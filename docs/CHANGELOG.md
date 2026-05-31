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
- Ninguna actualmente

### Planificadas 🔜
- `certifications/` → CompTIA security +

---

[0.1.0] — 2026-05
Added

version-control/git.md — Guía definitiva de Git y Version Control

Git internals: modelo de objetos (blob, tree, commit, tag), DAG
Configuración profesional de ~/.gitconfig con SSH signing
Comandos avanzados: bisect, worktrees, reflog, add -p
Workflows comparados: Trunk-Based Development vs Gitflow vs GitHub Flow
Conventional Commits + automatización de CHANGELOG con git-cliff
Git hooks con pre-commit: detección de secrets, validación de commits
Branch protection rules y CODEOWNERS para GitHub
8 antipatrones documentados con causa → consecuencia → fix


### Added
- Estructura inicial del repositorio
  - `README.md` con índice de guías y estado del repositorio
  - `docs/CONTRIBUTING.md` con convenciones y proceso de contribución
  - `docs/CHANGELOG.md` (este fichero)
  - `docs/GLOSSARY.md` (pendiente de contenido)
  - `docs/templates/template-guide.md` con plantilla estándar