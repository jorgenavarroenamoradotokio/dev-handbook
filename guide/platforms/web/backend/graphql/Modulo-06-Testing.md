> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Testing](#1-testing)
- [2. La pirámide de testing en GraphQL](#2-la-pirámide-de-testing-en-graphql)
- [3. Implementación paso a paso](#3-implementación-paso-a-paso)
  - [Testing unitario de servicios (sin GraphQL en absoluto)](#testing-unitario-de-servicios-sin-graphql-en-absoluto)
  - [Testing de integración con el servidor en memoria](#testing-de-integración-con-el-servidor-en-memoria)
  - [Mocking de DataLoaders y dependencias externas](#mocking-de-dataloaders-y-dependencias-externas)
  - [E2E con Playwright (reemplaza a Cypress en el índice original — ver nota)](#e2e-con-playwright-reemplaza-a-cypress-en-el-índice-original--ver-nota)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Testing

Testear GraphQL mal es fácil: levantar el servidor HTTP completo y hacer requests contra `/graphql` en cada test. Es lento, frágil y acopla tus tests a detalles de transporte que no importan (headers, puertos, CORS). La estrategia correcta separa capas, igual que separaste lógica de negocio de resolvers en el Módulo 03.

**Analogía:** no testeas si un restaurante funciona abriendo sus puertas al público cada vez que quieres verificar una receta. Testeas la receta en la cocina de pruebas (test unitario de servicio), luego verificas que el cocinero interpreta bien la comanda (test de resolver), y solo al final simulas un servicio completo (test E2E) — con moderación, porque es caro y lento.

---

## 2. La pirámide de testing en GraphQL

```
        /\
       /E2E\          ← pocos: flujo completo cliente→servidor→DB real (Cypress/Playwright)
      /------\
     /Integr. \       ← moderados: query/mutation contra schema real, DB de test o mocks
    /----------\
   / Unitarios  \     ← muchos: lógica de negocio pura, resolvers aislados, sin red
  /--------------\
```

| Nivel | Qué verifica | Herramienta | Costo |
|---|---|---|---|
| Unitario | Lógica de negocio pura (`postService.create`) | Vitest/Jest | Bajo — milisegundos |
| Integración | El schema resuelve queries/mutations correctamente end-to-end en memoria | `@apollo/server` testing API | Medio |
| E2E | El flujo completo funciona desde la perspectiva del usuario real | Cypress/Playwright | Alto — segundos por test |

---

## 3. Implementación paso a paso

### Testing unitario de servicios (sin GraphQL en absoluto)

```bash
npm install -D vitest@4.1.10
```

```typescript
// src/services/postService.test.ts
import { describe, it, expect, vi } from 'vitest';
import { postService } from './postService.js';

describe('postService.create', () => {
  it('rechaza títulos menores a 3 caracteres', async () => {
    await expect(
      postService.create({ title: 'ab', content: '...' }, { id: '1', role: 'USER' }),
    ).rejects.toThrow('Título muy corto');
  });

  it('crea el post asociándolo al autor correcto', async () => {
    const post = await postService.create(
      { title: 'Título válido', content: '...' },
      { id: 'user-42', role: 'USER' },
    );
    expect(post.authorId).toBe('user-42');
  });
});
```

**Por qué esto va primero:** esta prueba no sabe que existe GraphQL. Si mañana migras de GraphQL a gRPC, este test sigue siendo válido sin cambios — es la prueba de que tu lógica de negocio está correctamente desacoplada (Módulo 03, sección 4.1).

### Testing de integración con el servidor en memoria

`@apollo/server` permite ejecutar operaciones contra el schema **sin abrir un puerto HTTP real**, usando `server.executeOperation`:

```typescript
// src/schema.integration.test.ts
import { describe, it, expect, beforeAll } from 'vitest';
import { ApolloServer } from '@apollo/server';
import { typeDefs } from './schema.js';
import { resolvers } from './resolvers.js';

describe('Query.user', () => {
  let server: ApolloServer;

  beforeAll(() => {
    server = new ApolloServer({ typeDefs, resolvers });
  });

  it('devuelve el usuario solicitado con sus posts', async () => {
    const response = await server.executeOperation(
      {
        query: `query { user(id: "1") { name posts { title } } }`,
      },
      { contextValue: { user: { id: '1', role: 'USER' }, loaders: createTestLoaders() } },
    );

    // executeOperation nunca lanza — siempre revisa el body explícitamente
    assert(response.body.kind === 'single');
    expect(response.body.singleResult.errors).toBeUndefined();
    expect(response.body.singleResult.data?.user).toMatchObject({ name: 'Ana García' });
  });

  it('devuelve error BAD_USER_INPUT si el título es inválido', async () => {
    const response = await server.executeOperation(
      {
        query: `mutation { createPost(title: "ab", content: "x") { id } }`,
      },
      { contextValue: { user: { id: '1', role: 'USER' } } },
    );
    assert(response.body.kind === 'single');
    expect(response.body.singleResult.errors?.[0].extensions?.code).toBe('BAD_USER_INPUT');
  });
});
```

> ✅ **BIEN:** este nivel de test valida que el schema, los resolvers y la resolución de campos anidados funcionan **juntos**, sin el costo de un servidor HTTP real. Es el punto óptimo costo/cobertura para la mayoría de tu suite.

### Mocking de DataLoaders y dependencias externas

```typescript
// test/helpers/loaders.ts
import DataLoader from 'dataloader';

export function createTestLoaders(fixtures: { posts: PostRecord[] }) {
  return {
    postsByUser: new DataLoader<string, PostRecord[]>(async (userIds) =>
      userIds.map((id) => fixtures.posts.filter((p) => p.authorId === id)),
    ),
  };
}
```

Nunca conectes tests de integración a una base de datos real compartida — usa fixtures en memoria o una base de datos de test aislada (contenedor Docker desechable por suite).

### E2E con Playwright (reemplaza a Cypress en el índice original — ver nota)

> 📌 **Corrección respecto a la guía original:** Cypress sigue siendo válido, pero Playwright es hoy el estándar de facto para E2E en proyectos nuevos por su mejor soporte multi-navegador y velocidad. Se documenta Playwright; si tu equipo ya tiene infraestructura Cypress, la migración no es obligatoria.

```typescript
// e2e/create-post.spec.ts
import { test, expect } from '@playwright/test';

test('usuario autenticado puede crear un post desde la UI', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name=email]', 'ana@example.com');
  await page.fill('[name=password]', 'test-password');
  await page.click('button[type=submit]');

  await page.goto('/posts/new');
  await page.fill('[name=title]', 'Mi nuevo post E2E');
  await page.click('button:has-text("Publicar")');

  await expect(page.locator('text=Mi nuevo post E2E')).toBeVisible();
});
```

**Regla de oro de la pirámide:** si tienes 10 tests E2E cubriendo la misma mutation con distintos inputs, tienes un problema de diseño de suite — esos 9 casos adicionales deberían bajar a integración o unitario. E2E cubre *flujos críticos de usuario*, no combinatoria de validaciones.

---

## 4. Errores Comunes y Buenas Prácticas

| Problema | Causa | Solución |
|---|---|---|
| Suite de tests tarda 20 minutos | Todo testeado vía E2E contra servidor HTTP real | Redistribuir según la pirámide — mover validaciones a unitario |
| Tests de integración fallan aleatoriamente | Comparten estado de base de datos entre tests sin aislamiento | Transacción por test con rollback, o contenedor efímero |
| Mock de DataLoader oculta bugs reales de batching | El mock no respeta el mismo contrato de orden que el loader real (Módulo 03, 3.1) | El fixture de test debe implementar el mismo `.map(key => ...)` que producción |
| `executeOperation` "pasa" pero producción falla | Context de test no replica middlewares reales (ej. `graphql-shield` no aplicado) | Envolver el schema con el mismo `applyMiddleware(schema, permissions)` en tests de integración |