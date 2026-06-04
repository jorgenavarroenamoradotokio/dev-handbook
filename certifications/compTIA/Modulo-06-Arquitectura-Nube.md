> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Modelos de Despliegue en la Nube](#1-modelos-de-despliegue-en-la-nube)
    - [Tipos de Modelos de Despliegue](#tipos-de-modelos-de-despliegue)
    - [Consideraciones de Seguridad por Arquitectura](#consideraciones-de-seguridad-por-arquitectura)
    - [Nube Híbrida — Desafíos de Seguridad Específicos](#nube-híbrida--desafíos-de-seguridad-específicos)
  - [2. Modelo de Servicios en la Nube (XaaS)](#2-modelo-de-servicios-en-la-nube-xaas)
    - [Los tres modelos principales](#los-tres-modelos-principales)
    - [Proveedores de Terceros](#proveedores-de-terceros)
  - [3. Matriz de Responsabilidades (Shared Responsibility Model)](#3-matriz-de-responsabilidades-shared-responsibility-model)
    - [Matriz de Responsabilidades por Modelo de Servicio](#matriz-de-responsabilidades-por-modelo-de-servicio)
    - [Responsabilidades del CSP](#responsabilidades-del-csp)
    - [Responsabilidades del Cliente](#responsabilidades-del-cliente)
  - [4. Computación Centralizada y Descentralizada](#4-computación-centralizada-y-descentralizada)
    - [Arquitectura Centralizada](#arquitectura-centralizada)
    - [Arquitectura Descentralizada](#arquitectura-descentralizada)
    - [Ejemplos de Arquitectura Descentralizada](#ejemplos-de-arquitectura-descentralizada)
  - [5. Conceptos de Arquitectura Resiliente](#5-conceptos-de-arquitectura-resiliente)
    - [Alta Disponibilidad (HA — High Availability)](#alta-disponibilidad-ha--high-availability)
    - [Replicación de Datos](#replicación-de-datos)
    - [Niveles de Replicación (Zonas de Disponibilidad)](#niveles-de-replicación-zonas-de-disponibilidad)
  - [6. Virtualización de Aplicaciones y Contenedores](#6-virtualización-de-aplicaciones-y-contenedores)
    - [Virtualización de Aplicaciones](#virtualización-de-aplicaciones)
    - [Contenedorización](#contenedorización)
    - [Hipervisores](#hipervisores)
    - [VM vs. Contenedores](#vm-vs-contenedores)
  - [7. Arquitectura en la Nube](#7-arquitectura-en-la-nube)
    - [Computación Sin Servidor (Serverless)](#computación-sin-servidor-serverless)
    - [Microservicios](#microservicios)
    - [Cambios Transformacionales (Servicios Nativos de Nube)](#cambios-transformacionales-servicios-nativos-de-nube)
  - [8. Tecnologías de Automatización en la Nube](#8-tecnologías-de-automatización-en-la-nube)
    - [Infraestructura como Código (IaC — Infrastructure as Code)](#infraestructura-como-código-iac--infrastructure-as-code)
    - [Tecnologías de Capacidad de Respuesta](#tecnologías-de-capacidad-de-respuesta)
  - [9. Redes Definidas por Software (SDN — Software-Defined Networking)](#9-redes-definidas-por-software-sdn--software-defined-networking)
    - [Los Tres Planos de Red](#los-tres-planos-de-red)
    - [Arquitectura SDN](#arquitectura-sdn)
    - [NFV (Network Functions Virtualization / Virtualización de Funciones de Red)](#nfv-network-functions-virtualization--virtualización-de-funciones-de-red)
  - [10. Características de la Arquitectura en la Nube](#10-características-de-la-arquitectura-en-la-nube)
    - [Características Clave](#características-clave)
    - [SLA e ISA](#sla-e-isa)
  - [11. Aspectos de Seguridad en la Nube a Considerar](#11-aspectos-de-seguridad-en-la-nube-a-considerar)
    - [Protección de Datos](#protección-de-datos)
    - [Gestión de Parches](#gestión-de-parches)
    - [SD-WAN (Software-Defined WAN / Red de Área Amplia Definida por Software)](#sd-wan-software-defined-wan--red-de-área-amplia-definida-por-software)
    - [SASE (Secure Access Service Edge / Perímetro de Servicio de Acceso Seguro)](#sase-secure-access-service-edge--perímetro-de-servicio-de-acceso-seguro)
- [2 Sistemas Integrados y Arquitectura de Confianza Cero](#2-sistemas-integrados-y-arquitectura-de-confianza-cero)
  - [1. Sistemas Integrados (Embedded Systems)](#1-sistemas-integrados-embedded-systems)
    - [Aplicaciones de Sistemas Integrados](#aplicaciones-de-sistemas-integrados)
    - [RTOS (Real-Time Operating System / Sistema Operativo en Tiempo Real)](#rtos-real-time-operating-system--sistema-operativo-en-tiempo-real)
    - [Riesgos Asociados a los RTOS](#riesgos-asociados-a-los-rtos)
  - [2. Sistemas de Control Industrial (ICS — Industrial Control Systems)](#2-sistemas-de-control-industrial-ics--industrial-control-systems)
    - [Componentes de un ICS](#componentes-de-un-ics)
    - [SCADA (Supervisory Control and Data Acquisition / Control de Supervisión y Adquisición de Datos)](#scada-supervisory-control-and-data-acquisition--control-de-supervisión-y-adquisición-de-datos)
    - [Sectores de Aplicación ICS/SCADA](#sectores-de-aplicación-icsscada)
    - [Seguridad en ICS/SCADA](#seguridad-en-icsscada)
  - [3. Internet de las Cosas (IoT — Internet of Things)](#3-internet-de-las-cosas-iot--internet-of-things)
    - [Componentes del Ecosistema IoT](#componentes-del-ecosistema-iot)
    - [Ejemplos de IoT por Sector](#ejemplos-de-iot-por-sector)
    - [Factores que Impulsan la Adopción de IoT](#factores-que-impulsan-la-adopción-de-iot)
    - [Riesgos de Seguridad de IoT](#riesgos-de-seguridad-de-iot)
    - [Casos Históricos de Ataques IoT](#casos-históricos-de-ataques-iot)
    - [Guías de Mejores Prácticas para IoT](#guías-de-mejores-prácticas-para-iot)
  - [4. Desperimetrización y Confianza Cero](#4-desperimetrización-y-confianza-cero)
    - [El Problema del Perímetro Tradicional](#el-problema-del-perímetro-tradicional)
    - [Desperimetrización](#desperimetrización)
    - [Tendencias que Impulsan la Desperimetrización](#tendencias-que-impulsan-la-desperimetrización)
    - [Confianza Cero (Zero Trust Architecture — ZTA)](#confianza-cero-zero-trust-architecture--zta)
  - [5. Conceptos de Seguridad de Confianza Cero](#5-conceptos-de-seguridad-de-confianza-cero)
    - [Conceptos Fundamentales de Zero Trust](#conceptos-fundamentales-de-zero-trust)
    - [Los Planos de Control y Datos en Zero Trust](#los-planos-de-control-y-datos-en-zero-trust)
      - [Plano de Control](#plano-de-control)
      - [Plano de Datos](#plano-de-datos)
    - [Flujo de una Solicitud en Zero Trust (NIST Framework)](#flujo-de-una-solicitud-en-zero-trust-nist-framework)
    - [Zona de Confianza Implícita](#zona-de-confianza-implícita)
    - [Ventajas de la Separación del Plano de Control y Datos](#ventajas-de-la-separación-del-plano-de-control-y-datos)
    - [Ejemplos de Implementaciones de Zero Trust](#ejemplos-de-implementaciones-de-zero-trust)
- [3. Glosario de Acrónimos](#3-glosario-de-acrónimos)

---

# 1. Modelos de Despliegue en la Nube

> **Analogía:** Piensa en los modelos de despliegue como tipos de vivienda: la nube pública es un piso compartido (barato, con vecinos); la privada, una casa propia (cara, total control); la híbrida, tener casa y reservar hotel cuando hay muchas visitas.

### Tipos de Modelos de Despliegue

| Modelo | Descripción | Seguridad | Costo |
|--------|-------------|-----------|-------|
| **Público (multiusuario)** | Servicio ofrecido por un **CSP** (Cloud Service Provider / Proveedor de Servicios en la Nube) via Internet; suscripción o pago por uso | Menor — recurso compartido | Menor |
| **Privado alojado** | Infraestructura hospedada por tercero para uso **exclusivo** de la organización | Alta | Alto |
| **Privado** | Infraestructura completamente privada y propiedad de la organización (ideal: banca, gobierno) | Máxima — control total | Muy alto |
| **Comunitario** | Varias organizaciones comparten costos de una nube privada (preocupaciones comunes: estándares, políticas de seguridad) | Alta entre miembros | Moderado |
| **Híbrido** | Combinación de nube pública + privada (o cualquier combinación de los anteriores) | Variable — gestión compleja | Variable |
| **Multinube** | Uso de servicios de **varios CSP** distintos | Complejidad añadida | Variable |

### Consideraciones de Seguridad por Arquitectura

- **Un solo inquilino (Single-Tenant):** Infraestructura dedicada → máxima seguridad → cliente con control total → más costoso → cliente gestiona la seguridad.
- **Multiinquilino (Multi-Tenant):** Datos de varios clientes separados **lógicamente** → rentable → mayor riesgo de acceso no autorizado si no se protege correctamente.
- **Híbrida:** Flexibilidad y control sobre datos confidenciales → requiere gestión cuidadosa → riesgo de brechas por confusión del límite entre local y nube pública.
- **Sin servidor (Serverless):** El CSP gestiona y protege la infraestructura → el cliente debe asegurar el acceso a sus apps y datos.

### Nube Híbrida — Desafíos de Seguridad Específicos

- Gestión de múltiples entornos en la nube.
- Aplicación de políticas de seguridad **coherentes**.
- Acceso no autorizado, especialmente en datos en nube pública.
- Redundancia de datos → posibles **problemas de sincronización**.
- Cumplimiento legal (GDPR, HIPAA, PCI DSS) en ambos entornos.
- **SLA (Service Level Agreement / Acuerdo de Nivel de Servicio):** establece expectativas de rendimiento, disponibilidad y soporte — puede ser difícil garantizar cuando se integran sistemas locales y en la nube.
- Latencia de red adicional en transferencias de grandes volúmenes de datos.

> **👉 Enfoque de Examen SY0-701:**
> CompTIA pregunta frecuentemente sobre qué modelo usar en escenarios específicos. **Distractor común:** confundir "privado alojado" con "privado puro" — el alojado sigue siendo de terceros. Recuerda: multinube = varios CSP; híbrida = nube pública + privada. La triada CIA puede aparecer: en nube **pública**, los riesgos de **confidencialidad** son mayores. Vigila preguntas sobre SLA e ISA como mecanismos de gobierno en la nube.

## 2. Modelo de Servicios en la Nube (XaaS)

> **Analogía:** Los modelos de servicio son como cocinar: IaaS es comprar los ingredientes y el fogón (tú cocinas todo); PaaS es una cocina equipada donde tú solo haces la receta; SaaS es pedir el plato listo al restaurante.

**XaaS** (Anything as a Service / Cualquier cosa como servicio) — término paraguas para todos los modelos de servicio en la nube.

### Los tres modelos principales

| Modelo | Significado | Qué gestiona el CSP | Qué gestiona el cliente | Ejemplos |
|--------|-------------|---------------------|------------------------|----------|
| **SaaS** | Software as a Service / Software como Servicio | Todo (infra, SO, app) | Solo los datos y accesos | Microsoft 365, Salesforce, Google Workspace |
| **PaaS** | Platform as a Service / Plataforma como Servicio | Infra + plataforma/BD | La aplicación creada sobre la plataforma | Oracle DB, Azure SQL Database, Google App Engine |
| **IaaS** | Infrastructure as a Service / Infraestructura como Servicio | Hardware físico y red | SO, apps, datos, configuración | Amazon EC2, Azure VMs, Oracle Cloud, OpenStack |
| **FaaS** | Function as a Service / Función como Servicio | Toda la infra (serverless) | Solo el código de la función | AWS Lambda, Azure Functions, Google Cloud Functions |

### Proveedores de Terceros

- **SLA:** Disposiciones contractuales que delinean métricas de uptime, rendimiento y tiempos de respuesta → con penalizaciones si no se cumplen.
- Evaluar: cifrado, controles de acceso, gestión de vulnerabilidades, respuesta a incidentes y cumplimiento normativo.
- **PII** (Personally Identifiable Information / Información de Identificación Personal) — especial cuidado si el proveedor la maneja.
- **Vendor lock-in (dependencia del proveedor):** examinar portabilidad, interoperabilidad y estandarización de datos.
- Estrategia de mitigación: implementaciones **multinube o híbridas**.

> **👉 Enfoque de Examen SY0-701:**
> Memoriza la tabla de responsabilidades: en **SaaS**, el CSP gestiona el SO y la red; en **IaaS**, la responsabilidad de red es **compartida**. FaaS = serverless. CompTIA puede preguntarte qué modelo usar si la empresa quiere "solo ejecutar su código sin gestionar servidores" → **FaaS/Serverless**. Los SLA son contractuales, no técnicos — no los confundas con controles de seguridad.

## 3. Matriz de Responsabilidades (Shared Responsibility Model)

> **Analogía:** Como en un edificio de apartamentos: el propietario del edificio (CSP) mantiene la estructura, fontanería y seguridad del portal; el inquilino (cliente) cierra su puerta con llave y protege sus objetos dentro del piso.

**Principio fundamental:** Los riesgos de seguridad **no se transfieren** al CSP, sino que se **comparten**. La seguridad en la nube es una **responsabilidad compartida**.

### Matriz de Responsabilidades por Modelo de Servicio

| Área de Responsabilidad | On-Premises | IaaS | PaaS | SaaS | FaaS |
|------------------------|-------------|------|------|------|------|
| Clasificación de datos | Cliente | Cliente | Cliente | Cliente | Cliente |
| Protección de endpoint | Cliente | Cliente | Cliente | Compartida | Compartida |
| Gestión de identidad y acceso (IAM) | Cliente | Cliente | Compartida | Compartida | Compartida |
| Controles de aplicación | Cliente | Cliente | Compartida | Compartida | Compartida |
| Controles de red | Cliente | Compartida | CSP | CSP | CSP |
| Infraestructura del host | Cliente | Compartida | CSP | CSP | CSP |
| Seguridad física | Cliente | CSP | CSP | CSP | CSP |

### Responsabilidades del CSP

- Seguridad física de la infraestructura.
- Protección de equipos de cómputo, almacenamiento y red.
- Seguridad de red (protección contra ataques DDoS).
- Backup y recuperación de almacenamiento en la nube.
- Aislamiento de recursos entre inquilinos.
- Identidad y control de acceso de recursos del inquilino.
- Seguridad y gestión de centros de datos en múltiples regiones.

### Responsabilidades del Cliente

- Gestión de identidad del usuario.
- Configuración de la ubicación geográfica de los datos.
- Controles de acceso de usuarios y servicios.
- Configuración de seguridad de datos y aplicaciones.
- Protección del SO (cuando aplica, en IaaS).
- Cifrado y gestión de claves.

> **⚠️ Concepto clave:** La identificación del límite entre responsabilidades del cliente y del CSP es un **esfuerzo deliberado** — no es automático ni pasivo. Un error en esta identificación introduce vulnerabilidades.

> **👉 Enfoque de Examen SY0-701:**
> Esta es una de las áreas más preguntadas del dominio de arquitectura. CompTIA presentará escenarios donde debes identificar quién es responsable de qué. **Distractor frecuente:** asumir que el CSP es responsable de todo en SaaS — el cliente **siempre** es responsable de la clasificación de datos y la gestión de identidades de sus usuarios. Memoriza que la seguridad física **siempre** es del CSP (excepto on-premises).

## 4. Computación Centralizada y Descentralizada

### Arquitectura Centralizada

- Todo el procesamiento y almacenamiento en **una única ubicación** (servidor central).
- Los usuarios confían en la integridad del administrador del servidor.
- **Ejemplos:** Mainframes (computadoras centrales), arquitecturas cliente-servidor.
- **Uso:** Grandes organizaciones que requieren control y gestión estrictos.

### Arquitectura Descentralizada

- Procesamiento y almacenamiento distribuidos en **múltiples ubicaciones o dispositivos**.
- Ningún dispositivo o ubicación única tiene toda la responsabilidad.
- **Beneficios:** Mejor tolerancia a fallas, escalabilidad, características de seguridad únicas.

### Ejemplos de Arquitectura Descentralizada

| Tecnología | Descripción |
|-----------|-------------|
| **Blockchain** | Tecnología de contabilidad distribuida — transacciones seguras, transparentes y descentralizadas |
| **Redes P2P** (Peer-to-Peer) | Distribución del procesamiento y almacenamiento entre nodos participantes sin servidor central |
| **CDN** (Content Delivery Network / Red de Distribución de Contenido) | Distribuye contenido en múltiples servidores para mejorar rendimiento, confiabilidad y escalabilidad |
| **IoT** (Internet of Things / Internet de las Cosas) | Dispositivos conectados en red descentralizada para compartir datos y capacidad de procesamiento |
| **Bases de datos distribuidas** | Datos divididos entre varios servidores — alta disponibilidad aunque un servidor falle |
| **Tor** (The Onion Router) | Red de comunicación anónima — enruta tráfico a través de nodos operados por voluntarios para ocultar la identidad y actividad del usuario |

> **👉 Enfoque de Examen SY0-701:**
> Tor puede aparecer en preguntas sobre privacidad y anonimato — no confundir con una herramienta de seguridad corporativa. Blockchain puede aparecer asociado a integridad de datos (no repudio). CDN → disponibilidad. Vigila el **tradeoff**: centralizado = más control, descentralizado = más resiliencia.

## 5. Conceptos de Arquitectura Resiliente

### Alta Disponibilidad (HA — High Availability)

- **HA:** Aprovisionamiento con garantía de al menos **99.99% de uptime** (tiempo activo).
- El CSP utiliza una **capa de virtualización** para asegurar que cómputo, almacenamiento y red cumplan los criterios del SLA.
- Redundancia: múltiples controladores de disco y dispositivos de almacenamiento.
- Los datos se pueden replicar entre diferentes conjuntos, cada uno respaldado por hardware independiente.

### Replicación de Datos

- Permite copiar información hacia donde pueda usarse más eficientemente.
- La nube como área de almacenamiento central facilita disponibilidad entre unidades de negocio.
- Requiere conexiones de red de **baja latencia**, seguridad e integridad de datos.

**Tipos de almacenamiento por velocidad:**

| Tipo | Descripción | Velocidad | Costo |
|------|-------------|-----------|-------|
| **Hot Storage** (almacenamiento en caliente) | Recuperación de datos rápida | Alta | Alto |
| **Cold Storage** (almacenamiento en frío) | Recuperación de datos lenta | Baja | Bajo |

### Niveles de Replicación (Zonas de Disponibilidad)

Los CSP dividen el mundo en **regiones** independientes, que a su vez se dividen en **zonas de disponibilidad** con centros de datos independientes (energía, refrigeración y red propias).

| Nivel de Replicación | Descripción |
|---------------------|-------------|
| **Local** | Réplica dentro de un solo centro de datos en la región, en dominios de fallas y actualización separados |
| **Regional (Zone-Redundant Storage)** | Réplica en varios centros de datos dentro de una o dos regiones — protección ante fallo de un centro |
| **GRS (Geo-Redundant Storage / Almacenamiento georredundante)** | Réplica en una **región secundaria** alejada de la primaria — protección ante desastre o interrupción regional |

> **Consideración:** Una base de datos generalmente requiere replicación **síncrona** de baja latencia — la transacción no se considera completa hasta que se ha replicado. Un archivo de respaldo puede tolerar replicación asíncrona.

> **👉 Enfoque de Examen SY0-701:**
> Las preguntas sobre resiliencia suelen pedir qué nivel de replicación aplicar ante un escenario de desastre regional → **GRS**. Hot vs. Cold Storage aparece frecuentemente en preguntas de costo vs. velocidad de recuperación. Recuerda: HA ≠ DR (Disaster Recovery) — HA es disponibilidad continua, DR es recuperación ante catástrofe.

## 6. Virtualización de Aplicaciones y Contenedores

### Virtualización de Aplicaciones

- Tipo más limitado de **VDI** (Virtual Desktop Infrastructure / Infraestructura de Escritorio Virtual).
- El cliente accede a una aplicación alojada en un servidor o la transmite (streaming) al cliente para procesamiento local.
- Soluciones principales: **Citrix XenApp**, **Microsoft App-V**, **VMware ThinApp**.
- Implementación habitual mediante aplicaciones de **escritorio remoto HTML5 "sin cliente"** — acceso desde un navegador web convencional.

### Contenedorización

> **Analogía:** Un contenedor de software es como un contenedor físico marítimo: empaqueta todo lo que la aplicación necesita (código, bibliotecas, configuraciones) en una unidad portátil, independientemente del barco (hardware) que lo transporte.

- **Contenedor:** Encapsula código, bibliotecas y configuraciones en una unidad portátil autocontenida.
- Garantiza comportamiento **consistente** de la aplicación independientemente de la plataforma subyacente.
- **Docker** es la plataforma de contenedores más popular (equivalente al "buque de carga").
- Evita el **"infierno de dependencias"** (dependency hell) — problemas de versiones incompatibles en instalaciones tradicionales.
- Las aplicaciones contenedorizadas son **unidades autocontenidas**, cada una con su propia copia de dependencias.

### Hipervisores

| Tipo | Descripción | Características | Ejemplos |
|------|-------------|-----------------|----------|
| **Tipo 1 (Bare-Metal)** | Se ejecuta **directamente** sobre el hardware físico | Alto rendimiento y eficiencia, ideal para empresas | VMware ESXi, Microsoft Hyper-V |
| **Tipo 2 (Hosted)** | Se ejecuta sobre un **sistema operativo anfitrión** | Menor rendimiento, ideal para desarrollo y pruebas | VMware Workstation, Oracle VirtualBox |

### VM vs. Contenedores

| Característica | Máquina Virtual (VM) | Contenedor |
|---------------|---------------------|------------|
| **Aislamiento** | SO invitado completo (Guest OS) | Comparte el kernel del SO anfitrión |
| **Tamaño** | GBs (incluye SO completo) | MBs (solo app + dependencias) |
| **Arranque** | Minutos | Segundos |
| **Hipervisor** | Requiere hipervisor (Tipo 1 o 2) | Requiere motor de contenedores (Docker) |
| **Portabilidad** | Menor | Mayor |
| **Seguridad** | Mejor aislamiento | Riesgo si el kernel del host se compromete |

> **👉 Enfoque de Examen SY0-701:**
> La diferencia Tipo 1 vs. Tipo 2 es pregunta frecuente. **Bare-metal = Tipo 1 = producción empresarial**. Contenedores vs. VM: CompTIA preguntará qué usar cuando se prioriza velocidad de despliegue y portabilidad → contenedores. Mayor aislamiento de seguridad → VM. Recuerda: Docker = motor de contenedores, no hipervisor.

## 7. Arquitectura en la Nube

### Computación Sin Servidor (Serverless)

- El **CSP** gestiona la infraestructura y asigna recursos automáticamente.
- Se cobra **únicamente por el uso real** (tiempo de ejecución), no por hora.
- Las organizaciones se centran en el **desarrollo** de aplicaciones, no en la gestión de servidores.
- Las aplicaciones se desarrollan como **funciones y microservicios**.
- No se aprovisionan múltiples servidores para redundancia o balanceo de carga — el CSP lo gestiona.
- **VPC** (Virtual Private Cloud / Nube Privada Virtual) — a diferencia de las ofertas "convencionales", en serverless los servicios no se ejecutan en instancias de VM.

**Ejemplos de casos de uso:**
- Chatbots para atención al cliente.
- Back-ends móviles.
- Procesamiento basado en eventos (lecturas de sensores, alertas).

**Principales proveedores:**
- **AWS Lambda** (`aws.amazon.com/lambda`)
- **Google Cloud Functions** (`cloud.google.com/functions`)
- **Microsoft Azure Functions** (`azure.microsoft.com/services/functions`)

**Ventajas de seguridad en serverless:**
- Poco o ningún esfuerzo de gestión de parches de SO.
- No hay privilegios de administración que gestionar.
- El proveedor gestiona la seguridad del sistema de archivos.

> **Analogía:** La computación sin servidor es como usar el servicio de electricidad de tu ciudad — no gestionas la central eléctrica, solo enchufas y pagas por lo que consumes.

### Microservicios

- Enfoque arquitectónico: aplicación como colección de **servicios pequeños e independientes**.
- Cada microservicio se centra en una capacidad comercial específica.
- **Modular:** interfaz bien definida, responsabilidad única.
- Los equipos trabajan independientemente en distintas funciones.
- **Riesgo:** problemas de integración — componentes individuales funcionan bien, pero al integrarlos surgen problemas difíciles de aislar.
- Frecuentemente implementado mediante prácticas de **IaC** (Infraestructura como Código).

### Cambios Transformacionales (Servicios Nativos de Nube)

| Servicio | Beneficio |
|----------|-----------|
| Cómputo elástico y autoescalado | Cambios dinámicos en potencia de cómputo según demanda |
| Computación sin servidor | Elimina la necesidad de servidores tradicionales |
| **CDN** (Content Delivery Network) | Optimiza tráfico web almacenando contenido en caché |
| Almacenamiento de objetos | Datos masivos y no estructurados — reemplaza servidores de archivos |
| IAM (Identity and Access Management) | Funciones de seguridad avanzadas e integración de plataformas |
| Contenedorización y orquestación | Cambia cómo se implementan y gestionan las aplicaciones |
| IA/ML, IoT back-end, Big Data | Amplían el rango de posibilidades |

> **⚠️ Alerta de seguridad:** La tasa de cambio y los riesgos desconocidos en plataformas en la nube generan nuevos problemas de seguridad significativos y vulneraciones de datos sin precedentes.

> **👉 Enfoque de Examen SY0-701:**
> Serverless/FaaS: el cliente NO gestiona el SO ni los parches. Microservicios: el riesgo es en la **integración**, no en los componentes individuales. Preguntas de escenario: "Una empresa quiere escalar automáticamente según demanda sin administrar servidores" → FaaS/Serverless. "Una empresa quiere dividir su aplicación monolítica en componentes independientes" → Microservicios.

## 8. Tecnologías de Automatización en la Nube

### Infraestructura como Código (IaC — Infrastructure as Code)

> **Analogía:** IaC es como tener los planos arquitectónicos de tu casa en formato digital — puedes construir exactamente la misma casa en cualquier lugar del mundo, sin errores de construcción manual, y el resultado siempre será idéntico.

- **IaC:** Práctica de ingeniería de software que gestiona la infraestructura usando **archivos de definición legibles por máquina**.
- Reduce el riesgo de errores por intervención manual.
- Los archivos están **controlados por versiones** (tratados como código fuente).
- Permite replicar infraestructura en diferentes entornos (desarrollo, staging, producción) de forma consistente y reproducible.

**Formatos de archivos IaC:**

| Formato | Descripción |
|---------|-------------|
| **YAML** | Yet Another Markup Language — legible por humanos, ampliamente usado |
| **JSON** | JavaScript Object Notation — estructurado, intercambio de datos |
| **HCL** | HashiCorp Configuration Language — desarrollado por HashiCorp, usado en Terraform y Consul; similar a JSON y YAML pero con características adicionales para gestión de infraestructura (soporta variables, sintaxis concisa) |

**Los archivos de definición contienen:**
- Estado de la infraestructura deseada.
- Ajustes de configuración.
- Requisitos de red.
- Políticas de seguridad.
- Otros parámetros.

### Tecnologías de Capacidad de Respuesta

| Tecnología | Descripción |
|-----------|-------------|
| **Balanceo de carga (Load Balancing)** | Distribuye tráfico de red a través de múltiples servidores para mejorar rendimiento y alta disponibilidad. Los load balancers actúan como **intermediarios (proxies)** entre usuarios y recursos back-end (VMs, contenedores). Usan algoritmos sofisticados para distribuir solicitudes y gestionar capacidad, tiempo de respuesta y carga de trabajo. |
| **Computación periférica (Edge Computing)** | Optimiza la ubicación geográfica de recursos para procesamiento más rápido y **menor latencia**. En lugar de enrutar todo a un centro de datos centralizado, usa recursos distribuidos para minimizar la distancia que los datos viajan. Ideal para: IoT, CDN, aplicaciones sensibles a la latencia. |
| **Escalado automático (Auto-Scaling)** | Proceso automatizado que ajusta recursos informáticos según la demanda en tiempo real. Durante alta demanda → aprovisiona recursos adicionales automáticamente. Durante baja demanda → libera recursos al grupo compartido → reduce costos operativos. |

> **👉 Enfoque de Examen SY0-701:**
> IaC = automatización + consistencia + reducción de errores manuales. HCL es el formato de Terraform (HashiCorp). Balanceo de carga → disponibilidad; Edge Computing → latencia; Auto-Scaling → elasticidad. Pregunta tipo: "¿Qué tecnología permitiría a una empresa ajustar automáticamente sus recursos de cómputo durante picos de demanda?" → Auto-Scaling. No confundas balanceador de carga con firewall.

## 9. Redes Definidas por Software (SDN — Software-Defined Networking)

> **Analogía:** SDN es como separar el piloto automático del avión del propio avión. El plano de control (piloto automático) toma decisiones de vuelo, el plano de datos (motores y alerones) ejecuta esas decisiones, y el plano de gestión (torre de control) monitorea todo.

La IaC se ve facilitada por dispositivos de red físicos y virtuales que se pueden configurar mediante **scripts y API**.

### Los Tres Planos de Red

| Plano | Función |
|-------|---------|
| **Plano de Gestión (Management Plane)** | Monitorea las condiciones del tráfico y el estado de la red |
| **Plano de Control (Control Plane)** | Toma decisiones sobre cómo priorizar, asegurar y enrutar el tráfico |
| **Plano de Datos (Data Plane)** | Maneja la conmutación y enrutamiento del tráfico; impone controles de acceso |

### Arquitectura SDN

```
[Aplicaciones SDN]
      |
   API "Northbound" (dirección norte)
      |
[Controlador SDN]
      |
   API "Southbound" (dirección sur)
      |
[Dispositivos de Red: físicos y virtuales]
```

- **API Northbound:** Interfaz entre aplicaciones SDN y el controlador SDN.
- **API Southbound:** Interfaz entre el controlador SDN y los dispositivos de red.
- SDN gestiona dispositivos físicos compatibles, **conmutadores virtuales, enrutadores y cortafuegos**.

### NFV (Network Functions Virtualization / Virtualización de Funciones de Red)

- Arquitectura que permite implementar redes virtuales mediante **VMs de propósito general y contenedores**.
- Ahorra trabajo y complejidad de configuración manual de dispositivos.
- Posibilita implementación **totalmente automatizada** (aprovisionamiento) de enlaces de red, dispositivos y servidores.
- Parte importante de tecnologías de **automatización y orquestación**.

> **👉 Enfoque de Examen SY0-701:**
> Memoriza los tres planos y sus funciones. SDN separa el **control** de los **datos** — esto es fundamental. **Distractor:** confundir SDN con NFV; SDN = políticas de red vía software; NFV = virtualización de las propias funciones de red. API Northbound = hacia las apps; API Southbound = hacia los dispositivos. Pregunta típica: "¿Qué tecnología permite a un administrador configurar políticas de red mediante una API centralizada?" → SDN.

## 10. Características de la Arquitectura en la Nube

### Características Clave

| Característica | Descripción |
|---------------|-------------|
| **Costo** | Cambio de **CapEx** (Capital Expenditure — gastos de capital iniciales: hardware, licencias, configuración) a **OpEx** (Operational Expenditure — gastos operativos: pago por uso). Alinea gastos con uso real. Recursos no optimizados pueden generar costos elevados. |
| **Escalabilidad** | Capacidad de expandir y contraer dinámicamente. **Escalado vertical (Scale-Up):** añadir capacidad a un recurso existente (más CPU, RAM). **Escalado horizontal (Scale-Out):** añadir más instancias en paralelo. |
| **Resiliencia** | Hardware redundante, tolerancia a fallas (clústeres), replicación en múltiples servidores y centros de datos. |
| **Facilidad de implementación** | Automatización (reduce intervención manual), estandarización (plantillas e imágenes consistentes), portabilidad (evita vendor lock-in). |
| **Facilidad de recuperación** | Backup/restauración automatizados, arquitecturas redundantes, servicios DR (Disaster Recovery) en diferentes regiones geográficas. |
| **Energía** | Infraestructura de energía redundante (SAI, generadores), monitoreo en tiempo real. **PUE** (Power Usage Effectiveness / Efectividad en el Uso de Energía) — métrica de eficiencia energética del datacenter. PUE más bajo = mayor proporción de energía para cómputo. |
| **Cómputo** | Elasticidad, agrupación de recursos, orquestación, automatización, computación sin servidor. |
| **Redes** | Redes virtuales para comunicación segura, load balancers, CDN, conectividad privada y pública. |

### SLA e ISA

- **SLA (Service Level Agreement / Acuerdo de Nivel de Servicio):** Define niveles de servicio esperados — rendimiento, disponibilidad, soporte → con créditos o reembolsos si no se cumplen.
- **ISA (Interconnection Security Agreement / Acuerdo de Seguridad de Interconexión):** Establece requisitos y responsabilidades de seguridad entre la organización y el CSP:
  - Métodos de cifrado.
  - Controles de acceso.
  - Gestión de vulnerabilidades.
  - Segregación de datos.
  - Propiedad de los datos.
  - Derechos de auditoría.
  - Procedimientos de backup, recuperación y retención.
  - Cumplimiento: **GDPR, HIPAA, PCI DSS**.
  - Uso de subcontratistas.

> **👉 Enfoque de Examen SY0-701:**
> **CapEx vs. OpEx** es pregunta habitual — nube = OpEx. Scale-Up vs. Scale-Out: Up = más potencia al mismo servidor; Out = más servidores. **PUE** puede aparecer en preguntas sobre eficiencia de datacenter. ISA vs. SLA: ISA = seguridad; SLA = niveles de servicio. Memoriza que GDPR, HIPAA y PCI DSS son los estándares de cumplimiento normativo que suelen mencionarse en el ISA.

## 11. Aspectos de Seguridad en la Nube a Considerar

### Protección de Datos

- Los datos se almacenan fuera de la infraestructura privada — esencialmente "en Internet".
- **Errores de configuración** pueden tener consecuencias catastróficas.
- Medidas esenciales: controles de acceso + cifrado.
- Los planes de DR (Disaster Recovery) deben actualizarse continuamente.

### Gestión de Parches

- Política clara del CSP sobre frecuencia y velocidad de publicación de parches.
- Funciones que garantizan disponibilidad de parches: gestión automatizada, actualizaciones periódicas, gestión centralizada, supervisión de seguridad, soporte de software de terceros.
- **Desafíos del parcheo en la nube:**
  - Complejidad de sistemas en la nube → difícil identificar vulnerabilidades.
  - Algunos CSP no permiten a los clientes modificar la infraestructura subyacente.
  - El CSP gestiona la infra → pérdida de control directo sobre el calendario de parches.
  - Dificultad para cumplir plazos legales y regulatorios de parcheo.

### SD-WAN (Software-Defined WAN / Red de Área Amplia Definida por Software)

- Conecta sucursales, centros de datos e infraestructura en la nube a través de una **WAN** (Wide Area Network / Red de Área Amplia).
- **Funciones de seguridad clave:**
  - Cifrado de datos en tránsito.
  - Segmentación del tráfico según clasificaciones de prioridad.
  - Enrutamiento inteligente según la aplicación.
  - Integración con cortafuegos.
  - Gestión centralizada de políticas de seguridad.

### SASE (Secure Access Service Edge / Perímetro de Servicio de Acceso Seguro)

- Combina la protección de una **plataforma de acceso seguro** con la agilidad de una **arquitectura de seguridad entregada en la nube**.
- Enfoque centralizado de seguridad y acceso.
- Protección para todos los usuarios, independientemente de su ubicación.
- Opera bajo un modelo de seguridad de **confianza cero**.
- Incorpora **IAM** (Identity and Access Management / Gestión de Identidades y Accesos).
- Asume que todos los usuarios y dispositivos son **no confiables** hasta que se autentiquen y autoricen.
- Funciones de prevención de amenazas: prevención de intrusiones, protección anti-malware, filtrado de contenido.

> **👉 Enfoque de Examen SY0-701:**
> SASE = SD-WAN + seguridad en la nube + Zero Trust. Es una arquitectura moderna importante para el examen. **Distractor:** confundir SASE con SD-WAN — SD-WAN es solo la parte de red; SASE agrega la capa de seguridad integral. Parches en la nube: el cliente puede perder control sobre el calendario → riesgo regulatorio. Preguntas de escenario: "Empresa con empleados remotos en múltiples países necesita acceso seguro centralizado" → SASE.

# 2 Sistemas Integrados y Arquitectura de Confianza Cero

## 1. Sistemas Integrados (Embedded Systems)

> **Analogía:** Un sistema integrado es como el cerebro especializado de un electrodoméstico — no hace de todo, pero hace su tarea específica de manera perfecta, constante y en tiempo real.

Los sistemas integrados se usan en aplicaciones especializadas donde se requiere control preciso en tiempo real.

### Aplicaciones de Sistemas Integrados

| Sector | Ejemplos |
|--------|---------|
| **Electrónica de consumo** | Refrigeradores, lavadoras, cafeteras, termostatos inteligentes |
| **Teléfonos inteligentes y tabletas** | Procesadores, sensores, módulos de comunicación integrados |
| **Automotriz** | Unidades de control del motor, sistemas de entretenimiento, bolsas de aire, frenos ABS |
| **Automatización industrial** | Robots, líneas de montaje, sensores en maquinaria de control |
| **Dispositivos médicos** | Marcapasos, bombas de insulina, monitores de glucosa |
| **Aeroespacial y defensa** | Aeronaves, satélites, equipo militar (navegación, comunicación, control) |

### RTOS (Real-Time Operating System / Sistema Operativo en Tiempo Real)

- Sistema operativo diseñado para aplicaciones que requieren **procesamiento y respuesta en tiempo real**.
- Alta estabilidad y velocidad de procesamiento.

| RTOS | Uso Principal |
|------|--------------|
| **VxWorks** | Sistemas aeroespaciales y de defensa — control de aeronaves, sistemas de guía de misiles |
| **FreeRTOS** | Open source — robótica, automatización industrial, electrónica de consumo |
| **AUTOSAR** (Automotive Open System Architecture) | Industria automotriz — control de motor, transmisión, sistemas de seguridad activa |
| **Siemens SIMATIC WinCC Open Architecture** | Control industrial — automatización de fábricas |

### Riesgos Asociados a los RTOS

- Software complejo y difícil de proteger → vulnerabilidades difíciles de identificar.
- **Ataques a nivel de sistema:** un atacante con acceso puede interrumpir procesos críticos u obtener control del sistema.
- Consecuencias graves: daños a personas o equipos (dispositivos médicos, control industrial).

> **👉 Enfoque de Examen SY0-701:**
> RTOS: la característica clave es "tiempo real" — no confundir con SO convencional. El riesgo en RTOS es que un compromiso puede tener consecuencias físicas (no solo de datos). Recuerda VxWorks = defensa/aeroespacial; FreeRTOS = open source / IoT.

## 2. Sistemas de Control Industrial (ICS — Industrial Control Systems)

> **Analogía:** Un ICS es el sistema nervioso de una fábrica o planta — los PLC son los nervios periféricos que controlan músculos (actuadores), los sensores son los receptores sensoriales, la HMI es el cerebro consciente que muestra el estado y permite el control, y el servidor SCADA es la conciencia global que supervisa todo.

### Componentes de un ICS

| Componente | Descripción |
|-----------|-------------|
| **ICS** (Industrial Control System) | Mecanismos de automatización de flujo de trabajo y procesos. Controla maquinaria de infraestructuras críticas (energía, agua, sanidad, telecomunicaciones, seguridad nacional). |
| **DCS** (Distributed Control System / Sistema de Control Distribuido) | ICS que administra automatización de procesos dentro de un **único sitio**. |
| **PLC** (Programmable Logic Controller / Controlador Lógico Programable) | Dispositivos integrados en equipos de planta. Vinculados por red serial de campo OT (Operational Technology / Tecnología Operativa) o Ethernet industrial a actuadores y sensores. |
| **HMI** (Human-Machine Interface / Interfaz Hombre-Máquina) | Panel de control local o software en host de computación. Permite configuración y lectura de salida de PLC. |
| **Data Historian** | Base de datos que almacena toda la información generada por el bucle de control. |
| **Actuadores** | Operan válvulas, motores, interruptores y otros componentes mecánicos. |
| **Sensores** | Monitorean estados locales (temperatura, presión, etc.). |

### SCADA (Supervisory Control and Data Acquisition / Control de Supervisión y Adquisición de Datos)

- Reemplaza al servidor de control en **ICS de gran escala y múltiples sitios**.
- Se ejecuta como software en computadoras convencionales.
- Recopila datos y gestiona dispositivos de campo con PLC integrados.
- Usa comunicaciones **WAN** (telefonía móvil o satélite) para enlazar el servidor SCADA con dispositivos de campo.

### Sectores de Aplicación ICS/SCADA

| Sector | Descripción |
|--------|-------------|
| **Energía** | Generación y distribución de energía eléctrica, redes de agua/alcantarillado, transporte |
| **Industrial** | Extracción y refinación de materias primas (hornos, prensas, centrífugas, bombas) |
| **Fabricación/Manufactura** | Sistemas de producción automatizados (forjas, molinos, líneas de montaje) — precisión extrema |
| **Logística** | Sistemas de transporte y elevación automatizados, sensores de seguimiento de componentes |
| **Instalaciones** | Sistemas de gestión de edificios: HVAC (Heating, Ventilation and Air Conditioning / Calefacción, Ventilación y Aire Acondicionado), iluminación, seguridad |

### Seguridad en ICS/SCADA

- Construidos históricamente **sin tener en cuenta la seguridad informática**.
- **Prioridades invertidas respecto a TI tradicional:** Los sistemas industriales priorizan **AIC** (Availability, Integrity, Confidentiality / Disponibilidad, Integridad, Confidencialidad) — la **disponibilidad** es la prioridad máxima, no la confidencialidad. Esto invierte la triada CIA clásica.
- Los procesos industriales involucran componentes electromecánicos peligrosos → **la seguridad (safety) es prioridad absoluta**.

**Riesgos de ciberseguridad:**
- Malware y ransomware.
- Acceso no autorizado.
- Ataques dirigidos (APT).

**Ejemplo histórico — Stuxnet:**
- Gusano diseñado para atacar software SCADA en Windows.
- Objetivo: dañar centrífugas del programa de combustibles nucleares de Irán.
- Primer ciberataque conocido con consecuencias físicas documentadas.

**Controles de protección recomendados (NIST SP 800-82):**
- Segmentación de redes.
- Controles de acceso.
- Sistemas IDS (Intrusion Detection Systems / Sistemas de Detección de Intrusiones).
- Cifrado.
- Monitoreo continuo.

> **👉 Enfoque de Examen SY0-701:**
> **Triada AIC vs. CIA** es crítica: en ICS/SCADA, la disponibilidad viene PRIMERO. Stuxnet es el ejemplo clásico de ataque ICS. Memoriza: PLC → controla actuadores; HMI → interfaz humana; SCADA → supervisión multi-sitio; DCS → un solo sitio. NIST SP 800-82 = referencia para seguridad ICS. OT (Operational Technology) es el término genérico para la tecnología de control industrial, distinto de IT (Information Technology).

## 3. Internet de las Cosas (IoT — Internet of Things)

> **Analogía:** IoT es como convertir todos los objetos de tu mundo físico en "informantes" que reportan su estado constantemente a una central de datos en la nube — desde el termostato hasta el motor de una turbina.

**Definición:** Red de dispositivos físicos, vehículos, electrodomésticos y objetos con sensores, software y conectividad integrados para recopilar e intercambiar datos.

### Componentes del Ecosistema IoT

| Componente | Función |
|-----------|---------|
| **Sensores** | Detectan cambios en el entorno (temperatura, humedad, movimiento) |
| **Actuadores** | Realizan acciones basadas en datos de sensores (encender luz, ajustar termostato) |
| **Conectividad** | Comunicación entre dispositivos y sistemas (vía Internet) |
| **Sistemas basados en la nube** | Potencia computacional para análisis de grandes volúmenes de datos generados por IoT |

### Ejemplos de IoT por Sector

| Sector | Aplicación |
|--------|-----------|
| **Hogar inteligente** | Control de iluminación, temperatura, sistemas de seguridad de forma remota |
| **Ciudades inteligentes** | Gestión de tráfico, control de calidad del aire, mejora de seguridad pública |
| **Salud** | Dispositivos portátiles e implantables que envían datos de pacientes a proveedores médicos |
| **Agricultura** | Sensores de condiciones del suelo, patrones climáticos, crecimiento de cultivos |

### Factores que Impulsan la Adopción de IoT

- **Reducción de costos** de sensores y dispositivos.
- **Avances en conectividad:** 5G y redes inalámbricas de baja potencia (LPWAN).
- **Big Data y Analytics:** IA y Machine Learning para procesar grandes volúmenes de datos IoT.
- **Pandemia COVID-19:** Aceleró adopción en salud (monitoreo remoto, telemedicina).

### Riesgos de Seguridad de IoT

- **Gran número de dispositivos sin medidas de seguridad adecuadas**.
- **Recursos limitados:** potencia de procesamiento y memoria reducidas → dificulta implementar controles robustos.
- **Falta de estandarización:** problemas de compatibilidad, distintos requisitos y protocolos de seguridad.
- **Volumen masivo de datos:** dificulta proteger información sensible.
- **Vulnerabilidades de diseño:** dispositivos diseñados priorizando funcionalidad sobre seguridad.
- **Presión de costos:** los fabricantes difícilmente pueden priorizar seguridad con márgenes bajos.
- **Lanzamientos sin pruebas de seguridad** adecuadas.
- **Falta de conciencia del usuario:** no cambian contraseñas predeterminadas, no actualizan firmware.

### Casos Históricos de Ataques IoT

| Incidente | Descripción |
|-----------|-------------|
| **Botnet Mirai** | Infectó millones de dispositivos IoT para lanzar ataques DDoS masivos contra sitios web y servicios en línea |
| **Casino y termómetro de pecera** | Un casino fue hackeado a través de un termómetro IoT en una pecera usado como backdoor para acceder a la red del casino |
| **Monitores de bebés y cámaras** | Dispositivos IoT hackeados para espiar a personas |

### Guías de Mejores Prácticas para IoT

- **IoTSF** (Internet of Things Security Foundation) — `iotsecurityfoundation.org`
- **IIC** (Industrial Internet Consortium) Security Framework — `iiconsortium.org/iisf/`
- **CSA** (Cloud Security Alliance) IoT Security Controls Framework
- **ETSI** (European Telecommunications Standards Institute) IoT Security Standards

> **👉 Enfoque de Examen SY0-701:**
> Botnet Mirai es el ejemplo de ataque IoT más citado en exámenes. Los riesgos de IoT se centran en: recursos limitados, falta de estandarización y contraseñas predeterminadas sin cambiar. Recuerda: IoT agrega una superficie de ataque masiva. Pregunta tipo: "¿Cuál es el mayor riesgo de seguridad al implementar dispositivos IoT en una red corporativa?" → dispositivos con firmware sin actualizar y contraseñas predeterminadas.

## 4. Desperimetrización y Confianza Cero

### El Problema del Perímetro Tradicional

El perímetro tradicional se ha disuelto porque:
- Trabajo remoto con equipos en redes domésticas o Wi-Fi públicas no seguras.
- Infraestructura mixta: on-premises + nube pública.
- Servicios y contratistas externos con acceso remoto.
- **BYOD** (Bring Your Own Device / Trae Tu Propio Dispositivo) — dispositivos personales accediendo a sistemas corporativos.
- Acceso a sistemas críticos mediante interfaces externas.
- Software desarrollado por entidades subcontratadas.

> **Analogía:** El modelo de seguridad tradicional era como un castillo con un foso — todo lo que estaba dentro del foso era de confianza, todo lo que estaba fuera no. Zero Trust es como reemplazar el castillo por un sistema de control de acceso individual en cada habitación, sin importar si estás dentro o fuera del castillo.

### Desperimetrización

- Estrategia que desplaza el enfoque de defender los **límites de la red** a proteger los **datos y recursos individuales** dentro de ella.
- Los modelos tradicionales de seguridad basados en el perímetro son menos efectivos ante:
  - Computación en la nube.
  - Trabajo remoto.
  - Dispositivos móviles.
- Implementa **múltiples medidas de seguridad** en torno a activos individuales.

### Tendencias que Impulsan la Desperimetrización

| Tendencia | Impacto |
|-----------|---------|
| **Enfoque en la nube** | Infraestructura distribuida entre on-premises y nube — sin perímetro claro |
| **Trabajo remoto** | Expande la huella geográfica drásticamente; empleados conectan desde ubicaciones no seguras |
| **Dispositivos móviles** | Cada vez más datos corporativos accedidos desde smartphones/tablets con ciclos de soporte cortos |
| **Externalización y contratación** | Acceso remoto a terceros puede ser punto de entrada a la red corporativa |
| **Redes Wi-Fi** | Redes inalámbricas frecuentemente abiertas, sin protección o con clave ampliamente conocida |

### Confianza Cero (Zero Trust Architecture — ZTA)

**Definición (NIST SP 800-207):** "Paradigmas de ciberseguridad que mueven las estrategias de defensas de los perímetros estáticos basados en redes para centrarse en los usuarios, los activos y los recursos."

**Principio fundamental:** "Nunca confiar, siempre verificar" — todo acceso debe ser verificado y autorizado continuamente.

**Beneficios clave de ZTA:**

| Beneficio | Descripción |
|-----------|-------------|
| **Mayor seguridad** | Todos los usuarios, dispositivos y apps deben autenticarse y verificarse antes del acceso |
| **Mejores controles de acceso** | Límites más estrictos sobre quién/qué puede acceder a recursos y desde qué ubicaciones |
| **Mejora de gobernanza y cumplimiento** | Mayor visibilidad operativa sobre la actividad del usuario y del dispositivo |
| **Mayor granularidad** | Acceso a lo que se necesita, cuando se necesita (principio de mínimo privilegio) |

**Componentes esenciales de ZTA:**

- Seguridad de redes y terminales.
- **IAM** (Identity and Access Management / Gestión de Identidad y Acceso).
- Aplicación basada en políticas.
- Seguridad en la nube.
- Visibilidad de redes (análisis de tráfico).
- Segmentación de redes.
- Protección de datos (cifrado y auditoría).
- Detección y prevención de amenazas.

**Referencias:**
- NIST SP 800-207 — `csrc.nist.gov/publications/detail/sp/800-207/final`
- Modelo de Madurez de Confianza Cero de CISA — `cisa.gov/zero-trust-maturity-model`

> **👉 Enfoque de Examen SY0-701:**
> Zero Trust es uno de los temas más importantes del examen SY0-701. Memoriza la frase "nunca confiar, siempre verificar". **Distractor común:** pensar que Zero Trust elimina la autenticación una vez que el usuario está "dentro" — en ZTA, la verificación es **continua**. BYOD y trabajo remoto son los drivers típicos que llevan a implementar ZTA. NIST SP 800-207 es la referencia normativa de Zero Trust.

## 5. Conceptos de Seguridad de Confianza Cero

### Conceptos Fundamentales de Zero Trust

| Concepto | Descripción |
|---------|-------------|
| **Identidad adaptativa** | Las identidades de los usuarios no son estáticas; la verificación es continua y basada en el contexto actual y los recursos a los que se intenta acceder |
| **Reducción del alcance de amenazas** | El acceso se otorga según la **necesidad de conocer** (need-to-know) y solo a recursos necesarios para la tarea específica → reduce la superficie de ataque |
| **Control de acceso impulsado por políticas** | Las políticas de control de acceso aplican restricciones basadas en: identidad del usuario, postura del dispositivo y contexto de la red |
| **Postura del dispositivo (Device Posture)** | Estado de seguridad del dispositivo — configuraciones de seguridad, versiones de software y niveles de parches. Se evalúa si el dispositivo cumple requisitos de seguridad |

### Los Planos de Control y Datos en Zero Trust

#### Plano de Control

- **Gestiona las políticas** que determinan cómo usuarios y dispositivos están autorizados para acceder a recursos.
- Se implementa a través de un **Punto de Decisión de Políticas (PDP — Policy Decision Point)** centralizado.

**Subsistemas del PDP:**

| Subsistema | Función |
|-----------|---------|
| **Motor de Políticas (Policy Engine)** | Configurado con identidades, credenciales, políticas de control de acceso, inteligencia de amenazas actualizada, análisis de comportamientos y resultados de monitoreo. Define algoritmos y métricas para tomar **decisiones dinámicas de autenticación y autorización por solicitud**. |
| **Administrador de Políticas (Policy Administrator)** | Gestiona el proceso de emisión de **tokens de acceso** y establece/cierra sesiones según las decisiones del Motor de Políticas. Implementa la interfaz entre el plano de control y el plano de datos. |

#### Plano de Datos

- **Establece sesiones** para transferencias de información seguras.
- Un **sujeto** (usuario o servicio) usa un sistema (laptop, smartphone) para hacer solicitudes de recursos.
- Cada solicitud está mediada por un **PEP (Policy Enforcement Point / Punto de Aplicación de Políticas)**.
- El PEP puede implementarse como agente de software en el host cliente que se comunica con una puerta de enlace de aplicaciones.

### Flujo de una Solicitud en Zero Trust (NIST Framework)

```
1. El Motor de Políticas está configurado con entradas dinámicas
   (identidades, amenazas, comportamientos, posturas de dispositivo)

2. El Administrador de Políticas comunica decisiones al Plano de Datos

3. Los sujetos poseen credenciales para acceder a recursos

4. Los sistemas cliente NO son de confianza implícita

5. El PEP (Punto de Cumplimiento de Políticas) es el ÚNICO de confianza
   para comunicar solicitudes y recibir decisiones del Administrador de Políticas

6. El PEP implementa la configuración y desmontaje de la sesión cifrada
   según las indicaciones del Administrador de Políticas

7. Se crea una zona de confianza implícita de alcance y duración LIMITADOS
```

### Zona de Confianza Implícita

- Ruta de datos establecida entre el **PEP** y el recurso.
- **Ejemplo:** Túnel IPsec entre un agente firmado digitalmente en el cliente, una puerta de enlace de aplicaciones web de confianza y el servidor de recursos.
- IPsec cifra los datos en tránsito → imposibilita la manipulación por parte de cualquier persona con acceso a la infraestructura de red subyacente (switches, APs, routers, firewalls).
- **Objetivo del diseño:** Hacer la zona de confianza implícita lo más **pequeña y transitoria** posible.
- Las sesiones de confianza pueden establecerse únicamente para **transacciones individuales** (microsegmentación).

### Ventajas de la Separación del Plano de Control y Datos

- Arquitectura de red más **flexible y escalable**.
- El plano de control centralizado garantiza consistencia en solicitudes de acceso: tanto en la red empresarial administrada como en Internet no administrado o redes de terceros.
- Facilita la gestión de políticas de control de acceso.
- **Monitoreo continuo:** Las sesiones pueden finalizarse si se detecta comportamiento anómalo.
- La ubicación en la red **NO** es razón suficiente para confiar en una solicitud → incluso un usuario autenticado puede ser bloqueado si el análisis de comportamiento lo detecta como sospechoso.

### Ejemplos de Implementaciones de Zero Trust

| Implementación | Descripción |
|---------------|-------------|
| **Google BeyondCorp** | Referente de ZTA. Sistema multicapa: verificación de identidad + verificación de dispositivos + políticas de control de acceso. Permite acceso remoto de empleados sin VPN tradicional manteniendo alta seguridad. |
| **Cisco Zero Trust Architecture** | Integra segmentación de red, políticas de control de acceso y capacidades de detección y respuesta a amenazas. Protege contra amenazas internas y externas. |
| **Palo Alto Networks Prisma Access** | Servicio de seguridad en la nube con ZTA. Protege tráfico de red, provee acceso seguro a recursos en la nube e Internet, previene exfiltración de datos. |

> **👉 Enfoque de Examen SY0-701:**
> Esta es la sección más densa y técnica de Zero Trust. Memoriza:
> - **Motor de Políticas** = toma las decisiones de autenticación/autorización.
> - **Administrador de Políticas** = emite tokens y gestiona sesiones.
> - **PEP/Punto de Aplicación** = el único punto autorizado para comunicarse con el Administrador de Políticas.
> - **Zona de confianza implícita** = lo más pequeña y temporal posible.
> - **Comportamiento anómalo** puede terminar una sesión aunque el usuario esté autenticado.
>
> **Distractores frecuentes:** confundir el Motor de Políticas con el Administrador de Políticas; pensar que una vez autenticado el acceso es permanente (en ZTA NO lo es). Pregunta tipo: "¿Qué componente de ZTA es responsable de emitir tokens de acceso?" → **Administrador de Políticas**. "¿Qué componente toma la decisión dinámica de autorización?" → **Motor de Políticas**.

# 3. Glosario de Acrónimos

| Acrónimo | Significado en inglés | Significado en español |
|---------|----------------------|----------------------|
| **AIC** | Availability, Integrity, Confidentiality | Disponibilidad, Integridad, Confidencialidad |
| **AUTOSAR** | Automotive Open System Architecture | Arquitectura de Sistema Abierto Automotriz |
| **BYOD** | Bring Your Own Device | Trae Tu Propio Dispositivo |
| **CapEx** | Capital Expenditure | Gasto de Capital |
| **CDN** | Content Delivery Network | Red de Distribución de Contenido |
| **CIA** | Confidentiality, Integrity, Availability | Confidencialidad, Integridad, Disponibilidad |
| **CSP** | Cloud Service Provider | Proveedor de Servicios en la Nube |
| **DCS** | Distributed Control System | Sistema de Control Distribuido |
| **DDoS** | Distributed Denial of Service | Denegación de Servicio Distribuida |
| **DR** | Disaster Recovery | Recuperación ante Desastres |
| **FaaS** | Function as a Service | Función como Servicio |
| **GRS** | Geo-Redundant Storage | Almacenamiento Georredundante |
| **HA** | High Availability | Alta Disponibilidad |
| **HCL** | HashiCorp Configuration Language | Lenguaje de Configuración de HashiCorp |
| **HMI** | Human-Machine Interface | Interfaz Hombre-Máquina |
| **HVAC** | Heating, Ventilation and Air Conditioning | Calefacción, Ventilación y Aire Acondicionado |
| **IaaS** | Infrastructure as a Service | Infraestructura como Servicio |
| **IaC** | Infrastructure as Code | Infraestructura como Código |
| **IAM** | Identity and Access Management | Gestión de Identidades y Accesos |
| **ICS** | Industrial Control System | Sistema de Control Industrial |
| **IIC** | Industrial Internet Consortium | Consorcio de Internet Industrial |
| **IoT** | Internet of Things | Internet de las Cosas |
| **IoTSF** | Internet of Things Security Foundation | Fundación de Seguridad del IoT |
| **ISA** | Interconnection Security Agreement | Acuerdo de Seguridad de Interconexión |
| **NFV** | Network Functions Virtualization | Virtualización de Funciones de Red |
| **NIST** | National Institute of Standards and Technology | Instituto Nacional de Estándares y Tecnología |
| **OpEx** | Operational Expenditure | Gasto Operativo |
| **OT** | Operational Technology | Tecnología Operativa |
| **P2P** | Peer-to-Peer | Red de Pares |
| **PaaS** | Platform as a Service | Plataforma como Servicio |
| **PDP** | Policy Decision Point | Punto de Decisión de Políticas |
| **PEP** | Policy Enforcement Point | Punto de Aplicación/Cumplimiento de Políticas |
| **PII** | Personally Identifiable Information | Información de Identificación Personal |
| **PLC** | Programmable Logic Controller | Controlador Lógico Programable |
| **PUE** | Power Usage Effectiveness | Efectividad en el Uso de Energía |
| **RTOS** | Real-Time Operating System | Sistema Operativo en Tiempo Real |
| **SaaS** | Software as a Service | Software como Servicio |
| **SAN** | Storage Area Network | Red de Área de Almacenamiento |
| **SASE** | Secure Access Service Edge | Perímetro de Servicio de Acceso Seguro |
| **SCADA** | Supervisory Control and Data Acquisition | Control de Supervisión y Adquisición de Datos |
| **SD-WAN** | Software-Defined Wide Area Network | Red de Área Amplia Definida por Software |
| **SDN** | Software-Defined Networking | Redes Definidas por Software |
| **SLA** | Service Level Agreement | Acuerdo de Nivel de Servicio |
| **Tor** | The Onion Router | El Enrutador Cebolla |
| **VDI** | Virtual Desktop Infrastructure | Infraestructura de Escritorio Virtual |
| **VM** | Virtual Machine | Máquina Virtual |
| **VPC** | Virtual Private Cloud | Nube Privada Virtual |
| **WAN** | Wide Area Network | Red de Área Amplia |
| **XaaS** | Anything as a Service | Cualquier cosa como Servicio |
| **ZTA** | Zero Trust Architecture | Arquitectura de Confianza Cero |