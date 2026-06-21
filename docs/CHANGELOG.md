# Changelog — dev-handbook

Todas las guías y cambios relevantes de este repositorio se documentan aquí.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).
Las versiones siguen [Semantic Versioning](https://semver.org/lang/es/): `MAJOR.MINOR.PATCH`

> **Convención de versiones para este repo:**
> - `MAJOR`: reestructuración completa del repositorio
> - `MINOR`: nueva guía añadida
> - `PATCH`: correcciones, mejoras o actualizaciones de una guía existente

---

## [Unreleased]

> Guías planificadas o en progreso.

### En progreso 🟡

- Sin plantillas en progreso

### Planificadas 🔜

- Sin planificaciones pendientes

---

## [0.4.3] — 2026-06

### Fixed
- Normalización de índices (TOC) en todas las guías existentes:
  - `version-control/` — 1 guia

---

## [0.4.2] — 2026-06

### Fixed
- Normalización de índices (TOC) en todas las guías existentes:
  - `infrastructure/server/tomcat/` — 10 módulos

---

## [0.4.1] — 2026-06

### Fixed
- Normalización de índices (TOC) en todas las guías existentes:
  - `infrastructure/os/linux/` — 5 módulos

---

## [0.4.0] — 2026-06

### Added

- `certifications/compTIA/` — Guía modular de CompTIA Security+ (16 módulos):
  - `Modulo-01-Fundamentos-Arquitectura.md` — Arquitectura del kernel, syscalls y sistema de ficheros
  - `Modulo-02-CLI-Procesamiento-Texto.md` — Shell, pipes, redirecciones y herramientas de texto
  - `Modulo-03-Administracion-Sistema.md` — Procesos, servicios systemd y gestión de usuarios
  - `Modulo-04-Almacenamiento-Red.md` — Discos, LVM, sistemas de ficheros y networking
  - `Modulo-05-Automatizacion-Operaciones.md` — Scripting bash, cron y automatización de operaciones

---

## [0.3.0] — 2026-06

### Added

- `infrastructure/os/linux/` — Guía modular de Linux en progreso (5 módulos):
  - `Modulo-01-Fundamentos-Arquitectura.md` — Arquitectura del kernel, syscalls y sistema de ficheros
  - `Modulo-02-CLI-Procesamiento-Texto.md` — Shell, pipes, redirecciones y herramientas de texto
  - `Modulo-03-Administracion-Sistema.md` — Procesos, servicios systemd y gestión de usuarios
  - `Modulo-04-Almacenamiento-Red.md` — Discos, LVM, sistemas de ficheros y networking
  - `Modulo-05-Automatizacion-Operaciones.md` — Scripting bash, cron y automatización de operaciones

---

## [0.2.0] — 2026-06

### Added

- `infrastructure/server/tomcat/` — Guía completa de Apache Tomcat dividida en 10 módulos:
  - `Modulo-01-Arquitectura.md` — Arquitectura interna, componentes y modelo de procesamiento
  - `Modulo-02-Instalacion.md` — Instalación y configuración inicial de producción
  - `Modulo-03-ServerXml.md` — Configuración detallada de `server.xml`
  - `Modulo-04-Conectores.md` — Conectores HTTP/1.1, HTTP/2 y AJP
  - `Modulo-05-Web.md` — Despliegue y gestión de aplicaciones web
  - `Modulo-06-Seguridad.md` — Hardening, TLS/SSL, autenticación y autorización
  - `Modulo-07-Pool.md` — Connection pooling y gestión de recursos JDBC
  - `Modulo-08-Sesiones-Clustering.md` — Gestión de sesiones y clustering
  - `Modulo-09-Rendimiento-Monitorizacion.md` — Tuning de JVM, GC y monitorización con JMX
  - `Modulo-10-Migraciones.md` — Migraciones entre versiones y estrategias de actualización

---

## [0.1.0] — 2026-05

### Added

- `version-control/git.md` — Guía definitiva de Git y Version Control
  - Git internals: modelo de objetos (blob, tree, commit, tag), DAG
  - Configuración profesional de `~/.gitconfig` con SSH signing
  - Comandos avanzados: bisect, worktrees, reflog, add -p
  - Workflows comparados: Trunk-Based Development vs Gitflow vs GitHub Flow
  - Conventional Commits + automatización de CHANGELOG con git-cliff
  - Git hooks con pre-commit: detección de secrets, validación de commits
  - Branch protection rules y CODEOWNERS para GitHub
  - 8 antipatrones documentados con causa → consecuencia → fix

- Estructura inicial del repositorio
  - `README.md` con índice de guías y estado del repositorio
  - `docs/CONTRIBUTING.md` con convenciones y proceso de contribución
  - `docs/CHANGELOG.md` (este fichero)