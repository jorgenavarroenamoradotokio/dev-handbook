# dev-handbook

> Referencia técnica personal de ingeniería de software. Guías de producción sobre lenguajes, frameworks, bases de datos, infraestructura, testing y certificaciones — con arquitectura interna, ejemplos reales y antipatrones.

<!-- BADGES:START -->
[![GuÃ­as completadas](https://img.shields.io/badge/Gui­as-34-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![CategorÃ­as activas](https://img.shields.io/badge/Categorias_activas-4-blue?style=flat-square)](#-Ã­ndice-de-guÃ­as)
[![Última actualización](https://img.shields.io/badge/Última_actualización-2026--06-blue?style=flat-square)](./docs/CHANGELOG.md)
<!-- BADGES:END -->
[![Licencia](https://img.shields.io/badge/Licencia-Privado-red?style=flat-square)](#-licencia)

> Los badges y la tabla de **Estado del Repositorio** se generan con `scripts/update-stats.sh`. No los edites a mano — se desincronizan (es justo lo que pasaba antes). Ver [Mantenimiento](#-mantenimiento-automatizado).

---

## ¿Qué es este repositorio?

Mi **sistema personal de gestión del conocimiento técnico**. No es un blog ni un curso — es la referencia que consulto cuando necesito recordar cómo funciona algo, cuál es el comando exacto, o cuál es la práctica correcta en producción.

- Arquitectura interna y modelo mental
- Instalación y configuración de producción
- Ejemplos de código reales, comentados línea por línea
- Buenas prácticas, seguridad y rendimiento
- Antipatrones comunes y cómo evitarlos
- Recursos y documentación oficial

---

## 📐 Convención de Modularización

Regla fija para decidir si un tema es **una guía única** o **una serie de módulos**:

| Criterio | Formato | Ejemplo |
|:---------|:--------|:--------|
| Tema acotado, una sola superficie de API o herramienta puntual | `<tecnologia>.md` único | `git.md` |
| Tema extenso con subsistemas independientes (arquitectura, instalación, seguridad, rendimiento son bloques separados) | Serie `Modulo-XX-Nombre.md` dentro de `/<tecnologia>/` | `tomcat/Modulo-01-Arquitectura.md` |

**Antes de crear una guía nueva, decide explícitamente cuál de las dos aplica.** Si dudas a mitad de la redacción, es señal de que el tema es más grande de lo que pensabas — divide en módulos en lugar de seguir alargando un único archivo.

---

## 🗺️ Índice de Guías

### 🛠️ Version Control (`/version-control`)

| Tecnología | Guía | Estado |
|:-----------|:-----|:------:|
| **Git & Version Control** | [Guía Definitiva](./version-control/git.md) | ✅ |

### 🖥️ Infrastructure — OS (`/infrastructure/os/linux`)

Administración de sistemas Linux a nivel de producción: fundamentos, CLI, almacenamiento y automatización.

| Módulo | Guía | Estado |
|:-------|:-----|:------:|
| 01 | [Fundamentos y Arquitectura](./infrastructure/os/linux/Modulo-01-Fundamentos-Arquitectura.md) | ✅ |
| 02 | [CLI y Procesamiento de Texto](./infrastructure/os/linux/Modulo-02-CLI-Procesamiento-Texto.md) | ✅ |
| 03 | [Administración del Sistema](./infrastructure/os/linux/Modulo-03-Administracion-Sistema.md) | ✅ |
| 04 | [Almacenamiento y Red](./infrastructure/os/linux/Modulo-04-Almacenamiento-Red.md) | ✅ |
| 05 | [Automatización y Operaciones](./infrastructure/os/linux/Modulo-05-Automatizacion-Operaciones.md) | ✅ |

### 🐱 Infrastructure — Servers (`/infrastructure/server/tomcat`)

Apache Tomcat: instalación, configuración, seguridad, rendimiento y operaciones en producción.

| Módulo | Guía | Estado |
|:-------|:-----|:------:|
| 01 | [Arquitectura](./infrastructure/server/tomcat/Modulo-01-Arquitectura.md) | ✅ |
| 02 | [Instalación](./infrastructure/server/tomcat/Modulo-02-Instalacion.md) | ✅ |
| 03 | [Server XML](./infrastructure/server/tomcat/Modulo-03-ServerXml.md) | ✅ |
| 04 | [Conectores](./infrastructure/server/tomcat/Modulo-04-Conectores.md) | ✅ |
| 05 | [Web](./infrastructure/server/tomcat/Modulo-05-Web.md) | ✅ |
| 06 | [Seguridad](./infrastructure/server/tomcat/Modulo-06-Seguirdad.md) | ✅ |
| 07 | [Pool](./infrastructure/server/tomcat/Modulo-07-Pool.md) | ✅ |
| 08 | [Sesiones y Clustering](./infrastructure/server/tomcat/Modulo-08-Sesiones-Clustering.md) | ✅ |
| 09 | [Rendimiento y Monitorización](./infrastructure/server/tomcat/Modulo-09-Rendimiento-Monitorizacion.md) | ✅ |
| 10 | [Migraciones](./infrastructure/server/tomcat/Modulo-10-Migracion.md) | ✅ |

### 🎓 Certifications — CompTIA Security+ (`/certifications/compTIA`)

| Módulo | Guía | Estado |
|:-------|:-----|:------:|
| 01 | [Fundamentos de Seguridad](./certifications/compTIA/Modulo-01-Fundamentales-Seguridad.md) | ✅ |
| 02 | [Tipos de Amenazas](./certifications/compTIA/Modulo-02-Tipos-Amenazas.md) | ✅ |
| 03 | [Criptografía](./certifications/compTIA/Modulo-03-Criptográfia.md) | ✅ |
| 04 | [Gestión de Identidades y Accesos](./certifications/compTIA/Modulo-04-Gestion-Identidades-Accesos.md) | ✅ |
| 05 | [Arquitectura de Red Empresarial](./certifications/compTIA/Modulo-05-Arquitectura-Red-Empresarial.md) | ✅ |
| 06 | [Arquitectura en la Nube](./certifications/compTIA/Modulo-06-Arquitectura-Nube.md) | ✅ |
| 07 | [Gestión de Activos y Redundancia](./certifications/compTIA/Modulo-07-Gestion-Activos-Estrategias-Redundancia.md) | ✅ |
| 08 | [Gestión de Vulnerabilidades](./certifications/compTIA/Modulo-08-Gestion-Vulnerabilidades.md) | ✅ |
| 09 | [Evaluación de Seguridad de Red](./certifications/compTIA/Modulo-09-Evaluación-Seguridad-Red.md) | ✅ |
| 10 | [Puntos de Conexión](./certifications/compTIA/Modulo-10-Seguridad-Puntos-Conexión.md) | ✅ |
| 11 | [Seguridad de Aplicaciones](./certifications/compTIA/Modulo-11-Seguirdad-Aplicaciones.md.md) | ✅ |
| 12 | [Monitoreo de Incidentes](./certifications/compTIA/Modulo-12-Incidentes-Monitoreo.md) | ✅ |
| 13 | [Indicadores de Actividad Maliciosa](./certifications/compTIA/Modulo-13-Indicadores-Actividad-Maliciosa.md) | ✅ |
| 14 | [Gobernanza](./certifications/compTIA/Modulo-14-Gobernanza.md) | ✅ |
| 15 | [Gestión de Riesgos](./certifications/compTIA/Modulo-15-Gestion-Riesgos.md) | ✅ |
| 16 | [Protección de Datos](./certifications/compTIA/Modulo-16-Proteccion-Datos.md) | ✅ |

### 💻 Languages (`/languages`)

| Tecnología | Guía | Estado |
|:-----------|:-----|:------:|
| — | Próximamente | 🔜 |

### 🧱 Platforms (`/platforms`)

| Subcategoría | Tecnología | Guía | Estado |
|:--------------|:-----------|:-----|:------:|
| Backend | — | Próximamente | 🔜 |
| Frontend | — | Próximamente | 🔜 |
| Mobile | — | Próximamente | 🔜 |
| Microservicios | — | Próximamente | 🔜 |

### 🧪 Testing (`/testing`)

| Tipo | Herramienta | Guía | Estado |
|:-----|:------------|:-----|:------:|
| Unitario | JUnit 5 | [jUnit.md](./testing/unitario/jUnit.md) | ✅ |
| Unitario (Mocking) | Mockito | [Mockito.md](./testing/unitario/mockito.md) | ✅ |
| Integración | — | Próximamente | 🔜 |
| E2E | — | Próximamente | 🔜 |
| Contract | — | Próximamente | 🔜 |
| Performance | — | Próximamente | 🔜 |

### 🐳 Infrastructure — Containers (`/infrastructure/containers`)

| Tecnología | Guía | Estado |
|:-----------|:-----|:------:|
| **Docker** | [Guía Definitiva](./infrastructure/containers/Docker.md) | ✅ |

### 🗄️ Data — Databases (`/data/databases`)

| Tipo | Tecnología | Guía | Estado |
|:-----|:-----------|:-----|:------:|
| — | Próximamente | 🔜 |

---

## 🏗️ Estructura del Repositorio

```
dev-handbook/
│
├── 📄 README.md
│
├── 📁 docs/
│   ├── CONTRIBUTING.md
│   └── CHANGELOG.md

│
├── 📁 scripts/
│   ├── update-stats.ps1            # Genera badges + tabla de estado windows
│   └── update-stats.sh             # Genera badges + tabla de estado windows

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
│       ├── jUnit.md
│       └── mockito.md
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
│   └── build-tools/
│
├── 📁 version-control/
│   └── git.md
│
├── 📁 certifications/
│   └── compTIA/                   # Módulos 01–16 (completos)
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

# 3. Decidir formato (ver Convención de Modularización arriba):
#    - Tema acotado  -> cp docs/templates/template-guide.md <categoria>/<tecnologia>.md
#    - Tema extenso   -> mkdir <categoria>/<tecnologia> && cp docs/templates/template-guide.md <categoria>/<tecnologia>/Modulo-01-Nombre.md

# 4. Desarrollar la guía

# 5. Regenerar badges y tabla de estado
bash scripts/update-stats.sh

# 6. Commit con conventional commits
git add .
git commit -m "docs(<categoria>): add <tecnologia> guide"

# 7. Mergear y limpiar
git switch main
git merge --no-ff docs/guide-<tecnologia>
git push origin main
git branch -d docs/guide-<tecnologia>
```

**¿Dónde va cada tecnología?** → [`docs/CONTRIBUTING.md`](./docs/CONTRIBUTING.md)

---

## 🤖 Mantenimiento Automatizado

El contador de guías y categorías se generaba a mano y se desincronizaba del contenido real (el README original decía "03 guías completadas" con 32 archivos reales en el repo). Para que esto no vuelva a pasar, hay dos scripts equivalentes en `scripts/` — usa el que corresponda a tu entorno, ambos producen el mismo resultado:

| Entorno | Script | Cuándo usarlo |
|:--------|:-------|:---------------|
| Git Bash / WSL / Linux / macOS | `scripts/update-stats.sh` | Si ya tienes bash disponible |
| Windows sin bash | `scripts/update-stats.ps1` | PowerShell nativo, sin dependencias extra |

**Git Bash / WSL / Linux / macOS:**
```bash
bash scripts/update-stats.sh
```

**PowerShell (Windows nativo):**
```powershell
.\scripts\update-stats.ps1
```
Si PowerShell bloquea la ejecución (política de ejecución por defecto en Windows), ejecuta una vez por sesión:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Qué hace (ambas versiones, misma lógica):
1. Cuenta archivos `.md` reales bajo cada categoría de nivel superior (excluye `docs/`, `scripts/`, `README.md`).
2. Cuenta cuántas de esas categorías tienen al menos un archivo (= "categoría activa").
3. Reescribe los badges entre `<!-- BADGES:START -->` y `<!-- BADGES:END -->` en este README.
[![GuÃ­as completadas](https://img.shields.io/badge/GuÃ­as-34-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![CategorÃ­as activas](https://img.shields.io/badge/CategorÃ­as_activas-4-blue?style=flat-square)](#-Ã­ndice-de-guÃ­as)
[![Ãšltima actualizaciÃ³n](https://img.shields.io/badge/Ãšltima_actualizaciÃ³n-2026-06-blue?style=flat-square)](./docs/CHANGELOG.md)
