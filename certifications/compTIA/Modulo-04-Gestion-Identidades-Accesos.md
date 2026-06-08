> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Autenticación](#1-autenticación)
  - [Arquitectura básica del proceso de autenticación](#arquitectura-básica-del-proceso-de-autenticación)
  - [Diseño de Autenticación](#diseño-de-autenticación)
    - [Los factores de autenticación](#los-factores-de-autenticación)
  - [Conceptos sobre Contraseñas](#conceptos-sobre-contraseñas)
    - [Componentes de una política de contraseñas sólida](#componentes-de-una-política-de-contraseñas-sólida)
    - [Distinción clave: Antigüedad vs. Caducidad](#distinción-clave-antigüedad-vs-caducidad)
    - [Nota NIST (National Institute of Standards and Technology)](#nota-nist-national-institute-of-standards-and-technology)
  - [Administradores de Contraseñas](#administradores-de-contraseñas)
    - [Flujo de funcionamiento de un administrador de contraseñas](#flujo-de-funcionamiento-de-un-administrador-de-contraseñas)
    - [Riesgos principales de los administradores de contraseñas](#riesgos-principales-de-los-administradores-de-contraseñas)
  - [Autenticación de Multifactores (MFA)](#autenticación-de-multifactores-mfa)
    - [Regla de oro de MFA](#regla-de-oro-de-mfa)
    - [2FA (Two-Factor Authentication) vs. MFA](#2fa-two-factor-authentication-vs-mfa)
    - [Factor de ubicación — Casos de uso](#factor-de-ubicación--casos-de-uso)
  - [Autenticación Biométrica](#autenticación-biométrica)
    - [Proceso de configuración biométrica](#proceso-de-configuración-biométrica)
    - [Métricas de rendimiento biométrico](#métricas-de-rendimiento-biométrico)
    - [Regla de oro de las métricas](#regla-de-oro-de-las-métricas)
    - [Tipos de biometría](#tipos-de-biometría)
    - [Consideraciones adicionales](#consideraciones-adicionales)
  - [Tokens de Autenticación Físicos](#tokens-de-autenticación-físicos)
    - [Tres tipos de generación de tokens](#tres-tipos-de-generación-de-tokens)
    - [TOTP vs. HOTP](#totp-vs-hotp)
    - [Tipos de autenticadores físicos](#tipos-de-autenticadores-físicos)
    - [Tokens estáticos — Riesgo crítico](#tokens-estáticos--riesgo-crítico)
  - [Tokens de Autenticación Blandos](#tokens-de-autenticación-blandos)
    - [Métodos de entrega de tokens blandos](#métodos-de-entrega-de-tokens-blandos)
    - [Flujo de la aplicación autenticadora](#flujo-de-la-aplicación-autenticadora)
  - [Autenticación Sin Contraseña](#autenticación-sin-contraseña)
    - [FIDO2 y WebAuthn — El estándar](#fido2-y-webauthn--el-estándar)
    - [Flujo de autenticación sin contraseña (FIDO2/WebAuthn)](#flujo-de-autenticación-sin-contraseña-fido2webauthn)
    - [FIDO U2F vs. FIDO2/WebAuthn](#fido-u2f-vs-fido2webauthn)
    - [Attestation (Ratificación)](#attestation-ratificación)
- [2. Autorización](#2-autorización)
  - [Control de Acceso Discrecional y Obligatorio](#control-de-acceso-discrecional-y-obligatorio)
    - [DAC — Discretionary Access Control (Control de Acceso Discrecional)](#dac--discretionary-access-control-control-de-acceso-discrecional)
    - [MAC — Mandatory Access Control (Control de Acceso Obligatorio)](#mac--mandatory-access-control-control-de-acceso-obligatorio)
    - [DAC vs. MAC — Tabla Comparativa](#dac-vs-mac--tabla-comparativa)
  - [Control de Acceso Basado en Funciones y Atributos](#control-de-acceso-basado-en-funciones-y-atributos)
    - [RBAC — Role-Based Access Control (Control de Acceso Basado en Funciones)](#rbac--role-based-access-control-control-de-acceso-basado-en-funciones)
    - [Grupos de seguridad como implementación de RBAC](#grupos-de-seguridad-como-implementación-de-rbac)
    - [ABAC — Attribute-Based Access Control (Control de Acceso Basado en Atributos)](#abac--attribute-based-access-control-control-de-acceso-basado-en-atributos)
    - [Control M de N](#control-m-de-n)
      - [RBAC vs. ABAC — Comparativa](#rbac-vs-abac--comparativa)
  - [Control de Acceso Basado en Reglas](#control-de-acceso-basado-en-reglas)
    - [Acceso Condicional](#acceso-condicional)
  - [Asignaciones de Permisos de Mínimo Privilegio](#asignaciones-de-permisos-de-mínimo-privilegio)
    - [¿Por qué es importante?](#por-qué-es-importante)
    - [Desafíos de implementación](#desafíos-de-implementación)
    - [Acumulación de autorizaciones (Privilege Creep)](#acumulación-de-autorizaciones-privilege-creep)
  - [Aprovisionamiento de Cuentas de Usuario](#aprovisionamiento-de-cuentas-de-usuario)
    - [Pasos del aprovisionamiento de una cuenta de usuario](#pasos-del-aprovisionamiento-de-una-cuenta-de-usuario)
    - [Desaprovisionamiento](#desaprovisionamiento)
  - [Atributos de Cuenta y Políticas de Acceso](#atributos-de-cuenta-y-políticas-de-acceso)
    - [Componentes de una cuenta de usuario](#componentes-de-una-cuenta-de-usuario)
    - [Permisos y políticas de acceso](#permisos-y-políticas-de-acceso)
    - [GPO — Group Policy Objects (Objetos de Directiva de Grupo) en Windows](#gpo--group-policy-objects-objetos-de-directiva-de-grupo-en-windows)
  - [Restricciones de la Cuenta](#restricciones-de-la-cuenta)
    - [Políticas basadas en la ubicación](#políticas-basadas-en-la-ubicación)
    - [Políticas basadas en el tiempo](#políticas-basadas-en-el-tiempo)
  - [Administración de Acceso con Privilegios (PAM)](#administración-de-acceso-con-privilegios-pam)
    - [Tipos de cuentas por nivel de privilegio](#tipos-de-cuentas-por-nivel-de-privilegio)
    - [PAM — Privileged Access Management (Administración de Acceso Privilegiado)](#pam--privileged-access-management-administración-de-acceso-privilegiado)
    - [Buenas prácticas de PAM](#buenas-prácticas-de-pam)
    - [JIT — Just-in-Time Permissions (Permisos Justo a Tiempo)](#jit--just-in-time-permissions-permisos-justo-a-tiempo)
    - [Tres modelos de implementación de JIT/ZSP](#tres-modelos-de-implementación-de-jitzsp)
- [3. Administración de Identidades](#3-administración-de-identidades)
  - [Autenticación Local, de Red y Remota](#autenticación-local-de-red-y-remota)
    - [Principio base: almacenamiento de credenciales](#principio-base-almacenamiento-de-credenciales)
    - [Autenticación en Windows](#autenticación-en-windows)
    - [Autenticación en Linux](#autenticación-en-linux)
  - [Servicios de Directorio](#servicios-de-directorio)
    - [LDAP — Lightweight Directory Access Protocol (Protocolo Ligero de Acceso a Directorios)](#ldap--lightweight-directory-access-protocol-protocolo-ligero-de-acceso-a-directorios)
    - [Estructura de nombres en LDAP (basada en X.500)](#estructura-de-nombres-en-ldap-basada-en-x500)
  - [Autenticación de Inicio de Sesión Único (SSO) — Kerberos](#autenticación-de-inicio-de-sesión-único-sso--kerberos)
    - [Kerberos — El guardián de tres cabezas](#kerberos--el-guardián-de-tres-cabezas)
    - [Los dos servicios del KDC](#los-dos-servicios-del-kdc)
    - [Fase 1 — Autenticación con el KDC (obtención del TGT)](#fase-1--autenticación-con-el-kdc-obtención-del-tgt)
  - [Autorización de Inicio de Sesión Único (Kerberos TGS)](#autorización-de-inicio-de-sesión-único-kerberos-tgs)
    - [Fase 2 — Autorización con el TGS (obtención del ticket de servicio)](#fase-2--autorización-con-el-tgs-obtención-del-ticket-de-servicio)
    - [Punto débil de Kerberos](#punto-débil-de-kerberos)
  - [Federation (Federación de Identidades)](#federation-federación-de-identidades)
    - [¿Qué es la Federación?](#qué-es-la-federación)
    - [Por qué Kerberos/LDAP no es suficiente para la federación](#por-qué-kerberosldap-no-es-suficiente-para-la-federación)
    - [Terminología de federación](#terminología-de-federación)
    - [Flujo de autenticación federada](#flujo-de-autenticación-federada)
  - [SAML (Security Assertion Markup Language)](#saml-security-assertion-markup-language)
    - [¿Qué es SAML?](#qué-es-saml)
    - [Ejemplo de implementación SAML](#ejemplo-de-implementación-saml)
    - [Estructura básica de una respuesta SAML (XML)](#estructura-básica-de-una-respuesta-saml-xml)
    - [Características técnicas de SAML](#características-técnicas-de-saml)
  - [OAuth (Open Authorization)](#oauth-open-authorization)
    - [El contexto: APIs RESTful vs. SOAP](#el-contexto-apis-restful-vs-soap)
    - [¿Qué es OAuth?](#qué-es-oauth)
    - [Actores en OAuth](#actores-en-oauth)
    - [Flujo básico de OAuth](#flujo-básico-de-oauth)
    - [JWT — JSON Web Token](#jwt--json-web-token)
    - [SAML vs. OAuth — Comparativa Maestra](#saml-vs-oauth--comparativa-maestra)
- [4. Tabla Maestra de Comparación de Modelos de Control de Acceso](#4-tabla-maestra-de-comparación-de-modelos-de-control-de-acceso)
- [5. Glosario](#5-glosario)

---

# 1. Autenticación
 
> **Concepto clave:** La autenticación verifica que **solo el titular legítimo de una cuenta** pueda utilizarla. Es diferente de la autorización (qué puede hacer una vez dentro).
 
## Arquitectura básica del proceso de autenticación
 
```
Solicitante (Demandante)  →  Credenciales  →  Servidor de Autenticación
                                                       ↓
                                          Compara con copia almacenada
                                                       ↓
                                          ✅ Coincide → Acceso concedido
                                          ❌ No coincide → Acceso denegado
```
 
## Diseño de Autenticación
 
**Tres pilares del diseño de autenticación (triada CIA aplicada):**
 
| Pilar | Aplicación en Autenticación |
|---|---|
| **Confidencialidad** | Si se filtran credenciales, un atacante puede suplantar al titular |
| **Integridad** | El mecanismo debe ser fiable; difícil de eludir con credenciales falsificadas |
| **Disponibilidad** | El proceso no debe obstaculizar el flujo de trabajo del usuario |
 
### Los factores de autenticación
 
Los factores son las **categorías** de credenciales que puede presentar un usuario:
 
- **Factor de conocimiento** — "Algo que la persona **sabe**"
  - Contraseña, frase de contraseña (passphrase), PIN (Número de Identificación Personal)
  - **Analogía:** La llave de tu casa que solo tú conoces.
  - ⚠️ El **PIN** moderno se diferencia de la contraseña en que es **válido únicamente para un dispositivo específico**. Puede tener cualquier longitud y tipo de carácter.
- **Factor de propiedad** — "Algo que la persona **tiene**"
  - Tarjeta inteligente, key fob (llavero criptográfico), smartphone
- **Factor biométrico/inherencia** — "Algo que la persona **es**"
  - Huella digital, reconocimiento facial, patrón de marcha (gait analysis)
- **Factor de ubicación** — "Algún **lugar** donde está la persona"
  - Dirección IP, geolocalización, segmento de red, VLAN (Red de Área Local Virtual), puerto físico

> **👉 Enfoque de Examen SY0-701:**
> CompTIA suele preguntar: "¿Cuántos factores usa este escenario?" Recuerda que **dos factores de conocimiento** (ej. PIN + fecha de nacimiento) NO es MFA (Autenticación de Multifactores). MFA requiere factores de **categorías diferentes**. El factor de ubicación se usa como autenticación **continua o control de acceso**, no como factor principal.

## Conceptos sobre Contraseñas
 
### Componentes de una política de contraseñas sólida
 
| Componente | Descripción |
|---|---|
| **Longitud mínima** | Impone un número mínimo de caracteres |
| **Longitud máxima** | Límite superior (menos común) |
| **Complejidad** | Combinación de mayúsculas, minúsculas, números y caracteres especiales; no usar el nombre de usuario |
| **Antigüedad (Age)** | Obliga a cambiar la contraseña tras N días |
| **Caducidad (Expiry)** | La cuenta queda **desactivada** si no se renueva a tiempo |
| **Historial/Reutilización** | Bloquea el uso de contraseñas ya utilizadas anteriormente |
| **Antigüedad mínima** | Impide cambiar la contraseña demasiado rápido para volver a la contraseña preferida |
 
### Distinción clave: Antigüedad vs. Caducidad
 
| Término | Significado |
|---|---|
| **Antigüedad (Age)** | El usuario **aún puede iniciar sesión** pero debe elegir una nueva contraseña de inmediato |
| **Caducidad (Expiry)** | El usuario **ya NO puede iniciar sesión**; la cuenta queda efectivamente desactivada |
 
### Nota NIST (National Institute of Standards and Technology)
 
Las recomendaciones más recientes del **NIST** han **descartado** algunos elementos "tradicionales":
- ❌ Complejidad obligatoria (reglas rígidas de caracteres)
- ❌ Vencimiento periódico forzado
- ❌ Pistas de contraseña (password hints)
> La **reutilización de contraseña** entre el trabajo y sitios de consumo es un riesgo que solo puede controlarse mediante **políticas y formación**, no técnicamente.
 
> **👉 Enfoque de Examen SY0-701:**
> Una pregunta clásica: "Un usuario cambia su contraseña 10 veces seguidas para volver a la original. ¿Qué política previene esto?" → **Antigüedad mínima de contraseña** (minimum password age) combinada con el **historial de contraseñas**.

## Administradores de Contraseñas
 
**Problema que resuelven:** Los usuarios reutilizan contraseñas entre cuentas corporativas y sitios de consumo → riesgo de violación de datos.
 
### Flujo de funcionamiento de un administrador de contraseñas
 
1. **Selección** → El usuario elige una aplicación (ej. LastPass, 1Password, Credential Manager de Windows, iCloud Keychain de Apple)
2. **Bóveda** → Se protege con una **contraseña maestra** (único secreto a recordar). La bóveda puede almacenarse en la nube o localmente.
3. **Generación** → Al crear/actualizar una cuenta, el administrador genera una contraseña aleatoria cumpliendo la política del sitio.
4. **Autocompletado seguro** → Al navegar, el administrador valida la identidad del sitio mediante su **certificado digital** antes de completar la contraseña.

### Riesgos principales de los administradores de contraseñas
 
- Contraseña maestra débil
- Compromiso del almacenamiento en la nube del proveedor
- Ataques de **suplantación de identidad (phishing)** que engañen al gestor para que complete credenciales en un sitio falso
> **👉 Enfoque de Examen SY0-701:**
> CompTIA puede preguntar qué mecanismo usa el administrador de contraseñas para verificar un sitio antes de rellenar credenciales → **certificados digitales**.

## Autenticación de Multifactores (MFA)
 
> **MFA (Multi-Factor Authentication)** = Combinar **más de un tipo** de factor de autenticación de categorías diferentes.
 
### Regla de oro de MFA
 
```
PIN + Contraseña          ❌  NO es MFA  (ambos son factores de conocimiento)
Contraseña + Huella       ✅  SÍ es MFA  (conocimiento + biométrico)
Tarjeta inteligente + PIN ✅  SÍ es MFA  (propiedad + conocimiento)
```
 
### 2FA (Two-Factor Authentication) vs. MFA
 
| Término | Significado |
|---|---|
| **2FA** | Exactamente **dos** factores de categorías diferentes |
| **MFA** | **Dos o más** factores de categorías diferentes |
 
### Factor de ubicación — Casos de uso
 
- Un usuario inicia sesión desde Nueva York y dos horas después desde Los Ángeles → **tiempo de viaje imposible** → se rechaza y genera alerta
- La dirección IP del dispositivo no coincide con el país esperado → se restringen privilegios o se deniega acceso
- Se puede usar VLAN (Virtual LAN), segmento de red lógico o señal Wi-Fi como base del factor de ubicación
> **👉 Enfoque de Examen SY0-701:**
> La pregunta favorita de CompTIA: "¿Es esto MFA?" → Busca si los factores son de **categorías distintas**. Otra variante: preguntan sobre "verificación de dos pasos" (two-step verification), que puede usar dos factores del mismo tipo y **no equivale a MFA**.

## Autenticación Biométrica
 
### Proceso de configuración biométrica
 
1. **Registro (Enrollment):** El módulo sensor adquiere la muestra biométrica del usuario.
2. **Extracción de características:** Se crea una **plantilla** (representación matemática única).
3. **Autenticación:** Se vuelve a escanear y se compara con la plantilla dentro de un grado de tolerancia.

### Métricas de rendimiento biométrico
 
| Métrica | Sigla (inglés) | Descripción | Tipo de error |
|---|---|---|---|
| **Tasa de Falso Rechazo** | FRR / FNMR | Usuario legítimo no es reconocido | Error Tipo I |
| **Tasa de Falsa Aceptación** | FAR / FMR | Un intruso es aceptado | Error Tipo II |
| **Tasa de Error de Cruce** | CER | Punto donde FRR = FAR | — |
| **Tasa de Falla de Registro** | FER | No se puede crear plantilla durante el registro | — |
 
### Regla de oro de las métricas
 
```
FRR alta → Inconveniente para usuarios legítimos
FAR alta → Brecha de seguridad (más crítica)
CER baja → Tecnología más eficiente y confiable
```

### Tipos de biometría
 
| Tipo | Método | Notas |
|---|---|---|
| **Huella digital** | Sensor capacitivo u óptico | Más extendido, económico, fácil de usar. Humedad/suciedad puede interferir. |
| **Reconocimiento facial** | Cámaras ópticas e infrarrojas | Los sensores IR frustran ataques de suplantación con fotos |
| **Identificadores de comportamiento** | Patrón de marcha (gait) | Más difícil de falsificar |
 
### Consideraciones adicionales
 
- **Velocidad/Rendimiento:** Crítica en entornos de alto volumen (aeropuertos, estaciones)
- **Costo/Implementación:** Los escáneres de iris son más caros que los de huella digital
- **Privacidad:** Los usuarios pueden considerarlo intrusivo
- **Accesibilidad:** Puede ser discriminatorio o inaccesible para personas con discapacidad
> **👉 Enfoque de Examen SY0-701:**
> CompTIA pregunta: "¿Qué métrica indica cuándo la tasa de falso rechazo iguala a la de falsa aceptación?" → **CER (Crossover Error Rate)**. También: "¿Qué error es más grave en seguridad?" → **FAR (Error Tipo II)** porque admite intrusos.

## Tokens de Autenticación Físicos
 
> **Analogía:** Como un llavero de coche que genera una señal única cada vez para abrir el vehículo, pero sin transmitir el código secreto.
 
### Tres tipos de generación de tokens
 
| Tipo | Descripción | Ventajas/Inconvenientes |
|---|---|---|
| **Basado en certificados** | El solicitante controla una clave privada → genera token firmado único. La parte de confianza verifica con la clave pública. | Requiere **PKI** (Infraestructura de Clave Pública) completa → carga administrativa alta |
| **OTP (One-Time Password / Contraseña de Un Solo Uso)** | Token generado por función hash sobre secreto compartido + semilla de sincronización (timestamp o contador). Solo se usa una vez. | No requiere PKI. Tipos: **TOTP** (Time-based) y **HOTP** (HMAC-based) |
| **FIDO (Fast Identity Online) U2F (Universal 2nd Factor)** | Par de claves pública/privada por cuenta. La privada queda bloqueada en el dispositivo. No se transmite secreto compartido. | Evita la debilidad de secreto compartido de HOTP/TOTP. La PKI interviene solo para **certificados de attestation**. |
 
### TOTP vs. HOTP
 
| | TOTP | HOTP |
|---|---|---|
| **Sincronización** | Marca de tiempo (tiempo) | Contador (HMAC-based) |
| **Validez** | Período corto de tiempo | Hasta que se use |
| **Riesgo** | Desincronización de reloj | Desincronización de contador |
 
### Tipos de autenticadores físicos
 
| Dispositivo | Tecnología | Notas |
|---|---|---|
| **Tarjeta inteligente** | Certificados digitales + PIN | Tipos: contacto físico y NFC (Near Field Communication / Comunicación de Campo Cercano). Almacena certificado, clave privada y PIN. |
| **Key fob / Token OTP** | Criptoprocesador genera código | No necesita interfaz con PC; el usuario lee el código en pantalla |
| **Clave de seguridad** | HSM (Hardware Security Module / Módulo de Seguridad de Hardware) portátil; USB o NFC | Más asociado con U2F. Requiere activación de presencia: botón físico o lector biométrico de huella + PIN de respaldo |
 
### Tokens estáticos — Riesgo crítico
 
Las tarjetas y fobs más simples transmiten un **código estático** (sin cambio). Son extremadamente vulnerables a **ataques de clonación y reproducción (replay attacks)**.
 
> **👉 Enfoque de Examen SY0-701:**
> CompTIA distingue TOTP vs. HOTP por su mecanismo de sincronización. También pregunta qué tipo de token elimina la necesidad de transmitir un secreto compartido → **FIDO U2F**. La "attestation" (ratificación) es clave en FIDO: demuestra que el dispositivo es genuino.

## Tokens de Autenticación Blandos
 
> **Definición:** Un token blando es una OTP generada por el **proveedor de identidad** y transmitida al solicitante (en lugar de generarse localmente).
 
### Métodos de entrega de tokens blandos
 
| Método | Factor real | Seguridad | Notas |
|---|---|---|---|
| **SMS/Mensaje de texto** | ❌ No es factor de propiedad real | Baja | Vulnerable a interceptación; se considera **verificación de dos pasos**, no MFA |
| **Correo electrónico** | ❌ No es factor de propiedad real | Baja | Mismo problema que SMS |
| **Aplicación autenticadora** (soft token app) | ✅ Factor de propiedad (dispositivo) | Media-Alta | Más seguro que SMS. Riesgo: malware en el dispositivo compartido |
 
### Flujo de la aplicación autenticadora
 
1. Usuario registra cada proveedor de identidad en la app (ej. Google Authenticator, Microsoft Authenticator).
2. Se escanea un **código QR (Quick Response)** para comunicar el secreto compartido.
3. Al autenticarse, el usuario desbloquea la app con sus credenciales del dispositivo.
4. La app muestra el token OTP vigente.

> **👉 Enfoque de Examen SY0-701:**
> Pregunta trampa: "¿Un código enviado por SMS es un factor de propiedad?" → **NO**. Los tokens blandos por SMS/email son "verificación de dos pasos" (two-step verification), no MFA verdadera. La app autenticadora sí se acerca más a un factor de propiedad real.

## Autenticación Sin Contraseña
 
> **Concepto:** El sistema de autenticación **elimina por completo** los factores de conocimiento (contraseñas).
 
### FIDO2 y WebAuthn — El estándar
 
**FIDO2** con **WebAuthn (Web Authentication API)** proporciona el marco para la autenticación sin contraseña.
 
### Flujo de autenticación sin contraseña (FIDO2/WebAuthn)
 
```
1. Usuario elige autenticador:
   - Autenticador de ROAMING → Clave de seguridad física (USB/NFC)
   - Autenticador de PLATAFORMA → Windows Hello / Face ID / Touch ID
 
2. Usuario configura gesto local:
   - Huella digital, reconocimiento facial, o PIN local
   - Esta credencial se valida SOLO LOCALMENTE en el dispositivo
 
3. Registro con la Parte de Confianza (Relying Party / RP):
   - El autenticador genera un par de claves pública/privada ÚNICO por RP
   - La clave PÚBLICA se registra en el servidor de la RP
   - La clave PRIVADA NUNCA sale del dispositivo
 
4. Autenticación:
   - Se presenta desafío → usuario realiza el gesto local
   - La clave privada firma la confirmación
   - La RP verifica con la clave pública → sesión autenticada
 
5. La RP NO conoce la contraseña → no puede filtrarse
```

### FIDO U2F vs. FIDO2/WebAuthn
 
| | FIDO U2F | FIDO2 / WebAuthn |
|---|---|---|
| **Uso** | Segundo factor | Factor único (sin contraseña) |
| **API web** | No | ✅ Sí (WebAuthn API) |
| **Compatibilidad** | Los dispositivos U2F son compatibles con FIDO2 | Superconjunto de U2F |
 
### Attestation (Ratificación)
 
- **Qué es:** Mecanismo por el cual el dispositivo autenticador prueba que es genuino (raíz de confianza).
- **Cómo funciona:** Cada dispositivo lleva un **certificado de attestation** y un **ID de modelo** (no único por dispositivo para proteger la privacidad).
- **Por qué no es único por dispositivo:** Para evitar que se identifique y rastree individualmente a las personas.
- La RP verifica que el autenticador es de una marca/modelo conocido con las propiedades criptográficas requeridas.
> **👉 Enfoque de Examen SY0-701:**
> FIDO2/WebAuthn elimina la contraseña completamente. La "parte de confianza" (relying party) es el servicio web. La attestation verifica el **modelo** del autenticador, no al usuario individual. Comparado con FIDO U2F: la mejora clave es la **API WebAuthn** que permite eliminar el campo de contraseña en aplicaciones web.

# 2. Autorización
 
> **Concepto clave:** La autorización determina **qué puede hacer** un usuario ya autenticado. Define los derechos y permisos sobre recursos.

## Control de Acceso Discrecional y Obligatorio
 
### DAC — Discretionary Access Control (Control de Acceso Discrecional)
 
> **Analogía:** Eres propietario de una casa (recurso) y decides tú mismo quién tiene llave (acceso).
 
- **Principio:** El **propietario del recurso** tiene control total y puede modificar la **ACL (Access Control List / Lista de Control de Acceso)**.
- **Implementación:** Sistema predeterminado en UNIX/Linux y Windows.
- **Ventaja:** Modelo más **flexible**.
- **Desventaja:** El más **débil** en seguridad:
  - Dificulta la administración centralizada de políticas.
  - Vulnerable a amenazas internas y abuso de cuentas comprometidas.
### MAC — Mandatory Access Control (Control de Acceso Obligatorio)
 
> **Analogía:** Un edificio gubernamental donde las salas tienen niveles de clasificación (Confidencial, Secreto, Ultrasecreto) y tus credenciales de seguridad determinan a cuáles puedes entrar, sin importar quién seas.
 
- **Principio:** Basado en **niveles de habilitación de seguridad**. Las reglas las establece el sistema, no los usuarios.
- **Cómo funciona:**
  - A cada **objeto** → se le asigna una **etiqueta de clasificación**.
  - A cada **sujeto** → se le otorga un **nivel de autorización**.
- **Regla "read down, write up":**
```
Nivel Ultrasecreto puede LEER: Ultrasecreto, Secreto, Confidencial ✅
Nivel Secreto puede LEER: Secreto, Confidencial ✅
Nivel Secreto NO PUEDE LEER: Ultrasecreto ❌
 
Un usuario con autorización Alta NO PUEDE ESCRIBIR documentos de nivel bajo
→ Previene la filtración de datos a niveles menos seguros
```
 
- **Compartimentos:** Para mayor flexibilidad, se añade acceso por compartimentos (ej. clasificación Secreto + compartimento RRHH).

### DAC vs. MAC — Tabla Comparativa
 
| Característica | DAC | MAC |
|---|---|---|
| **Control** | Propietario del recurso | Sistema (reglas preestablecidas) |
| **Flexibilidad** | Alta | Baja |
| **Seguridad** | Débil | Fuerte |
| **Implementación típica** | Windows NTFS, Linux permisos | Sistemas militares/gubernamentales |
| **Discrecional** | ✅ Sí | ❌ No |
| **ACL modificable por usuario** | ✅ Sí (si es propietario) | ❌ No |
 
> **👉 Enfoque de Examen SY0-701:**
> "Write up, read down" es una regla exclusiva de **MAC**. Si un escenario menciona "etiquetas de clasificación" o "niveles de autorización", es MAC. Si menciona que el propietario asigna permisos libremente, es DAC. CompTIA puede preguntar cuál modelo es más vulnerable a amenazas internas → **DAC**.

## Control de Acceso Basado en Funciones y Atributos
 
### RBAC — Role-Based Access Control (Control de Acceso Basado en Funciones)
 
> **Analogía:** En una empresa, al nuevo empleado de Contabilidad se le asigna el "rol de Contable" que ya tiene todos los permisos necesarios, sin configurar cada permiso individualmente.
 
- **Principio:** Los permisos se asignan a **roles/funciones** (no directamente a usuarios). Los usuarios heredan permisos al pertenecer a un rol.
- **Características:**
  - No discrecional: el usuario **no puede** modificar la ACL del recurso.
  - Los derechos se adquieren de forma **implícita** (por rol) no explícita (por asignación directa).
  - Las ACL del sistema de archivos almacenan y aplican los permisos.
  - Funciona en Windows y UNIX/Linux.

### Grupos de seguridad como implementación de RBAC
 
```
Sin RBAC: Usuario → permisos asignados directamente (no escalable)
Con RBAC: Usuario → Grupo de Seguridad → ACL del objeto → Hereda permisos
```
 
**Ventaja:** Una cuenta puede pertenecer a múltiples grupos, heredando permisos de varias fuentes.
 
**Riesgo:** Si los administradores asignan roles a sus propias cuentas arbitrariamente → **escalada de privilegios**.
 
### ABAC — Attribute-Based Access Control (Control de Acceso Basado en Atributos)
 
> **Analogía:** Un sistema VIP inteligente que verifica no solo tu membresía (rol), sino también si llevas traje (atributo), si es horario VIP (contexto) y si estás en la ciudad correcta (ubicación).
 
- **Principio:** El modelo **más granular**. Las decisiones de acceso se basan en una combinación de:
  - Atributos del **sujeto** (usuario, rol, departamento)
  - Atributos del **objeto** (tipo de dato, clasificación)
  - Atributos de **contexto/sistema** (sistema operativo, IP, parches actualizados, antimalware)
- **Capacidades adicionales de ABAC:**
  - Monitorea cantidad de eventos/alertas asociados con una cuenta.
  - Rastrea solicitudes de acceso para verificar coherencia geográfica/temporal.
  - Puede implementar **separación de funciones** y **control M de N**.

### Control M de N
 
- **Definición:** Requiere que un número mínimo **M** de agentes, de un total de **N**, colaboren para realizar una tarea de seguridad de alto nivel (ej. firma de claves criptográficas).
- **Ejemplo:** Para firmar una clave PKI se necesitan 3 de 5 administradores.

#### RBAC vs. ABAC — Comparativa
 
| Característica | RBAC | ABAC |
|---|---|---|
| **Granularidad** | Media | Alta (la más detallada) |
| **Basado en** | Roles/Funciones | Múltiples atributos + contexto |
| **Flexibilidad** | Media | Alta |
| **Complejidad** | Media | Alta |
| **Casos de uso** | Empresas con roles bien definidos | Entornos que requieren control fino contextual |
 
> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: "¿Qué modelo de control de acceso es el más granular?" → **ABAC**. "¿Cuál asigna permisos basados en la función laboral?" → **RBAC**. No confundas RBAC con DAC: en RBAC el usuario **no puede** modificar las ACL del recurso; en DAC el propietario sí puede.

## Control de Acceso Basado en Reglas
 
- **Definición:** Cualquier modelo donde las **políticas de acceso las determina el sistema** (no los usuarios).
- **Incluye:** MAC, RBAC y ABAC son todos ejemplos de control de acceso basado en reglas (no discrecional).
### Acceso Condicional
 
- **Qué hace:** Supervisa el comportamiento de la cuenta/dispositivo durante una sesión.
- **Si se cumplen condiciones específicas:** puede suspender la cuenta o exigir re-autenticación.
- **Ejemplos concretos:**
  - **UAC (User Account Control / Control de Cuentas de Usuario)** de Windows
  - **`sudo`** en Linux
  - Políticas basadas en ubicación geográfica
> **👉 Enfoque de Examen SY0-701:**
> "¿Cuál es un ejemplo de acceso condicional?" → UAC de Windows y sudo de Linux. El acceso condicional puede "pausar" una sesión activa si se detecta comportamiento anómalo, lo que lo diferencia de los modelos que solo verifican en el inicio de sesión.

## Asignaciones de Permisos de Mínimo Privilegio
 
> **Principio:** A cada entidad se le otorgan los derechos **mínimos posibles** para completar las tareas autorizadas.
 
### ¿Por qué es importante?
 
- Mitiga el riesgo si una cuenta es comprometida.
- Limita el daño potencial de malware o actores malintencionados.

### Desafíos de implementación
 
| Desafío | Consecuencia |
|---|---|
| Privilegios demasiado restrictivos | Alto volumen de llamadas de soporte, reducción de productividad |
| Privilegios excesivos | Debilitamiento de la seguridad, mayor riesgo de malware y filtraciones |
 
### Acumulación de autorizaciones (Privilege Creep)
 
- **Definición:** Un usuario adquiere **cada vez más derechos** con el tiempo (directamente o por pertenencia a grupos).
- **Prevención:**
  - Auditorías regulares de privilegios.
  - Revisión periódica de membresía de grupos.
  - Revisión de ACL de cada recurso.
  - Identificación y desactivación de cuentas innecesarias.
  - Sistema para revocar privilegios temporales al finalizar el período acordado.

> **👉 Enfoque de Examen SY0-701:**
> "Un usuario cambió de departamento tres veces y ahora tiene acceso a recursos de todos sus departamentos anteriores. ¿Qué concepto describe esto?" → **Privilege creep / Acumulación de autorizaciones**. La solución es la auditoría periódica de permisos.

## Aprovisionamiento de Cuentas de Usuario
 
> **Aprovisionamiento:** Proceso de configurar un servicio/cuenta conforme a procedimientos estándar y buenas prácticas.
 
### Pasos del aprovisionamiento de una cuenta de usuario
 
1. **Verificación de identidad** → Confirmar quién es la persona (documentos, registros, comprobación de antecedentes)
2. **Emisión de credenciales** → El usuario elige contraseña o se registra con autenticadores biométricos/tokens
3. **Emisión de activos (hardware/software)** → PC, smartphone, aplicaciones con licencia
   - ⚠️ Recursos insuficientes → el usuario busca alternativas por su cuenta → **Shadow IT (TI en la sombra)**
4. **Concientización sobre políticas** → Capacitación en seguridad, políticas de uso aceptable
5. **Creación de asignación de permisos** → Configurar derechos según modelo de control de acceso (RBAC/MAC/ABAC). Si tiene acceso privilegiado → etiquetado para monitoreo estrecho.

### Desaprovisionamiento
 
- **Definición:** Eliminar derechos y permisos cuando alguien deja la empresa o finaliza un proyecto.
- **Proceso:** Eliminar de roles/grupos → Desactivar cuenta → Eliminar (inmediatamente o después de un período).

> **👉 Enfoque de Examen SY0-701:**
> "Un empleado deja la empresa. ¿Cuál es el primer paso crítico de seguridad?" → **Desaprovisionamiento inmediato** de la cuenta (desactivar acceso). El término **Shadow IT** aparece cuando los usuarios obtienen recursos por su cuenta por falta de aprovisionamiento adecuado.

## Atributos de Cuenta y Políticas de Acceso
 
### Componentes de una cuenta de usuario
 
- **SID (Security Identifier / Identificador de Seguridad):** Identificador único de la cuenta en el sistema.
- **Nombre de cuenta:** Identificador visible.
- **Credencial:** Contraseña, biométrico, token.
- **Perfil:** Contiene atributos personalizados (nombre completo, email, departamento, número de contacto, imagen de cuenta).
- **Carpeta de inicio (Home folder):** Ubicación de almacenamiento de archivos del usuario.
- **Configuración por cuenta:** Preferencias de aplicaciones de software.

### Permisos y políticas de acceso
 
Los permisos pueden asignarse:
- **Directamente** a la cuenta, o
- **Heredarse** a través de la pertenencia a grupos/roles de seguridad.
Las políticas de acceso determinan derechos como:
- Iniciar sesión localmente o mediante escritorio remoto
- Instalar software
- Cambiar configuración de red

### GPO — Group Policy Objects (Objetos de Directiva de Grupo) en Windows
 
- Herramienta de **Active Directory (AD)** para definir y aplicar políticas de acceso.
- Se vinculan a límites administrativos:
  - **Sitios**
  - **Dominios**
  - **OU (Organizational Units / Unidades Organizacionales)**
> **👉 Enfoque de Examen SY0-701:**
> CompTIA puede preguntar cómo se aplican políticas de acceso en entornos Windows → **GPO vinculados a AD**. Los GPO pueden configurar derechos para usuarios, grupos y roles dentro de sitios, dominios y UO.

## Restricciones de la Cuenta
 
### Políticas basadas en la ubicación
 
| Mecanismo | Descripción |
|---|---|
| **Ubicación de red lógica** | IP, subred, VLAN, OU → restringe inicio de sesión local en servidores de zonas restringidas |
| **Geolocalización por IP** | Se consultan bases de datos (ej. GeoIP) para mapear IPs a países/regiones. Precisión limitada por el ISP (Internet Service Provider / Proveedor de Servicios de Internet). |
| **GPS (Global Positioning System / Sistema de Posicionamiento Global)** | Alta precisión en exteriores |
| **Servicios de ubicación** | Triangulación de torres celulares, puntos de acceso Wi-Fi y señales Bluetooth |
 
### Políticas basadas en el tiempo
 
| Política | Descripción |
|---|---|
| **Restricciones horarias (time-of-day)** | Define las horas autorizadas de inicio de sesión para una cuenta |
| **Inicio de sesión por duración** | Establece el tiempo máximo que una cuenta puede estar conectada |
| **Tiempo de viaje imposible / inicio de sesión riesgoso** | Detecta inicios de sesión desde ubicaciones geográficamente imposibles en el tiempo transcurrido → desactiva cuenta y genera alerta |
| **Permisos temporales** | Elimina automáticamente una cuenta de un rol/grupo después de un período definido |
 
> **👉 Enfoque de Examen SY0-701:**
> "Un usuario inicia sesión en Nueva York y dos horas después se detecta un intento desde Los Ángeles. ¿Qué política actúa aquí?" → **Tiempo de viaje imposible / inicio de sesión riesgoso (impossible travel / risky sign-in)**. Esta política es clave en Zero Trust.

## Administración de Acceso con Privilegios (PAM)
 
### Tipos de cuentas por nivel de privilegio
 
| Tipo | Descripción |
|---|---|
| **Usuario estándar** | Solo puede ejecutar programas y modificar archivos de su propio perfil |
| **Cuenta privilegiada** | Puede instalar software, desactivar cortafuegos, administrar redes, servidores y bases de datos |
 
### PAM — Privileged Access Management (Administración de Acceso Privilegiado)
 
- **Qué incluye:** Políticas, procedimientos y controles técnicos para prevenir el compromiso de cuentas privilegiadas.
- **Funciones:** Identificar y documentar cuentas privilegiadas, dar visibilidad de su uso, gestionar sus credenciales.
### Buenas prácticas de PAM
 
- Minimizar el número de cuentas administrativas.
- No compartir cuentas administrativas entre varios administradores.
- No usar cuentas predeterminadas (compromete la responsabilidad/trazabilidad).
- Usar contraseñas fuertes + MFA o autenticación sin contraseña.
- Usar **SAW (Secure Administrative Workstation / Estación de Trabajo Administrativa Segura):** dispositivo dedicado con superficie de ataque mínima y solo las aplicaciones estrictamente necesarias.

### JIT — Just-in-Time Permissions (Permisos Justo a Tiempo)
 
> Los privilegios NO se asignan al iniciar sesión. Se solicitan explícitamente y se otorgan solo por un período limitado.
 
**Concepto relacionado: ZSP — Zero Standing Privileges (Privilegios Permanentes Cero)**
 
### Tres modelos de implementación de JIT/ZSP
 
| Modelo | Descripción | Nivel de control |
|---|---|---|
| **Elevación temporal** | La cuenta obtiene derechos administrativos por un período limitado (ej. UAC en Windows, `sudo` en Linux) | Básico |
| **Bóveda de contraseñas / Intermediación (Vaulting/Brokering)** | La cuenta privilegiada se "saca" de un repositorio; disponible por tiempo limitado; requiere justificación. La aprobación puede automatizarse o requerir aprobación manual (control M de N) | Avanzado |
| **Credenciales efímeras** | El sistema genera/habilita una cuenta para la tarea y la destruye/deshabilita al finalizar | Máximo |
 
> **👉 Enfoque de Examen SY0-701:**
> "¿Qué término describe el modelo donde los privilegios administrativos solo se otorgan cuando se solicitan y por tiempo limitado?" → **JIT (Just-in-Time)** o **ZSP (Zero Standing Privileges)**. La "bóveda de contraseñas" es más segura que la elevación temporal porque requiere justificación y proporciona trazabilidad. La PAM también se aplica a **cuentas de servicio**, no solo a administradores humanos.

# 3. Administración de Identidades
 
> **Contexto:** A medida que las organizaciones migran servicios a la nube, la administración de cuentas y derechos requiere soluciones de **identidad federada** que vayan más allá de los directorios locales.

## Autenticación Local, de Red y Remota

### Principio base: almacenamiento de credenciales
 
Las contraseñas **nunca se almacenan en texto plano**. Se almacenan como **hashes criptográficos**. Al autenticarse, la contraseña ingresada se hashea y se compara con el hash almacenado.
 
### Autenticación en Windows
 
| Escenario | Mecanismo |
|---|---|
| **Inicio de sesión local** | **LSASS** (Local Security Authority Subsystem Service / Servicio del Subsistema de la Autoridad de Seguridad Local) compara el hash con la base de datos **SAM** (Security Accounts Manager / Administrador de Cuentas de Seguridad), parte del registro. También llamado "inicio de sesión interactivo". |
| **Inicio de sesión en red** | LSASS pasa credenciales a un **controlador de dominio de Active Directory (AD)**. Protocolo preferido: **Kerberos**. Aplicaciones heredadas pueden usar **NTLM** (NT LAN Manager). |
| **Inicio de sesión remoto** | A través de **VPN (Virtual Private Network / Red Privada Virtual)**, Wi-Fi empresarial o portal web. Usan protocolos para crear una conexión segura entre cliente, dispositivo de acceso remoto y servidor de autenticación. |
 
### Autenticación en Linux
 
| Elemento | Descripción |
|---|---|
| `/etc/passwd` | Almacena nombres de cuentas locales |
| `/etc/shadow` | Almacena los hashes de contraseñas |
| **SSH (Secure Shell / Shell Seguro)** | Protocolo para inicio de sesión interactivo remoto. Permite autenticación con **claves criptográficas** en lugar de contraseñas. |
| **PAM (Pluggable Authentication Module / Módulo de Autenticación Conectable)** | Paquete que habilita distintos proveedores de autenticación (ej. tarjeta inteligente). También puede implementar autenticación en servicios de directorio de red. |
 
> **👉 Enfoque de Examen SY0-701:**
> CompTIA puede preguntar: "¿Qué módulo de Linux permite integrar distintos métodos de autenticación?" → **PAM**. "¿Dónde se almacenan los hashes de contraseñas en Linux?" → `/etc/shadow`. "¿Qué protocolo usa Windows para autenticación de red moderna vs. heredada?" → **Kerberos** (moderno) vs. **NTLM** (heredado).

## Servicios de Directorio
 
> **Analogía:** Un directorio de empresa es como una guía telefónica digital que almacena información sobre todos los empleados, sus departamentos, sus permisos y los recursos disponibles.
 
### LDAP — Lightweight Directory Access Protocol (Protocolo Ligero de Acceso a Directorios)
 
- **Base:** Desarrollado a partir del estándar **X.500**.
- **Propósito:** Asegurar la interoperabilidad entre productos de distintos proveedores.
- Los servicios de directorio almacenan: usuarios, equipos, grupos de seguridad/roles, servicios.
- Cada objeto tiene **atributos** definidos por el **esquema** del directorio.

### Estructura de nombres en LDAP (basada en X.500)
 
| Atributo | Significado |
|---|---|
| `CN` | Common Name (Nombre Común) |
| `OU` | Organizational Unit (Unidad Organizacional) |
| `O` | Organization (Organización) |
| `C` | Country (País) |
| `DC` | Domain Component (Componente de Dominio) |
 
**Ejemplo de Distinguished Name (DN / Nombre Distinguido):**
```
CN=WIDGETWEB, OU=Marketing, O=Widget, C=UK, DC=widget, DC=foo
```
- El atributo **más específico** va primero → identifica de forma única el objeto.
- El **Relative Distinguished Name (RDN)** es el atributo más específico dentro de su contexto.
> **👉 Enfoque de Examen SY0-701:**
> CompTIA puede preguntar qué protocolo usa Active Directory para consultas de directorio → **LDAP**. Los atributos DN más frecuentes en preguntas son CN, OU y DC. El estándar base de LDAP es **X.500**.

## Autenticación de Inicio de Sesión Único (SSO) — Kerberos
 
> **SSO (Single Sign-On / Inicio de Sesión Único):** El usuario se autentica **una sola vez** y recibe acceso a múltiples servicios sin volver a ingresar credenciales.
 
### Kerberos — El guardián de tres cabezas
 
- **Nombre:** Inspirado en el perro de tres cabezas de la mitología griega (Cerbero).
- **Las tres partes:** Cliente, Servidor de Aplicaciones, y **KDC (Key Distribution Center / Centro de Distribución de Claves)**.
- **Implementación principal:** Active Directory de Microsoft.
- **Usuarios de Kerberos:** "Principales" = usuarios humanos + servicios de aplicaciones.

### Los dos servicios del KDC
 
| Servicio | Sigla | Función |
|---|---|---|
| **Servicio de Autenticación** | AS | Verifica la identidad del principal y emite el TGT |
| **Servicio de Concesión de Tickets** | TGS | Emite tickets de servicio para acceder a aplicaciones específicas |
 
### Fase 1 — Autenticación con el KDC (obtención del TGT)
 
```
PASO 1: El principal envía al AS una solicitud de TGT
         → La solicitud está cifrada con el hash de la contraseña del usuario
         → El hash NO se transmite por la red
 
PASO 2: El AS verifica:
         ✅ La cuenta existe
         ✅ Puede descifrar la solicitud (hash de contraseña coincide con AD)
         ✅ La solicitud no ha caducado
 
PASO 3: El AS responde con:
         → TGT (Ticket Granting Ticket / Ticket de Concesión de Tickets):
           - Contiene: nombre del cliente, IP, sello de tiempo, período de validez
           - Cifrado con la clave secreta del KDC (el cliente NO puede leerlo)
         → Clave de sesión TGS:
           - Cifrada con el hash de la contraseña del usuario
```
 
> **El TGT es un token lógico.** Solo identifica quién eres; NO da acceso a recursos.
 
> **👉 Enfoque de Examen SY0-701:**
> Pregunta clave: "¿Qué emite el AS de Kerberos?" → El **TGT** y la **clave de sesión TGS**. "¿Se transmite la contraseña por la red en Kerberos?" → **No**; solo el hash de la fecha/hora cifrado con el hash de la contraseña. El TGT está cifrado con la clave secreta del KDC → el cliente no puede manipularlo.
 
## Autorización de Inicio de Sesión Único (Kerberos TGS)
 
### Fase 2 — Autorización con el TGS (obtención del ticket de servicio)
 
```
PASO 1: El principal envía al TGS:
         → Copia de su TGT (cifrado con clave KDC)
         → Nombre del servidor de aplicaciones de destino
         → Autenticador: ID de cliente con marca de tiempo, cifrado con clave de sesión TGS
 
PASO 2: El TGS verifica:
         ✅ Descifra el TGT con la clave secreta del KDC
         ✅ Descifra el autenticador con la clave de sesión TGS
         ✅ El ticket no ha caducado
         ✅ El ticket no se ha usado antes (prevención de replay attack / ataque de repetición)
 
PASO 3: El TGS responde con:
         → Clave de sesión de servicio: cifrada con la clave de sesión TGS
         → Ticket de servicio: contiene IP del sistema, SID del usuario y grupos, clave de sesión del servicio
           → Cifrado con la clave secreta del servidor de aplicaciones
 
PASO 4: El principal envía al servidor de aplicaciones:
         → El ticket de servicio (NO puede descifrarlo)
         → Otro autenticador con marca de tiempo, cifrado con clave de sesión del servicio
 
PASO 5: El servidor de aplicaciones descifra el ticket de servicio con su clave secreta
         → Obtiene la clave de sesión del servicio
         → Descifra el autenticador con esa clave
 
PASO 6 (OPCIONAL): El servidor responde con la marca de tiempo cifrada (autenticación mutua)
         → El principal verifica que el servidor es genuino
         → Previene ataques "on-path" (man-in-the-middle)
 
PASO 7: El servidor responde a las solicitudes de acceso según su ACL
```

### Punto débil de Kerberos
 
- El **KDC es un único punto de falla (Single Point of Failure)**.
- **Solución:** Se implementan KDCs de respaldo (ej. múltiples controladores de dominio AD, cada uno ejecutando KDC).
  
> **👉 Enfoque de Examen SY0-701:**
> "¿Cómo previene Kerberos los ataques de repetición?" → Verifica que el ticket no se haya usado antes + comprueba el sello de tiempo. "¿Qué es la autenticación mutua en Kerberos?" → El servidor también se autentica ante el cliente enviando la marca de tiempo cifrada. El SID del usuario y sus grupos viajan en el **ticket de servicio**.

## Federation (Federación de Identidades)
 
> **Analogía:** Como un pasaporte internacional: tu país (IdP) te emite el pasaporte (token/claim), y otros países (SP) confían en él para dejarte entrar sin crearte una nueva identidad.
 
### ¿Qué es la Federación?
 
- Permite que una organización **confíe en las cuentas creadas y administradas por otra red**.
- Ejemplo empresarial: una empresa da acceso a socios/proveedores usando sus propias credenciales corporativas.
- Ejemplo de consumidor: iniciar sesión en Twitter con credenciales de Google (y viceversa).

### Por qué Kerberos/LDAP no es suficiente para la federación
 
- Las aplicaciones web pueden no admitir Kerberos.
- Las redes de terceros pueden no admitir Active Directory/LDAP.
- Se necesitan **protocolos estándar interoperables** basados en identidad de "reclamos".

### Terminología de federación
 
| Término | Descripción |
|---|---|
| **IdP (Identity Provider / Proveedor de Identidad)** | Gestiona y autentica las identidades de usuario. Emite tokens/reclamos. |
| **SP (Service Provider / Proveedor de Servicios)** | El servicio al que el usuario quiere acceder. Confía en el IdP. |
| **Reclamo (Claim)** | Token o documento firmado que el IdP emite como prueba de identidad/atributos |
| **Relación de confianza** | Acuerdo previo entre SP e IdP para aceptar los tokens del IdP |
 
### Flujo de autenticación federada
 
```
1. La entidad intenta acceder al SP (Proveedor de Servicios)
2. El SP redirige al IdP (Proveedor de Identidad)
3. La entidad se autentica con el IdP
4. El IdP emite un reclamo (token firmado)
5. La entidad presenta el reclamo al SP
6. El SP valida el reclamo (gracias a la relación de confianza con el IdP)
7. El SP conecta la entidad con su base de datos local de cuentas y permisos
```
 
> **👉 Enfoque de Examen SY0-701:**
> La federación usa "identidad basada en reclamos". El SP confía en el IdP, no autentica directamente al usuario. Las preguntas suelen combinar federación con SAML u OAuth. Si el escenario menciona "confiar en las cuentas de otra organización" → **Federación**.

## SAML (Security Assertion Markup Language)
 
### ¿Qué es SAML?
 
- **SAML (Security Assertion Markup Language / Lenguaje de Marcado para Confirmaciones de Seguridad):** Protocolo para transmitir afirmaciones/reclamos de identidad entre el IdP y el SP.
- Las afirmaciones están escritas en **XML (eXtensible Markup Language / Lenguaje de Marcado Extensible)**.
- Las comunicaciones usan **HTTP/HTTPS** y **SOAP (Simple Object Access Protocol / Protocolo Simple de Acceso a Objetos)**.
- Los tokens se firman usando **firma XML (XML Signature)**.
- Las firmas digitales permiten que el SP confíe en el IdP.

### Ejemplo de implementación SAML
 
**Amazon Web Services (AWS)** funciona como proveedor de servicios SAML, permitiendo que las empresas gestionen identidades de clientes en AWS sin crear cuentas directamente en la plataforma.
 
### Estructura básica de una respuesta SAML (XML)
 
```xml
<samlp:Response ...>
  <saml:Issuer>https://idp.foo/sso</saml:Issuer>
  <ds:Signature>...</ds:Signature>
  <samlp:Status>...(success)...</samlp:Status>
  <saml:Assertion ...>
    <saml:Subject>...</saml:Subject>
    <saml:Conditions>...</saml:Conditions>
    <saml:AuthnStatement>...</saml:AuthnStatement>
    <saml:AttributeStatement>
      <saml:Attribute>...</saml:Attribute>
    </saml:AttributeStatement>
  </saml:Assertion>
</samlp:Response>
```
 
### Características técnicas de SAML
 
| Característica | Detalle |
|---|---|
| **Formato de datos** | XML |
| **Protocolo de transporte** | HTTP/HTTPS + SOAP |
| **Firma** | XML Signature (firma digital) |
| **Uso típico** | Federación empresarial (B2B), SSO web |
| **Caso de uso** | AWS, aplicaciones SaaS empresariales |
 
> **👉 Enfoque de Examen SY0-701:**
> SAML usa **XML** y **SOAP**. OAuth usa **JSON** y **REST**. Esta distinción es crucial en el examen. Si el escenario menciona "empresa que permite acceso a sus socios usando sus propias credenciales" y "XML" → **SAML**. AWS es el ejemplo canónico de SAML en la nube.

## OAuth (Open Authorization)
 
### El contexto: APIs RESTful vs. SOAP
 
| | SOAP | REST |
|---|---|---|
| **Tipo** | Protocolo estrictamente especificado | Marco arquitectónico flexible |
| **Formato** | XML | JSON |
| **Soporte móvil** | Limitado | ✅ Mejor |
| **Protocolo de auth** | SAML | OAuth |
 
### ¿Qué es OAuth?
 
- **OAuth (Open Authorization / Autorización Abierta):** Protocolo para implementar autenticación y autorización en **APIs RESTful**.
- **Propósito:** Facilitar el intercambio de información (recursos) entre sitios sin compartir contraseñas.
- **Diferencia clave:** OAuth es principalmente un protocolo de **autorización** (permite que apps accedan a tus datos). Para autenticación se complementa con **OIDC (OpenID Connect)**.

### Actores en OAuth
 
| Actor | Descripción |
|---|---|
| **Propietario del recurso (Resource Owner)** | El usuario que tiene la cuenta y autoriza el acceso |
| **Cliente OAuth** | La aplicación o sitio que quiere acceder a los datos del usuario |
| **Servidor de recursos (API Server)** | Donde están alojados los datos/recursos del usuario |
| **Servidor de autorización** | Procesa las solicitudes de autorización; puede gestionar múltiples servidores de recursos |
 
### Flujo básico de OAuth
 
```
1. El cliente se registra en el servidor de autorización
   → Obtiene: Client ID (público) + Client Secret (privado/confidencial)
   → Registra una URL de redirección
 
2. El usuario (propietario del recurso) inicia el flujo de autorización
 
3. El usuario aprueba el acceso en el servidor de autorización
 
4. El cliente recibe un token de acceso validado
 
5. El cliente presenta el token al servidor de recursos
 
6. El servidor de recursos acepta la solicitud si el token es válido
```

### JWT — JSON Web Token
 
- **Formato de datos que usa OAuth** para los datos de reclamos.
- Se puede pasar como cadena codificada en **Base64** en URLs y encabezados HTTP.
- Se puede **firmar digitalmente** para garantizar autenticación e integridad.

### SAML vs. OAuth — Comparativa Maestra
 
| Característica | SAML | OAuth |
|---|---|---|
| **Formato de datos** | XML | JSON (JWT) |
| **Protocolo de transporte** | HTTP/HTTPS + SOAP | HTTP/HTTPS + REST |
| **Propósito principal** | Autenticación + Autorización | Autorización (+ OIDC para autenticación) |
| **Soporte móvil** | Limitado | ✅ Excelente |
| **Uso típico** | SSO empresarial, B2B | APIs de consumidor, apps móviles, redes sociales |
| **Firma** | XML Signature | JWT firmado digitalmente |
| **Ejemplo** | AWS SAML, federación corporativa | "Login con Google", "Login con Facebook" |
 
> **👉 Enfoque de Examen SY0-701:**
> La distinción SAML vs. OAuth es de las más preguntadas del tema. Regla rápida:
> - **XML + SOAP + Empresa** → SAML
> - **JSON + REST + App móvil/web** → OAuth
> El **JWT (JSON Web Token)** es el formato de token de OAuth. El "Login con Google" en un sitio es un ejemplo de OAuth/OIDC, no de SAML.

# 4. Tabla Maestra de Comparación de Modelos de Control de Acceso
 
| Modelo | Sigla | Quién decide el acceso | Flexibilidad | Seguridad | Caso de uso típico |
|---|---|---|---|---|---|
| Discrecional | **DAC** | El propietario del recurso | Alta | Baja | Windows NTFS, Linux permisos básicos |
| Obligatorio | **MAC** | El sistema (etiquetas + niveles) | Baja | Alta | Sistemas militares, gubernamentales |
| Basado en funciones | **RBAC** | El sistema (por roles laborales) | Media | Media-Alta | Empresas con organigramas claros |
| Basado en atributos | **ABAC** | El sistema (múltiples atributos + contexto) | Alta | Alta | Sistemas en la nube, Zero Trust |
| Basado en reglas | **Rule-BAC** | El sistema (reglas definidas) | Variable | Variable | Firewalls, acceso condicional |

# 5. Glosario
 
| Acrónimo | Significado (inglés) | Significado (español) |
|---|---|---|
| **IAM** | Identity and Access Management | Gestión de Identidades y Accesos |
| **MFA** | Multi-Factor Authentication | Autenticación de Multifactores |
| **2FA** | Two-Factor Authentication | Autenticación de Dos Factores |
| **OTP** | One-Time Password | Contraseña de Un Solo Uso |
| **TOTP** | Time-based One-Time Password | Contraseña de Un Solo Uso Basada en Tiempo |
| **HOTP** | HMAC-based One-Time Password | Contraseña de Un Solo Uso Basada en HMAC |
| **FIDO** | Fast Identity Online | Identidad en Línea Rápida |
| **U2F** | Universal 2nd Factor | Segundo Factor Universal |
| **PKI** | Public Key Infrastructure | Infraestructura de Clave Pública |
| **PIN** | Personal Identification Number | Número de Identificación Personal |
| **FRR** | False Rejection Rate | Tasa de Falso Rechazo |
| **FAR** | False Acceptance Rate | Tasa de Falsa Aceptación |
| **CER** | Crossover Error Rate | Tasa de Error de Cruce |
| **FER** | Failure to Enroll Rate | Tasa de Falla de Registro |
| **FNMR** | False Non-Match Rate | Tasa de Falsa No Coincidencia |
| **FMR** | False Match Rate | Tasa de Falsa Coincidencia |
| **HSM** | Hardware Security Module | Módulo de Seguridad de Hardware |
| **NFC** | Near Field Communication | Comunicación de Campo Cercano |
| **DAC** | Discretionary Access Control | Control de Acceso Discrecional |
| **MAC** | Mandatory Access Control | Control de Acceso Obligatorio |
| **RBAC** | Role-Based Access Control | Control de Acceso Basado en Funciones |
| **ABAC** | Attribute-Based Access Control | Control de Acceso Basado en Atributos |
| **ACL** | Access Control List | Lista de Control de Acceso |
| **PAM** | Privileged Access Management | Administración de Acceso Privilegiado |
| **SAW** | Secure Administrative Workstation | Estación de Trabajo Administrativa Segura |
| **JIT** | Just-in-Time | Justo a Tiempo |
| **ZSP** | Zero Standing Privileges | Privilegios Permanentes Cero |
| **UAC** | User Account Control | Control de Cuentas de Usuario |
| **GPO** | Group Policy Object | Objeto de Directiva de Grupo |
| **AD** | Active Directory | Directorio Activo |
| **SSO** | Single Sign-On | Inicio de Sesión Único |
| **KDC** | Key Distribution Center | Centro de Distribución de Claves |
| **TGT** | Ticket Granting Ticket | Ticket de Concesión de Tickets |
| **TGS** | Ticket Granting Service | Servicio de Concesión de Tickets |
| **AS** | Authentication Service | Servicio de Autenticación |
| **SID** | Security Identifier | Identificador de Seguridad |
| **NTLM** | NT LAN Manager | Administrador de LAN NT |
| **LDAP** | Lightweight Directory Access Protocol | Protocolo Ligero de Acceso a Directorios |
| **DN** | Distinguished Name | Nombre Distinguido |
| **RDN** | Relative Distinguished Name | Nombre Distinguido Relativo |
| **OU** | Organizational Unit | Unidad Organizacional |
| **DC** | Domain Component | Componente de Dominio |
| **IdP** | Identity Provider | Proveedor de Identidad |
| **SP** | Service Provider | Proveedor de Servicios |
| **SAML** | Security Assertion Markup Language | Lenguaje de Marcado para Confirmaciones de Seguridad |
| **XML** | eXtensible Markup Language | Lenguaje de Marcado Extensible |
| **SOAP** | Simple Object Access Protocol | Protocolo Simple de Acceso a Objetos |
| **OAuth** | Open Authorization | Autorización Abierta |
| **REST** | Representational State Transfer | Transferencia de Estado Representacional |
| **JWT** | JSON Web Token | Token Web JSON |
| **API** | Application Programming Interface | Interfaz de Programación de Aplicaciones |
| **LSASS** | Local Security Authority Subsystem Service | Servicio del Subsistema de la Autoridad de Seguridad Local |
| **SAM** | Security Accounts Manager | Administrador de Cuentas de Seguridad |
| **PAM** (Linux) | Pluggable Authentication Module | Módulo de Autenticación Conectable |
| **SSH** | Secure Shell | Shell Seguro |
| **VPN** | Virtual Private Network | Red Privada Virtual |
| **VLAN** | Virtual Local Area Network | Red de Área Local Virtual |
| **GPS** | Global Positioning System | Sistema de Posicionamiento Global |
| **ISP** | Internet Service Provider | Proveedor de Servicios de Internet |
| **IP** | Internet Protocol | Protocolo de Internet |
| **QR** | Quick Response | Respuesta Rápida |
| **NIST** | National Institute of Standards and Technology | Instituto Nacional de Estándares y Tecnología |
| **TPM** | Trusted Platform Module | Módulo de Plataforma de Confianza |
