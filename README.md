# dev-handbook

> Referencia técnica personal de ingeniería de software. Guías de producción sobre lenguajes, frameworks, bases de datos, infraestructura y certificaciones — con arquitectura interna, ejemplos reales y antipatrones.

[![Guías completadas](https://img.shields.io/badge/Guías_completadas-1-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![Categorías](https://img.shields.io/badge/Categorías-9-blue?style=flat-square)](#️-índice-de-guías)
[![Última actualización](https://img.shields.io/badge/Última_actualización-2026--05-blue?style=flat-square)](./docs/CHANGELOG.md)
[![Licencia](https://img.shields.io/badge/Licencia-Privado-red?style=flat-square)](#-licencia)

---

## ¿Qué es este repositorio?

Este repositorio es mi **sistema personal de gestión del conocimiento técnico**. No es un blog ni un curso — es la referencia que consulto cuando necesito recordar cómo funciona algo, cuál es el comando exacto, o cuál es la práctica correcta en producción.

Cada guía sigue una [plantilla estándar](./docs/templates/template-guide.md) que garantiza profundidad técnica consistente:

- Arquitectura interna y modelo mental
- Instalación y configuración de producción
- Ejemplos de código reales, comentados línea por línea
- Buenas prácticas, seguridad y rendimiento
- Antipatrones comunes y cómo evitarlos
- Recursos y documentación oficial

---

## 🗺️ Índice de Guías

### 🛠️ version (`/version-control`)

| Tecnología | Guía | Nivel | Estado | Última actualización |
|:-----------|:-----|:-----:|:------:|:--------------------:|
| **Git & Version Control** | [Guía Definitiva](./version-control/git.md) | Completo | ✅ | 2026-05 |

### 💻 Languages (`/languages`)

Cubre Backend y Frontend. Profundidad técnica: runtime, gestión de memoria, concurrencia, patrones.

| Tecnología | Subcategoría | Guía | Estado | Última actualización |
|:-----------|:-------------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |

### 🧱 Platforms (`/platforms`)

Frameworks web, móvil y microservicios.

#### Web Backend

| Tecnología | Guía | Estado | Última actualización |
|:-----------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |

#### Web Frontend

| Tecnología | Guía | Estado | Última actualización |
|:-----------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |

#### Mobile

| Tecnología | Guía | Estado | Última actualización |
|:-----------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |

#### Microservicios

| Tecnología | Guía | Estado | Última actualización |
|:-----------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |

### 🧪 Testing (`/testing`)

Unit, Integration, E2E, Contract Testing y QA Automation.

| Herramienta / Tipo | Subcategoría | Guía | Estado | Última actualización |
|:-------------------|:-------------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |


### 🐳 Infrastructure — Containers (`/infrastructure/containers`)

| Tecnología | Guía | Estado | Última actualización |
|:-----------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |


### 🗄️ Data — Databases (`/data/databases`)

| Tecnología | Tipo | Guía | Estado | Última actualización |
|:-----------|:-----|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |


### 🖥️ Infrastructure — Servers (`/infrastructure/servers`)

| Tecnología | Tipo | Guía | Estado | Última actualización |
|:-----------|:-----|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |


### 🎓 Certifications (`/certifications`)

| Certificación | Proveedor | Guía | Estado | Última actualización |
|:-------------|:----------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |


---

## 🏗️ Estructura del Repositorio

```
dev-handbook/
│
├── 📄 README.md
│
├── 📁 docs/
│   ├── CONTRIBUTING.md            # Convenciones y proceso para añadir guías
│   ├── CHANGELOG.md               # Historial de guías y cambios
│   └── templates/
│       └── template-guide.md      # Plantilla base para nuevas guías
│
├── 📁 languages/
│   ├── backend/                   # Go, python, java, rust, kotlin
│   └── frontend/                  # typescript
│
├── 📁 platforms/
│   ├── web/
│   │   ├── backend/               # FastAPI, Gin, Spring Boot, Express
│   │   └── frontend/              # Next.js, Remix, SvelteKit
│   ├── mobile/                    # React Native, Flutter
│   └── microservices/             # gRPC, Temporal, Dapr
│
├── 📁 data/
│   └── databases/
│       ├── relational/            # PostgreSQL, MySQL
│       ├── nosql/                 # MongoDB, DynamoDB
│       ├── cache/                 # Redis, Memcached
│       └── vector/                # pgvector
│
├── 📁 testing/
│   ├── unit/
│   ├── integration/
│   ├── e2e/
│   ├── contract/
│   └── performance/
│
├── 📁 infrastructure/
│   ├── containers/                # Docker, Compose, Kubernetes intro
│   ├── ci-cd/                     # GitHub Actions, GitLab CI
│   ├── build-tools/
│   └── servers/                   # Nginx, Caddy, HAProxy, Traefik
│
├── 📁 version-control/
│   └── git.md
│
├── 📁 certifications/
│
└── 📁 assets/                     # Diagramas, imágenes
```

---

## 🚀 Uso Local

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/dev-handbook.git
cd dev-handbook

# Actualizar con los últimos apuntes
git pull origin main

# Crear una nueva guía desde la plantilla
cp docs/templates/template-guide.md <categoria>/<tecnologia>.md
```

---

## ➕ Añadir una Nueva Guía

```bash
# 1. Partir desde main actualizado
git switch main && git pull origin main

# 2. Crear rama con prefijo docs/
git switch -c docs/guide-<tecnologia>

# 3. Copiar la plantilla
cp docs/templates/template-guide.md <categoria>/<tecnologia>.md

# 4. Desarrollar la guía, luego actualizar README.md y CHANGELOG.md

# 5. Commit con conventional commits
git add .
git commit -m "docs(<categoria>): add <tecnologia> guide"

# 6. Mergear y limpiar
git switch main
git merge --no-ff docs/guide-<tecnologia>
git push origin main
git branch -d docs/guide-<tecnologia>
```

**¿Dónde va cada tecnología?** → [`docs/CONTRIBUTING.md`](./docs/CONTRIBUTING.md)

---

## 📊 Estado del Repositorio

| Métrica | Valor |
|:--------|:-----:|
| Total de guías | 1 |
| Guías completadas ✅ | 1 |
| Guías en progreso 🟡 | 0 |
| Categorías activas | 0 |
| Tecnologías planificadas | 35+ |

> El contador se actualiza manualmente con cada guía añadida. Ver historial completo en [CHANGELOG.md](./docs/CHANGELOG.md).

---

## 🔒 Licencia

Todos los derechos reservados. No se permite copiar, modificar ni distribuir sin permiso expreso del autor.