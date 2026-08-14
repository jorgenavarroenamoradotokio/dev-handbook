> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Líneas de Base de Seguridad del Protocolo de Aplicación](#1-líneas-de-base-de-seguridad-del-protocolo-de-aplicación)
  - [Protocolos Seguros](#protocolos-seguros)
    - [Tabla Comparativa: Protocolos Inseguros vs. Seguros](#tabla-comparativa-protocolos-inseguros-vs-seguros)
    - [Proceso de Selección de Protocolos Seguros](#proceso-de-selección-de-protocolos-seguros)
    - [Consideraciones al Seleccionar Protocolos](#consideraciones-al-seleccionar-protocolos)
    - [Desafíos de los Protocolos Seguros](#desafíos-de-los-protocolos-seguros)
  - [Seguridad de la Capa de Transporte (TLS)](#seguridad-de-la-capa-de-transporte-tls)
    - [Historia y Evolución](#historia-y-evolución)
    - [Versiones SSL/TLS](#versiones-ssltls)
    - [Funcionamiento de TLS](#funcionamiento-de-tls)
    - [Ataque de Degradación (Downgrade Attack)](#ataque-de-degradación-downgrade-attack)
    - [Suites de Cifrado (Cipher Suites)](#suites-de-cifrado-cipher-suites)
  - [Servicios de Directorio Seguro (LDAP/LDAPS)](#servicios-de-directorio-seguro-ldapldaps)
    - [Métodos de Autenticación LDAP](#métodos-de-autenticación-ldap)
    - [Buenas Prácticas](#buenas-prácticas)
  - [Seguridad del Protocolo SNMP](#seguridad-del-protocolo-snmp)
    - [Versiones de SNMP](#versiones-de-snmp)
    - [Buenas Prácticas SNMP](#buenas-prácticas-snmp)
  - [Servicios de Transferencia de Archivos](#servicios-de-transferencia-de-archivos)
    - [FTP (Protocolo de Transferencia de Archivos)](#ftp-protocolo-de-transferencia-de-archivos)
    - [SFTP — SSH FTP (Protocolo Seguro de Transferencia de Archivos)](#sftp--ssh-ftp-protocolo-seguro-de-transferencia-de-archivos)
    - [FTPS — FTP sobre SSL/TLS](#ftps--ftp-sobre-ssltls)
    - [Tabla Comparativa Final](#tabla-comparativa-final)
  - [Servicios de Correo Electrónico](#servicios-de-correo-electrónico)
    - [Dos tipos de protocolos de email:](#dos-tipos-de-protocolos-de-email)
    - [SMTP Seguro (SMTPS)](#smtp-seguro-smtps)
    - [POP3 Seguro (POP3S)](#pop3-seguro-pop3s)
    - [IMAP Seguro (IMAPS)](#imap-seguro-imaps)
    - [Tabla Resumen de Puertos de Email](#tabla-resumen-de-puertos-de-email)
  - [Seguridad del Correo Electrónico: SPF, DKIM, DMARC, S/MIME](#seguridad-del-correo-electrónico-spf-dkim-dmarc-smime)
    - [SPF (Marco de Directivas de Remitente / Sender Policy Framework)](#spf-marco-de-directivas-de-remitente--sender-policy-framework)
    - [DKIM (Correo Identificado por Claves de Dominio / DomainKeys Identified Mail)](#dkim-correo-identificado-por-claves-de-dominio--domainkeys-identified-mail)
    - [DMARC (Autenticación de Mensajes, Informes y Conformidad Basada en Dominios / Domain-based Message Authentication, Reporting \& Conformance)](#dmarc-autenticación-de-mensajes-informes-y-conformidad-basada-en-dominios--domain-based-message-authentication-reporting--conformance)
    - [Combinación SPF + DKIM + DMARC](#combinación-spf--dkim--dmarc)
    - [Puerta de Enlace de Correo Electrónico (Email Gateway)](#puerta-de-enlace-de-correo-electrónico-email-gateway)
    - [S/MIME (Extensiones de Correo de Internet Multipropósito/Seguras / Secure/Multipurpose Internet Mail Extensions)](#smime-extensiones-de-correo-de-internet-multipropósitoseguras--securemultipurpose-internet-mail-extensions)
  - [Prevención de Pérdida de Datos por Correo Electrónico (DLP)](#prevención-de-pérdida-de-datos-por-correo-electrónico-dlp)
    - [¿Por qué el correo electrónico es un vector crítico de pérdida de datos?](#por-qué-el-correo-electrónico-es-un-vector-crítico-de-pérdida-de-datos)
    - [Cómo funciona DLP en Email](#cómo-funciona-dlp-en-email)
    - [Acciones posibles del sistema DLP](#acciones-posibles-del-sistema-dlp)
    - [Implementación](#implementación)
  - [Filtrado de DNS y DNSSEC](#filtrado-de-dns-y-dnssec)
    - [Ventajas del Filtrado DNS](#ventajas-del-filtrado-dns)
    - [Métodos de Implementación del Filtrado DNS](#métodos-de-implementación-del-filtrado-dns)
    - [Seguridad DNS (Más allá del Filtrado)](#seguridad-dns-más-allá-del-filtrado)
    - [DNSSEC (Extensiones de Seguridad de DNS / DNS Security Extensions)](#dnssec-extensiones-de-seguridad-de-dns--dns-security-extensions)
- [2. Conceptos de Seguridad en la Nube y en las Aplicaciones Web](#2-conceptos-de-seguridad-en-la-nube-y-en-las-aplicaciones-web)
  - [Técnicas de Codificación Segura](#técnicas-de-codificación-segura)
    - [Validación de Entradas](#validación-de-entradas)
    - [Cookies Seguras](#cookies-seguras)
    - [Análisis de Código Estático (SAST)](#análisis-de-código-estático-sast)
    - [Firma de Código (Code Signing)](#firma-de-código-code-signing)
  - [Protección de Aplicaciones](#protección-de-aplicaciones)
    - [Exposición de Datos](#exposición-de-datos)
    - [Gestión de Errores](#gestión-de-errores)
    - [Gestión de Memoria](#gestión-de-memoria)
    - [Validación del Lado del Cliente vs. del Servidor](#validación-del-lado-del-cliente-vs-del-servidor)
    - [Seguridad de Aplicaciones en la Nube (Cloud Hardening)](#seguridad-de-aplicaciones-en-la-nube-cloud-hardening)
    - [Capacidades de Monitoreo](#capacidades-de-monitoreo)
  - [Sandboxing de Software](#sandboxing-de-software)
    - [Ejemplos Prácticos de Sandboxing](#ejemplos-prácticos-de-sandboxing)
    - [Sandboxing en Operaciones de Seguridad](#sandboxing-en-operaciones-de-seguridad)
- [3. Tabla Puertos y Protocolos](#3-tabla-puertos-y-protocolos)
- [4. Tabla Seguridad de Email](#4-tabla-seguridad-de-email)
- [5. GLOSARIO](#5-glosario)

---

# 1. Líneas de Base de Seguridad del Protocolo de Aplicación

> **Objetivo de Examen cubierto: 4.5** — A partir de un escenario, modificar las capacidades de la empresa para aumentar la seguridad.

## Protocolos Seguros

Muchos protocolos de red nacieron en una era donde la **funcionalidad** era prioritaria y la seguridad era secundaria. Hoy, cada protocolo inseguro tiene una alternativa segura.

> **Analogía:** Un protocolo inseguro es como enviar una carta sin sobre — cualquiera que la toque en el camino puede leerla. Un protocolo seguro es como enviarla en una caja fuerte que solo el destinatario puede abrir.

### Tabla Comparativa: Protocolos Inseguros vs. Seguros

| Protocolo Inseguro | Puerto | Alternativa Segura | Puerto | Mecanismo |
|--------------------|--------|--------------------|--------|-----------|
| `HTTP` | `80` | `HTTPS` | `443` | TLS/SSL |
| `Telnet` | `23` | `SSH` | `22` | Cifrado simétrico/asimétrico |
| `FTP` | `21` | `SFTP` / `FTPS` | `22` / `990` | SSH / TLS |
| `LDAP` | `389` | `LDAPS` | `636` | TLS |
| `SMTP` | `25` | `SMTPS` | `465`/`587` | TLS implícito/explícito |
| `POP3` | `110` | `POP3S` | `995` | TLS |
| `IMAP` | `143` | `IMAPS` | `993` | TLS |
| `DNS` | `53` | `DNSSEC` | `53` | Firmas criptográficas |
| `SNMP v1/v2` | `161`/`162` | `SNMP v3` | `161`/`162` | Autenticación + cifrado |

### Proceso de Selección de Protocolos Seguros

Las organizaciones siguen un proceso formal que incluye:
1. **Evaluación de riesgos** → ¿Qué tan sensible es el dato?
2. **Revisión de políticas** → ¿Qué exige el marco de cumplimiento?
3. **Consulta con expertos** → Proveedores o arquitectos de seguridad
4. **Documentación** → Para auditorías y revisiones de cumplimiento
5. **Afectación a líneas de base** → Sistemas de gestión de configuración

### Consideraciones al Seleccionar Protocolos

- **Tipo de datos:** Cuanto más confidencial, más robusto debe ser el protocolo
- **Puertos TCP/UDP:** Los puertos estándar pueden cambiarse para "oscurecer" el servicio (aunque añade complejidad)
- **TCP vs. UDP:**

| Protocolo | Tipo | Características | Uso Ideal |
|-----------|------|-----------------|-----------|
| **TCP** (Protocolo de Control de Transmisión) | Orientado a conexión | Confiable, ordenado, verificación de errores | Aplicaciones que requieren alta confiabilidad |
| **UDP** (Protocolo de Datagrama de Usuario) | Sin conexión | Rápido, sin garantía de entrega | Streaming, VoIP, juegos en línea |

### Desafíos de los Protocolos Seguros

- Mayor **complejidad de implementación** (certificados, gestión de claves, renovaciones)
- **Gestión de claves criptográficas**: creación, almacenamiento, distribución, revocación
- **Resolución de problemas más difícil**: no se puede inspeccionar el payload cifrado fácilmente
- **Mayor configuración propensa a errores**

> 💡 **Regla de oro:** Todos los protocolos deben ser seguros **a menos que haya razones específicas** que justifiquen el uso de protocolos inseguros.

> **👉 Enfoque de Examen SY0-701:** CompTIA presenta escenarios donde tienes que elegir el protocolo CORRECTO para una situación. Los distractores más comunes son confundir `SFTP` (usa SSH/puerto `22`) con `FTPS` (usa TLS/puerto `990`/`21`), o elegir `Telnet` cuando claramente se necesita `SSH`. También preguntan sobre TCP vs. UDP — recuerda: **streaming/tiempo real = UDP**, **confiabilidad/transacciones = TCP**.

## Seguridad de la Capa de Transporte (TLS)

### Historia y Evolución

- **SSL** (Secure Sockets Layer) → Desarrollado por Netscape en los años 90 para asegurar HTTP
- **TLS** (Seguridad de la Capa de Transporte) → Estándar derivado de SSL, actualmente reemplaza a SSL por completo
- **Uso principal:** `HTTPS` en el puerto `443`, pero también protege otros protocolos y sirve como base de **VPN** (Red Privada Virtual)

> **Analogía:** SSL/TLS es como el sistema de seguridad de un banco que se actualiza constantemente. Las versiones viejas tienen vulnerabilidades conocidas (como cerraduras anticuadas), mientras que TLS 1.3 es la cerradura más moderna e impenetrable.

### Versiones SSL/TLS

| Versión | Estado | Notas |
|---------|--------|-------|
| SSL 2.0 | ❌ Obsoleto/Inseguro | No usar |
| SSL 3.0 | ❌ Obsoleto/Inseguro | No usar (POODLE attack) |
| TLS 1.0 | ❌ Obsoleto | No usar |
| TLS 1.1 | ❌ Obsoleto | No usar |
| TLS 1.2 | ⚠️ Aceptable | Ampliamente usado, pero ya hay TLS 1.3 |
| **TLS 1.3** | ✅ Recomendado | Aprobado en 2018. Elimina ataques de degradación |

### Funcionamiento de TLS

```
Cliente                          Servidor
  |                                 |
  |--- ClientHello (versiones/cifrados soportados) --->|
  |<-- ServerHello + Certificado Digital -------------|
  |    [Certificado firmado por CA de confianza]       |
  |--- Verificar certificado, acordar claves --------->|
  |<========= Sesión Cifrada Establecida =============>|
```

- El servidor recibe un **certificado digital** firmado por una **CA** (Autoridad Certificadora) de confianza
- El certificado valida el par de **clave pública/privada** del servidor
- El cliente puede también tener certificado → **autenticación mutua** (usado en VPN empresariales)
- `HTTPS` se indica por `https://` en la URL y el ícono de 🔒 en el navegador

### Ataque de Degradación (Downgrade Attack)

- Un **ataque en ruta** (man-in-the-middle) fuerza el uso de versiones antiguas de TLS o suites de cifrado débiles
- **TLS 1.3 elimina** la capacidad de realizar ataques de degradación al no incluir algoritmos inseguros

### Suites de Cifrado (Cipher Suites)

Una **suite de cifrado** es el conjunto de algoritmos que cliente y servidor negocian para establecer la sesión segura.

**Formato en TLS 1.2:**
```
ECDHE-RSA-AES128-GCM-SHA256
  │     │    │       │
  │     │    │       └── Hash HMAC: SHA-256
  │     │    └────────── Cifrado simétrico: AES-128-GCM
  │     └─────────────── Firma: RSA
  └───────────────────── Intercambio de claves: ECDHE (Elliptic Curve Diffie-Hellman Ephemeral)
```

**Formato simplificado en TLS 1.3:**
```
TLS_AES_256_GCM_SHA384
       │           │
       │           └── Hash: SHA-384 (usado en HKDF)
       └────────────── Cifrado: AES-256-GCM
```

> En TLS 1.3 **solo se admite intercambio de clave efímero**, y el tipo de firma se proporciona en el certificado. La **HKDF** (Función de Derivación de Clave Basada en Hash) deriva las claves de sesión simétricas a partir del secreto compartido D-H.

> **👉 Enfoque de Examen SY0-701:** Saber que TLS 1.3 **elimina los ataques de degradación** y solo admite **suites efímeras**. Un distractor común es confundir SSL con TLS — SSL está obsoleto. También pueden preguntar sobre el **ataque de degradación** y qué versión lo previene (respuesta: **TLS 1.3**). Recuerda: HTTPS = puerto `443`.

## Servicios de Directorio Seguro (LDAP/LDAPS)

- **LDAP** (Protocolo Ligero de Acceso a Directorios) → Puerto `389`, texto plano ❌
- **LDAPS** (LDAP Seguro) → Puerto `636`, cifrado con TLS ✅
- Los directorios listan **sujetos** (usuarios, equipos, servicios) y **objetos** (archivos, directorios) con sus permisos

> **Analogía:** Un directorio de red es como la guía telefónica interna de una empresa: lista quién existe, qué permisos tiene y a qué puede acceder. Si alguien intercepta esa guía, puede atacar la organización. LDAPS es como guardar esa guía en una caja fuerte.

### Métodos de Autenticación LDAP

| Método | Seguridad | Descripción |
|--------|-----------|-------------|
| **Sin autenticación** | ❌ Muy baja | Acceso anónimo al directorio |
| **Enlace simple** | ❌ Baja | DN (Distinguished Name) + contraseña en texto plano |
| **SASL** (Capa de Autenticación y Seguridad Simple) | ✅ Alta | Negocia mecanismo compatible (ej. Kerberos); usa `STARTTLS` para cifrado e integridad. Preferido en **Active Directory de Microsoft** |
| **LDAPS** | ✅ Alta | Certificado digital en servidor + túnel TLS. Puerto `636` |

### Buenas Prácticas

- **Deshabilitar** acceso anónimo y enlace simple si se requiere seguridad
- **Dos niveles de acceso:** solo lectura (consultas) y lectura/escritura (actualizaciones)
- El servidor LDAP debe ser **accesible solo desde la red privada**
- **Bloquear puertos LDAP en cortafuegos** para evitar acceso desde Internet
- Si hay integración externa, permitir solo **IPs autorizadas**

> **👉 Enfoque de Examen SY0-701:** Los distractores típicos son confundir el puerto `389` (LDAP inseguro) con el `636` (LDAPS). CompTIA puede preguntar cuál método de autenticación LDAP es el más seguro en un entorno de Active Directory → Respuesta: **SASL con STARTTLS**. También puede aparecer LDAPS como alternativa correcta.

## Seguridad del Protocolo SNMP

- **SNMP** (Protocolo Simple de Administración de Red) → Marco para administrar y monitorear dispositivos de red
- Compuesto por:
  - **Agentes SNMP**: procesos en switches, routers, servidores
  - **MIB** (Base de Información de Administración): BD de estadísticas del dispositivo
  - **Monitor SNMP**: programa central que sondea a los agentes
- **Puertos:**
  - Consultas → `UDP/161`
  - Traps (capturas/alertas) → `UDP/162`

> **Analogía:** SNMP es como el panel de control de una fábrica — muestra el estado de todas las máquinas. Si alguien hackea ese panel, puede ver (o manipular) toda la operación. SNMPv3 es como blindar ese panel con contraseña y cifrado.

### Versiones de SNMP

| Versión | Seguridad | Características |
|---------|-----------|-----------------|
| **SNMPv1** | ❌ Muy baja | Nombres de comunidad en texto plano |
| **SNMPv2** | ❌ Baja | Mejoras de rendimiento, pero sin cifrado real |
| **SNMPv3** | ✅ Alta | **Cifrado + autenticación basada en usuario**. Mensajes firmados con hash de contraseña |

### Buenas Prácticas SNMP

- Si no se usa SNMP → **desactivarlo**
- Los nombres de comunidad se transmiten en **texto plano** → no usar en redes no confiables
- Usar **nombres de comunidad difíciles de adivinar** (nunca dejar en blanco ni usar valores por defecto)
- Implementar **ACL** (Listas de Control de Acceso) para restringir operaciones a hosts conocidos (1-2 IPs)
- **Usar SNMPv3 siempre que sea posible** y deshabilitar versiones anteriores
- SNMPv3 usa lista de **nombres de usuario con permisos** en lugar de nombres de comunidad

> **👉 Enfoque de Examen SY0-701:** CompTIA pregunta frecuentemente sobre qué versión de SNMP usar → siempre **SNMPv3**. Los puertos `161` y `162` sobre **UDP** son datos de examen. Un distractor común es elegir SNMPv2 como "suficientemente seguro" — no lo es. Si el escenario menciona texto plano o nombres de comunidad visibles, la respuesta es actualizar a **SNMPv3**.

## Servicios de Transferencia de Archivos

> **Analogía:** FTP es como enviar documentos secretos por correo sin sobre y sin seguimiento. SFTP/FTPS es como enviarlos en un maletín blindado con candado y seguimiento GPS.

### FTP (Protocolo de Transferencia de Archivos)

- **FTP** (File Transfer Protocol) → Muy popular, eficiente, multiplataforma
- **Sin seguridad**: autenticación y datos en **texto plano**
- Credenciales fácilmente extraíbles del tráfico interceptado
- **Riesgo**: servidores FTP no autorizados instalados por usuarios (servidores fraudulentos)

### SFTP — SSH FTP (Protocolo Seguro de Transferencia de Archivos)

- **SFTP** (Secure File Transfer Protocol) → Cifra autenticación Y transferencia de datos
- Usa **SSH** sobre el puerto `TCP/22`
- Requiere servidor SSH con soporte SFTP + cliente SFTP
- **No es FTP sobre SSL** — es un protocolo completamente distinto que corre sobre SSH

### FTPS — FTP sobre SSL/TLS

Hay **dos modalidades**:

| Modalidad | Nombre Alternativo | Puerto | Descripción |
|-----------|-------------------|--------|-------------|
| **FTPES** (TLS explícito) | TLS Explícito | `21` → actualiza a TLS con `AUTH TLS` | Conexión inicia insegura, luego se actualiza con comando `AUTH TLS`. También cifra datos con `PROT` |
| **FTPS** (TLS implícito) | TLS Implícito | `990` | Negocia SSL/TLS ANTES de cualquier comando FTP |

> ⚠️ **FTPS es difícil de configurar con cortafuegos** entre cliente y servidor → **FTPES es el método preferido**.

### Tabla Comparativa Final

| Protocolo | Puerto | Seguridad | Mecanismo |
|-----------|--------|-----------|-----------|
| `FTP` | `21` | ❌ Ninguna | Texto plano |
| `SFTP` | `22` | ✅ Alta | SSH |
| `FTPES` | `21` | ✅ Alta | TLS Explícito (`AUTH TLS`) |
| `FTPS` | `990` | ✅ Alta | TLS Implícito |

> **👉 Enfoque de Examen SY0-701:** La distinción entre **SFTP** (SSH, puerto `22`) y **FTPS/FTPES** (TLS, puertos `990`/`21`) es MUY frecuente. CompTIA puede preguntar cuál usar cuando hay cortafuegos → **FTPES** (explícito). También: SFTP NO es "FTP seguro sobre SSL" — es un subsistema SSH independiente. El distractor clásico es confundir FTPS implícito con explícito.

## Servicios de Correo Electrónico

> **Analogía:** SMTP es el cartero que lleva tu carta de una oficina postal a otra. POP3 es el buzón donde tu carta espera hasta que la recoges (y luego desaparece del buzón). IMAP es un casillero inteligente donde puedes leer tu carta desde varios dispositivos sin que desaparezca.

### Dos tipos de protocolos de email:

1. **SMTP** (Protocolo Simple de Transferencia de Correo) → Envío de correo entre servidores
2. **Protocolos de buzón** → Almacenamiento y descarga de mensajes por el cliente

### SMTP Seguro (SMTPS)

- Registro **MX** (Mail Exchanger) en DNS → indica el servidor SMTP del dominio
- Dos formas de usar TLS con SMTP:

| Método | Alias | Descripción |
|--------|-------|-------------|
| **STARTTLS** | TLS Explícito / TLS Oportunista | Actualiza conexión existente no segura a TLS |
| **SMTPS** | TLS Implícito | Establece sesión segura ANTES de cualquier comando SMTP (ej. HELO) |

**Puertos SMTP:**

| Puerto | Uso |
|--------|-----|
| `25` | Retransmisión entre servidores MTA (Mail Transfer Agent). Puede usar STARTTLS |
| `587` | Envío de clientes MSA (Mail Submission Agent). **Debe** usar STARTTLS + autenticación |
| `465` | SMTPS (TLS implícito). **Obsoleto** por los estándares actuales |

### POP3 Seguro (POP3S)

- **POP3** (Protocolo de Oficina de Correo v3) → Descarga mensajes al cliente y los elimina del servidor
- Puerto inseguro: `TCP/110`
- **POP3S** → Puerto `TCP/995` (con TLS)
- Clientes: Microsoft Outlook, Mozilla Thunderbird

### IMAP Seguro (IMAPS)

- **IMAP** (Protocolo de Acceso a Mensajes de Internet) → Acceso permanente al servidor, múltiples clientes simultáneos, gestión de carpetas en servidor
- Puerto inseguro: `TCP/143`
- **IMAPS** → Puerto `TCP/993` (con TLS)

### Tabla Resumen de Puertos de Email

| Protocolo | Puerto Inseguro | Puerto Seguro | Función |
|-----------|----------------|---------------|---------|
| `SMTP` | `25` | `587` (STARTTLS) / `465` (obsoleto) | Envío |
| `POP3` | `110` | `995` | Descarga mensajes (los borra del servidor) |
| `IMAP` | `143` | `993` | Acceso sincronizado a buzón |

> **👉 Enfoque de Examen SY0-701:** Memoriza los puertos de email — son datos muy frecuentes. La distinción clave: **POP3 descarga y borra**, **IMAP sincroniza**. El puerto `587` es para **envío de clientes** (no retransmisión entre servidores). El puerto `465` está **obsoleto**. CompTIA usa esto como distractor frecuente.

## Seguridad del Correo Electrónico: SPF, DKIM, DMARC, S/MIME

El phishing y el spam explotan la falta de verificación del remitente. Tres tecnologías esenciales combaten esto:

> **Analogía:** Imagina que cualquiera puede enviar una carta con tu membrete y tu firma falsificada. SPF, DKIM y DMARC son como un sistema notarial que verifica que la carta realmente vino de ti.

### SPF (Marco de Directivas de Remitente / Sender Policy Framework)

- **¿Qué hace?** Verifica que el servidor que envía el email está **autorizado** por el dominio del remitente
- **¿Cómo?** El dominio del remitente publica en un **registro TXT de DNS** la lista de IPs autorizadas para enviar email
- **¿Quién verifica?** El servidor de correo **receptor** compara la IP del servidor emisor con el registro SPF del dominio

```
Flujo SPF:
Servidor emisor (IP: 1.2.3.4) envía email de @empresa.com
         |
Servidor receptor consulta DNS de empresa.com
         |
DNS devuelve registro TXT SPF: "v=spf1 ip4:1.2.3.4 ~all"
         |
¿Coincide la IP? → SI → Email pasa SPF ✅ | NO → Falla SPF ❌
```

### DKIM (Correo Identificado por Claves de Dominio / DomainKeys Identified Mail)

- **¿Qué hace?** Permite al remitente **firmar digitalmente** los correos para verificar integridad y autenticidad
- **¿Cómo?**
  1. El servidor emisor firma el email con su **clave privada**
  2. Publica su **clave pública** en un registro DNS (tipo TXT)
  3. El servidor receptor usa esa clave pública para verificar la **firma y la integridad** del mensaje

> DKIM garantiza que el contenido del correo **no fue modificado** en tránsito.

### DMARC (Autenticación de Mensajes, Informes y Conformidad Basada en Dominios / Domain-based Message Authentication, Reporting & Conformance)

- **¿Qué hace?** Usa los resultados de SPF y DKIM para **definir qué hacer** con los mensajes que fallen la autenticación
- **Acciones posibles:**
  - **Quarantine** → Mover a carpeta de spam
  - **Reject** → Rechazar el mensaje directamente
  - **None** → Solo monitorear y reportar
- **Capacidad de informes:** El propietario del dominio recibe visibilidad sobre qué sistemas envían correos en su nombre, incluida **actividad no autorizada**
- Se publica también como registro **TXT en DNS**

### Combinación SPF + DKIM + DMARC

```
                    ┌─────────────┐
Email entrante ──►  │  Verificar  │──► SPF: ¿IP autorizada? ✅/❌
                    │   Gateway   │──► DKIM: ¿Firma válida?  ✅/❌
                    └──────┬──────┘
                           ▼
                    ┌─────────────┐
                    │    DMARC    │──► Ambas pasan → Entregar ✅
                    │   Política  │──► Alguna falla → Cuarentena / Rechazar ❌
                    └─────────────┘
```

### Puerta de Enlace de Correo Electrónico (Email Gateway)

- **Punto de control** para todo el tráfico de email entrante y saliente
- Funciones:
  - Filtros anti-spam y antivirus
  - Detección de phishing y URLs maliciosas
  - Análisis de adjuntos
  - **Automatización de SPF, DKIM y DMARC**
  - Aplicación de políticas de contenido y cumplimiento normativo
  - **DLP** (Prevención de Pérdida de Datos): bloqueo de adjuntos, filtrado de contenido

### S/MIME (Extensiones de Correo de Internet Multipropósito/Seguras / Secure/Multipurpose Internet Mail Extensions)

- **Protocolo** para proteger comunicaciones por email
- Usa **cifrado de clave pública** para cifrar el cuerpo del correo
- Incorpora **firmas digitales** para verificar identidad del remitente e integridad del mensaje
- **Ventajas:** Confidencialidad + autenticidad
- **Desventajas:** Implementación complicada, propensa a errores de configuración

> **👉 Enfoque de Examen SY0-701:** Esta es una de las secciones MÁS EXAMINADAS del Tema 11. Debes distinguir claramente: **SPF** verifica la IP del servidor emisor (en DNS TXT), **DKIM** firma el contenido (firma digital), **DMARC** define la política de acción y reporta. Los distractores más comunes: confundir DKIM con SPF, o pensar que SPF verifica el contenido (no lo hace, solo verifica la IP). **S/MIME** cifra el cuerpo del email y usa firmas digitales — no confundir con TLS que cifra el canal.

## Prevención de Pérdida de Datos por Correo Electrónico (DLP)

- **DLP** (Prevención de Pérdida de Datos / Data Loss Prevention) → Tecnología para evitar la difusión no autorizada de información confidencial

> **Analogía:** DLP en email es como un guardia de seguridad en la salida de una empresa que revisa cada paquete que sale para asegurarse de que nadie está sacando documentos confidenciales sin autorización.

### ¿Por qué el correo electrónico es un vector crítico de pérdida de datos?

- Es el canal de comunicación más usado en las organizaciones
- Transporta datos sensibles: **PII** (Información Personal Identificable), datos financieros, propiedad intelectual
- Errores humanos son comunes (destinatario incorrecto, adjuntos no cifrados)
- **Amenazas internas**: empleados maliciosos o descuidados
- Regulaciones que exigen protección: **GDPR**, **HIPAA**, **PCI DSS**

### Cómo funciona DLP en Email

```
Email saliente con adjunto o contenido
         |
Sistema DLP escanea el mensaje:
  ├── ¿Contiene número de tarjeta de crédito? → Bloquear / Cifrar
  ├── ¿Contiene número de seguro social? → Alertar al admin
  ├── ¿Contiene propiedad intelectual? → Bloquear
  └── ¿Todo OK? → Permitir envío
```

### Acciones posibles del sistema DLP

- **Bloquear** el correo electrónico
- **Alertar** al remitente o administrador
- **Cifrar automáticamente** antes de la transmisión
- **Registrar** el intento para auditoría

### Implementación

- A través de **puertas de enlace de correo electrónico**
- Mediante **políticas de seguridad en herramientas de protección de endpoints**

> **👉 Enfoque de Examen SY0-701:** CompTIA puede preguntar qué tecnología controla que información confidencial no salga por email → **DLP**. Recuerda los marcos regulatorios asociados: **GDPR** (privacidad europea), **HIPAA** (salud en EE.UU.), **PCI DSS** (datos de tarjetas de pago). El distractor clásico es confundir DLP con un antivirus — el antivirus detecta malware, DLP detecta **fuga de datos**.

## Filtrado de DNS y DNSSEC

- **DNS** (Sistema de Nombres de Dominio) → Traduce nombres de dominio en direcciones IP
- El **filtrado DNS** bloquea o permite dominios en el momento de la resolución de nombres
- Si un dominio está en la lista negra → se bloquea la resolución → el usuario no puede acceder

> **Analogía:** El filtrado DNS es como un recepcionista que, antes de dejarte entrar a un edificio, verifica en una lista negra si ese edificio es peligroso. Si está en la lista, te bloquea el paso antes de que puedas acercarte.

### Ventajas del Filtrado DNS

- **Defensa proactiva**: bloquea sitios de phishing, malware y distribución antes del acceso
- **Cumplimiento de AUP** (Políticas de Uso Aceptable): bloquea sitios inapropiados
- **Protege dispositivos IoT** (Internet de las Cosas) conectados a la red
- **Simple y rentable**: fácil de implementar, bajo riesgo, válido para cualquier tamaño de red
- **Debe combinarse** con otras medidas de seguridad (defensa en profundidad)

### Métodos de Implementación del Filtrado DNS

| Método | Ejemplos | Ventajas |
|--------|---------|---------|
| **Servicios externos de filtrado DNS** | OpenDNS (Cisco), Quad9, CleanBrowsing | Fácil, solo redirigir solicitudes DNS al servicio |
| **Servidores DNS propios** | Microsoft DNS, BIND | Control total, integración de listas RPZ (Response Policy Zone) |
| **Cortafuegos DNS** | A nivel de red | Intercepta consultas DNS y aplica reglas |
| **Herramientas endpoint** | Antivirus con filtrado DNS | Protección a nivel de dispositivo (portátiles, móviles) |
| **Software de código abierto** | Pi-hole, AdGuard Home | Se ejecuta en Linux (Raspberry Pi), solucionador DNS local con filtrado |

### Seguridad DNS (Más allá del Filtrado)

**Amenazas al DNS:**

| Amenaza | Descripción |
|---------|-------------|
| **DoS al servidor DNS** | Interrumpir el servicio de resolución de nombres |
| **Footprinting DNS** | Obtener info sobre la red privada via transferencias de zona o consultas con `nslookup`/`dig` |
| **Envenenamiento DNS** (DNS Poisoning) | Insertar registros falsos para redirigir tráfico |
| **Suplantación DNS** (DNS Spoofing) | Respuestas falsas de DNS |

**Medidas de Seguridad DNS:**

- Servidores DNS locales solo aceptan **consultas recurrentes de hosts locales autenticados**
- **ACL** para evitar modificación manual de registros
- Clientes limitados a **solucionadores autorizados**
- **BIND** (Berkeley Internet Name Domain) → parchear a la última versión (ISC - isc.org)
- **ACL para transferencias de zona** → solo a DNS secundarios autorizados (evitar footprinting)

### DNSSEC (Extensiones de Seguridad de DNS / DNS Security Extensions)

**¿Qué hace DNSSEC?**

Mitiga ataques de **suplantación y envenenamiento** al validar criptográficamente las respuestas DNS.

**Funcionamiento de DNSSEC:**

```
Servidor autoritativo de la zona
         |
Crea RRset (Resource Record Set) con registros DNS
         |
Firma el RRset con la CLAVE PRIVADA de Firma de Zona (ZSK - Zone Signing Key)
         |
Cuando otro servidor solicita registros seguros:
         |
Devuelve RRset + Clave pública ZSK
         |
El receptor verifica la firma → Integridad confirmada ✅
```

**Cadena de confianza DNSSEC:**

```
Servidores Raíz DNS (auto-validados, firma M-de-N)
         │
Registros Regionales de Internet
         │
Dominios de Nivel Superior (.com, .org, etc.)
         │
Dominio específico (empresa.com)
         │
Subdominios (mail.empresa.com)
```

**Dos tipos de claves en DNSSEC:**

| Clave | Nombre | Función |
|-------|--------|---------|
| **ZSK** | Zone Signing Key (Clave de Firma de Zona) | Firma los registros de recursos (RRset) |
| **KSK** | Key Signing Key (Clave de Firma de Clave) | Firma la clave ZSK pública. Si la ZSK se compromete, la KSK permite revocarla y emitir una nueva sin interrumpir el servicio |

> Se usan claves separadas ZSK/KSK para que, si la ZSK se ve comprometida, el dominio pueda seguir funcionando de forma segura.

> **Analogía:** DNSSEC es como un sistema de sellos y certificados notariales en la guía telefónica DNS — cada entrada está firmada y verificada en una cadena de confianza desde la raíz hasta el subdominio.

> **👉 Enfoque de Examen SY0-701:** DNSSEC es una pregunta recurrente. Memoriza: protege contra **envenenamiento y suplantación DNS** mediante **firmas criptográficas**. La **cadena de confianza** va desde los servidores raíz hasta los subdominios. El distractor habitual es confundir DNSSEC con filtrado DNS — **DNSSEC valida la autenticidad de las respuestas DNS**; **el filtrado DNS bloquea dominios maliciosos**. Son complementarios, no lo mismo. También: BIND → parchear siempre.


# 2. Conceptos de Seguridad en la Nube y en las Aplicaciones Web

**Estrategia de defensa en capas:**
- **Endurecimiento de la nube** (Cloud Hardening): fortalecer la infraestructura, reducir superficie de ataque
- **Seguridad de aplicaciones**: diseño, desarrollo e implementación seguros del software

Ambas soportan el **modelo de responsabilidad compartida** en la nube:
- **Proveedor de nube (CSP)**: responsable de la infraestructura
- **Cliente**: responsable de sus datos y aplicaciones

> **Objetivo de Examen cubierto: 4.1** — A partir de un escenario, aplicar técnicas comunes de seguridad a los recursos computacionales.


## Técnicas de Codificación Segura

**El problema del desarrollo tradicional:**
- La presión por lanzar supera los requisitos de seguridad
- Los modelos legacy se centraban en: funcionalidad, rendimiento, costo
- Las prácticas modernas usan un **SDLC de Seguridad** (Ciclo de Vida de Desarrollo Seguro) en paralelo o integrado

**Marcos de referencia:**
- **SDL de Microsoft** → microsoft.com/en-us/securityengineering/sdl
- **OWASP SAMM** (Software Assurance Maturity Model) → owasp.org/www-project-samm
- **OWASP SKF** (Security Knowledge Framework)
- **OWASP Top 10** → Lista de las 10 vulnerabilidades más críticas en aplicaciones web

> **Analogía:** El desarrollo de software sin seguridad es como construir un banco sin caja fuerte porque "el arquitecto tiene prisa". El SDLC de seguridad es como integrar la caja fuerte en los planos desde el inicio, no añadirla al final como un afterthought.

### Validación de Entradas

- **Entrada no confiable**: datos especialmente diseñados por un atacante para manipular el comportamiento de la aplicación
- **Sin validación** → vulnerable a inyección SQL, XSS (Cross-Site Scripting / Secuencias de Comandos entre Sitios), inyección de código, etc.

| Método de Validación | Descripción |
|---------------------|-------------|
| **Lista de permitidos** (Allowlist) | Solo acepta entradas que coincidan con un conjunto aprobado de valores/patrones. Más seguro |
| **Lista de bloqueados** (Blocklist) | Bloquea entradas dañinas conocidas (caracteres especiales, patrones maliciosos) |
| **Verificaciones de tipo de dato** | Garantizan que la entrada sea del tipo esperado (string, entero, fecha) |
| **Verificaciones de rango** | Validan que valores numéricos estén dentro del rango esperado |
| **Expresiones regulares (Regex)** | Coincidencia de patrones esperados o detección de actividad maliciosa |
| **Codificación** | Evita que caracteres especiales se interpreten como comandos ejecutables |

> **Analogía:** La validación de entradas es como un portero de discoteca — solo deja pasar a quien cumple los requisitos. Si alguien intenta entrar con un traje de arma (código malicioso), el portero lo detiene antes de que cause problemas.

### Cookies Seguras

Las cookies pueden explotarse mediante:
- **Secuestro de sesión** (Session Hijacking)
- **XSS** (Cross-Site Scripting)
- **CSRF** (Cross-Site Request Forgery / Falsificación de Solicitudes entre Sitios)

**Atributos de cookies seguras:**

| Atributo | Función | Protege contra |
|----------|---------|----------------|
| `Secure` | Solo se envía por HTTPS | Interceptación/espionaje |
| `HttpOnly` | Scripts del cliente no pueden acceder a la cookie | Ataques XSS |
| `SameSite` | Limita cuándo se envía la cookie en solicitudes cross-site | Ataques CSRF |
| **Tiempo de caducidad** | Limita la vida útil de la cookie | Robo de sesiones antiguas |

> **Analogía:** Una cookie de sesión es como el brazalete de un festival — permite moverte entre áreas sin volver a identificarte. Si alguien te roba el brazalete (cookie), puede hacerse pasar por ti.

### Análisis de Código Estático (SAST)

- **SAST** (Static Application Security Testing / Pruebas de Seguridad de Aplicaciones Estáticas) → Examina el código fuente SIN ejecutarlo
- **Objetivo:** Detectar vulnerabilidades, errores y malas prácticas en etapas tempranas del SDLC
- **Ventajas:** Detección temprana = corrección más barata, educación de desarrolladores
- **Herramientas comunes:** SonarQube, Coverity, Fortify (OpenText)
- Se complementa con **DAST** (Dynamic Application Security Testing / Pruebas Dinámicas) que prueba la app en ejecución

| Tipo | Cuándo se ejecuta | Qué analiza |
|------|------------------|-------------|
| **SAST** | En el código fuente (antes de compilar) | Código estático, sin ejecutar |
| **DAST** | En la aplicación en ejecución | Comportamiento dinámico, entradas/salidas |

> **Analogía:** SAST es como revisar los planos de un edificio antes de construirlo para detectar defectos estructurales — mucho más barato que demoler y reconstruir después.

### Firma de Código (Code Signing)

**¿Qué hace?**
1. El firmante calcula un **hash del código**
2. Cifra el hash con su **clave privada** → firma digital
3. Se incluye la firma + identidad del firmante
4. Requiere **certificado de CA** (Autoridad Certificadora) de confianza
5. El receptor verifica la firma con la **clave pública** del certificado

**Propósitos:**
- Verifica que el software **no fue modificado** desde su firma
- Confirma la **identidad del editor**
- Permite bloquear software no confiable
- Genera confianza en la distribución de software

**⚠️ LIMITACIÓN IMPORTANTE:**
> La firma de código **NO garantiza la seguridad del código en sí**. El código firmado puede contener errores, vulnerabilidades o código malicioso insertado por el autor original. Solo garantiza la **fuente** y la **integridad**, no la **calidad** ni la **seguridad**.

> **Analogía:** La firma de código es como el sello notarial en un documento legal — garantiza que el documento viene de quien dice y que no ha sido alterado. Pero no garantiza que el contenido del documento sea honesto.

> **👉 Enfoque de Examen SY0-701:** SAST vs DAST es una distinción frecuente. La firma de código es una pregunta de concepto clásica — el distractor más común es asumir que código firmado = código seguro (FALSO). Sobre validación de entradas: la **lista de permitidos** (allowlist) es SIEMPRE más segura que la lista de bloqueados (blocklist). Recuerda también los atributos de cookies: `HttpOnly` → anti-XSS, `SameSite` → anti-CSRF, `Secure` → solo HTTPS.

## Protección de Aplicaciones

### Exposición de Datos

- **Exposición de datos**: falla que permite leer información privilegiada (tokens, contraseñas, datos personales) sin los controles de acceso correctos
- Las aplicaciones solo deben transmitir datos sensibles **entre hosts autenticados** y mediante **criptografía**
- Usar **bibliotecas de cifrado estándar de la industria** (no desarrolladas internamente)

### Gestión de Errores

- La aplicación debe manejar errores de forma **controlada** (no colapsar exponiendo información)
- **SEH** (Structured Exception Handler / Controlador Estructurado de Excepciones): determina qué hacer ante condiciones inesperadas
- Cada procedimiento puede tener múltiples controladores de excepciones + un **catchall** (controlador general)
- **Objetivo principal**: que la app no falle de forma que permita **inyección de código**
- **Evitar mensajes de error predeterminados** que revelen información de la plataforma (usar controladores personalizados)
- Ejemplo infame: bug **GoTo de Apple** (2014)

| Concepto | Definición |
|----------|-----------|
| **Error** | Condición de la que el proceso no puede recuperarse (ej.: sistema sin memoria) |
| **Excepción** | Tipo de error que puede ser abordado por un bloque de código sin que el proceso colapse |

> **Analogía:** Un buen manejador de errores es como un empleado entrenado para no revelar información confidencial cuando algo sale mal. El mal manejador de errores es como un empleado que, cuando se equivoca, grita todos los secretos de la empresa en voz alta.

### Gestión de Memoria

- Muchos ataques de **código arbitrario** explotan una gestión de memoria defectuosa
- El atacante puede ejecutar su propio código en el espacio de memoria de la aplicación
- Prácticas:
  - Evitar prácticas no seguras conocidas de gestión de memoria
  - Validar cadenas y entradas no confiables para evitar sobreescritura de áreas de memoria (buffer overflow)

### Validación del Lado del Cliente vs. del Servidor

| Aspecto | Lado del Cliente | Lado del Servidor |
|---------|-----------------|------------------|
| **Dónde se ejecuta** | En el navegador del usuario | En el servidor remoto |
| **Ejemplo** | Scripts DOM para render dinámico | Validación en base de datos |
| **Problema principal** | Más vulnerable a malware que interfiera con la validación | Puede ser lento (múltiples transacciones) |
| **Uso recomendado** | Informar al usuario de errores ANTES de enviar | Validación definitiva antes de aceptar datos |
| **¿Es suficiente solo con esto?** | ❌ NO — mala práctica | ✅ Siempre necesario |

> **Regla:** La validación en el lado del cliente es un complemento de UX (experiencia de usuario), NUNCA un sustituto de la validación en el servidor. **Confiar solo en la validación del lado del cliente es una mala práctica de programación.**

### Seguridad de Aplicaciones en la Nube (Cloud Hardening)

Prácticas de **endurecimiento de la nube:**

- **Políticas de mínimo privilegio**: solo los permisos mínimos necesarios para cada tarea
- **Cifrado** de datos en tránsito y en reposo
- **Auditorías periódicas** y monitoreo continuo
- **Evaluaciones de vulnerabilidades** y **pruebas de penetración** regulares

### Capacidades de Monitoreo

Las prácticas de codificación segura también mejoran el **registro y monitoreo**:

- **Registro integral**: capturar eventos y actividades importantes (auditoría, respuesta a incidentes, resolución de problemas)
- **Gestión robusta de errores**: ocultar información de depuración para no filtrarlo a atacantes
- **Alertas en tiempo real**: código que dispara alertas ante eventos específicos:
  - Intentos repetidos de inicio de sesión fallidos
  - Transferencias de datos inusuales
- Estas alertas son **indicadores de posibles brechas** y son cruciales para los equipos de respuesta a incidentes

> **Analogía:** El código con capacidades de monitoreo es como un edificio con cámaras de seguridad, sensores de movimiento y alarmas integradas desde la construcción — mucho más efectivo que instalar una cámara barata en la entrada después de un robo.

> **👉 Enfoque de Examen SY0-701:** La validación cliente vs. servidor es un tema clásico — siempre se necesita validación del servidor. La gestión de errores es importante: los mensajes de error detallados son una vulnerabilidad. Sobre cloud hardening: el **modelo de responsabilidad compartida** es clave — el CSP protege la infraestructura, el cliente protege sus datos y aplicaciones. SAST + DAST van juntos en el ciclo de desarrollo seguro.

## Sandboxing de Software

- **Sandboxing** (Aislamiento de Procesos): mecanismo de seguridad que **aísla** los procesos en ejecución entre sí y del sistema operativo subyacente
- Un **sandbox** es un entorno de ejecución con **acceso sumamente restrictivo**
- Reduce el impacto del software malicioso o defectuoso

> **Analogía:** Un sandbox (caja de arena) es como una sala de cuarentena de un hospital. Si un paciente contagioso entra a esa sala, sus gérmenes no pueden salir al resto del hospital. El software malicioso en un sandbox puede hacer lo que quiera dentro, pero no puede afectar al sistema real.

### Ejemplos Prácticos de Sandboxing

| Contexto | Ejemplo | Cómo funciona |
|----------|---------|---------------|
| **Navegadores web** | Google Chrome | Cada pestaña y extensión en procesos aislados. Código malicioso en una pestaña no afecta al navegador ni al SO |
| **Sistemas operativos móviles** | iOS, Android | Cada app en su propio sandbox. Solo puede acceder a sus datos y recursos propios sin permiso explícito |
| **Máquinas Virtuales (VM)** | VMware, VirtualBox | Cada VM aislada del host y entre sí. Una brecha en una VM no afecta a las demás |
| **Contenedores** | Docker | Aislamiento a nivel de proceso, separados del host |

### Sandboxing en Operaciones de Seguridad

- Las herramientas de sandboxing son críticas para **análisis forense de malware**
- Crean un entorno cerrado y controlado para la **ejecución segura** (también llamada **detonación**) de software potencialmente dañino
- Permiten analizar comportamiento sin comprometer el entorno de TI real

**Herramientas de Sandboxing:**

| Herramienta | Tipo | Características |
|-------------|------|-----------------|
| **Cuckoo Sandbox** | Código abierto | Ejecuta archivos en entorno aislado, analiza y registra: llamadas al sistema, tráfico de red, etc. |
| **Joe Sandbox** | Comercial/Web | Accesible vía navegador, sin instalación local. Usa ML (Machine Learning / Aprendizaje Automático) para análisis avanzado |

> **👉 Enfoque de Examen SY0-701:** El sandboxing aparece en preguntas sobre respuesta a incidentes y análisis de malware. La palabra clave es **"detonación"** — ejecutar malware de forma controlada para analizarlo. Recuerda: Chrome usa sandboxing por pestañas, iOS/Android usan sandboxing por apps. El distractor clásico es confundir una VM con un sandbox — las VMs pueden usarse como sandbox, pero el sandboxing es un concepto más amplio. Cuckoo Sandbox = código abierto; Joe Sandbox = comercial basado en web.

# 3. Tabla Puertos y Protocolos

| Protocolo | Puerto Inseguro | Puerto Seguro | Mecanismo de Seguridad |
|-----------|----------------|---------------|----------------------|
| `HTTP` | `80` | `443` (HTTPS) | TLS |
| `Telnet` | `23` | `22` (SSH) | Cifrado SSH |
| `FTP` | `21` | `22` (SFTP) / `990` (FTPS) | SSH / TLS |
| `SMTP` (retransmisión) | `25` | `25` + STARTTLS | TLS Explícito |
| `SMTP` (envío cliente) | — | `587` + STARTTLS | TLS Explícito |
| `SMTP` (implícito, obsoleto) | — | `465` | TLS Implícito |
| `POP3` | `110` | `995` (POP3S) | TLS |
| `IMAP` | `143` | `993` (IMAPS) | TLS |
| `LDAP` | `389` | `636` (LDAPS) | TLS |
| `SNMP` (consultas) | `161/UDP` | `161/UDP` (SNMPv3) | Autenticación + Cifrado |
| `SNMP` (traps) | `162/UDP` | `162/UDP` (SNMPv3) | Autenticación + Cifrado |

# 4. Tabla Seguridad de Email

| Tecnología | Qué verifica | Dónde se publica | Acción |
|-----------|-------------|-----------------|--------|
| **SPF** | IP del servidor emisor autorizada | Registro TXT DNS | Permite/falla |
| **DKIM** | Integridad y autenticidad del mensaje (firma digital) | Registro TXT DNS (clave pública) | Permite/falla |
| **DMARC** | Usa resultados de SPF + DKIM para definir política | Registro TXT DNS | Cuarentena / Rechazar / Reportar |
| **S/MIME** | Cifra el cuerpo del mensaje y firma digitalmente | Certificados PKI | Cifrado + Autenticación |
| **DLP** | Contenido sensible en el mensaje | Gateway de email / Endpoint | Bloquear / Alertar / Cifrar |

# 5. GLOSARIO

| Acrónimo | Significado |
|----------|-------------|
| **HTTPS** | HyperText Transfer Protocol Secure (Protocolo de Transferencia de Hipertexto Seguro) |
| **TLS** | Transport Layer Security (Seguridad de la Capa de Transporte) |
| **SSL** | Secure Sockets Layer (Capa de Sockets Seguro) |
| **SSH** | Secure Shell (Intérprete de Comandos Seguro) |
| **SFTP** | SSH File Transfer Protocol (Protocolo de Transferencia de Archivos SSH) |
| **FTPS** | FTP Secure / FTP sobre SSL (TLS Implícito) |
| **FTPES** | FTP Explicit Security (FTP con TLS Explícito) |
| **LDAP** | Lightweight Directory Access Protocol (Protocolo Ligero de Acceso a Directorios) |
| **LDAPS** | LDAP Secure (LDAP Seguro) |
| **SASL** | Simple Authentication and Security Layer (Capa de Autenticación y Seguridad Simple) |
| **SNMP** | Simple Network Management Protocol (Protocolo Simple de Administración de Red) |
| **MIB** | Management Information Base (Base de Información de Administración) |
| **SMTP** | Simple Mail Transfer Protocol (Protocolo Simple de Transferencia de Correo) |
| **MTA** | Mail Transfer Agent (Agente de Transferencia de Mensajes) |
| **MSA** | Mail Submission Agent (Agente de Envío de Mensajes) |
| **POP3** | Post Office Protocol v3 (Protocolo de Oficina de Correo v3) |
| **IMAP** | Internet Message Access Protocol (Protocolo de Acceso a Mensajes de Internet) |
| **SPF** | Sender Policy Framework (Marco de Directivas de Remitente) |
| **DKIM** | DomainKeys Identified Mail (Correo Identificado por Claves de Dominio) |
| **DMARC** | Domain-based Message Authentication, Reporting & Conformance (Autenticación de Mensajes, Informes y Conformidad Basada en Dominios) |
| **S/MIME** | Secure/Multipurpose Internet Mail Extensions (Extensiones de Correo de Internet Multipropósito/Seguras) |
| **DLP** | Data Loss Prevention (Prevención de Pérdida de Datos) |
| **PII** | Personally Identifiable Information (Información Personal Identificable) |
| **DNS** | Domain Name System (Sistema de Nombres de Dominio) |
| **DNSSEC** | DNS Security Extensions (Extensiones de Seguridad de DNS) |
| **RPZ** | Response Policy Zone (Zona de Política de Respuesta) |
| **BIND** | Berkeley Internet Name Domain |
| **AUP** | Acceptable Use Policy (Política de Uso Aceptable) |
| **SAST** | Static Application Security Testing (Pruebas de Seguridad de Aplicaciones Estáticas) |
| **DAST** | Dynamic Application Security Testing (Pruebas de Seguridad de Aplicaciones Dinámicas) |
| **SDLC** | Software Development Lifecycle (Ciclo de Vida de Desarrollo de Software) |
| **SEH** | Structured Exception Handler (Controlador Estructurado de Excepciones) |
| **OWASP** | Open Web Application Security Project |
| **XSS** | Cross-Site Scripting (Secuencias de Comandos entre Sitios) |
| **CSRF** | Cross-Site Request Forgery (Falsificación de Solicitudes entre Sitios) |
| **DOM** | Document Object Model (Modelo de Objetos de Documento) |
| **CA** | Certificate Authority (Autoridad Certificadora) |
| **ZSK** | Zone Signing Key (Clave de Firma de Zona) |
| **KSK** | Key Signing Key (Clave de Firma de Clave) |
| **HKDF** | HMAC-based Key Derivation Function (Función de Derivación de Clave Basada en HMAC) |
| **ECDHE** | Elliptic Curve Diffie-Hellman Ephemeral (Diffie-Hellman de Curva Elíptica Efímero) |
| **TCP** | Transmission Control Protocol (Protocolo de Control de Transmisión) |
| **UDP** | User Datagram Protocol (Protocolo de Datagrama de Usuario) |
| **VPN** | Virtual Private Network (Red Privada Virtual) |
| **IoT** | Internet of Things (Internet de las Cosas) |
| **VM** | Virtual Machine (Máquina Virtual) |
| **ML** | Machine Learning (Aprendizaje Automático) |
| **ACL** | Access Control List (Lista de Control de Acceso) |
| **MX** | Mail Exchanger (Intercambiador de Correo) |
| **GDPR** | General Data Protection Regulation (Reglamento General de Protección de Datos) |
| **HIPAA** | Health Insurance Portability and Accountability Act |
| **PCI DSS** | Payment Card Industry Data Security Standard |