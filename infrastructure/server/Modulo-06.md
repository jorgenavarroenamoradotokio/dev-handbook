## Módulo 06: Seguridad — TLS/SSL, Realms y Autenticación

## 6.1 Arquitectura de Seguridad en Tomcat

La seguridad en Tomcat se articula en cuatro capas independientes y complementarias:

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

---

## 6.2 TLS/SSL: Conceptos Fundamentales

### 6.2.1 Tipos de implementación TLS en Tomcat

| Implementación | Librería         | Rendimiento | Configuración | Disponibilidad |
|----------------|------------------|-------------|---------------|----------------|
| JSSE           | Java SE (JDK)    | Media       | Simple        | Siempre        |
| OpenSSL (APR)  | libtcnative + OpenSSL | Alta  | Compleja      | Requiere APR   |
| OpenSSL (FFM)  | OpenSSL via FFM API | Alta    | Media         | Tomcat 11+     |

### 6.2.2 Versiones de TLS soportadas por Tomcat

| Protocolo | Tomcat 8.0 | Tomcat 8.5 | Tomcat 9.0 | Tomcat 10.x | Tomcat 11.0 |
|-----------|------------|------------|------------|-------------|-------------|
| SSLv3     | ❌ Disabled| ❌ Disabled| ❌ Disabled| ❌ Disabled | ❌ Disabled |
| TLSv1.0   | ✅          | ✅          | ⚠️ Dep.   | ❌ Disabled | ❌ Disabled |
| TLSv1.1   | ✅          | ✅          | ⚠️ Dep.   | ❌ Disabled | ❌ Disabled |
| TLSv1.2   | ✅          | ✅          | ✅          | ✅           | ✅           |
| TLSv1.3   | ❌          | ❌          | ✅ (JDK11+)| ✅           | ✅           |

---

## 6.3 Gestión de Certificados

### 6.3.1 Generación de KeyStore JKS con keytool

```bash
# ======================================================
# 1. Generar KeyStore con par de claves RSA-2048
# ======================================================
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
keytool -certreq \
  -alias tomcat \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file app.miempresa.com.csr \
  -ext SAN=dns:app.miempresa.com,dns:www.app.miempresa.com

# ======================================================
# 3. Importar certificado firmado por CA
# ======================================================
# 3a. Importar certificado raíz de la CA
keytool -importcert \
  -alias root-ca \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file root-ca.crt \
  -trustcacerts \
  -noprompt

# 3b. Importar certificado intermedio de la CA
keytool -importcert \
  -alias intermediate-ca \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file intermediate-ca.crt \
  -noprompt

# 3c. Importar certificado del servidor firmado
keytool -importcert \
  -alias tomcat \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit \
  -file app.miempresa.com.crt \
  -noprompt

# ======================================================
# 4. Verificar el KeyStore
# ======================================================
keytool -list -v \
  -keystore $CATALINA_BASE/conf/ssl/keystore.jks \
  -storepass changeit

# ======================================================
# 5. Generar KeyStore PKCS12 (recomendado sobre JKS desde Java 9+)
# ======================================================
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
openssl pkcs12 -export \
  -in fullchain.pem \
  -inkey privkey.pem \
  -out keystore.p12 \
  -name tomcat \
  -CAfile chain.pem \
  -caname root \
  -passout pass:changeit

# Convertir PKCS12 a JKS si es necesario
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

```bash
# Obtener certificado Let's Encrypt (modo standalone)
sudo certbot certonly \
  --standalone \
  --preferred-challenges http \
  --http-01-port 80 \
  -d app.miempresa.com \
  -d www.app.miempresa.com \
  --email admin@miempresa.com \
  --agree-tos \
  --non-interactive

# Los certificados quedan en:
# /etc/letsencrypt/live/app.miempresa.com/fullchain.pem
# /etc/letsencrypt/live/app.miempresa.com/privkey.pem

# Convertir a PKCS12 para Tomcat
sudo openssl pkcs12 -export \
  -in /etc/letsencrypt/live/app.miempresa.com/fullchain.pem \
  -inkey /etc/letsencrypt/live/app.miempresa.com/privkey.pem \
  -out $CATALINA_BASE/conf/ssl/keystore.p12 \
  -name tomcat \
  -passout pass:${KEYSTORE_PASSWORD}

sudo chown tomcat:tomcat $CATALINA_BASE/conf/ssl/keystore.p12
sudo chmod 640 $CATALINA_BASE/conf/ssl/keystore.p12

# ======================================================
# Script de renovación automática
# /etc/cron.d/certbot-tomcat-renew
# ======================================================
cat > /etc/cron.d/certbot-tomcat-renew << 'EOF'
# Renovar certificado a las 3:00 AM el día 1 y 15 de cada mes
0 3 1,15 * * root certbot renew --quiet --post-hook "/opt/scripts/convert-cert-tomcat.sh"
EOF

# Script post-renovación
cat > /opt/scripts/convert-cert-tomcat.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail

DOMAIN="app.miempresa.com"
KEYSTORE_PASS="${KEYSTORE_PASSWORD}"
KEYSTORE_PATH="/opt/tomcat/conf/ssl/keystore.p12"

# Convertir nuevo certificado
openssl pkcs12 -export \
  -in /etc/letsencrypt/live/$DOMAIN/fullchain.pem \
  -inkey /etc/letsencrypt/live/$DOMAIN/privkey.pem \
  -out $KEYSTORE_PATH \
  -name tomcat \
  -passout pass:$KEYSTORE_PASS

chown tomcat:tomcat $KEYSTORE_PATH
chmod 640 $KEYSTORE_PATH

# Recargar el contexto SSL sin reiniciar Tomcat
# via JMX o Manager API
curl -s -u deployer:password \
  "http://localhost:8080/manager/text/sslConnectorCerts"

echo "Certificado renovado y recargado: $(date)"
SCRIPT

chmod +x /opt/scripts/convert-cert-tomcat.sh
```

---

## 6.4 Configuración TLS Completa en server.xml

### 6.4.1 HTTPS con PKCS12 — Tomcat 8.5+ (Configuración recomendada)

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
    SSLHostConfig principal — dominio por defecto
    Se aplica cuando el SNI del cliente no coincide con
    ningún otro SSLHostConfig definido.
  -->
  <SSLHostConfig
    hostName="_default_"

    <!-- Protocolos TLS permitidos -->
    protocols="TLSv1.2+TLSv1.3"

    <!--
      Cipher suites TLS 1.2 (TLS 1.3 usa sus propios cipher suites)
      Orden: ECDHE primero (Perfect Forward Secrecy), sin RC4, sin 3DES
    -->
    ciphers="TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:
             TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:
             ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:
             ECDHE-ECDSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:
             DHE-RSA-AES128-GCM-SHA256"

    <!-- No preferir el orden del servidor sobre el del cliente -->
    honorCipherOrder="false"

    <!-- Session tickets TLS -->
    disableSessionTickets="false"
    sessionCacheSize="0"
    sessionTimeout="86400"

    <!-- Verificación de certificado de cliente -->
    certificateVerification="none"

    <!-- OCSP Stapling — Tomcat 8.5+ -->
    certificateRevocationListFile=""
    revocationEnabled="false">

    <!-- Certificado RSA -->
    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.p12"
      certificateKeystorePassword="${ssl.keystore.password}"
      certificateKeystoreType="PKCS12"
      certificateKeyAlias="tomcat"/>

    <!-- Certificado ECDSA (dual-cert para clientes modernos) -->
    <Certificate
      type="EC"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore-ec.p12"
      certificateKeystorePassword="${ssl.keystore.ec.password}"
      certificateKeystoreType="PKCS12"
      certificateKeyAlias="tomcat-ec"/>

  </SSLHostConfig>

  <!--
    SSLHostConfig adicional para dominio específico via SNI
    El cliente envía el hostname en el TLS ClientHello
    y Tomcat selecciona el SSLHostConfig correspondiente.
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

```xml
<!--
  mTLS (mutual TLS): el servidor también verifica el certificado del cliente.
  Usado en:
    - Comunicación machine-to-machine (M2M)
    - APIs internas de alta seguridad
    - Zero Trust Architecture
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

    <!--
      certificateVerification:
        none     — No verificar cliente (TLS estándar)
        optional — Verificar si el cliente presenta certificado
        required — EXIGIR certificado de cliente (mTLS)
        optionalNoCA — Aceptar cualquier certificado del cliente
    -->
    certificateVerification="required"

    <!-- TrustStore con los certificados CA de clientes autorizados -->
    truststoreFile="${catalina.base}/conf/ssl/client-truststore.jks"
    truststorePassword="${ssl.truststore.password}"
    truststoreType="JKS"

    <!-- Profundidad máxima de la cadena de certificación del cliente -->
    certificateVerificationDepth="5">

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

        // Obtener el certificado del cliente
        X509Certificate[] certs = (X509Certificate[])
            request.getAttribute("jakarta.servlet.request.X509Certificate");

        if (certs == null || certs.length == 0) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED,
                "Certificado de cliente requerido");
            return;
        }

        X509Certificate clientCert = certs[0];

        String subjectDN  = clientCert.getSubjectX500Principal().getName();
        String issuerDN   = clientCert.getIssuerX500Principal().getName();
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

```bash
# Recargar certificados SSL en caliente via Manager API
# Sin necesidad de reiniciar Tomcat
curl -u admin:password \
  "http://localhost:8080/manager/text/sslConnectorCerts"

# Ver estado actual de los conectores SSL
curl -u admin:password \
  "http://localhost:8080/manager/text/sslConnectorCiphers"

# Recargar un conector SSL específico
curl -u admin:password \
  "http://localhost:8080/manager/text/sslReload?tlsHostName=app.miempresa.com"
```

---

## 6.5 Realms: Sistema de Autenticación de Tomcat

### 6.5.1 MemoryRealm — Solo desarrollo

```xml
<!-- server.xml o context.xml -->
<Realm className="org.apache.catalina.realm.MemoryRealm"
       pathname="conf/tomcat-users.xml"
       digest="SHA-256"/>
```

```xml
<!-- conf/tomcat-users.xml con passwords hasheados -->
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users>

  <role rolename="admin"/>
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-status"/>

  <!--
    Password hasheado con SHA-256.
    Generación: bin/digest.sh -a SHA-256
                -h org.apache.catalina.realm.MessageDigestCredentialHandler
                mipassword
  -->
  <user username="admin"
        password="8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
        roles="admin,manager-gui,manager-script,manager-status"/>

</tomcat-users>
```

### 6.5.2 JDBCRealm — Usuarios en base de datos (JDBC directo)

```xml
<Realm className="org.apache.catalina.realm.JDBCRealm"
       driverName="org.postgresql.Driver"
       connectionURL="jdbc:postgresql://db-host:5432/security_db"
       connectionName="tomcat_user"
       connectionPassword="${db.password}"

       userTable="app_users"
       userNameCol="username"
       userCredCol="password_hash"

       userRoleTable="app_user_roles"
       roleNameCol="role_name"

       digest="SHA-256"
       digestEncoding="UTF-8"

       userClassNames=""
       roleClassNames=""/>
```

```sql
-- Esquema de tablas para JDBCRealm
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
);

CREATE INDEX idx_users_username ON app_users(username);
CREATE INDEX idx_roles_username ON app_user_roles(username);

-- Insertar usuario con password SHA-256
-- Hash de "admin123": 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a
INSERT INTO app_users (username, password_hash)
VALUES ('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a');

INSERT INTO app_user_roles (username, role_name)
VALUES ('admin', 'admin'), ('admin', 'manager');
```

### 6.5.3 DataSourceRealm — Usuarios en BD via pool JNDI (recomendado)

```xml
<!--
  DataSourceRealm: versión mejorada de JDBCRealm.
  Usa el pool de conexiones JNDI en lugar de gestionar su propia conexión.
  RECOMENDADO sobre JDBCRealm para producción.
-->
<Realm className="org.apache.catalina.realm.DataSourceRealm"
       dataSourceName="jdbc/SecurityDB"
       localDataSource="false"

       userTable="app_users"
       userNameCol="username"
       userCredCol="password_hash"

       userRoleTable="app_user_roles"
       roleNameCol="role_name"

       digest="SHA-256"
       digestEncoding="UTF-8"

       userClassNames=""
       allRolesMode="authOnly"/>
```

### 6.5.4 JNDIRealm — Autenticación contra LDAP / Active Directory

```xml
<!--
  JNDIRealm: autenticación contra LDAP o Active Directory.
  Configuración para Active Directory corporativo.
-->
<Realm className="org.apache.catalina.realm.JNDIRealm"

       <!-- Servidor LDAP -->
       connectionURL="ldap://dc01.miempresa.com:389"
       alternateURL="ldap://dc02.miempresa.com:389"
       connectionTimeout="5000"
       readTimeout="10000"

       <!-- Cuenta de servicio para bind inicial -->
       connectionName="cn=tomcat-service,ou=service-accounts,dc=miempresa,dc=com"
       connectionPassword="${ldap.service.password}"

       <!-- Búsqueda de usuarios -->
       userBase="ou=users,dc=miempresa,dc=com"
       userSearch="(sAMAccountName={0})"
       userSubtree="true"
       userPattern=""

       <!-- Atributo de contraseña (para comparación directa) -->
       userPassword=""

       <!-- Búsqueda de roles -->
       roleBase="ou=groups,dc=miempresa,dc=com"
       roleName="cn"
       roleSearch="(member={0})"
       roleSubtree="true"

       <!-- Seguir referencias LDAP -->
       referrals="follow"

       <!-- Caché de roles -->
       commonRole=""

       <!-- AD específico: usar userPrincipalName para bind -->
       adCompat="true"

       <!-- Protocolo de digest (vacío = comparación directa LDAP) -->
       digest=""

       <!-- Pool de conexiones LDAP -->
       connectionPoolSize="10"
       connectionPoolMaxSize="20"
       connectionPoolTimeout="300000"
       connectionPoolMinSize="5"/>
```

```xml
<!--
  JNDIRealm con LDAPS (LDAP sobre TLS) — Producción
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
    Configurar TrustStore para el certificado LDAPS del AD
    Se pasa como propiedad del sistema en setenv.sh:
    -Djavax.net.ssl.trustStore=/opt/tomcat/conf/ssl/ad-truststore.jks
    -Djavax.net.ssl.trustStorePassword=trustpass
  -->

</Realm>
```

### 6.5.5 LockOutRealm — Protección contra fuerza bruta

```xml
<!--
  LockOutRealm: wrapper que añade bloqueo de cuenta
  por intentos fallidos de autenticación.
  Debe SIEMPRE envolver el Realm real en producción.
-->
<Realm className="org.apache.catalina.realm.LockOutRealm"

       <!-- Intentos fallidos antes de bloquear -->
       failureCount="5"

       <!-- Segundos de bloqueo tras alcanzar failureCount -->
       lockOutTime="600"

       <!-- Tamaño del caché de intentos fallidos -->
       cacheSize="1000"

       <!-- Tiempo antes de avisar de eliminaciones del caché (segundos) -->
       cacheRemovalWarningTime="3600">

  <!-- Realm interno: puede ser cualquier tipo -->
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

```xml
<!--
  CombinedRealm: intenta autenticar con cada Realm en orden.
  El primero que tenga éxito gana. Si ninguno autentifica, falla.
  Útil para migrar gradualmente de un sistema de autenticación a otro.
-->
<Realm className="org.apache.catalina.realm.LockOutRealm"
       failureCount="5"
       lockOutTime="300">

  <Realm className="org.apache.catalina.realm.CombinedRealm">

    <!-- Prioridad 1: LDAP corporativo -->
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

    <!-- Prioridad 2: BD local (cuentas de servicio / fallback) -->
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

```xml
<Realm className="org.apache.catalina.realm.JAASRealm"
       appName="TomcatLogin"
       userClassNames="com.miempresa.security.jaas.UserPrincipal"
       roleClassNames="com.miempresa.security.jaas.RolePrincipal"
       useContextClassLoader="true"
       configFile="${catalina.base}/conf/jaas.config"/>
```

```
# conf/jaas.config
TomcatLogin {
    com.miempresa.security.jaas.DatabaseLoginModule required
        dataSource="jdbc/SecurityDB"
        userTable="app_users"
        passwordColumn="password_hash"
        roleTable="app_user_roles"
        debug="false";
};
```

---

## 6.6 CredentialHandler — Hashing de Contraseñas

Tomcat 8.5+ introduce los `CredentialHandler` para gestionar el hashing de contraseñas de forma segura y configurable.

```xml
<!-- MessageDigestCredentialHandler — SHA-256, SHA-512 -->
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
    encoding="hex"
    saltLength="32"
    iterations="100000"/>

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
    keyLength="256"
    saltLength="32"
    iterations="600000"/>

</Realm>
```

```bash
# Generar hash de contraseña con digest.sh
# SHA-512
$CATALINA_HOME/bin/digest.sh \
  -a SHA-512 \
  -h org.apache.catalina.realm.MessageDigestCredentialHandler \
  -s 32 \
  -i 100000 \
  miPasswordSeguro

# PBKDF2
$CATALINA_HOME/bin/digest.sh \
  -a PBKDF2WithHmacSHA512 \
  -h org.apache.catalina.realm.SecretKeyCredentialHandler \
  -s 32 \
  -i 600000 \
  -k 256 \
  miPasswordSeguro
```

---

## 6.7 Métodos de Autenticación en web.xml

### 6.7.1 BASIC Authentication

```xml
<!-- web.xml -->
<login-config>
  <auth-method>BASIC</auth-method>
  <realm-name>API Privada Mi Empresa</realm-name>
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
    <transport-guarantee>CONFIDENTIAL</transport-guarantee>
  </user-data-constraint>
</security-constraint>
```

### 6.7.2 FORM Authentication

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
<!-- /login.html — Formulario de login requerido por la especificación -->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de Sesión</title>
</head>
<body>
    <!--
      IMPORTANTE: El action DEBE ser j_security_check.
      Los campos DEBEN llamarse j_username y j_password.
      Estos nombres son parte de la especificación Servlet.
      El method DEBE ser POST.
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
          CSRF protection: incluir token CSRF en formularios de login.
          En Tomcat con FORM auth, el contenedor gestiona el estado,
          pero la aplicación debe implementar CSRF manualmente.
        -->
        <input type="hidden" name="_csrf" value="${csrfToken}"/>
        <button type="submit">Iniciar Sesión</button>
    </form>
</body>
</html>
```

### 6.7.3 CLIENT-CERT Authentication (mTLS)

```xml
<!-- web.xml -->
<login-config>
  <auth-method>CLIENT-CERT</auth-method>
  <realm-name>API M2M Segura</realm-name>
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
    <transport-guarantee>CONFIDENTIAL</transport-guarantee>
  </user-data-constraint>
</security-constraint>
```

### 6.7.4 DIGEST Authentication

```xml
<!-- web.xml -->
<login-config>
  <auth-method>DIGEST</auth-method>
  <realm-name>API Digest</realm-name>
</login-config>
```

---

## 6.8 Single Sign-On (SSO) entre Aplicaciones

```xml
<!--
  SingleSignOn Valve: permite que múltiples aplicaciones
  bajo el mismo Host compartan la sesión de autenticación.
  El usuario se autentica una vez y accede a todas las apps.
  
  REQUISITO: Todas las apps deben usar el MISMO Realm.
  Se configura a nivel de Host en server.xml.
-->
<Host name="localhost" appBase="webapps">

  <Valve className="org.apache.catalina.authenticator.SingleSignOn"
         cookieDomain="miempresa.com"
         cookieName="SSOID"
         cookiePath="/"
         cookieSecure="true"
         cookieHttpOnly="true"
         requireReauthentication="false"
         sessionIdLength="32"/>

</Host>
```

---

## 6.9 Hardening de Seguridad del Servidor

### 6.9.1 Checklist completo de hardening

```xml
<!-- server.xml — Configuración de hardening -->

<!-- 1. Deshabilitar puerto de shutdown -->
<Server port="-1" shutdown="SHUTDOWN">

<!-- 2. Ocultar información del servidor -->
<Connector ...
           server="Apache"
           xpoweredBy="false"/>

<!-- 3. Error pages sin información de versión -->
<Valve className="org.apache.catalina.valves.ErrorReportValve"
       showReport="false"
       showServerInfo="false"/>

<!-- 4. Restringir métodos HTTP peligrosos -->
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

<!-- 5. Deshabilitar TRACE en web.xml global -->
```

```xml
<!-- conf/web.xml global de Tomcat — DefaultServlet hardening -->
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <!-- NUNCA listar directorios en producción -->
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Deshabilitar lectura directa de archivos fuera del docBase -->
        <param-name>readonly</param-name>
        <param-value>true</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

### 6.9.2 Configuración de SecurityManager (Java Security Policy)

```bash
# Arrancar Tomcat con SecurityManager habilitado
$CATALINA_HOME/bin/catalina.sh start -security
```

```
# conf/catalina.policy — Política de seguridad personalizada

// Permisos para el propio Tomcat
grant codeBase "file:${catalina.home}/bin/bootstrap.jar" {
    permission java.security.AllPermission;
};

grant codeBase "file:${catalina.home}/bin/tomcat-juli.jar" {
    permission java.security.AllPermission;
};

grant codeBase "file:${catalina.home}/lib/-" {
    permission java.security.AllPermission;
};

// Permisos para la aplicación myapp
grant codeBase "file:${catalina.base}/webapps/myapp/-" {
    // Acceso a red solo al servidor de BD
    permission java.net.SocketPermission "db-host:5432", "connect,resolve";

    // Acceso de lectura a su directorio de configuración
    permission java.io.FilePermission
        "/opt/config/myapp/-", "read";

    // Acceso de lectura/escritura al directorio de uploads
    permission java.io.FilePermission
        "/tmp/uploads/-", "read,write,delete";

    // Propiedades del sistema que puede leer
    permission java.util.PropertyPermission "user.timezone", "read";
    permission java.util.PropertyPermission "file.encoding", "read";
    permission java.util.PropertyPermission "app.*", "read";

    // Logging
    permission java.util.logging.LoggingPermission "control";
};
```

### 6.9.3 Filtro de cabeceras de seguridad HTTP con HttpHeaderSecurityFilter

Tomcat incluye un filtro incorporado para cabeceras de seguridad:

```xml
<!-- web.xml de la aplicación -->
<filter>
    <filter-name>httpHeaderSecurity</filter-name>
    <filter-class>
        org.apache.catalina.filters.HttpHeaderSecurityFilter
    </filter-class>
    <init-param>
        <!-- HSTS -->
        <param-name>hstsEnabled</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <param-name>hstsMaxAgeSeconds</param-name>
        <param-value>31536000</param-value>
    </init-param>
    <init-param>
        <param-name>hstsIncludeSubDomains</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <param-name>hstsPreload</param-name>
        <param-value>true</param-value>
    </init-param>
    <!-- Anti-clickjacking -->
    <init-param>
        <param-name>antiClickJackingEnabled</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <param-name>antiClickJackingOption</param-name>
        <param-value>SAMEORIGIN</param-value>
    </init-param>
    <!-- X-Content-Type-Options -->
    <init-param>
        <param-name>blockContentTypeSniffingEnabled</param-name>
        <param-value>true</param-value>
    </init-param>
    <!-- X-XSS-Protection -->
    <init-param>
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

```xml
<!-- web.xml — CorsFilter de Tomcat -->
<filter>
    <filter-name>corsFilter</filter-name>
    <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>
    <init-param>
        <param-name>cors.allowed.origins</param-name>
        <param-value>
            https://app.miempresa.com,
            https://admin.miempresa.com
        </param-value>
    </init-param>
    <init-param>
        <param-name>cors.allowed.methods</param-name>
        <param-value>GET,POST,PUT,DELETE,OPTIONS,PATCH,HEAD</param-value>
    </init-param>
    <init-param>
        <param-name>cors.allowed.headers</param-name>
        <param-value>
            Authorization,Content-Type,Accept,
            X-Requested-With,Origin,X-Request-ID
        </param-value>
    </init-param>
    <init-param>
        <param-name>cors.exposed.headers</param-name>
        <param-value>X-Request-ID,X-Total-Count</param-value>
    </init-param>
    <init-param>
        <param-name>cors.support.credentials</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <param-name>cors.preflight.maxage</param-name>
        <param-value>3600</param-value>
    </init-param>
    <init-param>
        <!-- Rechazar peticiones sin Origin header (protección CSRF) -->
        <param-name>cors.request.decorate</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>corsFilter</filter-name>
    <url-pattern>/api/*</url-pattern>
</filter-mapping>
```

---

## 6.10 Auditoría de Seguridad: Valve de Acceso Avanzado

```xml
<!--
  AccessLogValve configurado para auditoría de seguridad.
  Registra información suficiente para detectar ataques
  e investigar incidentes de seguridad.
-->
<Valve className="org.apache.catalina.valves.AccessLogValve"
       directory="${catalina.base}/logs"
       prefix="security-audit"
       suffix=".log"
       rotatable="true"
       fileDateFormat="yyyy-MM-dd"
       buffered="false"
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
       requestAttributesEnabled="true"
       ipv6Canonical="false"/>
```

---

## 6.11 Script de Auditoría de Seguridad de Tomcat

```bash
#!/bin/bash
# tomcat-security-audit.sh
# Auditoría automatizada de configuración de seguridad

set -euo pipefail

CATALINA_HOME="${CATALINA_HOME:-/opt/tomcat}"
CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
SERVER_XML="$CATALINA_BASE/conf/server.xml"
TOMCAT_USERS="$CATALINA_BASE/conf/tomcat-users.xml"

PASS=0
FAIL=0
WARN=0

check_pass() { echo "  ✅ PASS: $1"; PASS=$((PASS+1)); }
check_fail() { echo "  ❌ FAIL: $1"; FAIL=$((FAIL+1)); }
check_warn() { echo "  ⚠️  WARN: $1"; WARN=$((WARN+1)); }

echo "==================================================="
echo " Auditoría de Seguridad Apache Tomcat"
echo " CATALINA_HOME: $CATALINA_HOME"
echo " Fecha: $(date)"
echo "==================================================="
echo ""

# 1. Puerto de shutdown
echo "[1] Puerto de Shutdown"
if grep -q 'port="-1"' "$SERVER_XML"; then
    check_pass "Puerto de shutdown deshabilitado (port=-1)"
else
    check_fail "Puerto de shutdown HABILITADO. Cambiar a port=-1"
fi

# 2. Versión del servidor
echo ""
echo "[2] Cabecera Server"
if grep -qE 'server="[^A-Za-z]*Apache[^0-9]*"' "$SERVER_XML"; then
    check_pass "Cabecera Server configurada para ocultar versión"
elif grep -q 'server=' "$SERVER_XML"; then
    check_warn "Cabecera Server configurada pero verificar valor"
else
    check_fail "Cabecera Server no configurada, expone versión de Tomcat"
fi

# 3. ErrorReportValve
echo ""
echo "[3] ErrorReportValve"
if grep -q 'showServerInfo="false"' "$SERVER_XML"; then
    check_pass "showServerInfo=false configurado"
else
    check_fail "showServerInfo no está en false, expone versión en páginas de error"
fi

if grep -q 'showReport="false"' "$SERVER_XML"; then
    check_pass "showReport=false configurado"
else
    check_fail "showReport no está en false, expone stack traces"
fi

# 4. Conector AJP
echo ""
echo "[4] Conector AJP"
if grep -q 'AJP' "$SERVER_XML" || grep -q 'ajp' "$SERVER_XML"; then
    if grep -q 'secretRequired="true"' "$SERVER_XML"; then
        check_pass "AJP con secretRequired=true"
    else
        check_fail "AJP habilitado SIN secretRequired=true (vulnerable a Ghostcat)"
    fi
    if grep -q 'address="127.0.0.1"' "$SERVER_XML"; then
        check_pass "AJP escucha solo en loopback (127.0.0.1)"
    else
        check_warn "AJP puede estar escuchando en todas las interfaces"
    fi
else
    check_pass "Conector AJP no está configurado/habilitado"
fi

# 5. Apps por defecto
echo ""
echo "[5] Aplicaciones por defecto"
for app in examples docs; do
    if [ -d "$CATALINA_BASE/webapps/$app" ]; then
        check_fail "Aplicación '$app' existe. Eliminar en producción"
    else
        check_pass "Aplicación '$app' no presente"
    fi
done

# 6. Autenticación del Manager
echo ""
echo "[6] Manager Application"
if [ -f "$TOMCAT_USERS" ]; then
    if grep -qE 'roles="[^"]*manager' "$TOMCAT_USERS"; then
        # Verificar que usa hash y no password en claro
        if grep -qE 'password="[a-f0-9]{64}"' "$TOMCAT_USERS"; then
            check_pass "Manager configurado con password hasheado (SHA-256)"
        else
            check_warn "Manager configurado: verificar que los passwords estén hasheados"
        fi
    else
        check_pass "No hay usuarios con rol manager en tomcat-users.xml"
    fi
fi

# 7. TLS
echo ""
echo "[7] Configuración TLS"
if grep -q 'SSLEnabled="true"' "$SERVER_XML"; then
    if grep -q 'TLSv1.2' "$SERVER_XML" || grep -q 'TLSv1.3' "$SERVER_XML"; then
        check_pass "TLS 1.2/1.3 configurado"
    else
        check_warn "Verificar que TLS 1.0/1.1 esté deshabilitado"
    fi
    if grep -q 'TLSv1.0\|TLSv1.1\|SSLv3' "$SERVER_XML"; then
        check_fail "Protocolos inseguros (SSLv3, TLSv1.0, TLSv1.1) detectados"
    else
        check_pass "No se detectan protocolos TLS inseguros"
    fi
fi

# 8. Permisos de archivos de configuración
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
            check_fail "Permisos inseguros ($perms) en $(basename $file). Usar 640 o menos"
        fi
    fi
done

# 9. Usuario del proceso
echo ""
echo "[9] Usuario del proceso Tomcat"
TOMCAT_USER=$(ps aux | grep -v grep | grep catalina | awk '{print $1}' | head -1)
if [ -z "$TOMCAT_USER" ]; then
    check_warn "No se puede determinar el usuario (¿Tomcat está corriendo?)"
elif [ "$TOMCAT_USER" = "root" ]; then
    check_fail "Tomcat está corriendo como ROOT. Usar usuario dedicado sin privilegios"
else
    check_pass "Tomcat corre como usuario: $TOMCAT_USER"
fi

# Resumen
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
    exit 1
elif [ $WARN -gt 0 ]; then
    echo "  Estado: REVISAR — $WARN advertencias pendientes"
    exit 0
else
    echo "  Estado: SEGURO — Todos los controles superados"
    exit 0
fi
```

---

## 6.12 Diferencias de Seguridad entre Versiones

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

---

## Puntos Clave del Módulo 06

- La seguridad en Tomcat se articula en **cuatro capas**: transporte (TLS), autenticación (Realms), autorización (Security Constraints) e infraestructura (hardening).
- Usar siempre **PKCS12** sobre JKS para los KeyStores. PKCS12 es el formato estándar recomendado desde Java 9.
- El **LockOutRealm** debe envolver siempre al Realm real en producción para proteger contra ataques de fuerza bruta.
- El **DataSourceRealm** es preferido sobre JDBCRealm en producción porque reutiliza el pool de conexiones JNDI en lugar de gestionar sus propias conexiones.
- Usar **SecretKeyCredentialHandler con PBKDF2WithHmacSHA512** para el hashing de contraseñas. Nunca almacenar contraseñas en texto plano o con MD5/SHA-1.
- El conector **AJP requiere `secretRequired="true"`** tras Ghostcat. Si no se usa AJP, eliminarlo completamente del `server.xml`.
- En **mTLS** el certificado del cliente se obtiene en el Servlet via el atributo `jakarta.servlet.request.X509Certificate` (o `javax.servlet.request.X509Certificate` en Tomcat 9-).
- El **SecurityManager** de Java proporciona aislamiento de permisos entre aplicaciones pero tiene un impacto en rendimiento. Evaluar su uso según el modelo de amenazas.
- El script de **auditoría de seguridad** debe ejecutarse tras cada instalación y antes de cada release en producción.
- **TLS 1.0 y 1.1 deben deshabilitarse explícitamente** en Tomcat 8.x y 9.x. En Tomcat 10.x están deshabilitados por defecto.