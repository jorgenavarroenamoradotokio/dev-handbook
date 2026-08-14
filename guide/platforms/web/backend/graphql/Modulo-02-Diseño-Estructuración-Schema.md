> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. El schema](#1-el-schema)
- [2. Interfaces vs. Unions — el error de modelado más común](#2-interfaces-vs-unions--el-error-de-modelado-más-común)
  - [Modelado de relaciones: evita el "Dios objeto"](#modelado-de-relaciones-evita-el-dios-objeto)
  - [Scalars personalizados](#scalars-personalizados)
- [3. Implementación: organización modular del schema](#3-implementación-organización-modular-del-schema)
  - [Nomenclatura consistente](#nomenclatura-consistente)
  - [Deprecación sin romper clientes](#deprecación-sin-romper-clientes)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. El schema

El schema **es** tu API. A diferencia de REST, donde el contrato vive disperso entre documentación (a menudo desactualizada) y el código real de cada endpoint, en GraphQL el schema es ejecutable: si dice la verdad, el cliente puede confiar en él ciegamente vía introspección.

**El problema de negocio que resuelve un buen diseño de schema:** cada decisión de modelado que tomas hoy (¿esto es una interface o una union? ¿este campo es nullable?) se vuelve un compromiso de compatibilidad con clientes que quizá no controlas (apps móviles en producción que no puedes forzar a actualizar). Un schema mal diseñado no se "arregla" fácil — se deprecia lentamente durante años.

**Analogía:** diseñar un schema es como diseñar los planos de un edificio, no como decorar una habitación. Puedes repintar paredes (lógica de resolvers) sin problema. Pero mover una columna estructural (cambiar el tipo de un campo, o romper un contrato `!`) después de que el edificio tiene inquilinos (clientes en producción) es carísimo o directamente rompe cosas.

---

## 2. Interfaces vs. Unions — el error de modelado más común

Ambos permiten que un campo devuelva "más de un tipo posible", pero resuelven problemas distintos:

| | **Interface** | **Union** |
|---|---|---|
| Requiere campos comunes | Sí — todos los tipos implementan el mismo contrato | No — los tipos pueden no compartir nada |
| Caso de uso típico | Polimorfismo real: `Vehicle` → `Car`, `Truck` (ambos tienen `speed`, `wheels`) | Resultados heterogéneos: búsqueda que devuelve `User \| Post \| Comment` |
| Query del cliente | Puede pedir campos comunes sin `... on` | Siempre requiere fragmentos `... on Tipo` |

```graphql
# Interface: hay contrato compartido real
interface Content {
  id: ID!
  createdAt: String!
}
type Article implements Content { id: ID!, createdAt: String!, body: String! }
type Video implements Content { id: ID!, createdAt: String!, durationSeconds: Int! }

# Union: no hay nada en común, solo coexisten como posible resultado
union SearchResult = User | Post | Comment

type Query {
  search(term: String!): [SearchResult!]!
}
```

> ❌ **MAL:** usar `Union` cuando los tipos sí comparten campos reales — obligas al cliente a repetir fragmentos `... on X { id }` en cada rama, solo para pedir un `id`.
> ✅ **BIEN:** si hay contrato compartido, usa `Interface`. Reserva `Union` para resultados genuinamente heterogéneos (como resultados de búsqueda global).

### Modelado de relaciones: evita el "Dios objeto"

> ❌ **MAL**
> ```graphql
> type Query {
>   getEverything(userId: ID!): User
> }
> type User {
>   id: ID!
>   name: String!
>   posts: [Post!]!
>   comments: [Comment!]!
>   followers: [User!]!
>   following: [User!]!
>   notifications: [Notification!]!
>   settings: Settings!
>   billingHistory: [Invoice!]!   # dato sensible mezclado con dato público
> }
> ```
> Un solo tipo `User` que actúa como fachada de todo el dominio. Cualquier query a `User` puede, sin quererlo, forzar joins costosos (`billingHistory` no debería resolverse en el 95% de las queries que solo piden `name`).

> ✅ **BIEN**
> ```graphql
> type Query {
>   user(id: ID!): User
> }
> type User {
>   id: ID!
>   name: String!
>   posts(first: Int = 10, after: String): PostConnection!
> }
> # Datos sensibles/costosos van en una query separada con su propia autorización
> type Query {
>   billingHistory(userId: ID!): [Invoice!]! @auth(requires: SELF_OR_ADMIN)
> }
> ```
> Separar por *costo* y *sensibilidad de acceso*, no solo por relación conceptual. Ver Módulo 04 para el patrón `@auth`.

### Scalars personalizados

Los scalars built-in (`String`, `Int`, `Float`, `Boolean`, `ID`) no validan semántica de negocio. Un `String` acepta `"no-soy-un-email"` igual que `"real@dominio.com"`.

```typescript
// src/scalars/dateTime.ts
import { GraphQLScalarType, Kind } from 'graphql';

export const DateTimeScalar = new GraphQLScalarType({
  name: 'DateTime',
  description: 'Fecha/hora en formato ISO 8601 (UTC)',
  serialize(value) {
    if (!(value instanceof Date)) throw new TypeError('DateTime debe ser un objeto Date');
    return value.toISOString();
  },
  parseValue(value) {
    if (typeof value !== 'string') throw new TypeError('DateTime debe ser un string ISO');
    const date = new Date(value);
    if (isNaN(date.getTime())) throw new TypeError(`"${value}" no es una fecha ISO válida`);
    return date;
  },
  parseLiteral(ast) {
    if (ast.kind !== Kind.STRING) throw new TypeError('DateTime debe expresarse como string');
    return new Date(ast.value);
  },
});
```

```graphql
scalar DateTime

type Post {
  publishedAt: DateTime!
}
```

**Por qué importa:** con esto, un cliente que envíe `publishedAt: "ayer"` recibe un error de validación **antes** de que tu resolver o tu base de datos vean el dato. Es validación gratis en la capa de transporte.

---

## 3. Implementación: organización modular del schema

Un schema de 2000 líneas en un solo archivo es inmantenible. El patrón estándar de producción usa `@graphql-tools/schema` para fusionar módulos:

```bash
npm install @graphql-tools/schema@10.1.0
```

```
src/
├── modules/
│   ├── user/
│   │   ├── user.typedefs.ts
│   │   └── user.resolvers.ts
│   ├── post/
│   │   ├── post.typedefs.ts
│   │   └── post.resolvers.ts
│   └── shared/
│       └── scalars.typedefs.ts
└── schema.ts   # ensambla todo
```

```typescript
// src/modules/user/user.typedefs.ts
export const userTypeDefs = `#graphql
  type User {
    id: ID!
    name: String!
    posts: [Post!]!   # referencia a un tipo definido en otro módulo — es válido
  }
  extend type Query {
    user(id: ID!): User
  }
`;
```

```typescript
// src/schema.ts
import { mergeTypeDefs, mergeResolvers } from '@graphql-tools/schema';
import { userTypeDefs } from './modules/user/user.typedefs.js';
import { userResolvers } from './modules/user/user.resolvers.js';
import { postTypeDefs } from './modules/post/post.typedefs.js';
import { postResolvers } from './modules/post/post.resolvers.js';

const rootTypeDefs = `#graphql
  type Query
  type Mutation
`;

export const typeDefs = mergeTypeDefs([rootTypeDefs, userTypeDefs, postTypeDefs]);
export const resolvers = mergeResolvers([userResolvers, postResolvers]);
```

**Regla de modularización:** cada módulo declara su propio tipo con `extend type Query` / `extend type Mutation` en lugar de pelear por un único archivo gigante con todos los root types. Esto es exactamente el mismo criterio de tu convención de repo: cuando un dominio tiene entidad propia y crece de forma independiente, se separa en su propio módulo.

### Nomenclatura consistente

> ❌ **MAL:** mezclar convenciones — `fetchUser`, `get_post`, `addComment`, `Comment_Create`.
> ✅ **BIEN:** verbo + entidad en camelCase consistente — `user`, `posts`, `createPost`, `updatePost`, `deletePost`. Las mutations siempre en imperativo (`createX`, no `xCreation`).

### Deprecación sin romper clientes

```graphql
type User {
  name: String! @deprecated(reason: "Usa 'fullName'. Se elimina en Q1 2027.")
  fullName: String!
}
```

El campo antiguo sigue funcionando — los clientes que aún no migraron no se rompen. Herramientas como GraphQL Inspector (ver Módulo 05) pueden fallar tu CI si alguien intenta introducir un breaking change sin pasar primero por deprecación.

---

## 4. Errores Comunes y Buenas Prácticas

| Problema en producción | Causa raíz | Solución |
|---|---|---|
| Queries que tardan segundos en responder | Campo `!` obliga a resolver relaciones costosas siempre, aunque el cliente no las pida directamente vía lógica interna acoplada | Modela relaciones como campos independientes resueltos solo bajo demanda (ver 2.2) |
| Cliente móvil roto tras un deploy | Se cambió el tipo de un campo (`String` → `Int`) sin período de deprecación | Nunca cambies el tipo de un campo existente; añade uno nuevo y deprecia el viejo |
| Imposible saber qué mutations son "seguras" de llamar en paralelo | No hay convención de nombres ni de idempotencia documentada | Documenta con `description` en el SDL si una mutation es idempotente |
| Schema con 40 campos opcionales sin ningún significado documentado | Falta de `"""docstrings"""` en SDL | La introspección solo es útil si documentas — cada campo público debe llevar descripción |
