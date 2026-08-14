> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Vulnerabilidades de Dispositivos y Sistemas Operativos](#1-vulnerabilidades-de-dispositivos-y-sistemas-operativos)
  - [Vulnerabilidades del Sistema Operativo](#vulnerabilidades-del-sistema-operativo)
    - [Tabla Comparativa de SO y sus Vulnerabilidades](#tabla-comparativa-de-so-y-sus-vulnerabilidades)
    - [Casos Históricos Clave para el Examen](#casos-históricos-clave-para-el-examen)
  - [Tipos de Vulnerabilidad y Explotación](#tipos-de-vulnerabilidad-y-explotación)
    - [Sistemas Heredados y de Fin de Vida (EOL)](#sistemas-heredados-y-de-fin-de-vida-eol)
    - [Vulnerabilidades de Firmware](#vulnerabilidades-de-firmware)
    - [Vulnerabilidades de Virtualización](#vulnerabilidades-de-virtualización)
  - [Vulnerabilidades de Día Cero](#vulnerabilidades-de-día-cero)
    - [Características Clave](#características-clave)
    - [Proceso de Divulgación Responsable](#proceso-de-divulgación-responsable)
  - [Vulnerabilidades de Configuración Errónea](#vulnerabilidades-de-configuración-errónea)
    - [Orígenes Comunes](#orígenes-comunes)
    - [Principios para Mitigar Configuraciones Erróneas](#principios-para-mitigar-configuraciones-erróneas)
  - [Vulnerabilidades Criptográficas](#vulnerabilidades-criptográficas)
    - [Algoritmos Débiles y Ataques](#algoritmos-débiles-y-ataques)
    - [Ataques Conocidos a Protocolos Criptográficos](#ataques-conocidos-a-protocolos-criptográficos)
    - [SSL/TLS — Usos](#ssltls--usos)
    - [Protección de Claves Criptográficas](#protección-de-claves-criptográficas)
  - [Instalación Lateral, Rooting y Jailbreaking](#instalación-lateral-rooting-y-jailbreaking)
    - [Definiciones](#definiciones)
    - [Riesgos para las Organizaciones](#riesgos-para-las-organizaciones)
    - [Herramientas y Términos Relacionados](#herramientas-y-términos-relacionados)
    - [Marco Regulatorio](#marco-regulatorio)
    - [Permisos de Aplicaciones](#permisos-de-aplicaciones)
- [2. Vulnerabilidades de Aplicaciones y de la Nube](#2-vulnerabilidades-de-aplicaciones-y-de-la-nube)
  - [Vulnerabilidades de Aplicación](#vulnerabilidades-de-aplicación)
    - [Condición de Carrera y TOCTOU](#condición-de-carrera-y-toctou)
    - [Inyección de Memoria](#inyección-de-memoria)
    - [Buffer Overflow (Desbordamiento de Búfer)](#buffer-overflow-desbordamiento-de-búfer)
    - [Actualización Maliciosa (Malicious Update)](#actualización-maliciosa-malicious-update)
  - [Alcance de la Evaluación](#alcance-de-la-evaluación)
    - [Prácticas del Alcance de Evaluación](#prácticas-del-alcance-de-evaluación)
    - [Pentester vs. Atacante](#pentester-vs-atacante)
  - [Ataques a las Aplicaciones Web](#ataques-a-las-aplicaciones-web)
    - [XSS — Cross-Site Scripting (Secuencias de Comandos en Sitios Cruzados)](#xss--cross-site-scripting-secuencias-de-comandos-en-sitios-cruzados)
    - [SQLi — SQL Injection (Inyección de Código SQL)](#sqli--sql-injection-inyección-de-código-sql)
  - [Ataques a las Aplicaciones con Base en la Nube](#ataques-a-las-aplicaciones-con-base-en-la-nube)
    - [Características Únicas de Ataques en la Nube](#características-únicas-de-ataques-en-la-nube)
    - [Tipos de Ataques Específicos de la Nube](#tipos-de-ataques-específicos-de-la-nube)
    - [CASB — Cloud Access Security Broker](#casb--cloud-access-security-broker)
  - [Cadena de Suministro](#cadena-de-suministro)
    - [Tipos de Proveedores y sus Riesgos](#tipos-de-proveedores-y-sus-riesgos)
    - [SBOM — Software Bill of Materials (Lista de Materiales del Software)](#sbom--software-bill-of-materials-lista-de-materiales-del-software)
    - [Herramientas y Estándares SBOM](#herramientas-y-estándares-sbom)
- [3. Métodos de Identificación de Vulnerabilidades](#3-métodos-de-identificación-de-vulnerabilidades)
  - [Escaneo de Vulnerabilidades](#escaneo-de-vulnerabilidades)
    - [Herramientas de Escaneo de Red](#herramientas-de-escaneo-de-red)
    - [Escaneos Con y Sin Credenciales](#escaneos-con-y-sin-credenciales)
    - [Escaneo de Vulnerabilidades de Aplicaciones](#escaneo-de-vulnerabilidades-de-aplicaciones)
    - [Monitoreo de Paquetes (Package Monitoring)](#monitoreo-de-paquetes-package-monitoring)
  - [Fuentes de Amenazas (Threat Feeds)](#fuentes-de-amenazas-threat-feeds)
    - [Tipos de Investigación de Amenazas](#tipos-de-investigación-de-amenazas)
    - [CTI — Cyber Threat Intelligence](#cti--cyber-threat-intelligence)
    - [Plataformas de Threat Intelligence (Propietarias)](#plataformas-de-threat-intelligence-propietarias)
    - [Fuentes de Código Abierto vs. Propietarias](#fuentes-de-código-abierto-vs-propietarias)
    - [Organizaciones de Intercambio de Información](#organizaciones-de-intercambio-de-información)
    - [OSINT — Open Source Intelligence (Inteligencia de Fuentes Abiertas)](#osint--open-source-intelligence-inteligencia-de-fuentes-abiertas)
  - [Deep y Dark Web](#deep-y-dark-web)
    - [Capas de la Web](#capas-de-la-web)
    - [TOR — The Onion Router](#tor--the-onion-router)
    - [Usos de la Dark Web](#usos-de-la-dark-web)
  - [Otros Métodos de Evaluación de Vulnerabilidades](#otros-métodos-de-evaluación-de-vulnerabilidades)
    - [Pentest (Prueba de Penetración)](#pentest-prueba-de-penetración)
    - [Tipos de Pentest por Conocimiento del Entorno](#tipos-de-pentest-por-conocimiento-del-entorno)
    - [Bug Bounty (Recompensas por Detección de Errores)](#bug-bounty-recompensas-por-detección-de-errores)
    - [Auditoría](#auditoría)
- [4. Análisis y Corrección de Vulnerabilidades](#4-análisis-y-corrección-de-vulnerabilidades)
  - [Vulnerabilidades y Exposiciones Comunes (CVE, NVD, CVSS, SCAP)](#vulnerabilidades-y-exposiciones-comunes-cve-nvd-cvss-scap)
    - [Fuente de Vulnerabilidades (Vulnerability Feed)](#fuente-de-vulnerabilidades-vulnerability-feed)
    - [CVE — Common Vulnerabilities and Exposures](#cve--common-vulnerabilities-and-exposures)
    - [NVD — National Vulnerability Database](#nvd--national-vulnerability-database)
    - [CVSS — Common Vulnerability Scoring System](#cvss--common-vulnerability-scoring-system)
    - [SCAP — Security Content Automation Protocol](#scap--security-content-automation-protocol)
  - [Falsos Positivos, Falsos Negativos y Revisión de Registros](#falsos-positivos-falsos-negativos-y-revisión-de-registros)
    - [Informes de Escaneo](#informes-de-escaneo)
    - [Falsos Positivos y Falsos Negativos](#falsos-positivos-y-falsos-negativos)
    - [Revisión de Registros para Validación](#revisión-de-registros-para-validación)
  - [Análisis de Vulnerabilidades](#análisis-de-vulnerabilidades)
    - [Dimensiones del Análisis](#dimensiones-del-análisis)
    - [Variables Ambientales en el Análisis](#variables-ambientales-en-el-análisis)
    - [Tolerancia al Riesgo (Risk Tolerance)](#tolerancia-al-riesgo-risk-tolerance)
  - [Respuesta y Corrección de Vulnerabilidades](#respuesta-y-corrección-de-vulnerabilidades)
    - [Prácticas de Corrección (Remediation)](#prácticas-de-corrección-remediation)
    - [Validación de la Corrección](#validación-de-la-corrección)
    - [Informes de Vulnerabilidades](#informes-de-vulnerabilidades)
- [5. Glosario](#5-glosario)

---

# 1. Vulnerabilidades de Dispositivos y Sistemas Operativos

## Vulnerabilidades del Sistema Operativo

> Los SO (Sistemas Operativos) son la capa más crítica de la infraestructura. Son los objetivos preferidos de los atacantes.

### Tabla Comparativa de SO y sus Vulnerabilidades

| SO | Perfil de Riesgo | Vulnerabilidades Comunes | Caso Histórico Clave |
|---|---|---|---|
| **Windows** | Altísimo (base usuarios masiva, gobiernos, corporaciones) | Desbordamientos de búfer, validación de entradas, escalación de privilegios | `MS08-067` (Conficker, 2008), `MS17-010` + EternalBlue (WannaCry, 2017) |
| **macOS** | Medio-alto (creciente popularidad) | Controles de acceso, arranque seguro, software de terceros | Shellshock (2014) — falla en shell Bash |
| **Linux** | Alto (infraestructura cloud/servidores) | Vulnerabilidades del kernel, configuraciones erróneas, sistemas sin parches | Heartbleed (2014) — librería `OpenSSL` |
| **Android** | Alto (código abierto, fragmentación de versiones) | Parches inconsistentes entre fabricantes, apps maliciosas | Stagefright (2015) — biblioteca de medios |
| **iOS** | Medio (no open source) | Vulnerabilidades en kernel, ataques "watering hole" | Project Zero de Google (2019) — ataques de estado-nación |
| **IoT** | Muy alto (SO especializados, difícil actualización) | Firmware sin parches, credenciales por defecto | — |

### Casos Históricos Clave para el Examen

- **`MS17-010`** → parche de Microsoft para el protocolo `SMB` (Server Message Block — protocolo de intercambio de archivos de red) → explotado por **EternalBlue** → base de **WannaCry** (ransomware, mayo 2017)
- **Heartbleed** → falla en `OpenSSL` en Linux → permitía leer memoria de sistemas → comprometía claves secretas
- **Shellshock** → falla en el shell `Bash` en sistemas Unix/macOS (2014) → control total del sistema
- **Stagefright** → librería de medios en Android → RCE (Remote Code Execution — Ejecución Remota de Código) vía MMS malicioso

> **👉 Enfoque de Examen SY0-701:**
> CompTIA pregunta relacionando **el nombre del exploit/vulnerabilidad con el sistema operativo afectado**. Memoriza los 5 casos históricos. Distractor común: atribuir WannaCry a Linux o Heartbleed a Windows. Vigilar que `MS17-010` = `SMB` = EternalBlue = WannaCry (cadena completa). También puede preguntar por "fragmentación" como riesgo específico de **Android**.

## Tipos de Vulnerabilidad y Explotación

### Sistemas Heredados y de Fin de Vida (EOL)

> **Analogía:** Un auto sin soporte del fabricante. Ya no te envían actualizaciones de seguridad del motor, pero tú sigues usándolo. Si descubren un defecto de fábrica, nunca lo arreglarán.

| Concepto | Descripción | Diferencia Clave |
|---|---|---|
| **EOL** (End of Life — Fin de Vida) | El fabricante declaró públicamente que NO dará más soporte ni parches | Sin soporte del proveedor |
| **Sistema Heredado** (Legacy) | Tecnología obsoleta que sigue en uso por costo/complejidad del reemplazo | Puede o no tener soporte del proveedor |

- **Ejemplos EOL:** Windows 7 y Windows Server 2008 → sin actualizaciones desde enero 2020
- **Riesgo principal:** Sin parches de seguridad para nuevas vulnerabilidades descubiertas
- **Hardware de segunda mano/recertificado:** Puede contener vulnerabilidades conocidas en firmware o drivers sin posibilidad de soporte
- **Criterios para reemplazar EOL:**
  - Disponibilidad de soporte del proveedor
  - Compatibilidad con infraestructura existente
  - Garantía y rendimiento en el mercado
  - Costos de transición (licencias, hardware, implementación)

### Vulnerabilidades de Firmware

**Firmware:** software fundamental que controla el hardware directamente.

- **Meltdown y Spectre** (2018) → vulnerabilidades en **procesadores** → permitían robo de datos en procesamiento → afectaron casi todas las computadoras y dispositivos móviles
- **LoJax** (2018) → malware en **firmware UEFI** (Unified Extensible Firmware Interface — Interfaz de Firmware Extensible Unificada) → persistía **incluso tras reemplazar el disco duro o reinstalar el SO**
- **Riesgo EOL de hardware:** Fabricantes que dejan de proveer actualizaciones de firmware crean vectores permanentes

### Vulnerabilidades de Virtualización

> **Analogía:** Un edificio de apartamentos. Si alguien escapa de su apartamento (VM), puede acceder a los otros pisos (otras VMs o el edificio mismo/host).

| Tipo de Vulnerabilidad | Descripción | Ejemplo |
|---|---|---|
| **Escape de VM** | Un atacante sale del entorno aislado de la VM y accede al host u otras VMs | Cloudburst (`CVE-2009-1244`) en VMware ESX Server |
| **Reutilización de recursos** | Datos residuales en disco/memoria asignados a nueva VM sin sanitizar previamente | Una nueva VM lee datos de la VM anterior |
| **Vulnerabilidades de hipervisor** | Fallos en el software de gestión de VMs (hipervisor) | Interfaces de administración con autenticación débil |

**Mitigaciones de virtualización:**
- Sanitización exhaustiva de datos entre usos
- Cifrado de datos durante todo el ciclo de vida
- Gestión robusta de claves de cifrado
- Segregación de recursos por niveles de seguridad
- Parcheo regular del hipervisor

> **👉 Enfoque de Examen SY0-701:**
> "VM escape" y "reutilización de recursos" son los dos vectores de virtualización más preguntados. Distingue EOL (sin soporte) vs Legacy (obsoleto pero puede tener soporte). El examen puede describir LoJax para preguntar qué tipo de vulnerabilidad representa → respuesta: **firmware/UEFI**. Spectre/Meltdown = vulnerabilidades de **hardware/procesador**, no de SO.

## Vulnerabilidades de Día Cero

> **Analogía:** Una grieta en el muro de tu fortaleza que NADIE ha descubierto todavía — ni tú ni el atacante público. Cuando el atacante la encuentra primero, tienes "cero días" para repararla antes de que te ataque.

**Vulnerabilidad de Día Cero** (Zero-Day): falla de software/hardware **previamente desconocida** que puede ser explotada antes de que el desarrollador o proveedor la conozca o la haya parcheado.

### Características Clave

- **Cero días** = los desarrolladores tienen 0 días para corregirlo al momento del descubrimiento
- **Sigilosas:** Las defensas basadas en firmas (antivirus, firewalls tradicionales) son **ineficaces** porque no existe firma conocida
- **Alto valor:** Un exploit zero-day para SO móvil puede valer **millones de dólares**
- **Actores que las usan:** Crimen organizado, atacantes de estado-nación, agencias de seguridad gubernamentales
- **Objetivos preferidos:** Instituciones gubernamentales y grandes corporaciones (alto valor)
- Las agencias de seguridad y fuerzas del orden pueden **almacenar zero-days** para investigaciones

### Proceso de Divulgación Responsable

```
Investigador descubre zero-day
↓
Notificación PRIVADA al proveedor
↓
Proveedor desarrolla parche
↓
Divulgación PÚBLICA de la vulnerabilidad
```

> **Divulgación responsable:** práctica de informar privadamente al proveedor para que desarrolle un parche ANTES de hacer pública la vulnerabilidad.

> **👉 Enfoque de Examen SY0-701:**
> La pregunta clave es "¿por qué las defensas tradicionales fallan contra zero-days?" → porque se basan en **firmas conocidas**. Otro escenario: "¿qué tipo de actores usan zero-days?" → actores avanzados (APT — Advanced Persistent Threat), estado-nación. Distingue zero-day *vulnerabilidad* vs zero-day *exploit* (código que la aprovecha) vs zero-day *ataque* (el ataque que usa el exploit).

## Vulnerabilidades de Configuración Errónea

> **Analogía:** Dejar la puerta principal de tu casa abierta porque así venía de fábrica. No hubo un "hackeo" — simplemente nadie la cerró.

**Configuración errónea** (Misconfiguration): ajuste incorrecto de sistemas, redes o aplicaciones que genera vulnerabilidades de seguridad.

### Orígenes Comunes

| Origen | Ejemplo |
|---|---|
| **Configuraciones predeterminadas** | Usuario: `admin` / Contraseña: `admin`; servicios innecesarios habilitados |
| **Servicios en la nube** | Buckets de almacenamiento accesibles públicamente por defecto |
| **Dispositivos de red** | Routers/switches con credenciales predeterminadas documentadas públicamente |
| **Resolución de incidentes urgentes** | Técnico desactiva temporalmente seguridad para aislar problema y no la reactiva |
| **Permisos excesivos** | Configuraciones que priorizan facilidad de uso sobre seguridad |

### Principios para Mitigar Configuraciones Erróneas

- Aplicar el **principio de mínimo privilegio** (Least Privilege)
- Cambiar **siempre** las credenciales predeterminadas
- Auditar regularmente las configuraciones
- Implementar procesos de **gestión de cambios** (documentación, pruebas, aprobación)
- Revertir cambios temporales realizados durante troubleshooting

> **👉 Enfoque de Examen SY0-701:**
> CompTIA presenta escenarios donde un técnico hace un cambio "temporal" que queda permanente. La respuesta correcta siempre incluye **gestión de cambios** y **auditorías de configuración**. Distractor: confundir "misconfiguration" con "vulnerability in the code" — la misconfiguration no es un bug en el software, es un error de configuración del administrador.

## Vulnerabilidades Criptográficas

> **Analogía:** Si tienes la caja fuerte más robusta del mundo pero usas una llave débil o la guardas debajo del tapete, toda la seguridad de la caja es inútil.

### Algoritmos Débiles y Ataques

| Algoritmo | Problema | Estado Actual |
|---|---|---|
| `MD5` | Vulnerable a **ataques de colisión** (dos entradas diferentes producen el mismo hash) | **Inseguro** — no usar |
| `SHA-1` | Vulnerable a ataques de colisión | **Inseguro** — no usar |
| `DES` (Data Encryption Standard) | Clave de **56 bits** → vulnerable a fuerza bruta (demostrado a finales de los 90) | **Obsoleto** |
| `3DES` (Triple DES) | Vulnerable al ataque **Sweet32** (`CVE-2016-2183`) — ataque de cumpleaños | **Deprecado por NIST en 2017**, descontinuación recomendada para 2023 |
| `RSA` | Vulnerable si se usan claves cortas o generación de números aleatorios débil | Usar claves suficientemente largas |

### Ataques Conocidos a Protocolos Criptográficos

| Ataque | Protocolo Afectado | Descripción |
|---|---|---|
| **Heartbleed** | `OpenSSL` | Permitía leer memoria de sistemas, comprometiendo claves secretas |
| **KRACK** (Key Reinstallation Attacks) | `WPA2` (Wi-Fi) | Interceptar y descifrar tráfico de red confidencial |
| **BEAST** (Browser Exploit Against SSL/TLS) | `SSL/TLS` | Explota debilidades en suites de cifrado de SSL y TLS temprano |
| **POODLE** (Padding Oracle On Downgraded Legacy Encryption) | `SSL 3.0` | Explota fallas de implementación en cifrado |

### SSL/TLS — Usos

`SSL/TLS` protege:
- Sesiones de navegador web (`HTTP` → `HTTPS`)
- Correo electrónico (`SMTP`, `POP`, `IMAP`)
- Voz sobre IP (VoIP)
- Transferencias de archivos (`FTP` → `SFTP/FTPS`)
- Conexiones `VPN`
- Aplicaciones móviles con datos confidenciales

### Protección de Claves Criptográficas

**Principio de Kerckhoffs:** Un criptosistema debe ser seguro incluso si todo sobre el sistema es público, **excepto la clave**.

| Práctica | Descripción |
|---|---|
| **HSM** (Hardware Security Module — Módulo de Seguridad Hardware) | Almacenamiento físico seguro de claves criptográficas |
| **KMS** (Key Management System — Sistema de Gestión de Claves) | Sistema de software para gestión centralizada de claves |
| **Rotación de claves** (Key Rotation) | Cambio periódico de claves para mitigar riesgos de filtración y fuerza bruta |
| **Controles de acceso** | Limitar quién puede acceder a las claves |
| **Auditoría de uso de claves** | Monitoreo y registro del uso de claves |

> **👉 Enfoque de Examen SY0-701:**
> Memoriza qué algoritmo reemplazó a cuál: DES → 3DES → AES. Sweet32 afecta a 3DES específicamente. Heartbleed = OpenSSL (no es un ataque a SSL/TLS el protocolo, sino a la librería). KRACK afecta a WPA2 (Wi-Fi). El principio de Kerckhoffs puede aparecer en preguntas conceptuales sobre PKI. HSM es la respuesta correcta para "almacenamiento seguro de claves privadas".

## Instalación Lateral, Rooting y Jailbreaking

> **Analogía:** El rooting/jailbreaking es como hacerse propietario del edificio donde solo eres inquilino. Tienes más control, pero también eliminaste todas las medidas de seguridad que el propietario había instalado.

### Definiciones

| Término | Plataforma | Descripción |
|---|---|---|
| **Rooting** | Android | Obtener acceso `root` (privilegios administrativos) para modificar archivos del sistema, instalar ROMs personalizadas y acceder a funciones restringidas |
| **Jailbreaking** | iOS (iPhone/iPad) | Eliminar las limitaciones impuestas por Apple para instalar apps no autorizadas, personalizar el dispositivo y eludir restricciones |
| **Sideloading** (Instalación Lateral) | Android (APK) / iOS | Instalar apps desde fuentes distintas a las tiendas oficiales (Google Play Store / App Store) **sin pasar por los procesos de revisión y validación** |

### Riesgos para las Organizaciones

- Debilitan las medidas de seguridad del fabricante
- Facilitan la instalación de **malware** desde tiendas no verificadas
- Invalidan los **términos de licencia** → el dispositivo pierde soporte oficial → sin parches de seguridad futuros
- Aumentan la **superficie de ataque** del dispositivo
- En sectores regulados (salud, finanzas): riesgo de incumplimiento normativo

### Herramientas y Términos Relacionados

- **APK** (Android Application Package): formato de archivo de instalación de apps en Android
- **F-Droid**: catálogo de apps FOSS (Free and Open Source Software — Software Libre y de Código Abierto) para Android — ejemplo de fuente de sideloading alternativa
- **MDM** (Mobile Device Management — Gestión de Dispositivos Móviles): plataformas que pueden **detectar y restringir** rooting, jailbreaking y sideloading

### Marco Regulatorio

- **Ley de Mercados Digitales** (Digital Markets Act) de la UE y **leyes de "Right to Repair"** están cuestionando algunas restricciones de software/hardware

### Permisos de Aplicaciones

- Apps con **permisos excesivos** pueden acceder a: datos personales, datos corporativos, contactos, historial de llamadas, ubicación, identificadores del dispositivo
- Los permisos deben alinearse con el **propósito de la aplicación**

> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: "Un empleado hizo jailbreak a su iPhone corporativo. ¿Cuál es el riesgo principal?" → pérdida de las protecciones del SO del fabricante + posible instalación de malware. MDM es la herramienta de control. Sideloading en Android = archivos APK. En iOS = jailbreak requerido (violar términos de Apple). El examen puede preguntar qué herramienta detecta dispositivos con jailbreak en una red corporativa → **MDM**.

# 2. Vulnerabilidades de Aplicaciones y de la Nube

## Vulnerabilidades de Aplicación

### Condición de Carrera y TOCTOU

> **Analogía:** Dos personas intentan retirar dinero al mismo tiempo desde cajeros diferentes con la misma cuenta. Si el banco no verifica y ejecuta el descuento como una operación atómica, ambos pueden retirar la misma cantidad antes de que el saldo se actualice.

**Condición de Carrera** (Race Condition): vulnerabilidad donde el resultado depende del **orden o momento de ejecución** de operaciones concurrentes.

**TOCTOU** (Time-of-Check to Time-of-Use — Tiempo de Verificación a Tiempo de Uso): tipo específico de race condition donde el **estado del sistema cambia** entre el momento en que se verifica (check) y el momento en que se usa (use).

| Ejemplo | CVE | Descripción |
|---|---|---|
| Dirty COW | `CVE-2016-5195` | Race condition en el **kernel de Linux** → escalación de privilegios local |
| SMBv3 Elevation of Privilege | `CVE-2020-0796` | Race condition en el protocolo `SMBv3` de Microsoft → ejecución de código arbitrario |

**Mitigaciones:**
- Operaciones **atómicas** (verificación y ejecución como operación indivisible)
- Uso de **cerraduras** (locks), **semáforos** y **monitores** en aplicaciones multihilo

### Inyección de Memoria

**Inyección de Memoria** (Memory Injection): el atacante introduce código malicioso en la **memoria de proceso** de una aplicación en ejecución.

- El código inyectado se ejecuta con los **mismos privilegios** que la aplicación comprometida
- Usos: instalar malware, exfiltrar datos, crear backdoors

**Tipos de ataques de inyección de memoria:**
- Desbordamiento de búfer (Buffer Overflow)
- Vulnerabilidades de cadena de formato
- Inyección de código

**Mitigaciones:**
- Validación de entradas y salidas
- Codificación segura
- `ASLR` (Address Space Layout Randomization — Distribución Aleatoria del Espacio de Direcciones)
- `DEP` (Data Execution Prevention — Prevención de Ejecución de Datos)
- Lenguajes de programación type-safe
- Pruebas SAST (Static Application Security Testing) y DAST (Dynamic Application Security Testing)

### Buffer Overflow (Desbordamiento de Búfer)

> **Analogía:** Llenar un vaso hasta el límite y seguir echando agua. El exceso "desborda" hacia donde no debería ir — en este caso, hacia áreas de memoria críticas.

**Buffer:** área de memoria que la aplicación reserva para datos esperados.

**Mecanismo del ataque:**
```
Ejecución Normal:         Ejecución de Exploit:
Sub()                     Sub()
Sub() pila                NOP (instrucciones vacías)
Dirección de devolución   NOP
Main()              →     Código Shell (malicioso)
Pila Main()               NOP
Dirección de devolución → apunta al código shell
```

- Ataque de **desbordamiento de pila** (Stack Overflow): el atacante sobrescribe la **dirección de devolución** para ejecutar código arbitrario
- `NOP sled`: secuencia de instrucciones vacías (No Operation) para facilitar la ejecución del shellcode

**Mitigaciones:**
- `ASLR` (Address Space Layout Randomization)
- `DEP`/`NX bit` (Data Execution Prevention / No-Execute)
- Lenguajes de programación con gestión automática de memoria (type-safe)
- Prácticas de codificación segura con validación de límites

### Actualización Maliciosa (Malicious Update)

> **Analogía:** Un ladrón que se disfraza de técnico de la compañía de alarmas para acceder a tu casa y desactivar la seguridad desde dentro.

**Actualización maliciosa:** actualización que aparenta ser legítima pero contiene **código dañino**.

| Caso Real | Año | Descripción |
|---|---|---|
| **CCleaner** | 2017 | Actualización no autorizada del software legítimo CCleaner contenía payload malicioso → millones de usuarios afectados |
| **SolarWinds** | 2020 | Actualización de SolarWinds Orion comprometida → distribución de backdoor malicioso → redes gubernamentales y corporativas afectadas |

**Mitigaciones:**
- Gestión segura de la **cadena de suministro de software**
- Verificación de **firmas digitales** en actualizaciones
- Gestión de actualizaciones centralizada y controlada

> **👉 Enfoque de Examen SY0-701:**
> TOCTOU es la subcategoría de race condition más preguntada. Buffer overflow → la respuesta de mitigación más importante es ASLR y DEP. El examen puede presentar un escenario de "un atacante sobrescribe la dirección de retorno" → identifica como **stack buffer overflow**. SolarWinds es el caso de supply chain attack más citado → puede aparecer en preguntas sobre cadena de suministro. La diferencia entre XSS, SQLi y buffer overflow: los primeros dos son ataques de inyección en apps web; el último es una vulnerabilidad de gestión de memoria.

## Alcance de la Evaluación

**Alcance** (Scope): el producto, sistema o servicio específico que se analiza en busca de vulnerabilidades.

### Prácticas del Alcance de Evaluación

| Práctica | Descripción |
|---|---|
| **Pruebas de seguridad** | Evaluaciones de vulnerabilidades y pentests para identificar debilidades |
| **Revisión de documentación** | Revisión de especificaciones de diseño, diagramas de arquitectura, políticas de seguridad |
| **Análisis del código fuente** | Identificar vulnerabilidades de seguridad o errores de codificación |
| **Evaluación de configuración** | Verificar alineación con mejores prácticas (controles de acceso, cifrado, autenticación) |
| **Análisis criptográfico** | Evaluar algoritmos de cifrado, gestión de claves, almacenamiento seguro |
| **Verificación de cumplimiento** | Verificar conformidad con regulaciones y marcos de seguridad |
| **Revisión de arquitectura de seguridad** | Identificar debilidades en segregación de funciones, auditorías, controles de acceso |

### Pentester vs. Atacante

| Rol | Perspectiva del Alcance | Objetivo |
|---|---|---|
| **Pentester** | Sistema autorizado para evaluar | Identificar vulnerabilidades, reportar hallazgos, recomendar remediación |
| **Atacante** | Objetivo previsto | Explotar vulnerabilidades para acceso no autorizado, robo de datos, interrupción del servicio |

## Ataques a las Aplicaciones Web

> **HTTP es stateless** (sin estado): cada solicitud es independiente. Las apps web deben gestionar sesiones mediante cookies o ID de sesión → esto crea vectores de ataque adicionales.

### XSS — Cross-Site Scripting (Secuencias de Comandos en Sitios Cruzados)

> Analogía: Un atacante pone un cartel falso en la entrada de tu banco de confianza. Los clientes lo ven, confían en él (porque están en el banco) y siguen las instrucciones maliciosas.

**XSS:** el atacante inyecta scripts maliciosos que el navegador ejecuta porque aparenta provenir de un sitio de confianza.

| Tipo de XSS | Mecanismo | Persistencia |
|---|---|---|
| **XSS Reflejado** (Reflected/Non-Persistent) | El código malicioso viene en un enlace manipulado → el servidor lo "refleja" en la respuesta | No persiste — requiere que la víctima haga clic en el enlace |
| **XSS Almacenado** (Stored/Persistent) | El código malicioso se almacena en la base de datos del servidor | Persiste — afecta a todos los usuarios que vean el contenido |
| **XSS basado en DOM** (DOM-Based) | Explota vulnerabilidades en scripts del **lado del cliente** que manipulan el DOM (Document Object Model — Modelo de Objetos del Documento) | Varía — ocurre en el navegador sin involucrar al servidor |

**Ejemplo de XSS Almacenado:**

```html
Eche un vistazo a este sitio web increíble.
<script src="https://badsite.foo/hook.js"></script>
```

**Ejemplo de XSS Reflejado — URL maliciosa:**
> https://trusted.foo/messages?user=James<script src="https://badsite.foo/hook.js"></script>

**Usos maliciosos del XSS:**
- Robo de cookies de sesión
- Desfiguración del sitio (defacement)
- Interceptación de formularios
- Instalación de malware
- Ataques CSRF (Cross-Site Request Forgery — Falsificación de Petición en Sitios Cruzados)

### SQLi — SQL Injection (Inyección de Código SQL)

> **Analogía:** Le preguntas al empleado del banco "¿Me puedes dar el saldo de Bob?" y en lugar del nombre escribes una instrucción que dice "dame el saldo de TODOS los clientes".

**SQL** (Structured Query Language — Lenguaje de Consulta Estructurado): lenguaje para leer y escribir en bases de datos.

**Operaciones SQL principales:** `SELECT`, `INSERT`, `DELETE`, `UPDATE`

**Ejemplo de ataque SQLi:**

Consulta legítima:
```sql
SELECT * FROM tbl_user WHERE username = 'Bob'
```

Consulta maliciosa (el atacante introduce `' or 1=1#`):
```sql
SELECT * FROM tbl_user WHERE username = '' or 1=1#
```
- `1=1` → siempre verdadero → devuelve todos los registros
- `#` → convierte el resto en comentario → anula el cierre de la consulta

**Resultado:** volcado completo de la base de datos de usuarios.

**Impacto exitoso de SQLi:**
- Extracción de datos sensibles
- Modificación o eliminación de datos
- Ejecución de código arbitrario con privilegios de la aplicación de BD

> **👉 Enfoque de Examen SY0-701:**
> XSS y SQLi son los dos ataques web más preguntados. Distingue: XSS ataca al **navegador del cliente** (inyecta JavaScript); SQLi ataca la **base de datos** (inyecta SQL). La mitigación universal para ambos es **validación/sanitización de entradas**. El examen puede presentar `' or 1=1--` o `' or 1=1#` → identifica como SQLi. Para XSS: el código malicioso se ejecuta con los permisos del **sitio de confianza**, no del atacante. DOM-based XSS ocurre solo en el cliente (sin round-trip al servidor).

## Ataques a las Aplicaciones con Base en la Nube

### Características Únicas de Ataques en la Nube

- **Modelo de responsabilidad compartida** puede crear brechas de seguridad por confusión sobre quién protege qué
- Un ataque exitoso puede dar acceso a **otros recursos dentro del mismo entorno cloud** (movimiento lateral en la nube)
- Alta accesibilidad hace a las apps cloud objetivos atractivos

### Tipos de Ataques Específicos de la Nube

| Ataque | Descripción |
|---|---|
| **Ataque de canal lateral** (Side-Channel) | Un actor de amenazas con una instancia en el mismo servidor físico intenta extraer información de otras instancias mediante recursos compartidos |
| **Cryptojacking** | El atacante usa el poder de procesamiento de la nube para minar criptomonedas sin consentimiento → aumento masivo de costos para el usuario legítimo |
| **Buckets mal configurados** | Acceso no autorizado a datos en almacenamiento cloud por configuraciones erróneas de permisos |
| **Phishing desde la nube** | Sitios fraudulentos alojados en servicios cloud que imitan sitios legítimos |

### CASB — Cloud Access Security Broker

**CASB** (Cloud Access Security Broker — Agente de Seguridad de Acceso a la Nube): software de gestión empresarial que media el acceso de usuarios a servicios en la nube.

**Funciones del CASB:**
- Autenticación SSO (Single Sign-On) y controles de acceso
- Escaneo de malware y dispositivos no autorizados
- Monitoreo y auditoría de actividad de usuarios y recursos
- Prevención de exfiltración de datos

**Modos de implementación:**

| Modo | Descripción | Ventaja | Desventaja |
|---|---|---|---|
| **Proxy Directo** (Forward Proxy) | Se ubica en el perímetro de la red del cliente, requiere configurar dispositivos/agentes | Inspección en tiempo real de todo el tráfico | Posible punto único de fallo; usuarios pueden bypassearlo |
| **Proxy Inverso** (Reverse Proxy) | Se ubica en el perímetro de la red cloud; no requiere configurar dispositivos del usuario | Sin configuración en clientes | Solo funciona si la app cloud soporta proxy |
| **API** | Media conexiones mediante la API del servicio cloud; no requiere dispositivo en línea | Flexible, sin impacto en el flujo de tráfico | Depende de que la API soporte las funciones requeridas |

> **Proveedores de CASB:** Symantec, Skyhigh Security, Forcepoint, Microsoft Cloud App Security, Cisco Cloudlock

> **👉 Enfoque de Examen SY0-701:**
> El modelo de responsabilidad compartida es crítico para preguntas de cloud security. Cryptojacking = minería de criptomonedas no autorizada usando recursos de la víctima. El CASB en modo proxy directo requiere agente; en modo API no requiere agente. El examen puede preguntar cuál modo de CASB no requiere configurar los dispositivos del usuario → **proxy inverso o API**. Side-channel attack en cloud = un inquilino (tenant) ataca a otro en el mismo hardware físico.

## Cadena de Suministro

> **Analogía:** Si el proveedor de ladrillos que usas para construir tu fortaleza pone una puerta trasera en cada ladrillo, toda tu fortaleza estará comprometida desde el principio, aunque tú la construyas perfectamente.

**Vulnerabilidades de la cadena de suministro de software** (Supply Chain): riesgos introducidos en productos de software durante su ciclo de vida de desarrollo, distribución y mantenimiento.

### Tipos de Proveedores y sus Riesgos

| Tipo de Proveedor | Riesgos Clave |
|---|---|
| **Proveedores de servicios** | Plataformas cloud o agencias de desarrollo con medidas de seguridad inadecuadas; comunicaciones no aseguradas |
| **Proveedores de hardware** | Firmware preinstalado con vulnerabilidades conocidas; drivers desactualizados o de proveedores no confiables; IoT con software propietario del fabricante |
| **Proveedores de software** | Librerías, frameworks y componentes de terceros desactualizados o con vulnerabilidades conocidas |

### SBOM — Software Bill of Materials (Lista de Materiales del Software)

**SBOM** (Software Bill of Materials — Lista de Materiales del Software): inventario completo de **todos los componentes** de un producto de software.

**Contenido del SBOM:**
- Nombres de componentes
- Versiones de todos los componentes
- Información sobre proveedores
- Dependencias (librerías, frameworks, componentes de terceros)

**Beneficios del SBOM:**
- Transparencia y visibilidad de la cadena de suministro
- Identificación rápida de componentes vulnerables tras una divulgación
- Respuesta y remediación más rápidas ante incidentes
- Rastreo del origen de los componentes

### Herramientas y Estándares SBOM

| Herramienta/Estándar | Descripción |
|---|---|
| **OWASP Dependency-Check** | Herramienta SCA (Software Composition Analysis — Análisis de Composición de Software) que identifica dependencias con vulnerabilidades conocidas y divulgadas públicamente |
| **OWASP Dependency-Track** | Plataforma que consume el output de Dependency-Check para gestión continua del SBOM |
| **SPDX** (Software Package Data Exchange — Intercambio de Datos de Paquetes de Software) | Estándar abierto para comunicar información de SBOM (componentes, licencias, referencias de seguridad) |
| **CycloneDX** | Especificación ligera de OWASP para compartir y analizar datos SBOM de forma ágil |

> **SCA** (Software Composition Analysis — Análisis de Composición de Software): categoría de herramientas automatizadas que identifican y monitorean paquetes, librerías y dependencias para detectar vulnerabilidades conocidas.

> **👉 Enfoque de Examen SY0-701:**
> SolarWinds 2020 = el caso más emblemático de supply chain attack. SBOM es la herramienta proactiva para gestionar riesgos de cadena de suministro. Memoriza que OWASP Dependency-Check es una herramienta SCA (no es un SBOM en sí, sino que ayuda a crearlo). Pregunta frecuente: "¿Qué herramienta proporciona visibilidad sobre todos los componentes de software de un producto?" → SBOM. SPDX y CycloneDX son los dos estándares de formato SBOM del examen.

# 3. Métodos de Identificación de Vulnerabilidades

## Escaneo de Vulnerabilidades

> **Analogía:** Un detector de metales en el aeropuerto. Pasa a todos los pasajeros (hosts/sistemas) por el detector (escáner) buscando elementos conocidamente peligrosos (vulnerabilidades en la base de datos).

**Escaneo de vulnerabilidades:** proceso sistemático y automatizado de sondeo de sistemas/redes usando herramientas especializadas para detectar debilidades de seguridad conocidas.

### Herramientas de Escaneo de Red

| Herramienta | Tipo | Descripción |
|---|---|---|
| **Nessus** (Tenable) | Comercial | Escáner de vulnerabilidades de red popular; usa "plugins" como fuente de vulnerabilidades |
| **OpenVAS** (Greenbone) | Open Source | Escáner de vulnerabilidades de red; usa NVTs (Network Vulnerability Tests — Pruebas de Vulnerabilidad de Red) |

**Qué analizan los escáneres de red:**
- Equipos cliente y dispositivos móviles
- Servidores
- Routers y switches
- Parches faltantes
- Desviaciones de configuraciones de referencia (baseline)

### Escaneos Con y Sin Credenciales

| Tipo | Acceso | Vista obtenida | Uso recomendado |
|---|---|---|---|
| **Sin credenciales** (Unauthenticated) | Sin inicio de sesión; usa contraseñas predeterminadas de prueba | Vista de usuario sin privilegios en la red | Evaluación externa del perímetro; escaneo de apps web |
| **Con credenciales** (Authenticated) | Cuenta con derechos de inicio de sesión y permisos apropiados | Análisis profundo; detecta configuraciones erróneas internas | Simulación de ataque interno o cuenta comprometida |

> Un escaneo con credenciales es **más intrusivo** pero más completo.

### Escaneo de Vulnerabilidades de Aplicaciones

**Análisis estático** (SAST): revisión del código **sin ejecutarlo**
**Análisis dinámico** (DAST): pruebas en aplicaciones **en ejecución**

**Vulnerabilidades específicas de apps** (requieren herramientas especializadas):
- `XSS` (Cross-Site Scripting)
- `SQLi` (SQL Injection)
- Referencias a objetos directos inseguras (IDOR — Insecure Direct Object Reference)

### Monitoreo de Paquetes (Package Monitoring)

**Monitoreo de paquetes:** rastreo y evaluación continua de la seguridad de paquetes de software, librerías y dependencias de terceros.

- Relacionado con **SBOM** y gestión de riesgos de cadena de suministro
- Herramientas SCA (Software Composition Analysis) automatizan este proceso
- Compara el inventario de software de la organización contra bases de datos de vulnerabilidades conocidas (ej. **NVD** — National Vulnerability Database)
- Complementado con políticas de gobernanza: auditorías periódicas, aprobación de nuevos paquetes, procedimientos de actualización

> **👉 Enfoque de Examen SY0-701:**
> Pregunta: "¿Qué tipo de escaneo proporciona la visión de un atacante externo sin credenciales?" → escaneo **sin credenciales**. Nessus llama a sus actualizaciones "plugins"; OpenVAS las llama "NVTs". Ambas son herramientas de escaneo de red, no de apps web específicamente. El análisis estático (SAST) revisa el código fuente; el dinámico (DAST) prueba la app en ejecución.

## Fuentes de Amenazas (Threat Feeds)

> **Analogía:** Suscribirse a un boletín de inteligencia policial en tiempo real que te avisa de los criminales activos en tu zona antes de que lleguen a tu puerta.

**Feeds de amenazas** (Threat Feeds): fuentes de información actualizadas continuamente y en tiempo real sobre amenazas y vulnerabilidades, recopiladas de múltiples fuentes.

### Tipos de Investigación de Amenazas

| Tipo | Descripción |
|---|---|
| **Investigación basada en el comportamiento** | Narrativas que describen ataques y TTPs (Tactics, Techniques and Procedures — Tácticas, Técnicas y Procedimientos) recopilados de investigación primaria |
| **Inteligencia reputacional** | Listas de IPs y dominios maliciosos; firmas de malware conocido |
| **Datos de amenazas** | Datos informáticos para correlacionar eventos observados con TTPs conocidos; se integran con SIEM (Security Information and Event Management — Gestión de Información y Eventos de Seguridad) |

### CTI — Cyber Threat Intelligence

**CTI** (Cyber Threat Intelligence — Inteligencia de Amenazas Cibernéticas): los datos de amenazas empaquetados como feeds para integrar con plataformas SIEM. Los datos solos no son suficientes — deben correlacionarse con datos observados en las redes del cliente (frecuentemente mediante funcionalidades de IA del SIEM).

### Plataformas de Threat Intelligence (Propietarias)

| Plataforma | Proveedor |
|---|---|
| **IBM X-Force Exchange** | IBM Security |
| **Mandiant / FireEye** | Mandiant |
| **Recorded Future** | Recorded Future |
| **AlienVault OTX** (Open Threat Exchange) | AT&T Cybersecurity |

### Fuentes de Código Abierto vs. Propietarias

| Característica | Código Abierto | Propietarias |
|---|---|---|
| **Costo** | Gratuitas | Suscripción paga |
| **Profundidad de análisis** | Menor | Mayor |
| **Ejemplos** | Cyber Threat Alliance, MISP (Malware Information Sharing Platform) | IBM X-Force, Mandiant, Recorded Future |
| **Accesibilidad** | Disponible para todos | Solo suscriptores |

### Organizaciones de Intercambio de Información

- **Cyber Threat Alliance**: grupo colaborativo que comparte datos sobre amenazas y vulnerabilidades
- **ISAC** (Information Sharing and Analysis Centers — Centros de Análisis e Intercambio de Información): organizaciones por sectores industriales que comparten inteligencia de amenazas

### OSINT — Open Source Intelligence (Inteligencia de Fuentes Abiertas)

**OSINT** (Open Source Intelligence — Inteligencia de Fuentes Abiertas): recopilación y análisis de información disponible públicamente para apoyar la toma de decisiones en ciberseguridad.

**Fuentes de OSINT:** blogs, foros, redes sociales, dark web

**Herramientas OSINT comunes:**

| Herramienta | Función |
|---|---|
| **Shodan** | Investigar dispositivos conectados a Internet |
| **Maltego** | Visualizar redes complejas de información (relaciones entre entidades) |
| **Recon-ng** | Actividades de reconocimiento basadas en la web |
| **theHarvester** | Recopilar correos electrónicos, subdominios, hosts y nombres de empleados de fuentes públicas |

> **OSINT Framework** (https://github.com/lockfale/osint-framework): recurso para localizar y organizar herramientas OSINT.

> **👉 Enfoque de Examen SY0-701:**
> ISAC es la organización de intercambio de inteligencia por sectores. CTI data se integra con SIEM. OSINT = fuentes públicas. Shodan es la herramienta más conocida de OSINT para encontrar dispositivos expuestos en Internet. El examen puede presentar "una organización del sector salud quiere compartir información sobre amenazas con otras del sector" → respuesta: ISAC. La diferencia entre threat feed propietario y open source: costo vs. profundidad de análisis.

## Deep y Dark Web

> Analogía: Internet es como un iceberg. La "surface web" (indexada por Google) es la punta visible. La deep web es el enorme bloque sumergido. La dark web es una caverna secreta dentro de ese bloque, a la que solo se accede con un equipo especial.

### Capas de la Web

| Capa | Descripción | Acceso |
|---|---|---|
| **Surface Web** | Contenido indexado por motores de búsqueda | Navegador estándar + Google/Bing |
| **Deep Web** | Contenido NO indexado por motores de búsqueda (páginas con registro, páginas bloqueadas para indexación, DNS no estándar, contenido codificado no estándar) | Navegador estándar + URL directa / credenciales |
| **Dark Net** | Red superpuesta sobre Internet usando software como TOR (The Onion Router), Freenet o I2P para anonimizar el uso | Software especializado (ej. TOR Browser) |
| **Dark Web** | Sitios, contenidos y servicios accesibles SOLO a través de una dark net | TOR Browser u otro software de dark net |

### TOR — The Onion Router

**Enrutamiento cebolla** (Onion Routing): múltiples capas de cifrado y retransmisiones entre nodos para lograr anonimato. Cada nodo solo conoce el nodo anterior y el siguiente.

### Usos de la Dark Web

**Legítimos:**
- Privacidad y anonimato (periodistas, activistas, denunciantes en regímenes represivos)
- Acceso a información censurada
- Investigación de amenazas cibernéticas (investigadores de seguridad)
- Inteligencia de contrainteligencia (infiltración en foros de hackeo)

**Ilícitos:**
- Intercambio de datos robados y herramientas de hackeo
- Mercados de malware y exploits
- Actividades criminales diversas

> **Importante:** La dark web como **fuente de inteligencia de amenazas** es legítima para investigadores; participar en actividades ilegales está estrictamente prohibido.

**Honeynets:** redes trampa operadas por organizaciones de seguridad para observar cómo los hackers interactúan con sistemas vulnerables → fuente de inteligencia primaria sobre TTPs.

> **👉 Enfoque de Examen SY0-701:**
> Distingue: Deep web ≠ Dark web. Deep web = cualquier cosa no indexada (incluyendo tu banco online, correo, etc.). Dark web = subconjunto de la deep web, accesible solo mediante software especial como TOR. TOR = The Onion Router = múltiples capas de cifrado. El examen puede preguntar qué tipo de red usa TOR → "overlay network" (red superpuesta). Honeynets son herramientas de investigación activa de amenazas.

## Otros Métodos de Evaluación de Vulnerabilidades

### Pentest (Prueba de Penetración)

> Analogía: Contratar a un ladrón ético para intentar robar en tu banco. Si lo logra, sabes exactamente dónde está el fallo antes de que lo encuentre un ladrón real.

**Pentest** (Penetration Testing — Prueba de Penetración): hackers éticos intentan comprometer activamente la seguridad de una organización explotando vulnerabilidades.

**Ventaja sobre el escaneo automatizado:**
- Ingenio y creatividad humana
- Detecta vulnerabilidades complejas (diseño/implementación, no solo código)
- Identifica vulnerabilidades encadenadas (varias debilidades menores que combinadas crean una falla mayor)
- Vulnerabilidades de omisión de autenticación

### Tipos de Pentest por Conocimiento del Entorno

| Tipo | Nombre Antiguo | Información del Consultor | Simula |
|---|---|---|---|
| **Entorno Desconocido** | Caja Negra (Black Box) | Sin información privilegiada; requiere fase extensa de reconocimiento | Amenaza externa |
| **Entorno Conocido** | Caja Blanca (White Box) | Acceso completo a información sobre la red | Amenaza interna privilegiada |
| **Entorno Parcialmente Conocido** | Caja Gris (Gray Box) | Información parcial; reconocimiento parcial requerido | Amenaza intermedia |

### Bug Bounty (Recompensas por Detección de Errores)

**Bug Bounty:** programas donde organizaciones ofrecen recompensas a investigadores externos o hackers éticos ("white hat") por descubrir y reportar vulnerabilidades.

| Característica | Pentest | Bug Bounty |
|---|---|---|
| **Quién realiza** | Equipo contratado de profesionales | Comunidad global de investigadores independientes |
| **Estructura** | Marco de tiempo definido, enfoque estructurado | Abierto y continuo |
| **Costo** | Predecible | Variable (basado en hallazgos) |
| **Cobertura** | Focalizada y exhaustiva en el alcance | Amplia (diversas habilidades y perspectivas) |
| **Control** | Alto | Bajo |

**Plataformas de Bug Bounty:** HackerOne, Bugcrowd

**Divulgación responsable:** programas implementados por organizaciones para incentivar el reporte de vulnerabilidades, con pautas claras y posibles recompensas.

### Auditoría

**Auditoría de ciberseguridad:** revisión exhaustiva para garantizar que la postura de seguridad está alineada con estándares y mejores prácticas.

| Tipo de Auditoría | Descripción |
|---|---|
| **Auditoría de cumplimiento** | Evalúa conformidad con regulaciones (GDPR, HIPAA, PCI DSS) |
| **Auditoría basada en riesgos** | Identifica amenazas y vulnerabilidades en sistemas y procesos |
| **Auditoría técnica** | Examina infraestructura TI: seguridad de red, controles de acceso, protección de datos |
| **Auditoría de productos** | Se centra en funciones específicas (ej. código de una aplicación) |
| **Auditoría de sistemas y procesos** | Examina uso e implementación más amplia: cadena de suministro, configuración, soporte, monitoreo |

**Marcos de referencia para auditorías:** ISO 27001, NIST Cybersecurity Framework

**PCI DSS** (Payment Card Industry Data Security Standard — Estándar de Seguridad de Datos para la Industria de Tarjetas de Pago): exige pentests **anuales** para organizaciones que manejan datos de tarjetas de pago.

> **👉 Enfoque de Examen SY0-701:**
> Los nuevos nombres (entorno conocido/desconocido/parcialmente conocido) reemplazaron a caja blanca/negra/gris en SY0-701. Memoriza ambas versiones. Pregunta típica: "Un consultor realiza un pentest sin información previa sobre la red" → entorno desconocido / caja negra. Bug bounty vs. pentest: el pentest es controlado y contratado; el bug bounty es abierto a la comunidad. PCI DSS requiere pentests anuales → dato examinable. Divulgación responsable = notificar al proveedor ANTES de publicar la vulnerabilidad.

# 4. Análisis y Corrección de Vulnerabilidades

## Vulnerabilidades y Exposiciones Comunes (CVE, NVD, CVSS, SCAP)

### Fuente de Vulnerabilidades (Vulnerability Feed)

**Vulnerability Feed:** base de datos actualizada de vulnerabilidades conocidas que alimenta a los escáneres.

| Herramienta | Nombre de la Fuente |
|---|---|
| **Nessus** | Plugins |
| **OpenVAS** | NVTs (Network Vulnerability Tests — Pruebas de Vulnerabilidad de Red) |

### CVE — Common Vulnerabilities and Exposures

**CVE** (Common Vulnerabilities and Exposures — Vulnerabilidades y Exposiciones Comunes): diccionario público de vulnerabilidades en SO y software de aplicaciones, mantenido por MITRE (cve.mitre.org).

**Formato del identificador CVE:**

> CVE-AAAA-####

- `AAAA` = año en que se descubrió la vulnerabilidad
- `####` = al menos 4 dígitos (orden de descubrimiento)

**Componentes de una entrada CVE:**
- Identificador único (`CVE-AAAA-####`)
- Breve descripción de la vulnerabilidad
- Lista de URLs de referencia con más información
- Fecha de creación de la entrada

### NVD — National Vulnerability Database

**NVD** (National Vulnerability Database — Base de Datos Nacional de Vulnerabilidades): repositorio mantenido por **NIST** (National Institute of Standards and Technology — Instituto Nacional de Estándares y Tecnología) (nvd.nist.gov).

- Usa las entradas CVE como base
- Añade: análisis adicional, métrica CVSS, información sobre correcciones

### CVSS — Common Vulnerability Scoring System

**CVSS** (Common Vulnerability Scoring System — Sistema de Puntuación de Vulnerabilidades Comunes): métrica estándar para calificar la severidad de vulnerabilidades, mantenida por **FIRST** (Forum of Incident Response and Security Teams — Foro de Equipos de Seguridad y Respuesta a Incidentes) (first.org/cvss).

**Escala CVSS:**

| Puntuación | Descripción |
|---|---|
| 0.1 – 3.9 | **Baja** |
| 4.0 – 6.9 | **Media** |
| 7.0 – 8.9 | **Alta** |
| 9.0 – 10.0 | **Crítica** |

**Factores que considera CVSS:**
- ¿Puede activarse remotamente o requiere acceso local?
- ¿Requiere intervención del usuario?
- Complejidad del ataque
- Impacto en confidencialidad, integridad y disponibilidad

### SCAP — Security Content Automation Protocol

**SCAP** (Security Content Automation Protocol — Protocolo de Automatización de Contenido de Seguridad): protocolo utilizado por muchos escáneres para obtener actualizaciones de fuentes/plugins (scap.nist.gov).

**Funciones de SCAP:**
- Distribuir la fuente de vulnerabilidades
- Comparar la configuración real de un sistema con una línea base segura
- Definir sistemas de identificadores comunes (incluyendo CVE, CPE)

**CPE** (Common Platform Enumeration — Enumeración de Plataformas Comunes): identificador estándar para sistemas, plataformas y paquetes.

> **👉 Enfoque de Examen SY0-701:**
> Memoriza la jerarquía: CVE (MITRE) → NVD (NIST) → CVSS (FIRST). CVSS proporciona la PUNTUACIÓN; CVE proporciona el IDENTIFICADOR; NVD es el REPOSITORIO completo. Nessus = plugins; OpenVAS = NVTs. SCAP es el protocolo que distribuye las actualizaciones. Puntuación CVSS ≥ 9.0 = Crítica → remediación inmediata. El examen puede dar una puntuación CVSS y preguntar la categoría de severidad → usa la tabla.

## Falsos Positivos, Falsos Negativos y Revisión de Registros

> Analogía: El detector de humo que se activa cada vez que cocinas (falso positivo) hace que eventualmente desconectes el detector → mayor riesgo. El detector que no se activa con un incendio real (falso negativo) = desastre silencioso.

### Informes de Escaneo

- Los informes codifican vulnerabilidades **por colores** (rojo = atención inmediata)
- Se pueden revisar por alcance (las más críticas en todos los hosts) o por host
- Incluyen enlaces a detalles y técnicas de remediación

### Falsos Positivos y Falsos Negativos

| Tipo | Definición | Riesgo | Solución |
|---|---|---|---|
| **Falso Positivo** (False Positive) | El escáner identifica incorrectamente una vulnerabilidad que NO existe | Desperdicio de tiempo y recursos; riesgo de ignorar todos los escaneos | Escaneos con credenciales (más precisos); escáneres activos/intrusivos |
| **Falso Negativo** (False Negative) | Una vulnerabilidad real NO es detectada durante el escaneo | Falsa sensación de seguridad | Escaneos periódicos repetidos; usar escáneres de diferentes proveedores |

> **Escaneos activos/intrusivos:** más adecuados para detectar más vulnerabilidades y reducir notablemente los falsos positivos.

### Revisión de Registros para Validación

- Los registros de red y del sistema **validan** los informes de vulnerabilidades
- Ejemplo: escáner identifica proceso inestable → revisar registros de eventos → confirmar fallos del proceso en las últimas semanas → la alerta es válida
- Los scripts de escaneo automatizado pueden no replicar el éxito de un hacker experto → posible **falsa sensación de seguridad**

> **👉 Enfoque de Examen SY0-701:**
> Si el examen describe una situación donde "el equipo ignora los resultados del escáner por exceso de alertas", el problema es exceso de **falsos positivos**. Si "el escáner no encontró la vulnerabilidad que fue explotada", el problema es un **falso negativo**. La solución a falsos negativos incluye escaneos repetidos y múltiples proveedores. Los escaneos con credenciales reducen los falsos positivos porque tienen acceso real al sistema.

## Análisis de Vulnerabilidades

> Analogía: Después de hacer el inventario de todos los problemas de tu fortaleza (escaneo), ahora debes decidir cuáles reparar primero, cuáles son más críticos y cuáles puedes aceptar temporalmente.

### Dimensiones del Análisis

| Dimensión | Descripción |
|---|---|
| **Priorización** | Identificar las vulnerabilidades más críticas según gravedad, facilidad de explotación e impacto potencial |
| **Clasificación** | Categorizar vulnerabilidades por tipo de sistema/app afectado, naturaleza de la vulnerabilidad, impacto potencial |
| **Factor de Exposición** (EF — Exposure Factor) | Grado en que un activo es susceptible de ser comprometido. Considera: autenticación débil, segmentación de red inadecuada, controles de acceso insuficientes |
| **Impactos** | Pérdidas financieras, daños a la reputación, interrupciones operativas, sanciones regulatorias |

### Variables Ambientales en el Análisis

| Variable | Influencia en el Análisis |
|---|---|
| **Infraestructura TI** | Diversidad, complejidad y antigüedad de hardware/software determinan cantidad y tipo de vulnerabilidades |
| **Panorama de amenazas externas** | Si un tipo de ataque está en auge en el sector, priorizar las vulnerabilidades relacionadas |
| **Entorno regulatorio y de cumplimiento** | Sectores regulados (salud, finanzas) priorizan vulnerabilidades con riesgo de brechas de datos y sanciones |
| **Entorno operativo** | Flujos de trabajo, patrones de uso; prácticas deficientes (gestión de parches, acceso, configuración) aumentan la exposición |

**Prácticas operativas que aumentan el riesgo:**
- Prácticas deficientes de gestión de parches
- Falta de controles de acceso rigurosos
- Falta de capacitación en concienciación de seguridad
- Prácticas deficientes de gestión de configuraciones
- Políticas insuficientes de desarrollo de aplicaciones

### Tolerancia al Riesgo (Risk Tolerance)

**Tolerancia al riesgo:** nivel de riesgo que una organización está dispuesta a aceptar. Varía según:
- Tamaño de la organización
- Industria
- Entorno regulatorio
- Objetivos estratégicos

> **👉 Enfoque de Examen SY0-701:**
> El examen pregunta sobre EF (Exposure Factor) como parte del cálculo de ALE (Annual Loss Expectancy — Expectativa de Pérdida Anual). EF × Asset Value × ARO (Annual Rate of Occurrence) = ALE. La priorización basada en CVSS + contexto ambiental es la práctica correcta. "Risk tolerance" determina qué nivel de vulnerabilidad es aceptable — si la organización tiene baja tolerancia, debe remediar hasta vulnerabilidades de severidad media.

## Respuesta y Corrección de Vulnerabilidades

### Prácticas de Corrección (Remediation)

| Práctica | Descripción |
|---|---|
| **Implementación de parches** (Patch Management) | Aplicar actualizaciones de software/SO para corregir vulnerabilidades conocidas. Gestión centralizada y procesos robustos son esenciales |
| **Seguro de ciberseguridad** (Cyber Insurance) | Protección financiera ante brechas. No mitiga vulnerabilidades directamente — es transferencia de riesgo. Cubre: costos de respuesta, interrupción del negocio, ransomware, responsabilidad civil, extorsión |
| **Segmentación** (Segmentation) | Dividir la red en segmentos separados. Limita el movimiento lateral del atacante y contiene brechas |
| **Controles compensatorios** (Compensating Controls) | Medidas alternativas cuando la corrección directa es imposible o inmediata. Ej: monitoreo adicional, autenticación secundaria, cifrado reforzado |
| **Excepciones y exenciones** | Vulnerabilidades que no pueden corregirse por criticidad del negocio, restricciones técnicas o costos → alta dirección acepta el riesgo formalmente con documentación y cronograma de reevaluación |

**Alcance del programa de gestión de parches:**
- Sistemas operativos
- Dispositivos de red (routers, switches, firewalls)
- Bases de datos
- Aplicaciones web
- Aplicaciones de escritorio (clientes de email, navegadores, suite de oficina)
- Otras aplicaciones de software del entorno

### Validación de la Corrección

| Método | Descripción |
|---|---|
| **Reevaluación** (Re-scan) | Ejecutar escaneos adicionales tras implementar correcciones para verificar que las vulnerabilidades fueron resueltas |
| **Auditoría** | Revisión detallada del proceso de corrección; verifica alineación con políticas y que la documentación esté actualizada |
| **Verificación** | Confirmación de resultados mediante verificaciones manuales, pruebas automatizadas o revisión de logs |

**¿Por qué es crítica la validación?**
- Errores humanos o técnicos pueden dejar correcciones incompletas/incorrectas
- Una corrección puede inadvertidamente introducir nuevas vulnerabilidades o conflictos con otros sistemas
- Proporciona responsabilización y evidencia de cumplimiento

### Informes de Vulnerabilidades

Un buen informe incluye:
- Lista de vulnerabilidades con **clasificación de severidad** (usando CVSS)
- **Impacto potencial** de cada vulnerabilidad (brechas de datos, interrupción del sistema)
- **Recomendaciones de remediación** específicas (parches, cambios de configuración, estrategias de mitigación)
- **Formato claro y conciso** para audiencias técnicas y no técnicas
- **Presentación puntual** (demoras = mayor ventana de oportunidad para atacantes)

> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: "Una vulnerabilidad crítica no puede parchearse porque el sistema no puede reiniciarse en producción. ¿Cuál es la medida correcta?" → **control compensatorio**. Recuerda que el seguro de ciberseguridad = transferencia de riesgo, NO mitigación técnica. La diferencia entre excepción y exención: ambas implican aceptar el riesgo formalmente, con documentación y reevaluación programada. La validación mediante re-scan es el paso final obligatorio del ciclo de gestión de vulnerabilidades. CVSS es el estándar de puntuación en los informes.

# 5. Glosario

| Acrónimo | Significado |
|---|---|
| **ALE** | Annual Loss Expectancy — Expectativa de Pérdida Anual |
| **APK** | Android Application Package — Paquete de Aplicación Android |
| **ARO** | Annual Rate of Occurrence — Tasa Anual de Ocurrencia |
| **ASLR** | Address Space Layout Randomization — Distribución Aleatoria del Espacio de Direcciones |
| **BEAST** | Browser Exploit Against SSL/TLS |
| **CASB** | Cloud Access Security Broker — Agente de Seguridad de Acceso a la Nube |
| **CSAM** | Cloud Security Access Management |
| **CTI** | Cyber Threat Intelligence — Inteligencia de Amenazas Cibernéticas |
| **CVE** | Common Vulnerabilities and Exposures — Vulnerabilidades y Exposiciones Comunes |
| **CVSS** | Common Vulnerability Scoring System — Sistema de Puntuación de Vulnerabilidades Comunes |
| **DAST** | Dynamic Application Security Testing — Pruebas Dinámicas de Seguridad de Aplicaciones |
| **DEP** | Data Execution Prevention — Prevención de Ejecución de Datos |
| **DOM** | Document Object Model — Modelo de Objetos del Documento |
| **EF** | Exposure Factor — Factor de Exposición |
| **EOL** | End of Life — Fin de Vida |
| **FIRST** | Forum of Incident Response and Security Teams |
| **FOSS** | Free and Open Source Software — Software Libre y de Código Abierto |
| **HIPAA** | Health Insurance Portability and Accountability Act |
| **HSM** | Hardware Security Module — Módulo de Seguridad Hardware |
| **HTTP** | HyperText Transfer Protocol — Protocolo de Transferencia de HiperTexto |
| **IDOR** | Insecure Direct Object Reference — Referencia Directa a Objeto Insegura |
| **IoT** | Internet of Things — Internet de las Cosas |
| **ISAC** | Information Sharing and Analysis Centers — Centros de Análisis e Intercambio de Información |
| **KMS** | Key Management System — Sistema de Gestión de Claves |
| **KRACK** | Key Reinstallation Attacks |
| **MDM** | Mobile Device Management — Gestión de Dispositivos Móviles |
| **MISP** | Malware Information Sharing Platform |
| **NIST** | National Institute of Standards and Technology — Instituto Nacional de Estándares y Tecnología |
| **NVD** | National Vulnerability Database — Base de Datos Nacional de Vulnerabilidades |
| **NVT** | Network Vulnerability Test — Prueba de Vulnerabilidad de Red |
| **OSINT** | Open Source Intelligence — Inteligencia de Fuentes Abiertas |
| **PCI DSS** | Payment Card Industry Data Security Standard |
| **POODLE** | Padding Oracle On Downgraded Legacy Encryption |
| **RCE** | Remote Code Execution — Ejecución Remota de Código |
| **SAST** | Static Application Security Testing — Pruebas Estáticas de Seguridad de Aplicaciones |
| **SBOM** | Software Bill of Materials — Lista de Materiales del Software |
| **SCAP** | Security Content Automation Protocol — Protocolo de Automatización de Contenido de Seguridad |
| **SCA** | Software Composition Analysis — Análisis de Composición de Software |
| **SIEM** | Security Information and Event Management — Gestión de Información y Eventos de Seguridad |
| **SMB** | Server Message Block — Bloque de Mensajes del Servidor |
| **SPDX** | Software Package Data Exchange — Intercambio de Datos de Paquetes de Software |
| **SQL** | Structured Query Language — Lenguaje de Consulta Estructurado |
| **SQLi** | SQL Injection — Inyección de SQL |
| **SSL** | Secure Sockets Layer |
| **TLS** | Transport Layer Security — Seguridad de la Capa de Transporte |
| **TOCTOU** | Time-of-Check to Time-of-Use — Tiempo de Verificación a Tiempo de Uso |
| **TOR** | The Onion Router |
| **TTP** | Tactics, Techniques and Procedures — Tácticas, Técnicas y Procedimientos |
| **UEFI** | Unified Extensible Firmware Interface — Interfaz de Firmware Extensible Unificada |
| **VoIP** | Voice over IP — Voz sobre IP |
| **XSS** | Cross-Site Scripting — Secuencias de Comandos en Sitios Cruzados |