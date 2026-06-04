> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Gestión de activos](#1-gestión-de-activos)
  - [Seguimiento de activos](#seguimiento-de-activos)
    - [Datos típicos en una base de datos de activos](#datos-típicos-en-una-base-de-datos-de-activos)
    - [Asignación/contabilización de activos](#asignacióncontabilización-de-activos)
    - [Métodos de enumeración de activos](#métodos-de-enumeración-de-activos)
    - [Adquisición/compra de activos — consideraciones de seguridad](#adquisicióncompra-de-activos--consideraciones-de-seguridad)
  - [Copias de seguridad de datos](#copias-de-seguridad-de-datos)
    - [Por qué las técnicas simples son insuficientes en entornos empresariales](#por-qué-las-técnicas-simples-son-insuficientes-en-entornos-empresariales)
    - [Funcionalidades críticas en soluciones empresariales de backup](#funcionalidades-críticas-en-soluciones-empresariales-de-backup)
    - [Desduplicación de datos](#desduplicación-de-datos)
    - [Frecuencia de copias de seguridad](#frecuencia-de-copias-de-seguridad)
    - [Copias en las instalaciones vs. fuera de las instalaciones](#copias-en-las-instalaciones-vs-fuera-de-las-instalaciones)
    - [Validación de recuperación](#validación-de-recuperación)
  - [Protección avanzada de datos](#protección-avanzada-de-datos)
    - [Instantáneas (Snapshots)](#instantáneas-snapshots)
    - [Replicación](#replicación)
    - [Registro por diario (Journaling)](#registro-por-diario-journaling)
    - [Cifrado de copias de seguridad](#cifrado-de-copias-de-seguridad)
  - [Destrucción segura de datos](#destrucción-segura-de-datos)
    - [Cuándo se requiere destrucción de datos](#cuándo-se-requiere-destrucción-de-datos)
    - [Métodos por tipo de medio](#métodos-por-tipo-de-medio)
    - [Métodos de sobrescritura para HDD](#métodos-de-sobrescritura-para-hdd)
    - [Enajenación de activos — conceptos clave](#enajenación-de-activos--conceptos-clave)
- [2. Estrategias de redundancia](#2-estrategias-de-redundancia)
  - [Continuidad de las operaciones](#continuidad-de-las-operaciones)
    - [COOP (Continuity of Operations Planning)](#coop-continuity-of-operations-planning)
    - [COOP vs. Continuidad del negocio (BC)](#coop-vs-continuidad-del-negocio-bc)
    - [Planificación de la capacidad](#planificación-de-la-capacidad)
  - [Riesgos de la planificación de la capacidad](#riesgos-de-la-planificación-de-la-capacidad)
    - [Riesgos para las personas](#riesgos-para-las-personas)
    - [Tecnologías para trabajo remoto](#tecnologías-para-trabajo-remoto)
    - [Riesgos de despidos (impacto en seguridad)](#riesgos-de-despidos-impacto-en-seguridad)
    - [Riesgos de planificación deficiente vs. sobreestimación](#riesgos-de-planificación-deficiente-vs-sobreestimación)
  - [Alta disponibilidad](#alta-disponibilidad)
    - [Definición y métricas](#definición-y-métricas)
    - [Tabla de "los nueves"](#tabla-de-los-nueves)
    - [Escalabilidad y elasticidad](#escalabilidad-y-elasticidad)
    - [Tolerancia a fallas y redundancia](#tolerancia-a-fallas-y-redundancia)
    - [Consideraciones del sitio (Site Resilience)](#consideraciones-del-sitio-site-resilience)
    - [La nube como DR (Disaster Recovery)](#la-nube-como-dr-disaster-recovery)
    - [Prueba de redundancia y HA](#prueba-de-redundancia-y-ha)
  - [Agrupamiento o clustering](#agrupamiento-o-clustering)
    - [Clúster vs. Balanceador de carga](#clúster-vs-balanceador-de-carga)
    - [IP Virtual (VIP — Virtual IP Address)](#ip-virtual-vip--virtual-ip-address)
    - [Clustering Activo/Pasivo (A/P) vs. Activo/Activo (A/A)](#clustering-activopasivo-ap-vs-activoactivo-aa)
    - [Configuraciones N+1 y N+M](#configuraciones-n1-y-nm)
    - [Agrupamiento de aplicaciones](#agrupamiento-de-aplicaciones)
  - [Redundancia de energía](#redundancia-de-energía)
    - [Cadena de suministro eléctrico (de mayor a menor urgencia)](#cadena-de-suministro-eléctrico-de-mayor-a-menor-urgencia)
    - [Componentes clave](#componentes-clave)
    - [Consideraciones sobre generadores](#consideraciones-sobre-generadores)
  - [Diversidad y defensa en profundidad](#diversidad-y-defensa-en-profundidad)
    - [Diversidad de plataformas](#diversidad-de-plataformas)
    - [Defensa en profundidad (Defense in Depth)](#defensa-en-profundidad-defense-in-depth)
    - [Diversidad de proveedores](#diversidad-de-proveedores)
    - [Estrategia multinube (Multi-cloud)](#estrategia-multinube-multi-cloud)
  - [Tecnologías de engaño](#tecnologías-de-engaño)
    - [Herramientas de engaño y disrupción](#herramientas-de-engaño-y-disrupción)
    - [Estrategias de disrupción](#estrategias-de-disrupción)
  - [Prueba de resiliencia](#prueba-de-resiliencia)
    - [Métodos de prueba](#métodos-de-prueba)
    - [Consecuencias de NO realizar pruebas](#consecuencias-de-no-realizar-pruebas)
    - [Documentación en continuidad del negocio](#documentación-en-continuidad-del-negocio)
- [3. Seguridad Física](#3-seguridad-física)
  - [Controles de seguridad física](#controles-de-seguridad-física)
    - [Implementación por zonas](#implementación-por-zonas)
  - [Plano del sitio, rejas e iluminación](#plano-del-sitio-rejas-e-iluminación)
    - [CPTED (Crime Prevention Through Environmental Design)](#cpted-crime-prevention-through-environmental-design)
    - [Barricadas y puntos de entrada/salida](#barricadas-y-puntos-de-entradasalida)
    - [Cercado (Fencing)](#cercado-fencing)
    - [Iluminación de seguridad](#iluminación-de-seguridad)
    - [Bolardos](#bolardos)
    - [Principios para estructuras existentes](#principios-para-estructuras-existentes)
  - [Puertas de entrada y cerraduras](#puertas-de-entrada-y-cerraduras)
    - [Tipos de cerradura](#tipos-de-cerradura)
    - [Vestíbulo de control de acceso (Mantrap / Airlock)](#vestíbulo-de-control-de-acceso-mantrap--airlock)
    - [Cerraduras de cable (Cable Locks)](#cerraduras-de-cable-cable-locks)
    - [Credenciales de acceso](#credenciales-de-acceso)
    - [PACS (Physical Access Control System — Sistema de Control de Acceso Físico)](#pacs-physical-access-control-system--sistema-de-control-de-acceso-físico)
  - [Cámaras y guardias de seguridad](#cámaras-y-guardias-de-seguridad)
    - [Guardias de seguridad](#guardias-de-seguridad)
    - [Videovigilancia (CCTV)](#videovigilancia-cctv)
    - [Vigilancia inteligente (IA y Machine Learning)](#vigilancia-inteligente-ia-y-machine-learning)
  - [Sistemas de alarma y sensores](#sistemas-de-alarma-y-sensores)
    - [Tipos de alarmas](#tipos-de-alarmas)
    - [Tipos de sensores](#tipos-de-sensores)
- [4. Glosario](#4-glosario)

---

# 1. Gestión de activos

La **gestión de activos** consiste en identificar, clasificar e inventariar todos los activos de TI (hardware, software, datos, personal) para:

- Conocer la infraestructura completa
- Monitorear actividades no autorizadas
- Identificar vulnerabilidades
- Garantizar parches y actualizaciones correctas
- Apoyar la respuesta a incidentes (aislar activos afectados rápidamente)

> **Analogía:** Imagina que eres el dueño de un almacén. La gestión de activos es el inventario: saber exactamente qué tienes, dónde está, quién es responsable y cuánto vale. Sin ese inventario, no puedes proteger lo que no sabes que tienes.

## Seguimiento de activos

### Datos típicos en una base de datos de activos

| Campo | Ejemplo |
|---|---|
| Tipo | Servidor, switch, laptop |
| Modelo | Dell PowerEdge R750 |
| Número de serie | ABC123XYZ |
| ID de activo | AS-0042 |
| Ubicación | Rack 3, CPD Madrid |
| Usuario(s) | dpto. Finanzas |
| Valor | 12.000 € |
| Info de servicio | Garantía hasta 2026 |

### Asignación/contabilización de activos

- **Asignación de propiedad:** Designar un individuo o equipo responsable de cada activo → cadena clara de responsabilidad.
- **Clasificación de activos:** Organizar por valor, sensibilidad o criticidad → permite aplicar controles de seguridad apropiados y priorizar mantenimiento.
- Ambos procesos requieren **revisiones periódicas** al cambiar el valor o relevancia del activo.

### Métodos de enumeración de activos

| Método | Descripción | Herramientas ejemplo |
|---|---|---|
| **Inventario manual** | Inspección física, registro de datos | Planillas, Excel |
| **Escaneo de red** | Descubrir dispositivos conectados automáticamente | `Nmap`, `Nessus`, `OpenVAS` |
| **Software de gestión** | Descubre, rastrea y cataloga activos (HW, SW, licencias) | Lansweeper, ManageEngine, SolarWinds |
| **CMDB** (Configuration Management Database) | Repositorio centralizado de activos, configs y relaciones | ServiceNow, BMC Remedy |
| **MDM** (Mobile Device Management) | Gestión de dispositivos móviles | Microsoft Intune, VMware Workspace ONE, MobileIron |
| **Descubrimiento en la nube** | Inventario de activos cloud | AWS Config, Azure Resource Graph, CloudAware |

### Adquisición/compra de activos — consideraciones de seguridad

- Seleccionar hardware/software con **cifrado incorporado**, arranque seguro y parches regulares.
- Trabajar con **proveedores de renombre** que prioricen la seguridad.
- Verificar integración con la infraestructura existente (firewalls, IDS, **SIEM** — Security Information and Event Management).
- Evaluar el **TCO** (Total Cost of Ownership — Costo Total de Propiedad): precio inicial + costos de mantenimiento + posibles incidentes de seguridad.

> **👉 Enfoque de Examen SY0-701:**
> CompTIA pregunta sobre qué herramienta usar para enumeración de activos en distintos contextos. Distingue bien: **Nmap** = escaneo de red activo; **CMDB** = repositorio centralizado de relaciones/configuraciones; **MDM** = exclusivo para dispositivos móviles. Un distractor clásico es confundir CMDB con una simple BBDD de inventario — la CMDB incluye también las **interdependencias** entre activos.

##  Copias de seguridad de datos

> **Analogía:** Una copia de seguridad es como el seguro del coche: no lo necesitas hasta que lo necesitas, y si no lo tienes en ese momento, el daño puede ser catastrófico.

### Por qué las técnicas simples son insuficientes en entornos empresariales

| Problema | Impacto |
|---|---|
| Escalabilidad limitada | No gestionan grandes volúmenes de datos |
| Problemas de rendimiento | Ralentizan aplicaciones durante el backup |
| Tiempos de recuperación largos | Tiempo de inactividad prolongado |
| Poca granularidad | No permiten recuperar archivos/BBDD individuales |
| Sin cifrado ni auditoría | Incumplen requisitos regulatorios |

### Funcionalidades críticas en soluciones empresariales de backup

- Soporte multientorno (virtual, físico, nube)
- **Desduplicación** y compresión (elimina datos redundantes → guarda una sola copia con punteros)
- Recuperación e instantáneas rápidas
- Protección contra **ransomware** y cifrado
- Restauración granular (archivo, carpeta, aplicación)
- Herramientas de monitoreo, alertas e informes
- Integración con virtualización, nube y almacenamiento

### Desduplicación de datos

Técnica que identifica bloques de datos idénticos y guarda solo una copia, creando referencias/punteros para las demás instancias. Se puede aplicar a nivel de archivo, bloque o byte.

### Frecuencia de copias de seguridad

Factores que la determinan:
- Requisitos regulatorios
- Volatilidad de los datos
- Rendimiento del sistema
- Capacidades de arquitectura
- Tolerancia al riesgo organizacional

### Copias en las instalaciones vs. fuera de las instalaciones

| Tipo | Ubicación | Ventaja | Desventaja |
|---|---|---|---|
| **On-site** | Mismo sitio que los sistemas | Recuperación rápida | Vulnerable a desastres físicos y ransomware |
| **Off-site** | Ubicación remota | Protección ante desastres, robos, ransomware | Recuperación más lenta |

> ⚠️ El **ransomware** frecuentemente ataca también la infraestructura de backup. Solución: backups **aislados** (air-gapped), desconectados físicamente de la red.

### Validación de recuperación

| Técnica | Descripción |
|---|---|
| **Prueba de recuperación completa** | Restaurar todo el sistema en entorno separado y verificar funcionalidad |
| **Prueba de recuperación parcial** | Restaurar archivos/carpetas/BBDD seleccionados |
| **Auditoría periódica de backups** | Verificar registros, horarios y configuraciones |
| **Simulación de DR** | Simular escenarios (fallo HW, ransomware) para evaluar preparación |

> ⚠️ Un backup con "100% de éxito" puede enmascarar problemas que solo se revelan al intentar recuperar. Los tiempos de recuperación suelen ser mucho más largos de lo estimado.

> **👉 Enfoque de Examen SY0-701:**
> Pregunta frecuente: ¿qué tipo de prueba valida que TODOS los sistemas se pueden restaurar? → **Prueba de recuperación completa**. El distractor más común es confundirla con la prueba parcial. También preguntan sobre backups aislados como defensa contra ransomware — recuerda que el término clave es **air-gapped**.

## Protección avanzada de datos

### Instantáneas (Snapshots)

Capturan el estado de un sistema en un momento específico.

| Tipo | Descripción | Ejemplo |
|---|---|---|
| **Snapshot de VM** | Captura estado completo de la máquina virtual (memoria, almacenamiento, config) | VMware vSphere, Microsoft Hyper-V |
| **Snapshot de sistema de archivos** | Captura estado del sistema de archivos | ZFS, Btrfs |
| **Snapshot de SAN** | Captura estado del volumen de almacenamiento a nivel de bloque | NetApp, Dell EMC |

> 💡 En Hyper-V, las snapshots se llaman **Checkpoints** (Puntos de control). Los tipos son:
> - **Production checkpoints:** usan tecnología de backup del SO invitado, consistencia de datos (sin info de apps en ejecución)
> - **Standard checkpoints:** capturan el estado actual de las aplicaciones

### Replicación

Crear y mantener **copias exactas** de datos en sistemas o ubicaciones diferentes.

- **Replicación sincrónica:** consistencia garantizada, sin desfase temporal.
- **Replicación asincrónica:** más rentable, ligeramente menos estricta en consistencia.

Tipos avanzados:
| Tipo | Descripción |
|---|---|
| **Replicación de SAN** | Duplica datos de una SAN a otra en tiempo real o casi real |
| **Replicación de VM** | Mantiene copia actualizada de una VM en host/ubicación diferente |
| **Registro por diario remoto** (Remote Journaling) | Guarda el diario de cambios en ubicación remota |

### Registro por diario (Journaling)

Los cambios en los datos se guardan en un **diario** separado. Permite:
- Rastrear modificaciones
- Volver a estados anteriores
- Recuperarse de cierres inesperados (identificar y deshacer transacciones incompletas)

Ejemplos: `JFS` (Journaled File System), `NTFS` con journaling habilitado.

### Cifrado de copias de seguridad

Razones fundamentales:
- **Seguridad:** datos ilegibles sin la clave de descifrado correcta
- **Privacidad:** protege datos confidenciales de clientes, propiedad intelectual
- **Cumplimiento normativo:** muchas regulaciones exigen protección de backups

> ⚠️ Los conjuntos de backup suelen pasarse por alto como vectores de ataque, pero contienen datos igual de sensibles que los sistemas primarios.

> **👉 Enfoque de Examen SY0-701:**
> Distingue **snapshot** (punto en el tiempo, reversible) de **replicación** (copia continua/en tiempo real). La replicación sincrónica garantiza consistencia; la asincrónica es más económica. Para Hyper-V, recuerda que "checkpoint" = snapshot. El examen puede preguntar qué técnica usarías si necesitas recuperarte de transacciones incompletas → **Journaling**.

## Destrucción segura de datos

> **Analogía:** Borrar un archivo no es como quemar un papel; es como arrancar la etiqueta de un cajón sin vaciar el cajón. Los datos siguen ahí hasta que algo nuevo los sobreescriba.

### Cuándo se requiere destrucción de datos

- Final del período de retención de datos
- Cumplimiento con **RGPD** (Reglamento General de Protección de Datos) o **HIPAA** (Health Insurance Portability and Accountability Act)
- Retiro de servicio de dispositivos
- Datos obsoletos que ocupan almacenamiento

### Métodos por tipo de medio

| Medio | Métodos efectivos |
|---|---|
| **HDD** (Hard Disk Drive) | Sobrescritura con ceros, patrones múltiples; relleno cero |
| **SSD** (Solid State Drive) | `ATA Secure Erase` (a nivel firmware); sobrescritura estándar NO es efectiva por nivelado de desgaste |

> ⚠️ En HDD, los archivos eliminados NO se borran completamente: los sectores se marcan como disponibles pero los datos persisten hasta ser sobrescritos.

### Métodos de sobrescritura para HDD

- **Relleno cero (1 pasada):** establece todos los bits a 0. Puede dejar patrones detectables.
- **Método de 3 pasadas:** pasada de ceros → pasada de unos → pasada pseudoaleatoria. Más seguro.
- **Agencias federales:** pueden requerir más de 3 pasadas.

### Enajenación de activos — conceptos clave

| Concepto | Descripción |
|---|---|
| **Sanitización** | Eliminar información confidencial del medio (borrado, desmagnetización, cifrado) para posible reutilización/donación |
| **Destrucción** | Eliminación física (trituración, aplastamiento, incineración) o electrónica (sobrescritura múltiple, desmagnetización) — datos irrecuperables |
| **Certificación** | Documentación y verificación del proceso; certificado de destrucción de proveedor acreditado (tercero imparcial) |

> 💡 Herramienta de referencia en el examen: **Active KillDisk** — software de borrado que implementa "One Pass Zeros" y métodos más avanzados.

> **👉 Enfoque de Examen SY0-701:**
> Pregunta trampa clásica: ¿qué método usar para sanitizar un SSD? La respuesta es **ATA Secure Erase**, NO la sobrescritura con múltiples pasadas (ineficaz por el wear leveling). Para HDD, la sobrescritura multipasada ES válida. También distingue **sanitización** (puede reutilizarse) de **destrucción** (irrecuperable). La **certificación** requiere tercero — no puedes certificarte a ti mismo de forma imparcial.

# 2. Estrategias de redundancia

La redundancia es el principio de "nunca un punto único de fallo". Como tener neumático de repuesto en el coche: no lo usas normalmente, pero cuando lo necesitas, es crítico.

Estrategias clave:
- **COOP** (Continuity of Operations Planning — Planificación de Continuidad de Operaciones)
- Clústeres de **HA** (High Availability — Alta Disponibilidad)
- Redundancia de energía
- Diversidad de proveedores y defensa en profundidad
- Pruebas periódicas (tabletop, failover, simulaciones)

## Continuidad de las operaciones

### COOP (Continuity of Operations Planning)

> **Analogía:** COOP es el plan de evacuación de un edificio: existe antes del incendio, define quién hace qué, y se practica regularmente para que funcione cuando sea necesario.

Elementos clave de un plan COOP:
- Identificar funciones comerciales críticas
- Establecer prioridades y recursos necesarios
- Crear redundancia para sistemas y datos de TI
- Definir modalidades alternativas de trabajo (remoto, coubicación)
- Protocolos claros de comunicación y toma de decisiones
- **Pruebas y actualizaciones periódicas**

### COOP vs. Continuidad del negocio (BC)

| Aspecto | COOP | BC (Business Continuity) |
|---|---|---|
| **Alcance** | Funciones críticas de TI/operaciones | Toda la organización |
| **Marco temporal** | Respuesta inmediata | Largo plazo |
| **Enfoque** | Restaurar funciones críticas rápidamente | Resiliencia y viabilidad organizacional total |
| **Incluye** | Backups, failover, DR | Cadena de suministro, comunicación, cumplimiento legal, reputación |

> COOP es un **componente** de BC. BC es el concepto más amplio.

### Planificación de la capacidad

Proceso de evaluar necesidades actuales y futuras de recursos.

| Dimensión | Consideraciones |
|---|---|
| **Personas** | Cantidad, habilidades, brechas, capacitación |
| **Tecnología** | HW, SW, red; rendimiento, escalabilidad, confiabilidad |
| **Infraestructura** | Instalaciones físicas, energía, refrigeración, conectividad |

Métodos de planificación:
- **Análisis de tendencias:** examina datos históricos para identificar patrones
- **Modelado de simulación:** modelos computacionales para simular escenarios reales
- **Evaluación comparativa (Benchmarking):** compara métricas con estándares/mejores prácticas del sector

> **👉 Enfoque de Examen SY0-701:**
> La distinción COOP vs. BC aparece frecuentemente. Recuerda: COOP = respuesta inmediata y restauración de funciones críticas; BC = enfoque integral y largo plazo. El examen puede presentar un escenario y preguntar qué tipo de plan aplica. Distractor: confundir COOP con DR (Disaster Recovery) — DR es la recuperación técnica; COOP incluye también los procesos organizacionales.

## Riesgos de la planificación de la capacidad

### Riesgos para las personas

| Riesgo | Descripción |
|---|---|
| Personal insuficiente / brechas de habilidades | Recursos mal asignados o subutilizados |
| Dependencia en personas específicas | Vulnerabilidad si esa persona no está disponible |
| Resistencia al cambio | Obstaculiza operaciones de seguridad |

**Estrategias de mitigación:**

- **Capacitación combinada (Cross-training):** empleados desarrollan habilidades fuera de su rol principal → múltiples personas pueden realizar tareas críticas → flexibilidad y resiliencia.
- **Planes de trabajo remoto:** definen canales de comunicación, requisitos tecnológicos y expectativas para trabajo a distancia.
- **Estructuras alternativas de reporting:** relaciones de reporte de respaldo para evitar puntos únicos de fallo en la gestión.

### Tecnologías para trabajo remoto

| Tecnología | Función |
|---|---|
| **VPN** (Virtual Private Network) | Acceso seguro a red interna |
| Software de escritorio remoto | Acceso remoto a equipos de oficina |
| Herramientas cloud | Microsoft 365, Google Workspace, Dropbox, Slack |
| Videoconferencia | Zoom, Microsoft Teams, Webex |
| Mensajería instantánea | Slack, Teams, Discord |
| Sistemas telefónicos virtuales | Llamadas desde PC/móvil vía cloud |
| Gestión de proyectos | Trello, Asana, Jira |

### Riesgos de despidos (impacto en seguridad)

**Riesgos de ciberseguridad:**
- Empleados descontentos → acceso no autorizado o uso indebido de datos
- Pérdida de conocimiento experto → brechas de seguridad y errores de configuración
- Revocación inadecuada de accesos → vulnerabilidades persistentes

**Riesgos físicos:**
- Robo o sabotaje de activos físicos
- Acceso no autorizado si las credenciales no se revocan inmediatamente

**Mitigación:** procedimientos de desvinculación robustos, transferencia de conocimiento, revocación inmediata de accesos.

### Riesgos de planificación deficiente vs. sobreestimación

| Escenario | Consecuencias |
|---|---|
| **Subestimación de capacidad** | Sistemas sobrecargados, más vulnerables a DoS (Denial of Service), descuido de medidas de seguridad, inversión insuficiente en controles físicos |
| **Sobreestimación de capacidad** | Gastos innecesarios, ROI negativo, mayor consumo energético, mayor complejidad de gestión, costo de oportunidad |

> **👉 Enfoque de Examen SY0-701:**
> El examen pregunta sobre qué riesgos de seguridad introduce la mala planificación de capacidad. Los sistemas sobrecargados son más vulnerables a ataques **DoS**. También puede preguntar sobre qué hacer cuando un empleado es despedido — la respuesta correcta siempre incluye **revocación inmediata** de accesos físicos y lógicos.

## Alta disponibilidad

### Definición y métricas

**HA (High Availability — Alta Disponibilidad):** diseño de sistemas que permanecen operativos con tiempo de inactividad mínimo.

**MTD (Maximum Tolerable Downtime — Tiempo de Inactividad Máximo Tolerable):** métrica que expresa el requisito de disponibilidad para una función empresarial.

### Tabla de "los nueves"

| Nueves | Disponibilidad | Tiempo inactividad anual |
|---|---|---|
| Seis | 99,9999 % | 00:00:32 h |
| Cinco | 99,999 % | 00:05:15 h |
| Cuatro | 99,99 % | 00:52:34 h |
| Tres | 99,9 % | 08:45:36 h |
| Dos | 99 % | 87:36:00 h |

> Los sistemas críticos se describen típicamente como 24×7 o 24×365.

### Escalabilidad y elasticidad

| Concepto | Definición |
|---|---|
| **Escalabilidad** | Capacidad de aumentar recursos para satisfacer demanda manteniendo ratios de costo similares |
| **Escalado horizontal** | Agregar más recursos en paralelo (más servidores) |
| **Escalado vertical** | Aumentar la potencia de los recursos existentes (más RAM/CPU) |
| **Elasticidad** | Capacidad de abordar cambios de demanda **en tiempo real** — sin pérdida de servicio ante aumentos repentinos |

### Tolerancia a fallas y redundancia

- **Sistema tolerante a fallas:** puede experimentar fallos y continuar operando al mismo nivel de servicio.
- Se logra mediante **redundancia** de componentes críticos (puntos únicos de fallo).
- Un **componente redundante** no es necesario en operación normal, pero permite recuperación ante fallo de otro componente.

### Consideraciones del sitio (Site Resilience)

| Tipo de sitio | Descripción | Tiempo de activación |
|---|---|---|
| **Hot site** (sitio caliente) | Equipos operativos actualizados con datos en tiempo real, propiedad de la empresa | Casi inmediato |
| **Warm site** (sitio cálido) | Infraestructura lista pero requiere cargar el dataset más reciente antes de usar | Horas |
| **Cold site** (sitio frío) | Edificio vacío con contrato de arrendamiento; instalar equipos cuando se necesite | Días |

**Failover (Conmutación por error):** técnica que garantiza que un componente/dispositivo/sitio redundante asuma la funcionalidad del activo fallido de forma rápida.

**Dispersión geográfica:** distribuir sitios de recuperación en distintas ubicaciones para minimizar el impacto de desastres regionales.

### La nube como DR (Disaster Recovery)

Ventajas de usar cloud para redundancia de sitios:
- **Eficiencia en costos** (economías de escala)
- **Escalabilidad** sin aprovisionar en exceso
- **Diversidad geográfica** integrada
- **Implementación más rápida** que construir infraestructura propia
- **Gestión simplificada**
- **Mejoras en seguridad y cumplimiento normativo**

### Prueba de redundancia y HA

| Tipo de prueba | Descripción |
|---|---|
| **Pruebas de carga** | Validar rendimiento bajo cargas máximas; identificar cuellos de botella |
| **Pruebas de failover** | Provocar fallo intencionado para validar la transición a infraestructura secundaria |
| **Pruebas de sistemas de monitoreo** | Validar detección y respuesta efectivas ante fallas |

> **👉 Enfoque de Examen SY0-701:**
> Memoriza la tabla de "los nueves" — CompTIA pregunta cuánto tiempo de inactividad permite cierto nivel de disponibilidad. Diferencia clave: **hot site** = datos en tiempo real, activación inmediata; **cold site** = más barato, más lento. El distractor clásico es confundir **elasticidad** (tiempo real, automática) con **escalabilidad** (planificada, no necesariamente inmediata).

## Agrupamiento o clustering

> **Analogía:** Un clúster de servidores es como un equipo de médicos de guardia. Si un médico cae enfermo, otro toma su turno sin que el paciente (el cliente) lo note.

### Clúster vs. Balanceador de carga

| Concepto | Función |
|---|---|
| **Balanceador de carga** | Distribuye solicitudes entre nodos independientes; gestión de tráfico web |
| **Clúster** | Nodos que **comparten datos** entre sí; proporciona redundancia y HA para BBDD, servidores de archivos, etc. |

Para el cliente, el clúster **parece un único servidor**.

### IP Virtual (VIP — Virtual IP Address)

Cuando dos dispositivos (ej. dos balanceadores de carga) comparten una IP pública, esta se llama **dirección IP virtual, compartida o flotante**.

- Los nodos se identifican internamente por su IP "real"
- Protocolo de redundancia: **CARP** (Common Address Redundancy Protocol)
- Mecanismo de **heartbeat (latido):** detecta si el nodo activo falla para activar failover al nodo pasivo

### Clustering Activo/Pasivo (A/P) vs. Activo/Activo (A/A)

| Modo | Descripción | Ventaja | Desventaja |
|---|---|---|---|
| **A/P (Activo/Pasivo)** | Un nodo activo, otro en espera | Rendimiento no afectado durante failover | Mayor costo (capacidad no utilizada) |
| **A/A (Activo/Activo)** | Ambos nodos procesan simultáneamente | Utiliza capacidad máxima | En failover, el nodo restante carga más → degradación del rendimiento |

### Configuraciones N+1 y N+M

| Config | Descripción |
|---|---|
| **N+1** | 1 nodo pasivo compartido entre N nodos activos (ej. 5 activos + 1 pasivo) |
| **N+M** | M nodos pasivos compartidos entre N nodos activos (ej. 10 activos + 2-3 pasivos) |

Objetivo: reducir costos de hardware sin sacrificar toda la redundancia.

### Agrupamiento de aplicaciones

Permite que los servidores del clúster compartan **información de sesión** entre sí. Si un usuario inicia sesión en la instancia A y la siguiente petición va a la instancia B, esta puede acceder a las cookies/tokens de sesión — experiencia de usuario continua.

> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: ¿qué diferencia hay entre A/P y A/A? → En A/P el rendimiento no se degrada en failover pero hay coste ocioso; en A/A hay mejor utilización pero degradación al fallar un nodo. También preguntan sobre la VIP y el protocolo CARP. Distractor: confundir **balanceador de carga** (distribuye tráfico) con **clúster** (comparte datos y proporciona HA).

## Redundancia de energía

> **Analogía:** La redundancia de energía es como los generadores de un hospital: cuando falla la red eléctrica, los quirófanos no se apagan.

### Cadena de suministro eléctrico (de mayor a menor urgencia)

```
Red eléctrica → PDU → UPS → Servidor/Rack → PSU dual
                              ↑
                         Generador de backup (cuando UPS se agota)
```

### Componentes clave

| Componente | Descripción |
|---|---|
| **PSU dual** (Power Supply Unit) | Dos fuentes de alimentación por servidor; hot-swappable (reemplazable sin apagar) |
| **PDU** (Power Distribution Unit) | Unidad de distribución de energía; limpia señal, protege contra picos/sobretensiones, integra con UPS; las gestionadas permiten monitoreo remoto |
| **UPS** (Uninterruptible Power Supply) | Alimentación ininterrumpida; proporciona energía temporal (minutos a horas) para transición a generador o apagado controlado |
| **Generador** | Suministra energía a todo el edificio (días); usa gasoil, propano o gas natural |

### Consideraciones sobre generadores

- **Gasoil/propano:** almacenamiento seguro requerido; gasoil tiene vida útil de 18 meses - 2 años
- **Gas natural:** depende de suministro continuo (riesgo en desastres naturales)
- **Energías renovables:** solar, eólica, geotérmica, hidrógeno, hidráulica
- **Baterías a gran escala:** alternativa emergente (Tesla Powerpack)
- Los generadores se conectan mediante **interruptores de transferencia** (manuales o automáticos)

> ⚠️ Un generador **no puede conectarse lo suficientemente rápido** para responder a un corte de energía. Por eso el UPS es imprescindible: cubre el tiempo de transición. El UPS debe estar dimensionado para gestionar los requisitos durante ese proceso de transferencia.

> **👉 Enfoque de Examen SY0-701:**
> Pregunta directa: ¿por qué se necesita UPS si hay generador? → Porque el generador tarda en arrancar; el UPS cubre el intervalo. El examen también pregunta sobre el orden correcto: red → PDU → UPS → equipos, con el generador como respaldo del UPS. La **PSU de conexión en caliente** (hot-swappable) permite reemplazo sin apagar el sistema — concepto importante.

## Diversidad y defensa en profundidad

### Diversidad de plataformas

Usar múltiples tecnologías, sistemas operativos y componentes HW/SW en la infraestructura.

**Beneficio:** si un componente es comprometido, el resto permanece seguro. Un atacante necesita dominar múltiples plataformas y técnicas.

### Defensa en profundidad (Defense in Depth)

> **Analogía:** Como un castillo medieval: foso, murallas, torres, guardia interior, cámara acorazada. Ninguna capa es perfecta, pero juntas hacen el ataque muy costoso.

Implementar **múltiples capas** de protección en distintos niveles:

| Capa | Ejemplos |
|---|---|
| Perimetral | Firewalls, IDS (Intrusion Detection Systems) |
| Red | Segmentación, controles de acceso, monitoreo de tráfico |
| Endpoint | Antivirus, hardening de dispositivos, gestión de parches |
| Autenticación | **MFA** (Multi-Factor Authentication) |
| Humana | Capacitación en conciencia de seguridad |
| Respuesta | Planificación de respuesta a incidentes |
| Física | Controles de acceso físico |

### Diversidad de proveedores

| Beneficio | Descripción |
|---|---|
| **Ciberseguridad** | Evita punto único de fallo; una vulnerabilidad no compromete toda la infraestructura |
| **Resiliencia empresarial** | Evita vendor lock-in; continuidad si un proveedor falla/quiebra |
| **Innovación** | Perspectivas y tecnologías diversas → infraestructura más ágil |
| **Competencia** | Mejores precios y características |
| **Personalización** | Elegir la mejor solución para cada necesidad específica |
| **Gestión de riesgos** | Distribuye el riesgo entre múltiples proveedores |
| **Cumplimiento** | Algunos sectores lo requieren regulatoriamente |

### Estrategia multinube (Multi-cloud)

Usar múltiples proveedores de servicios cloud simultáneamente.

**Beneficios:**
- Diversifica el riesgo (fallo de un proveedor no compromete todo)
- Aprovecha funciones de seguridad únicas de cada proveedor
- Independencia de proveedor (evita vendor lock-in)
- Competencia saludable entre proveedores → mejores precios
- Optimización: elegir el mejor servicio para cada carga de trabajo

**Ejemplo práctico:** ecommerce con infraestructura principal en proveedor A, backups y DR en proveedor B, datos sensibles con proveedor C (certificaciones de cumplimiento), CDN con proveedor D, y analytics con proveedor E.

> **👉 Enfoque de Examen SY0-701:**
> Defensa en profundidad es un tema recurrente. Recuerda que **ninguna capa es perfecta por sí sola** — la fortaleza está en la combinación. Pregunta trampa: ¿qué es diversidad de proveedores? No es solo usar productos de distintas marcas — es una estrategia deliberada para **eliminar puntos únicos de fallo** a nivel de proveedor. Distractor: confundir estrategia multinube (múltiples proveedores cloud) con multi-región (mismo proveedor, múltiples regiones).

## Tecnologías de engaño

> **Analogía:** Las honeypots son como señuelos en una trampa de caza: parecen reales y atractivos, pero su propósito es detectar y estudiar al intruso, no al revés.

### Herramientas de engaño y disrupción

| Herramienta | Descripción |
|---|---|
| **Honeypot** | Sistema señuelo que imita sistemas/aplicaciones reales; monitorea actividad y recopila TTPs (Tactics, Techniques, Procedures) del atacante |
| **Honeynet** | Red de honeypots interconectados; simula una red completa más realista |
| **Honeyfile** | Archivo falso que aparenta contener información confidencial; detecta intentos de robo de datos |
| **Honeytoken** | Credenciales falsas u otros datos señuelo; distraen al atacante, activan alertas y revelan actividad del intruso |

**Objetivo:** aumentar el costo del ataque, inmovilizar recursos del adversario y recopilar inteligencia.

### Estrategias de disrupción

Usan técnicas de ofuscación para confundir al atacante:

- **Entradas DNS falsas:** enumerar hosts que no existen → desperdicia tiempo de reconocimiento
- **Servidor web con directorios señuelo:** páginas dinámicas falsas → ralentiza escaneos
- **Port triggering / spoofing con telemetría falsa:** reportar puertos como abiertos cuando no lo están → ralentiza escaneos de puertos
- **DNS sinkhole:** redirigir tráfico sospechoso a una red diferente (ej. honeynet) para análisis

> **👉 Enfoque de Examen SY0-701:**
> Memoriza las diferencias: **honeypot** = un sistema; **honeynet** = red de sistemas; **honeyfile** = archivo; **honeytoken** = credencial/dato. El **DNS sinkhole** es específicamente para **redirigir tráfico** sospechoso — no lo confundas con honeynet (que es la red de recepción). Pregunta típica: ¿qué tecnología usarías para detectar intentos de robo de credenciales? → **Honeytoken**.

## Prueba de resiliencia

> **Analogía:** Los simulacros de emergencia existen porque "recordar" el procedimiento no es lo mismo que "practicarlo". Las pruebas de resiliencia son esos simulacros para los sistemas de TI.

### Métodos de prueba

| Método | Descripción | Ejemplo |
|---|---|---|
| **Ejercicios tabletop** | Equipos discuten escenarios hipotéticos; evalúan planes de respuesta y comunicación | Simular ataque de ransomware en sala de reuniones |
| **Pruebas de failover** | Provocar intencionadamente el fallo de un sistema primario para validar la transición automática al secundario | Simular fallo del servidor de BBDD primario |
| **Simulaciones** | Experimentos controlados que replican escenarios reales; evalúan resiliencia en condiciones realistas | Ciberataque dirigido a infraestructura de red |
| **Pruebas de procesamiento en paralelo** | Ejecutar sistemas primario y de respaldo simultáneamente para validar sin interrumpir operaciones | Centro de datos de backup manejando el mismo tráfico que el primario |

### Consecuencias de NO realizar pruebas

- Sistemas y procedimientos no probados pueden fallar en incidentes reales
- Tiempo de inactividad prolongado → pérdida de datos y daño reputacional
- Mayores costos de recuperación y mitigación
- Sanciones regulatorias por incumplimiento de estándares
- Incapacidad para mantener la continuidad del negocio

### Documentación en continuidad del negocio

| Documento | Contenido |
|---|---|
| **Planes de prueba** | Objetivos, alcance, métodos, roles y responsabilidades |
| **Guiones de prueba (escenarios)** | Instrucciones paso a paso para ejecutar las pruebas |
| **Resultados de prueba** | Fortalezas, debilidades, lecciones aprendidas |
| **Evaluaciones de terceros** | ISO 22301, PCI DSS (Payment Card Industry Data Security Standard), SOC 2 |

> **👉 Enfoque de Examen SY0-701:**
> Distingue los cuatro tipos de prueba: **tabletop** = solo discusión (sin sistemas reales); **failover** = provoca fallo real; **simulación** = escenario controlado completo; **procesamiento en paralelo** = ambos sistemas activos simultáneamente. La prueba menos disruptiva es el **tabletop**; la más completa es la **simulación**. Estándar clave: **ISO 22301** = gestión de continuidad del negocio.

# 3. Seguridad Física

> **Analogía:** De nada sirve el mejor firewall del mundo si alguien puede entrar al CPD, conectar un USB y llevarse el servidor. La seguridad física es la primera y última línea de defensa.

La seguridad física protege personal, hardware, software, redes y datos de daños o pérdidas físicas. Incluye:
- Controles de acceso
- Videovigilancia (**CCTV** — Closed-Circuit Television)
- Controles ambientales
- Sensores de detección de intrusiones

**Principio fundamental:** una brecha física puede dar acceso directo a sistemas y datos, eludiendo todas las medidas de ciberseguridad.

## Controles de seguridad física

Los controles de acceso físico aplican los mismos principios que la seguridad lógica:

| Principio | Descripción |
|---|---|
| **Autenticación** | Listas de acceso y mecanismos de identificación para personas autorizadas |
| **Autorización** | Barreras que controlan el acceso a través de puntos definidos de entrada/salida |
| **Registro (Logging)** | Registro de cuándo se usan los puntos de acceso; detección de brechas |

### Implementación por zonas

La seguridad física se implementa mediante **zonas progresivamente más restrictivas**:

```
Zona pública → Zona semiprivada → Zona privada → Zona crítica (CPD)
     ↑                ↑                ↑                ↑
   Menor                                             Mayor
  restricción                                      restricción
```

Cada zona está separada por barreras con uno o más mecanismos de control en los puntos de entrada/salida.

> **👉 Enfoque de Examen SY0-701:**
> La seguridad física NO es solo un complemento de la ciberseguridad — es parte integral de ella. CompTIA pregunta sobre los tres principios (autenticación, autorización, registro) en contexto físico. Recuerda que las **zonas** deben ser progresivamente más restrictivas hacia adentro.

## Plano del sitio, rejas e iluminación

### CPTED (Crime Prevention Through Environmental Design)

**Seguridad física a través del diseño ambiental:** usar el entorno construido para mejorar la seguridad y prevenir el delito. Se incorpora en el diseño de espacios para que los elementos de seguridad sean naturales, no evidentes y rentables.

### Barricadas y puntos de entrada/salida

- Propósito: **canalizar** a las personas a través de puntos definidos, no bloquear absolutamente.
- Cada punto de entrada debe tener un mecanismo de autenticación.
- Mecanismos de vigilancia detectan intentos de penetración por otros medios.
- Usos especiales: **bolardos** y puestos de seguridad para proteger contra ataques con vehículos.

### Cercado (Fencing)

Un cercado de seguridad debe ser:
- **Transparente:** guardias pueden observar intentos de intrusión
- **Robusto:** difícil de cortar
- **Seguro contra escalado:** alto, con alambre de púas o de cuchillas

> ⚠️ Desventaja: puede dar apariencia intimidante. Los edificios que atienden público pueden preferir métodos más discretos.

### Iluminación de seguridad

Propósitos:
- **Percepción de seguridad** (especialmente de noche)
- **Disuasión** (dificulta intrusiones)
- **Facilitación de vigilancia** (cámaras y guardias)

Consideraciones de diseño:
- Niveles generales de luz
- Iluminación de superficies específicas (ej. para reconocimiento facial)
- Evitar áreas de sombra y deslumbramiento

### Bolardos

Postes verticales cortos (acero, concreto) instalados a intervalos en perímetros/entradas.
- Pueden ser **fijos o retráctiles** (algunos controlados remotamente)
- Protegen peatones del tráfico
- Evitan acceso no autorizado de vehículos
- Protegen infraestructuras críticas (edificios gubernamentales, aeropuertos, estadios)

### Principios para estructuras existentes

- Ubicar zonas seguras (salas de equipos) **lo más profundo posible** dentro del edificio
- Diseño de **zona desmilitarizada física:** áreas públicas alejadas de zonas seguras
- Señalización visible en áreas públicas → disuasión
- Puntos de entrada a zonas seguras: **discretos** (no mostrar mecanismos de seguridad)
- **Camuflaje industrial:** edificios de alto valor que pasan desapercibidos
- Minimizar tráfico entre zonas; flujo "dentro y fuera" no "a través"
- Visibilidad alta en áreas públicas → dificulta uso encubierto de puertos de red
- Pantallas y dispositivos de entrada **alejados de ventanas y pasillos**
- **Vidrio unidireccional** (solo visible desde adentro hacia afuera)

> **👉 Enfoque de Examen SY0-701:**
> CPTED es un concepto que aparece en preguntas sobre diseño de seguridad preventiva. Los **bolardos** son específicamente para proteger contra ataques vehiculares. Recuerda la regla de las zonas: lo más crítico debe estar más protegido y más al interior. La pregunta trampa suele ser: ¿qué elemento protege contra que un vehículo embista un edificio? → **Bolardos** (no cercas, no cámaras).

## Puertas de entrada y cerraduras

### Tipos de cerradura

| Tipo | Descripción | Ejemplos |
|---|---|---|
| **Física** | Cerradura convencional con llave | Cerraduras de alta seguridad con mayor resistencia al forzado |
| **Electrónica** | PIN en teclado; también llamada de cifrado, combinación o sin llave. Las inteligentes: tarjeta magnética o lector de proximidad (key fob, smart-card) | Teclados numéricos, lectores de tarjeta |
| **Biométrica** | Integrada con escáner biométrico (huella dactilar, iris, reconocimiento facial) | Escáner de huella + cerradura |

### Vestíbulo de control de acceso (Mantrap / Airlock)

Dos puertas interbloqueadas que permiten el paso de **una persona a la vez**:

1. Persona autentica en la primera puerta (lector de tarjeta / biométrico)
2. Primera puerta se abre → persona entra al vestíbulo
3. Primera puerta se cierra completamente
4. Segunda puerta se abre solo cuando la primera está cerrada

**Propósito:** prevenir **tailgating** (piggybacking — seguir a alguien autorizado sin autenticarse).

Usos: centros de datos, edificios gubernamentales, instituciones financieras.

### Cerraduras de cable (Cable Locks)

Se sujetan al chasis del dispositivo mediante una ranura de seguridad (**Kensington slot**). Además de fijar el chasis a un rack o escritorio, impiden abrir el chasis sin retirar primero el cable.

### Credenciales de acceso

Tarjetas con:
- **Banda magnética**
- Chip **RFID** (Radio Frequency Identification — Identificación por Radiofrecuencia)
- **NFC** (Near Field Communication — Comunicación de Campo Cercano)

El lector verifica la credencial con un sistema de control → si es válida y autorizada → desbloquea el acceso.

### PACS (Physical Access Control System — Sistema de Control de Acceso Físico)

Sistema integral que combina hardware y software:
- Tarjetas/credenciales de acceso
- Lectores de tarjetas
- Paneles de control de acceso
- Red de control centralizada

Capacidades del PACS:
- **Registro de actividades** (hora, ubicación, identidad de cada evento de acceso)
- Identificación del titular (nombre, puesto, foto)
- Datos para auditorías e investigaciones de seguridad
- Planificación de evacuaciones de emergencia

> **👉 Enfoque de Examen SY0-701:**
> El **mantrap/vestíbulo de control de acceso** es la solución específica para prevenir **tailgating** — memoriza este par. RFID y NFC son las tecnologías de credenciales más preguntadas. El PACS es el sistema que integra todo y proporciona el log de auditoría físico. Distractor: confundir tailgating (físico, seguir a alguien) con piggybacking (que es el mismo concepto con otro nombre).

## Cámaras y guardias de seguridad

### Guardias de seguridad

**Ventajas:**
- Verificación de identidad en puntos de control
- Elemento de disuasión visual
- Juicio e intuición humana ante situaciones anómalas
- Respuesta inmediata

**Desventajas:**
- Alto costo
- No pueden estar en zonas donde no tienen la autorización de seguridad adecuada
- Requieren capacitación y evaluación continua

### Videovigilancia (CCTV)

**Ventajas:**
- Más económica que guardias en cada acceso
- Registro de movimientos y accesos
- Elemento disuasorio eficaz

**Desventajas:**
- Tiempos de respuesta más largos
- Requiere personal para monitorear las imágenes

**Arquitectura técnica:**
- Cámaras conectadas a **multiplexor** (cableado coaxial) → pantallas de monitoreo + grabación
- Sistemas modernos: cámaras IP en red de datos estándar

### Vigilancia inteligente (IA y Machine Learning)

| Capacidad | Descripción |
|---|---|
| **Reconocimiento de movimiento** | Tecnología de identificación de la marcha; alerta si alguien se mueve en patrón no autorizado |
| **Detección de objetos** | Detecta cambios en el entorno (falta de un servidor, dispositivo desconocido en puerto de red) |
| **Drones/UAV** (Unmanned Aerial Vehicles) | Cámaras aéreas que cubren áreas más amplias que patrullas terrestres |

> **👉 Enfoque de Examen SY0-701:**
> La pregunta típica compara guardias vs. CCTV en términos de costo-efectividad. Los guardias son más caros pero tienen mejor tiempo de respuesta y juicio situacional. CCTV es más económica a escala pero depende de que alguien monitoree. Los **drones/UAV** son un elemento emergente en vigilancia perimetral.

## Sistemas de alarma y sensores

Las alarmas son controles de **detección y disuasión**: alertan del problema y desincentivan el acceso no autorizado. Suelen integrarse con sistemas de control de acceso, CCTV y sensores de movimiento.

### Tipos de alarmas

| Tipo | Funcionamiento | Uso típico |
|---|---|---|
| **Circuito** | Suena cuando el circuito se abre o cierra (apertura de puerta/ventana, corte de cerca). Circuito cerrado = más seguro (no se puede anular cortando el circuito) | Perímetro, puertas, ventanas |
| **Detección de movimiento** | Vinculada a detector de movimiento (radio por microondas o **PIR** — Passive Infrared — Infrarrojo Pasivo) | Espacios normalmente vacíos |
| **Detección de ruido** | Activada por micrófono + análisis de IA para reducir falsos positivos | Interior de instalaciones |
| **Proximidad** | Usa RFID para rastrear objetos etiquetados; detecta intentos de retirar equipo | Salas de servidores, almacenes |
| **Coacción** | Activada manualmente por personal amenazado (colgantes inalámbricos, activadores ocultos, código PIN especial) | Personal en áreas públicas |

> 💡 Algunas cerraduras electrónicas pueden programarse con un **código de coacción** diferente al código normal: abre la puerta pero alerta al personal de seguridad.

### Tipos de sensores

| Sensor | Tecnología | Aplicación típica |
|---|---|---|
| **Infrarrojo** | Detecta cambios en patrones de calor causados por movimiento | Sistemas de seguridad residenciales y comerciales; activa alarmas o luces |
| **Presión** | Instalado en pisos/alfombras; activado por peso | Áreas de alta seguridad; conteo de tráfico en retail |
| **Microondas** | Emite pulsos y mide reflexión de objetos en movimiento; combinado con PIR en sensores de **doble tecnología** → reduce falsos positivos | Grandes áreas al aire libre (estacionamientos, áreas valladas) |
| **Ultrasónico** | Emite ondas de sonido por encima del rango humano y mide el tiempo de retorno | Sistemas de iluminación automatizada (enciende/apaga luces según ocupación) |

> 💡 Los sensores de **doble tecnología** (infrarrojo + microondas) requieren que AMBOS se activen simultáneamente → menor tasa de falsas alarmas.

> **👉 Enfoque de Examen SY0-701:**
> Memoriza los tipos de alarma y sus casos de uso: **PIR** = movimiento por calor; **RFID de proximidad** = robo de equipo; **coacción** = personal amenazado. El sensor de **doble tecnología** (microondas + PIR) es la respuesta cuando la pregunta menciona reducción de falsos positivos. Pregunta trampa: ¿qué tipo de alarma es más segura entre circuito abierto y cerrado? → **Circuito cerrado** (no se anula cortando el cable).

# 4. Glosario

| Acrónimo | Significado |
|---|---|
| **HA** | High Availability — Alta Disponibilidad |
| **COOP** | Continuity of Operations Planning — Planificación de Continuidad de Operaciones |
| **BC** | Business Continuity — Continuidad del Negocio |
| **DR** | Disaster Recovery — Recuperación ante Desastres |
| **MTD** | Maximum Tolerable Downtime — Tiempo de Inactividad Máximo Tolerable |
| **SIEM** | Security Information and Event Management — Gestión de Eventos e Información de Seguridad |
| **TCO** | Total Cost of Ownership — Costo Total de Propiedad |
| **CMDB** | Configuration Management Database — Base de Datos de Gestión de la Configuración |
| **MDM** | Mobile Device Management — Gestión de Dispositivos Móviles |
| **UPS** | Uninterruptible Power Supply — Sistema de Alimentación Ininterrumpida |
| **PDU** | Power Distribution Unit — Unidad de Distribución de Energía |
| **PSU** | Power Supply Unit — Unidad de Fuente de Alimentación |
| **CARP** | Common Address Redundancy Protocol — Protocolo Común de Redundancia de Direcciones |
| **VIP** | Virtual IP Address — Dirección IP Virtual |
| **CCTV** | Closed-Circuit Television — Televisión de Circuito Cerrado |
| **PIR** | Passive Infrared — Infrarrojo Pasivo |
| **RFID** | Radio Frequency Identification — Identificación por Radiofrecuencia |
| **NFC** | Near Field Communication — Comunicación de Campo Cercano |
| **PACS** | Physical Access Control System — Sistema de Control de Acceso Físico |
| **CPTED** | Crime Prevention Through Environmental Design — Seguridad a través del Diseño Ambiental |
| **MFA** | Multi-Factor Authentication — Autenticación Multifactor |
| **SAN** | Storage Area Network — Red de Área de Almacenamiento |
| **VM** | Virtual Machine — Máquina Virtual |
| **HDD** | Hard Disk Drive — Disco Duro Magnético |
| **SSD** | Solid State Drive — Unidad de Estado Sólido |
| **RGPD** | Reglamento General de Protección de Datos (equivalente europeo al GDPR) |
| **HIPAA** | Health Insurance Portability and Accountability Act |
| **UAV** | Unmanned Aerial Vehicle — Vehículo Aéreo No Tripulado (Dron) |
| **JFS** | Journaled File System — Sistema de Archivos con Registro por Diario |
| **NTFS** | New Technology File System — Sistema de Archivos de Nueva Tecnología |
| **ROI** | Return on Investment — Retorno de la Inversión |
| **DoS** | Denial of Service — Denegación de Servicio |
