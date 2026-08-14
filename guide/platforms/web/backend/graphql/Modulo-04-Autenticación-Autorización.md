> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Autenticación y Autorización](#1-autenticación-y-autorización)
- [2. Dónde vive cada responsabilidad](#2-dónde-vive-cada-responsabilidad)
  - [JWT — verificación correcta](#jwt--verificación-correcta)
  - [Inyectar el usuario en el context](#inyectar-el-usuario-en-el-context)
- [3. Implementación: autorización por campo con graphql-shield](#3-implementación-autorización-por-campo-con-graphql-shield)
  - [OAuth 2.0 — cuándo usarlo y cómo se integra](#oauth-20--cuándo-usarlo-y-cómo-se-integra)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Autenticación y Autorización

**Autenticación** responde "¿quién eres?". **Autorización** responde "¿qué puedes hacer, ya sabiendo quién eres?". En REST, la autorización suele vivir en middleware por endpoint (`router.get('/admin', requireAdmin, handler)`). En GraphQL, **todos los endpoints son el mismo endpoint** (`/graphql`) — no puedes proteger por URL. La autorización tiene que vivir a nivel de *campo*, dentro del schema o de los resolvers.

**Analogía:** en un edificio con recepción única (GraphQL), no puedes poner un guardia distinto en cada puerta de la calle (como haces con endpoints REST). El control de acceso se mueve dentro del edificio: cada piso (tipo) y cada oficina (campo) tiene su propia cerradura, y la recepción solo verifica tu identidad al entrar (autenticación), no qué pisos puedes visitar.

---

## 2. Dónde vive cada responsabilidad


| Capa | Responsabilidad | Dónde se implementa |
|---|---|---|
| Transporte | Extraer y verificar el token de la request | Función `context` (se ejecuta una vez por request) |
| Autorización | Decidir si el usuario autenticado puede ejecutar ESTE campo | Middleware de campo (graphql-shield) o guard dentro del resolver |
| Datos | Filtrar qué *filas* puede ver (ej. solo sus propios posts) | Capa de servicio/repositorio, usando el usuario del context |

### JWT — verificación correcta

```typescript
// src/auth/verifyToken.ts
import jwt from 'jsonwebtoken';

interface TokenPayload { userId: string; role: 'USER' | 'ADMIN' }

export function verifyToken(authHeader: string | undefined): TokenPayload | null {
  if (!authHeader?.startsWith('Bearer ')) return null;
  const token = authHeader.slice(7);
  try {
    // El secreto NUNCA va hardcodeado — viene de variable de entorno
    return jwt.verify(token, process.env.JWT_SECRET!) as TokenPayload;
  } catch {
    // Token inválido/expirado → usuario anónimo, no lanzamos error aquí.
    // El error de "no autorizado" se decide en la capa de autorización, no aquí.
    return null;
  }
}
```

> ❌ **MAL**
> ```javascript
> const token = jwt.sign({ userId: 123 }, 'secret_key', { expiresIn: '1h' });
> ```
> Secreto hardcodeado en el código fuente. Si este repo es privado hoy y público mañana (o si alguien hace `git log` en un fork), el secreto queda expuesto permanentemente en el historial de Git. Además, `'secret_key'` es un valor trivialmente adivinable.

> ✅ **BIEN**
> ```javascript
> // .env (nunca comiteado — en .gitignore)
> JWT_SECRET=<valor generado con crypto.randomBytes(64).toString('hex')>
>
> // código
> const token = jwt.sign({ userId: user.id, role: user.role }, process.env.JWT_SECRET!, {
>   expiresIn: '15m',       // vida corta — usa refresh tokens para sesiones largas
>   issuer: 'mi-api',
>   algorithm: 'HS256',     // sé explícito con el algoritmo, no confíes en el default
> });
> ```

### Inyectar el usuario en el context

```typescript
// src/index.ts (extiende Módulo 01/03)
context: async ({ req }) => {
  const user = verifyToken(req.headers.authorization);
  return {
    user,                          // null si no autenticado — NO lanzar error aquí
    loaders: { postsByUser: createPostLoader() },
  };
},
```

**Por qué no lanzar error en `context` cuando no hay token:** muchas queries son públicas (ej. `posts` de blog público). Si fuerzas autenticación en el context global, matas el acceso anónimo legítimo. La decisión de "esto requiere login" es responsabilidad de la autorización por campo, no del transporte.

---

## 3. Implementación: autorización por campo con graphql-shield

```bash
npm install graphql-shield@7.6.5
```

```typescript
// src/auth/permissions.ts
import { rule, shield, and, allow, deny } from 'graphql-shield';
import type { GraphQLContext } from '../types.js';

const isAuthenticated = rule({ cache: 'contextual' })(
  async (_parent, _args, ctx: GraphQLContext) => ctx.user !== null,
);

const isAdmin = rule({ cache: 'contextual' })(
  async (_parent, _args, ctx: GraphQLContext) => ctx.user?.role === 'ADMIN',
);

// Regla que valida propiedad del recurso, no solo rol
const isOwner = rule({ cache: 'strict' })(
  async (parent, _args, ctx: GraphQLContext) => parent.authorId === ctx.user?.id,
);

export const permissions = shield(
  {
    Query: {
      users: isAdmin,           // listar todos los usuarios: solo admin
      user: allow,              // ver perfil individual: público
    },
    Mutation: {
      createPost: isAuthenticated,
      deletePost: and(isAuthenticated, isOwner),  // dueño Y logueado
      banUser: isAdmin,
    },
  },
  {
    fallbackRule: deny,          // 🔒 whitelist explícita: todo lo no listado se DENIEGA
    fallbackError: 'No autorizado',
  },
);
```

```typescript
// src/index.ts
import { applyMiddleware } from 'graphql-middleware';
import { permissions } from './auth/permissions.js';

const schemaWithAuth = applyMiddleware(schema, permissions);
const server = new ApolloServer({ schema: schemaWithAuth });
```

> 🚨 **Decisión de diseño no negociable:** `fallbackRule: deny`. Si mañana un desarrollador junior añade una mutation nueva y olvida declarar su regla de permisos, el default debe ser **bloquear**, no exponer. Con `fallbackRule: allow` (o sin declarar fallback), cada campo nuevo nace público por accidente — es la causa más común de fugas de datos en APIs GraphQL reales.

### OAuth 2.0 — cuándo usarlo y cómo se integra

OAuth resuelve un problema distinto a JWT propio: delegar la autenticación a un proveedor externo (Google, GitHub) para no gestionar contraseñas tú mismo.

```typescript
// src/auth/oauth.ts
import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
      callbackURL: '/auth/google/callback',
    },
    async (_accessToken, _refreshToken, profile, done) => {
      const user = await userService.findOrCreateByGoogleProfile(profile);
      // Tras OAuth, emites TU PROPIO JWT — no reenvíes el token de Google al cliente
      const appToken = jwt.sign({ userId: user.id, role: user.role }, process.env.JWT_SECRET!, {
        expiresIn: '15m',
      });
      done(null, { appToken });
    },
  ),
);
```

**Patrón clave:** OAuth vive **fuera** del flujo GraphQL (rutas Express normales `/auth/google`, `/auth/google/callback`). Al terminar el handshake, emites tu propio JWT de aplicación. El resolver de GraphQL nunca sabe ni le importa si el usuario entró con contraseña o con Google — solo ve un JWT válido en el header.

---

## 4. Errores Comunes y Buenas Prácticas

| Problema | Por qué ocurre | Corrección |
|---|---|---|
| Campo sensible accesible sin login | `fallbackRule: allow` o regla olvidada | Whitelist explícita + `fallbackRule: deny` |
| Usuario A borra posts de usuario B | Autorización solo verifica rol, no propiedad del recurso | Añadir regla `isOwner` comparando `parent.authorId` vs `ctx.user.id` |
| Error "jwt malformed" tumba el servidor | `jwt.verify` sin try/catch en el `context` | Envolver siempre en try/catch, devolver `user: null` en fallo |
| Token de sesión válido durante días tras logout | `expiresIn` demasiado largo, sin lista de revocación | Tokens de acceso cortos (15 min) + refresh token con revocación en BD/Redis |
| Contraseñas o secretos en el repo | Hardcodeo directo en código | `.env` + `.gitignore`, gestor de secretos en CI/CD (no `.env` commiteado) |