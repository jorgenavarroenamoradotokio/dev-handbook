# Guía de Contribución — dev-handbook

Este documento define las convenciones para mantener el repositorio consistente y útil a largo plazo.

---

## ¿Dónde va cada tecnología?

| Tecnología / Herramienta | Carpeta destino |
|:-------------------------|:----------------|
| Lenguajes (Go, Python, TypeScript, Rust, Java) | `languages/` |
| Frameworks web backend (FastAPI, Gin, Spring) | `platforms/web/backend/` |
| Frameworks web frontend (Next.js, Remix, SvelteKit) | `platforms/web/frontend/` |
| Frameworks móvil (React Native, Flutter) | `platforms/mobile/` |
| Microservicios (gRPC, Temporal, Dapr) | `platforms/microservices/` |
| Bases de datos relacionales (PostgreSQL, MySQL) | `data/databases/relational/` |
| Bases de datos NoSQL (MongoDB, DynamoDB) | `data/databases/nosql/` |
| Caché (Redis, Memcached) | `data/databases/cache/` |
| Testing (Vitest, Pytest, Playwright, k6) | `testing/` |
| Docker y contenedores | `infrastructure/containers/` |
| CI/CD (GitHub Actions, GitLab CI, ArgoCD) | `infrastructure/ci-cd/` |
| Servidores y proxies (Nginx, Caddy, HAProxy) | `infrastructure/servers/` |
| Control de versiones, Git workflows | `tooling/` |
| Shell, CLI tools (bash, zsh, awk, jq) | `tooling/shell/` |
| Certificaciones (AWS, CKA, Terraform) | `certifications/` |

Si una tecnología no encaja claramente, abre un issue o crea la carpeta con un `README.md` que explique el criterio.

---

## Proceso para añadir una guía

```bash
# 1. Partir siempre desde main actualizado
git switch main && git pull origin main

# 2. Crear rama con prefijo docs/
git switch -c docs/guide-<tecnologia>
# Ejemplos:
# docs/guide-postgresql
# docs/guide-nginx
# docs/guide-aws-saa

# 3. Copiar la plantilla estándar
cp docs/templates/template-guide.md <categoria>/<tecnologia>.md

# 4. Desarrollar la guía (ver estándares de calidad abajo)

# 5. Actualizar el README.md principal
#    - Añadir fila en la tabla de la categoría correspondiente
#    - Actualizar el contador en "Estado del Repositorio"

# 6. Actualizar docs/CHANGELOG.md
#    - Añadir entrada en la sección [Unreleased] o la versión correcta

# 7. Commit
git add .
git commit -m "docs(<categoria>): add <tecnologia> guide"
# Ejemplos:
# docs(data): add postgresql guide
# docs(infrastructure): add nginx guide

# 8. Merge a main
git switch main
git merge --no-ff docs/guide-<tecnologia>
git push origin main
git branch -d docs/guide-<tecnologia>
```

---

## Estándares de calidad de una guía

Una guía **no se considera completa** hasta cubrir todas estas secciones:

- [ ] **Metadata**: versión actual, tipo, casos de uso y casos a evitar
- [ ] **Arquitectura interna**: cómo funciona bajo el capó (diagrama Mermaid obligatorio)
- [ ] **Instalación**: comandos exactos, incluyendo opción Docker para desarrollo local
- [ ] **Configuración de producción**: fichero de configuración comentado línea por línea
- [ ] **Ejemplos reales**: código del mundo real, no `hello world`
- [ ] **Buenas prácticas**: seguridad, rendimiento, observabilidad
- [ ] **Antipatrones**: tabla con problema → consecuencia → solución
- [ ] **Recursos**: documentación oficial, libros, herramientas

---

## Convenciones de escritura

### Commits

Usar [Conventional Commits](https://www.conventionalcommits.org):

```
docs(<scope>): <descripción en imperativo>

# Scopes válidos: languages, platforms, data, testing,
#                 infrastructure, tooling, certifications, meta
```

### Nombres de archivo

- Siempre en **kebab-case**: `docker-compose.md`, `react-native.md`
- Sin espacios, sin mayúsculas, sin caracteres especiales

### Diagramas

- Usar **Mermaid.js** dentro de bloques ` ```mermaid `
- Toda arquitectura relevante debe tener al menos un diagrama
- Los diagramas de secuencia para flujos de request son obligatorios en guías de frameworks

### Tablas comparativas

Cuando existan opciones, configuraciones o versiones, organizarlas siempre en tabla Markdown:

```markdown
| Opción | Cuándo usarlo | Cuándo NO usarlo |
|--------|--------------|-----------------|
| ...    | ...          | ...             |
```

### Estado de una guía

Añadir al inicio de cada fichero `.md`:

```markdown
> **Estado:** 🟢 Completo | 🟡 En progreso | 🔴 Borrador
> **Última actualización:** YYYY-MM
```

---

## Niveles de profundidad

Cada guía debe aspirar al nivel **Completo**:

| Nivel | Descripción |
|:------|:------------|
| `Básico` | Instalación, comandos principales, ejemplo mínimo |
| `Intermedio` | Configuración real, patrones de uso, integración con otras herramientas |
| `Completo` | Arquitectura interna, producción, seguridad, rendimiento, antipatrones, troubleshooting |

---

## Lo que NO entra en este repositorio

- Tutoriales paso a paso tipo curso (para eso hay plataformas dedicadas)
- Opiniones sin respaldo técnico
- Código sin comentarios ni contexto
- Capturas de pantalla como sustituto de comandos escritos
- Información sin fuente cuando sea opinable