# dev-handbook

> Referencia técnica personal de ingeniería de software. Guías de producción sobre lenguajes, frameworks, bases de datos, infraestructura y certificaciones — con arquitectura interna, ejemplos reales y antipatrones.

[![Guías completadas](https://img.shields.io/badge/Guías_completadas-03-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![Categorías](https://img.shields.io/badge/Categorías-9-blue?style=flat-square)](#️-índice-de-guías)
[![Última actualización](https://img.shields.io/badge/Última_actualización-2026--06-blue?style=flat-square)](./docs/CHANGELOG.md)
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

### 🛠️ Version Control (`/version-control`)

| Tecnología | Guía | Estado | Última actualización |
|:-----------|:-----|:------:|:--------------------:|
| **Git & Version Control** | [Guía Definitiva](./version-control/git.md) | ✅ | 2026-05 |

### 🖥️ Infrastructure — OS (`/infrastructure/os/linux`)

Administración de sistemas Linux a nivel de producción: fundamentos, CLI, almacenamiento y automatización.

| Módulo | Guía | Estado | Última actualización |
|:-------|:-----|:------:|:--------------------:|
| 01 | [Fundamentos y Arquitectura](./infrastructure/os/linux/Modulo-01-Fundamentos-Arqui...) | ✅ | 2026-06 |
| 02 | [CLI y Procesamiento de Texto](./infrastructure/os/linux/Modulo-02-CLI-Procesamiento-T...) | ✅ | 2026-06 |
| 03 | [Administración del Sistema](./infrastructure/os/linux/Modulo-03-Administracion-Siste...) | ✅ | 2026-06 |
| 04 | [Almacenamiento y Red](./infrastructure/os/linux/Modulo-04-Almacenamiento-Re...) | ✅ | 2026-06 |
| 05 | [Automatización y Operaciones](./infrastructure/os/linux/Modulo-05-Automatizacion-Ope...) | ✅ | 2026-06 |

### 🐱 Infrastructure — Servers (`/infrastructure/server/tomcat`)

Apache Tomcat: instalación, configuración, seguridad, rendimiento y operaciones en producción.

| Módulo | Guía | Estado | Última actualización |
|:-------|:-----|:------:|:--------------------:|
| 01 | [Arquitectura](./infrastructure/server/tomcat/Modulo-01-Arquitectura.md) | ✅ | 2026-06 |
| 02 | [Instalación](./infrastructure/server/tomcat/Modulo-02-Instalacion.md) | ✅ | 2026-06 |
| 03 | [Server XML](./infrastructure/server/tomcat/Modulo-03-ServerXml.md) | ✅ | 2026-06 |
| 04 | [Conectores](./infrastructure/server/tomcat/Modulo-04-Conectores.md) | ✅ | 2026-06 |
| 05 | [Web](./infrastructure/server/tomcat/Modulo-05-Web.md) | ✅ | 2026-06 |
| 06 | [Seguridad](./infrastructure/server/tomcat/Modulo-06-Seguridad.md) | ✅ | 2026-06 |
| 07 | [Pool](./infrastructure/server/tomcat/Modulo-07-Pool.md) | ✅ | 2026-06 |
| 08 | [Sesiones y Clustering](./infrastructure/server/tomcat/Modulo-08-Sesiones-Clustering.md) | ✅ | 2026-06 |
| 09 | [Rendimiento y Monitorización](./infrastructure/server/tomcat/Modulo-09-Rendimiento-Monitorizaci...) | ✅ | 2026-06 |
| 10 | [Migraciones](./infrastructure/server/tomcat/Modulo-10-Migraciones.md) | ✅ | 2026-06 |

### 💻 Languages (`/languages`)

| Tecnología | Subcategoría | Guía | Estado | Última actualización |
|:-----------|:-------------|:-----|:------:|:--------------------:|
| — | Próximamente | — | 🔜 | — |

### 🧱 Platforms (`/platforms`)

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
│   ├── CONTRIBUTING.md
│   ├── CHANGELOG.md
│   └── templates/
│       └── template-guide.md
│
├── 📁 languages/
│   ├── backend/
│   └── frontend/
│
├── 📁 platforms/
│   ├── web/
│   │   ├── backend/
│   │   └── frontend/
│   ├── mobile/
│   └── microservices/
│
├── 📁 data/
│   └── databases/
│       ├── relational/
│       ├── nosql/
│       ├── cache/
│       └── vector/
│
├── 📁 testing/
│   ├── unit/
│   ├── integration/
│   ├── e2e/
│   ├── contract/
│   └── performance/
│
├── 📁 infrastructure/
│   ├── os/
│   │   └── linux/                 # Módulos 01–05 (completos)
│   ├── server/
│   │   └── tomcat/                # Módulos 01–10 (completos)
│   ├── containers/
│   ├── ci-cd/
│   ├── build-tools/
│   └── servers/
│
├── 📁 version-control/
│   └── git.md
│
├── 📁 certifications/
│
└── 📁 assets/
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
| Total de guías | 16 |
| Guías completadas ✅ | 11 |
| Guías en progreso 🟡 | 5 |
| Categorías activas | 3 |
| Tecnologías planificadas | 35+ |

> El contador se actualiza manualmente con cada guía añadida. Ver historial completo en [CHANGELOG.md](./docs/CHANGELOG.md).

---

## 🔒 Licencia

Todos los derechos reservados. No se permite copiar, modificar ni distribuir sin permiso expreso del autor.