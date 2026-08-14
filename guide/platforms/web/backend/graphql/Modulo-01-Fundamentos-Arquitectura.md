> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Introduccion](#1-introduccion)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Las tres piezas que nunca faltan](#las-tres-piezas-que-nunca-faltan)
  - [Los tres tipos de operación raíz](#los-tres-tipos-de-operación-raíz)
  - [El ciclo de vida de una consulta](#el-ciclo-de-vida-de-una-consulta)
- [3. Implementación Paso a Paso: Servidor funcional end-to-end](#3-implementación-paso-a-paso-servidor-funcional-end-to-end)
  - [Requisitos previos](#requisitos-previos)
  - [Inicialización del proyecto](#inicialización-del-proyecto)
  - [Definir el schema (`src/schema.ts`)](#definir-el-schema-srcschemats)
  - [Datos y resolvers (`src/resolvers.ts`)](#datos-y-resolvers-srcresolversts)
  - [Levantar el servidor (`src/index.ts`)](#levantar-el-servidor-srcindexts)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  - [Null bubbling — el error que rompe respuestas enteras](#null-bubbling--el-error-que-rompe-respuestas-enteras)
  - [Introspección expuesta en producción](#introspección-expuesta-en-producción)
  - [Confundir GraphQL con "no necesito diseñar mi API"](#confundir-graphql-con-no-necesito-diseñar-mi-api)
  
---

## 1. Introduccion

**GraphQL** es un lenguaje de consulta para APIs y un runtime que resuelve esas consultas contra un schema fuertemente tipado que tú defines. No es una base de datos, ni un framework, ni un reemplazo obligatorio de REST: es una capa de contrato entre cliente y servidor.

**El problema real que resuelve:** en REST, la forma de la respuesta la decide el servidor. Si el endpoint `/users/:id` devuelve 15 campos y tu app móvil solo necesita 2, pagas el costo de red y parseo de los 15 (*overfetching*). Si necesitas datos de dos recursos relacionados, hits múltiples endpoints (*underfetching* → cascada de requests). GraphQL invierte el control: **el cliente decide la forma de la respuesta**, el servidor solo garantiza que existan los datos.

**Analogía:** REST es como pedir en un restaurante de menú fijo — cada plato (endpoint) viene con guarniciones predefinidas, y si quieres solo la proteína sin el arroz, igual te lo traen. GraphQL es un buffet con carta: pides exactamente lo que vas a comer, ni un ingrediente de más. El coste operativo del "buffet" (el servidor) es más alto de construir bien, pero el comensal (el cliente) nunca paga por lo que no pidió.

**Un matiz que casi nadie explica:** GraphQL no es "más rápido" que REST por naturaleza. Con una sola query mal diseñada puedes generar cientos de golpes a base de datos (problema N+1, ver Módulo 03) o tumbar tu servidor con una query anidada maliciosa (ver Módulo 05). GraphQL da flexibilidad al cliente; a cambio, exige al backend disciplina que REST no exige.

---

## 2. Arquitectura y Componentes

### Las tres piezas que nunca faltan

| Componente | Qué hace | Analogía |
|---|---|---|
| **Schema** (SDL) | Contrato tipado: qué tipos, campos y operaciones existen | El menú del buffet: lista todo lo disponible, no cómo se cocina |
| **Resolvers** | Funciones que obtienen el dato real para cada campo | Los cocineros: cada uno sabe preparar *su* plato, no todo el menú |
| **Runtime de ejecución** | Motor que recibe la query, la valida contra el schema y ejecuta los resolvers en el orden correcto | El jefe de cocina: coordina qué cocinero prepara qué, en qué orden |

### Los tres tipos de operación raíz

```graphql
type Query {
  # Lecturas — análogo a GET
  user(id: ID!): User
}

type Mutation {
  # Escrituras — análogo a POST/PUT/PATCH/DELETE
  createUser(input: CreateUserInput!): User!
}

type Subscription {
  # Tiempo real — mantiene conexión abierta (WebSocket, normalmente vía graphql-ws)
  userCreated: User!
}
```

**Diferencia crítica que la mayoría pasa por alto:** `Query` y `Mutation` se ejecutan sobre HTTP tradicional request/response. `Subscription` requiere un transporte con estado (WebSocket vía `graphql-ws`, o alternativas como Server-Sent Events). Añadir subscriptions no es "marcar una casilla" — es añadir infraestructura con estado a un sistema que hasta ese momento era stateless.

### El ciclo de vida de una consulta

```
Cliente envía query (string GraphQL)
        │
        ▼
1. PARSING     → ¿Es sintaxis GraphQL válida?
        │
        ▼
2. VALIDATION  → ¿Los campos/tipos existen en el schema? ¿Los argumentos son correctos?
        │
        ▼
3. EXECUTION   → Se ejecutan los resolvers, campo por campo, respetando la forma del árbol pedido
        │
        ▼
4. RESPONSE    → JSON con { data, errors } — ambos pueden coexistir (respuesta parcial)
```

**Punto que sorprende a quien viene de REST:** una respuesta GraphQL puede tener `data` con algunos campos en `null` **y** `errors` en la misma respuesta con código HTTP `200`. GraphQL no usa el código de estado HTTP para señalar errores de negocio — solo para errores de transporte (servidor caído, malformación del request). Esto rompe la intuición REST de "4xx/5xx = algo falló".

---

## 3. Implementación Paso a Paso: Servidor funcional end-to-end

### Requisitos previos

- Node.js 22 LTS
- Conocimiento básico de JavaScript/TypeScript asíncrono
- Un editor con soporte de extensión `.graphql` (recomendado: VS Code + extensión GraphQL oficial)

### Inicialización del proyecto

```bash
mkdir graphql-server-demo && cd graphql-server-demo
npm init -y
npm install @apollo/server@5.5.1 @as-integrations/express5@1.1.2 express@5.2.1 graphql@17.0.2 cors dotenv
npm install -D typescript @types/express @types/node @types/cors tsx
npx tsc --init --rootDir src --outDir dist --module nodenext --target es2022 --esModuleInterop
```

> ❌ **MAL:** `npm install apollo-server-express` → paquete EOL, no recibe parches de seguridad desde octubre de 2024.
> ✅ **BIEN:** `npm install @apollo/server @as-integrations/express5` → paquete activo, mantenido y con soporte para Express 5.

### Definir el schema (`src/schema.ts`)

```typescript
// src/schema.ts
export const typeDefs = `#graphql
  type User {
    id: ID!
    name: String!
    email: String!
    posts: [Post!]!
  }

  type Post {
    id: ID!
    title: String!
    content: String
    author: User!
  }

  type Query {
    """Devuelve un usuario por su ID. Null si no existe."""
    user(id: ID!): User
    users: [User!]!
  }

  type Mutation {
    createUser(name: String!, email: String!): User!
  }
`;
```

**Nota sobre el `!`:** en GraphQL, `!` significa "este campo NUNCA será null si la operación tiene éxito". Es una promesa contractual. Si tu resolver puede fallar en obtener el dato, el campo **no debe** llevar `!` — de lo contrario, un error interno en ese campo destruye toda la respuesta (ver "Null bubbling" en Troubleshooting).

### Datos y resolvers (`src/resolvers.ts`)

```typescript
// src/resolvers.ts
// Simulación de "base de datos" en memoria — en producción, esto llama a tu ORM/driver real.
interface UserRecord { id: string; name: string; email: string }
interface PostRecord { id: string; title: string; content: string; authorId: string }

const users: UserRecord[] = [
  { id: '1', name: 'Ana García', email: 'ana@example.com' },
];
const posts: PostRecord[] = [
  { id: '1', title: 'GraphQL en producción', content: '...', authorId: '1' },
];

export const resolvers = {
  Query: {
    // parent, args, context, info — la firma canónica de TODO resolver
    user: (_parent: unknown, args: { id: string }) =>
      users.find((u) => u.id === args.id) ?? null,
    users: () => users,
  },
  Mutation: {
    createUser: (_parent: unknown, args: { name: string; email: string }) => {
      const newUser: UserRecord = { id: String(users.length + 1), ...args };
      users.push(newUser);
      return newUser;
    },
  },
  // Resolver de campo: se ejecuta SOLO cuando el cliente pide "posts" dentro de un User
  User: {
    posts: (parent: UserRecord) => posts.filter((p) => p.authorId === parent.id),
  },
  Post: {
    author: (parent: PostRecord) => users.find((u) => u.id === parent.authorId),
  },
};
```

**Por qué esto importa:** `User.posts` solo se ejecuta si el cliente lo pidió explícitamente en la query. Esa es la base física del "no overfetching" — no es magia, es que el motor de ejecución solo recorre el árbol de campos solicitado.

### Levantar el servidor (`src/index.ts`)

```typescript
// src/index.ts
import express from 'express';
import cors from 'cors';
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@as-integrations/express5';
import { typeDefs } from './schema.js';
import { resolvers } from './resolvers.js';

const app = express();

const server = new ApolloServer({
  typeDefs,
  resolvers,
  // Introspección: OFF en producción por defecto a partir de Apollo Server 4+.
  // Actívala explícitamente solo si tu API es pública y documentada a propósito.
  introspection: process.env.NODE_ENV !== 'production',
});

await server.start();

app.use(
  '/graphql',
  cors<cors.CorsRequest>({ origin: process.env.ALLOWED_ORIGIN ?? 'http://localhost:5173' }),
  express.json({ limit: '1mb' }), // límite explícito: evita payloads de escritura desmedidos
  expressMiddleware(server, {
    context: async ({ req }) => ({
      // Aquí inyectarás el usuario autenticado en el Módulo 04
      requestId: req.headers['x-request-id'] ?? crypto.randomUUID(),
    }),
  }),
);

const PORT = process.env.PORT ?? 4000;
app.listen(PORT, () => {
  console.log(`🚀 GraphQL server listo en http://localhost:${PORT}/graphql`);
});
```

```bash
npx tsx src/index.ts
```

**Verificación:** abre `http://localhost:4000/graphql` con un cliente como Apollo Sandbox (o `curl`) y ejecuta:

```graphql
query {
  users {
    id
    name
    posts {
      title
    }
  }
}
```

Si obtienes JSON con `data.users[0].posts`, el servidor funciona de punta a punta.

---

## 4. Errores Comunes y Buenas Prácticas

### Null bubbling — el error que rompe respuestas enteras

```graphql
type Query {
  user(id: ID!): User!   # ❌ Non-nullable en una query que puede fallar
}
```

Si el resolver de `user` lanza una excepción o el registro no existe, GraphQL debe cumplir el contrato `!`. Como no puede, **la nulabilidad se propaga hacia arriba** hasta encontrar un campo nullable — en el peor caso, toda la respuesta `data` se vuelve `null`, aunque el error afectara a un solo campo.

> ❌ **MAL:** marcar como no-nulos campos que dependen de un recurso externo, una consulta a BD que puede fallar, o una relación opcional.
> ✅ **BIEN:** el `!` se reserva para garantías que tu código *realmente* puede sostener (IDs generados, campos calculados sin dependencias externas). Todo lo demás, nullable — y documenta *por qué* puede ser null.

### Introspección expuesta en producción

La introspección permite a cualquiera consultar tu schema completo (`{ __schema { types { name } } }`), revelando toda tu superficie de API, incluidos campos y mutaciones que no querías publicitar.

> ❌ **MAL:** dejar `introspection: true` (o el valor por defecto de versiones antiguas) en producción sin evaluarlo.
> ✅ **BIEN:** `introspection: false` en producción salvo que tu API sea deliberadamente pública y documentada (ver Módulo 05 para alternativas como *persisted queries*, que resuelven este problema de forma más elegante que apagar introspección a secas).

### Confundir GraphQL con "no necesito diseñar mi API"

Es el error conceptual más caro. Un schema mal modelado (tipos genéricos tipo `AnyData`, resolvers con lógica de negocio embebida, ausencia de paginación) es **peor** que un REST bien diseñado, porque además hereda los riesgos de performance de las queries arbitrarias del cliente. GraphQL exige tanto o más diseño previo que REST — ver Módulo 02.
