> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [Módulo 06: Seguridad — TLS/SSL, Realms y Autenticación](#módulo-06-seguridad--tlsssl-realms-y-autenticación)
  - [6.1 Arquitectura de Seguridad en Tomcat](#61-arquitectura-de-seguridad-en-tomcat)
    - [¿Por qué hablar de "capas" de seguridad?](#por-qué-hablar-de-capas-de-seguridad)
  - [6.2 TLS/SSL: Conceptos Fundamentales](#62-tlsssl-conceptos-fundamentales)
    - [¿Qué es TLS y por qué importa?](#qué-es-tls-y-por-qué-importa)
    - [¿Cómo funciona el proceso de conexión TLS? (Handshake simplificado)](#cómo-funciona-el-proceso-de-conexión-tls-handshake-simplificado)
    - [6.2.1 Tipos de implementación TLS en Tomcat](#621-tipos-de-implementación-tls-en-tomcat)
    - [6.2.2 Versiones de TLS soportadas por Tomcat](#622-versiones-de-tls-soportadas-por-tomcat)
  - [6.3 Gestión de Certificados](#63-gestión-de-certificados)
    - [¿Qué es un certificado digital?](#qué-es-un-certificado-digital)
    - [¿Qué es un KeyStore?](#qué-es-un-keystore)
    - [6.3.1 Generación de KeyStore JKS con keytool](#631-generación-de-keystore-jks-con-keytool)
    - [6.3.2 Integración con Let's Encrypt (Certbot)](#632-integración-con-lets-encrypt-certbot)
  - [6.4 Configuración TLS Completa en server.xml](#64-configuración-tls-completa-en-serverxml)
    - [6.4.1 HTTPS con PKCS12 — Tomcat 8.5+ (Configuración recomendada)](#641-https-con-pkcs12--tomcat-85-configuración-recomendada)
    - [6.4.2 mTLS — Autenticación mutua con certificados de cliente](#642-mtls--autenticación-mutua-con-certificados-de-cliente)
    - [6.4.3 Recarga de certificados TLS sin reinicio — Tomcat 8.5+](#643-recarga-de-certificados-tls-sin-reinicio--tomcat-85)
  - [6.5 Realms: Sistema de Autenticación de Tomcat](#65-realms-sistema-de-autenticación-de-tomcat)
    - [¿Qué es un Realm?](#qué-es-un-realm)
    - [6.5.1 MemoryRealm — Solo desarrollo](#651-memoryrealm--solo-desarrollo)
    - [6.5.2 JDBCRealm — Usuarios en base de datos (JDBC directo)](#652-jdbcrealm--usuarios-en-base-de-datos-jdbc-directo)
    - [6.5.3 DataSourceRealm — Usuarios en BD via pool JNDI (recomendado)](#653-datasourcerealm--usuarios-en-bd-via-pool-jndi-recomendado)
    - [6.5.4 JNDIRealm — Autenticación contra LDAP / Active Directory](#654-jndirealm--autenticación-contra-ldap--active-directory)
    - [6.5.5 LockOutRealm — Protección contra fuerza bruta](#655-lockoutrealm--protección-contra-fuerza-bruta)
    - [6.5.6 CombinedRealm — Múltiples fuentes de autenticación](#656-combinedrealm--múltiples-fuentes-de-autenticación)
    - [6.5.7 JAASRealm — Delegación a JAAS](#657-jaasrealm--delegación-a-jaas)
  - [6.6 CredentialHandler — Hashing de Contraseñas](#66-credentialhandler--hashing-de-contraseñas)
    - [¿Por qué hashear contraseñas?](#por-qué-hashear-contraseñas)
  - [6.7 Métodos de Autenticación en web.xml](#67-métodos-de-autenticación-en-webxml)
    - [6.7.1 BASIC Authentication](#671-basic-authentication)
    - [6.7.2 FORM Authentication](#672-form-authentication)
    - [6.7.3 CLIENT-CERT Authentication (mTLS)](#673-client-cert-authentication-mtls)
    - [6.7.4 DIGEST Authentication](#674-digest-authentication)
  - [6.8 Single Sign-On (SSO) entre Aplicaciones](#68-single-sign-on-sso-entre-aplicaciones)
    - [¿Qué es SSO?](#qué-es-sso)
  - [6.9 Hardening de Seguridad del Servidor](#69-hardening-de-seguridad-del-servidor)
    - [6.9.1 Checklist completo de hardening](#691-checklist-completo-de-hardening)
    - [6.9.2 Configuración de SecurityManager (Java Security Policy)](#692-configuración-de-securitymanager-java-security-policy)
    - [6.9.3 Filtro de cabeceras de seguridad HTTP con HttpHeaderSecurityFilter](#693-filtro-de-cabeceras-de-seguridad-http-con-httpheadersecurityfilter)
    - [6.9.4 Filtro CORS incorporado de Tomcat](#694-filtro-cors-incorporado-de-tomcat)
  - [6.10 Auditoría de Seguridad: Valve de Acceso Avanzado](#610-auditoría-de-seguridad-valve-de-acceso-avanzado)
  - [6.11 Script de Auditoría de Seguridad de Tomcat](#611-script-de-auditoría-de-seguridad-de-tomcat)
  - [6.12 Diferencias de Seguridad entre Versiones](#612-diferencias-de-seguridad-entre-versiones)
  - [Puntos Clave](#puntos-clave)

---

# Módulo 06: Seguridad — TLS/SSL, Realms y Autenticación

## 6.1 Arquitectura de Seguridad en Tomcat

### ¿Por qué hablar de "capas" de seguridad?

La seguridad de un servidor web no es un único mecanismo, sino un conjunto de defensas independientes que trabajan en coordinación. La idea central es la **defensa en profundidad**: si un atacante consigue saltarse una capa, las capas restantes siguen protegiéndote. Confiar en una sola capa es un error de diseño; si esa capa falla, todo queda expuesto.

En Tomcat, la seguridad se articula en cuatro capas independientes y complementarias:

```
┌─────────────────────────────────────────────────────────────────┐
│  CAPA 1: Seguridad de Transporte (TLS/SSL)                      │
│  → Cifrado de comunicaciones, certificados, mTLS                │
├─────────────────────────────────────────────────────────────────┤
│  CAPA 2: Autenticación (Realms)                                 │
│  → Verificación de identidad: usuarios, contraseñas, roles      │
├─────────────────────────────────────────────────────────────────┤
│  CAPA 3: Autorización (Security Constraints)                    │
│  → Control de acceso a recursos por rol y método HTTP           │
├─────────────────────────────────────────────────────────────────┤
│  CAPA 4: Seguridad de Infraestructura                           │
│  → Hardening del servidor, Valves, cabeceras HTTP, permisos OS  │
└─────────────────────────────────────────────────────────────────┘
```

**Capa 1 — TLS/SSL:** Protege el canal de comunicación entre el cliente (navegador, otra aplicación) y el servidor. Garantiza que los datos viajan cifrados y que el servidor es quien dice ser (mediante certificados). Sin TLS, cualquier intermediario en la red puede leer las contraseñas y datos que se transmiten.

**Capa 2 — Autenticación (Realms):** Una vez que el canal es seguro, el servidor verifica la identidad del usuario. Un *Realm* en Tomcat es el componente que gestiona esta verificación: consulta una base de datos, un servidor LDAP, o un archivo de texto para comprobar si el usuario y contraseña son válidos y qué roles tiene.

**Capa 3 — Autorización:** La autenticación confirma *quién* eres; la autorización decide *qué puedes hacer*. Las `<security-constraint>` en `web.xml` (vistas en el Módulo 05) implementan esta capa: "solo los usuarios con el rol `admin` pueden acceder a `/admin/*`".

**Capa 4 — Hardening de infraestructura:** Son las medidas preventivas que reducen la superficie de ataque del servidor en sí: deshabilitar puertos innecesarios, ocultar información de versiones, configurar cabeceras HTTP de seguridad, restringir permisos del sistema operativo, etc.

---

## 6.2 TLS/SSL: Conceptos Fundamentales

### ¿Qué es TLS y por qué importa?

**TLS** (*Transport Layer Security*) es el protocolo criptográfico que hace que las conexiones HTTPS sean seguras. Su predecesor SSL (*Secure Sockets Layer*) está obsoleto y lleno de vulnerabilidades conocidas; cuando hoy se habla de "SSL" en el contexto de servidores web, en realidad se hace referencia a TLS.

TLS garantiza tres propiedades fundamentales:

- **Confidencialidad:** Los datos viajan cifrados. Aunque alguien intercepte el tráfico de red, solo ve bytes sin sentido.
- **Integridad:** Si los datos son alterados durante el tránsito, el destinatario lo detecta y rechaza el mensaje.
- **Autenticación del servidor:** El certificado digital del servidor demuestra al cliente que está hablando con el servidor legítimo y no con un impostor (ataque *man-in-the-middle*).

### ¿Cómo funciona el proceso de conexión TLS? (Handshake simplificado)

1. El cliente (navegador) se conecta al servidor y anuncia qué versiones de TLS y qué algoritmos criptográficos soporta.
2. El servidor responde con el certificado digital (que contiene su clave pública) y selecciona los algoritmos a usar.
3. El cliente verifica que el certificado está firmado por una Autoridad de Certificación (CA) de confianza y que el nombre del dominio coincide.
4. Ambas partes negocian una clave de sesión simétrica (diferente para cada conexión) usando criptografía asimétrica.
5. A partir de ahí, todos los datos se cifran con esa clave de sesión.

### 6.2.1 Tipos de implementación TLS en Tomcat

Tomcat puede usar tres implementaciones diferentes del protocolo TLS, con diferentes características de rendimiento y complejidad:

| Implementación | Librería         | Rendimiento | Configuración | Disponibilidad |
|----------------|------------------|-------------|---------------|----------------|
| JSSE           | Java SE (JDK)    | Media       | Simple        | Siempre        |
| OpenSSL (APR)  | libtcnative + OpenSSL | Alta  | Compleja      | Requiere APR   |
| OpenSSL (FFM)  | OpenSSL via FFM API | Alta    | Media         | Tomcat 11+     |

**JSSE** (*Java Secure Socket Extension*): Implementación TLS incluida en el propio JDK. No requiere instalar nada adicional. Rendimiento suficiente para la mayoría de aplicaciones. Es la opción por defecto y la recomendada para empezar.

**OpenSSL via APR** (*Apache Portable Runtime*): Usa la librería nativa OpenSSL a través de `libtcnative`. Ofrece mayor rendimiento en escenarios de muy alto volumen de conexiones TLS porque OpenSSL está altamente optimizado y puede aprovechar instrucciones de hardware para criptografía. Requiere compilar e instalar `libtcnative` en el sistema.

**OpenSSL via FFM**: Disponible en Tomcat 11+, usa la *Foreign Function & Memory API* de Java 22 para acceder a OpenSSL sin necesidad de `libtcnative`. Combina el rendimiento de OpenSSL con una instalación más sencilla.

### 6.2.2 Versiones de TLS soportadas por Tomcat

La versión de TLS determina qué algoritmos criptográficos se pueden usar. Versiones más antiguas tienen vulnerabilidades conocidas y deben deshabilitarse explícitamente en versiones antiguas de Tomcat.

| Protocolo | Tomcat 8.0 | Tomcat 8.5 | Tomcat 9.0 | Tomcat 10.x | Tomcat 11.0 |
|-----------|------------|------------|------------|-------------|-------------|
| SSLv3     | ❌ Disabled| ❌ Disabled| ❌ Disabled| ❌ Disabled | ❌ Disabled |
| TLSv1.0   | ✅          | ✅          | ⚠️ Dep.   | ❌ Disabled | ❌ Disabled |
| TLSv1.1   | ✅          | ✅          | ⚠️ Dep.   | ❌ Disabled | ❌ Disabled |
| TLSv1.2   | ✅          | ✅          | ✅          | ✅           | ✅           |
| TLSv1.3   | ❌          | ❌          | ✅ (JDK11+)| ✅           | ✅           |

**SSLv3, TLSv1.0 y TLSv1.1:** Considerados inseguros. TLSv1.0 y TLSv1.1 son vulnerables a ataques como POODLE y BEAST. No deben estar habilitados en producción. En Tomcat 10.x y 11.0 están deshabilitados por defecto. En Tomcat 8.x y 9.x debes deshabilitarlos explícitamente en la configuración del conector.

**TLSv1.2:** Versión mínima aceptable hoy en día. Soporta cipher suites modernos con *Perfect Forward Secrecy* (PFS).

**TLSv1.3:** La versión más moderna y segura. Simplifica el handshake (más rápido), elimina cipher suites inseguros y mejora la privacidad. Requerida si se quiere calificación A+ en herramientas como SSL Labs.

---

## 6.3 Gestión de Certificados

### ¿Qué es un certificado digital?

Un certificado digital es un documento electrónico que vincula una clave pública con la identidad de su propietario (un nombre de dominio, una organización). Lo que lo hace confiable es que está **firmado digitalmente por una Autoridad de Certificación (CA)**, que es una entidad en la que los navegadores confían por defecto.

Los navegadores incluyen una lista de CAs de confianza (Root CAs). Cuando tu servidor presenta un certificado firmado por una de esas CAs, el navegador lo acepta sin mostrar advertencias.

### ¿Qué es un KeyStore?

Un **KeyStore** es un archivo que almacena de forma segura claves criptográficas y certificados. Es como una caja fuerte para material criptográfico. Tomcat usa el KeyStore para:
- Almacenar la **clave privada** del servidor (secreta, nunca sale del servidor).
- Almacenar el **certificado del servidor** (público, se envía a los clientes durante el handshake TLS).
- Opcionalmente, almacenar los **certificados de CAs de confianza** (TrustStore).

Hay dos formatos principales de KeyStore:
- **JKS** (*Java KeyStore*): Formato propietario de Java. Sigue funcionando pero está en desuso desde Java 9.
- **PKCS12** (`.p12` o `.pfx`): Formato estándar e interoperable. Es el recomendado actualmente porque funciona con herramientas Java y no-Java (OpenSSL, etc.).

### 6.3.1 Generación de KeyStore JKS con keytool

`keytool` es una herramienta de línea de comandos incluida en el JDK para gestionar KeyStores. No necesitas instalar nada adicional.

```bash
# ======================================================
# 1. Generar KeyStore con par de claves RSA-2048
# ======================================================
# Este comando crea el KeyStore y dentro de él genera:
#   - Una clave privada RSA de 2048 bits
#   - Un certificado autofirmado válido 365 días
#
# -alias tomcat: Nombre con el que se identifica esta entrada dentro del KeyStore.
# -keyalg RSA: Algoritmo de la clave (RSA es el más compatible; ECDSA es más moderno).
# -keysize 2048: Longitud de la clave. 2048 es el mínimo aceptable; 4096 es más seguro.
# -validity 365: Días de validez del certificado autofirmado.
# -keystore: Ruta donde se crea/actualiza el archivo KeyStore.
# -storepass: Contraseña del KeyStore (protege el archivo completo).
# -keypass: Contraseña de la clave privada dentro del KeyStore.
# -dname: Distinguished Name — identifica al propietario del certificado.
#   CN = Common Name (dominio del servidor, CRÍTICO para la verificación TLS)
#   OU = Organizational Unit
#   O  = Organization
#   L  = Locality (ciudad)
#   ST = State/Province
#   C  = Country (código ISO 2 letras)
keytool -genkeypair \
  -alias tomcat \
  -keyalg RSA \
  -keysize 2048 \
  -validity 365 \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -keypass changeit \
  -dname "CN=app.miempresa.com, OU=IT, O=Mi Empresa SL, L=Madrid, ST=Madrid, C=ES"

# ======================================================
# 2. Generar CSR (Certificate Signing Request) para CA
# ======================================================
# El certificado autofirmado del paso 1 no es confiable para los navegadores.
# Para obtener un certificado firmado por una CA reconocida, necesitas generar
# un CSR: una solicitud de firma que contiene tu clave pública y los datos de
# tu organización. Lo envías a la CA (DigiCert, Sectigo, etc.) y ellos te
# devuelven el certificado firmado.
#
# -ext SAN: Subject Alternative Names — lista de dominios y/o IPs adicionales
# que el certificado debe cubrir. Los navegadores modernos requieren SAN;
# el CN solo ya no es suficiente para la validación del dominio.
keytool -certreq \
  -alias tomcat \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file app.miempresa.com.csr \
  -ext SAN=dns:app.miempresa.com,dns:www.app.miempresa.com

# ======================================================
# 3. Importar certificado firmado por CA
# ======================================================
# Una vez que la CA te devuelve el certificado firmado, debes importarlo
# al KeyStore EN EL ORDEN CORRECTO: primero la CA raíz, luego la CA
# intermedia (si existe), y finalmente el certificado del servidor.
# El orden incorrecto produce errores de "incomplete certificate chain".

# 3a. Importar certificado raíz de la CA (la entidad de máxima confianza)
# -trustcacerts: Indica que es un certificado de CA, no de servidor.
keytool -importcert \
  -alias root-ca \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file root-ca.crt \
  -trustcacerts \
  -noprompt

# 3b. Importar certificado intermedio de la CA
# (Las CAs modernas rara vez firman directamente con su Root CA;
# usan una CA intermedia para limitar la exposición de la Root CA)
keytool -importcert \
  -alias intermediate-ca \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file intermediate-ca.crt \
  -noprompt

# 3c. Importar el certificado del servidor firmado por la CA.
# DEBE usar el mismo alias que la clave privada generada en el paso 1 ("tomcat"),
# para que keytool asocie el certificado con su clave privada.
keytool -importcert \
  -alias tomcat \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file app.miempresa.com.crt \
  -noprompt

# ======================================================
# 4. Verificar el KeyStore
# ======================================================
# Lista el contenido del KeyStore: alias, tipo de entrada (PrivateKeyEntry
# o trustedCertEntry), fechas de validez, huellas digitales, etc.
# Ejecutar esto después de cualquier cambio para verificar que el contenido es correcto.
keytool -list -v \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit

# ======================================================
# 5. Generar KeyStore PKCS12 (recomendado sobre JKS desde Java 9+)
# ======================================================
# PKCS12 es el estándar moderno. Es interoperable con OpenSSL y otras
# herramientas, a diferencia de JKS que es propietario de Java.
# Desde Java 9, el tipo por defecto de keytool ya es PKCS12.
#
# RSA 4096 bits para mayor seguridad (a costa de un handshake TLS ligeramente más lento).
# -ext SAN: Incluir SANs directamente en la generación (evita un paso extra).
keytool -genkeypair \
  -alias tomcat \
  -keyalg RSA \
  -keysize 4096 \
  -validity 730 \
  -storetype PKCS12 \
  -keystore $CATALINA_BASE/conf/ssl/keystore.p12 \
  -storepass changeit \
  -dname "CN=app.miempresa.com, OU=IT, O=Mi Empresa SL, L=Madrid, ST=Madrid, C=ES" \
  -ext "SAN=dns:app.miempresa.com,dns:www.app.miempresa.com,ip:10.0.0.1"

# ======================================================
# 6. Convertir PEM (Let's Encrypt / OpenSSL) a PKCS12
# ======================================================
# Let's Encrypt y la mayoría de CAs entregan los certificados en formato PEM
# (archivos de texto con cabeceras -----BEGIN CERTIFICATE-----).
# Tomcat prefiere PKCS12. openssl hace la conversión:
#
# -in fullchain.pem: Certificado del servidor + cadena de CAs intermedias.
# -inkey privkey.pem: Clave privada del servidor.
# -out keystore.p12: Archivo PKCS12 de salida.
# -name tomcat: Alias con el que se almacenará la entrada en el PKCS12.
# -CAfile chain.pem: Cadena de CAs (para incluirla en el PKCS12 si es necesario).
openssl pkcs12 -export \
  -in fullchain.pem \
  -inkey privkey.pem \
  -out keystore.p12 \
  -name tomcat \
  -CAfile chain.pem \
  -caname root \
  -passout pass:changeit

# Convertir PKCS12 a JKS si, por alguna razón, necesitas JKS
# (p.ej. versiones muy antiguas de Tomcat o herramientas legacy)
keytool -importkeystore \
  -srckeystore keystore.p12 \
  -srcstoretype PKCS12 \
  -srcstorepass changeit \
  -destkeystore keystore.jks \
  -deststoretype JKS \
  -deststorepass changeit \
  -destkeypass changeit
```

### 6.3.2 Integración con Let's Encrypt (Certbot)

**¿Qué es Let's Encrypt?**
Let's Encrypt es una CA gratuita, automatizada y abierta, patrocinada por grandes empresas tecnológicas (Mozilla, Google, Cisco...). Proporciona certificados TLS válidos sin coste. Sus certificados son reconocidos por todos los navegadores modernos. La única limitación es que expiran cada 90 días (lo que fomenta la automatización de la renovación).

**Certbot** es la herramienta oficial para obtener y renovar certificados de Let's Encrypt.

```bash
# Obtener certificado Let's Encrypt (modo standalone)
# --standalone: Certbot levanta temporalmente un servidor HTTP propio
#               en el puerto 80 para que Let's Encrypt pueda verificar
#               que controlas el dominio. Tomcat debe estar parado
#               o el puerto 80 debe estar libre.
# --preferred-challenges http: Usa el challenge HTTP-01 (el más simple:
#   Let's Encrypt hace una petición HTTP al dominio y verifica un archivo).
# --http-01-port 80: Puerto donde escucha el challenge.
# -d: Dominios para los que se solicita el certificado (hasta 100 SANs).
# --agree-tos: Acepta los términos de servicio automáticamente.
# --non-interactive: No hace preguntas (para scripts automatizados).
sudo certbot certonly \
  --standalone \
  --preferred-challenges http \
  --http-01-port 80 \
  -d app.miempresa.com \
  -d www.app.miempresa.com \
  --email admin@miempresa.com \
  --agree-tos \
  --non-interactive

# Los certificados quedan en /etc/letsencrypt/live/<dominio>/:
#   fullchain.pem — Certificado del servidor + cadena de CAs intermedias
#                   (este es el que envías al cliente durante el handshake TLS)
#   privkey.pem   — Clave privada del servidor (¡mantener seguro!)
#   cert.pem      — Solo el certificado del servidor (sin cadena)
#   chain.pem     — Solo las CAs intermedias (sin el certificado del servidor)

# Convertir a PKCS12 para que Tomcat pueda usarlo
# NOTA: Las rutas bajo /etc/letsencrypt/live/ son enlaces simbólicos
# que apuntan a la versión más reciente del certificado. Certbot los
# actualiza automáticamente al renovar.
sudo openssl pkcs12 -export \
  -in /etc/letsencrypt/live/app.miempresa.com/fullchain.pem \
  -inkey /etc/letsencrypt/live/app.miempresa.com/privkey.pem \
  -out $CATALINA_BASE/conf/ssl/keystore.p12 \
  -name tomcat \
  -passout pass:${KEYSTORE_PASSWORD}

# Ajustar permisos: solo el usuario de Tomcat puede leer el KeyStore.
# La clave privada nunca debe ser legible por otros usuarios del sistema.
sudo chown tomcat:tomcat $CATALINA_BASE/conf/ssl/keystore.p12
sudo chmod 640 $CATALINA_BASE/conf/ssl/keystore.p12

# ======================================================
# Script de renovación automática
# /etc/cron.d/certbot-tomcat-renew
# ======================================================
# Let's Encrypt recomienda renovar cuando quedan menos de 30 días.
# Ejecutar el script dos veces al mes cubre ese margen con holgura.
cat > /etc/cron.d/certbot-tomcat-renew << 'EOF'
# Renovar certificado a las 3:00 AM el día 1 y 15 de cada mes
0 3 1,15 * * root certbot renew --quiet --post-hook "/opt/scripts/convert-cert-tomcat.sh"
EOF

# Script post-renovación:
# Se ejecuta automáticamente solo cuando certbot renueva el certificado.
# Si el certificado todavía no necesita renovarse, certbot no ejecuta el post-hook.
cat > /opt/scripts/convert-cert-tomcat.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail

DOMAIN="app.miempresa.com"
KEYSTORE_PASS="${KEYSTORE_PASSWORD}"
KEYSTORE_PATH="/opt/tomcat/conf/ssl/keystore.p12"

# Convertir el nuevo certificado al formato PKCS12 para Tomcat
openssl pkcs12 -export \
  -in /etc/letsencrypt/live/$DOMAIN/fullchain.pem \
  -inkey /etc/letsencrypt/live/$DOMAIN/privkey.pem \
  -out $KEYSTORE_PATH \
  -name tomcat \
  -passout pass:$KEYSTORE_PASS

chown tomcat:tomcat $KEYSTORE_PATH
chmod 640 $KEYSTORE_PATH

# Recargar el certificado en Tomcat SIN reiniciarlo (ver sección 6.4.3)
curl -s -u deployer:password \
  "http://localhost:8080/manager/text/sslConnectorCerts"

echo "Certificado renovado y recargado: $(date)"
SCRIPT

chmod +x /opt/scripts/convert-cert-tomcat.sh
```

---

## 6.4 Configuración TLS Completa en server.xml

### 6.4.1 HTTPS con PKCS12 — Tomcat 8.5+ (Configuración recomendada)

A partir de Tomcat 8.5, la configuración TLS usa el elemento `<SSLHostConfig>` dentro del Connector, en lugar de los atributos directos que usaban versiones anteriores. Esta estructura es más flexible: permite configurar múltiples certificados (RSA y ECDSA simultáneos) y múltiples dominios via SNI.

**¿Qué es SNI?** *Server Name Indication* es una extensión de TLS que permite al cliente indicar al servidor, en el primer mensaje del handshake, a qué dominio se está conectando. Esto hace posible que un único servidor con una única IP pueda albergar múltiples dominios con certificados TLS diferentes. Sin SNI, solo podrías tener un certificado TLS por IP.

```xml
<Connector port="8443"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           maxThreads="200"
           scheme="https"
           secure="true"
           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxConnections="10000"
           acceptCount="200"
           server="Apache">
  <!--
    protocol="Http11NioProtocol": Usa el conector NIO (Non-blocking I/O).
    Es el conector estándar recomendado. "Nio2" también existe para I/O asíncrono.
    
    SSLEnabled="true": Activa TLS para este conector.
    
    scheme="https" y secure="true": Indica a la aplicación Java que las
    peticiones que llegan son HTTPS. Sin esto, request.isSecure() devuelve
    false aunque la conexión sea TLS, lo que puede causar problemas con
    redirecciones y cookies Secure.
    
    maxThreads: Número máximo de hilos para procesar peticiones.
    keepAliveTimeout: Tiempo máximo en ms que el servidor mantiene una
    conexión keep-alive abierta esperando más peticiones del mismo cliente.
    maxConnections: Número máximo de conexiones TCP aceptadas simultáneamente.
    acceptCount: Tamaño de la cola de conexiones pendientes cuando se alcanzan
    maxConnections. Las conexiones que superen esto se rechazan.
    server="Apache": Oculta la versión real de Tomcat en la cabecera Server.
  -->

  <!--
    SSLHostConfig principal — dominio por defecto.
    Se aplica cuando el SNI del cliente no coincide con ningún otro
    SSLHostConfig definido, o cuando el cliente no envía SNI.
  -->
  <SSLHostConfig
    hostName="_default_"

    protocols="TLSv1.2+TLSv1.3"
    <!--
      "TLSv1.2+TLSv1.3" significa: habilitar TLS 1.2 Y TLS 1.3.
      El "+" es el operador de unión en la sintaxis de Tomcat.
      Para solo TLS 1.3: protocols="TLSv1.3"
      Para deshabilitar TLS 1.0/1.1 explícitamente en Tomcat 8.x/9.x:
        protocols="TLSv1.2+TLSv1.3" ya excluye las versiones menores.
    -->

    ciphers="TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:
             TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:
             ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:
             ECDHE-ECDSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:
             DHE-RSA-AES128-GCM-SHA256"
    <!--
      Lista de cipher suites permitidos, en orden de preferencia.
      
      TLS 1.3 usa su propio conjunto de cipher suites (TLS_AES_*,
      TLS_CHACHA20_*) que son siempre seguros; no pueden desactivarse
      individualmente en TLS 1.3.
      
      Para TLS 1.2 se especifican los cipher suites manualmente:
      - ECDHE-*: Usan Elliptic Curve Diffie-Hellman Ephemeral para el
        intercambio de claves → Perfect Forward Secrecy (PFS).
      - PFS significa que si la clave privada del servidor es comprometida
        en el futuro, no permite descifrar conversaciones pasadas grabadas.
      - AES-GCM: Modo de cifrado autenticado (cifrado + integridad en un paso).
      - Excluidos: RC4 (roto), 3DES (SWEET32), NULL, EXPORT (vulnerables).
    -->

    honorCipherOrder="false"
    <!--
      false: El cliente elige el cipher suite de su preferencia entre los
      permitidos. Recomendado en TLS 1.3 que ya garantiza cipher suites seguros.
      true: El servidor impone su orden de preferencia.
      En TLS 1.2, "true" asegura que se usen los cipher suites más fuertes
      cuando el cliente soporta tanto fuertes como débiles.
    -->

    disableSessionTickets="false"
    sessionCacheSize="0"
    sessionTimeout="86400"
    <!--
      Session tickets: Mecanismo de reanudación de sesiones TLS.
      Permite que un cliente que ya completó el handshake lo omita en
      reconexiones (más rápido). sessionTimeout=86400 = 24 horas.
      sessionCacheSize=0 = sin límite de tamaño.
    -->

    certificateVerification="none"
    <!--
      "none": No se requiere ni verifica certificado del cliente (TLS estándar).
      Para mTLS (autenticación mutua), ver sección 6.4.2.
    -->

    certificateRevocationListFile=""
    revocationEnabled="false">
    <!--
      Revocación de certificados: Mecanismo para invalidar certificados
      antes de su fecha de expiración (si la clave privada fue comprometida,
      si el certificado fue emitido por error, etc.).
      CRL (Certificate Revocation List): Lista de certificados revocados
      que el servidor descarga periódicamente.
      OCSP Stapling (Online Certificate Status Protocol): Alternativa más
      moderna y eficiente a las CRLs. Tomcat 8.5+ lo soporta.
    -->

    <!-- Certificado RSA — para compatibilidad máxima -->
    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.p12"
      certificateKeystorePassword="${ssl.keystore.password}"
      <!--
        La contraseña del KeyStore se lee de una propiedad del sistema,
        no está en texto plano en el XML. Configúrala en conf/catalina.properties
        o pásala al arranque con -Dssl.keystore.password=valor.
        NUNCA escribas contraseñas directamente en server.xml.
      -->
      certificateKeystoreType="PKCS12"
      certificateKeyAlias="tomcat"/>

    <!-- Certificado ECDSA — para clientes modernos (más eficiente que RSA) -->
    <Certificate
      type="EC"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore-ec.p12"
      certificateKeystorePassword="${ssl.keystore.ec.password}"
      certificateKeystoreType="PKCS12"
      certificateKeyAlias="tomcat-ec"/>
    <!--
      Dual-certificate (RSA + ECDSA):
      Permite que el servidor presente certificados RSA y ECDSA simultáneamente.
      El cliente negocia cuál usar según su soporte:
      - Clientes modernos (TLS 1.3, Chrome, Firefox) → ECDSA (más rápido, claves más cortas)
      - Clientes legacy (IE, Android antiguo) → RSA (máxima compatibilidad)
      Requiere tener dos KeyStores separados, uno para cada tipo de clave.
    -->

  </SSLHostConfig>

  <!--
    SSLHostConfig adicional para un dominio específico via SNI.
    Cuando el cliente se conecta indicando "api.miempresa.com" en el SNI,
    Tomcat selecciona este SSLHostConfig y presenta el certificado de la API.
    El mismo Tomcat puede así servir múltiples dominios con diferentes
    certificados TLS desde el mismo puerto 8443.
  -->
  <SSLHostConfig
    hostName="api.miempresa.com"
    protocols="TLSv1.3"
    ciphers="TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256">
    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/api-keystore.p12"
      certificateKeystorePassword="${ssl.api.keystore.password}"
      certificateKeystoreType="PKCS12"
      certificateKeyAlias="api-tomcat"/>
  </SSLHostConfig>

</Connector>
```

### 6.4.2 mTLS — Autenticación mutua con certificados de cliente

**¿Qué es mTLS?**
En TLS estándar, solo el servidor presenta un certificado. El cliente (navegador) verifica que el servidor es legítimo, pero el servidor no verifica la identidad del cliente más allá de un usuario/contraseña.

En **mTLS** (*mutual TLS* o TLS mutuo), **ambas partes** presentan certificados. El servidor verifica que el cliente tiene un certificado emitido por una CA de confianza antes de permitir la conexión. Es el mecanismo de autenticación más seguro disponible en TLS.

**Casos de uso típicos de mTLS:**
- Comunicación entre microservicios (machine-to-machine, M2M). En lugar de tokens, cada servicio tiene su propio certificado.
- Acceso a APIs internas de alta seguridad (entornos financieros, sanitarios).
- Arquitecturas Zero Trust, donde no se confía en ningún cliente por defecto aunque esté dentro de la red corporativa.

```xml
<!--
  Conector mTLS en el puerto 8444 (puerto distinto al HTTPS normal).
  En producción puede estar en el mismo puerto usando SNI para distinguir.
-->
<Connector port="8444"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           scheme="https"
           secure="true"
           maxThreads="100"
           connectionTimeout="20000">

  <SSLHostConfig
    hostName="_default_"
    protocols="TLSv1.2+TLSv1.3"
    ciphers="TLS_AES_256_GCM_SHA384:ECDHE-RSA-AES256-GCM-SHA384"

    certificateVerification="required"
    <!--
      Valores de certificateVerification:
      
      none: TLS estándar — el servidor no solicita certificado al cliente.
      
      optional: El servidor solicita certificado al cliente, pero si el
        cliente no lo tiene, la conexión continúa. El Servlet puede
        comprobar después si el cliente presentó certificado o no.
      
      required: mTLS real — el servidor EXIGE que el cliente presente
        un certificado válido. Si no lo tiene o no es válido, la conexión
        TLS falla inmediatamente (antes de procesar ninguna petición HTTP).
      
      optionalNoCA: Acepta cualquier certificado del cliente, incluso
        autofirmados. Solo para casos muy específicos de testing o
        arquitecturas con PKI propia no estándar.
    -->

    truststoreFile="${catalina.base}/conf/ssl/client-truststore.jks"
    truststorePassword="${ssl.truststore.password}"
    truststoreType="JKS"
    <!--
      TrustStore: Contiene los certificados de las CAs que Tomcat considerará
      como emisoras válidas de certificados de clientes.
      
      Solo los clientes con certificados emitidos por estas CAs podrán conectarse.
      Es el equivalente a la "lista blanca" de clientes autorizados a nivel TLS.
      
      Es un archivo separado del KeyStore (que contiene el certificado del servidor).
      Se puede usar JKS o PKCS12 para el TrustStore también.
    -->

    certificateVerificationDepth="5">
    <!--
      Profundidad máxima de la cadena de certificación del cliente.
      Si el certificado del cliente está firmado directamente por una CA
      del TrustStore → depth 1.
      Si está firmado por una CA intermedia, que a su vez está firmada
      por una Root CA del TrustStore → depth 2.
      5 es un valor generoso que cubre la mayoría de PKIs corporativas.
    -->

    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/server-keystore.p12"
      certificateKeystorePassword="${ssl.keystore.password}"
      certificateKeystoreType="PKCS12"/>

  </SSLHostConfig>

</Connector>
```

```java
// Acceder a los atributos del certificado de cliente en un Servlet
// Una vez que el handshake mTLS ha completado, Tomcat inyecta el
// certificado del cliente como atributo de la petición.
package com.miempresa.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.cert.X509Certificate;

@WebServlet("/api/mtls/*")
public class MtlsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        // Tomcat pone el certificado del cliente en este atributo estándar.
        // Es un array porque el cliente puede presentar una cadena de certificados.
        // El elemento [0] es siempre el certificado del propio cliente (leaf certificate).
        // En Tomcat 9-: "javax.servlet.request.X509Certificate"
        // En Tomcat 10+: "jakarta.servlet.request.X509Certificate"
        X509Certificate[] certs = (X509Certificate[])
            request.getAttribute("jakarta.servlet.request.X509Certificate");

        if (certs == null || certs.length == 0) {
            // Esto solo puede ocurrir si certificateVerification="optional".
            // Con "required", si no hay certificado la conexión TLS falla antes.
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED,
                "Certificado de cliente requerido");
            return;
        }

        X509Certificate clientCert = certs[0];

        // Subject DN: El Distinguished Name del propietario del certificado.
        // Contiene CN, O, OU, C, etc. Puede usarse para identificar al cliente.
        String subjectDN  = clientCert.getSubjectX500Principal().getName();
        // Issuer DN: El Distinguished Name de la CA que firmó el certificado.
        String issuerDN   = clientCert.getIssuerX500Principal().getName();
        // Número de serie único asignado por la CA. Útil para auditoría y revocación.
        String serialNum  = clientCert.getSerialNumber().toString(16);

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().printf("""
            {
              "authenticated": true,
              "subject": "%s",
              "issuer": "%s",
              "serial": "%s",
              "validFrom": "%s",
              "validTo": "%s"
            }
            """,
            subjectDN, issuerDN, serialNum,
            clientCert.getNotBefore(),
            clientCert.getNotAfter()
        );
    }
}
```

### 6.4.3 Recarga de certificados TLS sin reinicio — Tomcat 8.5+

Los certificados TLS expiran (normalmente cada 1-2 años, o cada 90 días con Let's Encrypt). En versiones antiguas de Tomcat, actualizar el certificado requería reiniciar el servidor, interrumpiendo el servicio.

Desde Tomcat 8.5, es posible **recargar los certificados en caliente** via el Manager API, sin interrumpir las conexiones activas.

```bash
# Ver los certificados actuales cargados en todos los conectores SSL.
# Muestra alias, tipo de clave, fechas de validez y CA emisora.
curl -u admin:password \
  "http://localhost:8080/manager/text/sslConnectorCerts"

# Ver los cipher suites actualmente configurados en los conectores SSL.
# Útil para verificar que no hay cipher suites inseguros activos.
curl -u admin:password \
  "http://localhost:8080/manager/text/sslConnectorCiphers"

# Recargar los certificados para un hostname TLS específico.
# Tomcat lee de nuevo el KeyStore desde disco y actualiza el certificado
# en memoria, sin interrumpir las conexiones existentes.
# El nuevo certificado se aplica a las NUEVAS conexiones TLS.
curl -u admin:password \
  "http://localhost:8080/manager/text/sslReload?tlsHostName=app.miempresa.com"
```

---

## 6.5 Realms: Sistema de Autenticación de Tomcat

### ¿Qué es un Realm?

Un **Realm** es el componente de Tomcat que implementa la autenticación: verifica que un usuario existe y que la contraseña es correcta, y devuelve los roles asociados a ese usuario.

El Realm es independiente del método de autenticación (BASIC, FORM, CLIENT-CERT). El método define *cómo* el cliente envía las credenciales; el Realm define *dónde* se verifican esas credenciales.

Cuando el usuario introduce su contraseña, Tomcat:
1. Recibe las credenciales (usuario + contraseña).
2. Se las pasa al Realm configurado.
3. El Realm busca al usuario en su fuente de datos (archivo XML, BD, LDAP...).
4. Verifica la contraseña contra el hash almacenado.
5. Devuelve los roles del usuario si la autenticación es correcta.
6. Tomcat aplica las `<security-constraint>` para decidir si el usuario tiene acceso al recurso solicitado.

### 6.5.1 MemoryRealm — Solo desarrollo

`MemoryRealm` carga los usuarios desde el archivo `conf/tomcat-users.xml` al arrancar Tomcat. Los cambios en el archivo requieren reinicio para ser efectivos. Es extremadamente simple de configurar pero completamente inadecuado para producción: todos los usuarios están en un archivo de texto plano en el servidor, no escala, y no tiene integración con sistemas de identidad corporativos.

**Úsalo exclusivamente para desarrollo y testing local.**

```xml
<!-- server.xml o context.xml -->
<Realm className="org.apache.catalina.realm.MemoryRealm"
       pathname="conf/tomcat-users.xml"
       digest="SHA-256"/>
<!--
  pathname: Ruta al archivo de usuarios. Relativa a CATALINA_BASE.
  digest: Algoritmo de hash con el que están almacenadas las contraseñas.
  Si "digest" se omite, Tomcat espera contraseñas en texto plano (NUNCA en producción).
-->
```

```xml
<!-- conf/tomcat-users.xml con passwords hasheados -->
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users>

  <!-- Declaración de roles disponibles -->
  <role rolename="admin"/>
  <role rolename="manager-gui"/>     <!-- Acceso a la interfaz web del Manager -->
  <role rolename="manager-script"/>  <!-- Acceso a la API REST del Manager (para CI/CD) -->
  <role rolename="manager-status"/>  <!-- Acceso solo a la página de estado -->

  <!--
    El password NO está en texto plano. Está hasheado con SHA-256.
    Para generar un hash SHA-256 de una contraseña:
      bin/digest.sh -a SHA-256
                    -h org.apache.catalina.realm.MessageDigestCredentialHandler
                    mipassword
    
    El hash de "admin" con SHA-256 es:
    8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
    
    IMPORTANTE: En producción, incluso con hashing, los hashes simples como
    SHA-256 sin sal son vulnerables a ataques de rainbow table.
    Usar PBKDF2 o bcrypt (ver sección 6.6).
  -->
  <user username="admin"
        password="8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
        roles="admin,manager-gui,manager-script,manager-status"/>

</tomcat-users>
```

### 6.5.2 JDBCRealm — Usuarios en base de datos (JDBC directo)

`JDBCRealm` almacena los usuarios en una base de datos relacional y hace consultas JDBC directas para autenticar. A diferencia de `MemoryRealm`, los cambios en la BD son efectivos inmediatamente sin reiniciar.

**Limitación importante:** `JDBCRealm` gestiona su propia conexión a la BD, fuera del pool de conexiones de la aplicación. Esto significa que mantiene una conexión permanente abierta a la BD solo para autenticación, y si la BD se reinicia, esa conexión puede quedar en estado inválido sin que Tomcat lo detecte. Por eso se prefiere `DataSourceRealm` (sección 6.5.3) en producción.

```xml
<Realm className="org.apache.catalina.realm.JDBCRealm"
       driverName="org.postgresql.Driver"
       connectionURL="jdbc:postgresql://db-host:5432/security_db"
       connectionName="tomcat_user"
       connectionPassword="${db.password}"
       <!--
         El driver JDBC de la BD (postgresql-42.x.jar) debe estar en
         $CATALINA_HOME/lib/, no en WEB-INF/lib/ de la aplicación.
         JDBCRealm es un componente de Tomcat, no de la aplicación,
         y carga clases desde el classloader de Tomcat.
       -->

       userTable="app_users"          <!-- Tabla donde están los usuarios -->
       userNameCol="username"         <!-- Columna del nombre de usuario -->
       userCredCol="password_hash"    <!-- Columna con el hash de la contraseña -->

       userRoleTable="app_user_roles" <!-- Tabla de roles de usuarios -->
       roleNameCol="role_name"        <!-- Columna con el nombre del rol -->

       digest="SHA-256"               <!-- Algoritmo de hash de contraseñas -->
       digestEncoding="UTF-8"

       userClassNames=""
       roleClassNames=""/>
```

```sql
-- Esquema de tablas para JDBCRealm
-- Tomcat espera exactamente este tipo de estructura: una tabla de usuarios
-- y una tabla de relación usuario-rol. Los nombres de tabla y columna
-- son configurables en el XML anterior.

CREATE TABLE app_users (
    id           BIGSERIAL    PRIMARY KEY,
    username     VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    enabled      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    last_login   TIMESTAMP
);

CREATE TABLE app_user_roles (
    username  VARCHAR(100) NOT NULL REFERENCES app_users(username),
    role_name VARCHAR(50)  NOT NULL,
    PRIMARY KEY (username, role_name)
    -- Clave primaria compuesta: un usuario puede tener múltiples roles,
    -- pero no puede tener el mismo rol dos veces.
);

-- Índices para acelerar las consultas de autenticación
-- (Tomcat hace una consulta por username en cada login)
CREATE INDEX idx_users_username ON app_users(username);
CREATE INDEX idx_roles_username ON app_user_roles(username);

-- Insertar usuario con password SHA-256
-- El hash corresponde a "admin123" con SHA-256 simple (sin sal).
-- En producción usar PBKDF2 con salt (ver sección 6.6 sobre CredentialHandler).
INSERT INTO app_users (username, password_hash)
VALUES ('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a');

INSERT INTO app_user_roles (username, role_name)
VALUES ('admin', 'admin'), ('admin', 'manager');
```

### 6.5.3 DataSourceRealm — Usuarios en BD via pool JNDI (recomendado)

`DataSourceRealm` es funcionalmente idéntico a `JDBCRealm` pero en lugar de gestionar su propia conexión, usa un **DataSource JNDI** (el pool de conexiones configurado en Tomcat, como se vio en el Módulo 05). Esto es mejor por varios motivos:

- Reutiliza el pool de conexiones ya configurado y monitoreado.
- Se beneficia de la gestión de reconexiones automáticas del pool.
- No mantiene una conexión exclusiva abierta solo para autenticación.
- La configuración de la BD está centralizada en un único lugar (context.xml).

```xml
<!--
  DataSourceRealm: versión mejorada de JDBCRealm.
  Usa el pool de conexiones JNDI en lugar de gestionar su propia conexión.
  RECOMENDADO sobre JDBCRealm para producción.
  
  El DataSource "jdbc/SecurityDB" debe estar definido en context.xml.
-->
<Realm className="org.apache.catalina.realm.DataSourceRealm"
       dataSourceName="jdbc/SecurityDB"
       localDataSource="false"
       <!--
         localDataSource="false": El DataSource es global (definido en el
         server.xml o context.xml global). Se busca como java:/comp/env/jdbc/SecurityDB.
         localDataSource="true": El DataSource es local a la aplicación web.
       -->

       userTable="app_users"
       userNameCol="username"
       userCredCol="password_hash"

       userRoleTable="app_user_roles"
       roleNameCol="role_name"

       digest="SHA-256"
       digestEncoding="UTF-8"

       userClassNames=""
       allRolesMode="authOnly"/>
       <!--
         allRolesMode="authOnly": Para verificar si un usuario tiene acceso,
         Tomcat solo verifica que está autenticado (el rol "*" en auth-constraint).
         Valores: strictAuthOnly, authOnly, strict.
       -->
```

### 6.5.4 JNDIRealm — Autenticación contra LDAP / Active Directory

**¿Qué es LDAP?**
LDAP (*Lightweight Directory Access Protocol*) es un protocolo estándar para acceder a servicios de directorio. Un directorio LDAP es una base de datos optimizada para lecturas frecuentes que almacena información jerárquica: usuarios, grupos, equipos, políticas de empresa, etc.

**Active Directory** (AD) de Microsoft es la implementación LDAP más extendida en entornos empresariales. Gestiona todos los usuarios y grupos de una organización Windows.

`JNDIRealm` permite a Tomcat delegar la autenticación a un servidor LDAP/AD, lo que significa que los usuarios se gestionan en el directorio corporativo (AD) y no necesitas duplicarlos en una BD local. Cuando un empleado es dado de baja en AD, automáticamente pierde acceso a todas las aplicaciones que usan ese Realm.

```xml
<!--
  JNDIRealm: autenticación contra LDAP o Active Directory.
  Configuración para Active Directory corporativo.
-->
<Realm className="org.apache.catalina.realm.JNDIRealm"

       connectionURL="ldap://dc01.miempresa.com:389"
       <!--
         Puerto 389: LDAP sin cifrar. INSEGURO para producción.
         Puerto 636: LDAPS (LDAP sobre TLS). Usar siempre en producción.
         Puerto 3268: Global Catalog de AD (búsqueda en todo el bosque AD).
         alternateURL: Servidor LDAP de respaldo si el principal falla.
       -->
       alternateURL="ldap://dc02.miempresa.com:389"
       connectionTimeout="5000"   <!-- Timeout de conexión al servidor LDAP en ms -->
       readTimeout="10000"        <!-- Timeout para las operaciones LDAP en ms -->

       connectionName="cn=tomcat-service,ou=service-accounts,dc=miempresa,dc=com"
       connectionPassword="${ldap.service.password}"
       <!--
         Cuenta de servicio para el "bind inicial":
         Tomcat necesita conectarse al LDAP con una cuenta con permiso de lectura
         para buscar usuarios. Esta cuenta de servicio (service account) debe
         tener mínimo permiso de lectura en la OU de usuarios y grupos.
         NUNCA usar una cuenta de administrador de dominio aquí.
       -->

       userBase="ou=users,dc=miempresa,dc=com"
       <!--
         La rama (ou) del árbol LDAP donde buscar usuarios.
         dc=miempresa,dc=com es el dominio raíz.
         ou=users es la unidad organizativa donde están los usuarios.
       -->
       userSearch="(sAMAccountName={0})"
       <!--
         Filtro LDAP para buscar el usuario. {0} se sustituye por el
         username introducido en el login.
         sAMAccountName es el atributo de AD que contiene el nombre de login
         (el "username" en el login de Windows: DOMINIO\usuario).
         Para LDAP estándar (no AD) se usaría uid={0} en su lugar.
       -->
       userSubtree="true"
       <!--
         true: Busca en toda la subárbol bajo userBase (recursivo).
         false: Solo busca en el nivel inmediato de userBase.
         true es necesario si los usuarios están en sub-OUs.
       -->
       userPassword=""
       <!--
         Si se especifica, Tomcat hace una comparación directa del password
         contra el atributo LDAP. Si está vacío (recomendado), Tomcat
         hace un "bind" LDAP con las credenciales del usuario — el propio
         servidor LDAP verifica la contraseña, que nunca sale del directorio.
       -->

       roleBase="ou=groups,dc=miempresa,dc=com"
       roleName="cn"
       <!--
         cn (Common Name) es el atributo del grupo que Tomcat usará como
         nombre del rol. El nombre del grupo en AD se convierte en el nombre
         del rol en la aplicación.
       -->
       roleSearch="(member={0})"
       <!--
         Filtro para buscar los grupos a los que pertenece el usuario.
         {0} se sustituye por el DN completo del usuario encontrado.
         En AD: "member" contiene los DNs de los miembros del grupo.
       -->
       roleSubtree="true"

       referrals="follow"
       <!--
         En entornos AD con múltiples dominios (bosque AD), una búsqueda
         puede retornar una "referencia" a otro servidor LDAP donde continuar
         la búsqueda. "follow" significa seguir esas referencias automáticamente.
       -->

       adCompat="true"
       <!--
         Compatibilidad específica con Active Directory:
         - Usa el UPN (User Principal Name: usuario@miempresa.com) para
           el bind en lugar del DN completo.
         - Maneja las peculiaridades de AD en el protocolo LDAP.
         Siempre "true" cuando te conectas a Active Directory.
       -->

       connectionPoolSize="10"
       connectionPoolMaxSize="20"
       connectionPoolTimeout="300000"
       connectionPoolMinSize="5"/>
       <!--
         Pool de conexiones LDAP: en lugar de abrir una nueva conexión LDAP
         por cada autenticación, Tomcat mantiene un pool de conexiones
         reutilizables. Mejora significativamente el rendimiento en aplicaciones
         con muchos logins concurrentes.
       -->
```

```xml
<!--
  JNDIRealm con LDAPS (LDAP sobre TLS) — obligatorio en producción.
  Puerto 389 (LDAP sin cifrar) envía contraseñas en texto plano por la red.
-->
<Realm className="org.apache.catalina.realm.JNDIRealm"
       connectionURL="ldaps://dc01.miempresa.com:636"
       connectionTimeout="5000"
       connectionName="cn=tomcat-service,ou=SA,dc=miempresa,dc=com"
       connectionPassword="${ldap.service.password}"
       userBase="ou=users,dc=miempresa,dc=com"
       userSearch="(sAMAccountName={0})"
       userSubtree="true"
       roleBase="ou=groups,dc=miempresa,dc=com"
       roleName="cn"
       roleSearch="(member={0})"
       roleSubtree="true"
       adCompat="true">

  <!--
    Para LDAPS, el servidor AD presenta su certificado TLS y Tomcat debe
    confiar en la CA que lo firmó. La CA de AD generalmente no es una
    CA pública reconocida, sino la propia PKI de la empresa.
    
    Debes añadir el certificado de la CA del AD al TrustStore de la JVM
    o a un TrustStore específico y pasarlo como propiedad del sistema en
    conf/setenv.sh:
    
    JAVA_OPTS="$JAVA_OPTS \
      -Djavax.net.ssl.trustStore=/opt/tomcat/conf/ssl/ad-truststore.jks \
      -Djavax.net.ssl.trustStorePassword=trustpass"
    
    Sin esto, la conexión LDAPS fallará con "unable to find valid certification
    path to requested target".
  -->

</Realm>
```

### 6.5.5 LockOutRealm — Protección contra fuerza bruta

Un **ataque de fuerza bruta** consiste en intentar miles o millones de contraseñas automáticamente hasta dar con la correcta. Sin ninguna protección, un atacante puede intentar contraseñas indefinidamente.

`LockOutRealm` es un **wrapper** (envoltorio) que añade protección contra fuerza bruta a cualquier otro Realm. Después de un número configurable de intentos fallidos, bloquea la cuenta temporalmente.

**IMPORTANTE:** `LockOutRealm` no es un Realm independiente; siempre envuelve a otro Realm que hace la verificación real. La arquitectura es: `LockOutRealm → [tu Realm real]`.

```xml
<!--
  LockOutRealm: wrapper que añade bloqueo de cuenta
  por intentos fallidos de autenticación.
  Debe SIEMPRE envolver el Realm real en producción.
-->
<Realm className="org.apache.catalina.realm.LockOutRealm"

       failureCount="5"
       <!--
         Número de intentos fallidos consecutivos antes de bloquear la cuenta.
         5 es un valor habitual en entornos corporativos.
         Valores muy bajos (1-2) aumentan falsos positivos (un usuario legítimo
         que se equivoca dos veces queda bloqueado).
         Valores muy altos (50+) dejan pasar ataques de fuerza bruta lenta.
       -->

       lockOutTime="600"
       <!--
         Segundos que la cuenta permanece bloqueada tras alcanzar failureCount.
         600 segundos = 10 minutos.
         0 = bloqueo permanente (requiere intervención manual para desbloquear).
         El bloqueo se almacena en memoria: si Tomcat se reinicia, los bloqueos
         activos se pierden. No persiste en disco.
       -->

       cacheSize="1000"
       <!--
         Número máximo de usuarios cuyos intentos fallidos se rastrean simultáneamente.
         Protege contra un ataque que intente llenar la memoria con miles de
         nombres de usuario diferentes (ataque de amplificación del caché).
       -->

       cacheRemovalWarningTime="3600">
       <!--
         Cuando se elimina del caché una entrada que lleva más de este número
         de segundos (3600s = 1 hora), Tomcat registra una advertencia en el log.
         Útil para detectar ataques lentos que intentan evadir el lockout.
       -->

  <!-- Realm interno: el que hace la verificación real de credenciales -->
  <Realm className="org.apache.catalina.realm.DataSourceRealm"
         dataSourceName="jdbc/SecurityDB"
         userTable="app_users"
         userNameCol="username"
         userCredCol="password_hash"
         userRoleTable="app_user_roles"
         roleNameCol="role_name"
         digest="SHA-256"/>

</Realm>
```

### 6.5.6 CombinedRealm — Múltiples fuentes de autenticación

`CombinedRealm` permite tener **múltiples Realms en paralelo**. Cuando un usuario intenta autenticarse, Tomcat prueba cada Realm en el orden en que están definidos. El primero que autentifique al usuario con éxito "gana" y se usa su lista de roles.

**Casos de uso:**
- **Migración gradual:** Tienes usuarios en LDAP corporativo (nuevos) y en una BD local (legacy). Con `CombinedRealm`, ambos pueden autenticarse mientras migras los usuarios de BD a LDAP.
- **Cuentas de servicio:** Los robots y scripts de CI/CD usan cuentas locales en BD; los humanos usan LDAP.
- **Fallback:** Si el LDAP no está disponible, los usuarios caen al siguiente Realm.

```xml
<!--
  CombinedRealm: intenta autenticar con cada Realm en orden.
  El primero que tenga éxito gana. Si ninguno autentifica, falla.
  
  Envuelto en LockOutRealm para proteger contra fuerza bruta.
  El LockOutRealm opera sobre el CombinedRealm completo:
  cuenta los fallos de cualquiera de los Realms internos.
-->
<Realm className="org.apache.catalina.realm.LockOutRealm"
       failureCount="5"
       lockOutTime="300">

  <Realm className="org.apache.catalina.realm.CombinedRealm">

    <!-- Prioridad 1: LDAP corporativo — usuarios del directorio de empresa -->
    <Realm className="org.apache.catalina.realm.JNDIRealm"
           connectionURL="ldap://dc01.miempresa.com:389"
           connectionName="cn=tomcat-svc,dc=miempresa,dc=com"
           connectionPassword="${ldap.password}"
           userBase="ou=users,dc=miempresa,dc=com"
           userSearch="(sAMAccountName={0})"
           userSubtree="true"
           roleBase="ou=groups,dc=miempresa,dc=com"
           roleName="cn"
           roleSearch="(member={0})"
           roleSubtree="true"
           adCompat="true"/>

    <!-- Prioridad 2: BD local — cuentas de servicio / usuarios legacy -->
    <Realm className="org.apache.catalina.realm.DataSourceRealm"
           dataSourceName="jdbc/SecurityDB"
           userTable="local_users"
           userNameCol="username"
           userCredCol="password_hash"
           userRoleTable="local_user_roles"
           roleNameCol="role_name"
           digest="SHA-256"/>

  </Realm>
</Realm>
```

### 6.5.7 JAASRealm — Delegación a JAAS

**JAAS** (*Java Authentication and Authorization Service*) es el framework estándar de Java para autenticación y autorización. `JAASRealm` permite que Tomcat delegue la autenticación a un módulo JAAS personalizado.

Úsalo cuando necesitas una lógica de autenticación muy específica que no encaja en los Realms estándar, o cuando ya tienes una implementación JAAS que quieres reutilizar.

```xml
<Realm className="org.apache.catalina.realm.JAASRealm"
       appName="TomcatLogin"
       <!--
         Nombre de la configuración JAAS que Tomcat buscará en el archivo
         jaas.config. Debe coincidir exactamente con el bloque definido en él.
       -->
       userClassNames="com.miempresa.security.jaas.UserPrincipal"
       <!--
         Clase Java que implementa Principal y representa al usuario autenticado.
         JAAS devuelve un Subject con varios Principals; Tomcat necesita saber
         cuál es el "usuario" y cuáles son los "roles".
       -->
       roleClassNames="com.miempresa.security.jaas.RolePrincipal"
       <!--
         Clase que representa un rol. Los Principals de este tipo se convierten
         en roles de Tomcat.
       -->
       useContextClassLoader="true"
       configFile="${catalina.base}/conf/jaas.config"/>
```

```
# conf/jaas.config
# Define el LoginModule a usar para la configuración "TomcatLogin"
TomcatLogin {
    # El LoginModule personalizado que implementa la lógica de autenticación
    com.miempresa.security.jaas.DatabaseLoginModule required
        dataSource="jdbc/SecurityDB"
        userTable="app_users"
        passwordColumn="password_hash"
        roleTable="app_user_roles"
        debug="false";
        # "required": Este módulo DEBE tener éxito para que la autenticación
        # sea exitosa. Otros valores: requisite, sufficient, optional.
};
```

---

## 6.6 CredentialHandler — Hashing de Contraseñas

### ¿Por qué hashear contraseñas?

Nunca se deben almacenar contraseñas en texto plano en ninguna base de datos. Si la BD es comprometida, las contraseñas quedan expuestas directamente.

El hashing es un proceso unidireccional: a partir del hash no se puede obtener la contraseña original. Cuando el usuario hace login, se hashea la contraseña introducida y se compara con el hash almacenado.

**Hashes inadecuados para contraseñas:**
- **MD5:** Roto criptográficamente. Hay bases de datos de millones de hashes MD5 calculados previamente (*rainbow tables*). No usar nunca.
- **SHA-1:** Similar a MD5, demasiado rápido de calcular. No usar.
- **SHA-256 / SHA-512 simples (sin sal):** Vulnerables a rainbow tables si no se usa una sal (*salt*) única por usuario.

**Hashes adecuados para contraseñas:**
- **SHA-256 / SHA-512 con sal y múltiples iteraciones:** Mucho mejor. La sal única por usuario invalida las rainbow tables; las iteraciones hacen cada hash lento de calcular (costoso para el atacante, imperceptible para el usuario legítimo).
- **PBKDF2** (*Password-Based Key Derivation Function 2*): Diseñado específicamente para derivar claves a partir de contraseñas. Configurable en número de iteraciones. Es el estándar recomendado actualmente.
- **bcrypt, scrypt, Argon2:** También excelentes, pero requieren librerías externas en Java.

Tomcat 8.5+ introduce los `CredentialHandler` para configurar el algoritmo de hashing directamente en el Realm.

```xml
<!-- MessageDigestCredentialHandler — SHA-256 o SHA-512 con sal e iteraciones -->
<Realm className="org.apache.catalina.realm.DataSourceRealm"
       dataSourceName="jdbc/SecurityDB"
       userTable="app_users"
       userNameCol="username"
       userCredCol="password_hash"
       userRoleTable="app_user_roles"
       roleNameCol="role_name">

  <CredentialHandler
    className="org.apache.catalina.realm.MessageDigestCredentialHandler"
    algorithm="SHA-512"
    <!--
      Algoritmo de hash. SHA-512 es preferible a SHA-256 por mayor longitud.
      El hash resultante se almacena en la BD en el formato:
      iterations$salt$hash (para poder verificar posteriormente).
    -->
    encoding="hex"
    <!--
      Codificación del hash en la BD. "hex" produce caracteres hexadecimales.
      "Base64" produce una cadena más corta.
    -->
    saltLength="32"
    <!--
      Longitud de la sal aleatoria en bytes. 32 bytes = 256 bits de entropía.
      La sal se genera aleatoriamente para CADA usuario, haciendo que dos
      usuarios con la misma contraseña tengan hashes completamente diferentes.
    -->
    iterations="100000"/>
    <!--
      Número de iteraciones del algoritmo de hash.
      Más iteraciones = más tiempo de CPU para calcular el hash = más difícil
      para un atacante que intenta fuerza bruta.
      100.000 iteraciones tardan ~100ms en hardware moderno: imperceptible
      para el usuario en un login, pero muy costoso para millones de intentos
      automatizados. Ajustar según el hardware del servidor.
    -->

</Realm>
```

```xml
<!-- SecretKeyCredentialHandler — PBKDF2 (recomendado para producción) -->
<Realm className="org.apache.catalina.realm.DataSourceRealm"
       dataSourceName="jdbc/SecurityDB"
       userTable="app_users"
       userNameCol="username"
       userCredCol="password_hash"
       userRoleTable="app_user_roles"
       roleNameCol="role_name">

  <CredentialHandler
    className="org.apache.catalina.realm.SecretKeyCredentialHandler"
    algorithm="PBKDF2WithHmacSHA512"
    <!--
      PBKDF2 con HMAC-SHA512: El algoritmo más recomendado hoy en día
      para derivación de contraseñas. Ampliamente auditado y soportado.
    -->
    keyLength="256"
    <!--
      Longitud de la clave derivada en bits. 256 bits es más que suficiente.
    -->
    saltLength="32"    <!-- 32 bytes de sal aleatoria por usuario -->
    iterations="600000"/>
    <!--
      OWASP recomienda 600.000 iteraciones mínimas para PBKDF2WithHmacSHA256
      en 2024. Para PBKDF2WithHmacSHA512, 210.000 iteraciones son equivalentes
      en seguridad. Ajustar según el rendimiento del servidor:
      el hash de un login no debe tardar más de ~300ms para buena UX.
    -->

</Realm>
```

```bash
# Generar hashes de contraseñas usando la herramienta digest.sh de Tomcat.
# Usar estos hashes para poblar la BD en lugar de contraseñas en texto plano.

# Generar hash SHA-512 con sal y 100.000 iteraciones
$CATALINA_HOME/bin/digest.sh \
  -a SHA-512 \
  -h org.apache.catalina.realm.MessageDigestCredentialHandler \
  -s 32 \            # saltLength
  -i 100000 \        # iterations
  miPasswordSeguro
# Salida: iterations$salt$hash — copiar este valor completo a la BD

# Generar hash PBKDF2 con HMAC-SHA512
$CATALINA_HOME/bin/digest.sh \
  -a PBKDF2WithHmacSHA512 \
  -h org.apache.catalina.realm.SecretKeyCredentialHandler \
  -s 32 \            # saltLength
  -i 600000 \        # iterations
  -k 256 \           # keyLength en bits
  miPasswordSeguro
```

---

## 6.7 Métodos de Autenticación en web.xml

Los métodos de autenticación definen *cómo* el cliente envía sus credenciales al servidor. Se configuran en el `<login-config>` del `web.xml` de la aplicación.

### 6.7.1 BASIC Authentication

HTTP Basic Auth es el método más simple: el navegador muestra un diálogo nativo de usuario/contraseña. Las credenciales se envían en la cabecera `Authorization` codificadas en Base64.

**Importante:** Base64 NO es cifrado, es solo codificación. Las credenciales son completamente visibles para cualquiera que intercepte el tráfico. Por eso Basic Auth **siempre debe usarse sobre HTTPS** (transport-guarantee CONFIDENTIAL). Sin TLS, es equivalente a enviar la contraseña en texto plano.

```xml
<!-- web.xml -->
<login-config>
  <auth-method>BASIC</auth-method>
  <realm-name>API Privada Mi Empresa</realm-name>
  <!--
    realm-name: Texto descriptivo que el navegador muestra en el diálogo
    de credenciales. No tiene impacto en la seguridad.
  -->
</login-config>

<security-constraint>
  <web-resource-collection>
    <web-resource-name>API</web-resource-name>
    <url-pattern>/api/*</url-pattern>
  </web-resource-collection>
  <auth-constraint>
    <role-name>api-user</role-name>
  </auth-constraint>
  <user-data-constraint>
    <!-- CONFIDENTIAL: Tomcat redirigirá automáticamente HTTP → HTTPS -->
    <transport-guarantee>CONFIDENTIAL</transport-guarantee>
  </user-data-constraint>
</security-constraint>
```

### 6.7.2 FORM Authentication

FORM Auth permite usar un formulario HTML personalizado en lugar del diálogo nativo del navegador. Es el método más flexible para aplicaciones con diseño propio.

El flujo es:
1. El usuario accede a un recurso protegido.
2. Tomcat redirige al formulario de login (`form-login-page`).
3. El usuario envía el formulario a la URL especial `j_security_check`.
4. Tomcat recibe las credenciales (campos `j_username` y `j_password`), las valida contra el Realm.
5. Si son correctas, redirige al recurso original. Si no, redirige a `form-error-page`.

```xml
<!-- web.xml -->
<login-config>
  <auth-method>FORM</auth-method>
  <realm-name>Portal Mi Empresa</realm-name>
  <form-login-config>
    <form-login-page>/login.html</form-login-page>
    <form-error-page>/login-error.html</form-error-page>
  </form-login-config>
</login-config>
```

```html
<!-- /login.html — Formulario de login -->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de Sesión</title>
</head>
<body>
    <!--
      RESTRICCIONES OBLIGATORIAS DE LA ESPECIFICACIÓN SERVLET:
      
      1. action DEBE ser exactamente "j_security_check"
         Este es el endpoint especial que Tomcat registra internamente
         para recibir las credenciales del formulario FORM Auth.
      
      2. Los campos DEBEN llamarse exactamente "j_username" y "j_password"
         La especificación Servlet define estos nombres. Si usas otros
         nombres, Tomcat no reconocerá las credenciales y el login fallará.
      
      3. method DEBE ser POST.
         GET enviaría la contraseña en la URL, visible en logs del servidor,
         historial del navegador y cabecera Referer. Nunca usar GET para login.
      
      Estos tres puntos son parte de la especificación Servlet y no son
      configurables. Son iguales en todos los servidores Java EE/Jakarta EE.
    -->
    <form method="POST" action="j_security_check" autocomplete="off">
        <div>
            <label for="username">Usuario:</label>
            <input type="text"
                   id="username"
                   name="j_username"
                   required
                   autocomplete="username"/>
        </div>
        <div>
            <label for="password">Contraseña:</label>
            <input type="password"
                   id="password"
                   name="j_password"
                   required
                   autocomplete="current-password"/>
        </div>
        <!--
          Token CSRF (Cross-Site Request Forgery):
          CSRF es un ataque donde un sitio malicioso hace que el navegador
          del usuario envíe peticiones autenticadas a tu aplicación sin
          que el usuario lo sepa (aprovechando que el navegador envía
          automáticamente las cookies de sesión).
          
          El token CSRF es un valor aleatorio único por sesión que se incluye
          en el formulario. El servidor verifica que el token enviado coincide
          con el de la sesión. Un atacante CSRF no conoce el token.
          
          Tomcat no gestiona CSRF automáticamente en FORM Auth;
          la aplicación debe implementarlo manualmente.
        -->
        <input type="hidden" name="_csrf" value="${csrfToken}"/>
        <button type="submit">Iniciar Sesión</button>
    </form>
</body>
</html>
```

### 6.7.3 CLIENT-CERT Authentication (mTLS)

Cuando se usa `CLIENT-CERT` como método de autenticación en `web.xml`, Tomcat usa el certificado del cliente (verificado a nivel TLS en el Conector, ver sección 6.4.2) para determinar la identidad del usuario.

El Realm busca al usuario basándose en el Subject DN del certificado del cliente. El "usuario" en el Realm debe coincidir con el CN del certificado.

```xml
<!-- web.xml -->
<login-config>
  <auth-method>CLIENT-CERT</auth-method>
  <realm-name>API M2M Segura</realm-name>
  <!--
    Con CLIENT-CERT, el Realm verifica si el DN del certificado del cliente
    corresponde a un usuario con los roles necesarios.
    El password no se usa (la autenticación la hace el certificado en TLS).
  -->
</login-config>

<security-constraint>
  <web-resource-collection>
    <web-resource-name>M2M API</web-resource-name>
    <url-pattern>/api/m2m/*</url-pattern>
  </web-resource-collection>
  <auth-constraint>
    <role-name>service-account</role-name>
  </auth-constraint>
  <user-data-constraint>
    <!-- CONFIDENTIAL es OBLIGATORIO con CLIENT-CERT -->
    <transport-guarantee>CONFIDENTIAL</transport-guarantee>
  </user-data-constraint>
</security-constraint>
```

### 6.7.4 DIGEST Authentication

HTTP Digest Auth es una mejora sobre Basic Auth: en lugar de enviar la contraseña (aunque sea codificada en Base64), envía un hash MD5 de la contraseña combinada con un *nonce* (número aleatorio generado por el servidor).

Sin embargo, MD5 está considerado criptográficamente roto, el protocolo tiene debilidades conocidas, y en la práctica siempre que se usa Digest se podría usar BASIC con TLS (más seguro y más simple). Está en desuso.

```xml
<!-- web.xml -->
<login-config>
  <auth-method>DIGEST</auth-method>
  <realm-name>API Digest</realm-name>
</login-config>
```

> ⚠️ **No usar en sistemas nuevos.** DIGEST es mejor que BASIC sin TLS, pero en cualquier sistema con TLS habilitado (que debe ser todos), BASIC sobre HTTPS es más seguro que DIGEST (ya que DIGEST con MD5 es vulnerable a ataques de colisión).

---

## 6.8 Single Sign-On (SSO) entre Aplicaciones

### ¿Qué es SSO?

**SSO** (*Single Sign-On*) es el mecanismo que permite al usuario autenticarse una vez y acceder a múltiples aplicaciones sin volver a introducir sus credenciales. Es la experiencia habitual en entornos corporativos: te identificas por la mañana y puedes usar el correo, el ERP, el CRM, etc. sin más logins.

En Tomcat, el `SingleSignOn Valve` implementa SSO para múltiples aplicaciones desplegadas en el **mismo Host** (nombre de servidor). Cuando el usuario se autentica en cualquiera de las aplicaciones, Tomcat crea una cookie SSO (`SSOID`) que las demás aplicaciones reconocen.

**Requisito fundamental:** Todas las aplicaciones que participan en el SSO deben usar el **mismo Realm**. Si una app usa `DataSourceRealm` y otra usa `JNDIRealm`, el SSO no funciona entre ellas.

```xml
<!--
  SingleSignOn Valve: se configura en el <Host> de server.xml,
  no en el web.xml de la aplicación. Aplica a TODAS las aplicaciones
  desplegadas bajo ese Host.
-->
<Host name="localhost" appBase="webapps">

  <Valve className="org.apache.catalina.authenticator.SingleSignOn"
         cookieDomain="miempresa.com"
         <!--
           Dominio de la cookie SSO. El navegador enviará la cookie a todas
           las URLs de este dominio y sus subdominios.
           app.miempresa.com, admin.miempresa.com y api.miempresa.com
           comparten la misma cookie si cookieDomain="miempresa.com".
         -->
         cookieName="SSOID"
         <!--
           Nombre de la cookie SSO. Cambiarlo desde el valor por defecto
           ("JSESSIONIDSSO") dificulta la identificación del servidor.
         -->
         cookiePath="/"
         cookieSecure="true"   <!-- Solo HTTPS, como cualquier cookie de sesión -->
         cookieHttpOnly="true" <!-- Inaccesible desde JavaScript -->
         requireReauthentication="false"
         <!--
           false: Una vez autenticado en cualquier app, las demás lo aceptan
                  directamente sin re-verificar credenciales.
           true: Cada aplicación vuelve a verificar las credenciales contra
                 el Realm al acceder por primera vez. Más seguro pero
                 requiere que las credenciales estén disponibles (no funciona
                 bien con FORM auth en sesiones existentes).
         -->
         sessionIdLength="32"/>
         <!-- Longitud del ID de sesión SSO en bytes. 32 bytes = 256 bits de entropía. -->

</Host>
```

---

## 6.9 Hardening de Seguridad del Servidor

**Hardening** es el proceso de reducir la *superficie de ataque* de un sistema: eliminar funcionalidades innecesarias, ocultar información útil para atacantes, y aplicar configuraciones más restrictivas que las que vienen por defecto.

Un servidor Tomcat recién instalado tiene configuraciones pensadas para facilidad de uso y diagnóstico, no para seguridad en producción. El hardening convierte esas configuraciones en unas apropiadas para exposición pública.

### 6.9.1 Checklist completo de hardening

```xml
<!-- server.xml — Configuración de hardening -->

<!--
  1. Deshabilitar el puerto de shutdown.
  
  Tomcat incluye un mecanismo para parar el servidor: escucha en un puerto
  TCP (por defecto 8005) esperando una cadena específica ("SHUTDOWN").
  Esto fue diseñado para ser usado desde localhost, pero es un riesgo de
  seguridad: si alguien puede conectar a ese puerto (por error de firewall
  o desde el propio servidor), puede parar Tomcat.
  
  port="-1" deshabilita completamente este mecanismo. Para parar Tomcat,
  se usa el script catalina.sh stop (que envía SIGTERM al proceso).
-->
<Server port="-1" shutdown="SHUTDOWN">

<!--
  2. Ocultar información del servidor en las cabeceras HTTP.
  
  Por defecto, Tomcat incluye en la cabecera "Server" su nombre y versión:
  "Server: Apache-Coyote/1.1" o "Server: Apache Tomcat/10.1.18"
  Esto le da al atacante información exacta sobre qué versión atacar.
  
  Con server="Apache" se devuelve un valor genérico que no revela versión.
  xpoweredBy="false" elimina la cabecera "X-Powered-By: Servlet/5.0
  JSP/3.0 (Apache Tomcat/10.1.18 Java/...)".
-->
<Connector ...
           server="Apache"
           xpoweredBy="false"/>

<!--
  3. Error pages sin información de versión.
  
  Por defecto, las páginas de error de Tomcat muestran la versión completa
  y a veces el stack trace de la excepción. Esto revela:
  - Versión exacta de Tomcat (para buscar CVEs)
  - Estructura interna de la aplicación (rutas de clases, nombres de paquetes)
  
  showReport="false": No incluir el stack trace de la excepción en la respuesta.
  showServerInfo="false": No incluir la versión de Tomcat en las páginas de error.
-->
<Valve className="org.apache.catalina.valves.ErrorReportValve"
       showReport="false"
       showServerInfo="false"/>

<!--
  4. Restringir métodos HTTP peligrosos.
  
  TRACE: El método HTTP TRACE devuelve la petición completa de vuelta al cliente.
    Puede usarse en ataques XST (Cross-Site Tracing) para robar cookies aunque
    estén marcadas como HttpOnly, si el atacante puede ejecutar un plugin Java.
    No debería tener ningún uso legítimo en producción.
  
  TRACK: Variante de TRACE usada por IIS de Microsoft. No tiene uso legítimo.
  
  OPTIONS: Revela qué métodos HTTP acepta el servidor para una URL. Útil para
    desarrollo y herramientas de testing, pero innecesario en producción y
    puede revelar información sobre la configuración del servidor.
  
  La auth-constraint vacía (<auth-constraint/>) deniega el acceso a todos
  los roles (incluido el acceso sin autenticar).
-->
<security-constraint>
  <web-resource-collection>
    <web-resource-name>Restricted Methods</web-resource-name>
    <url-pattern>/*</url-pattern>
    <http-method>TRACE</http-method>
    <http-method>TRACK</http-method>
    <http-method>OPTIONS</http-method>
  </web-resource-collection>
  <auth-constraint/>
</security-constraint>
```

```xml
<!-- conf/web.xml global de Tomcat — DefaultServlet hardening -->
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <!-- NUNCA habilitar listings en producción.
             Si está true y no hay index.html, el servidor muestra todos
             los archivos del directorio. Equivale a publicar el sistema de
             archivos de la aplicación en internet. -->
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- readonly=true: El DefaultServlet no acepta peticiones HTTP PUT o DELETE
             para modificar archivos en el servidor. Evitar que alguien pueda
             sobrescribir archivos de la aplicación via HTTP si hay un Filtro o
             configuración que inadvertidamente permita acceso de escritura. -->
        <param-name>readonly</param-name>
        <param-value>true</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

### 6.9.2 Configuración de SecurityManager (Java Security Policy)

El **SecurityManager** de Java es un mecanismo de seguridad que permite restringir qué operaciones puede realizar cada pieza de código (lectura/escritura de archivos, conexiones de red, lectura de propiedades del sistema, carga de clases, etc.).

En un servidor Tomcat sin SecurityManager, todas las aplicaciones desplegadas tienen los mismos permisos: si una aplicación (o una librería comprometida dentro de ella) quiere leer archivos del sistema operativo, crear conexiones de red arbitrarias o ejecutar comandos, puede hacerlo sin ninguna restricción Java.

Con SecurityManager activado, cada aplicación solo puede hacer lo que explícitamente le está permitido en la política de seguridad (`catalina.policy`).

**Trade-off:** El SecurityManager añade overhead de CPU en cada operación controlada y puede causar fallos en librerías que asumen tener permisos completos. En Java 17+, SecurityManager está deprecado y será eliminado en versiones futuras. Evaluar si el modelo de amenazas justifica su complejidad.

```bash
# Arrancar Tomcat con SecurityManager habilitado
# Esto activa el SecurityManager de la JVM y aplica la política de catalina.policy
$CATALINA_HOME/bin/catalina.sh start -security
```

```
# conf/catalina.policy — Política de seguridad personalizada
# Define qué puede hacer cada JAR/directorio de código

// Permisos completos para los componentes core de Tomcat
// (estos son necesarios para que Tomcat funcione)
grant codeBase "file:${catalina.home}/bin/bootstrap.jar" {
    permission java.security.AllPermission;
};

grant codeBase "file:${catalina.home}/bin/tomcat-juli.jar" {
    permission java.security.AllPermission;
};

grant codeBase "file:${catalina.home}/lib/-" {
    permission java.security.AllPermission;
};

// Permisos RESTRINGIDOS para la aplicación "myapp"
// El principio es el mínimo privilegio: solo lo que la app necesita funcionar.
grant codeBase "file:${catalina.base}/webapps/myapp/-" {
    
    // Red: solo puede conectar al servidor de BD en su puerto específico.
    // No puede hacer conexiones arbitrarias a internet.
    permission java.net.SocketPermission "db-host:5432", "connect,resolve";

    // Filesystem: solo puede LEER su directorio de configuración.
    // No puede leer /etc/passwd, /etc/shadow, ni otros archivos del sistema.
    permission java.io.FilePermission
        "/opt/config/myapp/-", "read";

    // Filesystem: puede leer, escribir y borrar en el directorio de uploads temporales.
    // El "-" al final significa "y todos sus subdirectorios".
    permission java.io.FilePermission
        "/tmp/uploads/-", "read,write,delete";

    // Propiedades del sistema que puede leer (user.timezone, file.encoding son
    // necesarias para el funcionamiento básico de Java).
    permission java.util.PropertyPermission "user.timezone", "read";
    permission java.util.PropertyPermission "file.encoding", "read";
    // Permite leer propiedades que empiecen por "app." (configuración propia)
    permission java.util.PropertyPermission "app.*", "read";

    // Necesario para que el framework de logging funcione correctamente.
    permission java.util.logging.LoggingPermission "control";
};
```

### 6.9.3 Filtro de cabeceras de seguridad HTTP con HttpHeaderSecurityFilter

En el Módulo 05 vimos cómo implementar un filtro personalizado de cabeceras de seguridad en Java. Tomcat incluye uno ya implementado y listo para usar: `HttpHeaderSecurityFilter`. Es más conveniente que mantener código propio.

```xml
<!-- web.xml de la aplicación -->
<filter>
    <filter-name>httpHeaderSecurity</filter-name>
    <filter-class>
        org.apache.catalina.filters.HttpHeaderSecurityFilter
    </filter-class>
    <init-param>
        <!-- HSTS: fuerza HTTPS durante maxAgeSeconds.
             Ver explicación en el Módulo 05, sección 5.4.3. -->
        <param-name>hstsEnabled</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- 1 año = 31536000 segundos -->
        <param-name>hstsMaxAgeSeconds</param-name>
        <param-value>31536000</param-value>
    </init-param>
    <init-param>
        <!-- Incluir subdominios en la política HSTS -->
        <param-name>hstsIncludeSubDomains</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Autorizar a incluir el dominio en la lista HSTS precargada
             de navegadores. Ver https://hstspreload.org -->
        <param-name>hstsPreload</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Añadir X-Frame-Options: previene clickjacking (ver Módulo 05) -->
        <param-name>antiClickJackingEnabled</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- SAMEORIGIN: permite iframes del mismo dominio, bloquea de otros -->
        <param-name>antiClickJackingOption</param-name>
        <param-value>SAMEORIGIN</param-value>
    </init-param>
    <init-param>
        <!-- Añadir X-Content-Type-Options: nosniff (previene MIME sniffing) -->
        <param-name>blockContentTypeSniffingEnabled</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Añadir X-XSS-Protection: 1; mode=block (filtro XSS legacy) -->
        <param-name>xssProtectionEnabled</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>httpHeaderSecurity</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
    <dispatcher>FORWARD</dispatcher>
</filter-mapping>
```

### 6.9.4 Filtro CORS incorporado de Tomcat

Tomcat también incluye su propia implementación del filtro CORS (`org.apache.catalina.filters.CorsFilter`), como alternativa a implementarlo desde cero en Java.

```xml
<!-- web.xml — CorsFilter de Tomcat -->
<filter>
    <filter-name>corsFilter</filter-name>
    <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>
    <init-param>
        <!-- Lista de orígenes permitidos para peticiones cross-origin.
             Solo estos dominios pueden hacer peticiones AJAX a tu API. -->
        <param-name>cors.allowed.origins</param-name>
        <param-value>
            https://app.miempresa.com,
            https://admin.miempresa.com
        </param-value>
    </init-param>
    <init-param>
        <!-- Métodos HTTP que se permiten en peticiones cross-origin -->
        <param-name>cors.allowed.methods</param-name>
        <param-value>GET,POST,PUT,DELETE,OPTIONS,PATCH,HEAD</param-value>
    </init-param>
    <init-param>
        <!-- Cabeceras HTTP que el cliente puede enviar en peticiones cross-origin -->
        <param-name>cors.allowed.headers</param-name>
        <param-value>
            Authorization,Content-Type,Accept,
            X-Requested-With,Origin,X-Request-ID
        </param-value>
    </init-param>
    <init-param>
        <!-- Cabeceras de la respuesta que el código JavaScript del cliente puede leer.
             Por seguridad, el navegador oculta la mayoría de cabeceras de respuesta
             a menos que el servidor las liste explícitamente aquí. -->
        <param-name>cors.exposed.headers</param-name>
        <param-value>X-Request-ID,X-Total-Count</param-value>
    </init-param>
    <init-param>
        <!-- Permite enviar cookies en peticiones cross-origin.
             Requiere que el cliente use credentials: 'include' en fetch().
             Solo funciona con orígenes específicos (no con "*"). -->
        <param-name>cors.support.credentials</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Tiempo en segundos que el navegador puede cachear la respuesta
             a la petición OPTIONS preflight. 3600 = 1 hora. -->
        <param-name>cors.preflight.maxage</param-name>
        <param-value>3600</param-value>
    </init-param>
    <init-param>
        <!-- cors.request.decorate=true: Añade atributos a la petición
             con información CORS (origen, tipo de petición, etc.).
             Útil para la lógica de la aplicación que necesita saber
             si la petición es cross-origin. -->
        <param-name>cors.request.decorate</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>corsFilter</filter-name>
    <!-- Solo aplicar a la API, no a los recursos estáticos -->
    <url-pattern>/api/*</url-pattern>
</filter-mapping>
```

---

## 6.10 Auditoría de Seguridad: Valve de Acceso Avanzado

Un **Valve** en Tomcat es similar a un Filtro (intercepta peticiones), pero opera a un nivel más bajo del pipeline de Tomcat, antes incluso de que la petición llegue a los Filtros de la aplicación. Se configuran en `server.xml`.

`AccessLogValve` registra todas las peticiones HTTP en un archivo de log. Para auditoría de seguridad, el patrón de log debe incluir suficiente información para:
- Detectar patrones de ataque (muchas peticiones 401/403 desde la misma IP).
- Investigar incidentes (¿qué peticiones hizo este usuario comprometido?).
- Cumplimiento regulatorio (GDPR, PCI-DSS exigen registros de acceso).

```xml
<!--
  AccessLogValve configurado para auditoría de seguridad.
  El "pattern" define el formato de cada línea de log.
  
  Los campos del patrón (documentados en la Tomcat docs):
  %t: Timestamp de la petición
  %h: Dirección IP del cliente (host remoto)
  %{X-Forwarded-For}i: IP original si hay proxy/balanceador delante
      (la %h en ese caso sería la IP del proxy, no del cliente real)
  %l: Identidad lógica del usuario (siempre "-" en la práctica; no usar en HTTP)
  %u: Usuario autenticado (el nombre de usuario si el recurso requería auth)
  %r: Primera línea de la petición HTTP (método, URL, versión HTTP)
  %s: Código de estado HTTP de la respuesta
  %b: Bytes enviados en la respuesta (sin cabeceras)
  %D: Tiempo total de procesamiento de la petición en milisegundos
  %{Referer}i: Cabecera Referer de la petición
  %{User-Agent}i: Cabecera User-Agent
  %{X-Request-ID}i: ID de correlación personalizado
  %{javax.servlet.request.ssl_cipher_suite}r: Cipher suite TLS usado
  %{javax.servlet.request.key_size}r: Longitud de clave TLS
-->
<Valve className="org.apache.catalina.valves.AccessLogValve"
       directory="${catalina.base}/logs"
       prefix="security-audit"
       suffix=".log"
       rotatable="true"
       fileDateFormat="yyyy-MM-dd"   <!-- Rotar el log cada día (nuevo archivo con la fecha) -->
       buffered="false"
       <!--
         buffered="false": Escribe cada línea inmediatamente a disco sin buffering.
         Más costoso en I/O pero garantiza que en caso de crash no se pierden
         los últimos logs (importantes en investigación de incidentes).
         En entornos de muy alto tráfico, puede habilitarse buffering para
         rendimiento a costa de perder potencialmente los últimos logs.
       -->
       pattern="%{yyyy-MM-dd'T'HH:mm:ss.SSSZ}t
                %h
                %{X-Forwarded-For}i
                %l
                %u
                &quot;%r&quot;
                %s
                %b
                %D
                %{Referer}i
                %{User-Agent}i
                %{X-Request-ID}i
                %{javax.servlet.request.ssl_cipher_suite}r
                %{javax.servlet.request.key_size}r"
       resolveHosts="false"
       <!--
         resolveHosts="false": No hacer resolución DNS inversa de las IPs de los clientes.
         La resolución DNS añade latencia a cada petición (puede ser decenas de ms)
         y en entornos de alto tráfico degrada significativamente el rendimiento.
         Registrar las IPs y hacer la resolución offline si es necesario.
       -->
       requestAttributesEnabled="true"
       ipv6Canonical="false"/>
```

---

## 6.11 Script de Auditoría de Seguridad de Tomcat

Este script verifica automáticamente los puntos de hardening más críticos de una instalación de Tomcat. Debe ejecutarse después de cada instalación y antes de poner un servidor en producción.

```bash
#!/bin/bash
# tomcat-security-audit.sh
# Auditoría automatizada de configuración de seguridad

# set -euo pipefail: Hace el script robusto ante errores.
# -e: El script termina inmediatamente si cualquier comando falla.
# -u: Error si se referencia una variable no definida.
# -o pipefail: Un pipeline falla si cualquier comando dentro de él falla.
set -euo pipefail

CATALINA_HOME="${CATALINA_HOME:-/opt/tomcat}"
CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
SERVER_XML="$CATALINA_BASE/conf/server.xml"
TOMCAT_USERS="$CATALINA_BASE/conf/tomcat-users.xml"

# Contadores para el resumen final
PASS=0
FAIL=0
WARN=0

# Funciones helper para formatear la salida
check_pass() { echo "  ✅ PASS: $1"; PASS=$((PASS+1)); }
check_fail() { echo "  ❌ FAIL: $1"; FAIL=$((FAIL+1)); }
check_warn() { echo "  ⚠️  WARN: $1"; WARN=$((WARN+1)); }

echo "==================================================="
echo " Auditoría de Seguridad Apache Tomcat"
echo " CATALINA_HOME: $CATALINA_HOME"
echo " Fecha: $(date)"
echo "==================================================="
echo ""

# ----------------------------------------
# CHECK 1: Puerto de shutdown
# ----------------------------------------
# Un puerto de shutdown habilitado permite que cualquier proceso local
# (o remoto si el firewall no lo bloquea) pare Tomcat enviando la cadena
# de shutdown al puerto. port="-1" deshabilita esta funcionalidad.
echo "[1] Puerto de Shutdown"
if grep -q 'port="-1"' "$SERVER_XML"; then
    check_pass "Puerto de shutdown deshabilitado (port=-1)"
else
    check_fail "Puerto de shutdown HABILITADO. Cambiar a port=-1 en server.xml"
fi

# ----------------------------------------
# CHECK 2: Cabecera Server
# ----------------------------------------
# La cabecera "Server" de la respuesta HTTP revela qué servidor se usa
# y su versión. Los atacantes usan esto para buscar CVEs específicos.
echo ""
echo "[2] Cabecera Server"
if grep -qE 'server="[^"]*Apache[^"0-9]*"' "$SERVER_XML"; then
    check_pass "Cabecera Server configurada para ocultar versión"
elif grep -q 'server=' "$SERVER_XML"; then
    check_warn "Cabecera Server configurada pero verificar que no expone versión"
else
    check_fail "Cabecera Server no configurada → expone versión exacta de Tomcat"
fi

# ----------------------------------------
# CHECK 3: ErrorReportValve
# ----------------------------------------
# Las páginas de error por defecto de Tomcat incluyen la versión del servidor
# y el stack trace de la excepción. showServerInfo y showReport deben ser false.
echo ""
echo "[3] ErrorReportValve"
if grep -q 'showServerInfo="false"' "$SERVER_XML"; then
    check_pass "showServerInfo=false configurado"
else
    check_fail "showServerInfo no está en false → versión expuesta en páginas de error"
fi

if grep -q 'showReport="false"' "$SERVER_XML"; then
    check_pass "showReport=false configurado"
else
    check_fail "showReport no está en false → stack traces expuestos en errores"
fi

# ----------------------------------------
# CHECK 4: Conector AJP
# ----------------------------------------
# AJP (Apache JServ Protocol) es el protocolo usado cuando Apache httpd actúa
# como proxy delante de Tomcat. Si no se usa Apache httpd, AJP debe deshabilitarse.
# La vulnerabilidad "Ghostcat" (CVE-2020-1938) afectó a AJP sin secret.
# Tras el parche, secretRequired="true" es el valor por defecto en versiones
# parcheadas de Tomcat 8.5.51+, 9.0.31+, 10.0.x.
echo ""
echo "[4] Conector AJP"
if grep -q 'AJP\|ajp' "$SERVER_XML"; then
    if grep -q 'secretRequired="true"' "$SERVER_XML"; then
        check_pass "AJP con secretRequired=true (protegido contra Ghostcat)"
    else
        check_fail "AJP habilitado SIN secretRequired=true → VULNERABLE a CVE-2020-1938 (Ghostcat)"
    fi
    if grep -q 'address="127.0.0.1"' "$SERVER_XML"; then
        check_pass "AJP escucha solo en loopback (127.0.0.1)"
    else
        check_warn "AJP puede estar escuchando en todas las interfaces → verificar firewall"
    fi
else
    check_pass "Conector AJP no configurado (correcto si no usas Apache httpd como proxy)"
fi

# ----------------------------------------
# CHECK 5: Aplicaciones de ejemplo y documentación
# ----------------------------------------
# Tomcat incluye aplicaciones de ejemplo (examples) y documentación (docs)
# que son innecesarias en producción y pueden contener vulnerabilidades.
# "examples" en particular tiene XSS conocidos y muestra información de sesiones.
echo ""
echo "[5] Aplicaciones por defecto"
for app in examples docs; do
    if [ -d "$CATALINA_BASE/webapps/$app" ]; then
        check_fail "Aplicación '$app' presente en webapps/ → eliminar en producción"
    else
        check_pass "Aplicación '$app' no presente (correcto)"
    fi
done

# ----------------------------------------
# CHECK 6: Autenticación del Manager
# ----------------------------------------
# La aplicación "manager" permite gestionar despliegues remotamente.
# Si tiene usuarios con contraseñas débiles o en texto plano, es una
# puerta de entrada directa al servidor.
echo ""
echo "[6] Manager Application"
if [ -f "$TOMCAT_USERS" ]; then
    if grep -qE 'roles="[^"]*manager' "$TOMCAT_USERS"; then
        # Verificar que las contraseñas están hasheadas (SHA-256 = 64 chars hex)
        if grep -qE 'password="[a-f0-9]{64}"' "$TOMCAT_USERS"; then
            check_pass "Manager configurado con password hasheado (SHA-256)"
        else
            check_warn "Manager configurado: verificar que los passwords estén hasheados (no texto plano)"
        fi
    else
        check_pass "No hay usuarios con rol manager en tomcat-users.xml"
    fi
fi

# ----------------------------------------
# CHECK 7: Configuración TLS
# ----------------------------------------
# Verificar que TLS está habilitado y que no se usan versiones inseguras.
echo ""
echo "[7] Configuración TLS"
if grep -q 'SSLEnabled="true"' "$SERVER_XML"; then
    if grep -q 'TLSv1.2\|TLSv1.3' "$SERVER_XML"; then
        check_pass "TLS 1.2/1.3 configurado"
    else
        check_warn "TLS habilitado pero verificar que solo TLSv1.2 y TLSv1.3 están activos"
    fi
    # Buscar protocolos inseguros explícitamente habilitados
    if grep -q 'TLSv1\.0\|TLSv1\.1\|SSLv3' "$SERVER_XML"; then
        check_fail "Protocolos inseguros (SSLv3, TLSv1.0, TLSv1.1) detectados en la configuración"
    else
        check_pass "No se detectan protocolos TLS inseguros en la configuración"
    fi
else
    check_warn "TLS no está habilitado. ¿Se gestiona en un proxy/balanceador delante?"
fi

# ----------------------------------------
# CHECK 8: Permisos de archivos de configuración
# ----------------------------------------
# Los archivos de configuración de Tomcat pueden contener contraseñas
# y rutas internas. Deben ser legibles solo por el usuario de Tomcat.
# Permisos 640: propietario puede leer/escribir, grupo puede leer, otros nada.
echo ""
echo "[8] Permisos de archivos"
for file in "$CATALINA_BASE/conf/server.xml" \
            "$CATALINA_BASE/conf/tomcat-users.xml" \
            "$CATALINA_BASE/conf/context.xml"; do
    if [ -f "$file" ]; then
        perms=$(stat -c "%a" "$file")
        if [ "$perms" -le "640" ]; then
            check_pass "Permisos correctos ($perms) en $(basename $file)"
        else
            check_fail "Permisos inseguros ($perms) en $(basename $file) → usar 640 o menos"
        fi
    fi
done

# ----------------------------------------
# CHECK 9: Usuario del proceso
# ----------------------------------------
# Tomcat nunca debe ejecutarse como root. Si una vulnerabilidad en Tomcat
# o en una aplicación permite ejecutar código arbitrario, ese código se
# ejecutaría con los privilegios de root, comprometiendo el sistema completo.
# Usar siempre un usuario dedicado sin privilegios (p.ej. "tomcat").
echo ""
echo "[9] Usuario del proceso Tomcat"
TOMCAT_USER=$(ps aux | grep -v grep | grep catalina | awk '{print $1}' | head -1)
if [ -z "$TOMCAT_USER" ]; then
    check_warn "No se puede determinar el usuario (¿Tomcat está corriendo?)"
elif [ "$TOMCAT_USER" = "root" ]; then
    check_fail "Tomcat está corriendo como ROOT → usar usuario dedicado sin privilegios"
else
    check_pass "Tomcat corre como usuario no-root: $TOMCAT_USER"
fi

# ----------------------------------------
# Resumen final
# ----------------------------------------
echo ""
echo "==================================================="
echo " Resumen de la Auditoría"
echo "==================================================="
echo "  ✅ PASS: $PASS"
echo "  ❌ FAIL: $FAIL"
echo "  ⚠️  WARN: $WARN"
echo ""

if [ $FAIL -gt 0 ]; then
    echo "  Estado: INSEGURO — $FAIL controles críticos fallidos"
    exit 1   # Exit code 1: útil para integrar en pipelines CI/CD (falla el pipeline)
elif [ $WARN -gt 0 ]; then
    echo "  Estado: REVISAR — $WARN advertencias pendientes de verificación"
    exit 0
else
    echo "  Estado: SEGURO — Todos los controles superados"
    exit 0
fi
```

---

## 6.12 Diferencias de Seguridad entre Versiones

Esta tabla resume las características de seguridad disponibles en cada versión de Tomcat, útil para decisiones de actualización:

| Característica                          | 8.0   | 8.5   | 9.0   | 10.x  | 11.0  |
|-----------------------------------------|-------|-------|-------|-------|-------|
| TLS 1.3 nativo                          | ❌    | ❌    | ✅*   | ✅    | ✅    |
| OCSP Stapling                           | ❌    | ✅    | ✅    | ✅    | ✅    |
| SSLHostConfig / SNI                     | ❌    | ✅    | ✅    | ✅    | ✅    |
| SecretKeyCredentialHandler (PBKDF2)     | ❌    | ✅    | ✅    | ✅    | ✅    |
| AJP secretRequired por defecto          | ❌    | ✅**  | ✅**  | ✅    | ✅    |
| SameSite cookies                        | ❌    | ✅    | ✅    | ✅    | ✅    |
| HttpHeaderSecurityFilter integrado      | ❌    | ✅    | ✅    | ✅    | ✅    |
| Rfc6265CookieProcessor por defecto      | ❌    | ✅    | ✅    | ✅    | ✅    |
| doTrace() deshabilitado por defecto     | ❌    | ❌    | ❌    | ❌    | ✅    |
| OpenSSL via FFM API                     | ❌    | ❌    | ❌    | ❌    | ✅    |

*Requiere JDK 11+  
**A partir de versiones de parche post-Ghostcat (8.5.51+, 9.0.31+)

**Notas sobre características clave:**

**OCSP Stapling:** Mecanismo para verificar en tiempo real si un certificado TLS ha sido revocado. El servidor consulta periódicamente al servidor OCSP de la CA y "adjunta" (staples) la respuesta firmada en el handshake TLS. Esto evita que el cliente tenga que consultar al servidor OCSP directamente (más rápido y más privado). Disponible desde Tomcat 8.5.

**SSLHostConfig / SNI:** La estructura moderna de configuración TLS que permite múltiples certificados por IP (un certificado por nombre de dominio, seleccionado automáticamente según el SNI del cliente). Fundamental para albergar múltiples dominios HTTPS en el mismo servidor. Disponible desde Tomcat 8.5.

**SameSite cookies:** Atributo de cookie que controla si el navegador la envía en peticiones cross-site. `Strict` (solo same-site), `Lax` (same-site + navegaciones desde otros sitios), `None` (siempre, requiere Secure). Protege contra ataques CSRF. Configurable en `<cookie-config>` desde Tomcat 8.5.

**Rfc6265CookieProcessor:** Procesador de cookies que sigue estrictamente el RFC 6265 (especificación moderna de cookies HTTP). El procesador legacy aceptaba caracteres inválidos en cookies que podían causar problemas de seguridad. Habilitado por defecto desde Tomcat 8.5.

**AJP secretRequired:** La vulnerabilidad Ghostcat (CVE-2020-1938) permitía a un atacante con acceso al puerto AJP leer archivos arbitrarios del servidor o ejecutar código si podía hacer que Tomcat procesara un archivo malicioso. El parche añadió `secretRequired` que exige un secreto compartido entre Apache httpd y Tomcat para usar AJP.

---

## Puntos Clave

- La seguridad en Tomcat se articula en **cuatro capas independientes**: transporte (TLS), autenticación (Realms), autorización (Security Constraints) e infraestructura (hardening). Nunca depender de una sola capa.

- Usar siempre **PKCS12** sobre JKS para los KeyStores. PKCS12 es el formato estándar e interoperable recomendado desde Java 9. JKS es un formato propietario de Java en desuso.

- **TLS 1.0 y 1.1 deben deshabilitarse explícitamente** en Tomcat 8.x y 9.x (en 10.x y 11.0 ya están deshabilitados por defecto). Usar `protocols="TLSv1.2+TLSv1.3"` en `SSLHostConfig`.

- El **LockOutRealm debe envolver siempre al Realm real** en producción para proteger contra ataques de fuerza bruta. Sin él, un atacante puede probar contraseñas indefinidamente.

- El **DataSourceRealm** es preferido sobre JDBCRealm en producción porque reutiliza el pool de conexiones JNDI en lugar de gestionar sus propias conexiones, lo que evita conexiones huérfanas si la BD se reinicia.

- Usar **SecretKeyCredentialHandler con PBKDF2WithHmacSHA512** para el hashing de contraseñas. Nunca almacenar contraseñas en texto plano, con MD5 o SHA-1. SHA-256/512 sin iteraciones también es débil ante ataques modernos con GPUs.

- El conector **AJP requiere `secretRequired="true"`** tras la vulnerabilidad Ghostcat (CVE-2020-1938). Si no se usa AJP (cuando no hay Apache httpd delante), eliminarlo completamente del `server.xml`.

- En **mTLS**, el certificado del cliente se obtiene en el Servlet vía el atributo `jakarta.servlet.request.X509Certificate` (Tomcat 10+) o `javax.servlet.request.X509Certificate` (Tomcat 9-). Solo funciona si `certificateVerification="required"` o `"optional"` en el `SSLHostConfig`.

- El **SecurityManager** de Java proporciona aislamiento de permisos entre aplicaciones pero está deprecado en Java 17+ y tiene impacto en rendimiento. En Java 21+, valorar alternativas como contenedores (Docker/Kubernetes) para el aislamiento.

- El script de **auditoría de seguridad** debe ejecutarse tras cada instalación, cada actualización de Tomcat y antes de cada release a producción. Integrarlo en el pipeline CI/CD para que falle automáticamente si detecta configuraciones inseguras.

- Los certificados Let's Encrypt expiran cada **90 días**. Automatizar la renovación con cron + certbot + script de conversión a PKCS12 + recarga en caliente via Manager API para evitar interrupciones de servicio.