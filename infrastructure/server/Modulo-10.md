## Módulo 10: Migración entre Versiones (8.0 → 8.5 → 9 → 10 → 11)

## 10.1 Visión General del Mapa de Migración

La migración entre versiones de Tomcat puede ser incremental (versión a versión) o directa (saltar varias versiones). La elección depende del riesgo asumible y el esfuerzo disponible. El cambio más crítico es el salto de Tomcat 9 a Tomcat 10 por el cambio de namespace de APIs.

```
┌──────────────────────────────────────────────────────────────────────┐
│                   Mapa de Migración Tomcat                           │
│                                                                      │
│  Tomcat 8.0 ──────► Tomcat 8.5                                       │
│     │                   │                                            │
│     │   Java 7+         │   Java 7+                                  │
│     │   javax.*         │   javax.*                                  │
│     │   Servlet 3.1     │   Servlet 3.1                              │
│     │   BIO disponible  │   BIO deprecado                            │
│     │                   │   HTTP/2 disponible                        │
│     │                   │                                            │
│     └───────────────────┴──────► Tomcat 9.0                          │
│                                      │                               │
│                                      │   Java 8+                     │
│                                      │   javax.*                     │
│                                      │   Servlet 4.0                 │
│                                      │   BIO ELIMINADO               │
│                                      │   HTTP/2 completo             │
│                                      │                               │
│                          ╔═══════════▼═══════════╗                   │
│                          ║  BARRERA NAMESPACE     ║                   │
│                          ║  javax.* → jakarta.*  ║                   │
│                          ╚═══════════╤═══════════╝                   │
│                                      │                               │
│                                      ▼                               │
│                                  Tomcat 10.0                         │
│                                      │   Java 8+                     │
│                                      │   jakarta.*                   │
│                                      │   Servlet 5.0                 │
│                                      │                               │
│                                      ▼                               │
│                                  Tomcat 10.1                         │
│                                      │   Java 11+                    │
│                                      │   jakarta.*                   │
│                                      │   Servlet 6.0                 │
│                                      │                               │
│                                      ▼                               │
│                                  Tomcat 11.0                         │
│                                      │   Java 17+                    │
│                                      │   jakarta.*                   │
│                                      │   Servlet 6.1                 │
│                                      │   Virtual Threads             │
└──────────────────────────────────────────────────────────────────────┘
```

### Tabla de compatibilidad completa

| Desde → Hasta     | Cambio Namespace | Cambio JDK | Complejidad | Riesgo  |
|-------------------|-----------------|------------|-------------|---------|
| 8.0 → 8.5         | ❌ No            | ❌ No      | Baja        | Bajo    |
| 8.5 → 9.0         | ❌ No            | ⚠️ Min 8  | Media       | Medio   |
| 9.0 → 10.0        | ✅ Crítico       | ❌ No      | Alta        | Alto    |
| 10.0 → 10.1       | ❌ No            | ⚠️ Min 11 | Baja        | Bajo    |
| 10.1 → 11.0       | ❌ No            | ⚠️ Min 17 | Media       | Medio   |
| 8.x → 10.x        | ✅ Crítico       | ⚠️ Min 11 | Muy Alta    | Alto    |
| 8.x → 11.0        | ✅ Crítico       | ⚠️ Min 17 | Muy Alta    | Muy Alto|

---

## 10.2 Migración de Tomcat 8.0 a Tomcat 8.5

### 10.2.1 Cambios principales

| Área                    | Tomcat 8.0                     | Tomcat 8.5                          |
|-------------------------|--------------------------------|-------------------------------------|
| Protocolo BIO           | Disponible                     | Deprecado (pero funciona)           |
| HTTP/2                  | No disponible                  | Disponible via UpgradeProtocol      |
| SSL/TLS                 | Configuración antigua          | SSLHostConfig + Certificate         |
| APR lifecycle listener  | Disponible                     | Mejorado                            |
| JSSE SSL                | Atributos en Connector         | SSLHostConfig obligatorio en 8.5+   |
| CredentialHandler       | No disponible                  | Disponible (PBKDF2, SHA-256)        |
| Access Log              | Sin AsyncFileHandler           | AsyncFileHandler disponible         |
| Cookie handling         | LegacyCookieProcessor          | Rfc6265CookieProcessor default      |

### 10.2.2 Checklist de migración 8.0 → 8.5

```bash
#!/bin/bash
# migrate-80-to-85.sh
# Pre-migración: verificar compatibilidad

echo "=== Verificación pre-migración Tomcat 8.0 → 8.5 ==="
echo ""

CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
SERVER_XML="$CATALINA_BASE/conf/server.xml"

# 1. Verificar uso de protocolo BIO
echo "[1] Verificando protocolo BIO..."
if grep -q "Http11BioProtocol\|BIO" "$SERVER_XML" 2>/dev/null; then
    echo "  ⚠️  ACCIÓN REQUERIDA: Protocolo BIO detectado"
    echo "  Cambiar Http11BioProtocol → Http11NioProtocol"
    echo "  El BIO está deprecado en 8.5 y eliminado en 9.0"
else
    echo "  ✅ Sin uso de BIO"
fi

# 2. Verificar configuración SSL antigua
echo ""
echo "[2] Verificando configuración SSL..."
if grep -q 'SSLEnabled="true"' "$SERVER_XML" 2>/dev/null; then
    if ! grep -q "SSLHostConfig" "$SERVER_XML" 2>/dev/null; then
        echo "  ⚠️  ACCIÓN REQUERIDA: SSL configurado con atributos directos"
        echo "  Migrar a SSLHostConfig + Certificate (formato nuevo)"
        echo "  La configuración antigua funciona en 8.5 pero está deprecada"
    else
        echo "  ✅ SSL con SSLHostConfig (formato correcto)"
    fi
fi

# 3. Verificar CookieProcessor
echo ""
echo "[3] Verificando CookieProcessor..."
if grep -q "LegacyCookieProcessor" "$CATALINA_BASE/conf/context.xml" 2>/dev/null; then
    echo "  ⚠️  INFO: LegacyCookieProcessor configurado explícitamente"
    echo "  En 8.5 el default cambió a Rfc6265CookieProcessor"
    echo "  Verificar que las cookies de la aplicación son compatibles"
else
    echo "  ✅ Usando CookieProcessor por defecto"
fi

echo ""
echo "=== Verificación completada ==="
```

### 10.2.3 Cambios en server.xml para 8.5

```xml
<!-- ============================================================ -->
<!-- ANTES (Tomcat 8.0): SSL configurado con atributos directos  -->
<!-- ============================================================ -->
<Connector port="8443"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           maxThreads="150"
           scheme="https"
           secure="true"
           clientAuth="false"
           sslProtocol="TLS"
           keystoreFile="conf/ssl/keystore.jks"
           keystorePass="changeit"
           keyAlias="tomcat"
           truststoreFile="conf/ssl/truststore.jks"
           truststorePass="changeit"
           sslEnabledProtocols="TLSv1.2"
           ciphers="TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"/>

<!-- ============================================================ -->
<!-- DESPUÉS (Tomcat 8.5+): SSLHostConfig + Certificate          -->
<!-- ============================================================ -->
<Connector port="8443"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           maxThreads="150"
           scheme="https"
           secure="true">

  <SSLHostConfig
    hostName="_default_"
    protocols="TLSv1.2+TLSv1.3"
    ciphers="TLS_AES_256_GCM_SHA384:ECDHE-RSA-AES256-GCM-SHA384"
    certificateVerification="none">

    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
      certificateKeystorePassword="changeit"
      certificateKeyAlias="tomcat"
      certificateKeystoreType="JKS"/>

  </SSLHostConfig>
</Connector>

<!-- ============================================================ -->
<!-- ANTES (Tomcat 8.0): Protocolo BIO                           -->
<!-- ============================================================ -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11BioProtocol"
           .../>

<!-- DESPUÉS (Tomcat 8.5): Protocolo NIO                         -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           .../>
```

---

## 10.3 Migración de Tomcat 8.5 a Tomcat 9.0

### 10.3.1 Cambios principales

| Área                       | Tomcat 8.5                   | Tomcat 9.0                         |
|----------------------------|------------------------------|------------------------------------|
| Servlet Spec               | 3.1                          | 4.0                                |
| JSP Spec                   | 2.3                          | 2.3                                |
| Java mínimo                | Java 7                       | Java 8 (obligatorio)               |
| Protocolo BIO              | Deprecado                    | ELIMINADO                          |
| HTTP/2 PushBuilder         | No disponible                | Disponible (Servlet 4.0)           |
| TLS 1.3                    | No disponible                | Disponible (con JDK 11+)           |
| AJP secretRequired         | Opcional                     | Requerido post-Ghostcat            |
| `javax.*` namespace        | ✅ Sí                        | ✅ Sí (sin cambios)                |

### 10.3.2 Checklist de migración 8.5 → 9.0

```bash
#!/bin/bash
# migrate-85-to-90.sh

echo "=== Verificación pre-migración Tomcat 8.5 → 9.0 ==="
echo ""

CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
SERVER_XML="$CATALINA_BASE/conf/server.xml"

# 1. Verificar JDK
echo "[1] Verificando versión de JDK..."
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' \
    | cut -d'.' -f1)

if [ "$JAVA_VER" -lt 8 ] 2>/dev/null; then
    echo "  ❌ BLOQUEANTE: JDK $JAVA_VER detectado. Tomcat 9 requiere JDK 8+"
    echo "  Actualizar JDK antes de continuar"
else
    echo "  ✅ JDK $JAVA_VER compatible"
fi

# 2. Verificar BIO (eliminado en 9.0)
echo ""
echo "[2] Verificando protocolo BIO (eliminado en 9.0)..."
if grep -qE "Http11BioProtocol|AjpBioProtocol" "$SERVER_XML" 2>/dev/null; then
    echo "  ❌ BLOQUEANTE: Protocolo BIO detectado — ELIMINADO en Tomcat 9"
    echo "  Cambiar a NIO o NIO2 inmediatamente"
    grep -n "BioProtocol" "$SERVER_XML" 2>/dev/null \
        | awk '{print "    Línea: " $0}'
else
    echo "  ✅ Sin uso de BIO"
fi

# 3. Verificar AJP
echo ""
echo "[3] Verificando conector AJP (Ghostcat CVE-2020-1938)..."
if grep -q "AJP\|ajp" "$SERVER_XML" 2>/dev/null; then
    if ! grep -q 'secretRequired="true"' "$SERVER_XML" 2>/dev/null; then
        echo "  ❌ SEGURIDAD: AJP sin secretRequired=true"
        echo "  Añadir: secretRequired=\"true\" requiredSecret=\"<secret>\""
    else
        echo "  ✅ AJP con secretRequired configurado"
    fi
fi

# 4. Verificar web.xml version
echo ""
echo "[4] Verificando versión de web.xml en aplicaciones..."
find "$CATALINA_BASE/webapps" -name "web.xml" 2>/dev/null | while read f; do
    VERSION=$(grep -o 'version="[^"]*"' "$f" 2>/dev/null | head -1)
    APP=$(echo "$f" | sed "s|$CATALINA_BASE/webapps/||" | cut -d'/' -f1)
    echo "  App: $APP → web.xml $VERSION"
    echo "  ✅ Compatible (servlet 3.1 apps funcionan en Tomcat 9)"
done

echo ""
echo "=== Verificación completada ==="
```

### 10.3.3 Cambios en configuración para Tomcat 9.0

```xml
<!-- server.xml actualizado para Tomcat 9.0 -->

<!-- 1. Eliminar BIO — ya eliminado si se siguió la guía 8.5 -->
<!-- 2. AJP con secret obligatorio -->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           port="8009"
           redirectPort="8443"
           secretRequired="true"
           requiredSecret="${ajp.secret}"
           tomcatAuthentication="false"/>

<!-- 3. HTTP/2 disponible en Tomcat 9 -->
<Connector port="8443"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           scheme="https"
           secure="true">

  <!-- HTTP/2 — nuevo en Tomcat 9 (disponible desde 8.5) -->
  <UpgradeProtocol
    className="org.apache.coyote.http2.Http2Protocol"
    maxConcurrentStreams="200"/>

  <SSLHostConfig protocols="TLSv1.2+TLSv1.3">
    <Certificate type="RSA"
                 certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.p12"
                 certificateKeystorePassword="${ssl.keystore.password}"
                 certificateKeystoreType="PKCS12"/>
  </SSLHostConfig>

</Connector>
```

---

## 10.4 Migración de Tomcat 9 a Tomcat 10 — El Cambio Crítico

Esta es la migración más compleja. El cambio de namespace `javax.*` → `jakarta.*` afecta a **todas** las clases de la aplicación que implementan o usan APIs Servlet, JSP, EL, WebSocket y JASPIC.

### 10.4.1 Alcance completo del cambio de namespace

```
APIs que cambian de javax.* → jakarta.*:
───────────────────────────────────────────────────────────────
  javax.servlet.*           → jakarta.servlet.*
  javax.servlet.http.*      → jakarta.servlet.http.*
  javax.servlet.annotation.*→ jakarta.servlet.annotation.*
  javax.servlet.jsp.*       → jakarta.servlet.jsp.*
  javax.el.*                → jakarta.el.*
  javax.websocket.*         → jakarta.websocket.*
  javax.security.auth.message.* → jakarta.security.auth.message.*

APIs que NO cambian (siguen siendo javax.*):
───────────────────────────────────────────────────────────────
  javax.sql.*              (Java SE — DataSource, Connection...)
  javax.naming.*           (Java SE — JNDI)
  javax.annotation.*       (Java SE desde Java 11)
  javax.xml.*              (Java SE — XML APIs)
  javax.crypto.*           (Java SE — Criptografía)
  javax.net.ssl.*          (Java SE — SSL/TLS)
```

### 10.4.2 Impacto en el código de la aplicación

```java
// ================================================================
// ANTES (Tomcat 9 / javax.*):
// ================================================================

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        ServletContext ctx = filterConfig.getServletContext();
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession         sess = req.getSession(false);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}

// ================================================================
// DESPUÉS (Tomcat 10+ / jakarta.*):
// Solo cambian los imports — el código lógico es idéntico
// ================================================================

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// El resto del código es idéntico
@WebFilter("/*")
public class AuthFilter implements Filter {
    // ... código sin cambios ...
}
```

### 10.4.3 Migración automática con la Jakarta EE Migration Tool

```bash
# ============================================================
# OPCIÓN A: Migración del WAR completo (binario)
# Convierte los imports en el bytecode sin recompilar
# ============================================================

# Descargar la herramienta oficial de Apache
wget https://github.com/apache/tomcat-jakartaee-migration/releases/download/1.0.6/jakartaee-migration-1.0.6-shaded.jar

# Migrar WAR completo
java -jar jakartaee-migration-1.0.6-shaded.jar \
    myapp-javax.war \
    myapp-jakarta.war

# Verificar el resultado
unzip -p myapp-jakarta.war \
    WEB-INF/classes/com/miempresa/filter/AuthFilter.class \
    | strings | grep -E "javax|jakarta"

# ============================================================
# OPCIÓN B: Migración del código fuente (recomendada para prod)
# Permite recompilar con las nuevas dependencias
# ============================================================

# Migrar código fuente Java
find src/main/java -name "*.java" -exec \
    sed -i 's/import javax\.servlet\./import jakarta.servlet./g' {} \;

find src/main/java -name "*.java" -exec \
    sed -i 's/import javax\.websocket\./import jakarta.websocket./g' {} \;

find src/main/java -name "*.java" -exec \
    sed -i 's/import javax\.el\./import jakarta.el./g' {} \;

# Migrar web.xml (namespace del descriptor)
find src/main/webapp -name "web.xml" -exec \
    sed -i \
    's|http://xmlns.jcp.org/xml/ns/javaee|https://jakarta.ee/xml/ns/jakartaee|g' \
    {} \;

find src/main/webapp -name "web.xml" -exec \
    sed -i \
    's|http://java.sun.com/xml/ns/javaee|https://jakarta.ee/xml/ns/jakartaee|g' \
    {} \;

# ============================================================
# OPCIÓN C: Plugin Maven (integración en el build pipeline)
# ============================================================
```

```xml
<!-- pom.xml — Migración automática en el build Maven -->
<project>
  <dependencies>
    <!-- ANTES: javax.servlet (Tomcat 9) -->
    <!--
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.1</version>
      <scope>provided</scope>
    </dependency>
    -->

    <!-- DESPUÉS: jakarta.servlet (Tomcat 10+) -->
    <dependency>
      <groupId>jakarta.servlet</groupId>
      <artifactId>jakarta.servlet-api</artifactId>
      <version>6.0.0</version>
      <scope>provided</scope>
    </dependency>

    <dependency>
      <groupId>jakarta.servlet.jsp</groupId>
      <artifactId>jakarta.servlet.jsp-api</artifactId>
      <version>3.1.0</version>
      <scope>provided</scope>
    </dependency>

    <dependency>
      <groupId>jakarta.websocket</groupId>
      <artifactId>jakarta.websocket-api</artifactId>
      <version>2.1.0</version>
      <scope>provided</scope>
    </dependency>

    <dependency>
      <groupId>jakarta.el</groupId>
      <artifactId>jakarta.el-api</artifactId>
      <version>5.0.0</version>
      <scope>provided</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <!-- Plugin de migración Jakarta EE -->
      <plugin>
        <groupId>org.apache.tomcat</groupId>
        <artifactId>jakartaee-migration-maven-plugin</artifactId>
        <version>1.0.6</version>
        <executions>
          <execution>
            <id>migrate-javax-to-jakarta</id>
            <phase>package</phase>
            <goals>
              <goal>migrate</goal>
            </goals>
            <configuration>
              <source>
                ${project.build.directory}/${project.build.finalName}.war
              </source>
              <destination>
                ${project.build.directory}/${project.build.finalName}-jakarta.war
              </destination>
              <profile>EE</profile>
            </configuration>
          </execution>
        </executions>
      </plugin>

      <!-- Compilador apuntando a Java 11+ para Tomcat 10.x -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.11.0</version>
        <configuration>
          <source>17</source>
          <target>17</target>
          <encoding>UTF-8</encoding>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

### 10.4.4 Cambios en web.xml para Tomcat 10+

```xml
<!-- ============================================================ -->
<!-- ANTES — web.xml para Tomcat 9 (javax namespace)             -->
<!-- ============================================================ -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
             http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0"
         metadata-complete="false">
  <!-- contenido -->
</web-app>

<!-- ============================================================ -->
<!-- DESPUÉS — web.xml para Tomcat 10.0 (jakarta namespace)      -->
<!-- ============================================================ -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
             https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
         version="5.0"
         metadata-complete="false">
  <!-- contenido idéntico -->
</web-app>

<!-- ============================================================ -->
<!-- DESPUÉS — web.xml para Tomcat 10.1 (jakarta namespace)      -->
<!-- ============================================================ -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
             https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0"
         metadata-complete="false">
  <!-- contenido idéntico -->
</web-app>
```

### 10.4.5 Migración de dependencias de terceros

```xml
<!-- pom.xml — Dependencias de terceros que también cambian namespace -->
<dependencies>

  <!-- Spring Framework: usar Spring 6.x para jakarta.* -->
  <!-- Spring 5.x usa javax.* (para Tomcat 9) -->
  <!-- Spring 6.x usa jakarta.* (para Tomcat 10+) -->
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <!-- Spring 5.x para Tomcat 9 -->
    <!-- <version>5.3.31</version> -->
    <!-- Spring 6.x para Tomcat 10+ -->
    <version>6.1.5</version>
  </dependency>

  <!-- Hibernate: usar Hibernate 6.x para jakarta.* -->
  <dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <!-- Hibernate 5.x para javax.* (Tomcat 9) -->
    <!-- <version>5.6.15.Final</version> -->
    <!-- Hibernate 6.x para jakarta.* (Tomcat 10+) -->
    <version>6.4.4.Final</version>
  </dependency>

  <!-- JAX-RS (REST): usar Jersey 3.x o RESTEasy 6.x -->
  <dependency>
    <groupId>org.glassfish.jersey.containers</groupId>
    <artifactId>jersey-container-servlet</artifactId>
    <!-- Jersey 2.x para javax.* (Tomcat 9) -->
    <!-- <version>2.41</version> -->
    <!-- Jersey 3.x para jakarta.* (Tomcat 10+) -->
    <version>3.1.5</version>
  </dependency>

  <!-- JSF: usar Faces 4.x (Mojarra o MyFaces) -->
  <dependency>
    <groupId>org.glassfish</groupId>
    <artifactId>jakarta.faces</artifactId>
    <version>4.0.3</version>
  </dependency>

  <!-- Bean Validation -->
  <dependency>
    <groupId>jakarta.validation</groupId>
    <artifactId>jakarta.validation-api</artifactId>
    <version>3.0.2</version>
  </dependency>

  <!-- Hibernate Validator (implementación) -->
  <dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>8.0.1.Final</version>
  </dependency>

</dependencies>
```

---

## 10.5 Migración de Tomcat 10.0 a Tomcat 10.1

### 10.5.1 Cambios principales

| Área                   | Tomcat 10.0                | Tomcat 10.1                    |
|------------------------|----------------------------|--------------------------------|
| Servlet Spec           | 5.0                        | 6.0                            |
| JSP Spec               | 3.0                        | 3.1                            |
| EL Spec                | 4.0                        | 5.0                            |
| WebSocket Spec         | 2.0                        | 2.1                            |
| Java mínimo            | Java 8                     | Java 11 (obligatorio)          |
| SameSite cookies       | Disponible                 | Mejorado                       |
| `doTrace()` HTTP       | Habilitado                 | Deshabilitado por defecto      |

### 10.5.2 Checklist de migración 10.0 → 10.1

```bash
#!/bin/bash
# migrate-100-to-101.sh

echo "=== Verificación pre-migración Tomcat 10.0 → 10.1 ==="

# 1. Verificar JDK 11+
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' \
    | cut -d'.' -f1)

if [ "$JAVA_VER" -lt 11 ] 2>/dev/null; then
    echo "❌ BLOQUEANTE: JDK $JAVA_VER. Tomcat 10.1 requiere JDK 11+"
else
    echo "✅ JDK $JAVA_VER compatible con Tomcat 10.1"
fi

# 2. Verificar dependencias Servlet 5.0 → 6.0
echo ""
echo "[2] Verificando dependencias de la aplicación..."
WEBAPPS_DIR="${CATALINA_BASE:-/opt/tomcat}/webapps"

find "$WEBAPPS_DIR" -name "*.jar" 2>/dev/null | while read jar; do
    # Buscar clases que usen APIs de Servlet 5.0 específicas
    if unzip -l "$jar" 2>/dev/null | grep -q "jakarta/servlet"; then
        echo "  JAR con jakarta.servlet: $(basename $jar)"
    fi
done

echo ""
echo "=== Verificación completada ==="
```

---

## 10.6 Migración de Tomcat 10.1 a Tomcat 11.0

### 10.6.1 Cambios principales

| Área                     | Tomcat 10.1             | Tomcat 11.0                       |
|--------------------------|-------------------------|-----------------------------------|
| Servlet Spec             | 6.0                     | 6.1                               |
| JSP Spec                 | 3.1                     | 4.0                               |
| EL Spec                  | 5.0                     | 6.0                               |
| WebSocket Spec           | 2.1                     | 2.2                               |
| Java mínimo              | Java 11                 | Java 17 (obligatorio)             |
| Virtual Threads          | No disponible           | ✅ StandardVirtualThreadExecutor  |
| OpenSSL via FFM          | No disponible           | ✅ Disponible                     |
| doTrace() HTTP           | Deshabilitado defecto   | Deshabilitado defecto             |
| TLS 1.0/1.1              | Deshabilitado defecto   | Deshabilitado defecto             |

### 10.6.2 Adopción de Virtual Threads en Tomcat 11

```xml
<!-- server.xml — Adopción de Virtual Threads (Tomcat 11 + Java 21) -->

<!-- ANTES: Executor con Platform Threads -->
<Executor name="tomcatThreadPool"
          namePrefix="catalina-exec-"
          maxThreads="300"
          minSpareThreads="25"
          className="org.apache.catalina.core.StandardThreadExecutor"/>

<!-- DESPUÉS: Virtual Thread Executor (Tomcat 11 + Java 21) -->
<Executor name="tomcatThreadPool"
          namePrefix="catalina-exec-"
          className="org.apache.catalina.core.StandardVirtualThreadExecutor"/>

<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="tomcatThreadPool"
           maxConnections="50000"
           acceptCount="500"
           connectionTimeout="20000"
           URIEncoding="UTF-8"
           compression="on"
           compressionMinSize="1024"/>
```

```bash
# setenv.sh — Tomcat 11 con Java 21
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# En Java 21, Virtual Threads son estables
# No requieren flags adicionales
CATALINA_OPTS="$CATALINA_OPTS -Xms2g -Xmx6g"
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseZGC"
CATALINA_OPTS="$CATALINA_OPTS -XX:+ZGenerational"

# Con Virtual Threads, el maxThreads clásico no aplica
# pero maxConnections sigue siendo relevante
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Europe/Madrid"

export CATALINA_OPTS
```

---

## 10.7 Estrategias de Migración en Producción

### 10.7.1 Estrategia Blue-Green Deployment

```bash
#!/bin/bash
# blue-green-migration.sh
# Migración sin downtime usando entornos Blue/Green

set -euo pipefail

# ============================================================
# CONFIGURACIÓN
# ============================================================
BLUE_TOMCAT="/opt/tomcat-blue"    # Versión actual (ej: Tomcat 9)
GREEN_TOMCAT="/opt/tomcat-green"  # Nueva versión (ej: Tomcat 10.1)
LB_CONFIG="/etc/nginx/conf.d/app.conf"
APP_WAR="myapp-jakarta.war"
HEALTH_URL_BLUE="http://localhost:8080/myapp/health"
HEALTH_URL_GREEN="http://localhost:8090/myapp/health"

echo "=== Migración Blue-Green ==="
echo "Blue (actual):  $BLUE_TOMCAT"
echo "Green (nueva):  $GREEN_TOMCAT"
echo ""

# ============================================================
# FASE 1: Preparar el entorno Green
# ============================================================
echo "--- FASE 1: Preparando entorno Green ---"

# Instalar nueva versión de Tomcat
if [ ! -d "$GREEN_TOMCAT" ]; then
    echo "Instalando Tomcat 10.1 en $GREEN_TOMCAT..."
    tar -xzf /tmp/apache-tomcat-10.1.20.tar.gz -C /opt
    ln -s /opt/apache-tomcat-10.1.20 "$GREEN_TOMCAT"
fi

# Copiar configuración migrada
cp -r "$BLUE_TOMCAT/conf/"* "$GREEN_TOMCAT/conf/"

# Aplicar cambios de configuración para nueva versión
# (AJP secrets, SSLHostConfig, etc.)
echo "Configuración copiada y adaptada"

# Desplegar WAR migrado a jakarta.*
cp "/opt/releases/$APP_WAR" "$GREEN_TOMCAT/webapps/myapp.war"

# ============================================================
# FASE 2: Arrancar el entorno Green
# ============================================================
echo ""
echo "--- FASE 2: Arrancando entorno Green (puerto 8090) ---"

export CATALINA_HOME="$GREEN_TOMCAT"
export CATALINA_BASE="$GREEN_TOMCAT"
export CATALINA_PID="$GREEN_TOMCAT/temp/tomcat.pid"

"$GREEN_TOMCAT/bin/startup.sh"

# Esperar a que Green esté disponible
echo "Esperando disponibilidad de Green..."
MAX_WAIT=120
WAITED=0

until curl -sf "$HEALTH_URL_GREEN" >/dev/null 2>&1; do
    sleep 2
    WAITED=$((WAITED + 2))
    if [ $WAITED -ge $MAX_WAIT ]; then
        echo "❌ Green no disponible tras ${MAX_WAIT}s. Abortando migración."
        "$GREEN_TOMCAT/bin/shutdown.sh" 30 -force
        exit 1
    fi
    echo -n "."
done

echo ""
echo "✅ Green disponible tras ${WAITED}s"

# ============================================================
# FASE 3: Smoke tests en Green
# ============================================================
echo ""
echo "--- FASE 3: Smoke Tests en Green ---"

run_test() {
    local url="$1"
    local expected="$2"
    local result

    result=$(curl -s -o /dev/null -w "%{http_code}" \
        --connect-timeout 5 --max-time 10 "$url" 2>/dev/null)

    if [ "$result" = "$expected" ]; then
        echo "  ✅ $url → HTTP $result"
        return 0
    else
        echo "  ❌ $url → HTTP $result (esperado: $expected)"
        return 1
    fi
}

TESTS_PASSED=true

run_test "http://localhost:8090/myapp/health"     "200" || TESTS_PASSED=false
run_test "http://localhost:8090/myapp/api/status" "200" || TESTS_PASSED=false
run_test "http://localhost:8090/myapp/login.html" "200" || TESTS_PASSED=false

if ! $TESTS_PASSED; then
    echo "❌ Smoke tests fallaron. Manteniendo Blue activo."
    "$GREEN_TOMCAT/bin/shutdown.sh" 30 -force
    exit 1
fi

# ============================================================
# FASE 4: Switchover del balanceador
# ============================================================
echo ""
echo "--- FASE 4: Switchover del Load Balancer ---"
echo "Redirigiendo tráfico de Blue (8080) → Green (8090)..."

# Actualizar configuración de Nginx
cat > "$LB_CONFIG" << 'NGINX'
upstream tomcat_backend {
    server 127.0.0.1:8090;  # Green (nueva versión)
    # server 127.0.0.1:8080;  # Blue (versión anterior — comentado)
}

server {
    listen 443 ssl http2;
    server_name app.miempresa.com;
    # ... resto de configuración ...
    location / {
        proxy_pass http://tomcat_backend;
        # ...
    }
}
NGINX

# Recargar Nginx sin downtime
nginx -t && nginx -s reload
echo "✅ Nginx recargado — tráfico en Green"

# ============================================================
# FASE 5: Monitorización post-switchover
# ============================================================
echo ""
echo "--- FASE 5: Monitorización post-switchover (5 min) ---"
sleep 300

# Verificar que Green sigue saludable
if curl -sf "$HEALTH_URL_GREEN" >/dev/null 2>&1; then
    echo "✅ Green estable tras 5 minutos"
else
    echo "❌ Green con problemas. Ejecutar rollback manual."
    echo "  Para rollback: cambiar nginx upstream a puerto 8080"
    exit 1
fi

# ============================================================
# FASE 6: Drenado y parada de Blue
# ============================================================
echo ""
echo "--- FASE 6: Drenado de Blue ---"
echo "Esperando que las sesiones de Blue expiren (10 min)..."
sleep 600

echo "Parando Blue (Tomcat 9)..."
CATALINA_HOME="$BLUE_TOMCAT" \
CATALINA_BASE="$BLUE_TOMCAT" \
"$BLUE_TOMCAT/bin/shutdown.sh" 30 -force

echo ""
echo "=== Migración Blue-Green COMPLETADA ==="
echo "Nueva versión activa en: $GREEN_TOMCAT"
```

### 10.7.2 Estrategia Canary Release

```bash
#!/bin/bash
# canary-migration.sh
# Enrutar un porcentaje del tráfico a la nueva versión

NGINX_CONF="/etc/nginx/conf.d/app.conf"
CANARY_WEIGHT="${1:-10}"  # % de tráfico al canary (nueva versión)
STABLE_WEIGHT=$((100 - CANARY_WEIGHT))

echo "=== Canary Release: ${CANARY_WEIGHT}% → Nueva versión ==="

cat > "$NGINX_CONF" << NGINX
# Split testing: ${STABLE_WEIGHT}% → Tomcat 9 | ${CANARY_WEIGHT}% → Tomcat 10.1
upstream tomcat_stable {
    server 127.0.0.1:8080 weight=${STABLE_WEIGHT};
}

upstream tomcat_canary {
    server 127.0.0.1:8090 weight=${CANARY_WEIGHT};
}

# Mapa para routing basado en cookie de canary
map \$http_cookie \$backend {
    default         "tomcat_stable";
    "~*canary=true" "tomcat_canary";
}

# Routing por peso para usuarios nuevos
split_clients "\${remote_addr}\${http_user_agent}" \$weight_backend {
    ${CANARY_WEIGHT}%  "tomcat_canary";
    *                  "tomcat_stable";
}

server {
    listen 443 ssl http2;
    server_name app.miempresa.com;

    location / {
        # Usar cookie si existe, peso aleatorio si no
        set \$target \$backend;
        if (\$target = "tomcat_stable") {
            set \$target \$weight_backend;
        }

        proxy_pass         http://\$target;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;

        # Header para identificar qué versión sirvió la petición
        add_header X-Served-By \$target always;
    }
}
NGINX

nginx -t && nginx -s reload
echo "✅ Canary activo: ${CANARY_WEIGHT}% a nueva versión"
```

---

## 10.8 Script de Migración Integral

```bash
#!/bin/bash
# tomcat-migration-advisor.sh
# Analiza una instalación Tomcat y genera un informe de migración

set -euo pipefail

CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
TARGET_VERSION="${1:-10.1}"
SERVER_XML="$CATALINA_BASE/conf/server.xml"
CONTEXT_XML="$CATALINA_BASE/conf/context.xml"
WEBAPPS_DIR="$CATALINA_BASE/webapps"

ISSUES=0
WARNINGS=0
INFO=0

issue()   { echo "  ❌ ISSUE:   $1"; ISSUES=$((ISSUES+1)); }
warning() { echo "  ⚠️  WARN:   $1"; WARNINGS=$((WARNINGS+1)); }
info()    { echo "  ℹ️  INFO:   $1"; INFO=$((INFO+1)); }
ok()      { echo "  ✅ OK:     $1"; }

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     Tomcat Migration Advisor                             ║"
echo "║     Destino: Tomcat $TARGET_VERSION                      "
echo "║     Base: $CATALINA_BASE                                 "
echo "║     $(date)                                              "
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ===== Detectar versión actual =====
CURRENT_VERSION=$("$CATALINA_BASE/bin/version.sh" 2>/dev/null \
    | grep "Server version" | grep -o '[0-9]\+\.[0-9]\+' | head -1 \
    || echo "unknown")
echo "Versión actual detectada: Tomcat $CURRENT_VERSION"
echo "Versión destino:          Tomcat $TARGET_VERSION"
echo ""

# ===== Análisis de server.xml =====
echo "━━━ Análisis de server.xml ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# BIO Protocol
if grep -qE "Http11BioProtocol|AjpBioProtocol" "$SERVER_XML" 2>/dev/null; then
    issue "Protocolo BIO encontrado — eliminado en Tomcat 9+"
    echo "         Cambiar a Http11NioProtocol"
else
    ok "Sin protocolo BIO"
fi

# AJP sin secret
if grep -qE "AJP|ajp" "$SERVER_XML" 2>/dev/null; then
    if ! grep -q 'secretRequired="true"' "$SERVER_XML" 2>/dev/null; then
        issue "AJP sin secretRequired=true — vulnerable Ghostcat CVE-2020-1938"
    else
        ok "AJP con secretRequired=true"
    fi
fi

# SSL antiguo vs SSLHostConfig
if grep -q 'SSLEnabled="true"' "$SERVER_XML" 2>/dev/null; then
    if grep -q "SSLHostConfig" "$SERVER_XML" 2>/dev/null; then
        ok "SSL con SSLHostConfig (formato actual)"
    else
        warning "SSL con atributos directos — deprecado desde Tomcat 8.5"
    fi
fi

# Puerto shutdown
if grep -q 'port="-1"' "$SERVER_XML" 2>/dev/null; then
    ok "Puerto de shutdown deshabilitado"
else
    warning "Puerto de shutdown habilitado — deshabilitar en producción"
fi

# ===== Análisis de JDK =====
echo ""
echo "━━━ Análisis de JDK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' \
    | sed 's/^1\.//' | cut -d'.' -f1)

echo "  JDK actual: Java $JAVA_VER"

case "$TARGET_VERSION" in
    "8.5") MIN_JAVA=7 ;;
    "9.0") MIN_JAVA=8 ;;
    "10.0") MIN_JAVA=8 ;;
    "10.1") MIN_JAVA=11 ;;
    "11.0") MIN_JAVA=17 ;;
    *) MIN_JAVA=11 ;;
esac

if [ "$JAVA_VER" -ge "$MIN_JAVA" ] 2>/dev/null; then
    ok "JDK $JAVA_VER compatible con Tomcat $TARGET_VERSION (mín: $MIN_JAVA)"
else
    issue "JDK $JAVA_VER insuficiente para Tomcat $TARGET_VERSION (requiere $MIN_JAVA+)"
fi

# ===== Análisis de namespace (solo para migración a 10+) =====
if [[ "$TARGET_VERSION" == "10"* ]] || [[ "$TARGET_VERSION" == "11"* ]]; then
    echo ""
    echo "━━━ Análisis de Namespace javax.* → jakarta.* ━━━━━━━━━━"

    JAVAX_COUNT=0
    JAKARTA_COUNT=0

    # Buscar en WARs desplegados
    find "$WEBAPPS_DIR" -name "*.class" 2>/dev/null | while read classfile; do
        if strings "$classfile" 2>/dev/null | grep -q "javax/servlet"; then
            JAVAX_COUNT=$((JAVAX_COUNT + 1))
        fi
        if strings "$classfile" 2>/dev/null | grep -q "jakarta/servlet"; then
            JAKARTA_COUNT=$((JAKARTA_COUNT + 1))
        fi
    done

    # Buscar en archivos Java fuente si están disponibles
    JAVAX_IN_SRC=$(find "$WEBAPPS_DIR" -name "*.java" 2>/dev/null \
        | xargs grep -l "import javax.servlet" 2>/dev/null | wc -l || echo 0)

    if [ "$JAVAX_IN_SRC" -gt 0 ] 2>/dev/null; then
        issue "Encontrados $JAVAX_IN_SRC archivos Java con import javax.servlet.*"
        echo "         Ejecutar: jakartaee-migration-1.0.6-shaded.jar"
    fi

    # Verificar web.xml namespace
    find "$WEBAPPS_DIR" -name "web.xml" 2>/dev/null | while read webxml; do
        APP=$(echo "$webxml" | sed "s|$WEBAPPS_DIR/||" | cut -d'/' -f1)
        if grep -q "xmlns.jcp.org\|java.sun.com" "$webxml" 2>/dev/null; then
            issue "web.xml de '$APP' usa namespace javax — requiere migración"
            echo "         Cambiar xmlns a: https://jakarta.ee/xml/ns/jakartaee"
        else
            ok "web.xml de '$APP' — namespace correcto"
        fi
    done

    # Buscar librerías de terceros incompatibles en WEB-INF/lib
    find "$WEBAPPS_DIR" -path "*/WEB-INF/lib/*.jar" 2>/dev/null | while read jar; do
        JAR_NAME=$(basename "$jar")
        APP=$(echo "$jar" | sed "s|$WEBAPPS_DIR/||" | cut -d'/' -f1)

        # Spring Framework
        if echo "$JAR_NAME" | grep -qi "spring-webmvc-5\|spring-web-5"; then
            issue "[$APP] Spring 5.x detectado — incompatible con jakarta.*"
            echo "         Migrar a Spring 6.x"
        fi

        # Hibernate ORM
        if echo "$JAR_NAME" | grep -qi "hibernate-core-5"; then
            issue "[$APP] Hibernate 5.x detectado — incompatible con jakarta.*"
            echo "         Migrar a Hibernate 6.x"
        fi

        # Jersey JAX-RS
        if echo "$JAR_NAME" | grep -qi "jersey.*2\.[0-9]"; then
            warning "[$APP] Jersey 2.x — verificar compatibilidad con jakarta.*"
            echo "         Considerar migrar a Jersey 3.x"
        fi
    done
fi

# ===== Análisis de aplicaciones =====
echo ""
echo "━━━ Análisis de Aplicaciones ━━━━━━━━━━━━━━━━━━━━━━━━━━"
for APP_DIR in "$WEBAPPS_DIR"/*/; do
    APP_NAME=$(basename "$APP_DIR")
    [ "$APP_NAME" = "manager" ] && continue
    [ "$APP_NAME" = "host-manager" ] && continue

    echo "  Aplicación: $APP_NAME"

    # Verificar elemento distributable para clustering
    WEB_XML="$APP_DIR/WEB-INF/web.xml"
    if [ -f "$WEB_XML" ]; then
        if grep -q "<distributable" "$WEB_XML" 2>/dev/null; then
            ok "  $APP_NAME: <distributable/> presente"
        else
            info "  $APP_NAME: sin <distributable/> — sesiones no se replicarán en cluster"
        fi
    fi

    # Verificar descriptor de contexto
    CONTEXT_DESC="$CATALINA_BASE/conf/Catalina/localhost/${APP_NAME}.xml"
    if [ -f "$CONTEXT_DESC" ]; then
        ok "  $APP_NAME: descriptor de contexto externo encontrado"
    else
        info "  $APP_NAME: sin descriptor externo — se usa META-INF/context.xml"
    fi
done

# ===== Resumen y plan de acción =====
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    Resumen del Análisis                  ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║  Issues críticos:  $ISSUES"
echo "║  Advertencias:     $WARNINGS"
echo "║  Informativos:     $INFO"
echo "╠══════════════════════════════════════════════════════════╣"

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "║  Estado: ✅ LISTO PARA MIGRAR a Tomcat $TARGET_VERSION     ║"
elif [ $ISSUES -eq 0 ]; then
    echo "║  Estado: ⚠️  REVISAR ADVERTENCIAS antes de migrar          ║"
else
    echo "║  Estado: ❌ RESOLVER ISSUES antes de migrar                ║"
fi

echo "╠══════════════════════════════════════════════════════════╣"
echo "║  Plan de Acción Recomendado:                             ║"
echo "║  1. Resolver todos los issues críticos                   ║"
echo "║  2. Actualizar JDK al mínimo requerido                   ║"
echo "║  3. Ejecutar jakartaee-migration-tool (si aplica)        ║"
echo "║  4. Actualizar dependencias de terceros                  ║"
echo "║  5. Probar en entorno de staging con la nueva versión    ║"
echo "║  6. Ejecutar suite de tests de regresión completa        ║"
echo "║  7. Aplicar estrategia Blue-Green en producción          ║"
echo "╚══════════════════════════════════════════════════════════╝"

[ $ISSUES -gt 0 ] && exit 1 || exit 0
```

---

## 10.9 Tabla Maestra de Cambios por Versión

### Cambios de configuración acumulados

| Configuración / Feature                     | 8.0  | 8.5   | 9.0   | 10.0  | 10.1  | 11.0  |
|---------------------------------------------|------|-------|-------|-------|-------|-------|
| Protocolo HTTP BIO                          | ✅   | ⚠️Dep | ❌    | ❌    | ❌    | ❌    |
| Protocolo HTTP NIO                          | ✅   | ✅    | ✅    | ✅    | ✅    | ✅    |
| HTTP/2 (UpgradeProtocol)                    | ❌   | ✅    | ✅    | ✅    | ✅    | ✅    |
| SSLHostConfig / Certificate                 | ❌   | ✅    | ✅    | ✅    | ✅    | ✅    |
| TLS 1.3                                     | ❌   | ❌    | ✅*   | ✅*   | ✅    | ✅    |
| CredentialHandler (PBKDF2)                  | ❌   | ✅    | ✅    | ✅    | ✅    | ✅    |
| AJP secretRequired                          | ❌   | ✅**  | ✅**  | ✅    | ✅    | ✅    |
| Namespace javax.servlet.*                   | ✅   | ✅    | ✅    | ❌    | ❌    | ❌    |
| Namespace jakarta.servlet.*                 | ❌   | ❌    | ❌    | ✅    | ✅    | ✅    |
| Servlet 3.1 / PushBuilder                   | ✅   | ✅    | ❌    | ❌    | ❌    | ❌    |
| Servlet 4.0 / PushBuilder javax.*           | ❌   | ❌    | ✅    | ❌    | ❌    | ❌    |
| Servlet 5.0 / PushBuilder jakarta.*         | ❌   | ❌    | ❌    | ✅    | ❌    | ❌    |
| Servlet 6.0                                 | ❌   | ❌    | ❌    | ❌    | ✅    | ❌    |
| Servlet 6.1                                 | ❌   | ❌    | ❌    | ❌    | ❌    | ✅    |
| Java mínimo                                 | 7    | 7     | 8     | 8     | 11    | 17    |
| Virtual Threads Executor                    | ❌   | ❌    | ❌    | ❌    | ❌    | ✅    |
| OpenSSL via FFM API                         | ❌   | ❌    | ❌    | ❌    | ❌    | ✅    |
| doTrace() deshabilitado por defecto         | ❌   | ❌    | ❌    | ❌    | ✅    | ✅    |
| TLS 1.0/1.1 deshabilitado por defecto       | ❌   | ❌    | ❌    | ✅    | ✅    | ✅    |
| Generational ZGC (Java 21)                  | ❌   | ❌    | ❌    | ❌    | ❌    | ✅    |
| AsyncFileHandler JULI                       | ❌   | ✅    | ✅    | ✅    | ✅    | ✅    |
| SameSite cookies                            | ❌   | ✅    | ✅    | ✅    | ✅    | ✅    |
| Rfc6265CookieProcessor default              | ❌   | ✅    | ✅    | ✅    | ✅    | ✅    |

*Requiere JDK 11+  
**A partir de versiones de parche post-Ghostcat

---

## 10.10 Guía de Rollback de Emergencia

```bash
#!/bin/bash
# rollback-tomcat.sh
# Rollback de emergencia a la versión anterior

set -euo pipefail

PREVIOUS_TOMCAT="${1:-/opt/tomcat-previous}"
CURRENT_TOMCAT="${2:-/opt/tomcat}"
LB_CONFIG="${3:-/etc/nginx/conf.d/app.conf}"
BACKUP_LB="${LB_CONFIG}.bak"

echo "=== ROLLBACK DE EMERGENCIA ==="
echo "Timestamp: $(date)"
echo "Previous:  $PREVIOUS_TOMCAT"
echo "Current:   $CURRENT_TOMCAT"
echo ""

# 1. Verificar que la versión anterior existe y arranca
if [ ! -d "$PREVIOUS_TOMCAT" ]; then
    echo "❌ CRÍTICO: Directorio de versión anterior no encontrado"
    exit 1
fi

# 2. Parar la versión actual
echo "Parando versión actual..."
if [ -f "$CURRENT_TOMCAT/temp/tomcat.pid" ]; then
    CURRENT_PID=$(cat "$CURRENT_TOMCAT/temp/tomcat.pid")
    "$CURRENT_TOMCAT/bin/shutdown.sh" 15 -force 2>/dev/null || true
    sleep 5
    kill -9 "$CURRENT_PID" 2>/dev/null || true
fi
echo "✅ Versión actual parada"

# 3. Reactivar la versión anterior
echo "Arrancando versión anterior..."
export CATALINA_HOME="$PREVIOUS_TOMCAT"
export CATALINA_BASE="$PREVIOUS_TOMCAT"
"$PREVIOUS_TOMCAT/bin/startup.sh"

# 4. Esperar disponibilidad
echo "Esperando disponibilidad..."
for i in $(seq 1 30); do
    if curl -sf "http://localhost:8080/health" >/dev/null 2>&1; then
        echo "✅ Versión anterior disponible"
        break
    fi
    sleep 2
done

# 5. Restaurar configuración del balanceador
if [ -f "$BACKUP_LB" ]; then
    cp "$BACKUP_LB" "$LB_CONFIG"
    nginx -t && nginx -s reload
    echo "✅ Load balancer restaurado desde backup"
else
    echo "⚠️  No hay backup del LB — configurar manualmente"
fi

# 6. Registrar el rollback
echo "$(date): ROLLBACK ejecutado de $CURRENT_TOMCAT a $PREVIOUS_TOMCAT" \
    >> /var/log/tomcat-migrations.log

echo ""
echo "=== ROLLBACK COMPLETADO ==="
echo "Verificar manualmente el estado de la aplicación"
echo "y notificar al equipo de operaciones"
```

---

## Puntos Clave del Módulo 10

- El cambio más crítico en la historia de Tomcat es el **cambio de namespace `javax.*` → `jakarta.*`** en Tomcat 10. Todas las aplicaciones que usan APIs Servlet deben ser migradas o convertidas con la Migration Tool.
- La migración **8.0 → 8.5** es la más sencilla: el único cambio impactante es la deprecación de BIO y el nuevo formato SSL con `SSLHostConfig`.
- La migración **8.5 → 9.0** tiene un bloqueante: el BIO está **eliminado**. Si se usa BIO, es imposible arrancar Tomcat 9 sin cambiar el protocolo del conector.
- La migración **9 → 10** requiere **recompilar la aplicación** contra las nuevas APIs `jakarta.*` o usar la Jakarta EE Migration Tool para conversión binaria.
- Las migraciones **10.0 → 10.1** y **10.1 → 11.0** son principalmente cambios de JDK mínimo requerido (Java 11 y Java 17 respectivamente).
- **Tomcat 11 con Java 21** introduce Virtual Threads que eliminan el modelo thread-per-request limitado por `maxThreads`.
- Usar siempre la estrategia **Blue-Green o Canary** para migraciones en producción. Nunca migrar directamente en el entorno productivo sin entorno paralelo.
- El **script de Migration Advisor** debe ejecutarse antes de cualquier migración para identificar todos los issues bloqueantes antes de comenzar.
- Mantener siempre un **plan de rollback documentado y probado** antes de ejecutar la migración en producción.
- Las dependencias de terceros (**Spring, Hibernate, Jersey, JSF**) tienen versiones específicas para `javax.*` y para `jakarta.*`. Actualizar ambas en paralelo con la migración de Tomcat.

---

## Epílogo: Resumen del Manual Completo

```
╔══════════════════════════════════════════════════════════════════════╗
║         Manual de Formación: Apache Tomcat 8.0 → 11                ║
║                        ÍNDICE FINAL                                  ║
╠══════════════════════════════════════════════════════════════════════╣
║  Módulo 01 → Arquitectura interna y componentes del servidor         ║
║  Módulo 02 → Instalación, estructura de directorios y arranque       ║
║  Módulo 03 → Configuración de server.xml en profundidad              ║
║  Módulo 04 → Conectores HTTP/1.1, HTTP/2 y AJP                       ║
║  Módulo 05 → Gestión de aplicaciones web y web.xml                   ║
║  Módulo 06 → Seguridad: TLS/SSL, Realms y autenticación              ║
║  Módulo 07 → Pools de conexiones JNDI y DataSources                  ║
║  Módulo 08 → Clustering y sesiones distribuidas                      ║
║  Módulo 09 → Rendimiento, tuning y monitorización con JMX            ║
║  Módulo 10 → Migración entre versiones (8.0 → 8.5 → 9 → 10 → 11)   ║
╠══════════════════════════════════════════════════════════════════════╣
║  Versiones cubiertas: 8.0 | 8.5 | 9.0 | 10.0 | 10.1 | 11.0         ║
║  Nivel: Avanzado — Arquitecto de Software / Líder de Infraestructura ║
╚══════════════════════════════════════════════════════════════════════╝
```