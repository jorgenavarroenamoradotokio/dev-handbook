# dev-handbook

> Referencia técnica personal de ingeniería de software. Guías de producción sobre lenguajes, frameworks, bases de datos, infraestructura, testing y certificaciones — con arquitectura interna, ejemplos reales y antipatrones.

---

<!-- BADGES:START -->
[![Guías completadas](https://img.shields.io/badge/Gu%C3%ADas-63-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![Categorías activas](https://img.shields.io/badge/Categor%C3%ADas_activas-7-blue?style=flat-square)](#-índice-de-guías)
[![Última actualización](https://img.shields.io/badge/%C3%9Altima_actualizaci%C3%B3n-2026%2F08-blue?style=flat-square)](./docs/CHANGELOG.md)
<!-- BADGES:END -->

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

## 🏗️ Estructura del Repositorio

<!-- TREE:START -->
```
guide/
│
├── 📁 certifications/
│   └── 📁 compTIA/
│       ├── 📄 Modulo-01-Fundamentales-Seguridad.md
│       ├── 📄 Modulo-02-Tipos-Amenazas.md
│       ├── 📄 Modulo-03-Criptográfia.md
│       ├── 📄 Modulo-04-Gestion-Identidades-Accesos.md
│       ├── 📄 Modulo-05-Arquitectura-Red-Empresarial.md
│       ├── 📄 Modulo-06-Arquitectura-Nube.md
│       ├── 📄 Modulo-07-Gestion-Activos-Estrategias-Redundancia.md
│       ├── 📄 Modulo-08-Gestion-Vulnerabilidades.md
│       ├── 📄 Modulo-09-Evaluación-Seguridad-Red.md
│       ├── 📄 Modulo-10-Seguridad-Puntos-Conexión.md
│       ├── 📄 Modulo-11-Seguirdad-Aplicaciones.md
│       ├── 📄 Modulo-12-Incidentes-Monitoreo.md
│       ├── 📄 Modulo-13-Indicadores-Actividad-Maliciosa.md
│       ├── 📄 Modulo-14-Gobernanza.md
│       ├── 📄 Modulo-15-Gestion-Riesgos.md
│       └── 📄 Modulo-16-Proteccion-Datos.md
│
├── 📁 data/
│   └── 📁 database/
│       └── 📁 cache/
│           └── 📁 redis/
│               ├── 📄 Modulo-01-Instalaccion.md
│               ├── 📄 Modulo-02-Arquitectura.md
│               ├── 📄 Modulo-03-Datos-Tipo.md
│               ├── 📄 Modulo-04-Persistencia.md
│               ├── 📄 Modulo-05-Seguridad-ACL-TLS.md
│               ├── 📄 Modulo-06-Patrones-Arquitectura.md
│               ├── 📄 Modulo-07-Alta-Disponibilidad-Escalabilidad.md
│               ├── 📄 Modulo-08-Optimizacion-Rendimiento.md
│               ├── 📄 Modulo-09-Observabilidad-Troubleshooting.md
│               └── 📄 Modulo-10-Testing-Validacion.md
│
├── 📁 infrastructure/
│   ├── 📁 build-tools/
│   │   └── 📄 Maven.md
│   ├── 📁 containers/
│   │   └── 📄 Docker.md
│   ├── 📁 os/
│   │   └── 📁 linux/
│   │       ├── 📄 Modulo-01-Fundamentos-Arquitectura.md
│   │       ├── 📄 Modulo-02-CLI-Procesamiento-Texto.md
│   │       ├── 📄 Modulo-03-Administración-Sistema.md
│   │       ├── 📄 Modulo-04-Almacenamiento-Redes.md
│   │       └── 📄 Modulo-05-Automatización-Operaciones.md
│   └── 📁 server/
│       └── 📁 tomcat/
│           ├── 📄 Modulo-01-Arquitectura.md
│           ├── 📄 Modulo-02-Instalacion.md
│           ├── 📄 Modulo-03-ServerXml.md
│           ├── 📄 Modulo-04-Conectores.md
│           ├── 📄 Modulo-05-Web.md
│           ├── 📄 Modulo-06-Seguirdad.md
│           ├── 📄 Modulo-07-Pool.md
│           ├── 📄 Modulo-08-Sesiones-Clustering.md
│           ├── 📄 Modulo-09-Rendimiento-Monitorizacion.md
│           └── 📄 Modulo-10-Migracion.md
│
├── 📁 languages/
│   └── 📁 kotlin/
│       ├── 📄 Modulo-01-Fundamentos-Sintaxis.md
│       ├── 📄 Modulo-02-Colecciones.md
│       ├── 📄 Modulo-03-POO.md
│       ├── 📄 Modulo-04-POO-Avanzada.md
│       ├── 📄 Modulo-05-Programacion-Funcional.md
│       ├── 📄 Modulo-06-Excepciones.md
│       ├── 📄 Modulo-07-Corrutinas.md
│       └── 📄 Modulo-08-Anotaciones-JVM.md
│
├── 📁 platforms/
│   ├── 📁 mobile/
│   │   └── 📄 JetpackCompose.md
│   └── 📁 web/
│       └── 📁 backend/
│           └── 📁 graphql/
│               ├── 📄 Modulo-01-Fundamentos-Arquitectura.md
│               ├── 📄 Modulo-02-Diseño-Estructuración-Schema.md
│               ├── 📄 Modulo-03-Resolvers-DataLoader-Problema N+1.md
│               ├── 📄 Modulo-04-Autenticación-Autorización.md
│               ├── 📄 Modulo-05-Seguridad.md
│               ├── 📄 Modulo-06-Testing.md
│               ├── 📄 Modulo-07-Integracion-Fronted.md
│               └── 📄 Modulo-08-Arquitecturas-Distribuidas.md
│
├── 📁 testing/
│   └── 📁 unitario/
│       ├── 📄 JUnit.md
│       └── 📄 Mockito.md
│
└── 📁 version-control/
    └── 📄 Git.md
```
<!-- TREE:END -->

---

## 🗺️ Índice de Guías
<!-- INDEX:START -->
### Certifications — Comp TIA (`/certifications/compTIA`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| 01 | Fundamentales Seguridad | 🟢 Completo |
| 02 | Tipos Amenazas | 🟢 Completo |
| 03 | Criptográfia | 🟢 Completo |
| 04 | Gestion Identidades Accesos | 🟢 Completo |
| 05 | Arquitectura Red Empresarial | 🟢 Completo |
| 06 | Arquitectura Nube | 🟢 Completo |
| 07 | Gestion Activos Estrategias Redundancia | 🟢 Completo |
| 08 | Gestion Vulnerabilidades | 🟢 Completo |
| 09 | Evaluación Seguridad Red | 🟢 Completo |
| 10 | Seguridad Puntos Conexión | 🟢 Completo |
| 11 | Seguirdad Aplicaciones | 🟢 Completo |
| 12 | Incidentes Monitoreo | 🟢 Completo |
| 13 | Indicadores Actividad Maliciosa | 🟢 Completo |
| 14 | Gobernanza | 🟢 Completo |
| 15 | Gestion Riesgos | 🟢 Completo |
| 16 | Proteccion Datos | 🟢 Completo |

### Data — Redis (`/data/database/cache/redis`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| 01 | Instalaccion | 🟢 Completo |
| 02 | Arquitectura | 🟢 Completo |
| 03 | Datos Tipo | 🟢 Completo |
| 04 | Persistencia | 🟢 Completo |
| 05 | Seguridad ACL TLS | 🟢 Completo |
| 06 | Patrones Arquitectura | 🟢 Completo |
| 07 | Alta Disponibilidad Escalabilidad | 🟢 Completo |
| 08 | Optimizacion Rendimiento | 🟢 Completo |
| 09 | Observabilidad Troubleshooting | 🟢 Completo |
| 10 | Testing Validacion | 🟢 Completo |

### Infrastructure — Build Tools (`/infrastructure/build-tools`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| - | Maven | 🟢 Completo |

### Infrastructure — Containers (`/infrastructure/containers`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| - | Docker | 🟢 Completo |

### Infrastructure — Linux (`/infrastructure/os/linux`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| 01 | Fundamentos Arquitectura | 🟢 Completo |
| 02 | CLI Procesamiento Texto | 🟢 Completo |
| 03 | Administración Sistema | 🟢 Completo |
| 04 | Almacenamiento Redes | 🟢 Completo |
| 05 | Automatización Operaciones | 🟢 Completo |

### Infrastructure — Tomcat (`/infrastructure/server/tomcat`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| 01 | Arquitectura | 🟢 Completo |
| 02 | Instalacion | 🟢 Completo |
| 03 | Server Xml | 🟢 Completo |
| 04 | Conectores | 🟢 Completo |
| 05 | Web | 🟢 Completo |
| 06 | Seguirdad | 🟢 Completo |
| 07 | Pool | 🟢 Completo |
| 08 | Sesiones Clustering | 🟢 Completo |
| 09 | Rendimiento Monitorizacion | 🟢 Completo |
| 10 | Migracion | 🟢 Completo |

### Languages — Kotlin (`/languages/kotlin`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| 01 | Fundamentos Sintaxis | 🟢 Completo |
| 02 | Colecciones | 🟢 Completo |
| 03 | POO | 🟢 Completo |
| 04 | POO Avanzada | 🟢 Completo |
| 05 | Programacion Funcional | 🟢 Completo |
| 06 | Excepciones | 🟢 Completo |
| 07 | Corrutinas | 🟢 Completo |
| 08 | Anotaciones JVM | 🟢 Completo |

### Platforms — Mobile (`/platforms/mobile`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| - | Jetpack Compose | 🟢 Completo |

### Platforms — Graphql (`/platforms/web/backend/graphql`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| 01 | Fundamentos Arquitectura | 🟢 Completo |
| 02 | Diseño Estructuración Schema | 🟢 Completo |
| 03 | Resolvers Data Loader Problema N+1 | 🟢 Completo |
| 04 | Autenticación Autorización | 🟢 Completo |
| 05 | Seguridad | 🟢 Completo |
| 06 | Testing | 🟢 Completo |
| 07 | Integracion Fronted | 🟢 Completo |
| 08 | Arquitecturas Distribuidas | 🟢 Completo |

### Testing — Unitario (`/testing/unitario`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| - | Mockito | 🟢 Completo |
| - | JUnit | 🟢 Completo |

### Version Control (`/version-control`)

| Modulo | Guia | Estado |
|:-------|:-----|:------:|
| - | Git | 🟢 Completo |
<!-- INDEX:END -->

---

## 🚀 Uso Local

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/dev-handbook.git
cd dev-handbook

# Actualizar con los últimos apuntes
git pull origin main
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

# 5. Regenerar badges, estructura e indice de guias
scripts/Update-ReadmeStats.ps1
scripts/Update-ReadmeTree.ps1
scripts/Update-ReadmeStatus.ps1

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

El contador de guías y categorías, estructura e indices de guias se generan de manera automatica, para ello se usa los scripts definidos en `scripts/` — usa el que corresponda a tu entorno, ambos producen el mismo resultado:

| Entorno | Script | Cuándo usarlo |
|:--------|:-------|:---------------|
| Git Bash / WSL / Linux / macOS | `scripts/documento.sh` | Si ya tienes bash disponible |
| Windows sin bash | `scripts/documento.ps1` | PowerShell nativo, sin dependencias extra |

**Git Bash / WSL / Linux / macOS:**
```bash
bash scripts/documento.sh
```

**PowerShell (Windows nativo):**
```powershell
.\scripts\documento.ps1
```
Si PowerShell bloquea la ejecución (política de ejecución por defecto en Windows), ejecuta una vez por sesión:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```