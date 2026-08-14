> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1 Respuesta a Incidentes y Monitoreo](#1-respuesta-a-incidentes-y-monitoreo)
- [2. Respuesta a Incidentes](#2-respuesta-a-incidentes)
  - [Proceso de Respuesta a Incidentes](#proceso-de-respuesta-a-incidentes)
  - [Preparación](#preparación)
    - [La Infraestructura de Ciberseguridad](#la-infraestructura-de-ciberseguridad)
    - [Equipo de Respuesta a Incidentes Cibernéticos](#equipo-de-respuesta-a-incidentes-cibernéticos)
    - [Plan de Comunicación](#plan-de-comunicación)
    - [Gestión de las Partes Interesadas](#gestión-de-las-partes-interesadas)
    - [Plan de Respuesta a Incidentes (IRP)](#plan-de-respuesta-a-incidentes-irp)
- [3. Detección](#3-detección)
  - [Análisis](#análisis)
    - [Factores de Impacto para Determinar Prioridad](#factores-de-impacto-para-determinar-prioridad)
    - [Categoría e Inteligencia de Amenazas](#categoría-e-inteligencia-de-amenazas)
    - [Cadena de Eliminación Cibernética (Cyber Kill Chain)](#cadena-de-eliminación-cibernética-cyber-kill-chain)
    - [Manuales de Estrategias (Playbooks)](#manuales-de-estrategias-playbooks)
  - [Contención](#contención)
    - [Contención Basada en Aislamiento](#contención-basada-en-aislamiento)
    - [Contención Basada en Segmentación](#contención-basada-en-segmentación)
  - [Erradicación y Recuperación](#erradicación-y-recuperación)
    - [Erradicación](#erradicación)
  - [Lecciones Aprendidas](#lecciones-aprendidas)
    - [Análisis de Causa Raíz (Root Cause Analysis — RCA)](#análisis-de-causa-raíz-root-cause-analysis--rca)
  - [Pruebas y Capacitación](#pruebas-y-capacitación)
    - [Pruebas (Testing)](#pruebas-testing)
    - [Capacitación (Training)](#capacitación-training)
  - [Caza de Amenazas (Threat Hunting)](#caza-de-amenazas-threat-hunting)
  - [Análisis Forense Digital](#análisis-forense-digital)
    - [Debido Proceso y Retención Legal](#debido-proceso-y-retención-legal)
      - [Evidencia Digital — Características](#evidencia-digital--características)
      - [Debido Proceso (Due Process)](#debido-proceso-due-process)
      - [Retención Legal (Legal Hold)](#retención-legal-legal-hold)
    - [Adquisición](#adquisición)
      - [Orden de Volatilidad](#orden-de-volatilidad)
    - [Adquisición de Memoria del Sistema](#adquisición-de-memoria-del-sistema)
      - [Marco de Volatilidad (Volatility Framework)](#marco-de-volatilidad-volatility-framework)
    - [Adquisición de Imágenes de Disco](#adquisición-de-imágenes-de-disco)
      - [Tres Estados de Dispositivo para Adquisición](#tres-estados-de-dispositivo-para-adquisición)
      - [Herramienta Principal — Comando `dd`](#herramienta-principal--comando-dd)
    - [Preservación](#preservación)
      - [Integridad de la Evidencia y No Repudio](#integridad-de-la-evidencia-y-no-repudio)
      - [Bloqueador de Escritura (Write Blocker)](#bloqueador-de-escritura-write-blocker)
      - [Cadena de Custodia (Chain of Custody)](#cadena-de-custodia-chain-of-custody)
    - [Elaboración de Informes](#elaboración-de-informes)
      - [Principios Éticos del Análisis Forense](#principios-éticos-del-análisis-forense)
      - [ESI (Información Almacenada Electrónicamente — Electronically Stored Information)](#esi-información-almacenada-electrónicamente--electronically-stored-information)
      - [Descubrimiento Electrónico (e-Discovery)](#descubrimiento-electrónico-e-discovery)
  - [Fuentes de Datos](#fuentes-de-datos)
    - [Fuentes de Datos, Paneles e Informes](#fuentes-de-datos-paneles-e-informes)
      - [Las "5 V" de los Grandes Datos (Big Data)](#las-5-v-de-los-grandes-datos-big-data)
      - [Paneles (Dashboards)](#paneles-dashboards)
      - [Informes Automatizados](#informes-automatizados)
    - [Datos de Registro](#datos-de-registro)
      - [Formato Syslog](#formato-syslog)
      - [Event Viewer de Windows](#event-viewer-de-windows)
      - [Registros de Linux](#registros-de-linux)
      - [Registros de macOS](#registros-de-macos)
      - [Agregación de Registros con SIEM](#agregación-de-registros-con-siem)
    - [Registros del Sistema Operativo del Host](#registros-del-sistema-operativo-del-host)
    - [Registros de Aplicaciones y de Endpoints](#registros-de-aplicaciones-y-de-endpoints)
      - [Registros de Aplicaciones](#registros-de-aplicaciones)
      - [Registros de Puntos de Conexión (Endpoint Logs)](#registros-de-puntos-de-conexión-endpoint-logs)
      - [Escaneos de Vulnerabilidades](#escaneos-de-vulnerabilidades)
    - [Fuentes de Datos en Red](#fuentes-de-datos-en-red)
      - [Registros de Red](#registros-de-red)
      - [Registros de Cortafuegos](#registros-de-cortafuegos)
      - [Registros IPS/IDS](#registros-ipsids)
    - [Captura de Tráfico de Red](#captura-de-tráfico-de-red)
    - [Metadatos](#metadatos)
      - [Metadatos de Archivos](#metadatos-de-archivos)
      - [Metadatos Web](#metadatos-web)
      - [Metadatos de Correo Electrónico](#metadatos-de-correo-electrónico)
  - [Herramientas de Alerta y Monitoreo](#herramientas-de-alerta-y-monitoreo)
    - [Gestión de Información y Eventos de Seguridad — SIEM](#gestión-de-información-y-eventos-de-seguridad--siem)
      - [Métodos de Recopilación](#métodos-de-recopilación)
      - [Agregación de Registros](#agregación-de-registros)
    - [Actividades de Alerta y Monitoreo](#actividades-de-alerta-y-monitoreo)
      - [Alerta (Alerting)](#alerta-alerting)
      - [Elaboración de Informes](#elaboración-de-informes-1)
      - [Archivado](#archivado)
    - [Ajuste de Alertas (Alert Tuning)](#ajuste-de-alertas-alert-tuning)
      - [Problema — Fatiga de Alertas (Alert Fatigue)](#problema--fatiga-de-alertas-alert-fatigue)
      - [Equilibrio Falsos Positivos vs. Falsos Negativos](#equilibrio-falsos-positivos-vs-falsos-negativos)
      - [Técnicas de Ajuste de Alertas](#técnicas-de-ajuste-de-alertas)
    - [Supervisión de la Infraestructura](#supervisión-de-la-infraestructura)
      - [Monitores de Red](#monitores-de-red)
      - [NetFlow](#netflow)
    - [Aplicaciones y Sistemas de Monitoreo](#aplicaciones-y-sistemas-de-monitoreo)
      - [Monitores y Registros del Sistema](#monitores-y-registros-del-sistema)
      - [Monitores de Aplicaciones y de la Nube](#monitores-de-aplicaciones-y-de-la-nube)
      - [Escáneres de Vulnerabilidades](#escáneres-de-vulnerabilidades)
      - [Antivirus (A-V)](#antivirus-a-v)
      - [Prevención de Pérdida de Datos (DLP — Data Loss Prevention)](#prevención-de-pérdida-de-datos-dlp--data-loss-prevention)
    - [Indicadores de Referencia (Benchmarks)](#indicadores-de-referencia-benchmarks)
      - [SCAP (Protocolo de Automatización de Contenido de Seguridad — Security Content Automation Protocol)](#scap-protocolo-de-automatización-de-contenido-de-seguridad--security-content-automation-protocol)
      - [Análisis de Cumplimiento](#análisis-de-cumplimiento)
- [4. Glosario](#4-glosario)
- [5.  Relaciones Clave](#5--relaciones-clave)

---

# 1 Respuesta a Incidentes y Monitoreo

La **respuesta a incidentes (IR, Incident Response)** en el día a día consiste en:
- Investigar alertas generadas por sistemas de monitoreo.
- Atender problemas reportados por usuarios.
- Ejecutar políticas y procedimientos formales con asistencia de controles técnicos.

La **ciencia forense digital** complementa la IR mediante la captura, preservación y análisis **paciente** de evidencia con métodos verificables, para uso en acciones legales o contrainteligencia.

> **Analogía:** La respuesta a incidentes es como los servicios de emergencia de una ciudad. El SIEM (Sistema de Gestión de Información y Eventos de Seguridad) es la central de despacho que recibe todas las llamadas (eventos), el CIRT es el equipo de bomberos/policía que responde, y el forense digital es la unidad de investigación criminal que llega después.

# 2. Respuesta a Incidentes

Una respuesta efectiva se rige por **políticas y procedimientos formales** que asignan funciones y responsabilidades claras al equipo de respuesta.

## Proceso de Respuesta a Incidentes

**Definición de incidente:** Violación exitosa *o* intento de violación de las propiedades de seguridad (**CIA**: Confidencialidad, Integridad, Disponibilidad) de un activo.

La **política de respuesta a incidentes (IR)** establece recursos, procesos y pautas. Cada gestión de incidente sigue el **ciclo de vida** de 7 pasos de CompTIA:

```
Preparación → Detección → Análisis → Contención → Erradicación → Recuperación → Lecciones Aprendidas
     ↑_______________________________________________|
```

| # | Fase | Descripción clave |
|---|------|-------------------|
| 1 | **Preparación** | Hardening de sistemas, redacción de políticas, establecimiento de comunicaciones confidenciales, recursos de respuesta |
| 2 | **Detección** | Descubrir indicadores de actividad maliciosa (automatizado, caza de amenazas, reporte de empleados) |
| 3 | **Análisis** | Determinar si ocurrió un incidente y evaluar gravedad/prioridad |
| 4 | **Contención** | Limitar alcance y magnitud; proteger datos minimizando impacto en clientes |
| 5 | **Erradicación** | Eliminar la causa raíz; restaurar el sistema a estado seguro (parches, configs seguras) |
| 6 | **Recuperación** | Reintegrar el sistema al flujo de negocio; monitorear de cerca para detectar recurrencias |
| 7 | **Lecciones Aprendidas** | Analizar incidente y respuesta; documentar para mejorar el ciclo completo |

> ⚠️ **Nota importante:** El proceso puede necesitar iterar entre Detección → Contención → Erradicación → Recuperación varias veces antes de resolver completamente el incidente.

> **👉 Enfoque de Examen SY0-701:** CompTIA exige conocer el **orden exacto** de las 7 fases. El distractor más común es colocar "Análisis" antes de "Detección" o confundir el orden de Erradicación/Recuperación. Recuerda el acrónimo **P-D-A-C-E-R-L** (Preparación, Detección, Análisis, Contención, Erradicación, Recuperación, Lecciones). Las preguntas de escenario te presentarán un incidente y preguntarán en qué fase se encuentra o qué acción corresponde a continuación.

## Preparación

> **Analogía:** La preparación es como el entrenamiento de los bomberos antes de que haya un incendio. No esperas al fuego para comprar mangueras.

### La Infraestructura de Ciberseguridad

Conjunto de herramientas de hardware y software que facilitan la detección, análisis forense y gestión de casos:

- **Herramientas de detección de incidentes:** Automatizan la recopilación y análisis de tráfico de red, estado del sistema y datos de registro.
- **Herramientas forenses digitales:** Adquieren y validan datos de memoria del sistema y sistemas de archivos.
- **Herramientas de gestión de casos:** Base de datos para registrar detalles del incidente y coordinar actividades de respuesta.

> 💡 Esta funcionalidad suele implementarse en un único paquete: **SIEM** (Gestión de Información y Eventos de Seguridad) + **SOAR** (Orquestación, Automatización y Respuesta de Seguridad).

### Equipo de Respuesta a Incidentes Cibernéticos

El equipo se describe con distintos nombres:

| Acrónimo | Nombre completo |
|----------|----------------|
| **CIRT** | Computer Incident Response Team (Equipo de Respuesta a Incidentes Informáticos) |
| **CSIRT** | Computer Security Incident Response Team |
| **CERT** | Computer Emergency Response Team (Equipo de Respuesta a Emergencias Informáticas) |
| **SOC** | Security Operations Center (Centro de Operaciones de Seguridad) |

**Estructura del equipo:**
- **Ejecutivo sénior:** Toma de decisiones y autorización tras incidentes graves.
- **Gerentes:** Operación diaria del CIRT, coordinación con otros departamentos.
- **Analistas y técnicos:** Priorizan casos y mitigan incidentes menores de forma autónoma.

**Otras divisiones involucradas:**
- **Asuntos legales:** Evalúa respuesta desde perspectiva de cumplimiento legal.
- **RR. HH. (Recursos Humanos):** Gestiona efectos en contratos de empleados, legislación laboral, problemas organizacionales.
- **Relaciones Públicas:** Gestiona reacciones negativas en prensa y redes sociales.

> 📌 Algunas organizaciones **subcontratan** funciones del CIRT a agencias externas (proveedores de respuesta a incidentes), especialmente útil para amenazas internas.

### Plan de Comunicación

- Establecer **líneas claras de comunicación** para informar sobre incidentes.
- Evitar la **divulgación involuntaria** más allá del equipo autorizado.
- **No alertar a los adversarios** sobre medidas de contención/remediación.
- Usar un método **fuera de banda** que no pueda ser interceptado (el correo corporativo es riesgoso).
- Compartir información **solo a partes de confianza** en la lista de contactos.

### Gestión de las Partes Interesadas

- No publicar incidentes en prensa/redes sociales fuera de comunicaciones previstas.
- Considerar **obligaciones de notificación** a afectados y reguladores.
- Gestionar el impacto de marketing y relaciones públicas.

### Plan de Respuesta a Incidentes (IRP)

El **IRP (Incident Response Plan)** es el resultado de la preparación: enumera procedimientos, contactos y recursos disponibles para diversas categorías de incidentes.

> **👉 Enfoque de Examen SY0-701:** Preguntas sobre preparación frecuentemente preguntan sobre el **IRP** vs. el **BCP** (Plan de Continuidad del Negocio). El IRP se enfoca en respuesta a incidentes de seguridad; el BCP abarca continuidad general del negocio. Las comunicaciones "fuera de banda" son un tema recurrente: la respuesta correcta siempre implica canales alternativos al correo corporativo si éste puede estar comprometido.

# 3. Detección

La **detección** correlaciona eventos de múltiples fuentes para determinar si son indicadores de un incidente.

**Canales de detección:**

- Coincidencia de eventos en registros, alertas de IDS (Sistema de Detección de Intrusos), alertas de cortafuegos con patrones conocidos de amenazas.
- Identificación de **desviaciones de métricas de referencia** del sistema.
- Inspección manual o física del sitio (**caza de amenazas/threat hunting**).
- Notificación por empleado, cliente o proveedor.
- Informes públicos de nuevas vulnerabilidades por reguladores o medios.

> 💡 Es aconsejable dar a los empleados una opción de **reporte confidencial** para que no teman informar amenazas internas (fraude, mala conducta).

**Primer respondiente (First Responder):** Persona del CIRT notificada cuando se detecta un evento sospechoso. Toda la organización debe estar capacitada para reconocer y reportar incidentes.

**Ejemplo en Security Onion:** El SIEM puede mostrar 30 alertas en 24 horas agrupadas por nombre de módulo (ej. `windows_eventlog`, `suricata`), que deben evaluarse manualmente para determinar prioridad.

> **Analogía:** La detección es el sistema de alarmas de un edificio: puede activarse automáticamente (sensor de humo) o manualmente (alguien llama al portero).

> **👉 Enfoque de Examen SY0-701:** Distingue entre **detección reactiva** (alerta de IDS, reporte de usuario) y **caza de amenazas/threat hunting** (búsqueda proactiva). La caza de amenazas es parte de la detección pero con enfoque proactivo. Las preguntas de escenario pueden presentar una organización que "solo responde a alertas" y pedir cómo mejorar: la respuesta es implementar threat hunting.

## Análisis

Después de la detección, el primer respondiente investiga para determinar:
1. ¿Es un **verdadero positivo** o un **falso positivo**?
2. ¿Qué tipo de incidente es?
3. ¿Qué datos/recursos están afectados?
4. ¿Qué nivel de prioridad corresponde?

Para eventos complejos o de alto impacto, el análisis se eleva a miembros **sénior del CIRT**.

### Factores de Impacto para Determinar Prioridad

| Factor | Descripción |
|--------|-------------|
| **Integridad de los datos** | Valor de los datos en riesgo; factor más importante para priorizar |
| **Tiempo de inactividad** | Grado en que el incidente interrumpe procesos de negocio (degradar vs. interrumpir) |
| **Económico/publicitario** | Costos a corto plazo (respuesta, pérdida de negocio) y largo plazo (daño a reputación) |
| **Alcance** | Número de sistemas afectados (no es indicador directo de prioridad) |
| **Tiempo de detección** | Más de la mitad de filtraciones no se detectan por semanas o meses |
| **Tiempo de recuperación** | Remediaciones complejas aumentan el período de alerta ante nuevos ataques |

> **Analogía:** El análisis es el médico de urgencias que evalúa al paciente entrante y decide si es una emergencia real o una falsa alarma antes de asignar recursos.

> ⚠️ El **alcance** (número de sistemas infectados) puede ser engañoso: muchos sistemas con malware de bajo impacto puede ser menos crítico que un solo servidor de base de datos comprometido.

### Categoría e Inteligencia de Amenazas

Las **categorías y definiciones de incidentes** garantizan una comprensión compartida entre todos los miembros del equipo.

El análisis depende de la **inteligencia de amenazas (Threat Intelligence)**, que proporciona información sobre **TTP** (Tácticas, Técnicas y Procedimientos — Tactics, Techniques and Procedures) de los adversarios.

### Cadena de Eliminación Cibernética (Cyber Kill Chain)

Modelo de Lockheed Martin del paper "Intelligence-Driven Computer Network Defense":

```
1. Reconocimiento → 2. Militarización → 3. Distribución → 4. Explotación
        ↓
7. Acciones sobre objetivos ← 6. Mando y Control (C2) ← 5. Instalación
```

| Etapa | Nombre original | Descripción |
|-------|----------------|-------------|
| 1 | **Reconnaissance** | El atacante recopila información del objetivo |
| 2 | **Weaponization** | Crea el arma/exploit (ej. documento malicioso) |
| 3 | **Delivery** | Entrega el arma (correo phishing, USB, sitio web) |
| 4 | **Exploitation** | El arma se ejecuta y explota la vulnerabilidad |
| 5 | **Installation** | Instala malware/backdoor para persistencia |
| 6 | **Command & Control (C2)** | Establece canal de comunicación con el atacante |
| 7 | **Actions on Objectives** | Exfiltración, destrucción, cifrado (ransomware) |

### Manuales de Estrategias (Playbooks)

Un **manual/playbook** es un **SOP (Procedimiento Operativo Estándar — Standard Operating Procedure)** basado en datos para ayudar a analistas a detectar y responder a escenarios específicos de amenazas.

**Estructura de un playbook:**
1. Parte de un informe de panel de alertas.
2. Guía al analista en pasos de: análisis → contención → erradicación → recuperación → lecciones aprendidas.

El CIRT debe desarrollar playbooks para escenarios típicos:
- Ataques DDoS (Denegación de Servicio Distribuida — Distributed Denial of Service)
- Brotes de virus/gusanos
- Exfiltración de datos por adversario externo
- Modificación de datos por adversario interno

> **👉 Enfoque de Examen SY0-701:** La **cadena de eliminación (Kill Chain)** es fundamental. Conoce las 7 etapas en orden. Las preguntas suelen describir una acción y pedir a qué etapa corresponde: ej. "un atacante envía un correo con un adjunto malicioso" = **Distribución (Delivery)**. Los TTP del atacante y ATT&CK son marcos clave para la fase de análisis. Diferencia **playbook** (SOP específico de escenario) de **IRP** (plan general de respuesta).

## Contención

**Analogía:** La contención es como los bomberos cortando el suministro de gas antes de apagar el fuego. Primero limitas el daño, luego eliminas la causa.

Tras el registro del incidente (indicadores, naturaleza, impacto, investigador), la siguiente fase es determinar la respuesta apropiada.

**Preguntas clave de contención:**
- ¿Qué daños ya ocurrieron? ¿Cuánto más puede infligirse? (control de pérdidas)
- ¿Qué contramedidas están disponibles? ¿Cuáles son sus costos e implicaciones?
- ¿Qué acciones alertarían al atacante?
- ¿Qué evidencia debe preservarse?
- ¿Qué notificaciones/informes se requieren?

### Contención Basada en Aislamiento

El **aislamiento** elimina un componente afectado del entorno más amplio:

- **Desconectar de la red:** Desconectar cable de red (crear un "espacio de aire"/air gap) o desactivar el puerto del switch → opción **menos cautelosa** (reduce oportunidades de análisis).
- **Aislar VLANs infectadas** en un "agujero negro" (black hole) inaccesible desde el resto de la red.
- **Usar cortafuegos/filtros** para evitar que hosts infectados se comuniquen.
- **Deshabilitar cuentas de usuario o servicios de aplicación** → sin privilegios, el intruso no puede causar más daño.

### Contención Basada en Segmentación

La **segmentación** usa tecnología de red para aislar sin eliminar completamente:

- Usa **VLAN** (Red de Área Local Virtual — Virtual Local Area Network), enrutamiento/subredes y **ACL** (Listas de Control de Acceso — Access Control Lists) de cortafuegos.
- Alternativa: configurar el segmento como **"agujero negro" o red trampa (honeypot)** → el atacante continúa recibiendo resultados filtrados (posiblemente modificados), facilitando el análisis de TTP y la **atribución** del ataque.

> **👉 Enfoque de Examen SY0-701:** Distingue **aislamiento** (eliminar completamente del entorno) vs. **segmentación** (aislar mediante arquitectura de red manteniendo visibilidad). La segmentación es preferida cuando quieres analizar al atacante sin que sepa que fue detectado. Un "agujero negro" es una red donde el tráfico se redirige pero no llega a destino real.

## Erradicación y Recuperación

### Erradicación

La **erradicación** aplica técnicas de mitigación y controles para eliminar:
- Herramientas de intrusión del atacante.
- Cambios de configuración no autorizados.
- Malware, backdoors y cuentas comprometidas.

**Pasos de erradicación y recuperación:**

1. **Reconstituir los sistemas afectados:**
   - Eliminar archivos/herramientas maliciosos, O
   - Restaurar desde copias de seguridad o imágenes seguras.
   - ⚠️ Si usas imágenes de referencia, verifica que no contengan la vulnerabilidad que permitió el incidente. Actualiza la plantilla antes de reimplementar.

2. **Volver a auditar los controles de seguridad:** Asegurarse de que no son vulnerables a otro ataque (el mismo u otro basado en conocimiento del atacante sobre la red).
   - ⚠️ En ataques dirigidos, un incidente puede seguirse **muy rápidamente** de otro.

3. **Notificar a partes afectadas:** Proporcionarles medios para remediar sus propios sistemas.
   - Ej.: Si se robaron contraseñas de clientes, recomendarles cambiar credenciales en cualquier cuenta donde usaran esa contraseña.

> **👉 Enfoque de Examen SY0-701:** La erradicación ocurre **después** de la contención y **antes** de la recuperación. Un error común es confundir el orden. La recuperación no es simplemente "volver online" — incluye verificar que el vector de ataque esté cerrado o monitoreado de cerca.

## Lecciones Aprendidas

El proceso revisa incidentes graves para determinar:
- Su causa raíz.
- Si se podían haber evitado.
- Cómo prevenirlos en el futuro.

**Dinámica de la reunión:**
- Participan el personal directamente involucrado **y** responsables externos (perspectiva objetiva).
- **No se señala culpables** — se centra en mejorar procedimientos.
- Las preocupaciones disciplinarias se gestionan **por separado** por el equipo directivo.

**Documentos resultantes:**
- **LLR** (Informe de Lecciones Aprendidas — Lessons Learned Report) o **AAR** (Informe Posterior a la Acción — After-Action Report).

> **Analogía:** Es la "autopsia" del incidente: ¿qué salió mal?, ¿cómo lo mejoramos?

### Análisis de Causa Raíz (Root Cause Analysis — RCA)

**Método de los Cinco Porqués (Five Whys):** Pregunta sucesivas de "¿por qué?" hasta llegar a la causa fundamental.

**Ejemplo del PDF:**
1. ¿Por qué está nuestra BD de pacientes en un sitio oscuro? → Actor de amenaza la copió a USB.
2. ¿Por qué pudo copiarla sin alerta? → Desactivó el sistema DLP (Prevención de Pérdida de Datos — Data Loss Prevention).
3. ¿Por qué pudo desactivar DLP? → Tenía privilegios para hacerlo.
4. ¿Por qué tenía esos privilegios? → Todas las cuentas de admin tenían esos privilegios.
5. ¿Por qué el acto de desactivar DLP no generó alerta? → Las alertas para esa categoría estaban desactivadas por generar demasiados falsos positivos.

**Resultado:** Dos causas raíz: asignaciones de permisos incorrectas + configuración incorrecta de alertas.

**Preguntas alternativas del RCA:**
- ¿Quién era el adversario? ¿Interno, externo, combinación?
- ¿Por qué se perpetró el incidente? (motivación)
- ¿Cuándo ocurrió y cuánto tardó en detectarse/contenerse?
- ¿Dónde ocurrió? (sistemas host y segmentos de red)
- ¿Cómo? ¿Qué TTP empleó? ¿Se documentaban en **ATT&CK** o eran únicos?
- ¿Qué controles habrían mejorado la mitigación o respuesta?

> **👉 Enfoque de Examen SY0-701:** La fase de lecciones aprendidas es la **7ª y última** del ciclo de IR de CompTIA. El **LLR/AAR** y el **RCA** son los entregables clave. El método "Five Whys" puede aparecer como concepto. Recuerda que el resultado de las lecciones aprendidas **retroalimenta la fase de Preparación**, cerrando el ciclo.

## Pruebas y Capacitación

### Pruebas (Testing)

Las pruebas validan el proceso de preparación. Los analistas **no deben practicar por primera vez** en un incidente real.

| Método | Descripción | Recursos |
|--------|-------------|---------|
| **Ejercicios de simulación (Tabletop)** | El facilitador presenta situación; respondedores explican qué harían. Sin sistemas reales. Datos como tarjetas didácticas. | Mínimos — el más económico |
| **Recorridas (Walkthroughs)** | Los respondedores demuestran acciones reales (escaneos, análisis de muestras) en versiones **aisladas** de herramientas reales. | Moderados |
| **Simulaciones completas** | Ejercicio en equipos: **Rojo** (ataca), **Azul** (defiende/recupera), **Blanco** (modera y evalúa). | Altos — requiere planificación considerable |

### Capacitación (Training)

Áreas clave de capacitación:
- **Procedimientos de detección y notificación de incidentes** para todo el personal.
- **Capacitación interdepartamental** (la respuesta requiere múltiples departamentos).
- **Concientización en seguridad y cumplimiento normativo** (identificar ataques futuros).
- **Habilidades interpersonales y comunicación** (los incidentes son estresantes y afectan relaciones laborales).

> **👉 Enfoque de Examen SY0-701:** Distingue los tres tipos de prueba: **tabletop** (solo verbal/papel), **walkthrough** (acciones reales en entorno aislado), **simulación** (rojo vs. azul vs. blanco). Las preguntas de escenario describirán un ejercicio y pedirán identificar el tipo. El equipo **blanco** es el moderador, no un equipo que "no hace nada".

## Caza de Amenazas (Threat Hunting)

La **caza de amenazas** usa conocimientos de inteligencia de amenazas para descubrir **proactivamente** evidencia de TTP ya presente en la red/sistema.

Contrasta con el proceso **reactivo** que solo se activa cuando el sistema de alertas lo indica.

**Puntos generales de la caza de amenazas:**

- **Avisos y boletines:** La caza se basa en una hipótesis. Los boletines de seguridad sobre nuevos TTP o vulnerabilidades desencadenan una búsqueda específica.
  - Ej.: Inteligencia indica nuevo malware que infecta escritorios Windows sin ser detectado por definiciones actuales → buscar si también está en tus sistemas.

- **Fusión de inteligencia (Intelligence Fusion):** Análisis manual de datos de red y registros, acelerado por plataformas SIEM que correlacionan datos de amenazas (TTP e indicadores) con datos locales de tráfico y registros.

- **Maniobra (Maneuver):** Al investigar amenazas en vivo, recordar la naturaleza **contradictoria** de la piratería. El atacante puede:
  - Anticipar la caza de amenazas e implementar contramedidas.
  - Desencadenar un ataque DDoS para **desviar la atención** del equipo de seguridad.
  - Acelerar sus planes al saber que fue detectado.
  - Usar **técnicas de descubrimiento pasivo** para evitar ser detectado.

**Herramienta Security Onion — Hunt:** Los paneles de Hunt ayudan a determinar si una alerta afecta solo un sistema o está extendida por toda la red.

> **Analogía:** Si la detección tradicional espera a que suene la alarma, la caza de amenazas es el detective que patrulla activamente buscando signos de actividad criminal antes de que haya víctimas.

> **👉 Enfoque de Examen SY0-701:** La caza de amenazas es **proactiva** (no reactiva). La "fusión de inteligencia" se usa para correlacionar datos de amenazas conocidos con datos locales. El concepto de "maniobra" implica que el atacante también puede anticiparse, por lo que la caza debe ser discreta (técnicas pasivas). Diferencia threat hunting del análisis de alertas rutinario.

## Análisis Forense Digital

> **Objetivo del examen:** 4.8 — Explicar las actividades adecuadas de respuesta a incidentes.

El **análisis forense digital** examina evidencia de sistemas informáticos y redes para descubrir:
- Archivos eliminados.
- Marcas de tiempo.
- Actividad del usuario.
- Tráfico no autorizado.

**Principio fundamental:** La documentación es crítica. Los errores en el registro del proceso pueden llevar al rechazo de pruebas en juicio.

> **Analogía:** El forense digital es el CSI (Investigación de la Escena del Crimen) del mundo cibernético. Mientras la IR busca detener el ataque rápidamente, el forense busca **quién lo hizo y cómo**, preservando pruebas para la justicia.

### Debido Proceso y Retención Legal

#### Evidencia Digital — Características

- La evidencia digital es en su mayoría **latente** (no visible a simple vista; debe interpretarse con máquinas).
- Como el ADN o las huellas digitales, requiere medidas formales para garantizar su admisibilidad.
- Requiere documentación de **cómo se recopiló y analizó** sin adulteración o sesgo.

#### Debido Proceso (Due Process)

Término del derecho consuetudinario (EE. UU. y Reino Unido) que exige:
- Condena solo después de aplicación **justa** de las leyes.
- Conjunto de **garantías procesales** para garantizar la imparcialidad.

**Implicación forense:** Si hay posibilidad de investigación forense, los técnicos y gerentes deben conocer los procesos utilizados para no poner en riesgo la investigación. La defensa intentará aprovechar cualquier error de integridad.

#### Retención Legal (Legal Hold)

**Definición:** Obligación de **preservar información** que pueda ser relevante para un caso judicial.

**Fuentes que definen retención legal:**
- Reguladores o mejores prácticas de la industria.
- Aviso de litigio de policía o abogados (acción civil).

**Implicaciones prácticas:**
- Los sistemas informáticos pueden tomarse como evidencia (con la interrupción que eso implica).
- La empresa debe **suspender eliminación/destrucción rutinaria** de registros electrónicos y en papel.
- Las investigaciones forenses típicamente se inician para procesar **delitos de amenazas internas** (fraude, uso indebido del equipo).

> **👉 Enfoque de Examen SY0-701:** Distingue **retención legal** (obligación de preservar datos relevantes a un caso) de **retención de datos** (política normal de cuánto tiempo guardar datos). Cuando aparece "legal hold" en el examen, implica suspender procedimientos de eliminación. El **debido proceso** garantiza que la evidencia fue recopilada correctamente para ser admisible.

### Adquisición

**Analogía:** La adquisición forense es como hacer una fotocopia perfecta de un documento antes de analizarlo, sin tocar el original.

La **adquisición** obtiene una copia forense limpia de los datos de un dispositivo incautado.

**Complicación legal — BYOD (Trae Tu Propio Dispositivo — Bring Your Own Device):** Si la computadora no es propiedad de la organización, hay que verificar que la búsqueda e incautación sean **legalmente válidas**. Cualquier error hace inadmisible la evidencia.

#### Orden de Volatilidad

La guía de buenas prácticas de la **ISOC** (RFC 3227 — `tools.ietf.org/html/rfc3227`) establece capturar evidencia de **más volátil a menos volátil**:

| Prioridad | Fuente de datos | Volatilidad |
|-----------|----------------|-------------|
| 1 | Registros de CPU y memoria caché (incluye caché de controladores de disco, GPU) | **Máxima** |
| 2 | Contenido de RAM (tabla de enrutamiento, caché ARP, tabla de procesos, estadísticas del kernel) | Alta |
| 3 | **Almacenamiento masivo persistente** (HDD, SSD, dispositivos de memoria): bloques de partición, espacio no asignado, caché swap/hibernación, archivos temporales, archivos de usuario/aplicación/SO | Media |
| 4 | Registro de logs remoto y monitoreo a distancia | Baja |
| 5 | Configuración física y topología de red | Baja |
| 6 | Medios de archivo y documentos impresos | **Mínima** |

> ⚠️ El Registro de Windows se almacena principalmente en disco, pero `HKLM\HARDWARE` **solo existe en memoria**. Su contenido se analiza a través de un volcado de memoria.

> **👉 Enfoque de Examen SY0-701:** El **orden de volatilidad** es un concepto frecuente en el examen. La RAM es más volátil que el disco duro. El RFC 3227 define este orden. Las preguntas típicas: "¿Cuál fuente de evidencia debe adquirirse primero?" → respuesta: registros de CPU/RAM. BYOD complica la adquisición porque la propiedad legal del dispositivo afecta la legalidad de la búsqueda.

### Adquisición de Memoria del Sistema

La **memoria del sistema (RAM)** contiene datos volátiles que se pierden al cortar la energía.

**Un volcado de memoria del sistema puede revelar:**
- Procesos en ejecución.
- Contenido de sistemas de archivos temporales.
- Datos del registro.
- Conexiones de red activas.
- **Claves criptográficas** (crítico: permite descifrar datos cifrados).
- Datos que se cifran cuando se almacenan en disco.

#### Marco de Volatilidad (Volatility Framework)

Herramienta de referencia para análisis de volcados de memoria. Permite visualizar:
- Lista de procesos (`pslist`).
- Conexiones de red.
- Claves de registro.
- Artefactos de malware en memoria.

**Ejemplo de comando:**
```bash
volatility_2.6_win64_standalone.exe -f c:\dumps\memory.dmp --profile=Win7SP1x64_23418 pslist
```

**Adquisición de memoria — requisito técnico:** Las herramientas de hardware o software especializadas deben estar **preinstaladas**, ya que requieren un controlador de modo kernel. En Linux, el marco Volatility incluye herramienta para instalar este controlador.

> **👉 Enfoque de Examen SY0-701:** La RAM es la fuente de evidencia **más volátil** y debe adquirirse primero. El "volcado de memoria" (memory dump) permite analizar lo que estaba en ejecución. Clave: las herramientas deben estar preinstaladas — no puedes instalarlas después del incidente sin riesgo de alterar evidencia.

### Adquisición de Imágenes de Disco

La **adquisición de imágenes de disco** obtiene datos de almacenamiento **no volátil**:
- Unidades de disco duro (HDD).
- Unidades de estado sólido (SSD).
- Firmware.
- Memoria flash (USB, tarjetas de memoria).
- Medios ópticos (CD, DVD, Blu-ray).

También conocida como **adquisición de dispositivos** (incluye smartphones, reproductores multimedia).

#### Tres Estados de Dispositivo para Adquisición

| Estado | Descripción | Riesgos/Notas |
|--------|-------------|---------------|
| **Adquisición en vivo** | Copiar datos mientras el host sigue ejecutándose | Puede capturar más datos; datos en disco habrán cambiado → puede no ser legalmente aceptable; puede alertar al atacante |
| **Adquisición estática al apagar** | Apagar el host correctamente antes de adquirir | Riesgo: malware detecta proceso de apagado y realiza análisis antiforenses para eliminar rastros |
| **Adquisición estática "tirando del enchufe"** | Desconectar energía directamente del tomacorriente (no el botón) | Conserva dispositivos en estado limpio, pero riesgo de corrupción de datos |

> 💡 Con suficiente tiempo en la escena, puede hacerse **ambas** (vivo y estática).

#### Herramienta Principal — Comando `dd`

En hosts Linux, el comando `dd` hace una copia bit a bit:

```bash
dd if=/dev/sda of=/mnt/usbstick/backup.img
```

- `if=` → archivo de entrada (dispositivo origen)
- `of=` → archivo de salida (imagen destino)

**Herramienta mejorada — `dcfldd`:** Bifurcación de `dd` creada por el DoD (Departamento de Defensa de EE. UU.) con características adicionales:
- Múltiples archivos de salida.
- **Verificación de coincidencia exacta** (hash integrado).

```bash
dcfldd if=/dev/sda hash=sha256 of=/root/FORENSIC/ROGUE.dd bs=512 conv=noerror
```

> **👉 Enfoque de Examen SY0-701:** `dd` y `dcfldd` son herramientas clave para imágenes forenses. `dcfldd` es la versión mejorada del DoD con verificación hash. Los tres estados de adquisición de disco (en vivo, apagado correcto, "tirar del enchufe") pueden aparecer en preguntas de escenario. La adquisición "en vivo" es la menos legalmente robusta pero captura más datos.

### Preservación

> **Analogía:** La preservación es como el embalaje hermético de la escena del crimen: garantiza que la evidencia llega al laboratorio exactamente como estaba en la escena.

#### Integridad de la Evidencia y No Repudio

Proceso para garantizar integridad:

1. **Hash criptográfico** del medio original (MD5 o SHA).
2. **Copia bit a bit** del medio con utilidad de imágenes.
3. **Segundo hash** de la imagen — debe coincidir con el original.
4. **Copia de la imagen de referencia**, validada por suma de verificación. El análisis se realiza en la copia.

> 💡 Esta prueba de integridad garantiza el **no repudio**: si la cadena de procedencia es cierta, el actor de amenaza identificado no puede negar sus acciones.

#### Bloqueador de Escritura (Write Blocker)

Dispositivo que **filtra comandos de escritura** a nivel del controlador y del SO, evitando que la herramienta de captura altere datos o metadatos en el disco de origen.

**Procedencia (Provenance):** La grabación en vídeo de todo el proceso establece que las pruebas provienen **directamente de la escena del crimen**.

**Línea de tiempo (Timeline):** La evidencia recopilada debe ajustarse a una línea de tiempo válida.

#### Cadena de Custodia (Chain of Custody)

**Definición:** Documentación que registra dónde, cuándo y quién:
- Recolectó la evidencia.
- La manipuló posteriormente.
- Dónde se almacenó.

**Procedimiento físico:**
- Etiquetar, embolsar y precintar dispositivos con **bolsas a prueba de adulteraciones**.
- Usar **protección antiestática** para evitar daño por ESD (Descarga Electrostática — Electrostatic Discharge).
- Usar **formulario de cadena de custodia** para cada pieza de evidencia.
- Todos los manipuladores deben registrar métodos y herramientas utilizados.

**Almacenamiento:** Instalación segura con control de acceso **y** control ambiental (condensación, ESD, fuego).

> **👉 Enfoque de Examen SY0-701:** La **cadena de custodia** es fundamental. Si se rompe → evidencia inadmisible. El **bloqueador de escritura** protege la integridad del original. El proceso de **hash → imagen → hash de imagen** es el estándar para verificar integridad. Cualquier discrepancia en el hash indica modificación.

### Elaboración de Informes

Los **informes forenses digitales** resumen hallazgos y conclusiones del análisis.

#### Principios Éticos del Análisis Forense

- Análisis **sin sesgos**: conclusiones solo desde evidencia directa.
- Métodos **repetibles** por terceros con acceso a la misma evidencia.
- Evidencia **no alterada**: si debe manipularse (ej. desactivar bloqueo de pantalla), documentar razones y proceso.

> ⚠️ La defensa intentará usar cualquier desviación ética para desestimar los hallazgos del investigador forense.

#### ESI (Información Almacenada Electrónicamente — Electronically Stored Information)

Un examen forense incluye búsqueda de toda la unidad: sectores asignados y **no asignados**.

#### Descubrimiento Electrónico (e-Discovery)

El **descubrimiento electrónico** filtra la evidencia relevante de todos los datos recopilados para almacenarla en una base de datos usable como evidencia en ensayo.

**Funciones de las suites de e-Discovery:**

| Función | Descripción |
|---------|-------------|
| **Identificar y desduplicar** | Elimina archivos estándar y copias duplicadas; reduce volumen a analizar |
| **Buscar** | Búsqueda por palabras clave y **búsqueda semántica** (coincide si corresponde a contexto particular) |
| **Etiquetar** | Aplica palabras clave/etiquetas estandarizadas para organizar evidencia (relevancia, confidencialidad) |
| **Seguridad** | Demuestra que la evidencia se almacenó, transmitió y analizó sin adulteración |
| **Divulgación** | Garantiza disponibilidad de evidencia tanto para demandante como acusado |

> 💡 Casos judiciales recientes requieren que las partes proporcionen **ESI con capacidad de búsqueda** en lugar de registros en papel.

> **👉 Enfoque de Examen SY0-701:** **ESI** = cualquier información almacenada electrónicamente. **e-Discovery** = proceso de identificar, preservar y producir ESI para litigación. Recuerda que el e-Discovery puede buscar en sectores **no asignados** del disco (archivos supuestamente eliminados). La "búsqueda semántica" va más allá de palabras clave simples.

## Fuentes de Datos

> **Objetivo del examen:** 4.9 — A partir de un escenario, usar fuentes de datos para respaldar una investigación.

**Analogía:** Las fuentes de datos son los testigos y registros de un caso criminal. Cuantas más fuentes tengas y mejor las correlaciones, más completo es el cuadro del incidente.

### Fuentes de Datos, Paneles e Informes

En el contexto de respuesta a incidentes o análisis forense, una **fuente de datos** es cualquier cosa que pueda someterse a análisis para descubrir indicadores.

**Fuentes de datos principales:**

- Datos y metadatos del sistema de archivos del dispositivo multimedia y de la memoria.
- Archivos de registro de dispositivos de red (**switches, enrutadores, cortafuegos/UTM**).
- Tráfico de red capturado por sensores o condiciones alertables de **IDS** (Sistema de Detección de Intrusiones — Intrusion Detection System).
- Registros y alertas de **escáneres de vulnerabilidades** basados en red.
- Registros del **SO** de equipos host cliente y servidor.
- Registros de **aplicaciones y servicios**.
- Registros y alertas del **software de seguridad de endpoint**: IDS basado en host, análisis de vulnerabilidades, antivirus, cortafuegos de host.

#### Las "5 V" de los Grandes Datos (Big Data)

Los problemas de tratar grandes cantidades de datos se describen como las "V":
- **Volumen** (tamaño)
- **Velocidad** (rapidez de generación)
- **Variedad** (diversidad de formatos)
- **Veracidad** (confiabilidad)
- **Valor** (utilidad)

#### Paneles (Dashboards)

Un **panel de eventos** proporciona una consola de trabajo diario para la respuesta a incidentes:
- Resumen de información extraída de las fuentes de datos subyacentes.
- Panel del **controlador de incidentes:** eventos sin categorizar asignados a su cuenta + visualizaciones de métricas de estado clave.
- Panel del **administrador:** indicadores del estado general (número de eventos no clasificados para todos los manejadores).

#### Informes Automatizados

Un SIEM genera dos tipos de informes:
1. **Alertas y alarmas:** Detectan indicadores de amenaza; inician casos de incidentes. La gestión diaria de alertas es gran parte de la carga de trabajo del analista.
2. **Informes de estado:** Comunican datos sobre nivel de amenaza, número de incidentes, efectividad de controles de seguridad. Informa decisiones de administración y cumplimiento.

> 💡 Un SIEM incluye paneles e informes preconfigurados, pero también permite crear personalizados. Adaptar el informe al público objetivo es fundamental: información irrelevante o excesiva impide identificar acciones correctivas.

> **👉 Enfoque de Examen SY0-701:** Las preguntas de escenario del objetivo 4.9 te presentan una investigación y preguntan qué fuente de datos usar. Conoce cada fuente y qué tipo de evidencia proporciona. Los paneles no son herramientas de investigación profunda — son para gestión diaria. Los informes del SIEM tienen audiencias distintas (ejecutivos, gerencia, cumplimiento).

### Datos de Registro

Los **datos de registro** son un recurso fundamental para investigar incidentes de seguridad.

**Componentes de un evento de registro:**

| Componente | Descripción | Ejemplo |
|------------|-------------|---------|
| **Datos del mensaje** | Notificación o alerta específica del evento | "Error de inicio de sesión", "Tráfico interrumpido por regla del cortafuegos" |
| **Metadatos del evento** | Origen y hora del evento; puede incluir dirección de host/red, nombre de proceso, campos de categorización/prioridad | IP de origen, timestamp, proceso |

> ⚠️ El registro preciso requiere que todos los hosts se sincronicen con el mismo valor y formato de fecha/hora, idealmente usando **UTC** (Hora Coordinada Universal — Coordinated Universal Time) o la misma zona horaria.

#### Formato Syslog

**Syslog** proporciona formato, protocolo y software de servidor abiertos para registrar mensajes de eventos. Usado por: switches, enrutadores, cortafuegos, servidores UNIX/Linux.

**Estructura de un mensaje Syslog:**

```
[PRI] [ENCABEZADO] [MENSAJE]
```

- **PRI (Código Primario):** Calculado desde instalación (facility) y nivel de gravedad (severity).
- **Encabezado:** Marca de tiempo, nombre del host, nombre de la aplicación, ID del proceso, ID del mensaje.
- **Mensaje:** Etiqueta del proceso de origen + contenido (delimitado por espacios/comas o pares nombre/valor).

#### Event Viewer de Windows

Formato de registro para hosts y aplicaciones Windows. Cada evento incluye:
- Origen (Source)
- Nivel (Level: Information, Warning, Error, Critical)
- Usuario
- Marca de tiempo
- Categoría
- Palabras clave
- Nombre del host

**Tres archivos principales de registro de eventos de Windows:**
- **Aplicación:** Eventos generados por aplicaciones (bloqueos, instalaciones/eliminaciones).
- **Seguridad (Auditoría):** Inicio de sesión fallido, denegación de acceso a archivos.
- **Sistema:** Eventos del núcleo del SO (servicio que no puede iniciar, cambio de tipo de inicio, apagado).

#### Registros de Linux

- **`/var/log/messages`** o **`/var/log/syslog`** → Todos los eventos del sistema.
- **`/var/log/auth.log`** (Debian/Ubuntu) o **`/var/log/secure`** (RedHat/CentOS/Fedora) → Intentos de inicio de sesión, uso de sudo, autenticación.
- **`rastrea`** → Registra específicamente eventos de inicio de sesión fallidos.
- **`wtmp`, `utmp`, `btmp`** → Usados con comandos `w`, `who`, `last` para identificar sesiones.
- **Registro del administrador de paquetes** (`apt`, `yum`, `dnf`) → Software instalado/actualizado.
- **Journald** → Sistema de registro unificado (binario); leer con `journalctl`.

**Ejemplo de registro de autenticación Linux:**
```
00:26:47 lamp login[415]: pam_unix(login:auth): authentication failure...
00:26:51 lamp login[415]: FAILED LOGIN (1) on '/dev/tty1' FOR 'root'
...
00:27:11 lamp login[415]: pam_unix(login:session): session opened for user lamp(uid=1000)
```

#### Registros de macOS

- Sistema de registro unificado, accesible via aplicación **Consola** o comando `log`.
- Filtros para eventos de seguridad:
  - `com.apple.login` → Inicio de sesión.
  - `com.apple.install` → Instalaciones de aplicaciones.
  - `com.apple.syspolicy.exec` → Violaciones de políticas del sistema.

#### Agregación de Registros con SIEM

Los registros pueden mantenerse individualmente en cada host, pero el **SIEM** ofrece vista "panel de vidrio" (single pane of glass):
- Recopila registros de múltiples fuentes (agente o syslog/similar).
- Proporciona vista unificada de todos los hosts y dispositivos de red.

> **👉 Enfoque de Examen SY0-701:** Conoce las rutas de registros de Linux. Las preguntas de escenario pueden mostrar un fragmento de log y pedir identificar el evento. La sincronización de tiempo (**NTP** — Protocolo de Tiempo de Red — Network Time Protocol) es crítica para la correlación de registros. Syslog está en `UDP/514` (no seguro) o `TCP/6514` (seguro con TLS).

### Registros del Sistema Operativo del Host

Los **registros de seguridad** del SO graban eventos de auditoría (exitoso/aceptado vs. fallido/denegado):

- **Eventos de autenticación:** Inicio/cierre de sesión, obtención de privilegios especiales/administrativos.
- **Eventos del sistema de archivos:** Permisos de lectura/modificación. La auditoría del sistema de archivos debe configurarse **explícitamente** (demasiados datos si se habilita para todos los objetos).

(Ver detalles de Windows, Linux y macOS en sección 12.3.2 anterior)

### Registros de Aplicaciones y de Endpoints

#### Registros de Aplicaciones

Un archivo de registro de aplicación es administrado por la aplicación (no el SO). Puede usar:
- El visor de eventos o syslog (formato estándar).
- Sus propios directorios en cualquier formato elegido por el desarrollador.

> ⚠️ En Windows, cualquier cuenta autenticada puede escribir en el registro de aplicación del Visor de Eventos. También hay registros de aplicaciones y servicios personalizados separados.

#### Registros de Puntos de Conexión (Endpoint Logs)

Eventos monitoreados por **software de seguridad** del host:
- Cortafuegos basados en host.
- Detección de intrusiones (HIDS — Host-based IDS).
- Escáneres de vulnerabilidades.
- Antivirus/antimalware.

**Plataformas de seguridad de endpoints:**

| Acrónimo | Nombre | Función |
|----------|--------|---------|
| **EPP** | Endpoint Protection Platform (Plataforma de Protección de Puntos de Conexión) | Suite integrada de seguridad |
| **EDR** | Endpoint Detection and Response (Detección y Respuesta en Endpoints) | Monitoreo avanzado y respuesta |
| **XDR** | Extended Detection and Response (Detección y Respuesta Extendidas) | Integra múltiples capas de seguridad |

Estas herramientas se integran directamente con un SIEM via software basado en agentes.

**El resumen de eventos de endpoints puede mostrar:**
- Cantidad de malware detectado.
- Cantidad de eventos de detección de intrusiones en el host.
- Cantidad de hosts a los que les faltan parches.

#### Escaneos de Vulnerabilidades

Un escáner de vulnerabilidades puede configurarse para registrar cada vulnerabilidad detectada en un SIEM. El SIEM puede recuperar la lista por host y determinar si está correctamente configurado.

> **👉 Enfoque de Examen SY0-701:** EPP vs. EDR vs. XDR: EPP es la suite básica, EDR añade detección avanzada y respuesta, XDR extiende la visibilidad más allá del endpoint. Los registros de endpoints son clave para **atribuir eventos de intrusión a un actor específico** y desarrollar inteligencia de amenazas de TTP.

### Fuentes de Datos en Red

#### Registros de Red

Los **registros de red** se generan por: enrutadores, cortafuegos, switches, puntos de acceso.

Registran: funcionamiento del dispositivo, estado, tráfico y acceso.

**Ejemplos de amenazas reveladas:**
- Registro de **switch** → endpoint usando múltiples MACs (ataque en ruta/MitM).
- Registro de **cortafuegos** → actividad de análisis en puerto bloqueado.
- Registro de **punto de acceso** → eventos de desasociación indicando ataque a red inalámbrica.

#### Registros de Cortafuegos

- Un evento de auditoría registra: fecha/marca de tiempo, interfaz, dirección (entrante/saliente), acción (aceptado/descartado), información del paquete (IP y puertos origen/destino).
- **Nota:** Una sola regla de solo registro puede habilitarse sin bloquear tráfico (útil para probar o auditar reglas de alto impacto).
- Un solo paquete puede activar **múltiples eventos**.

**Ejemplo de registro de cortafuegos:**
```
T09:21:38-05  Info  hn1,pass,in,59897,0,DF,6,tcp,52,10.1.24.101,172.16.0.201,11545,22,0,S
T09:21:04-05  Info  hn0,block,in,46700,0,DF,6,tcp,60,203.0.113.66,172.16.0.201,41250,22,0
```

#### Registros IPS/IDS

Un registro **IPS/IDS (Sistema de Prevención/Detección de Intrusiones — Intrusion Prevention/Detection System)** se genera cuando un patrón de tráfico coincide con una regla.

- Puede configurarse para registrar solo reglas de alta sensibilidad/impacto.
- Un solo paquete puede desencadenar varias reglas.
- Un IPS también registra rechazos, restablecimientos y redirecciones como un cortafuegos.
- Los datos resumidos de IDS/IPS se visualizan en gráficos de paneles para representar niveles generales de amenaza.

> **👉 Enfoque de Examen SY0-701:** Conoce qué puede revelar cada tipo de registro de red. Las preguntas de escenario pueden mostrar un fragmento de log de cortafuegos y pedir identificar el tipo de tráfico o si fue bloqueado. Los registros de switch son útiles para detectar ataques ARP/MAC flooding.

### Captura de Tráfico de Red

(Nota del PDF: Esta sección se integra en el contexto de 12.3.5 y 12.4.4 — NetFlow y análisis de paquetes)

El tráfico de red puede capturarse directamente por sensores en el SIEM para análisis profundo de paquetes, complementando los registros de dispositivos.

### Metadatos

Los **metadatos** son propiedades de los datos creadas por una aplicación, almacenadas en medios o transmitidas a través de una red.

**Utilidad:** Resolver consultas sobre línea de tiempo (cuándo y dónde ocurrió una violación) y contener otros tipos de evidencia.

#### Metadatos de Archivos

El sistema de archivos rastrea atributos:
- Cuándo se creó un archivo.
- Cuándo se accedió.
- Cuándo se modificó.
- Atributos de seguridad (solo lectura, oculto, del sistema).
- **ACL** (Lista de Control de Acceso — Access Control List) → permisos.
- Atributos extendidos: autor, derechos de autor, etiquetas de indexación.

> ⚠️ Metadatos en redes sociales pueden revelar ubicación actual y hora, más de lo que el cargador pretendía.

#### Metadatos Web

Cuando un cliente solicita un recurso de un servidor web, el servidor devuelve encabezados HTTP con:
- Tipo de datos devueltos.
- Información de autorización (cookies).
- Otros metadatos de propiedades.

Los encabezados pueden inspeccionarse con **herramientas de desarrollo del navegador** y registrarse en el servidor web.

#### Metadatos de Correo Electrónico

El **encabezado de Internet** de un correo contiene la ruta completa del mensaje:

| Agente | Rol |
|--------|-----|
| **MUA** (Mail User Agent — Agente de Usuario de Correo) | Crea el encabezado inicial del mensaje |
| **MDA** (Mail Delivery Agent — Agente de Entrega de Correo) | Verifica que el remitente esté autorizado; añade/modifica encabezados |
| **MTA** (Mail Transfer Agent — Agente de Transferencia de Mensajes) | Dirige el mensaje al destinatario; cada MTA añade información al encabezado |

**Análisis de encabezados de correo:** Herramienta **Message Analyzer** de Microsoft Remote Connectivity Analyzer (`testconnectivity.microsoft.com/test/o365`).

**Caso de uso forense:** Análisis de encabezados en mensajes de phishing para:
- Identificar la ruta del mensaje (hops/saltos de MTA).
- Detectar typosquatting (ej. `structureality.com` vs. `structureality.com`).
- Identificar inconsistencias entre el remitente mostrado y el real.

> **👉 Enfoque de Examen SY0-701:** Los metadatos son evidencia **latente** — no visible directamente pero analizable. Los metadatos de correo revelan la ruta real del mensaje y pueden detectar phishing/spoofing. El análisis de encabezados de correo es una técnica forense importante. MUA → MDA → MTA es la cadena de agentes de correo.

## Herramientas de Alerta y Monitoreo

> **Objetivo del examen:** 4.4 — Explicar los conceptos y las herramientas de alertas de seguridad y monitoreo.

**Analogía:** Si los datos son el crimen organizado de una ciudad, el SIEM es el cuartel general de la policía que recibe todas las denuncias, las correlaciona y coordina la respuesta.

### Gestión de Información y Eventos de Seguridad — SIEM

El **SIEM (Security Information and Event Management)** recopila y correlaciona datos de sensores de red y registros de dispositivos/hosts/aplicaciones.

**Fuentes que agrega un SIEM:**
- Hosts Windows y Linux.
- Switches, enrutadores, cortafuegos.
- Sensores IDS.
- Rastreadores de paquetes.
- Escáner de vulnerabilidades.
- Escáner de malware.
- Sistemas **DLP** (Prevención de Pérdida de Datos — Data Loss Prevention).

**Ejemplo de SIEM populares:** Security Onion (open source), Wazuh (open source), Splunk, IBM QRadar.

#### Métodos de Recopilación

| Método | Descripción | Uso típico |
|--------|-------------|-----------|
| **Basado en agentes (Agent-based)** | Instalar servicio agente en cada host; filtra, agrega y normaliza eventos localmente antes de enviarlos | Windows, Linux, macOS |
| **Oyente/Recopilador (Listener/Collector)** | Hosts configurados para enviar cambios de registro al servidor SIEM via syslog (o similar); proceso en servidor SIEM analiza y normaliza | Switches, enrutadores, cortafuegos (incompatibles con agentes) |
| **Sensor** | SIEM recopila capturas de paquetes y datos de flujo de tráfico de rastreadores | Análisis de tráfico de red |

> ⚠️ El agente debe ejecutarse como proceso y puede usar de 50 a 500 MB de RAM según actividad.

#### Agregación de Registros

La **agregación de registros** normaliza datos de distintas fuentes para que sean **consistentes y consultables**:
- Conectores/complementos interpretan datos de distintos tipos de sistemas.
- Cada agente/recopilador requiere su propio analizador para identificar atributos.
- Función crítica: **normalizar diferencias de fecha/zona horaria** en una sola línea de tiempo.

**Ejemplo de archivo de configuración de agente Wazuh:**
```xml
<localfile>
  <location>Microsoft-Windows-Windows Defender/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
<!-- Security Configuration Assessment -->
<sca>
  <enabled>yes</enabled>
  <scan_on_start>yes</scan_on_start>
  <interval>12h</interval>
</sca>
<!-- File integrity monitoring -->
<syscheck>
  <disabled>no</disabled>
  <frequency>43200</frequency>
</syscheck>
```

> **👉 Enfoque de Examen SY0-701:** SIEM = recopilación + correlación + alerta + informes. Los tres métodos de recopilación (agente, oyente/recopilador, sensor) son conceptos clave. La **normalización** es crítica para poder correlacionar eventos de fuentes heterogéneas. SIEM ≠ SOAR (el SOAR automatiza la respuesta; el SIEM solo alerta e informa).

### Actividades de Alerta y Monitoreo

El SIEM permite implementar actividades de **alerta, informes y archivo**.

> 💡 La ventaja del SIEM es consolidar todas estas actividades en una sola interfaz ("panel de vidrio").

#### Alerta (Alerting)

El SIEM ejecuta **reglas de correlación** en los indicadores extraídos de las fuentes de datos.

**Regla de correlación SIEM — Ejemplo:**
```
Error.LoginFailure > 3 AND LoginFailure.User AND Duration < 1 hour
```
Interpreta: si hay más de 3 fallos de login del mismo usuario en menos de 1 hora → generar alerta.

**Operadores de correlación:** `==` (coincide), `<` (menor que), `>` (mayor que), `in` (contiene), `AND`, `OR`.

**Pasos de respuesta a alerta:**
1. **Validación:** El analista decide si la alerta es verdadero positivo o **falso positivo** (alerta sin actividad de amenaza real).
2. **Cuarentena:** Aislar la fuente de indicadores (dirección de red, host, archivo).

**Automatización con SOAR:** Las acciones de validación y cuarentena pueden automatizarse total o parcialmente (ej. cuarentena con un clic via integración con cortafuegos/EPP).

#### Elaboración de Informes

Tipos de informes del SIEM:

| Tipo | Audiencia | Propósito |
|------|-----------|-----------|
| **Ejecutivos** | Alta dirección | Resumen de alto nivel; orienta planificación e inversión |
| **Gerencia** | Líderes de departamento y ciberseguridad | Información detallada; orienta decisiones operativas diarias |
| **Cumplimiento** | Reguladores | Toda la información requerida por el regulador |

**Métricas comunes en informes:**
- Datos de autenticación (intentos fallidos de inicio de sesión).
- Equipos con parches faltantes o vulnerabilidades de configuración.
- Anomalías en cuentas con privilegios (uso fuera del horario laboral, solicitudes excesivas de permisos elevados).
- Estadísticas de gestión de casos (volumen general, casos abiertos, tiempo de resolución).
- Tendencias (cambios en métricas clave a lo largo del tiempo).

#### Archivado

El SIEM implementa **política de retención** para registros históricos y tráfico de red:
- Permite **detección retrospectiva** de incidentes y amenazas.
- Fuente valiosa de evidencia forense.
- Cumple requisitos de cumplimiento normativo.
- Esquema de **rotación de registros**: traslada información obsoleta al almacenamiento de archivos para mantener rendimiento.

> ⚠️ El rendimiento del SIEM se degrada con datos excesivos en análisis en tiempo real.

> **👉 Enfoque de Examen SY0-701:** La correlación SIEM es clave: una sola acción (1 fallo de login) no genera alerta; un patrón (3+ fallos en 1 hora) sí. **Falso positivo** = alerta sin amenaza real → fatiga de alertas. **Falso negativo** = no alerta cuando sí hay amenaza → debilidad grave. SOAR automatiza la respuesta que el SIEM identifica. El archivado cumple tanto propósitos forenses como de cumplimiento.

### Ajuste de Alertas (Alert Tuning)

**Analogía:** Un detector de humo que suena cada vez que cocinas es inútil porque lo desconectas. El ajuste de alertas es calibrar la sensibilidad para que suene solo en incendios reales.

Las reglas de correlación asignan un **nivel de criticidad** a cada coincidencia:

| Nivel | Descripción |
|-------|-------------|
| **Solo registro** | Evento agregado a BD del SIEM y clasificado automáticamente (sin notificación activa) |
| **Alerta** | Evento mostrado en panel de control/gestión de incidentes para evaluación del agente. El agente puede descartarlo o validarlo e iniciar un caso |
| **Alarma** | Clasificado automáticamente como crítico; genera notificación prioritaria (correo, SMS al gestor) |

#### Problema — Fatiga de Alertas (Alert Fatigue)

Los analistas se sobrecargan descartando alertas de baja prioridad y pueden perder alertas de alto impacto.

**Consecuencia:** Los analistas buscan razones rápidas para **descartar** en lugar de **evaluar** adecuadamente.

#### Equilibrio Falsos Positivos vs. Falsos Negativos

| Concepto | Definición | Impacto |
|----------|-----------|---------|
| **Falso positivo** | Alerta generada sin actividad maliciosa real | Desperdicia tiempo; fatiga de alertas |
| **Falso negativo** | No se genera alerta cuando hay indicadores maliciosos | **Debilidad grave** del sistema |
| **Verdadero negativo** | El sistema permitió correctamente un evento legítimo | Métrica de rendimiento |

#### Técnicas de Ajuste de Alertas

- **Refinar reglas y silenciar niveles de alerta:** Ajustar parámetros de la regla (más factores de correlación) o configurar para generar 1 notificación por cada 10 o 100 eventos.
- **Redirigir "aluviones" de alertas repentinas** a un grupo dedicado (en lugar de saturar el panel de cada analista).
- **Redirigir alertas de infraestructura** a un equipo de infraestructura (no al equipo de respuesta a incidentes).
- **Monitoreo continuo del volumen** de alertas y retroalimentación de analistas.
- **Aprendizaje automático (ML):** Analiza rápidamente grandes conjuntos de datos del SIEM; ajusta automáticamente el conjunto de reglas para reducir falsos negativos sin afectar verdaderos positivos.

> **👉 Enfoque de Examen SY0-701:** La "fatiga de alertas" es un concepto clave. La solución no es reducir indiscriminadamente las alertas (aumenta falsos negativos) sino ajustar con inteligencia. Los tres niveles (solo registro, alerta, alarma) pueden aparecer como opciones en escenarios. El ML para ajuste de alertas es una tendencia moderna importante.

### Supervisión de la Infraestructura

Los informes de gestión permiten la supervisión diaria de recursos informáticos y la infraestructura de red.

> **Analogía:** Si el SIEM es el cuartel de policía para crímenes, el monitor de infraestructura es el departamento de mantenimiento que verifica que los edificios (infraestructura de red) estén en buen estado.

#### Monitores de Red

Un **monitor de red** recopila datos sobre dispositivos de infraestructura (switches, puntos de acceso, enrutadores, cortafuegos):

**Datos que supervisa:**
- Estado de carga de CPU/memoria.
- Tablas de estado.
- Capacidad del disco.
- Velocidades y temperatura del ventilador.
- Estadísticas de utilización de enlace de red y errores.
- **Mensaje de latido** → indica disponibilidad.

**Protocolo — SNMP (Protocolo de Administración de Red Simple — Simple Network Management Protocol):**
- Una **captura SNMP (trap)** informa de eventos destacados: falla del puerto, sobrecalentamiento, falla de energía, uso excesivo de CPU.
- El umbral para activar capturas puede establecerse para cada valor.
- El monitoreo de red puede revelar condiciones inusuales que indican ataques.

#### NetFlow

**Definición:** Medio para registrar **metadatos y estadísticas** del tráfico de red en lugar de cada trama completa.

**Historia:** Desarrollado por Cisco; evolucionó como estándar **IETF IPFIX (IP Flow Information Export)** — `tools.ietf.org/html/rfc7011`.

**Conceptos clave de NetFlow:**

| Concepto | Definición |
|----------|-----------|
| **Etiqueta de flujo** | Selección de claves (características compartidas) que define un flujo |
| **Registro de flujo** | Tráfico que coincide con una etiqueta de flujo |
| **5-tupla** | Los 5 bits de información básica de un flujo |
| **7-tupla** | 5-tupla + interfaz de entrada + tipo de servicio IP |

**Composición de la 5-tupla:**
1. Dirección de origen
2. Dirección de destino
3. Protocolo
4. Puerto de origen
5. Puerto de destino

**Proceso:** El exportador almacena en caché datos de flujos recientes con temporizador de caducidad. Cuando un flujo caduca o se vuelve inactivo → el exportador transmite datos al recopilador.

**Funciones del análisis de flujo:**
- Destacar tendencias y patrones en tráfico generado por aplicaciones, hosts y puertos.
- Alerta basada en detección de anomalías.
- Herramientas de visualización (mapa de conexiones de red).
- Identificación de patrones de usuarios no autorizados, malware en tránsito, túneles.
- Identificación de intentos de malware de contactar canal **C&C** (Comando y Control — Command and Control).

**Herramienta:** `ntopng` (edición comunitaria) para supervisar datos de tráfico NetFlow.

> **👉 Enfoque de Examen SY0-701:** NetFlow registra **metadatos** del tráfico (no el contenido completo). IPFIX es el estándar IETF basado en NetFlow de Cisco. La **5-tupla** es el conjunto mínimo de información que define un flujo. SNMP y NetFlow son complementarios: SNMP monitorea el estado del dispositivo, NetFlow analiza el tráfico. Las capturas SNMP son alertas proactivas del dispositivo.

### Aplicaciones y Sistemas de Monitoreo

#### Monitores y Registros del Sistema

Un **monitor de sistema** implementa la misma funcionalidad que un monitor de red para hosts de equipo:
- Los hosts de servidores pueden informar sobre el estado de salud mediante **capturas SNMP**.

**Importancia del monitoreo proactivo de registros:**
- Los registros asocian acciones a usuarios específicos → razón crítica para no compartir credenciales.
- Si una cuenta está comprometida, no hay forma de relacionar eventos del registro con el atacante real.
- **No consultar registros solo cuando hay un incidente importante** → es perder la oportunidad de detectar amenazas y vulnerabilidades tempranamente.

#### Monitores de Aplicaciones y de la Nube

- **SNMP** ofrece funcionalidad limitada para aplicaciones.
- Numerosas soluciones patentadas para infraestructura, aplicaciones, bases de datos y entornos en nube.
- Un monitor de aplicación incluye: latido básico + número de sesiones/solicitudes, consumo de ancho de banda, utilización de CPU/memoria, condiciones de alerta de error o seguridad.
- **Monitores en la nube:** Evalúan ancho de banda de red, estado de máquinas virtuales y estado de aplicaciones.

#### Escáneres de Vulnerabilidades

Informan el número total de vulnerabilidades no mitigadas por host. La consolidación muestra el estado de seguridad de toda la red y resalta problemas de parches o configuración.

#### Antivirus (A-V)

El **análisis antivirus (A-V)** detecta malware mediante:
- **Firmas** (independientemente del tipo de malware).
- **Análisis de comportamiento** de usuarios y entidades (**UEBA** — User and Entity Behavior Analytics).
- **Análisis respaldado por IA** para detectar comportamientos de actores malintencionados que evadieron la coincidencia de firmas.

**Integración con SIEM:** El antivirus puede configurarse para generar alertas/registros en el panel via integración con SIEM.

**Evolución de suites A-V:**
- **EPP (Endpoint Protection Platform):** Suite integrada.
- **A-V de nueva generación (NGAV):** Combina firmas + análisis de comportamiento + IA.

#### Prevención de Pérdida de Datos (DLP — Data Loss Prevention)

La **DLP** media la copia de datos etiquetados para restringirla a medios y servicios autorizados.

El monitoreo de estadísticas de violaciones de políticas de DLP puede mostrar:
- Si hay problemas de exfiltración.
- Tendencias a lo largo del tiempo.

> **👉 Enfoque de Examen SY0-701:** EPP, EDR y XDR son la evolución del antivirus tradicional. UEBA detecta comportamientos anómalos de usuarios/entidades usando IA/ML. DLP previene la exfiltración de datos etiquetados. El monitoreo de aplicaciones va más allá del simple "latido" (ping) — incluye métricas de rendimiento y errores.

### Indicadores de Referencia (Benchmarks)

**Analogía:** Los indicadores de referencia son como los estándares de construcción que deben cumplir los edificios: los escáneres verifican si la "construcción" (configuración del sistema) cumple con el "código de construcción" (mejores prácticas).

Una función del escaneo de vulnerabilidades es evaluar la **configuración de controles de seguridad** comparándola con **puntos de referencia establecidos**.

**El escáner identifica:**
- Ausencia de controles necesarios.
- Configuración incorrecta que hace controles menos efectivos (ej. antivirus no actualizado, contraseñas de admin en configuración predeterminada).

#### SCAP (Protocolo de Automatización de Contenido de Seguridad — Security Content Automation Protocol)

**Definición:** Permite que escáneres compatibles determinen si un equipo cumple con una línea de base de configuración.

**Componentes clave de SCAP:**

| Componente | Nombre completo | Descripción |
|------------|----------------|-------------|
| **OVAL** | Open Vulnerability and Assessment Language (Lenguaje Abierto de Evaluación y Vulnerabilidad) | Esquema XML para describir estado de seguridad del sistema y consultar informes/datos de vulnerabilidades |
| **XCCDF** | eXtensible Configuration Checklist Description Format (Formato de Descripción de Lista de Verificación de Configuración Extensible) | Esquema XML para desarrollar y auditar listas de verificación y reglas de configuración de mejores prácticas; legible por máquina (puede aplicarse y validarse con software compatible) |

#### Análisis de Cumplimiento

Algunos escáneres miden sistemas contra marcos de mejores prácticas:
- **NIST 800-53** (Marco de controles de seguridad del gobierno de EE. UU.)
- Estándares de la industria.

**Herramientas de ejemplo:**
- **SCAP Compliance Checker** de Microsoft: compara política de seguridad local con una plantilla.
- **Wazuh SIEM:** Panel NIST 800-53 que clasifica controles por estado (cumplido/incumplido).

**Ejemplo de SCAP — plantilla vs. configuración local:**
- Configuración local: `MinimumPasswordLength = 7`
- Plantilla (MSFT Windows 10): `MinimumPasswordLength = 14`
- → La longitud mínima de contraseña local es significativamente menor que la recomendada.

> **👉 Enfoque de Examen SY0-701:** SCAP es el estándar para automatizar la verificación de cumplimiento de configuración. OVAL describe el estado del sistema; XCCDF describe las reglas y listas de verificación. El "análisis de cumplimiento" compara contra marcos como NIST 800-53. Distingue el escáner de vulnerabilidades (busca CVEs) del escáner de configuración/cumplimiento (verifica contra benchmarks). Ambos pueden integrarse con el SIEM.

# 4. Glosario

| Acrónimo | Significado en Español | Significado en Inglés |
|----------|----------------------|----------------------|
| **IR** | Respuesta a Incidentes | Incident Response |
| **IRP** | Plan de Respuesta a Incidentes | Incident Response Plan |
| **CIRT** | Equipo de Respuesta a Incidentes Informáticos | Computer Incident Response Team |
| **CSIRT** | Equipo de Respuesta a Incidentes de Seguridad Informática | Computer Security Incident Response Team |
| **CERT** | Equipo de Respuesta a Emergencias Informáticas | Computer Emergency Response Team |
| **SOC** | Centro de Operaciones de Seguridad | Security Operations Center |
| **SIEM** | Gestión de Información y Eventos de Seguridad | Security Information and Event Management |
| **SOAR** | Orquestación, Automatización y Respuesta de Seguridad | Security Orchestration, Automation and Response |
| **TTP** | Tácticas, Técnicas y Procedimientos | Tactics, Techniques and Procedures |
| **IOC** | Indicador de Compromiso | Indicator of Compromise |
| **C2/C&C** | Mando y Control | Command and Control |
| **DLP** | Prevención de Pérdida de Datos | Data Loss Prevention |
| **BYOD** | Trae Tu Propio Dispositivo | Bring Your Own Device |
| **RCA** | Análisis de Causa Raíz | Root Cause Analysis |
| **LLR** | Informe de Lecciones Aprendidas | Lessons Learned Report |
| **AAR** | Informe Posterior a la Acción | After-Action Report |
| **ESI** | Información Almacenada Electrónicamente | Electronically Stored Information |
| **SOP** | Procedimiento Operativo Estándar | Standard Operating Procedure |
| **IDS** | Sistema de Detección de Intrusiones | Intrusion Detection System |
| **IPS** | Sistema de Prevención de Intrusiones | Intrusion Prevention System |
| **HIDS** | IDS Basado en Host | Host-based IDS |
| **EPP** | Plataforma de Protección de Puntos de Conexión | Endpoint Protection Platform |
| **EDR** | Detección y Respuesta en Endpoints | Endpoint Detection and Response |
| **XDR** | Detección y Respuesta Extendidas | Extended Detection and Response |
| **UEBA** | Análisis de Comportamiento de Usuarios y Entidades | User and Entity Behavior Analytics |
| **A-V** | Antivirus | Antivirus |
| **SNMP** | Protocolo de Administración de Red Simple | Simple Network Management Protocol |
| **IPFIX** | Exportación de Información de Flujo IP | IP Flow Information Export |
| **SCAP** | Protocolo de Automatización de Contenido de Seguridad | Security Content Automation Protocol |
| **OVAL** | Lenguaje Abierto de Evaluación y Vulnerabilidad | Open Vulnerability and Assessment Language |
| **XCCDF** | Formato de Descripción de Lista de Verificación de Config. Extensible | eXtensible Configuration Checklist Description Format |
| **MUA** | Agente de Usuario de Correo | Mail User Agent |
| **MDA** | Agente de Entrega de Correo | Mail Delivery Agent |
| **MTA** | Agente de Transferencia de Mensajes | Mail Transfer Agent |
| **UTC** | Hora Coordinada Universal | Coordinated Universal Time |
| **ESD** | Descarga Electrostática | Electrostatic Discharge |
| **ACL** | Lista de Control de Acceso | Access Control List |
| **VLAN** | Red de Área Local Virtual | Virtual Local Area Network |
| **DDoS** | Denegación de Servicio Distribuida | Distributed Denial of Service |
| **ML** | Aprendizaje Automático | Machine Learning |
| **NTP** | Protocolo de Tiempo de Red | Network Time Protocol |

# 5.  Relaciones Clave

```
INCIDENTE
    │
    ▼
[DETECCIÓN]
    │ ← SIEM, IDS, usuarios, caza de amenazas
    ▼
[ANÁLISIS]
    │ ← TTP, Kill Chain, Playbooks, Impacto
    ▼
[CONTENCIÓN]
    │ ← Aislamiento vs. Segmentación
    ▼
[ERRADICACIÓN]
    │ ← Reconstituir, Auditar controles, Notificar
    ▼
[RECUPERACIÓN]
    │ ← Reintegrar, Monitorear de cerca
    ▼
[LECCIONES APRENDIDAS]
    │ ← LLR/AAR, RCA, Five Whys
    ▼
    ──────────────────────────▶ [PREPARACIÓN] (retroalimenta el ciclo)

FORENSE DIGITAL
└── Debido proceso → Retención legal → Adquisición (RAM→Disco) → Preservación (Hash+Bloqueador) → Elaboración de informes

FUENTES DE DATOS
├── Registros del SO (Windows Event, Syslog, Linux /var/log/*)
├── Registros de red (Cortafuegos, IDS/IPS, Switch, AP)
├── Metadatos (Archivos, Web, Correo)
└── SIEM (agrega, correlaciona y normaliza todo lo anterior)

HERRAMIENTAS DE MONITOREO
├── SIEM → recopila + correlaciona + alerta + informa + archiva
├── SOAR → automatiza la respuesta del SIEM
├── NetFlow/IPFIX → metadatos de tráfico (5-tupla)
├── SNMP → estado de dispositivos (capturas/traps)
├── EPP/EDR/XDR → seguridad de endpoints
├── DLP → prevención de exfiltración
└── SCAP (OVAL+XCCDF) → cumplimiento de configuración
```