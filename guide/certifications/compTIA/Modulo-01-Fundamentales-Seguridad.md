> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Seguridad de la Información (Infosec)](#1-seguridad-de-la-información-infosec)
  - [¿Qué es la Seguridad de la Información?](#qué-es-la-seguridad-de-la-información)
  - [Tríada CIA (también llamada AIC)](#tríada-cia-también-llamada-aic)
  - [No Repudio](#no-repudio)
- [2. Marco de Ciberseguridad (CSF)](#2-marco-de-ciberseguridad-csf)
  - [¿Qué es la Ciberseguridad?](#qué-es-la-ciberseguridad)
  - [Marco del NIST (National Institute of Standards and Technology)](#marco-del-nist-national-institute-of-standards-and-technology)
- [3. Análisis de Deficiencias (Gap Analysis)](#3-análisis-de-deficiencias-gap-analysis)
  - [¿Por qué se necesitan marcos?](#por-qué-se-necesitan-marcos)
  - [El Análisis de Deficiencias (Gap Analysis)](#el-análisis-de-deficiencias-gap-analysis)
  - [Informe de Análisis de Deficiencias](#informe-de-análisis-de-deficiencias)
- [4. Control de Acceso e IAM](#4-control-de-acceso-e-iam)
  - [¿Qué es el Control de Acceso?](#qué-es-el-control-de-acceso)
  - [IAM — Gestión de Identidades y Accesos](#iam--gestión-de-identidades-y-accesos)
  - [Ejemplo Práctico: E-Commerce](#ejemplo-práctico-e-commerce)
- [5. Clasificación de los Controles de Seguridad](#5-clasificación-de-los-controles-de-seguridad)
  - [¿Qué es un Control de Seguridad?](#qué-es-un-control-de-seguridad)
  - [Las 4 Categorías de Controles (por FORMA de implementación)](#las-4-categorías-de-controles-por-forma-de-implementación)
- [6. Tipos Funcionales de Controles de Seguridad](#6-tipos-funcionales-de-controles-de-seguridad)
  - [Clasificación por FUNCIÓN u OBJETIVO](#clasificación-por-función-u-objetivo)
    - [Controles Principales (los 3 fundamentales)](#controles-principales-los-3-fundamentales)
    - [Controles Adicionales (tipos complementarios)](#controles-adicionales-tipos-complementarios)
  - [Tabla Comparativa Completa](#tabla-comparativa-completa)
  - [Caso especial: Gestión de Parches](#caso-especial-gestión-de-parches)
- [7. Funciones y Responsabilidades de Seguridad](#7-funciones-y-responsabilidades-de-seguridad)
  - [¿Qué es una Política de Seguridad?](#qué-es-una-política-de-seguridad)
  - [Jerarquía de Roles y Responsabilidades](#jerarquía-de-roles-y-responsabilidades)
- [8. Competencias de la Seguridad de la Información](#8-competencias-de-la-seguridad-de-la-información)
  - [¿Qué hace un profesional de seguridad de TI?](#qué-hace-un-profesional-de-seguridad-de-ti)
- [9. Unidades de Negocio de Seguridad de la Información](#9-unidades-de-negocio-de-seguridad-de-la-información)
  - [Unidades organizativas de seguridad](#unidades-organizativas-de-seguridad)
  - [SOC — Centro de Operaciones de Seguridad](#soc--centro-de-operaciones-de-seguridad)
  - [DevSecOps](#devsecops)
  - [CIRT / CSIRT / CERT — Equipo de Respuesta a Incidentes](#cirt--csirt--cert--equipo-de-respuesta-a-incidentes)
- [10 Glosario](#10-glosario)

---

# 1. Seguridad de la Información (Infosec)

## ¿Qué es la Seguridad de la Información?

La **seguridad de la información** (infosec, por *Information Security*) se refiere a la **protección de recursos de datos** contra:
- Accesos no autorizados
- Ataques
- Robos
- Daños

Los datos pueden ser vulnerables en tres estados:
- **Almacenados** (datos en reposo)
- **Transferidos** (datos en tránsito)
- **Procesados** (datos en uso)

> **Analogía del mundo real:** Imagina un banco. El dinero (los datos) debe ser accesible solo para los titulares de la cuenta (confidencialidad), los saldos no deben modificarse sin transacciones válidas (integridad) y los cajeros ATM deben funcionar 24/7 (disponibilidad).

## Tríada CIA (también llamada AIC)

| Propiedad | Definición | Ejemplo práctico |
|---|---|---|
| **C — Confidencialidad** *(Confidentiality)* | Solo personas autorizadas pueden leer la información | Solo tu médico puede ver tu historial clínico |
| **I — Integridad** *(Integrity)* | Los datos se almacenan y transfieren tal como se prevé; modificaciones no autorizadas están prohibidas | El saldo de tu cuenta bancaria no cambia sin una transacción válida |
| **A — Disponibilidad** *(Availability)* | La información está accesible para usuarios autorizados cuando la necesitan | Los servidores de tu banco deben estar operativos cuando quieras hacer una transferencia |

> **Analogía:** La tríada CIA es como las tres patas de un taburete: si falta una, el sistema se cae.

> **Nota importante:** La tríada también se denomina **AIC** (Availability, Integrity, Confidentiality) para evitar confusiones con la Agencia Central de Inteligencia (CIA).

## No Repudio

**Definición:** El **no repudio** significa que una persona **no puede negar** haber realizado una acción, como:
- Crear un recurso
- Modificar un recurso
- Enviar un recurso

**Ejemplo:** Un testamento debe ser atestiguado al firmarse. Si hay disputa, el testigo proporciona evidencia de que se ejecutó correctamente.

> **Analogía:** Cuando firmas un contrato ante notario, no puedes después afirmar que nunca lo firmaste. El notario es la prueba de no repudio.

> El no repudio es identificado por algunos modelos de seguridad como una **cuarta propiedad esencial** además de la tríada CIA.


> **👉 Enfoque de Examen SY0-701:**
> CompTIA pregunta frecuentemente sobre qué propiedad de la tríada CIA se ve comprometida en un escenario dado. Distractores comunes:
> - Confundir **integridad** con **disponibilidad** (un ataque que corrompe datos vs. uno que los hace inaccesibles).
> - Pensar que el **no repudio** es parte oficial de la tríada: **NO lo es**, es una propiedad adicional.
> - La tríada se puede llamar **CIA o AIC** — ambas son correctas; no te dejes confundir por el orden.
> - Vigilar preguntas como: *"¿Qué propiedad garantiza que un empleado no pueda negar haber enviado un correo electrónico?"* → Respuesta: **No repudio**.


# 2. Marco de Ciberseguridad (CSF)

## ¿Qué es la Ciberseguridad?

La **ciberseguridad** hace referencia al **aprovisionamiento de hardware y software de procesamiento seguro** de forma específica. Es un subconjunto de la seguridad de la información centrado en los sistemas digitales.

> **Analogía:** Si la seguridad de la información es proteger el "qué" (los datos), la ciberseguridad es proteger el "cómo" (el hardware y software que procesa esos datos).

## Marco del NIST (National Institute of Standards and Technology)

El **NIST** *(National Institute of Standards and Technology)* desarrolló el **CSF** *(Cybersecurity Framework / Marco de Ciberseguridad)* que clasifica las tareas de ciberseguridad en **5 funciones**:

```
NIST CSF — Las 5 Funciones Clave
─────────────────────────────────────────────────────────────
  [IDENTIFICAR] → [PROTEGER] → [DETECTAR] ↔ [RESPONDER] → [RECUPERAR]
                                    ↑_____________________________|
                                    (retroalimentación continua)
─────────────────────────────────────────────────────────────
```

| # | Función | Descripción | Ejemplo |
|---|---|---|---|
| 1 | **Identificar** *(Identify)* | Desarrollar políticas y capacidades. Evaluar riesgos, amenazas y vulnerabilidades. Recomendar controles de mitigación. | Inventario de activos de la empresa |
| 2 | **Proteger** *(Protect)* | Instalar, operar y desmantelar activos de hardware/software con seguridad integrada en cada etapa del ciclo de vida | Cifrado de datos, control de acceso |
| 3 | **Detectar** *(Detect)* | Monitoreo continuo y proactivo para garantizar que los controles sean efectivos y capaces de proteger contra nuevas amenazas | SIEM, IDS |
| 4 | **Responder** *(Respond)* | Identificar, analizar, contener y erradicar amenazas a los sistemas y la seguridad de los datos | Plan de respuesta a incidentes |
| 5 | **Recuperar** *(Recover)* | Implementar resiliencia de ciberseguridad para restaurar sistemas y datos si otros controles no pueden prevenir ataques | Backup y recuperación ante desastres |

> 📌 El NIST CSF es **solo un ejemplo**. Existen **muchos otros marcos de ciberseguridad (CSF)**.

> Referencia oficial: `nist.gov/cyberframework/online-learning/five-functions`

> **👉 Enfoque de Examen SY0-701:**
> Las preguntas sobre el marco NIST suelen ser de escenario: *"Una empresa implementa monitoreo continuo de sus sistemas. ¿A qué función del NIST CSF corresponde?"* → **Detectar**.
> Distractores comunes:
> - Confundir **Responder** con **Recuperar**: Responder = durante/inmediatamente después del incidente; Recuperar = restaurar la normalidad operativa.
> - Confundir **Identificar** con **Detectar**: Identificar es proactivo (políticas, inventarios); Detectar es monitoreo activo.
> - Recuerda que la **retroalimentación** fluye desde Detectar/Responder hacia Identificar.

# 3. Análisis de Deficiencias (Gap Analysis)

## ¿Por qué se necesitan marcos?

Un **marco de ciberseguridad**:
- Evita construir el programa de seguridad "en el vacío"
- Guía la selección y configuración de controles
- Permite hacer una **declaración objetiva** de las capacidades actuales
- Identifica un **nivel de capacidad objetivo**
- **Prioriza inversiones** para alcanzar ese objetivo
- Proporciona una declaración de **cumplimiento normativo** verificable externamente
- Da estructura a los **procedimientos internos de gestión de riesgos**

> **Analogía:** Un marco de ciberseguridad es como las normas de construcción de edificios: no inventas las reglas de seguridad estructural desde cero; sigues un estándar probado para no olvidar elementos críticos.

## El Análisis de Deficiencias (Gap Analysis)

**Definición:** El **análisis de deficiencias** *(Gap Analysis)* es el proceso que identifica **cómo los sistemas de seguridad de una organización difieren** de los que exige o recomienda un marco de referencia.

**¿Cuándo se realiza?**
- Al adoptar un marco por primera vez
- Al cumplir con un nuevo requisito de cumplimiento industrial o legal
- Periódicamente (cada pocos años) para validar cambios en el marco

> **Analogía:** Es como una revisión técnica de tu coche. El inspector compara el estado actual de tu vehículo con los estándares mínimos de seguridad vial y te dice qué está faltando o mal configurado.

## Informe de Análisis de Deficiencias

Un informe de análisis de deficiencias incluye, **por cada sección del marco**:

| Elemento del Informe | Descripción |
|---|---|
| **Puntuación general** | Nivel de capacidad alcanzado vs. requerido |
| **Lista de controles faltantes** | Controles que no se implementaron |
| **Lista de controles mal configurados** | Controles existentes pero incorrectos |
| **Niveles de riesgo CIA** | Impacto sobre Confidencialidad, Integridad y Disponibilidad |
| **Fecha de remediación objetivo** | Plazo para corregir las deficiencias (ej. Q1, Q3, Q4) |

**Ejemplo real del documento** (función Identificar):

| Función | Controles (Actual/Requerido) | Capacidad | C | I | A | Remediación |
|---|---|---|---|---|---|---|
| Gestión de activos | 4/6 | Intermedia | 6 | 6 | 6 | Q4 |
| Gobernanza | 3/4 | Intermedia | 6 | 6 | 1 | Q3 |
| Evaluación de riesgos | 3/6 | Sin/Básica | 6 | 6 | 3 | Q3 |
| Gestión de identidad y acceso | 5/8 | Intermedia | 9 | 9 | 4 | Q1 |
| Seguridad de datos | 3/8 | Sin/Básica | 9 | 9 | 4 | Q1 |

**¿Quién realiza el análisis?**
- Puede realizarlo el **equipo de seguridad interno**
- Generalmente involucra **consultores externos** (por la complejidad de los marcos y regulaciones)
- Los externos aportan perspectiva fresca y alertan sobre **descuidos y nuevas tendencias**

> **👉 Enfoque de Examen SY0-701:**
> Las preguntas sobre Gap Analysis suelen preguntar *cuál es su propósito* o *cuándo se realiza*. Vigilar:
> - No confundir **Gap Analysis** con **Risk Assessment** (evaluación de riesgos): el Gap Analysis compara contra un marco estándar; el Risk Assessment evalúa amenazas específicas del negocio.
> - El análisis de deficiencias **puede repetirse periódicamente**, no es un proceso de una sola vez.
> - La implicación de **consultores externos** es una característica importante: aportan objetividad.

# 4. Control de Acceso e IAM

## ¿Qué es el Control de Acceso?

Un **sistema de control de acceso** garantiza que un sistema de información cumpla con los objetivos de la **tríada CIA**.

**Conceptos clave:**

| Término | Definición | Ejemplo |
|---|---|---|
| **Sujeto** | Persona, dispositivo, proceso de software o sistema que solicita acceso | Un usuario, una aplicación, un servidor |
| **Objeto** | El recurso al que se accede | Una red, servidor, base de datos, aplicación, archivo |
| **Derechos/Permisos** | Lo que el sujeto puede hacer sobre el objeto | Leer, escribir, ejecutar, eliminar |


> **Analogía:** Piensa en un edificio de oficinas. Hay empleados (sujetos), hay salas de reuniones, servidores y archivos (objetos). El sistema de tarjetas de acceso determina quién puede entrar dónde: eso es control de acceso.

## IAM — Gestión de Identidades y Accesos

El **IAM** *(Identity and Access Management / Gestión de Identidades y Accesos)* comprende **4 procesos principales**:

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUJO IAM                                │
│                                                             │
│  1. IDENTIFICACIÓN → 2. AUTENTICACIÓN → 3. AUTORIZACIÓN     │
│         ↓                    ↓                  ↓           │
│   Crear cuenta           Verificar          Asignar         │
│   única de usuario       credencial         derechos        │
│                                                             │
│                    4. REGISTRO (AUDITORÍA)                  │
│             (monitorea TODO el proceso)                     │
└─────────────────────────────────────────────────────────────┘
```

| Proceso | Definición | Ejemplo práctico |
|---|---|---|
| **1. Identificación** | Crear una cuenta o ID que represente de forma única al usuario, dispositivo o proceso en la red | Alta de usuario en Active Directory; registro de cliente en e-commerce |
| **2. Autenticación** | Demostrar que un sujeto es quien dice ser al intentar acceder al recurso | Contraseña, certificado digital, huella dactilar |
| **3. Autorización** | Determinar qué derechos tiene el sujeto sobre cada recurso y hacerlos valer | **ACL** *(Access Control List / Lista de Control de Acceso)*: permite o deniega lectura/escritura |
| **4. Registro** | Seguimiento del uso autorizado/no autorizado de recursos; alertas ante intentos de acceso no autorizado | Logs de auditoría, SIEM |

**Modelos de autorización:**
- **Modelo discrecional:** El **propietario del objeto** puede asignar derechos
- **Modelo obligatorio:** Los derechos están **predeterminados por reglas del sistema**; ningún usuario puede cambiarlos

*(Identity and Access Management)*

> **Analogía:** IAM es como el proceso completo de contratación de un empleado: primero se crea su expediente (identificación), luego se verifica quién es con su DNI (autenticación), luego se le asignan las llaves de las salas que necesita (autorización), y finalmente se registra cada vez que entra y sale de cada sala (registro/auditoría).

## Ejemplo Práctico: E-Commerce

Configurando un sitio de comercio electrónico, cada proceso IAM se implementa así:

| Proceso IAM | Implementación en E-Commerce |
|---|---|
| **Identificación** | Verificar que las direcciones de facturación/entrega coincidan; detectar métodos de pago fraudulentos |
| **Autenticación** | Cuentas únicas por cliente; solo el titular puede gestionar pedidos e información de facturación |
| **Autorización** | Solo clientes con métodos de pago válidos pueden realizar pedidos; esquemas de lealtad para ofertas exclusivas |
| **Registro** | Registrar todas las acciones del cliente (garantiza el no repudio: no puede negar haber realizado un pedido) |

> 📌 **Nota:** Los servidores también participan en IAM. Por ejemplo, tu servidor de e-commerce debe **autenticar su identidad** ante los clientes cuando se conectan vía navegador (certificado TLS/HTTPS).

> Los servidores y protocolos que implementan estas funciones también se conocen como **AAA** *(Authentication, Authorization, and Accounting / Autenticación, Autorización y Registro)*.

> **👉 Enfoque de Examen SY0-701:**
> Este es uno de los temas más preguntados. Puntos clave:
> - Diferencia entre **Identificación** (crear identidad) y **Autenticación** (verificar identidad): son pasos distintos y secuenciales.
> - Las **ACL** *(Access Control Lists)* son herramientas de **autorización**, no de autenticación.
> - El término **AAA** (Authentication, Authorization, Accounting) es sinónimo práctico de los pasos 2-4 del IAM; IAM es más amplio porque incluye la **Identificación** (paso 1).
> - Preguntas de escenario típicas: *"Un empleado se autentica en el sistema pero no puede acceder a una carpeta compartida. ¿Qué proceso IAM está fallando?"* → **Autorización** (el usuario está autenticado pero sin permisos sobre ese objeto).
> - El **modelo discrecional** (DAC) vs. **modelo obligatorio** (MAC) son conceptos que CompTIA desarrolla en profundidad en temas posteriores.


# 5. Clasificación de los Controles de Seguridad

## ¿Qué es un Control de Seguridad?

La garantía de información y ciberseguridad se cumple mediante la implementación de **controles de seguridad**.

**Definición:** Un **control de seguridad** es algo diseñado para dar a un sistema o activo de datos las propiedades de:
- **Confidencialidad**
- **Integridad**
- **Disponibilidad**
- **No repudio**

> **Analogía:** Si un banco es el sistema de información, los controles de seguridad son todas las medidas que lo protegen: la cámara acorazada (técnico), los guardias de seguridad (operacional), las cámaras de vigilancia (físico) y las políticas de auditoría interna (gerencial).

## Las 4 Categorías de Controles (por FORMA de implementación)

| Categoría | Descripción | Ejemplos |
|---|---|---|
| **Gerencial** *(Managerial)* | Supervisa el sistema de información. Herramientas que evalúan y seleccionan otros controles de seguridad | Identificación de riesgos, evaluación de riesgos, gestión de políticas |
| **Operacional** *(Operational)* | Implementado **principalmente por personas** | Guardias de seguridad, programas de capacitación, procedimientos manuales |
| **Técnico** *(Technical)* | Aplicado como un **sistema** (hardware, software o firmware) | Cortafuegos *(firewalls)*, software antivirus, modelos de control de acceso del SO |
| **Físico** *(Physical)* | Controles que disuaden y detectan el acceso a **instalaciones y hardware** | Alarmas, puertas de enlace, cerraduras, iluminación, cámaras de seguridad |

> 📌 **Referencia NIST:** El NIST clasifica los controles de seguridad con un esquema diferente pero complementario: `csrc.nist.gov/pubs/sp/800/53/r5/upd1/final` (NIST SP 800-53).

> **Analogía:** Imagina que proteger una joyería requiere: un gerente que diseña el plan de seguridad (gerencial), guardias que patrullan (operacional), alarmas y cámaras (técnico) y cerraduras y rejas físicas (físico).

> **👉 Enfoque de Examen SY0-701:**
> CompTIA combina estas categorías con los tipos funcionales (siguiente sección) en preguntas complejas. Ejemplos típicos:
> - *"Un guardia de seguridad en la entrada del datacenter es un control ___."* → **Operacional Y Físico** (puede tener doble categoría).
> - *"Un firewall configurado para bloquear tráfico no autorizado es un control ___."* → **Técnico**.
> - *"Una política de uso aceptable es un control ___."* → **Gerencial** (algunos también dirían Operacional).
> - Vigilar la distinción entre **Técnico** y **Físico**: las cámaras son **Físico**; el software de monitoreo de red es **Técnico**.

# 6. Tipos Funcionales de Controles de Seguridad

## Clasificación por FUNCIÓN u OBJETIVO

Los controles se pueden clasificar según **cuándo actúan** y **qué objetivo cumplen**:

> **Analogía temporal:** Piensa en un robo en un museo. Antes del robo: alarma visible en la puerta (preventivo/disuasivo). Durante el robo: cámara que graba y sensor de movimiento (detección). Después del robo: seguro que cubre las pérdidas (correctivo). Si el sistema de alarma falla, hay un guardia humano (compensatorio).

### Controles Principales (los 3 fundamentales)

| Tipo Funcional | ¿Cuándo actúa? | Descripción | Ejemplos |
|---|---|---|---|
| **Preventivo** *(Preventive)* | **ANTES** del ataque | Elimina o reduce la probabilidad de que un ataque tenga éxito | **ACL** en cortafuegos, software antimalware, gestión de parches proactiva, políticas y **SOP** *(Standard Operating Procedures / Procedimientos Operativos Estándar)* |
| **De Detección** *(Detective)* | **DURANTE** el ataque | No previene el acceso, pero detecta y registra intentos o hechos de intrusión | Logs de auditoría (registros), sistemas IDS *(Intrusion Detection System)*, cámaras de seguridad |
| **Correctivo** *(Corrective)* | **DESPUÉS** del ataque | Elimina o reduce el impacto de una violación de la política de seguridad | Sistemas de **backup** *(copia de seguridad)* que restauran datos dañados, parches aplicados post-incidente |

### Controles Adicionales (tipos complementarios)

| Tipo Funcional | Descripción | Ejemplos |
|---|---|---|
| **Directivo** *(Directive)* | Impone una **regla de comportamiento**: política, estándar de mejores prácticas o SOP | Contratos de empleados con cláusulas disciplinarias, programas de capacitación y concientización |
| **Disuasivo** *(Deterrent)* | No impide física ni lógicamente el acceso, pero **psicológicamente desalienta** al atacante | Señales de advertencia, avisos de sanciones legales contra intrusión, cámaras visibles |
| **Compensatorio** *(Compensating)* | Sustituto de un control principal que ofrece el **mismo nivel de protección o mejor** usando diferente metodología/tecnología | Segmentación de red para aislar un sistema legado que no puede actualizarse |

## Tabla Comparativa Completa

| Control | ¿Cuándo? | Propósito | Ejemplo clave |
|---|---|---|---|
| **Preventivo** | Antes | Bloquear el ataque | Firewall ACL, antivirus |
| **De Detección** | Durante | Identificar el ataque | Logs, IDS |
| **Correctivo** | Después | Mitigar el daño | Backup y restauración |
| **Directivo** | Siempre | Dictar comportamiento | Políticas, SOP |
| **Disuasivo** | Antes (psicológico) | Desalentar al atacante | Señales de advertencia |
| **Compensatorio** | Siempre | Reemplazar un control principal | Segmentación de red para sistema legado |

## Caso especial: Gestión de Parches

La **gestión de parches** puede ser:
- **Preventivo:** Cuando se aplica **proactivamente** antes de que una vulnerabilidad sea explotada
- **Correctivo:** Cuando se aplica **reactivamente** para remediar una vulnerabilidad conocida después de su descubrimiento

> **👉 Enfoque de Examen SY0-701:**
> Este tema es MUY frecuente en preguntas de escenario con múltiple opción. Las combinaciones más vigiladas:
> - *"Una empresa instala cámaras visibles en la entrada. ¿Qué tipo de control es?"* → **Disuasivo** (y también físico por categoría). Cuidado: si graban activamente, también es **De Detección**.
> - *"Los logs del servidor registran intentos fallidos de login. ¿Qué tipo de control son los logs?"* → **De Detección**.
> - *"Un sistema de backup permite restaurar archivos cifrados por ransomware. ¿Qué tipo de control es?"* → **Correctivo**.
> - *"Un sistema legado no puede parchearse. Se segmenta la red para aislarlo. ¿Qué tipo de control es la segmentación?"* → **Compensatorio**.
> - **Distractor clásico:** El control **Disuasivo** vs. **Preventivo**: disuasivo actúa en la psicología del atacante (no lo bloquea físicamente); preventivo bloquea el ataque técnica o físicamente.
> - La **gestión de parches** puede ser **preventiva O correctiva** dependiendo del contexto: aprende a identificar ambos casos.

# 7. Funciones y Responsabilidades de Seguridad

## ¿Qué es una Política de Seguridad?

Una **política de seguridad** es una **declaración formalizada** que define cómo se implementará la seguridad dentro de una organización. Describe los medios para proteger la **confidencialidad, disponibilidad e integridad** de los datos y recursos confidenciales.

Una organización que desarrolla políticas de seguridad y usa controles basados en marcos tiene una **postura de seguridad sólida** *(security posture)*.

> **Analogía:** La política de seguridad es como la constitución de una empresa: es el documento fundamental que define cómo se protegen los activos y cuáles son las reglas del juego para todos.

## Jerarquía de Roles y Responsabilidades

```
┌────────────────────────────────────────────────────────────┐
│              JERARQUÍA DE RESPONSABILIDAD                  │
│                                                            │
│  ┌──────────────────────────────────┐                      │
│  │  CIO (Chief Information Officer) │ ← Responsabilidad    │
│  │  CTO (Chief Technology Officer)  │   general de TI      │
│  └──────────────────┬───────────────┘                      │
│                     │                                      │
│  ┌──────────────────▼───────────────┐                      │
│  │  CSO (Chief Security Officer)    │ ← Seguridad interna  │
│  │  CISO (Chief Info. Sec. Officer) │   (org. grandes)     │
│  └──────────────────┬───────────────┘                      │
│                     │                                      │
│  ┌──────────────────▼───────────────┐                      │
│  │  Gestores de Área                │ ← Ámbito específico  │
│  │  (edificios, web, contabilidad)  │                      │
│  └──────────────────┬───────────────┘                      │
│                     │                                      │
│  ┌──────────────────▼───────────────┐                      │
│  │  Personal Técnico / ISSO         │ ← Implementación     │
│  │  (administradores de sistemas y  │   y monitoreo        │
│  │   redes, especialistas seguridad)│                      │
│  └──────────────────┬───────────────┘                      │
│                     │                                      │
│  ┌──────────────────▼───────────────┐                      │
│  │  Personal No Técnico             │ ← Cumplimiento de    │
│  │  (todos los empleados)           │   política y ley     │
│  └──────────────────────────────────┘                      │
│                                                            │
│  ⚠️ Responsabilidad externa (diligencia debida):          │
│     recae en DIRECTORES y PROPIETARIOS                     │
└────────────────────────────────────────────────────────────┘
```

| Rol | Sigla | Responsabilidad Principal |
|---|---|---|
| **Chief Information Officer** | **CIO** | Responsabilidad general de la función de TI (puede incluir seguridad directa) |
| **Chief Technology Officer** | **CTO** | Uso efectivo de productos y soluciones de TI nuevos y emergentes para objetivos empresariales |
| **Chief Security Officer** | **CSO** | Dirección del departamento de seguridad interno (organizaciones grandes) |
| **Chief Information Security Officer** | **CISO** | Responsabilidad interna específica de seguridad de la información |
| **Information Systems Security Officer** | **ISSO** | Implementación técnica, mantenimiento y monitoreo de la política de seguridad |

> 📌 **Marco NICE del NIST:** La **NICE** *(National Initiative for Cybersecurity Education / Iniciativa Nacional para la Educación en Ciberseguridad)* del NIST categoriza las tareas y funciones laborales dentro de la industria de la ciberseguridad.
> Referencia: `nist.gov/itl/applied-cybersecurity/nice/nice-framework-resource-center`

> **Analogía:** Como en un ejército: el General (CIO/CISO) define la estrategia, los oficiales (gestores) dirigen unidades específicas, los soldados (personal técnico) ejecutan las operaciones, y todos los reclutas (personal no técnico) deben seguir el reglamento.

> **👉 Enfoque de Examen SY0-701:**
> Las preguntas sobre roles preguntan principalmente por la responsabilidad de cada cargo. Puntos a vigilar:
> - **CIO** vs. **CISO**: el CIO tiene responsabilidad general de TI; el CISO se especializa en seguridad de la información.
> - **CSO** vs. **CISO**: en la práctica, ambos pueden tener roles similares, pero el CSO puede abarcar también seguridad física; el CISO es específico de información.
> - **ISSO**: es el nivel técnico de implementación, por debajo del CISO.
> - La responsabilidad externa (legal/diligencia debida) recae en **directores y propietarios**, no solo en el equipo de TI.
> - El marco **NICE del NIST** es el estándar para categorizar roles en ciberseguridad en EE.UU.

# 8. Competencias de la Seguridad de la Información

## ¿Qué hace un profesional de seguridad de TI?

Los profesionales de TI con responsabilidades en seguridad deben ser competentes en una **amplia gama de disciplinas**: desde diseño de redes y aplicaciones hasta adquisiciones y recursos humanos (**RR. HH.**).

**Actividades típicas del rol:**

- Participar en **evaluaciones de riesgos** y pruebas de sistemas de seguridad y hacer recomendaciones
- Especificar, obtener, instalar y **configurar dispositivos y software seguros**
- Configurar y mantener el **control de acceso** a documentos y los **perfiles de privilegios** de usuario
- Supervisar los **registros de auditoría**, revisar los **privilegios de usuario** y documentar los controles de acceso
- Gestionar la **respuesta y los informes de incidentes** relacionados con la seguridad
- Crear y probar **planes y procedimientos de continuidad del negocio** y **recuperación de desastres**
- Participar en programas de **capacitación y educación** en seguridad

> **Analogía:** Un profesional de seguridad de TI es como un inspector de salud y seguridad en una fábrica: evalúa riesgos, recomienda equipos de protección, instala sistemas de seguridad, supervisa que todo funcione, responde a accidentes y entrena al personal.

> **👉 Enfoque de Examen SY0-701:**
> CompTIA puede preguntar sobre qué actividades corresponden a qué roles. Clave:
> - La **respuesta a incidentes** y la **continuidad del negocio** son competencias del profesional de seguridad, no solo del equipo directivo.
> - La **revisión periódica de privilegios de usuario** (principle of least privilege) es una tarea activa del profesional técnico.
> - Estas competencias conectan directamente con los objetivos del examen SY0-701 en los dominios de Gestión de Riesgos y Operaciones de Seguridad.

# 9. Unidades de Negocio de Seguridad de la Información

## Unidades organizativas de seguridad

Las siguientes unidades representan la función de seguridad dentro de la jerarquía organizacional:

## SOC — Centro de Operaciones de Seguridad

**Definición:** Un **SOC** *(Security Operations Center / Centro de Operaciones de Seguridad)* es un lugar donde profesionales de seguridad **supervisan y protegen los activos de información críticos** en diversas funciones empresariales:
- Finanzas
- Operaciones
- Ventas
- Marketing
- y otras

**Funciones del SOC:**
- Detección rápida de incidentes
- Respuesta rápida a incidentes
- Supervisión continua de las operaciones de ciberseguridad

**¿Quién usa SOCs?**
- Principalmente **corporaciones grandes** (gobiernos, empresas de atención médica)
- Son difíciles de establecer, mantener y financiar, por lo que no todas las organizaciones los tienen

> **Analogía:** El SOC es como el centro de control de una central eléctrica: un lugar centralizado donde especialistas monitorean en tiempo real todos los sistemas críticos y responden inmediatamente ante cualquier anomalía.

## DevSecOps

**DevOps** *(Development + Operations / Desarrollo y Operaciones)*: cambio cultural que fomenta **mayor colaboración** entre desarrolladores y administradores de sistemas para:
- Crear software más rápido
- Probar software más rápido
- Lanzar software más confiable

**DevSecOps** *(Development + Security + Operations)*: extiende DevOps integrando a **especialistas y personal de seguridad** en el proceso. Principios:

| Concepto | Descripción |
|---|---|
| **Seguridad como consideración primordial** | La seguridad es parte de TODAS las etapas del desarrollo e implementación de software |
| **Desplazamiento a la izquierda** *(Shift Left)* | Las consideraciones de seguridad deben hacerse durante las fases de **requisitos y planificación**, NO injertarse al final |
| **Integración de experiencia en seguridad** | La experiencia en seguridad debe integrarse en cualquier proyecto de desarrollo |
| **Automatización de seguridad** | Las herramientas de seguridad se pueden automatizar a través de código |
| **Operaciones de seguridad como desarrollo** | Las operaciones de seguridad pueden concebirse como proyectos de desarrollo de software |

```
ANTES (Tradicional):
[Requisitos] → [Diseño] → [Desarrollo] → [Pruebas] → [Despliegue] → [Seguridad ❌]

CON DEVSECOPS ("Shift Left"):
[Req. + Seg.] → [Diseño + Seg.] → [Dev. + Seg.] → [Pruebas + Seg.] → [Despliegue + Seg.]
     ↑
  La seguridad se integra desde el INICIO
```

> **Analogía:** Antes, la seguridad era como añadir el airbag a un coche ya fabricado. DevSecOps es integrar el diseño de seguridad desde que se dibuja el primer plano del vehículo.

## CIRT / CSIRT / CERT — Equipo de Respuesta a Incidentes

| Sigla | Significado |
|---|---|
| **CIRT** | *Computer Incident Response Team* — Equipo Especializado de Respuesta a Incidentes Informáticos |
| **CSIRT** | *Computer Security Incident Response Team* — Equipo de Respuesta a Incidentes de Seguridad Informática |
| **CERT** | *Computer Emergency Response Team* — Equipo de Respuesta a Emergencias Informáticas |

> Estas tres siglas describen **el mismo concepto** con nombres alternativos.

**Función principal:**
- Actúa como **punto único de contacto** para la notificación de incidentes de seguridad

**Estructura organizativa:**
- Puede estar a cargo del **SOC** (integrado)
- O puede establecerse como una **unidad de negocio independiente**

# 10 Glosario

| Sigla / Término | Significado completo | Descripción breve |
|---|---|---|
| **AAA** | Authentication, Authorization, Accounting | Protocolo/proceso de autenticación, autorización y registro |
| **ACL** | Access Control List | Lista de Control de Acceso: permite/deniega acciones sobre objetos |
| **AIC** | Availability, Integrity, Confidentiality | Alternativa al orden CIA para evitar confusión |
| **CERT** | Computer Emergency Response Team | Equipo de respuesta a emergencias informáticas |
| **CIA** | Confidentiality, Integrity, Availability | Tríada fundamental de la seguridad de la información |
| **CIO** | Chief Information Officer | Director de Sistemas de Información |
| **CIRT** | Computer Incident Response Team | Equipo de respuesta a incidentes informáticos |
| **CISO** | Chief Information Security Officer | Director de Seguridad de la Información |
| **CSF** | Cybersecurity Framework | Marco de Ciberseguridad |
| **CSIRT** | Computer Security Incident Response Team | Equipo de respuesta a incidentes de seguridad informática |
| **CSO** | Chief Security Officer | Director de Seguridad |
| **CTO** | Chief Technology Officer | Director de Tecnología |
| **DevOps** | Development + Operations | Cultura de colaboración entre desarrollo y operaciones |
| **DevSecOps** | Development + Security + Operations | DevOps con seguridad integrada desde el inicio |
| **IAM** | Identity and Access Management | Gestión de Identidades y Accesos |
| **IDS** | Intrusion Detection System | Sistema de Detección de Intrusiones |
| **infosec** | Information Security | Seguridad de la Información |
| **ISSO** | Information Systems Security Officer | Oficial de Seguridad de Sistemas de Información |
| **NICE** | National Initiative for Cybersecurity Education | Iniciativa Nacional para la Educación en Ciberseguridad (NIST) |
| **NIST** | National Institute of Standards and Technology | Instituto Nacional de Estándares y Tecnología (EE.UU.) |
| **RR. HH.** | Recursos Humanos | Departamento de gestión de personal |
| **SIEM** | Security Information and Event Management | Sistema de Gestión de Información y Eventos de Seguridad |
| **SOC** | Security Operations Center | Centro de Operaciones de Seguridad |
| **SOP** | Standard Operating Procedures | Procedimientos Operativos Estándar |
| **TLS** | Transport Layer Security | Protocolo de seguridad para comunicaciones en red (sucesor de SSL) |