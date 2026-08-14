> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Resolver](#1-resolver)
- [2. La firma canónica del resolver](#2-la-firma-canónica-del-resolver)
  - [Por qué el N+1 es inevitable sin mitigación activa](#por-qué-el-n1-es-inevitable-sin-mitigación-activa)
- [3. Implementación: DataLoader paso a paso](#3-implementación-dataloader-paso-a-paso)
  - [El batch function — el corazón de DataLoader](#el-batch-function--el-corazón-de-dataloader)
  - [Conectar el loader al context (por request, no global)](#conectar-el-loader-al-context-por-request-no-global)
  - [Usar el loader en el resolver](#usar-el-loader-en-el-resolver)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  - [Encadenamiento de resolvers y composición](#encadenamiento-de-resolvers-y-composición)
  - [Manejo de errores en resolvers](#manejo-de-errores-en-resolvers)
  - [Diagnóstico rápido](#diagnóstico-rápido)
  
---

## 1. Resolver

Un resolver es una función pura (idealmente) con firma fija: `(parent, args, context, info) => valor`. El problema más caro en GraphQL de producción no es el diseño del schema — es que **cada campo con relación dispara su propio resolver, y por defecto, cada resolver puede disparar su propia consulta a base de datos.**

**El problema real:** pides 50 usuarios y, para cada uno, sus posts. Sin optimización: 1 query para los 50 usuarios + 50 queries individuales para los posts de cada uno = **51 queries** para una sola operación GraphQL. Esto se llama el **problema N+1**, y es la causa número uno de APIs GraphQL lentas en producción.

**Analogía:** imagina que pides al camarero (resolver) la cuenta de 50 mesas. En vez de pedir el reporte consolidado una vez, el camarero va mesa por mesa preguntando "¿cuánto gastaste?" — 50 viajes de ida y vuelta a la cocina en lugar de uno. **DataLoader** es darle al camarero una libreta: anota todas las preguntas pendientes, espera un instante, y hace **un solo viaje** con todas las mesas a la vez.

---

## 2. La firma canónica del resolver

```typescript
function resolver(
  parent,   // el resultado del resolver del campo padre (root para Query/Mutation)
  args,     // argumentos que el cliente pasó a este campo
  context,  // objeto compartido en TODA la ejecución de la request (auth, dataloaders, db)
  info,     // metadata de la ejecución (AST de la query, path, schema) — uso avanzado
) { /* ... */ }
```

| Argumento | Analogía |
|---|---|
| `parent` | Lo que ya trajo el cocinero anterior — tu resolver decide qué hacer con ese plato semi-preparado |
| `context` | La radio compartida de la cocina — todos los cocineros la escuchan durante ese servicio (esa request), pero se apaga al terminar |
| `info` | El ticket completo de la comanda — casi nunca lo necesitas, pero está ahí para casos avanzados (paginación dinámica, tracing) |

### Por qué el N+1 es inevitable sin mitigación activa

```graphql
query {
  users {        # 1 query: SELECT * FROM users
    name
    posts {       # ejecuta el resolver User.posts UNA VEZ POR CADA usuario devuelto
      title
    }
  }
}
```

```typescript
// ❌ MAL — dispara una query por cada usuario
const resolvers = {
  User: {
    posts: (parent) => db.query('SELECT * FROM posts WHERE author_id = ?', [parent.id]),
  },
};
```

Con 50 usuarios, esto son 50 queries idénticas en forma, distintas solo en el `id`. La base de datos no tiene forma de saber que "en 50ms más le van a pedir lo mismo para otro id" — cada resolver se ejecuta de forma aislada por diseño del motor GraphQL.

---

## 3. Implementación: DataLoader paso a paso

```bash
npm install dataloader@2.2.3
```

### El batch function — el corazón de DataLoader

```typescript
// src/loaders/postLoader.ts
import DataLoader from 'dataloader';
import type { PostRecord } from '../types.js';
import { db } from '../db.js';

export function createPostLoader() {
  return new DataLoader<string, PostRecord[]>(async (userIds) => {
    // DataLoader agrupa TODAS las llamadas .load(id) hechas en el mismo tick
    // y te las entrega como un array único — aquí haces UNA sola query.
    const allPosts = await db.query<PostRecord>(
      'SELECT * FROM posts WHERE author_id = ANY(?)',
      [userIds],
    );

    // CRÍTICO: debes devolver un array EN EL MISMO ORDEN que userIds.
    // Si no respetas el orden, DataLoader asigna resultados al usuario incorrecto.
    return userIds.map((id) => allPosts.filter((post) => post.authorId === id));
  });
}
```

> ❌ **MAL:** devolver los resultados en cualquier orden, o con longitud distinta a `userIds.length`. DataLoader **no** hace matching por contenido — asume posición 1:1 con el array de entrada. Esto genera bugs silenciosos donde un usuario ve los posts de otro.
>
> ✅ **BIEN:** siempre mapear explícitamente `keys.map(key => resultadoPara(key))`, incluso si el resultado es un array vacío.

### Conectar el loader al context (por request, no global)

```typescript
// src/index.ts (extiende el Módulo 01)
context: async ({ req }) => ({
  requestId: req.headers['x-request-id'] ?? crypto.randomUUID(),
  loaders: {
    postsByUser: createPostLoader(),
  },
}),
```

> 🚨 **Crítico:** el DataLoader se crea **una vez por request**, nunca como singleton global. DataLoader cachea resultados en memoria durante su ciclo de vida — si lo compartes entre requests, un usuario podría recibir datos cacheados que pertenecen a la sesión de otro usuario. Es un bug de seguridad, no solo de performance.

### Usar el loader en el resolver

```typescript
// ✅ BIEN — una sola query para N usuarios
const resolvers = {
  User: {
    posts: (parent, _args, context) => context.loaders.postsByUser.load(parent.id),
  },
};
```

Con esto, la misma query de 50 usuarios pasa de **51 queries a 2**: 1 para usuarios, 1 para todos los posts agrupados.

---

## 4. Errores Comunes y Buenas Prácticas

### Encadenamiento de resolvers y composición

Cuando la lógica de un resolver crece, extráela — el resolver debe ser un adaptador delgado hacia la capa de servicio, no contener lógica de negocio:

> ❌ **MAL**
> ```typescript
> createPost: async (_p, args, ctx) => {
>   if (!ctx.user) throw new Error('No auth');
>   if (args.title.length < 3) throw new Error('Título muy corto');
>   if (args.title.length > 200) throw new Error('Título muy largo');
>   const post = await db.insert('posts', { ...args, authorId: ctx.user.id });
>   await notifyFollowers(ctx.user.id, post.id);
>   await updateSearchIndex(post);
>   return post;
> }
> ```
> Todo el negocio vive dentro del resolver — imposible de testear sin levantar todo el servidor GraphQL.

> ✅ **BIEN**
> ```typescript
> createPost: (_p, args, ctx) => postService.create(args, ctx.user)
> ```
> `postService.create` es una función de dominio independiente, testeable con Jest sin tocar GraphQL en absoluto (ver Módulo 06).

### Manejo de errores en resolvers

> ❌ **MAL:** dejar que excepciones nativas de la base de datos lleguen al cliente (`error: relation "usres" does not exist` filtra tu esquema de BD).
>
> ✅ **BIEN:** capturar y traducir a errores de dominio con `GraphQLError`, incluyendo `extensions.code` para que el cliente pueda reaccionar programáticamente:

```typescript
import { GraphQLError } from 'graphql';

createPost: async (_p, args, ctx) => {
  try {
    return await postService.create(args, ctx.user);
  } catch (err) {
    if (err instanceof ValidationError) {
      throw new GraphQLError(err.message, {
        extensions: { code: 'BAD_USER_INPUT', field: err.field },
      });
    }
    // Nunca reenvíes el error crudo — lo logueas server-side, devuelves algo genérico
    console.error('createPost failed', { requestId: ctx.requestId, err });
    throw new GraphQLError('No se pudo crear la publicación', {
      extensions: { code: 'INTERNAL_ERROR' },
    });
  }
},
```

### Diagnóstico rápido

| Síntoma en producción | Causa probable | Verificación |
|---|---|---|
| Latencia crece linealmente con el tamaño de la lista | N+1 sin DataLoader | Loguea `queryCount` por request; debería ser constante, no proporcional |
| Un usuario ve datos de otro esporádicamente | DataLoader instanciado como singleton global | Verifica que el loader se crea dentro de `context: async ({req}) => ...` |
| Resultados de `posts` desordenados o vacíos para algunos usuarios | `batchFn` no respeta el orden de `keys` | Revisa el `.map(key => ...)` del batch function |
| Mensajes de error exponen nombres de tablas/columnas | Excepciones de BD sin traducir | Envolver todo acceso a datos con try/catch → `GraphQLError` |