> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Que es un cliente](#1-que-es-un-cliente)
- [2.Apollo Client vs. Relay vs. urql](#2apollo-client-vs-relay-vs-urql)
  - [Normalización de caché — cómo funciona bajo el capó](#normalización-de-caché--cómo-funciona-bajo-el-capó)
- [3. 🛠️ Implementación paso a paso](#3-️-implementación-paso-a-paso)
  - [Setup de Apollo Client](#setup-de-apollo-client)
  - [Fragmentos reutilizables — evita duplicar selecciones de campos](#fragmentos-reutilizables--evita-duplicar-selecciones-de-campos)
  - [Fetch policies — cuándo usar cada una](#fetch-policies--cuándo-usar-cada-una)
  - [GraphQL Code Generator — type-safety end-to-end](#graphql-code-generator--type-safety-end-to-end)
  - [Estado optimista](#estado-optimista)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Que es un cliente

Un cliente GraphQL no es "un fetch con un string distinto". Su valor real está en la **gestión de caché normalizada**: cuando actualizas un `Post` en cualquier parte de tu app, todas las vistas que muestran ese mismo `Post` se actualizan automáticamente, sin que tú escribas lógica manual de invalidación.

**Analogía:** un `fetch()` crudo es como fotocopiar un documento cada vez que lo necesitas — cada copia vive aislada, y si el original cambia, tus copias quedan desactualizadas hasta que fotocopies de nuevo. Un cliente GraphQL con caché normalizada es como tener un documento compartido en la nube: todos los que lo tienen abierto ven la misma versión actualizada al instante, porque todos apuntan al mismo objeto, no a una copia.

---

## 2.Apollo Client vs. Relay vs. urql

| | Apollo Client | Relay | urql |
|---|---|---|---|
| Curva de aprendizaje | Media | Alta (requiere convenciones estrictas de fragmentos) | Baja |
| Tamaño del bundle | Mayor | Medio | Menor |
| Normalización de caché | Automática por `id`/`__typename` | Automática, más estricta (requiere `id` en todo tipo) | Configurable (Graphcache como extensión opcional) |
| Cuándo elegirlo | Equipos que priorizan ecosistema maduro y DX | Apps a gran escala con disciplina de ingeniería fuerte (Meta-style) | Apps que priorizan bundle pequeño y simplicidad |

> **No hay "el mejor" objetivamente.** Es una decisión de trade-offs de equipo, no de tecnología superior. Elegir Relay para un equipo pequeño sin experiencia previa suele generar más fricción que valor.

### Normalización de caché — cómo funciona bajo el capó

```graphql
query {
  post(id: "42") { id title author { id name } }
}
```

Apollo Client no guarda esta respuesta como un blob JSON. La descompone:

```
Post:42     → { id: '42', title: '...', author: { __ref: 'User:7' } }
User:7      → { id: '7', name: 'Ana García' }
```

Si en otra parte de tu app ejecutas una mutation que actualiza `User:7.name`, **toda query que referencia a ese usuario se re-renderiza automáticamente** — sin refetch, sin lógica manual. Esto solo funciona si cada tipo expone un campo `id` (Apollo Client) — es la razón por la que tu schema (Módulo 02) siempre debería exponer `id: ID!` en tipos con identidad propia.

---

## 3. 🛠️ Implementación paso a paso

### Setup de Apollo Client

```bash
npm install @apollo/client@4.2.12 graphql
```

```typescript
// src/apollo/client.ts
import { ApolloClient, InMemoryCache, HttpLink, from } from '@apollo/client';
import { onError } from '@apollo/client/link/error';
import { setContext } from '@apollo/client/link/context';

const httpLink = new HttpLink({ uri: '/graphql' });

const authLink = setContext((_, { headers }) => {
  const token = localStorage.getItem('token');
  return { headers: { ...headers, authorization: token ? `Bearer ${token}` : '' } };
});

const errorLink = onError(({ graphQLErrors, networkError }) => {
  graphQLErrors?.forEach(({ message, extensions }) => {
    if (extensions?.code === 'UNAUTHENTICATED') {
      // redirige a login, limpia token, etc. — NO reintentar silenciosamente
      window.location.href = '/login';
    }
    console.error(`[GraphQL error]: ${message}`);
  });
  if (networkError) console.error(`[Network error]: ${networkError}`);
});

export const client = new ApolloClient({
  link: from([errorLink, authLink, httpLink]),
  cache: new InMemoryCache({
    typePolicies: {
      Query: {
        fields: {
          posts: { keyArgs: false, merge: (existing = { edges: [] }, incoming) => incoming },
        },
      },
    },
  }),
});
```

### Fragmentos reutilizables — evita duplicar selecciones de campos

> ❌ **MAL**
> ```graphql
> query GetPost { post(id: "1") { id title content author { id name } } }
> query GetFeed { posts { id title content author { id name } } }
> ```
> El mismo bloque `author { id name }` repetido — si mañana añades `author.avatarUrl`, tienes que tocar N queries.

> ✅ **BIEN**
> ```graphql
> fragment PostSummary on Post {
>   id
>   title
>   content
>   author { id name }
> }
> query GetPost { post(id: "1") { ...PostSummary } }
> query GetFeed { posts { ...PostSummary } }
> ```
> Un único punto de cambio. Además, colocalizar fragmentos junto al componente que los usa (patrón "fragment colocation") hace que cada componente declare exactamente los datos que necesita — la disciplina de Relay, adoptable también en Apollo.

### Fetch policies — cuándo usar cada una

```typescript
const { data } = useQuery(GET_POST, {
  fetchPolicy: 'cache-and-network', // ver tabla abajo
});
```

| Policy | Comportamiento | Caso de uso |
|---|---|---|
| `cache-first` (default) | Usa caché si existe; red solo si falta | Datos que cambian poco (perfil de usuario, config) |
| `network-only` | Siempre va a red, pero actualiza caché | Datos que deben estar frescos siempre (dashboard financiero) |
| `cache-and-network` | Devuelve caché al instante, dispara red en paralelo y actualiza | Mejor UX percibida: respuesta inmediata + frescura eventual |
| `no-cache` | Nunca lee ni escribe caché | Datos sensibles que no deben persistir en memoria del cliente (ej. números de tarjeta) |

> ❌ **MAL:** usar `no-cache` por defecto "para estar seguro" — pierdes toda la ventaja de normalización y generas requests redundantes.
>
> ✅ **BIEN:** `cache-first` como default global, overrides puntuales por query según sensibilidad/frescura real.

### GraphQL Code Generator — type-safety end-to-end

```bash
npm install -D @graphql-codegen/cli@7.2.0
```

```yaml
# codegen.yml
schema: http://localhost:4000/graphql
documents: 'src/**/*.graphql'
generates:
  src/generated/graphql.ts:
    plugins:
      - typescript
      - typescript-operations
      - typescript-react-apollo
```

Con esto, cada query/mutation tipada genera hooks React (`useGetPostQuery`) con tipos exactos derivados del schema real — si el backend cambia un campo, el build del frontend falla en compilación, no en producción. Esta es la práctica que más previene bugs de integración cliente-servidor en equipos con backend y frontend desacoplados.

### Estado optimista

```typescript
const [createPost] = useMutation(CREATE_POST, {
  optimisticResponse: {
    createPost: {
      __typename: 'Post',
      id: 'temp-id',           // reemplazado cuando llega la respuesta real
      title: variables.title,
      content: variables.content,
    },
  },
  update(cache, { data }) {
    cache.modify({
      fields: {
        posts: (existing = []) => [...existing, data.createPost],
      },
    });
  },
});
```

La UI muestra el post creado **antes** de que el servidor confirme — mejora percepción de velocidad. Si la mutation falla, Apollo Client revierte automáticamente al estado anterior.

---

## 4. Errores Comunes y Buenas Prácticas

| Problema | Causa | Solución |
|---|---|---|
| UI no se actualiza tras una mutation | El tipo devuelto no incluye `id`, Apollo no puede normalizarlo en caché | Toda mutation debe devolver al menos `id` y `__typename` del recurso afectado |
| Fallback UI genérico sin contexto | Manejo de errores no distingue `extensions.code` | Diferenciar `UNAUTHENTICATED` (redirect login) de `BAD_USER_INPUT` (mostrar mensaje inline) de `INTERNAL_ERROR` (mensaje genérico + retry) |
| Requests duplicados al montar múltiples componentes con la misma query | No se aprovecha deduplicación automática de Apollo (falla si usas `fetchPolicy: 'no-cache'` en todo) | Confiar en la deduplicación default; reservar `no-cache` para casos justificados |
| Bundle de frontend inflado | Importar todo `@apollo/client` en vez de imports específicos | Usar imports granulares (`@apollo/client/react`, `@apollo/client/link/error`) soportados desde v4 |