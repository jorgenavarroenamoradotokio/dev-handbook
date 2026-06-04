> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1 Seguridad de Puntos de Conexión](#1-seguridad-de-puntos-de-conexión)
    - [Por tipo de dispositivo:](#por-tipo-de-dispositivo)
    - [Objetivos de aprendizaje del Tema 10:](#objetivos-de-aprendizaje-del-tema-10)
- [1 Implementación de Seguridad en los Puntos de Conexión](#1-implementación-de-seguridad-en-los-puntos-de-conexión)
  - [Endurecimiento de los Puntos de Conexión (Endpoints)](#endurecimiento-de-los-puntos-de-conexión-endpoints)
    - [Seguridad del Sistema Operativo](#seguridad-del-sistema-operativo)
    - [Estaciones de Trabajo](#estaciones-de-trabajo)
    - [Configuración de Línea de Base y Ajustes de Registro](#configuración-de-línea-de-base-y-ajustes-de-registro)
  - [Protección de Puntos de Conexión](#protección-de-puntos-de-conexión)
    - [Segmentación](#segmentación)
    - [Aislamiento](#aislamiento)
    - [Antivirus y Antimalware](#antivirus-y-antimalware)
    - [Cifrado de Disco](#cifrado-de-disco)
    - [Gestión de Parches](#gestión-de-parches)
  - [Protección Avanzada de Puntos de Conexión](#protección-avanzada-de-puntos-de-conexión)
    - [Detección y Respuesta de Puntos de Conexión (EDR) y Detección y Respuesta Extendidas (XDR)](#detección-y-respuesta-de-puntos-de-conexión-edr-y-detección-y-respuesta-extendidas-xdr)
    - [Detección y Prevención de Intrusiones Basadas en el Host (HIDS/HIPS)](#detección-y-prevención-de-intrusiones-basadas-en-el-host-hidships)
    - [Análisis del Comportamiento de Usuarios (UBA) y Análisis del Comportamiento de Usuarios y Entidades (UEBA)](#análisis-del-comportamiento-de-usuarios-uba-y-análisis-del-comportamiento-de-usuarios-y-entidades-ueba)
  - [Configuración de Puntos de Conexión (Endpoints)](#configuración-de-puntos-de-conexión-endpoints)
    - [Control de Acceso](#control-de-acceso)
    - [Principio de Mínimo Privilegio (PoLP)](#principio-de-mínimo-privilegio-polp)
    - [Listas de Control de Acceso (ACL)](#listas-de-control-de-acceso-acl)
    - [Permisos del Sistema de Archivos](#permisos-del-sistema-de-archivos)
    - [Listas de Aplicaciones Permitidas y Listas de Bloqueos de Aplicaciones](#listas-de-aplicaciones-permitidas-y-listas-de-bloqueos-de-aplicaciones)
    - [Monitoreo](#monitoreo)
    - [Aplicación de la Configuración](#aplicación-de-la-configuración)
    - [Directiva de Grupo (Group Policy)](#directiva-de-grupo-group-policy)
    - [SELinux (Security-Enhanced Linux)](#selinux-security-enhanced-linux)
  - [Técnicas de Protección](#técnicas-de-protección)
    - [Protección de Puertos](#protección-de-puertos)
    - [Técnicas de Cifrado](#técnicas-de-cifrado)
    - [Cortafuegos e IPS Basados en Host](#cortafuegos-e-ips-basados-en-host)
    - [Instalación de Protección de Puntos de Conexión](#instalación-de-protección-de-puntos-de-conexión)
    - [Cambio de Valores Predeterminados y Eliminación del Software Innecesario](#cambio-de-valores-predeterminados-y-eliminación-del-software-innecesario)
    - [Desmantelamiento](#desmantelamiento)
  - [Endurecimiento de Dispositivos Especializados](#endurecimiento-de-dispositivos-especializados)
    - [Endurecimiento ICS/SCADA](#endurecimiento-icsscada)
    - [Endurecimiento Integrado y RTOS](#endurecimiento-integrado-y-rtos)
- [2 Endurecimiento de Dispositivos Móviles](#2-endurecimiento-de-dispositivos-móviles)
  - [Técnicas de Endurecimiento para Dispositivos Móviles](#técnicas-de-endurecimiento-para-dispositivos-móviles)
    - [Modelos de Implementación](#modelos-de-implementación)
    - [Administración de Dispositivos Móviles (MDM)](#administración-de-dispositivos-móviles-mdm)
  - [Cifrado Completo del Dispositivo y Medios Externos](#cifrado-completo-del-dispositivo-y-medios-externos)
  - [Servicios de Ubicación](#servicios-de-ubicación)
    - [Geovallado (Geofencing) y Aplicación de Normativas para Cámara y Micrófono](#geovallado-geofencing-y-aplicación-de-normativas-para-cámara-y-micrófono)
    - [Etiquetado GPS (GPS Tagging)](#etiquetado-gps-gps-tagging)
  - [Métodos de Conexión Celular y GPS](#métodos-de-conexión-celular-y-gps)
    - [Conexiones de Datos Celulares o Móviles](#conexiones-de-datos-celulares-o-móviles)
    - [Sistema de Posicionamiento Global (GPS)](#sistema-de-posicionamiento-global-gps)
  - [Métodos de Conexión Wi-Fi y Tethering (Anclaje de Red)](#métodos-de-conexión-wi-fi-y-tethering-anclaje-de-red)
    - [Redes de Área Personal (PAN)](#redes-de-área-personal-pan)
    - [Wi-Fi Ad Hoc y Wi-Fi Direct](#wi-fi-ad-hoc-y-wi-fi-direct)
    - [Tethering y Puntos de Acceso Inalámbrico (Hotspot)](#tethering-y-puntos-de-acceso-inalámbrico-hotspot)
  - [Métodos de Conexión Bluetooth](#métodos-de-conexión-bluetooth)
    - [Problemas de Seguridad de Bluetooth](#problemas-de-seguridad-de-bluetooth)
    - [Ataques Bluetooth Específicos](#ataques-bluetooth-específicos)
    - [Características de Seguridad de Bluetooth](#características-de-seguridad-de-bluetooth)
- [3 CONCEPTOS CLAVE](#3-conceptos-clave)
- [4 TABLA DE ATAQUES BLUETOOTH](#4-tabla-de-ataques-bluetooth)
- [5 COMANDOS Y PROTOCOLOS CLAVE](#5-comandos-y-protocolos-clave)

---

# 1 Seguridad de Puntos de Conexión

La **seguridad de puntos de conexión** (endpoint security) tiene como objetivo proteger **todos los dispositivos finales** conectados a una red:

- Computadoras de escritorio y portátiles
- Teléfonos inteligentes y tabletas
- Dispositivos de **IoT** (Internet of Things — Internet de las cosas)

> **Analogía:** Imagina que tu red es una ciudad amurallada. Los puntos de conexión (endpoints) son todas las puertas de entrada: ordenadores, móviles, tabletas, dispositivos IoT. Si una puerta tiene la cerradura rota, toda la ciudad está en peligro.

### Por tipo de dispositivo:

| Tipo de dispositivo | Enfoque principal de endurecimiento |
|---|---|
| Equipos de escritorio/portátiles | Actualizaciones de SO, antivirus, cortafuegos, mínimo privilegio |
| Dispositivos móviles | Cifrado, bloqueo de pantalla, MDM, deshabilitar Bluetooth/NFC innecesarios |
| Sistemas integrados / IoT | Firmware seguro, arranque seguro, comunicaciones cifradas, soluciones ligeras |

### Objetivos de aprendizaje del Tema 10:
- Explorar la importancia del endurecimiento de los puntos de conexión
- Comprender las técnicas de endurecimiento
- Explorar los desafíos únicos del endurecimiento de dispositivos integrados
- Obtener información sobre el endurecimiento de dispositivos móviles
- Explicar la importancia de la gestión de dispositivos móviles

> **👉 Enfoque de Examen SY0-701:** CompTIA distingue claramente entre endpoints tradicionales, dispositivos móviles y sistemas especializados (ICS/SCADA/IoT). Una pregunta clásica dice: "¿Qué control se aplica a un endpoint comprometido por ingeniería social?" → La respuesta NO es solo instalar antivirus; es **educación + revisión de privilegios**. Recuerda siempre el orden: identificar el vector → aplicar el control adecuado.

# 1 Implementación de Seguridad en los Puntos de Conexión

El **endurecimiento de dispositivos** (hardening) describe la práctica de **modificar configuraciones** para proteger los sistemas reduciendo vulnerabilidades atribuidas a configuraciones predeterminadas.

**Técnicas estándar incluyen:**
- Procesos de actualizaciones periódicas
- Políticas de contraseñas seguras
- **Principio de mínimo privilegio** (PoLP — Principle of Least Privilege)
- Desactivación/eliminación de software, servicios y funciones innecesarios
- Cifrado de datos
- Implementación de cortafuegos y sistemas de detección de intrusiones
- Auditorías periódicas de seguridad y evaluaciones de vulnerabilidad

**Objetivos del examen cubiertos:**
- 2.5 Explicar el objetivo de las técnicas de mitigación usadas para asegurar la empresa
- 4.1 Aplicar técnicas comunes de seguridad a los recursos computacionales
- 4.5 Modificar las capacidades de la empresa para aumentar la seguridad

> **Analogía:** Endurecer un sistema es como preparar una casa antes de un huracán: refuerzas puertas, cierras ventanas, retiras todo lo innecesario del jardín. No pones más cosas; eliminas las que podrían convertirse en proyectiles.

## Endurecimiento de los Puntos de Conexión (Endpoints)

### Seguridad del Sistema Operativo

La **seguridad del sistema operativo** abarca prácticas para proteger contra acceso no autorizado, filtraciones de datos, infecciones de malware y otras amenazas. Incluye:

- Controles de acceso
- Mecanismos de autenticación
- Configuraciones seguras
- Seguridad de aplicaciones
- Codificación segura
- **Gestión de parches** (patch management)
- Protección de puntos de conexión
- Capacitación de concientización del usuario
- Monitoreo

**El principio fundamental es el de MÍNIMA FUNCIONALIDAD:**
> Un sistema debe ejecutar **únicamente** los protocolos y servicios requeridos por usuarios legítimos, sin excederse.

**Componentes que deben gestionarse:**

| Componente | Riesgo / Acción |
|---|---|
| **Interfaces de red** | Desactivar explícitamente las no necesarias (cableadas, inalámbricas, módem, gestión) |
| **Servicios** | Deshabilitar servicios no utilizados (locales y remotos) |
| **Puertos de servicio** | Bloquear en cortafuegos los puertos de aplicaciones no requeridas |
| **Almacenamiento persistente** | Cifrar discos; usar unidades de autocifrado (**SED** — Self-Encrypting Drive) |

**Nota sobre puertos:** Un servidor HTTP puede estar configurado en `puerto 8080` en lugar del estándar `puerto 80`. El malware puede usar puertos abiertos para exfiltrar datos. Un **IDS** (Intrusion Detection System — Sistema de Detección de Intrusiones) debe detectar tráfico que no se ajuste al protocolo esperado.

> **Analogía:** El endurecimiento es como ajustar la "resistencia al viento" de un edificio: cuanto más lo endurezcas, menos puntos de ataque quedan expuestos, pero si te excedes, el edificio ya no es habitable (usabilidad vs. seguridad).

### Estaciones de Trabajo

Las **estaciones de trabajo** son la primera línea de actividades de una organización y presentan preocupaciones únicas:

- Gran superficie de ataque por diversidad de tareas y aplicaciones
- **Prácticas de endurecimiento específicas:**
  - Eliminación de software innecesario
  - Limitación de privilegios administrativos
  - Gestión estricta de instalaciones y actualizaciones
  - Capacitación periódica contra **phishing** (suplantación de identidad)
  - Comportamientos seguros: contraseñas robustas, uso responsable de Internet

**Configuraciones de seguridad esenciales:**
- Actualizaciones automáticas
- Bloqueos de pantalla
- Cortafuegos de host
- Protección de puntos de conexión
- Detección y prevención de intrusiones
- Aumento del registro (logging)
- Cifrado
- Monitoreo

**Segmentación de red:** Esencial para restringir comunicaciones y limitar la propagación de malware entre estaciones de trabajo.

### Configuración de Línea de Base y Ajustes de Registro

Una **línea de base de configuración** (configuration baseline) es una plantilla estándar de configuraciones seguras para un tipo específico de dispositivo.

**Tipos de líneas de base habituales:**
- Clientes de escritorio
- Servidores de archivos e impresión
- Servidores de **DNS** (Domain Name System — Sistema de Nombres de Dominio)
- Servidores de aplicaciones
- Servidores de directorio

**En entornos Windows:**
- Las configuraciones se almacenan en el **registro**
- Los equipos unidos a dominio reciben configuraciones vía **GPO** (Group Policy Object — Objeto de Directiva de Grupo)
- Los derechos para modificar el registro deben otorgarse bajo **mínimo privilegio**
- Se puede configurar un **HIDS** (Host-based Intrusion Detection System) para alertar sobre eventos de registro sospechosos

**Herramientas de gestión:**
- **MBSA** (Microsoft Baseline Security Analyzer): herramienta clásica (reemplazada)
- **Security Compliance Toolkit** (`docs.microsoft.com/en-us/windows/security/threat-protection/security-compliance-toolkit-10`): herramienta actual de Microsoft
- **SCCM** (System Center Configuration Manager) / **Endpoint Manager de Microsoft**: gestión empresarial de parches y configuraciones

**Informes de desviación de líneas de base:** Examinan la configuración real de los hosts para garantizar que coincidan con la plantilla de referencia.

> **Analogía:** Una línea de base de configuración es como el "plano original" de una casa. Cuando detectas que algo cambió (una puerta nueva que nadie autorizó), sabes que algo va mal porque tienes el plano como referencia.

> **👉 Enfoque de Examen SY0-701:** CompTIA pregunta sobre GPO y líneas de base en escenarios. Un distractor común es confundir "línea de base" con "política de contraseñas". La línea de base cubre **toda** la configuración del sistema (interfaces, servicios, puertos, registro). También vigila preguntas sobre qué herramienta de Microsoft reemplazó a MBSA → **Security Compliance Toolkit**.

## Protección de Puntos de Conexión

El propósito del endurecimiento es minimizar vulnerabilidades que una entidad maliciosa podría explotar, mediante:
- Configuración de la red
- Ajustes del sistema para reducir la **superficie de ataque** (attack surface)

### Segmentación

La **segmentación** es fundamental para asegurar un entorno empresarial:

- Los sistemas se dividen en **segmentos o subredes** separados
- Cada segmento tiene diferentes controles de seguridad y permisos de acceso
- **Beneficios:**
  - Dificulta el movimiento lateral de atacantes
  - Otorga más tiempo para detectar y responder ataques
  - Control más granular sobre el acceso a datos
  - Mejora la protección y privacidad de los datos

**Ejemplo de red segmentada:**
```
[Subred Marketing] — Conmutador — [Enrutador] — Conmutador — [Subred Finanzas]
```
El tráfico entre las dos subredes lo controla el **enrutador** (router), que puede aplicar políticas de acceso.

> **Analogía:** La segmentación de red es como dividir un barco en compartimentos estancos. Si uno se inunda, los demás permanecen secos. En redes, si un segmento se infecta, el malware no se propaga al resto.

### Aislamiento

El **aislamiento** (isolation) de dispositivos:
- Segrega equipos individuales dentro de una red
- Limita su interacción con otros dispositivos
- **Objetivo:** Evitar la propagación lateral de amenazas
- Especialmente útil para amenazas como **gusanos** y **ransomware** (secuestro de datos)

**Diferencia clave:**

| Concepto | Alcance | Propósito |
|---|---|---|
| Segmentación | Grupos de sistemas (subredes) | Reducir superficie de ataque global |
| Aislamiento | Dispositivos individuales | Contener una amenaza activa |

### Antivirus y Antimalware

El **software antivirus** moderno va mucho más allá de los virus:

- **Primera generación:** Detección basada en **firmas** (signatures) de virus conocidos
- **Actualidad:** Detección exhaustiva de malware incluyendo:
  - Virus y gusanos
  - Troyanos
  - **Software espía** (spyware)
  - **PUP** (Potentially Unwanted Program — Programa Potencialmente No Deseado)
  - **Cryptojackers** (secuestradores de recursos para minería)

**Limitación importante:** La detección basada en firmas es **insuficiente** por sí sola para prevenir violaciones de datos. Se requieren técnicas complementarias.

> **Analogía:** El antivirus de primera generación era como un guardia con una lista de sospechosos conocidos. El antimalware moderno es como un detective que busca comportamientos sospechosos aunque no conozca al sospechoso.

### Cifrado de Disco

El **cifrado de disco completo** — **FDE** (Full Disk Encryption) — significa que **todo el contenido** de la unidad, incluidos archivos y carpetas del sistema, está cifrado.

**¿Por qué es necesario?**
- Las medidas de seguridad basadas en **ACL** (Access Control List — Lista de Control de Acceso) del SO son fáciles de evadir si se conecta la unidad a otro sistema host.
- FDE hace que el contenido sea accesible **solo con la clave de cifrado correcta**.
- Aplica tanto a **HDD** (Hard Disk Drive — Unidad de Disco Duro) como a **SSD** (Solid State Drive — Unidad de Estado Sólido).

**Almacenamiento de la clave FDE:**
- Normalmente en un **TPM** (Trusted Platform Module — Módulo de Plataforma Confiable): chip que tiene área de almacenamiento seguro
- También puede usarse una **unidad USB extraíble** (si el USB es opción de arranque)
- Se crea una **contraseña o clave de recuperación** durante la configuración

**Windows BitLocker:** Herramienta de cifrado de disco de Microsoft. Se gestiona desde Panel de Control → BitLocker Drive Encryption.

**Discos Autrocriptados — SED** (Self-Encrypting Drive):
- Las operaciones criptográficas las realiza el **controlador del disco** (no el SO)
- Mitiga la reducción de rendimiento del FDE por software
- Usa una **clave simétrica de cifrado de datos/medios** — **DEK/MEK** (Data/Media Encryption Key)
- La DEK se almacena cifrada con un par de claves asimétricas:
  - **AK** (Authentication Key — Clave de Autenticación): se autentica con la contraseña del usuario
  - **KEK** (Key Encryption Key — Clave de Cifrado de Claves): cifra la DEK
- Estándar actual: especificación **Opal Storage Specification** del **TCG** (Trusted Computing Group)

**Casos de uso del FDE:**

| Dispositivo | Por qué aplicar FDE |
|---|---|
| Portátiles, escritorios, móviles, servidores | Protege datos confidenciales incluso si el disco se extrae; en VMs, impide acceso directo al disco virtual |
| Dispositivos IoT | Impide acceso no autorizado si el dispositivo es comprometido físicamente |
| HDD externo, USB, medios externos | Datos protegidos ante robo o extravío |

> **Analogía:** El cifrado de disco completo es como guardar tu diario en una caja fuerte. Aunque alguien robe la caja, sin la combinación correcta no puede leer nada.

### Gestión de Parches

**Principio clave:** Ningún SO, aplicación o firmware está libre de vulnerabilidades. Cuando se identifica una vulnerabilidad:
- Los **proveedores** intentan corregirla (lanzan parche)
- Los **atacantes** intentan explotarla

**Gestión en entornos domésticos/pequeños:**
- Los hosts se configuran para actualizarse **automáticamente**
- **Windows Update** gestiona este proceso en Windows
- En Linux: herramientas como `yum-cron` o `aptunattended-upgrades`

**Riesgos en redes empresariales:**
- Un parche incompatible puede causar problemas de **disponibilidad**
- Caso SolarWinds: los repositorios de actualizaciones pueden infectarse con malware que se propaga mediante actualizaciones automáticas
- Puede ser difícil programar operaciones de correcciones en sistemas críticos

**Solución empresarial:**
- Implementar una **suite empresarial de gestión de parches**
- Ejemplo: **SCCM/Endpoint Manager de Microsoft** (`docs.microsoft.com/en-us/mem/configmgr`)
- **Probar parches en entornos de prueba** antes de producción

**Casos problemáticos:**
- **Sistemas heredados** (legacy): SO o aplicaciones sin soporte del fabricante
- **Sistemas patentados**: sin planes sólidos de gestión de seguridad
- **Dispositivos IoT**: parches no siempre disponibles
- Solución: implementar **controles compensatorios** u otras formas de mitigación de riesgos

> **Analogía:** Un parche de software es como reparar una gotera en el techo. Si sabes que llueve (los atacantes buscan la vulnerabilidad), debes reparar antes de que el agua (el exploit) entre.

> **👉 Enfoque de Examen SY0-701:** CompTIA ama las preguntas sobre gestión de parches en escenarios IoT/legacy donde el parche NO está disponible. La respuesta correcta es siempre "implementar controles compensatorios". Otro distractor frecuente: confundir `yum-cron` (RedHat/CentOS) con `aptunattended-upgrades` (Debian/Ubuntu). Vigila también el ataque a SolarWinds como ejemplo de **supply chain attack** (ataque a la cadena de suministro) relacionado con actualizaciones.

## Protección Avanzada de Puntos de Conexión

### Detección y Respuesta de Puntos de Conexión (EDR) y Detección y Respuesta Extendidas (XDR)

**EDR** (Endpoint Detection and Response — Detección y Respuesta de Puntos de Conexión):
- Acuñado por el investigador de seguridad de Gartner, **Anton Chuvakin**
- **Objetivo:** Proporcionar visibilidad en tiempo real e histórica sobre el compromiso
- **Funciones:**
  - Contener el malware dentro de un solo equipo
  - Facilitar la remediación del host para devolverlo a su estado original
  - Monitoreo y recopilación de datos de endpoints en tiempo real
  - Investigación y respuesta a amenazas avanzadas y ransomware
  - Conocimientos forenses valiosos tras una brecha de seguridad

**EDR vs. XDR:**

| Característica | EDR | XDR (Extended Detection and Response — Detección y Respuesta Extendidas) |
|---|---|---|
| Alcance | Endpoints (equipos, portátiles, móviles) | Endpoints + red + nube + correo + cortafuegos |
| Visibilidad | Dispositivos individuales | Infraestructura completa |
| Análisis | Datos del endpoint | Correlación de múltiples fuentes |
| Velocidad de respuesta | Rápida a nivel de endpoint | Más rápida por visión integral |

**Nota:** La **MDR** (Managed Detection and Response — Detección y Respuesta Gestionada) es una **clase de servicio** de seguridad hospedado, no un producto de software instalado.

**Características de agentes de próxima generación:**
- Gestionados desde un **portal en la nube**
- Usan **IA** (Inteligencia Artificial) y **aprendizaje automático**
- Realizan análisis de comportamiento de usuarios y entidades (**UEBA**)

> **Analogía:** Si el antivirus es un guardia de seguridad, el EDR (Endpoint Detection and Response) es como tener un detective forense 24/7 que registra todo lo que ocurre, detecta comportamientos anómalos y puede aislar al sospechoso automáticamente.

### Detección y Prevención de Intrusiones Basadas en el Host (HIDS/HIPS)

**HIDS** (Host-based Intrusion Detection System — Sistema de Detección de Intrusiones Basado en el Host) y **HIPS** (Host-based Intrusion Prevention System — Sistema de Prevención de Intrusiones Basado en el Host):

**Diferencia clave:**

| Sistema | Acción ante amenaza |
|---|---|
| **HIDS** | Detecta y **alerta** (notificación al administrador) |
| **HIPS** | Detecta y **responde activamente** (bloquea o mitiga automáticamente) |

**Métodos de detección:**
- Detección basada en **firmas**
- Detección de **anomalías**
- **Análisis de comportamiento**

**Fuentes de datos que analizan:**
- Registros del sistema
- Tráfico de red
- Actividades de los usuarios

**FIM** (File Integrity Monitoring — Supervisión de la Integridad de Archivos):
- Característica principal de HIDS
- Audita archivos clave del sistema para garantizar que coincidan con las versiones autorizadas
- **En Windows:**
  - Servicio de protección de archivos se ejecuta automáticamente
  - **SFC** (System File Checker — Comprobador de Archivos del Sistema) para verificación manual
- **Herramientas multiplataforma:** Tripwire (`tripwire.com`), OSSEC (`ossec.net`)

### Análisis del Comportamiento de Usuarios (UBA) y Análisis del Comportamiento de Usuarios y Entidades (UEBA)

**UBA** (User Behavior Analytics — Análisis del Comportamiento de Usuarios) / **UEBA** (User and Entity Behavior Analytics — Análisis del Comportamiento de Usuarios y Entidades):
- Enfoque de ciberseguridad basado en **supervisión y análisis del comportamiento**
- Detecta anomalías que indican amenazas internas, cuentas comprometidas o fraudes

**Cómo funciona:**
1. Aprovecha técnicas de **aprendizaje automático**, **ciencia de datos** y **análisis estadístico**
2. Establece un **perfil de referencia** para cada usuario/entidad
3. Compara continuamente comportamientos nuevos contra el perfil establecido
4. **Alerta** sobre actividades inusuales o sospechosas

**Ejemplos de alertas UEBA:**
- Usuario que normalmente descarga archivos pequeños durante horario laboral → empieza a descargar grandes volúmenes a altas horas de la noche
- Usuario que siempre inicia sesión desde Madrid → de repente inicia sesión desde un país extranjero

**Productos comerciales UEBA:**
- Splunk User Behavior Analytics
- IBM QRadar User Behavior Analytics
- Rapid7 InsightIDR
- Forcepoint Insider Threat

> **Analogía:** UBA/UEBA es como un sistema de alarma bancaria que aprende los hábitos normales de cada cliente. Si tu tarjeta se usa a las 3 AM en Rusia cuando siempre la usas en Madrid, la alarma se dispara automáticamente.

> **👉 Enfoque de Examen SY0-701:** Distractor frecuente: confundir HIDS (alerta pero no bloquea) con HIPS (bloquea activamente). En escenarios de examen: si la pregunta menciona "detectar cambios en archivos del sistema" → FIM. Si menciona "bloquear automáticamente actividad maliciosa en un host" → HIPS. Si menciona "comportamiento anómalo de usuario" → UBA/UEBA. XDR siempre abarca más fuentes que EDR.

## Configuración de Puntos de Conexión (Endpoints)

Cuando la seguridad de un endpoint se ve comprometida, los vectores a considerar para la mitigación son:

| Vector | Acción de mitigación |
|---|---|
| **Ingeniería social** | Educación y concientización; revisar permisos de la cuenta comprometida |
| **Vulnerabilidades** | Instalar el parche correspondiente o aislar el sistema |
| **Falta de controles de seguridad** | Implementar endpoint protection, antivirus, cortafuegos de host, filtrado de contenidos, DLP, MDM |
| **Deriva de configuración** | Volver a aplicar configuración de referencia; revisar gestión de configuraciones |
| **Configuración débil** | Revisar y fortalecer la plantilla de configuración |

### Control de Acceso

El **control de acceso** regula y gestiona los permisos otorgados a individuos, software, sistemas y redes para acceder a recursos o información.
Se aplica a: redes, acceso físico, datos, aplicaciones y la nube.

> **Analogía:** El control de acceso es como el sistema de tarjetas de un hotel. Solo los huéspedes con tarjeta válida pueden abrir su habitación. El administrador (recepción) decide quién tiene acceso a qué.

### Principio de Mínimo Privilegio (PoLP)

**PoLP** (Principle of Least Privilege — Principio de Mínimo Privilegio):
- Los usuarios, aplicaciones y procesos deben tener **solo los permisos mínimos necesarios** para completar sus tareas, pero no más

**Implementación práctica:**
- **Auditoría minuciosa** de funciones, privilegios y responsabilidades de los usuarios
- Revisión y eliminación regular de cuentas no utilizadas o innecesarias
- **Privilegios temporales**: derechos adicionales por tiempo limitado y solo cuando son necesarios
- **RBAC** (Role-Based Access Control — Control de Acceso Basado en Roles): asigna derechos de acceso en función de roles predefinidos

**Aplicación ampliada:** PoLP aplica también a **aplicaciones de software y sistemas operativos**, no solo a usuarios.

### Listas de Control de Acceso (ACL)

**ACL** (Access Control List — Lista de Control de Acceso):
- Lista de reglas o entradas que especifican qué usuarios o grupos tienen permitido o denegado el acceso a recursos específicos

**En redes:**
- Asociadas con enrutadores, cortafuegos u otros dispositivos
- Filtran o reenvían tráfico en función de:
  - Direcciones IP de origen/destino
  - Puertos
  - Protocolos

**En sistemas de archivos y SO:**
- Cada entrada se denomina **ACE** (Access Control Entry — Entrada de Control de Acceso)
- Contiene: identificador de usuario/grupo + permisos (lectura, escritura, ejecución, modificar, eliminar, enumerar)
- El **orden de las ACE** en la ACL es importante para determinar permisos efectivos

**Sistemas de archivos compatibles:** NTFS, ext3/ext4, ZFS

### Permisos del Sistema de Archivos

**En Linux — Tres permisos básicos:**

| Permiso | Símbolo | Valor | Descripción |
|---|---|---|---|
| Lectura | `r` | 4 | Acceder/ver contenido de archivos o enumerar directorio |
| Escritura | `w` | 2 | Guardar cambios, crear/renombrar/eliminar archivos |
| Ejecución | `x` | 1 | Ejecutar scripts/programas o acceder a un directorio |

**Contextos de aplicación:**
- `u` = usuario propietario
- `g` = grupo
- `o` = otros usuarios

**Ejemplo de cadena de permisos:**
```
d rwx r-x r-x home
```
→ Directorio (`d`), propietario: lectura+escritura+ejecución (`rwx`), grupo: lectura+ejecución (`r-x`), otros: lectura+ejecución (`r-x`)

**Comando `chmod` para modificar permisos:**

Modo simbólico:
```bash
chmod g+w,o-x home
```
→ Añade permiso de escritura al grupo; elimina ejecución para otros

Modo simbólico completo:
```bash
chmod u=rwx,g=rx,o=rx home
```

Modo absoluto (octal):
```bash
chmod 755 home
```
→ 7(=4+2+1=rwx para usuario), 5(=4+1=r-x para grupo), 5(=4+1=r-x para otros)

### Listas de Aplicaciones Permitidas y Listas de Bloqueos de Aplicaciones

**Política de control de ejecución:**

| Tipo | Nombre alternativo | Comportamiento |
|---|---|---|
| **Lista de permisos** (allow list) | Approved list | Niega la ejecución a menos que el proceso esté explícitamente autorizado |
| **Lista de bloqueo** (block list) | Deny list | Permite la ejecución pero prohíbe explícitamente los procesos incluidos en la lista |

**Consideraciones:**
- El contenido de las listas debe **actualizarse** en respuesta a incidentes y monitoreo continuo de amenazas
- Cambiar de lista de bloqueo a lista de permisos es **altamente disruptivo**: requiere evaluación de riesgos e impacto en el negocio
- Los actores de amenaza pueden **evadir** controles de ejecución; el análisis de ataques puede sugerir mejoras

> **Analogía:** Una **lista de permisos** es como un club con lista VIP: solo entra quien está en la lista. Una **lista de bloqueo** es como una lista negra: todos entran excepto los que están en ella.

### Monitoreo

El **monitoreo** es fundamental para:
- Aplicar y mantener las medidas de seguridad establecidas durante el endurecimiento
- Detectar cambios que debiliten la configuración reforzada
- Alertar cuando un puerto desactivado se abre o un servicio desactivado se reactiva
- Aportar datos para **cumplimiento y auditoría**
- Verificar que las líneas de base se hayan implementado y mantenido efectivamente

### Aplicación de la Configuración

La **aplicación de la configuración** (configuration enforcement) garantiza que los sistemas cumplan con las configuraciones de seguridad obligatorias:

**Capacidades clave:**

- **Líneas de base de configuración estandarizadas:** Definidas por organizaciones como NIST, CIS o la propia organización
- **Herramientas de gestión de configuración automatizada:** Aplican y mantienen líneas de base automáticamente
- **Monitoreo continuo y controles de cumplimiento:** Detectan desviaciones de configuraciones obligatorias
- **Procesos de gestión de cambios:** Garantizan que los cambios sean revisados, probados y aprobados antes de implementarse

### Directiva de Grupo (Group Policy)

**Directiva de grupo** (Group Policy):
- Característica del SO Microsoft Windows
- Proporciona gestión y configuración **centralizadas** de SO, aplicaciones y ajustes del usuario
- Opera en entornos de **Active Directory** (Directorio Activo)
- Las directivas están vinculadas a **OU** (Organizational Unit — Unidad Organizativa)

**Ejemplos de configuraciones gestionables:**
- Políticas de contraseñas
- Derechos de usuario
- Configuraciones del cortafuegos de Windows
- Configuraciones de actualización del sistema
- Restricciones de instalación de software

**Ventaja:** Reduce problemas relacionados con configuraciones incorrectas o inconsistentes.

> **Analogía:** La Directiva de Grupo es como el reglamento interno de una empresa aplicado automáticamente a todos los empleados: no importa a qué computadora te conectes, las reglas siempre se aplican.

### SELinux (Security-Enhanced Linux)

**SELinux** (Security-Enhanced Linux — Linux con Seguridad Mejorada):
- Característica de seguridad del **kernel** (núcleo) de Linux
- Admite políticas de seguridad de control de acceso, incluso **MAC** (Mandatory Access Control — Control de Acceso Obligatorio)
- Proporciona control de permisos más **granular** sobre cada proceso y objeto del sistema
- Opera bajo el principio: si un proceso/usuario no necesita acceso a los recursos para funcionar, **se bloqueará**
- Restringe el acceso al sistema y a los archivos
- Previene que programas maliciosos o defectuosos causen daños al sistema

**SELinux en Android:**
- Las capacidades de SELinux también están disponibles en Android mediante **SEAndroid**
- Implementación mantenida de forma independiente por diferencias arquitectónicas entre Linux y Android

> **👉 Enfoque de Examen SY0-701:** Preguntas sobre permisos Linux son clásicas. Recuerda: `chmod 755` = `rwxr-xr-x`. El distractor más común es confundir el modo octal: 7=rwx, 6=rw-, 5=r-x, 4=r--. También vigila la diferencia entre RBAC (roles predefinidos) y PoLP (permisos mínimos necesarios): pueden parecer lo mismo pero son conceptos distintos. La Directiva de Grupo solo aplica a entornos **Windows/Active Directory**; SELinux es exclusivo de **Linux**.

## Técnicas de Protección

Se requieren diferentes enfoques de endurecimiento para proteger los endpoints, usando una **estrategia de defensa en capas** (defense in depth) que aborde vulnerabilidades en múltiples niveles:
- Acceso físico
- Protocolos de red
- Configuraciones del SO
- Comportamientos de los usuarios

### Protección de Puertos

El endurecimiento de **puertos físicos** implica restringir las interfaces físicas del dispositivo:

**Técnicas:**
- Desactivar puertos físicos innecesarios: `USB`, `HDMI`, puertos serie
- Software de control de puertos: solo permite dispositivos autorizados basándose en **identificadores de dispositivos**
- Configuración en **firmware UEFI/BIOS** para:
  - Desactivar puertos físicos
  - Solicitar contraseña antes de arrancar desde fuente no estándar (ej. USB)
- En tabletas y portátiles: desactivar la **función de conexión automática a redes**

**Amenaza BadUSB:**
- Investigador Karsten Nohl reveló que el firmware de dispositivos de almacenamiento externo puede **reprogramarse** para que el dispositivo actúe como otro tipo de dispositivo (ej. teclado)
- Un USB reprogramado puede inyectar pulsaciones de teclas, actuar como registrador de teclas (**keylogger**) o corromper la resolución de nombres DNS
- El cable **O.MG**: cable USB-Lightning de apariencia normal que actúa como punto de acceso y keylogger

**Recomendaciones:**
- Nunca conectar dispositivos de procedencia desconocida
- Si se sospecha de un dispositivo como vector de ataque: observar en **laboratorio aislado** (también llamado "inmersión de ovejas")
- Los hosts siempre deben configurarse para **evitar la ejecución automática** al conectar dispositivos USB

**Puertos lógicos:**
- Los cortafuegos protegen los puertos lógicos examinando el tráfico de red
- Las prácticas de endurecimiento de servicios garantizan que los servicios que se ejecutan en puertos lógicos estén fortalecidos
- Ej: mantener el software actualizado y desactivar servicios innecesarios

> **Analogía:** Los puertos físicos de un dispositivo son como los enchufes de una casa. Si no los necesitas, los cubres con tapas de seguridad para que nadie pueda meter nada peligroso.

### Técnicas de Cifrado

**Métodos de cifrado para endpoints:**

| Técnica | Descripción | Ejemplos |
|---|---|---|
| **FDE** (Cifrado de disco completo) | Encripta todo el disco incluyendo SO y archivos de usuario | BitLocker (Windows), FileVault (macOS) |
| **Cifrado de medios extraíbles** | Protege datos en tarjetas SD, USB, dispositivos externos | Funciones integradas en herramientas FDE |
| **VPN** (Virtual Private Network — Red Privada Virtual) | Túnel seguro para transmisión de datos; protege contra espionaje y ataques en ruta | Múltiples soluciones empresariales |
| **Cifrado de correo electrónico** | Protege información confidencial en correos | **PGP** (Pretty Good Privacy — Privacidad Bastante Buena), **S/MIME** (Secure/Multipurpose Internet Mail Extensions — Extensiones Multipropósito de Correo de Internet Seguro) |

### Cortafuegos e IPS Basados en Host

Los **cortafuegos** (firewalls) e **IPS** (Intrusion Prevention System — Sistema de Prevención de Intrusiones) basados en host son elementos vitales para el endurecimiento:

**Funciones:**
- Controlan el tráfico de red entrante y saliente
- Detectan posibles ataques
- **Política de denegación predeterminada:** Bloquean todo el tráfico a menos que se permita explícitamente
- Filtrado por números de puerto, direcciones IP, protocolos y servicios
- Bloquean tráfico malicioso o permiten solo tráfico que use protocolos seguros
- Los cortafuegos avanzados incluyen **control de aplicaciones**

**Integración con SIEM** (Security Information and Event Management — Gestión de Información y Eventos de Seguridad):
- Los registros de cortafuegos e IPS integrados con un SIEM permiten detección y respuesta rápidas

### Instalación de Protección de Puntos de Conexión

**Mejores prácticas para implementación:**

- **Crear un plan de implementación:** Considerar orden, marcos de tiempo y etapas por departamento
- **Estandarizar configuraciones:** Coherencia en todos los dispositivos
- **Automatizar implementaciones:** Herramientas como SCCM, Directiva de Grupo o soluciones de terceros
- **Mantener actualizaciones y parches:** Para el software de seguridad y definiciones
- **Supervisar agentes:** Verificar alertas, ejecución correcta y aplicación de parches
- **Centralizar la gestión:** Visión integral de configuraciones, actualizaciones y estado

### Cambio de Valores Predeterminados y Eliminación del Software Innecesario

**Contraseñas predeterminadas:**
- Establecidas por los fabricantes para configuración inicial
- Son **ampliamente conocidas y fáciles de descubrir**
- Cambiarlas por credenciales únicas y seguras es **indispensable** en la configuración inicial

**Eliminación de software innecesario:**
- Cada aplicación de software presenta **vulnerabilidades potenciales**
- La superficie de ataque se reduce significativamente al minimizar el número de aplicaciones
- Incluye:
  - Eliminar aplicaciones innecesarias
  - Desactivar funciones o servicios innecesarios dentro de las aplicaciones restantes
- Simplifica la gestión de parches (menos aplicaciones = menos parches pendientes)

**Ejemplo — Impresora de red multifunción:**
- Contraseñas predeterminadas de fábrica deben cambiarse inmediatamente
- Desactivar funciones no necesarias: impresión en la nube, correo electrónico, interfaces de servidor web
- Actualizaciones periódicas de firmware
- Protocolos cifrados: `HTTPS` para interfaces web, `SNMPv3` para gestión de dispositivos
- Acceso basado en **principio de mínimo privilegio**

> **Analogía:** Las contraseñas predeterminadas son como la llave maestra que entrega el constructor de un edificio a todos los inquilinos: todos la conocen. Debes cambiarla el primer día.

### Desmantelamiento

El **desmantelamiento** (decommissioning) de dispositivos es un proceso crítico de seguridad:

**Pasos del proceso:**
1. **Sanitización de datos:** Borrado seguro de todos los datos del dispositivo o medio extraíble (garantiza que no quede ningún dato recuperable)
2. **Restablecimiento de configuración de fábrica:** A través de consola de administración u otra utilidad
3. **Destrucción física** de componentes (si almacenaron datos confidenciales): módulos de memoria, HDD, SSD, M.2 u otros módulos de almacenamiento
4. **Documentación:** Actualización de registros de inventario para reflejar el desmantelamiento

**En algunos casos:** Contratar un **servicio de eliminación profesional** especializado en destrucción certificada y segura de componentes electrónicos.

**Ejemplo — Impresora multifunción:**
- Sanitizar trabajos de impresión almacenados, documentos escaneados, transmisiones de fax
- Eliminar credenciales de red almacenadas y datos de configuración
- Restablecimiento completo de fábrica
- Disposición o destrucción segura de componentes físicos
- Actualización de inventario de activos

> **Analogía:** Desmantelar un dispositivo sin sanitizarlo es como tirar tu extracto bancario sin triturarlo: quien lo encuentre en el contenedor puede obtener toda tu información.

> **👉 Enfoque de Examen SY0-701:** CompTIA pregunta sobre técnicas de protección en escenarios prácticos. Puntos críticos a recordar: (1) BadUSB → firmware reprogramable → laboratorio de aislamiento. (2) Diferencia entre PGP y S/MIME → ambos cifran correo pero S/MIME usa certificados X.509. (3) La política de "denegación predeterminada" en cortafuegos es siempre más segura que "permitir todo excepto lo bloqueado". (4) El desmantelamiento sin sanitización es una brecha de seguridad. Vigilar: preguntas sobre `SNMPv3` vs `SNMPv1/v2` (sin cifrado).

## Endurecimiento de Dispositivos Especializados

Los sistemas que han sido objeto de ataques con mayor frecuencia en los últimos años incluyen:

- **ICS** (Industrial Control System — Sistema de Control Industrial)
- **SCADA** (Supervisory Control and Data Acquisition — Supervisión, Control y Adquisición de Datos)
- Sistemas integrados (embedded systems)
- **RTOS** (Real-Time Operating System — Sistema Operativo en Tiempo Real)
- Dispositivos **IoT** (Internet of Things — Internet de las cosas)

**Razón:** Su papel vital en el control de infraestructuras críticas.

**Estrategias generales de endurecimiento (aplicables a todos):**
- Actualizaciones periódicas del sistema
- Desactivación de servicios innecesarios
- Limitación del acceso a la red
- Uso de credenciales de seguridad y controles de acceso basados en roles (RBAC)
- Cortafuegos, **IDS/IPS**
- Protocolos de cifrado de transporte: `TLS`, `SSH`
- Auditorías de seguridad periódicas y pruebas de penetración

### Endurecimiento ICS/SCADA

**ICS/SCADA** se usan para controlar operaciones físicas (plantas de energía, sistemas de agua, gas):

**Controles específicos:**
- **Segmentación estricta de la red:** Aislar de la red más amplia
- Procesos sólidos de **autenticación y autorización**
- **Pasarelas unidireccionales** (diodos de datos): Garantizan que los datos fluyan **únicamente hacia el exterior** desde estos sistemas → Protegen contra ataques externos

**Consecuencias de una brecha:**
- Desastres ambientales
- Fallas en servicios públicos (energía, gas, agua)
- **Pérdida de vidas humanas**

### Endurecimiento Integrado y RTOS

Los sistemas integrados simples y los RTOS:
- Tienen **recursos limitados** y no admiten medidas de seguridad tradicionales
- La seguridad debe integrarse **desde la concepción** del sistema

**Consideraciones:**
- Prácticas de **codificación segura**
- **Diseño mínimo**: Solo las funcionalidades necesarias para su operación
- Mecanismos de **arranque seguro** (secure boot)
- Protección física contra manipulaciones
- Pruebas de seguridad exhaustivas
- Seleccionar dispositivos según **calidad y capacidades de seguridad**, no solo por características de uso y costo

**Estándares y certificaciones relevantes:**
- **Common Criteria** (ISO/IEC 15408)
- **IEC 62443**
- **MISRA-C** (estándar de codificación segura)
- Estándares de codificación segura **CERT**
- **ISO 27001**
- **IEC 61508**

> **👉 Enfoque de Examen SY0-701:** Los dispositivos ICS/SCADA son tema favorito del examen. Puntos clave: (1) Las pasarelas unidireccionales (diodos de datos) son el control ÚNICO específico de ICS/SCADA. (2) RTOS/sistemas integrados → seguridad por diseño, no añadida. (3) Un ataque exitoso a SCADA puede tener consecuencias físicas (vidas humanas). Distractor: confundir RTOS con IoT → son diferentes aunque comparten desafíos.

# 2 Endurecimiento de Dispositivos Móviles

El **endurecimiento de dispositivos móviles** abarca prácticas esenciales:
- Actualizaciones periódicas
- Restricciones de acceso
- Configuraciones seguras
- Cifrado
- Bloqueos de pantalla
- Controles de acceso a la red
- Restricciones de aplicaciones
- Limitación de funciones como Bluetooth y NFC
- **MDM** (Mobile Device Management — Administración de Dispositivos Móviles)

**Objetivo del examen cubierto:**
- 4.1 Aplicar técnicas comunes de seguridad a los recursos computacionales

> **Analogía:** Un dispositivo móvil es como una llave maestra que llevas siempre encima: da acceso a tu correo, datos bancarios, redes corporativas y ubicación física. Si la pierdes sin las protecciones adecuadas, quien la encuentre tiene acceso a todo.

## Técnicas de Endurecimiento para Dispositivos Móviles

**Similitudes con equipos de escritorio:**
- Parches del SO
- Contraseñas únicas y seguras
- Software de protección de puntos de conexión
- Principio de mínimo privilegio

**Diferencias exclusivas de dispositivos móviles:**
- Mayor propensión a **robo o extravío** → importancia de borrado remoto y cifrado
- Ecosistema de aplicaciones con **diversos requisitos de permisos**
- Equipados con **GPS, Bluetooth y NFC** (Near Field Communication — Comunicación de Campo Cercano) → vías adicionales de ataque

### Modelos de Implementación

Los **modelos de despliegue de dispositivos móviles** definen cómo una organización utiliza, administra y protege dichos dispositivos:

| Modelo | Nombre completo | Propietario del dispositivo | Uso | Control organizacional | Riesgo de seguridad |
|---|---|---|---|---|---|
| **BYOD** | Bring Your Own Device (Trae tu propio dispositivo) | Empleado | Personal + corporativo | Limitado | Alto (mezcla de datos) |
| **COBO** | Corporate Owned, Business Only (Propiedad corporativa, solo negocios) | Empresa | Solo corporativo | Total | Muy bajo |
| **COPE** | Corporate Owned, Personally Enabled (Propiedad corporativa, habilitado para uso personal) | Empresa | Corporativo + personal limitado | Alto | Bajo-medio |
| **CYOD** | Choose Your Own Device (Elige tu propio dispositivo) | Empresa | Similar a COPE | Alto | Bajo-medio |

**Comparación BYOD vs. COPE:**
- **BYOD:** Más flexible, menores costos de equipamiento, mayor riesgo de seguridad
- **COPE:** Mayor control organizacional, mejor seguridad, mayor inversión en equipos

### Administración de Dispositivos Móviles (MDM)

**MDM** (Mobile Device Management — Administración de Dispositivos Móviles):

**Por qué es crítica:**
- El aumento del trabajo remoto y las políticas **BYOD** incrementaron su importancia
- Permite a los departamentos de TI mantener un **inventario de todos los dispositivos móviles**
- Garantiza que solo los dispositivos autorizados conserven acceso a recursos corporativos

**Funcionalidades clave:**

| Funcionalidad | Descripción |
|---|---|
| **Inventario de dispositivos** | Registro de todos los dispositivos que acceden a recursos corporativos |
| **Aplicación de políticas** | Cifrado de dispositivos, obligatoriedad de bloqueos de pantalla |
| **Bloqueo/borrado remoto** | Protege datos confidenciales en caso de robo o extravío |
| **Aplicación de endurecimiento** | Desactivar funciones/servicios innecesarios, restringir instalaciones de apps |
| **Gestión de parches** | Actualizar dispositivos contra vulnerabilidades conocidas |
| **Cuarentena** | Aislar dispositivos que no cumplan requisitos de seguridad |
| **Distribución de apps empresariales** | Despliegue y actualización centralizada de aplicaciones |
| **Gestión de correo corporativo** | Control de cuentas de correo electrónico corporativo |
| **Geolocalización y geofencing** | Seguimiento de dispositivos y aplicación de políticas basadas en ubicación |
| **Listas de apps permitidas/bloqueadas** | Control sobre qué aplicaciones pueden instalarse |
| **Control de acceso a Internet** | Gestión del uso de Internet en dispositivos corporativos |

**Soluciones MDM populares:**
- Apple MDM (integrada en SO de Apple: Macs, iPhones, iPads)
- **Android Enterprise** (solución de Google para dispositivos Android)
- **Microsoft Intune** (agnóstica de plataforma)
- **VMware AirWatch** (agnóstica de plataforma)
- **IBM MaaS360** (agnóstica de plataforma)

> **Analogía:** MDM es como el panel de control central de un sistema de seguridad para todos los dispositivos de una empresa. Desde un solo punto puedes ver, configurar, bloquear o borrar remotamente cualquier dispositivo.

> **👉 Enfoque de Examen SY0-701:** En escenarios de examen, cuando la pregunta mencione "aplicar políticas de seguridad a todos los dispositivos móviles de la empresa" → MDM. Cuando mencione "un empleado usa su propio teléfono para acceder a email corporativo" → BYOD. Distractor crítico: confundir COPE con BYOD. En COPE, la empresa es propietaria del dispositivo; en BYOD, el empleado lo es. MDM es compatible con TODOS los modelos (BYOD, COPE, COBO, CYOD).

## Cifrado Completo del Dispositivo y Medios Externos

Todas las versiones modernas de SO móvil ofrecen cifrado del dispositivo completo (excepto las primeras versiones).

**En iOS — Dos niveles de cifrado:**

| Nivel | Descripción |
|---|---|
| **Nivel 1** | Todos los datos del usuario siempre cifrados con clave almacenada en el dispositivo. Se usa principalmente para el borrado rápido del dispositivo (eliminar la clave) |
| **Nivel 2** (Protección de datos) | Datos de correo electrónico y apps que usan "Protección de datos" se cifran con clave derivada de la credencial del usuario. Proporciona protección real ante robo |

- El cifrado de Protección de datos se activa automáticamente al configurar un **bloqueo con contraseña**
- NO todos los datos se cifran con Protección de datos: contactos, mensajes SMS y fotos NO lo están

**En Android:**
- Existen diferencias sustanciales entre versiones
- A partir de **Android 10:** No existe cifrado de disco completo (demasiado perjudicial para el rendimiento)
- Los datos del usuario se cifran a **nivel de archivo** de forma predeterminada

**Almacenamiento extraíble:**
- Algunos teléfonos Android admiten almacenamiento extraíble (ranura **Micro SD**)
- También pueden conectar dispositivos de almacenamiento **USB**
- El SO móvil puede permitir el cifrado del almacenamiento extraíble (no siempre habilitado por defecto)
- Se debe aplicar cifrado a las tarjetas de almacenamiento y restringir el almacenamiento de datos sensibles en ellas

**HSM MicroSD** (Hardware Security Module — Módulo de Seguridad de Hardware):
- Factor de forma pequeño diseñado para almacenar claves criptográficas de forma segura
- Permite utilizar el material criptográfico con diferentes dispositivos (portátil y teléfono)

> **Analogía:** El cifrado completo del dispositivo móvil es como tener una caja fuerte dentro de tu bolsillo. Aunque alguien te robe el teléfono, sin el código de desbloqueo, los datos son inaccesibles.

> **👉 Enfoque de Examen SY0-701:** Puntos clave para el examen: (1) iOS nivel 2 = "Data Protection" = requiere contraseña de usuario. (2) Android 10+ = cifrado a nivel de archivo, NO disco completo. (3) HSM MicroSD almacena claves criptográficas para uso en múltiples dispositivos. Distractor: "el cifrado de iOS protege todos los datos automáticamente" → FALSO, algunos datos (contactos, SMS, fotos) no están bajo Data Protection.

## Servicios de Ubicación

La **geolocalización** es el uso de atributos de red para identificar (o estimar) la posición física de un dispositivo.

**Dos sistemas de ubicación:**

| Sistema | Descripción |
|---|---|
| **GPS** (Global Positioning System — Sistema de Posicionamiento Global) | Determina latitud/longitud mediante señales de satélites GPS |
| **IPS** (Indoor Positioning System — Sistema de Posicionamiento Interior) | Triangulación de proximidad a torres celulares, puntos de acceso Wi-Fi y balizas Bluetooth o RFID |

**Preocupaciones de privacidad:**
- Los servicios de ubicación son un mecanismo para **rastrear movimientos de un individuo**
- Seguimiento de hábitos sociales y comerciales
- Las apps móviles solicitan acceso a servicios de ubicación → envían la información a los desarrolladores
- Si un atacante accede a estos datos: **acoso, ingeniería social, robo de identidad**

### Geovallado (Geofencing) y Aplicación de Normativas para Cámara y Micrófono

**Geofencing** (Geovallado):
- Creación de un **límite virtual** basado en la geografía del mundo real
- **Casos de uso:**
  - Control del uso de cámara o video
  - Aplicación de autenticación basada en contexto
  - Al entrar/salir de un perímetro, el dispositivo puede bloquearse/desbloquearse o requerir nueva autenticación
  - La cámara y micrófono pueden desactivarse automáticamente dentro del perímetro de la empresa

**Ejemplo práctico con Microsoft Intune:**
- Se puede restringir la cámara, captura de pantalla y otros permisos del dispositivo mediante perfiles de configuración MDM

### Etiquetado GPS (GPS Tagging)

El **etiquetado GPS** (GPS tagging / geotagging):
- Proceso de agregar **metadatos de identificación geográfica** (latitud y longitud) a medios como fotografías, mensajes SMS, videos
- El etiquetado GPS es **información personal altamente confidencial**
- Las imágenes etiquetadas con GPS en redes sociales pueden usarse para rastrear movimientos y ubicación

**Ejemplo real de riesgo:** Un soldado ruso reveló las posiciones de las tropas al subir selfies etiquetadas con GPS en Instagram.

**Buenas prácticas:**
- Desactivar el etiquetado GPS en la cámara del dispositivo
- Revisar los permisos de ubicación de cada aplicación
- Usar MDM para controlar el acceso a la geolocalización en dispositivos corporativos

> **👉 Enfoque de Examen SY0-701:** Preguntas sobre geofencing suelen presentar escenarios donde la empresa quiere "controlar el uso de la cámara dentro de las instalaciones". La respuesta es geofencing + MDM. Distractor: confundir GPS (satélites) con IPS (triangulación Wi-Fi/Bluetooth/celdas). GPS funciona en exteriores; IPS en interiores.

## Métodos de Conexión Celular y GPS

Los dispositivos móviles utilizan diversos métodos de conexión para establecer comunicaciones y acceder a Internet.

### Conexiones de Datos Celulares o Móviles

Los teléfonos, tabletas y portátiles utilizan **redes de datos móviles** para comunicación de datos.

**Riesgos de seguridad:**
- Las conexiones de datos móviles **omiten efectivamente** las protecciones de red implementadas en el entorno empresarial
- La comunicación de datos móviles es difícilmente sujeta a seguimiento y filtrado

**Tecnologías de protección para conexiones celulares:**

| Tecnología | Función |
|---|---|
| Concientización y capacitación | Educar a los usuarios sobre riesgos |
| **VPN** | Tunelar el tráfico de forma segura |
| **MDM** | Aplicar políticas de seguridad |
| **Defensa contra amenazas móviles** | Detectar amenazas específicas de dispositivos móviles |
| **DLP** (Data Loss Prevention — Prevención de Pérdida de Datos) | Prevenir la exfiltración de datos sensibles |

### Sistema de Posicionamiento Global (GPS)

Un sensor **GPS** triangula la posición del dispositivo mediante señales de satélites GPS orbitales.

**GPS Asistido (A-GPS):**
- La mayoría de teléfonos usan **A-GPS** para obtener coordenadas de la torre celular más cercana
- Ajusta la posición del dispositivo en relación con la torre
- Un GPS asistido utiliza **datos celulares**

**Constelaciones de satélites:**
- Satélites GPS: operados por el **gobierno de los Estados Unidos**
- **Galileo**: operado por la Unión Europea
- **GLONASS**: operado por Rusia
- **BeiDou**: operado por China

**Riesgo de seguridad:**
- Las señales GPS pueden ser **interferidas o falsificadas** (spoofed) a través de equipos de radio especializados
- Podría usarse para evadir mecanismos de **geofencing**

> **👉 Enfoque de Examen SY0-701:** Recuerda: A-GPS usa datos celulares para acelerar la localización GPS. La falsificación de GPS (GPS spoofing) puede evadir controles de geofencing. DLP en el contexto móvil → previene exfiltración de datos corporativos a través de conexiones celulares/Wi-Fi no supervisadas.

## Métodos de Conexión Wi-Fi y Tethering (Anclaje de Red)

**Riesgos del Wi-Fi en dispositivos móviles:**
- Los riesgos surgen cuando los usuarios se conectan a **puntos de acceso abiertos** o **fraudulentos** (que imitan redes corporativas)
- Un atacante puede comprometer sesiones con servidores seguros mediante ataques de **suplantación de DNS**
- Los puntos de acceso maliciosos permiten lanzar una gran variedad de ataques

### Redes de Área Personal (PAN)

**PAN** (Personal Area Network — Red de Área Personal):
- Habilita la conectividad entre un dispositivo móvil y periféricos
- También permite redes **ad hoc** (punto a punto) entre dispositivos móviles

**Riesgo corporativo:**
- En términos de seguridad corporativa, las funciones punto a punto **deben desactivarse**
- Un atacante podría aprovechar un dispositivo mal configurado para obtener acceso a la red corporativa mediante una **conexión en modo puente**

### Wi-Fi Ad Hoc y Wi-Fi Direct

**Redes ad hoc:**
- Las estaciones inalámbricas pueden establecer conexiones punto a punto entre sí (sin punto de acceso)
- La red no está disponible de forma permanente
- Sin respaldo estándar establecido basado en normativas

**Wi-Fi Direct:**
- Permite conexiones uno a uno entre estaciones
- Un dispositivo actúa como punto de acceso mediante software (**SoftAP**)
- Depende del protocolo **WPS** (Wi-Fi Protected Setup — Configuración Protegida de Wi-Fi), que presenta **muchas vulnerabilidades**
- Android puede operar como punto de acceso Wi-Fi Direct
- iOS utiliza un **marco de conectividad multipunto patentado**

**Redes de malla inalámbrica:**
- Proveedores como Netgear y Google ofrecen productos de malla que permiten conectividad punto a punto
- Cada vez más compatibles con el estándar **EasyMesh** (Wi-Fi Alliance)

### Tethering y Puntos de Acceso Inalámbrico (Hotspot)

**Tethering** (Anclaje de red):
- Un teléfono inteligente comparte su conexión a Internet con otros dispositivos

| Modalidad | Descripción |
|---|---|
| **Punto de acceso inalámbrico** (Hotspot) | El teléfono comparte la conexión con varios dispositivos a través de Wi-Fi |
| **Tethering** (estricto) | Conexión compartida a una sola PC a través de cable USB o Bluetooth |

**Riesgo corporativo:**
- Esta funcionalidad **debe desactivarse** cuando el dispositivo está conectado a una red empresarial
- Podría usarse para eludir mecanismos de seguridad como:
  - **DLP** (Prevención de Pérdida de Datos)
  - Políticas de filtrado de contenido web

> **👉 Enfoque de Examen SY0-701:** Vigilar la diferencia entre hotspot (comparte con varios vía Wi-Fi) y tethering (comparte con uno vía USB/Bluetooth). WPS es siempre vulnerable → desactivar en entornos corporativos. Wi-Fi Direct depende de WPS → también un riesgo. Las redes ad hoc en entornos corporativos son siempre un riesgo de seguridad porque pueden crear puentes no autorizados a la red corporativa.

## Métodos de Conexión Bluetooth

**Bluetooth** es una tecnología inalámbrica basada en radio diseñada para implementar redes de área personal de corto alcance.

### Problemas de Seguridad de Bluetooth

| Problema | Descripción |
|---|---|
| **Detección de dispositivos** | Un dispositivo en modo de descubrimiento se conectará a cualquier Bluetooth cercano. Incluso en modo no detectable puede detectarse en algunas circunstancias |
| **Autenticación y autorización** | Los dispositivos se autentican ("emparejan") con una clave de acceso. Nunca dejar el PIN predeterminado como "0000". Revisar regularmente la lista de emparejamiento |
| **Malware** | Existen gusanos Bluetooth de prueba de concepto. El exploit **BlueBorne** compromete cualquier sistema activo y sin parches, **sin importar si el modo de descubrimiento está activado** y sin ninguna intervención del usuario |

### Ataques Bluetooth Específicos

| Ataque | Descripción |
|---|---|
| **Bluejacking** | Envío de mensajes no solicitados (spam): textos, imágenes, videos, vCards. Puede ser vector de distribución de malware |
| **Bluesnarfing** | Uso de exploit en Bluetooth para **robar información** de un teléfono ajeno. Elude el mecanismo de autenticación. Un PIN corto (4 dígitos) es vulnerable a fuerza bruta |
| **BlueBorne** | Exploit que compromete dispositivos activos sin parches sin necesidad de descubrimiento ni intervención del usuario |

**Riesgos adicionales:**
- Dispositivos periféricos con **firmware malicioso** pueden lanzar ataques altamente efectivos
- Probabilidad baja pero impacto muy alto

**Recomendaciones:**
- Desactivar Bluetooth completamente a través de la **configuración del dispositivo** (no solo desde el centro de control, ya que podría no desactivar realmente el radio)
- Mantener dispositivos actualizados con el **firmware más reciente**
- Revisar regularmente la lista de dispositivos emparejados

### Características de Seguridad de Bluetooth

| Característica | Descripción |
|---|---|
| **Emparejamiento y autenticación** | Intercambio de claves criptográficas durante el emparejamiento. Métodos: comparación numérica, entrada de contraseña, autenticación fuera de banda (**OOB** — Out Of Band) |
| **Permisos de Bluetooth** | Requiere consentimiento/permiso del usuario para conectarse y acceder a servicios. Los usuarios pueden controlar qué dispositivos se conectan |
| **Cifrado** | Emplea algoritmos de cifrado para proteger datos transmitidos entre dispositivos. Tras el emparejamiento, se usa una **clave secreta compartida** para cifrar paquetes de datos |
| **BSC** (Bluetooth Secure Connections — Conexiones Seguras de Bluetooth) | Introducido en Bluetooth 4.0. Mayor resistencia contra ataques de espionaje, en ruta y acceso no autorizado |
| **Privacidad BLE** (Bluetooth Low Energy — Bluetooth de Baja Energía) | BLE usa **direcciones de dispositivos generadas aleatoriamente** que cambian con frecuencia para evitar el seguimiento y la identificación no autorizada |

> **👉 Enfoque de Examen SY0-701:** Los tres ataques Bluetooth más importantes para el examen son: Bluejacking (mensajes no solicitados), Bluesnarfing (robo de datos) y BlueBorne (sin intervención del usuario, sin descubrimiento). Distractor clásico: confundir Bluejacking (spam/mensajes) con Bluesnarfing (robo). BlueBorne es el más peligroso porque no requiere emparejamiento ni descubrimiento. BLE ≠ Bluetooth estándar: BLE usa direcciones aleatorias rotativas para privacidad. BSC aparece en Bluetooth 4.0+.

# 3 CONCEPTOS CLAVE

| Concepto | Sigla | Significado completo | Función principal |
|---|---|---|---|
| Endpoint Detection & Response | **EDR** | Endpoint Detection and Response | Visibilidad y respuesta en tiempo real sobre endpoints |
| Extended Detection and Response | **XDR** | Extended Detection and Response | EDR + red + nube + correo + cortafuegos |
| Managed Detection and Response | **MDR** | Managed Detection and Response | Servicio de seguridad hospedado |
| Host-based IDS | **HIDS** | Host-based Intrusion Detection System | Detecta y alerta (no bloquea) |
| Host-based IPS | **HIPS** | Host-based Intrusion Prevention System | Detecta y bloquea activamente |
| File Integrity Monitoring | **FIM** | File Integrity Monitoring | Audita archivos del sistema contra versiones autorizadas |
| User Behavior Analytics | **UBA/UEBA** | User (and Entity) Behavior Analytics | Detecta anomalías en comportamiento de usuarios |
| Full Disk Encryption | **FDE** | Full Disk Encryption | Cifra todo el contenido del disco |
| Self-Encrypting Drive | **SED** | Self-Encrypting Drive | FDE realizado por el controlador del disco |
| Trusted Platform Module | **TPM** | Trusted Platform Module | Chip para almacenamiento seguro de claves de cifrado |
| Key Encryption Key | **KEK** | Key Encryption Key | Cifra la DEK en unidades SED |
| Data Encryption Key | **DEK** | Data Encryption Key | Clave simétrica que cifra los datos en SED |
| Principle of Least Privilege | **PoLP** | Principle of Least Privilege | Acceso mínimo necesario para cada rol |
| Role-Based Access Control | **RBAC** | Role-Based Access Control | Asigna derechos en función de roles predefinidos |
| Access Control List | **ACL** | Access Control List | Lista de reglas de acceso a recursos |
| Access Control Entry | **ACE** | Access Control Entry | Entrada individual dentro de una ACL |
| Group Policy Object | **GPO** | Group Policy Object | Configuraciones de seguridad centralizadas en Windows/AD |
| Security Information & Event Mgmt | **SIEM** | Security Information and Event Management | Correlación y análisis de eventos de seguridad |
| Mobile Device Management | **MDM** | Mobile Device Management | Gestión centralizada de dispositivos móviles |
| Bring Your Own Device | **BYOD** | Bring Your Own Device | El empleado usa su propio dispositivo |
| Corporate Owned, Business Only | **COBO** | Corporate Owned, Business Only | Dispositivo de empresa, solo uso corporativo |
| Corporate Owned, Personally Enabled | **COPE** | Corporate Owned, Personally Enabled | Dispositivo de empresa con uso personal permitido |
| Choose Your Own Device | **CYOD** | Choose Your Own Device | El empleado elige de una lista de dispositivos de empresa |
| Global Positioning System | **GPS** | Global Positioning System | Posicionamiento por satélite |
| Assisted GPS | **A-GPS** | Assisted GPS | GPS mejorado con datos celulares |
| Personal Area Network | **PAN** | Personal Area Network | Red de corto alcance (Bluetooth, Wi-Fi Direct) |
| Industrial Control System | **ICS** | Industrial Control System | Sistemas de control de procesos industriales |
| Supervisory Control & Data Acq. | **SCADA** | Supervisory Control and Data Acquisition | Supervisión y control de infraestructura crítica |
| Real-Time Operating System | **RTOS** | Real-Time Operating System | SO para sistemas integrados con tiempo real |
| Data Loss Prevention | **DLP** | Data Loss Prevention | Prevención de exfiltración de datos sensibles |
| Pretty Good Privacy | **PGP** | Pretty Good Privacy | Cifrado de correo electrónico |
| Secure/Multipurpose Internet Mail Extensions | **S/MIME** | Secure/Multipurpose Internet Mail Extensions | Cifrado de correo con certificados X.509 |
| Near Field Communication | **NFC** | Near Field Communication | Comunicación inalámbrica de muy corto alcance |
| Hardware Security Module | **HSM** | Hardware Security Module | Dispositivo seguro para almacenar claves criptográficas |
| Bluetooth Low Energy | **BLE** | Bluetooth Low Energy | Versión eficiente energéticamente de Bluetooth con privacidad mejorada |
| Bluetooth Secure Connections | **BSC** | Bluetooth Secure Connections | Seguridad mejorada en Bluetooth 4.0+ |
| Wi-Fi Protected Setup | **WPS** | Wi-Fi Protected Setup | Protocolo de configuración Wi-Fi (con vulnerabilidades) |
| Mandatory Access Control | **MAC** | Mandatory Access Control | Control de acceso obligatorio (usado por SELinux) |

# 4 TABLA DE ATAQUES BLUETOOTH

| Ataque | Vector | ¿Requiere emparejamiento? | ¿Requiere interacción del usuario? | Impacto |
|---|---|---|---|---|
| **Bluejacking** | Bluetooth | No | No (envío) | Spam, mensajes no solicitados, posible vector de malware |
| **Bluesnarfing** | Bluetooth | No (exploit) | No | Robo de información del dispositivo |
| **BlueBorne** | Bluetooth | No | No | Compromiso completo del sistema sin importar configuración |

# 5 COMANDOS Y PROTOCOLOS CLAVE

| Comando/Protocolo/Puerto | Plataforma | Descripción |
|---|---|---|
| `chmod 755 archivo` | Linux | Establece rwxr-xr-x |
| `chmod u=rwx,g=rx,o=rx archivo` | Linux | Modo simbólico equivalente |
| `chmod g+w,o-x archivo` | Linux | Añade escritura a grupo; elimina ejecución de otros |
| `yum-cron` | Linux (RedHat/CentOS) | Actualizaciones automáticas |
| `aptunattended-upgrades` | Linux (Debian/Ubuntu) | Actualizaciones automáticas |
| `HTTPS` | Web | `puerto 443` — Protocolo web cifrado |
| `HTTP` | Web | `puerto 80` — Protocolo web sin cifrado |
| `SSH` | Red | `puerto 22` — Acceso remoto cifrado |
| `TLS` | Red | Transport Layer Security — Cifrado de transporte |
| `SNMPv3` | Gestión de red | Simple Network Management Protocol v3 (con cifrado) |
| `SNMPv1/v2` | Gestión de red | Sin cifrado — NO usar |
| `PGP` | Correo | Cifrado de correo (clave pública/privada) |
| `S/MIME` | Correo | Cifrado de correo con certificados X.509 |
