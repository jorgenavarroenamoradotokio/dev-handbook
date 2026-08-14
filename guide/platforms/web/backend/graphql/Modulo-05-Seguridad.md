> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1.  Las cuatro capas de defensa (no son alternativas, son complementarias)](#1--las-cuatro-capas-de-defensa-no-son-alternativas-son-complementarias)
- [2. Implementación paso a paso](#2-implementación-paso-a-paso)
  - [Depth limiting](#depth-limiting)
  - [Query complexity analysis — el control más importante](#query-complexity-analysis--el-control-más-importante)
  - [Automatic Persisted Queries (APQ)](#automatic-persisted-queries-apq)
  - [Rate limiting a nivel de transporte](#rate-limiting-a-nivel-de-transporte)
  - [Caching en servidor con Redis](#caching-en-servidor-con-redis)
  - [Paginación: offset vs. cursor](#paginación-offset-vs-cursor)
- [3. Errores Comunes y Buenas Prácticas](#3-errores-comunes-y-buenas-prácticas)
  - [Monitoreo con Apollo Studio / GraphQL Inspector](#monitoreo-con-apollo-studio--graphql-inspector)
  
---

## 1.  Las cuatro capas de defensa (no son alternativas, son complementarias)

| Capa | Qué limita | Cuándo actúa |
|---|---|---|
| **Depth limiting** | Profundidad de anidación de la query | Antes de ejecutar, en validación |
| **Query complexity analysis** | "Costo" total estimado (campos × multiplicadores de listas) | Antes de ejecutar, en validación |
| **Rate limiting** | Número de requests por cliente/IP en el tiempo | A nivel de transporte HTTP |
| **Persisted queries (APQ)** | Qué queries están permitidas en absoluto | Antes de parsear siquiera |

Ninguna de estas por sí sola es suficiente. Depth limiting no detecta una query ancha-pero-plana con 500 campos en el mismo nivel; complexity analysis sí. Rate limiting no evita que una sola request maliciosa cause daño; las otras tres sí.

---

## 2. Implementación paso a paso

### Depth limiting

```bash
npm install graphql-depth-limit@1.1.0
```

```typescript
// src/index.ts
import depthLimit from 'graphql-depth-limit';

const server = new ApolloServer({
  schema: schemaWithAuth,
  validationRules: [depthLimit(7)],  // 7 niveles suele cubrir casos reales legítimos
});
```

> ❌ **MAL:** no establecer límite alguno, confiando en que "los clientes no van a escribir queries así de raras". Cualquier cliente de tu API pública (o un atacante con `curl`) puede escribir la query que quiera.
>
> ✅ **BIEN:** límite explícito basado en la profundidad máxima real que tus queries legítimas necesitan (mide con logging antes de fijar el número).

### Query complexity analysis — el control más importante

Depth limiting no detecta esto:

```graphql
query Ancho {
  users(first: 1000) {   # lista grande
    posts(first: 1000) { # cada uno con lista grande
      comments(first: 1000) { id }  # y cada uno con otra lista grande
    }
  }
}
```

Solo 3 niveles de profundidad, pero **1000 × 1000 × 1000 = mil millones** de resoluciones potenciales.

```bash
npm install graphql-query-complexity@2.0.0
```

```typescript
// src/security/complexity.ts
import { createComplexityLimitRule } from 'graphql-query-complexity';

export const complexityRule = createComplexityLimitRule(1000, {
  scalarCost: 1,
  objectCost: 2,
  listFactor: 10,  // cada campo dentro de una lista multiplica su costo por este factor
  onCost: (cost) => console.log('Costo estimado de la query:', cost),
});
```

```typescript
const server = new ApolloServer({
  schema: schemaWithAuth,
  validationRules: [depthLimit(7), complexityRule],
});
```

> ✅ **BIEN — refinamiento adicional:** define el costo por campo directamente en el schema para campos que sabes que son caros (ej. un campo que hace una llamada a un servicio externo lento):
> ```graphql
> type Query {
>   expensiveReport: Report! @cost(complexity: 500)
> }
> ```

### Automatic Persisted Queries (APQ)

En vez de que el cliente envíe el string completo de la query en cada request (payload grande, y cualquier query arbitraria es aceptada), APQ funciona así:

1. El cliente envía un hash SHA-256 de la query.
2. Si el servidor ya la conoce (caché), la ejecuta directamente — payload mínimo.
3. Si no la conoce, el cliente envía la query completa una vez; el servidor la cachea contra su hash.
4. **En producción, puedes deshabilitar queries no registradas** — solo se ejecutan las que ya pasaron por este proceso, eliminando la superficie de "cualquier query arbitraria".

```typescript
import { ApolloServerPluginCacheControl } from '@apollo/server/plugin/cacheControl';
import responseCachePlugin from '@apollo/server-plugin-response-cache';

const server = new ApolloServer({
  schema: schemaWithAuth,
  plugins: [
    ApolloServerPluginCacheControl({ defaultMaxAge: 0 }),
    responseCachePlugin(),
  ],
  persistedQueries: {
    // en Apollo Server 5, el cache de APQ es configurable (InMemoryLRUCache por defecto,
    // Redis recomendado en multi-instancia — ver 3.5)
  },
});
```

> 🚨 Este es el control que **reemplaza de forma más elegante** apagar la introspección a secas (Módulo 01, sección 4.2): en vez de ocultar el schema, controlas exactamente qué operaciones son ejecutables, sin importar si alguien conoce la forma del schema o no.

### Rate limiting a nivel de transporte

```bash
npm install express-rate-limit@8.6.2
```

```typescript
import rateLimit from 'express-rate-limit';

app.use(
  '/graphql',
  rateLimit({
    windowMs: 60_000,
    max: 100,               // 100 requests/minuto por IP — ajusta a tu tráfico real
    standardHeaders: true,
    message: { errors: [{ message: 'Demasiadas solicitudes, intenta más tarde' }] },
  }),
);
```

> **Limitación importante:** rate limiting por IP no distingue entre una query barata (`{ id }`) y una carísima — por eso nunca sustituye a complexity analysis, solo lo complementa.

### Caching en servidor con Redis

```typescript
import { KeyvAdapter } from '@apollo/utils.keyvadapter';
import Keyv from 'keyv';
import KeyvRedis from '@keyv/redis';

const server = new ApolloServer({
  schema: schemaWithAuth,
  cache: new KeyvAdapter(new Keyv({ store: new KeyvRedis(process.env.REDIS_URL!) })),
});
```

```graphql
type Query {
  # Cachea 60s: dato que cambia poco, alto volumen de lectura idéntica
  trendingPosts: [Post!]! @cacheControl(maxAge: 60)
}
```

### Paginación: offset vs. cursor

| | Offset-based | Cursor-based |
|---|---|---|
| Sintaxis | `posts(skip: 20, limit: 10)` | `posts(first: 10, after: "cursor_xyz")` |
| Rendimiento en datasets grandes | Degrada — `OFFSET 100000` sigue escaneando 100k filas | Constante — el cursor apunta directo al punto de partida |
| Estable ante inserciones concurrentes | No — insertar una fila desplaza el offset de todo lo posterior | Sí — el cursor es inmune a inserciones antes de él |
| Complejidad de implementación | Baja | Media-alta (requiere codificar/decodificar cursores, típicamente base64 de `id` o `createdAt`) |

> ✅ **Regla práctica:** offset-based está bien para paneles de administración internos con datasets pequeños y estables. **Cursor-based (estilo Relay Connections) es el estándar de producción** para cualquier listado público de alto volumen.

```graphql
type PostConnection {
  edges: [PostEdge!]!
  pageInfo: PageInfo!
}
type PostEdge { node: Post!, cursor: String! }
type PageInfo { hasNextPage: Boolean!, endCursor: String }

type Query {
  posts(first: Int!, after: String): PostConnection!
}
```

---

## 3. Errores Comunes y Buenas Prácticas

| Problema | Causa | Solución |
|---|---|---|
| Servidor caído tras una sola request | Sin depth limit ni complexity analysis | Ambos controles activos en `validationRules`, no opcionales |
| Rate limiting bypaseado fácilmente | Límite solo por IP, atacante rota IPs | Combinar con límite por API key/usuario autenticado |
| Caché de Apollo sirve datos de un usuario a otro | `@cacheControl` en un campo que depende de `context.user` sin `scope: PRIVATE` | Usar `@cacheControl(maxAge: 60, scope: PRIVATE)` en campos personalizados por usuario |
| Monitoreo inexistente hasta que el incidente ya ocurrió | No hay tracing de costo de queries en producción | Loguear `onCost` de complexity analysis desde el día uno, no reactivamente |

### Monitoreo con Apollo Studio / GraphQL Inspector

- **Apollo Studio**: reporta tiempo de respuesta por operación, frecuencia de queries, y detecta *schema breaking changes* antes de deploy si integras el check en tu CI.
- **GraphQL Inspector**: corre en pipeline (`graphql-inspector diff old.graphql new.graphql`) para bloquear cambios incompatibles con clientes existentes — el enforcement automático de la deprecación del Módulo 02.