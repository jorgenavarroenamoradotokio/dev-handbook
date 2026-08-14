> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Federation vs. Schema Stitching](#1-federation-vs-schema-stitching)
  - [Cómo funciona Federation — el concepto de `@key`](#cómo-funciona-federation--el-concepto-de-key)
- [3. Implementación paso a paso](#3-implementación-paso-a-paso)
  - [Definir un subgraph](#definir-un-subgraph)
  - [El gateway](#el-gateway)
  - [Migración progresiva desde REST — el patrón "strangler fig"](#migración-progresiva-desde-rest--el-patrón-strangler-fig)
  - [Cuándo NO usar Federation](#cuándo-no-usar-federation)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Federation vs. Schema Stitching

| | **Apollo Federation** | **Schema Stitching** |
|---|---|---|
| Cómo se combinan los schemas | Declarativo — cada subgraph declara qué expone y qué "extiende" de otros | Imperativo — un gateway central escribe código para fusionar schemas |
| Ownership de tipos compartidos | Distribuido — cualquier subgraph puede extender un tipo con `@key` | Centralizado — la lógica de merge vive en el gateway |
| Curva de adopción | Media — requiere entender directivas de federación | Alta — la lógica de resolución cruzada se vuelve compleja rápido |
| Estado del ecosistema (2026) | Estándar de facto en producción a gran escala | Nicho — útil para integrar APIs GraphQL de terceros que no controlas |

> **Recomendación práctica:** para arquitecturas de microservicios propias, Federation es la opción por defecto hoy. Stitching tiene su nicho en integrar un GraphQL de terceros (ej. Shopify Storefront API) junto al tuyo, donde no controlas el subgraph externo.

### Cómo funciona Federation — el concepto de `@key`

```graphql
# Subgraph: Users
type User @key(fields: "id") {
  id: ID!
  name: String!
  email: String!
}
```

```graphql
# Subgraph: Posts — EXTIENDE User sin poseerlo
type User @key(fields: "id") {
  id: ID!
  posts: [Post!]!    # este subgraph añade este campo a un tipo que no le pertenece
}
type Post {
  id: ID!
  title: String!
  author: User!
}
```

El **gateway** combina ambos en un supergraph: cuando un cliente pide `user.posts`, el gateway sabe que debe pedir la identidad al subgraph Users y luego resolver `posts` contra el subgraph Posts, usando `id` como llave de unión — sin que el cliente sepa que hubo dos servicios involucrados.

---

## 3. Implementación paso a paso

### Definir un subgraph

```bash
npm install @apollo/subgraph@2.14.3 @apollo/server@5.5.1
```

```typescript
// posts-service/src/index.ts
import { ApolloServer } from '@apollo/server';
import { buildSubgraphSchema } from '@apollo/subgraph';
import { expressMiddleware } from '@as-integrations/express5';
import gql from 'graphql-tag';

const typeDefs = gql`
  type Post @key(fields: "id") {
    id: ID!
    title: String!
    author: User!
  }
  type User @key(fields: "id") {
    id: ID!
  }
  extend type Query {
    posts: [Post!]!
  }
`;

const resolvers = {
  Post: {
    author: (post) => ({ __typename: 'User', id: post.authorId }), // referencia, no el objeto completo
  },
  Query: {
    posts: () => postRepository.findAll(),
  },
};

const server = new ApolloServer({
  schema: buildSubgraphSchema({ typeDefs, resolvers }),
});
```

**Punto clave:** `Post.author` no devuelve un `User` completo — devuelve una **referencia** (`{ __typename, id }`). El gateway se encarga de ir al subgraph Users a completar el resto de los campos que el cliente haya pedido. Esto es lo que hace posible que cada equipo posea su propio dato sin duplicar lógica.

### El gateway

```bash
npm install @apollo/gateway@2.14.3
```

```typescript
// gateway/src/index.ts
import { ApolloServer } from '@apollo/server';
import { ApolloGateway, IntrospectAndCompose } from '@apollo/gateway';

const gateway = new ApolloGateway({
  supergraphSdl: new IntrospectAndCompose({
    subgraphs: [
      { name: 'users', url: 'http://users-service:4001/graphql' },
      { name: 'posts', url: 'http://posts-service:4002/graphql' },
    ],
  }),
});

const server = new ApolloServer({ gateway });
```

> ❌ **MAL en producción:** `IntrospectAndCompose` consulta los subgraphs en cada arranque del gateway para componer el schema — funciona en desarrollo, pero introduce latencia y un punto de fallo en despliegues.
>
> ✅ **BIEN en producción:** usar **Managed Federation** vía Apollo GraphOS (o un pipeline de CI que genere el supergraph SDL de forma estática y lo publique), evitando que el gateway dependa de que todos los subgraphs estén disponibles en el momento exacto de su propio arranque.

### Migración progresiva desde REST — el patrón "strangler fig"

No migras un sistema REST completo a GraphQL de un día para otro. El patrón probado:

```
Paso 1: Levanta un servidor GraphQL cuyos resolvers son WRAPPERS de tus endpoints REST existentes
Paso 2: Migra el tráfico del cliente, endpoint por endpoint, a las queries GraphQL
Paso 3: Una vez que un dominio ya no recibe tráfico REST directo, reemplaza el wrapper
        por acceso directo a la fuente de datos (BD, servicio interno)
Paso 4: Desactiva el endpoint REST original cuando ya no tiene consumidores
```

```typescript
// Paso 1: resolver que envuelve un endpoint REST heredado — NO es el estado final
const resolvers = {
  Query: {
    user: async (_p, { id }) => {
      const res = await fetch(`${LEGACY_API_URL}/users/${id}`);
      if (!res.ok) throw new GraphQLError('Usuario no encontrado');
      return res.json();
    },
  },
};
```

> ⚠️ **Riesgo real de este paso 1:** cada query GraphQL ahora depende de la disponibilidad y latencia del sistema REST heredado. No es la arquitectura final — es un puente deliberadamente temporal. Documenta explícitamente qué resolvers son wrappers transitorios para no confundir a un desarrollador nuevo que asuma que es la arquitectura definitiva.

### Cuándo NO usar Federation

> ❌ **MAL:** adoptar Federation porque "es lo que usan las empresas grandes", con un equipo de 3 desarrolladores y un solo dominio de negocio. La complejidad operativa (gateway, múltiples subgraphs, composición de supergraph) no se justifica sin múltiples equipos operando de forma verdaderamente independiente.
>
> ✅ **BIEN:** un monolito GraphQL modularizado (Módulo 02, sección 3) cubre el 90% de los casos. Migra a Federation cuando el dolor real de coordinación entre equipos — no la aspiración arquitectónica — lo justifique.

---

## 4. Errores Comunes y Buenas Prácticas

| Problema | Causa | Solución |
|---|---|---|
| Gateway cae si un subgraph está temporalmente caído | `IntrospectAndCompose` en producción sin composición estática | Managed Federation / supergraph SDL generado en CI, no en runtime |
| Dos subgraphs declaran el mismo campo de forma conflictiva | Falta de ownership claro por tipo compartido | Definir explícitamente qué subgraph es dueño de cada campo (`@shareable` solo cuando es intencional) |
| Latencia alta en queries que cruzan subgraphs | Cada salto entre subgraphs añade una llamada de red | Medir con tracing distribuido (OpenTelemetry) qué queries cruzan más subgraphs y evaluar si el modelado de dominio está bien distribuido |
| Wrapper REST-a-GraphQL nunca se retira | Falta de tracking de qué resolvers son deuda técnica temporal | Etiquetar explícitamente en código/documentación + fecha objetivo de retiro |