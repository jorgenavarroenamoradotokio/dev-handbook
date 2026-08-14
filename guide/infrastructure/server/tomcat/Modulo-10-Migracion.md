> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Visión General del Mapa de Migración](#1-visión-general-del-mapa-de-migración)
  - [¿Por qué migrar de versión?](#por-qué-migrar-de-versión)
  - [El mapa completo de versiones](#el-mapa-completo-de-versiones)
  - [Tabla de compatibilidad: ¿qué implica cada salto?](#tabla-de-compatibilidad-qué-implica-cada-salto)
- [2. Migración de Tomcat 8.0 a Tomcat 8.5](#2-migración-de-tomcat-80-a-tomcat-85)
  - [¿Qué cambia realmente?](#qué-cambia-realmente)
  - [Checklist de migración 8.0 → 8.5](#checklist-de-migración-80--85)
  - [Cambios en server.xml para 8.5](#cambios-en-serverxml-para-85)
- [3. Migración de Tomcat 8.5 a Tomcat 9.0](#3-migración-de-tomcat-85-a-tomcat-90)
  - [¿Qué cambia?](#qué-cambia)
  - [Checklist de migración 8.5 → 9.0](#checklist-de-migración-85--90)
  - [Cambios en configuración para Tomcat 9.0](#cambios-en-configuración-para-tomcat-90)
- [4. Migración de Tomcat 9 a Tomcat 10 — El Cambio Crítico](#4-migración-de-tomcat-9-a-tomcat-10--el-cambio-crítico)
  - [El cambio más importante en la historia de Tomcat](#el-cambio-más-importante-en-la-historia-de-tomcat)
  - [¿Por qué ocurrió este cambio?](#por-qué-ocurrió-este-cambio)
  - [Alcance completo del cambio de namespace](#alcance-completo-del-cambio-de-namespace)
  - [Impacto en el código de la aplicación](#impacto-en-el-código-de-la-aplicación)
  - [Migración automática con la Jakarta EE Migration Tool](#migración-automática-con-la-jakarta-ee-migration-tool)
  - [Cambios en web.xml para Tomcat 10+](#cambios-en-webxml-para-tomcat-10)
  - [Migración de dependencias de terceros](#migración-de-dependencias-de-terceros)
- [5.Migración de Tomcat 10.0 a Tomcat 10.1](#5migración-de-tomcat-100-a-tomcat-101)
  - [¿Qué cambia?](#qué-cambia-1)
  - [Checklist de migración 10.0 → 10.1](#checklist-de-migración-100--101)
- [6. Migración de Tomcat 10.1 a Tomcat 11.0](#6-migración-de-tomcat-101-a-tomcat-110)
  - [¿Qué cambia?](#qué-cambia-2)
  - [La gran novedad: Virtual Threads](#la-gran-novedad-virtual-threads)
- [7. Estrategias de Migración en Producción](#7-estrategias-de-migración-en-producción)
  - [¿Por qué no actualizar directamente?](#por-qué-no-actualizar-directamente)
  - [Estrategia Blue-Green Deployment](#estrategia-blue-green-deployment)
  - [Estrategia Canary Release](#estrategia-canary-release)
- [8. Script de Migración Integral](#8-script-de-migración-integral)
- [9. Tabla Maestra de Cambios por Versión](#9-tabla-maestra-de-cambios-por-versión)
- [10. Guía de Rollback de Emergencia](#10-guía-de-rollback-de-emergencia)
  - [¿Qué es un rollback y cuándo ejecutarlo?](#qué-es-un-rollback-y-cuándo-ejecutarlo)
- [11. Puntos Clave](#11-puntos-clave)

---

# 1. Visión General del Mapa de Migración

## ¿Por qué migrar de versión?

Las razones para migrar Tomcat a una versión más reciente son varias: recibir parches de seguridad, adoptar nuevas especificaciones de Servlet que permiten nuevas funcionalidades, aprovechar mejoras de rendimiento, o simplemente porque la versión actual llega al fin de su ciclo de soporte.

Pero no todas las migraciones tienen el mismo coste. Algunas son casi transparentes (cambiar un par de líneas en `server.xml`) y otras requieren modificar toda la aplicación Java. Saber de antemano qué te espera en cada salto es fundamental para planificarlo correctamente.

## El mapa completo de versiones

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
│     │                   │   SSL renovado (SSLHostConfig)             │
│     │                   │                                            │
│     └───────────────────┴──────► Tomcat 9.0                          │
│                                      │                               │
│                                      │   Java 8+ (obligatorio)       │
│                                      │   javax.*                     │
│                                      │   Servlet 4.0                 │
│                                      │   BIO ELIMINADO               │
│                                      │   HTTP/2 completo             │
│                                      │                               │
│                    ╔═════════════════▼═══════════════╗               │
│                    ║   LA GRAN BARRERA: NAMESPACE    ║               │
│                    ║   javax.* → jakarta.*           ║               │
│                    ║   Requiere migrar toda la app   ║               │
│                    ╚═════════════════╤═══════════════╝               │
│                                      │                               │
│                                      ▼                               │
│                                  Tomcat 10.0                         │
│                                      │   Java 8+                     │
│                                      │   jakarta.*  (¡nuevo!)        │
│                                      │   Servlet 5.0                 │
│                                      │                               │
│                                      ▼                               │
│                                  Tomcat 10.1                         │
│                                      │   Java 11+ (obligatorio)      │
│                                      │   jakarta.*                   │
│                                      │   Servlet 6.0                 │
│                                      │                               │
│                                      ▼                               │
│                                  Tomcat 11.0                         │
│                                      │   Java 17+ (obligatorio)      │
│                                      │   jakarta.*                   │
│                                      │   Servlet 6.1                 │
│                                      │   Virtual Threads             │
└──────────────────────────────────────────────────────────────────────┘
```

## Tabla de compatibilidad: ¿qué implica cada salto?

| Salto de versión  | ¿Cambia el namespace de APIs? | ¿Cambia el JDK mínimo? | Complejidad | Riesgo   |
|-------------------|-------------------------------|------------------------|-------------|----------|
| 8.0 → 8.5         | ❌ No                         | ❌ No                  | Baja        | Bajo     |
| 8.5 → 9.0         | ❌ No                         | ⚠️ Sí, Java 8 mínimo  | Media       | Medio    |
| 9.0 → 10.0        | ✅ **Sí, cambio crítico**     | ❌ No                  | Alta        | Alto     |
| 10.0 → 10.1       | ❌ No                         | ⚠️ Sí, Java 11 mínimo | Baja        | Bajo     |
| 10.1 → 11.0       | ❌ No                         | ⚠️ Sí, Java 17 mínimo | Media       | Medio    |
| 8.x → 10.x        | ✅ **Sí, cambio crítico**     | ⚠️ Java 11 mínimo     | Muy Alta    | Alto     |
| 8.x → 11.0        | ✅ **Sí, cambio crítico**     | ⚠️ Java 17 mínimo     | Muy Alta    | Muy Alto |

> 💡 **Consejo práctico:** Si tienes una aplicación en Tomcat 9 y quieres ir a Tomcat 11, el salto más difícil no es el cambio de JDK (que puedes actualizar de forma independiente), sino el cambio de namespace de APIs (javax → jakarta). Ese trabajo solo lo haces una vez, así que tiene sentido subir directamente a la última versión estable en lugar de hacer paradas intermedias.

# 2. Migración de Tomcat 8.0 a Tomcat 8.5

## ¿Qué cambia realmente?

Esta es la migración más sencilla del mapa. No hay cambio de namespace, no hay cambio de JDK mínimo, y la gran mayoría de aplicaciones funciona sin tocar una línea de código. Los cambios principales están en la configuración del servidor:

| Área                    | Tomcat 8.0                          | Tomcat 8.5                               |
|-------------------------|-------------------------------------|------------------------------------------|
| Protocolo HTTP BIO      | Disponible y funcional              | Deprecado (funciona pero con aviso)      |
| HTTP/2                  | No disponible                       | Disponible via `UpgradeProtocol`         |
| Configuración SSL/TLS   | Atributos directos en el Connector  | Nuevo formato `SSLHostConfig`+`Certificate` |
| Manejo de cookies       | `LegacyCookieProcessor` por defecto | `Rfc6265CookieProcessor` por defecto     |
| Logs asíncronos (JULI)  | No disponible                       | `AsyncFileHandler` disponible            |
| Almacenamiento contraseñas | Solo hash simple (MD5, SHA-1)    | `CredentialHandler` con PBKDF2/SHA-256   |

El cambio con más impacto práctico es el **nuevo formato de configuración SSL**. En 8.0, el certificado y los parámetros TLS se configuraban como atributos directamente en el `<Connector>`. En 8.5, se introdujo una estructura más flexible y expresiva con `<SSLHostConfig>` y `<Certificate>` que permite, entre otras cosas, configurar diferentes certificados por dominio (SNI) sin necesitar varias IPs.

## Checklist de migración 8.0 → 8.5

Este script detecta los cambios necesarios en tu instalación actual antes de que instales 8.5:

```bash
#!/bin/bash
# migrate-80-to-85.sh
# Ejecutar ANTES de instalar Tomcat 8.5 para conocer qué hay que cambiar

echo "=== Verificación pre-migración Tomcat 8.0 → 8.5 ==="
echo ""

CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
SERVER_XML="$CATALINA_BASE/conf/server.xml"

# 1. Verificar si se usa el protocolo BIO
# El BIO está deprecado en 8.5 y ELIMINADO en 9.0.
# Si lo tienes en 8.0, mejor cambiar ya a NIO para no tener que hacerlo
# de nuevo cuando subas a 9.0.
echo "[1] Verificando protocolo BIO..."
if grep -q "Http11BioProtocol\|BIO" "$SERVER_XML" 2>/dev/null; then
    echo "  ⚠️  ACCIÓN REQUERIDA: Protocolo BIO detectado"
    echo "  Cambiar: Http11BioProtocol → Http11NioProtocol"
    echo "  El BIO está deprecado en 8.5 y será eliminado en 9.0"
else
    echo "  ✅ Sin uso de BIO"
fi

# 2. Verificar el formato de configuración SSL
# En 8.5+ el formato antiguo (atributos en Connector) sigue funcionando
# pero está deprecado. Es mejor migrar al nuevo formato ahora.
echo ""
echo "[2] Verificando configuración SSL..."
if grep -q 'SSLEnabled="true"' "$SERVER_XML" 2>/dev/null; then
    if ! grep -q "SSLHostConfig" "$SERVER_XML" 2>/dev/null; then
        echo "  ⚠️  ACCIÓN RECOMENDADA: SSL configurado con atributos directos"
        echo "  Funciona en 8.5 pero está deprecado"
        echo "  Migrar al nuevo formato SSLHostConfig + Certificate"
    else
        echo "  ✅ SSL con SSLHostConfig (formato correcto)"
    fi
fi

# 3. Verificar el procesador de cookies
# En 8.5, el procesador por defecto cambió a Rfc6265CookieProcessor.
# Si tu app usa cookies con caracteres especiales o formatos no estándar,
# esto puede causar que ciertas cookies dejen de funcionar.
echo ""
echo "[3] Verificando CookieProcessor..."
if grep -q "LegacyCookieProcessor" "$CATALINA_BASE/conf/context.xml" 2>/dev/null; then
    echo "  ⚠️  INFO: LegacyCookieProcessor configurado explícitamente"
    echo "  En 8.5 el default es Rfc6265CookieProcessor (más estricto)"
    echo "  Verificar que las cookies de tu app son compatibles con RFC 6265"
else
    echo "  ✅ Sin configuración especial de CookieProcessor"
fi

echo ""
echo "=== Verificación completada ==="
```

## Cambios en server.xml para 8.5

El cambio más visible es la forma de configurar SSL. Aquí está el antes y el después completo:

```xml
<!-- ============================================================ -->
<!-- ANTES (Tomcat 8.0): SSL como atributos directos en Connector -->
<!-- Este formato sigue funcionando en 8.5, pero está deprecado.  -->
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
           sslEnabledProtocols="TLSv1.2"
           ciphers="TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"/>

<!-- ============================================================ -->
<!-- DESPUÉS (Tomcat 8.5+): SSLHostConfig + Certificate           -->
<!-- Ventajas: más claro, permite múltiples certificados por      -->
<!-- dominio (SNI), permite configurar HSTS y más parámetros.     -->
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
    <!-- "TLSv1.2+TLSv1.3" significa: acepta TLS 1.2 o superior.
         Más seguro que listar versiones individuales. -->
    ciphers="TLS_AES_256_GCM_SHA384:ECDHE-RSA-AES256-GCM-SHA384"
    certificateVerification="none">
    <!-- "none": no requerir certificado del cliente (lo normal). -->

    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
      certificateKeystorePassword="changeit"
      certificateKeyAlias="tomcat"
      certificateKeystoreType="JKS"/>
      <!-- JKS es el formato de Java, pero PKCS12 es el estándar moderno.
           Si tienes el certificado en .p12, usar type="PKCS12". -->

  </SSLHostConfig>
</Connector>

<!-- ============================================================ -->
<!-- Cambio de protocolo BIO → NIO                               -->
<!-- ============================================================ -->
<!-- ANTES (Tomcat 8.0 con BIO): -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11BioProtocol" .../>

<!-- DESPUÉS (Tomcat 8.5+): -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol" .../>
<!-- Solo cambia el nombre de la clase. El resto de atributos
     (port, maxThreads, etc.) son los mismos. -->
```

# 3. Migración de Tomcat 8.5 a Tomcat 9.0

## ¿Qué cambia?

La migración más importante de este salto tiene dos aspectos: uno técnico (el BIO se elimina definitivamente) y uno de funcionalidad (se actualiza a Servlet 4.0, que introduce HTTP/2 PushBuilder y otras mejoras). Pero el namespace de las APIs **no cambia**: sigues usando `javax.*`.

| Área                       | Tomcat 8.5                   | Tomcat 9.0                           |
|----------------------------|------------------------------|--------------------------------------|
| Especificación Servlet     | 3.1                          | 4.0                                  |
| Java mínimo                | Java 7                       | **Java 8 obligatorio**               |
| Protocolo BIO              | Deprecado (funciona)         | **ELIMINADO** (no arranca con BIO)   |
| HTTP/2 PushBuilder API     | No disponible                | Disponible (`javax.servlet.http.PushBuilder`) |
| TLS 1.3                    | No disponible                | Disponible si usas JDK 11+           |
| AJP con autenticación      | Opcional                     | **Recomendado** (post-Ghostcat)      |
| Namespace `javax.*`        | ✅ Sí                        | ✅ Sí (sin cambios)                  |

> ⚠️ **El bloqueante principal es el BIO.** Si en tu `server.xml` tienes `Http11BioProtocol`, Tomcat 9 no arrancará. El error en el log será algo como `ClassNotFoundException: Http11BioProtocol`. Asegúrate de cambiar a `Http11NioProtocol` antes de instalar Tomcat 9.

## Checklist de migración 8.5 → 9.0

```bash
#!/bin/bash
# migrate-85-to-90.sh

echo "=== Verificación pre-migración Tomcat 8.5 → 9.0 ==="
echo ""

CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
SERVER_XML="$CATALINA_BASE/conf/server.xml"

# 1. Verificar versión de JDK
# Tomcat 9 requiere Java 8 como mínimo. Si tienes Java 7, Tomcat 9
# no arrancará con un error de UnsupportedClassVersionError.
echo "[1] Verificando versión de JDK..."
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' \
    | cut -d'.' -f1)

if [ "$JAVA_VER" -lt 8 ] 2>/dev/null; then
    echo "  ❌ BLOQUEANTE: JDK $JAVA_VER detectado. Tomcat 9 requiere JDK 8+"
    echo "  Actualizar JDK antes de continuar"
else
    echo "  ✅ JDK $JAVA_VER compatible con Tomcat 9"
fi

# 2. Verificar protocolo BIO
# Este es el bloqueante más frecuente al migrar a Tomcat 9.
# La clase Http11BioProtocol fue completamente eliminada.
echo ""
echo "[2] Verificando protocolo BIO (eliminado en Tomcat 9)..."
if grep -qE "Http11BioProtocol|AjpBioProtocol" "$SERVER_XML" 2>/dev/null; then
    echo "  ❌ BLOQUEANTE: Protocolo BIO detectado — ELIMINADO en Tomcat 9"
    echo "  Cambiar Http11BioProtocol → Http11NioProtocol"
    echo "  Líneas afectadas:"
    grep -n "BioProtocol" "$SERVER_XML" 2>/dev/null \
        | awk '{print "    " $0}'
else
    echo "  ✅ Sin uso de BIO"
fi

# 3. Verificar configuración AJP post-Ghostcat
# La vulnerabilidad Ghostcat (CVE-2020-1938) se descubrió en 2020.
# Las versiones de Tomcat 8.5 y 9.0 posteriores al parche requieren
# que el AJP esté asegurado con un secreto compartido.
echo ""
echo "[3] Verificando conector AJP (vulnerabilidad Ghostcat)..."
if grep -qiE "AJP|ajp" "$SERVER_XML" 2>/dev/null; then
    if ! grep -q 'secretRequired="true"' "$SERVER_XML" 2>/dev/null; then
        echo "  ❌ SEGURIDAD: AJP sin secretRequired=true"
        echo "  Añadir: secretRequired=\"true\" requiredSecret=\"clave-larga-aleatoria\""
        echo "  Ver sección 3.6.5 del Módulo 03 para más detalles"
    else
        echo "  ✅ AJP con secretRequired configurado correctamente"
    fi
else
    echo "  ✅ Sin conector AJP (o deshabilitado)"
fi

# 4. Revisar web.xml de las aplicaciones
# Las aplicaciones con Servlet 3.1 (web.xml version="3.1") funcionan
# sin cambios en Tomcat 9. No hay que tocar web.xml.
echo ""
echo "[4] Revisando web.xml de aplicaciones..."
find "$CATALINA_BASE/webapps" -name "web.xml" 2>/dev/null | while read f; do
    VERSION=$(grep -o 'version="[^"]*"' "$f" 2>/dev/null | head -1)
    APP=$(echo "$f" | sed "s|$CATALINA_BASE/webapps/||" | cut -d'/' -f1)
    echo "  App: $APP → web.xml $VERSION"
    echo "  ✅ Compatible (las apps Servlet 3.1 funcionan en Tomcat 9 sin cambios)"
done

echo ""
echo "=== Verificación completada ==="
```

## Cambios en configuración para Tomcat 9.0

```xml
<!-- ===== 1. AJP con secreto (seguridad post-Ghostcat) ===== -->
<!-- Si usas AJP con Apache httpd, este cambio es obligatorio
     en versiones recientes de Tomcat 9. Si no usas AJP, elimina
     completamente el elemento Connector del AJP. -->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           <!-- Solo acepta conexiones desde la misma máquina -->
           port="8009"
           redirectPort="8443"
           secretRequired="true"
           requiredSecret="${ajp.secret}"
           <!-- El secreto se lee de una propiedad del sistema definida
                en setenv.sh para no tenerlo en texto plano en server.xml -->
           tomcatAuthentication="false"/>
           <!-- Delegar autenticación a Apache httpd -->

<!-- ===== 2. HTTP/2 disponible en Tomcat 9 ===== -->
<!-- Para activar HTTP/2, basta con añadir el UpgradeProtocol dentro
     del Connector HTTPS. Tomcat negocia automáticamente si el cliente
     soporta h2 o HTTP/1.1. No hay que cambiar nada más. -->
<Connector port="8443"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           scheme="https"
           secure="true">

  <!-- Esta línea activa HTTP/2 sobre el conector HTTPS -->
  <UpgradeProtocol
    className="org.apache.coyote.http2.Http2Protocol"
    maxConcurrentStreams="200"/>

  <SSLHostConfig protocols="TLSv1.2+TLSv1.3">
    <Certificate type="RSA"
                 certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.p12"
                 certificateKeystorePassword="${ssl.keystore.password}"
                 certificateKeystoreType="PKCS12"/>
                 <!-- PKCS12 (.p12) es el formato moderno recomendado
                      sobre JKS. Los certificados de Let's Encrypt y la
                      mayoría de CAs modernos se exportan en PKCS12. -->
  </SSLHostConfig>

</Connector>
```

# 4. Migración de Tomcat 9 a Tomcat 10 — El Cambio Crítico

## El cambio más importante en la historia de Tomcat

Este salto es cualitativamente diferente a todos los anteriores. En las migraciones anteriores (8.0→8.5→9.0), el código Java de tu aplicación no necesitaba cambios: solo la configuración del servidor.

En el salto a Tomcat 10, **todas las clases Java de tu aplicación que usen APIs de Servlet, JSP, EL o WebSocket necesitan ser actualizadas**. La razón es el cambio de namespace: el prefijo de todos los paquetes de estas APIs cambia de `javax.*` a `jakarta.*`.

## ¿Por qué ocurrió este cambio?

En 2017, Oracle donó Java EE a la fundación Eclipse. La condición era que Eclipse podía continuar desarrollando la plataforma, pero **no podía usar el nombre "javax"** en nuevos paquetes, porque Oracle retiene la marca registrada de "Java". Como resultado, la fundación Eclipse (que gestiona Jakarta EE, el sucesor de Java EE) tuvo que renombrar todos los paquetes.

## Alcance completo del cambio de namespace

```
APIs que cambian (debes actualizar tu código):
──────────────────────────────────────────────────────────────
  javax.servlet.*            → jakarta.servlet.*
  javax.servlet.http.*       → jakarta.servlet.http.*
  javax.servlet.annotation.* → jakarta.servlet.annotation.*
  javax.servlet.jsp.*        → jakarta.servlet.jsp.*
  javax.el.*                 → jakarta.el.*
  javax.websocket.*          → jakarta.websocket.*
  javax.security.auth.message.* → jakarta.security.auth.message.*

APIs que NO cambian (siguen siendo javax.*):
──────────────────────────────────────────────────────────────
  javax.sql.*       → Java SE (DataSource, Connection, etc.)
  javax.naming.*    → Java SE (JNDI)
  javax.annotation.*→ Java SE desde Java 11
  javax.xml.*       → Java SE (XML)
  javax.crypto.*    → Java SE (criptografía)
  javax.net.ssl.*   → Java SE (TLS/SSL)
```

> 💡 **Regla fácil:** si el paquete es de Java EE / Jakarta EE (Servlet, JSP, WebSocket, JPA, JAX-RS...) cambia de `javax.*` a `jakarta.*`. Si es de Java SE (la plataforma base de Java: JDBC, JNDI, SSL, XML...) **no cambia**.

## Impacto en el código de la aplicación

El cambio es mecánico y consiste exclusivamente en actualizar los imports. La lógica del código no cambia en absoluto. Aquí el mismo filtro Servlet antes y después:

```java
// ================================================================
// ANTES: código para Tomcat 9 (javax.*)
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
        // Obtener el contexto de la aplicación
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

        // Tu lógica de autenticación aquí
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}

// ================================================================
// DESPUÉS: código para Tomcat 10+ (jakarta.*)
// Solo cambian los imports. El código es byte-por-byte idéntico.
// ================================================================

import jakarta.servlet.Filter;               // javax → jakarta
import jakarta.servlet.FilterChain;          // javax → jakarta
import jakarta.servlet.FilterConfig;         // javax → jakarta
import jakarta.servlet.ServletContext;       // javax → jakarta
import jakarta.servlet.ServletException;     // javax → jakarta
import jakarta.servlet.ServletRequest;       // javax → jakarta
import jakarta.servlet.ServletResponse;      // javax → jakarta
import jakarta.servlet.annotation.WebFilter; // javax → jakarta
import jakarta.servlet.http.HttpServletRequest;  // javax → jakarta
import jakarta.servlet.http.HttpServletResponse; // javax → jakarta
import jakarta.servlet.http.HttpSession;         // javax → jakarta

@WebFilter("/*")
public class AuthFilter implements Filter {
    // TODO: el código interno es exactamente el mismo que arriba
    //       No hay que cambiar nada más allá de los imports.
}
```

## Migración automática con la Jakarta EE Migration Tool

Hacer el cambio de imports manualmente en una aplicación grande es tedioso y propenso a errores. Apache proporciona una herramienta oficial que automatiza el proceso:

```bash
# ============================================================
# OPCIÓN A: Migrar el WAR compilado (binario)
# La herramienta modifica los imports en el bytecode Java
# sin necesidad de tener el código fuente.
# Útil si recibes WARs de terceros o no tienes el código fuente.
# ============================================================

# Descargar la herramienta de migración
wget https://github.com/apache/tomcat-jakartaee-migration/releases/download/1.0.6/jakartaee-migration-1.0.6-shaded.jar

# Convertir el WAR: javax → jakarta
# El WAR original no se modifica; se crea uno nuevo.
java -jar jakartaee-migration-1.0.6-shaded.jar \
    myapp-javax.war \    # WAR de entrada (Tomcat 9)
    myapp-jakarta.war    # WAR de salida (Tomcat 10+)

# Verificar que la conversión funcionó
# Buscar si quedan referencias a javax.servlet en el bytecode
unzip -p myapp-jakarta.war \
    WEB-INF/classes/com/miempresa/filter/AuthFilter.class \
    | strings | grep -E "javax|jakarta"
# Debe mostrar solo "jakarta", no "javax"

# ============================================================
# OPCIÓN B: Migrar el código fuente Java (recomendada)
# Permite recompilar con las nuevas dependencias y ejecutar
# los tests antes de desplegar.
# ============================================================

# Actualizar los imports en todos los archivos .java
# Estos comandos usan sed para hacer la sustitución en todos los archivos:

find src/main/java -name "*.java" -exec \
    sed -i 's/import javax\.servlet\./import jakarta.servlet./g' {} \;

find src/main/java -name "*.java" -exec \
    sed -i 's/import javax\.websocket\./import jakarta.websocket./g' {} \;

find src/main/java -name "*.java" -exec \
    sed -i 's/import javax\.el\./import jakarta.el./g' {} \;

# Actualizar el namespace del web.xml
# (ver sección 10.4.4 para los cambios detallados)
find src/main/webapp -name "web.xml" -exec \
    sed -i \
    's|http://xmlns.jcp.org/xml/ns/javaee|https://jakarta.ee/xml/ns/jakartaee|g' \
    {} \;

find src/main/webapp -name "web.xml" -exec \
    sed -i \
    's|http://java.sun.com/xml/ns/javaee|https://jakarta.ee/xml/ns/jakartaee|g' \
    {} \;
```

Actualización del `pom.xml` de Maven para compilar contra las nuevas APIs:

```xml
<!-- pom.xml — Actualizaciones necesarias para Tomcat 10+ -->
<project>
  <dependencies>

    <!-- ANTES: javax.servlet para Tomcat 9 -->
    <!--
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.1</version>
      <scope>provided</scope>
    </dependency>
    -->

    <!-- DESPUÉS: jakarta.servlet para Tomcat 10+ -->
    <!-- "scope=provided" significa que Tomcat ya incluye esta librería;
         no hay que empaquetarla dentro del WAR. -->
    <dependency>
      <groupId>jakarta.servlet</groupId>
      <artifactId>jakarta.servlet-api</artifactId>
      <version>6.0.0</version>   <!-- Para Tomcat 10.1 -->
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
      <!-- Plugin de migración: puede hacer la conversión como parte del build -->
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
              <source>${project.build.directory}/${project.build.finalName}.war</source>
              <destination>${project.build.directory}/${project.build.finalName}-jakarta.war</destination>
              <profile>EE</profile>
            </configuration>
          </execution>
        </executions>
      </plugin>

      <!-- Asegurar que compilamos para la versión correcta de Java -->
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

## Cambios en web.xml para Tomcat 10+

El `web.xml` también tiene que actualizarse: el namespace XML del descriptor cambia junto con los paquetes Java. Si no se actualiza, Tomcat puede rechazar el descriptor o procesarlo incorrectamente:

```xml
<!-- ============================================================ -->
<!-- ANTES: web.xml para Tomcat 9 (javax namespace)              -->
<!-- ============================================================ -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
             http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0"
         metadata-complete="false">
  <!-- El contenido del web.xml (servlets, filtros, etc.) no cambia -->
</web-app>

<!-- ============================================================ -->
<!-- DESPUÉS: web.xml para Tomcat 10.0 (jakarta namespace)       -->
<!-- Solo cambian: el xmlns, el schemaLocation y la version.     -->
<!-- El contenido interno no cambia.                             -->
<!-- ============================================================ -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
             https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
         version="5.0"
         metadata-complete="false">
  <!-- Mismo contenido que antes -->
</web-app>

<!-- Para Tomcat 10.1, la versión del Servlet sube a 6.0: -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
             https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0"
         metadata-complete="false">
  <!-- Mismo contenido que antes -->
</web-app>
```

## Migración de dependencias de terceros

No basta con migrar tu propio código. Las librerías de terceros que incluyes en `WEB-INF/lib/` también deben ser compatibles con jakarta.*. Los frameworks más populares tienen versiones separadas para javax.* y para jakarta.*:

```xml
<!-- pom.xml — Versiones de frameworks compatibles con jakarta.* -->
<dependencies>

  <!--
    Spring Framework:
    - Spring 5.x → usa javax.* → para Tomcat 9
    - Spring 6.x → usa jakarta.* → para Tomcat 10+
    Son versiones mayores incompatibles entre sí. Actualizar Spring
    implica revisar cambios de API entre Spring 5 y Spring 6.
  -->
  <dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>6.1.5</version>  <!-- Spring 6.x para Tomcat 10+ -->
  </dependency>

  <!--
    Hibernate ORM:
    - Hibernate 5.x → usa javax.* → para Tomcat 9
    - Hibernate 6.x → usa jakarta.* → para Tomcat 10+
    También implica cambios de API significativos.
  -->
  <dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>6.4.4.Final</version>  <!-- Hibernate 6.x para Tomcat 10+ -->
  </dependency>

  <!--
    Jersey (JAX-RS / REST APIs):
    - Jersey 2.x → usa javax.* → para Tomcat 9
    - Jersey 3.x → usa jakarta.* → para Tomcat 10+
  -->
  <dependency>
    <groupId>org.glassfish.jersey.containers</groupId>
    <artifactId>jersey-container-servlet</artifactId>
    <version>3.1.5</version>  <!-- Jersey 3.x para Tomcat 10+ -->
  </dependency>

  <!--
    JSF (JavaServer Faces):
    - Mojarra 2.x → javax.* → para Tomcat 9
    - Mojarra 4.x (Jakarta Faces 4.x) → jakarta.* → para Tomcat 10+
  -->
  <dependency>
    <groupId>org.glassfish</groupId>
    <artifactId>jakarta.faces</artifactId>
    <version>4.0.3</version>
  </dependency>

  <!-- Bean Validation (anotaciones @NotNull, @Size, etc.) -->
  <dependency>
    <groupId>jakarta.validation</groupId>
    <artifactId>jakarta.validation-api</artifactId>
    <version>3.0.2</version>
  </dependency>

  <!-- Implementación de Bean Validation (Hibernate Validator) -->
  <dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>8.0.1.Final</version>
  </dependency>

</dependencies>
```

> ⚠️ **La parte más difícil de la migración a Tomcat 10 no suele ser el cambio de `javax.*` a `jakarta.*` en tu propio código (que la herramienta automatiza). La parte difícil es actualizar los frameworks de terceros que también cambian de versión mayor, con sus propios cambios de API. Planifica tiempo suficiente para revisar los breaking changes de cada framework.**

# 5.Migración de Tomcat 10.0 a Tomcat 10.1

## ¿Qué cambia?

Comparado con el salto 9→10, esta migración es mucho más tranquila. No hay cambio de namespace. Los cambios principales son:

| Área                   | Tomcat 10.0            | Tomcat 10.1                    |
|------------------------|------------------------|--------------------------------|
| Especificación Servlet | 5.0                    | 6.0                            |
| JSP Spec               | 3.0                    | 3.1                            |
| EL Spec                | 4.0                    | 5.0                            |
| WebSocket Spec         | 2.0                    | 2.1                            |
| **Java mínimo**        | Java 8                 | **Java 11 obligatorio**        |
| Cookies SameSite       | Disponible             | Mejorado                       |
| HTTP TRACE             | Habilitado por defecto | **Deshabilitado por defecto**  |

El cambio práctico más importante es el **requisito de Java 11**. Si tu servidor tiene Java 8, necesitarás actualizar el JDK antes de instalar Tomcat 10.1.

## Checklist de migración 10.0 → 10.1

```bash
#!/bin/bash
# migrate-100-to-101.sh

echo "=== Verificación pre-migración Tomcat 10.0 → 10.1 ==="
echo ""

# 1. Verificar JDK 11+
echo "[1] Verificando versión de JDK..."
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' \
    | cut -d'.' -f1)

if [ "$JAVA_VER" -lt 11 ] 2>/dev/null; then
    echo "  ❌ BLOQUEANTE: JDK $JAVA_VER detectado. Tomcat 10.1 requiere JDK 11+"
    echo "  Actualizar JDK a 11 o superior antes de instalar Tomcat 10.1"
    echo ""
    echo "  Para instalar Java 17 en Ubuntu:"
    echo "  sudo apt install openjdk-17-jdk"
    echo "  sudo update-alternatives --config java"
else
    echo "  ✅ JDK $JAVA_VER compatible con Tomcat 10.1"
fi

# 2. Verificar compatibilidad de las librerías con Servlet 6.0
# Servlet 6.0 es retrocompatible con 5.0 para la mayoría de casos,
# pero algunas APIs deprecated en 5.0 pueden haber sido eliminadas.
echo ""
echo "[2] Verificando librerías con jakarta.servlet..."
WEBAPPS_DIR="${CATALINA_BASE:-/opt/tomcat}/webapps"

find "$WEBAPPS_DIR" -name "*.jar" 2>/dev/null | while read jar; do
    # Buscar JARs que contienen clases de jakarta.servlet
    if unzip -l "$jar" 2>/dev/null | grep -q "jakarta/servlet"; then
        echo "  JAR con jakarta.servlet: $(basename $jar)"
        echo "  → Verificar compatibilidad con Servlet 6.0"
    fi
done

# 3. Verificar uso de HTTP TRACE
# En Tomcat 10.1, el método HTTP TRACE está deshabilitado por defecto.
# TRACE puede revelar cabeceras de cookies y ser explotado en ataques XST.
# Si alguna aplicación usa TRACE intencionalmente, hay que habilitarlo explícitamente.
echo ""
echo "[3] Verificando uso de HTTP TRACE..."
echo "  INFO: HTTP TRACE está DESHABILITADO por defecto en Tomcat 10.1"
echo "  Si necesitas TRACE, añadir en conf/web.xml:"
echo "    <init-param>"
echo "      <param-name>readonly</param-name>"
echo "      <param-value>false</param-value>"
echo "    </init-param>"

echo ""
echo "=== Verificación completada ==="
```

# 6. Migración de Tomcat 10.1 a Tomcat 11.0

## ¿Qué cambia?

El requisito de **Java 17** es el cambio más impactante. Java 17 es una versión LTS y muy madura, por lo que la actualización del JDK suele ser el trabajo principal de esta migración. El resto de cambios son mejoras y nuevas funcionalidades:

| Área                     | Tomcat 10.1             | Tomcat 11.0                         |
|--------------------------|-------------------------|-------------------------------------|
| Especificación Servlet   | 6.0                     | 6.1                                 |
| **Java mínimo**          | Java 11                 | **Java 17 obligatorio**             |
| Virtual Threads          | No disponible           | ✅ `StandardVirtualThreadExecutor`  |
| OpenSSL via FFM          | No disponible           | ✅ Sin necesidad de librería nativa |
| HTTP TRACE               | Deshabilitado           | Deshabilitado                       |
| TLS 1.0/1.1              | Deshabilitado           | Deshabilitado                       |

## La gran novedad: Virtual Threads

Tomcat 11 con Java 21 permite usar Virtual Threads para procesar peticiones. Esto cambia fundamentalmente la ecuación de escalabilidad:

- **Antes (Platform Threads):** maxThreads=300 significa máximo 300 peticiones simultáneas procesándose. Si cada petición espera 100ms a la BD, tienes 300 hilos del SO bloqueados.
- **Ahora (Virtual Threads):** sin límite práctico. Si cada petición espera 100ms a la BD, ese Virtual Thread se suspende y el SO thread subyacente procesa otro. El servidor puede manejar miles de peticiones simultáneas con los mismos recursos de CPU.

La mejor parte: **el código de tu aplicación no cambia**. Solo hay que cambiar el Executor en server.xml:

```xml
<!-- server.xml — Activar Virtual Threads en Tomcat 11 -->

<!-- ANTES: Executor clásico con Platform Threads -->
<Executor name="tomcatThreadPool"
          namePrefix="catalina-exec-"
          maxThreads="300"
          minSpareThreads="25"
          className="org.apache.catalina.core.StandardThreadExecutor"/>

<!-- DESPUÉS: Virtual Thread Executor (Tomcat 11 + Java 21) -->
<!-- No hay maxThreads: los Virtual Threads son prácticamente ilimitados -->
<Executor name="tomcatThreadPool"
          namePrefix="catalina-exec-"
          className="org.apache.catalina.core.StandardVirtualThreadExecutor"/>

<!-- El Connector usa el mismo executor, sin cambios -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="tomcatThreadPool"
           maxConnections="50000"
           <!-- Con Virtual Threads puedes aumentar maxConnections
                significativamente sin aumentar el consumo de memoria -->
           acceptCount="500"
           connectionTimeout="20000"
           URIEncoding="UTF-8"
           compression="on"
           compressionMinSize="1024"/>
```

```bash
# setenv.sh para Tomcat 11 con Java 21
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

CATALINA_OPTS="$CATALINA_OPTS -Xms2g -Xmx6g"

# ZGC con modo generacional (Java 21+): pausas < 1ms
# Especialmente beneficioso con Virtual Threads que crean muchos
# objetos de vida corta.
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseZGC"
CATALINA_OPTS="$CATALINA_OPTS -XX:+ZGenerational"

# Los Virtual Threads son estables en Java 21 y no necesitan ningún
# flag adicional. Se activan únicamente a través del Executor en server.xml.

CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Europe/Madrid"

export CATALINA_OPTS
```

# 7. Estrategias de Migración en Producción

## ¿Por qué no actualizar directamente?

Actualizar Tomcat directamente en el servidor de producción "apagando uno y arrancando el otro" es técnicamente posible pero muy arriesgado:

- Si algo falla, hay un período de servicio interrumpido mientras haces el rollback
- No puedes probar la nueva versión con tráfico real antes de hacer el switchover completo
- Si hay un problema sutil (una funcionalidad que falla solo bajo cierta carga), no lo detectas hasta que ya es demasiado tarde

Las estrategias profesionales permiten **hacer la migración sin downtime** y con la posibilidad de revertir en segundos si algo falla.

## Estrategia Blue-Green Deployment

La idea es sencilla: tienes dos entornos idénticos. El "Blue" es el actual (producción). Instalas la nueva versión en el "Green" (preparación). Cuando el Green está listo y verificado, cambias el balanceador de carga para que apunte al Green. El Blue queda en standby. Si algo falla, cambias el balanceador de vuelta al Blue en segundos.

```bash
#!/bin/bash
# blue-green-migration.sh
# Migración sin downtime usando entornos Blue y Green

set -euo pipefail

# Ajustar estas rutas a tu infraestructura
BLUE_TOMCAT="/opt/tomcat-blue"    # Versión actual (ej: Tomcat 9)
GREEN_TOMCAT="/opt/tomcat-green"  # Nueva versión (ej: Tomcat 10.1)
LB_CONFIG="/etc/nginx/conf.d/app.conf"
APP_WAR="myapp-jakarta.war"
HEALTH_URL_GREEN="http://localhost:8090/myapp/health"

echo "=== Migración Blue-Green ==="
echo "Blue (activo):  $BLUE_TOMCAT"
echo "Green (nuevo):  $GREEN_TOMCAT"
echo ""

# ============================================================
# FASE 1: Preparar el entorno Green (la nueva versión)
# ============================================================
echo "--- FASE 1: Preparando entorno Green ---"

# Instalar la nueva versión de Tomcat si no está instalada
if [ ! -d "$GREEN_TOMCAT" ]; then
    echo "Instalando Tomcat 10.1 en $GREEN_TOMCAT..."
    tar -xzf /tmp/apache-tomcat-10.1.20.tar.gz -C /opt
    ln -s /opt/apache-tomcat-10.1.20 "$GREEN_TOMCAT"
fi

# Copiar la configuración del Blue como punto de partida
cp -r "$BLUE_TOMCAT/conf/"* "$GREEN_TOMCAT/conf/"
# Luego aplicar los cambios específicos de la nueva versión
# (AJP secrets, SSLHostConfig, namespace en web.xml, etc.)

# El Green usa el puerto 8090 (diferente al Blue que usa 8080)
# Cambiar en $GREEN_TOMCAT/conf/server.xml:
# port="8080" → port="8090" para el Connector HTTP

# Desplegar el WAR ya migrado a jakarta.*
cp "/opt/releases/$APP_WAR" "$GREEN_TOMCAT/webapps/myapp.war"
echo "Configuración y WAR copiados"

# ============================================================
# FASE 2: Arrancar el entorno Green y esperar que esté listo
# ============================================================
echo ""
echo "--- FASE 2: Arrancando entorno Green (puerto 8090) ---"

export CATALINA_HOME="$GREEN_TOMCAT"
export CATALINA_BASE="$GREEN_TOMCAT"
export CATALINA_PID="$GREEN_TOMCAT/temp/tomcat.pid"

"$GREEN_TOMCAT/bin/startup.sh"

# Esperar hasta 2 minutos a que el Green responda
echo "Esperando disponibilidad de Green..."
MAX_WAIT=120
WAITED=0

until curl -sf "$HEALTH_URL_GREEN" >/dev/null 2>&1; do
    sleep 2
    WAITED=$((WAITED + 2))
    if [ $WAITED -ge $MAX_WAIT ]; then
        echo "❌ Green no disponible tras ${MAX_WAIT}s. Abortando."
        "$GREEN_TOMCAT/bin/shutdown.sh" 30 -force
        exit 1
    fi
    echo -n "."
done

echo ""
echo "✅ Green disponible tras ${WAITED}s"

# ============================================================
# FASE 3: Smoke tests — verificar funcionalidad básica
# ============================================================
echo ""
echo "--- FASE 3: Smoke Tests en Green ---"

# Función auxiliar para cada test
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

# Verificar las URLs más críticas de la aplicación
run_test "http://localhost:8090/myapp/health"     "200" || TESTS_PASSED=false
run_test "http://localhost:8090/myapp/api/status" "200" || TESTS_PASSED=false
run_test "http://localhost:8090/myapp/login.html" "200" || TESTS_PASSED=false

if ! $TESTS_PASSED; then
    echo "❌ Smoke tests fallaron. Manteniendo Blue activo. Investigar el Green."
    "$GREEN_TOMCAT/bin/shutdown.sh" 30 -force
    exit 1
fi

echo "✅ Todos los smoke tests pasaron"

# ============================================================
# FASE 4: Switchover — redirigir el tráfico al Green
# ============================================================
echo ""
echo "--- FASE 4: Switchover del Load Balancer ---"
echo "El balanceador apuntará ahora al Green (nueva versión)"

# Guardar backup de la configuración actual de Nginx
cp "$LB_CONFIG" "${LB_CONFIG}.bak"

# Actualizar Nginx para que dirija al Green
cat > "$LB_CONFIG" << 'NGINX'
upstream tomcat_backend {
    server 127.0.0.1:8090;  # Green (nueva versión — ACTIVO)
    # server 127.0.0.1:8080;  # Blue (versión anterior — EN STANDBY)
}

server {
    listen 443 ssl http2;
    server_name app.miempresa.com;
    # (resto de configuración igual)
    location / {
        proxy_pass http://tomcat_backend;
    }
}
NGINX

# Recargar Nginx sin interrumpir las conexiones activas
nginx -t && nginx -s reload
echo "✅ Nginx recargado — tráfico dirigido al Green"

# ============================================================
# FASE 5: Monitorización — observar el Green durante 5 minutos
# ============================================================
echo ""
echo "--- FASE 5: Monitorización post-switchover (5 minutos) ---"
echo "Observando el Green bajo tráfico real..."
sleep 300

if curl -sf "$HEALTH_URL_GREEN" >/dev/null 2>&1; then
    echo "✅ Green estable tras 5 minutos de tráfico real"
else
    echo "❌ Green con problemas. Ejecutar rollback:"
    echo "  cp ${LB_CONFIG}.bak $LB_CONFIG && nginx -s reload"
    exit 1
fi

# ============================================================
# FASE 6: Drenar el Blue y apagarlo
# ============================================================
echo ""
echo "--- FASE 6: Drenado del Blue ---"
echo "Esperando que las sesiones activas del Blue expiren..."
# Las sesiones HTTP tienen un timeout (session-timeout en web.xml).
# Esperamos ese tiempo para que los usuarios que estaban en Blue
# terminen sus sesiones de forma natural.
sleep 600   # 10 minutos — ajustar según el session-timeout de la app

echo "Apagando Blue (versión anterior)..."
CATALINA_HOME="$BLUE_TOMCAT" \
CATALINA_BASE="$BLUE_TOMCAT" \
"$BLUE_TOMCAT/bin/shutdown.sh" 30 -force

echo ""
echo "=== Migración Blue-Green COMPLETADA ==="
echo "Nueva versión activa: $GREEN_TOMCAT"
echo "El Blue queda en $BLUE_TOMCAT para rollback si es necesario"
```

## Estrategia Canary Release

En lugar de hacer el switchover completo de golpe, el Canary Release envía un pequeño porcentaje del tráfico (por ejemplo, el 5% o el 10%) a la nueva versión mientras el 90-95% restante sigue en la versión antigua. Esto permite detectar problemas con tráfico real pero con impacto limitado:

```bash
#!/bin/bash
# canary-migration.sh
# Enviar X% del tráfico a la nueva versión, el resto a la antigua
# Uso: ./canary-migration.sh 10   (10% al canary)

NGINX_CONF="/etc/nginx/conf.d/app.conf"
CANARY_WEIGHT="${1:-10}"       # % de tráfico a la nueva versión
STABLE_WEIGHT=$((100 - CANARY_WEIGHT))  # % restante a la antigua

echo "=== Canary Release ==="
echo "Estable (Tomcat 9):  ${STABLE_WEIGHT}% del tráfico"
echo "Canary (Tomcat 10.1): ${CANARY_WEIGHT}% del tráfico"

cat > "$NGINX_CONF" << NGINX
# Tráfico dividido: ${STABLE_WEIGHT}% → Tomcat 9 | ${CANARY_WEIGHT}% → Tomcat 10.1

upstream tomcat_stable {
    server 127.0.0.1:8080 weight=${STABLE_WEIGHT};
    # Tomcat 9 — versión actual en producción
}

upstream tomcat_canary {
    server 127.0.0.1:8090 weight=${CANARY_WEIGHT};
    # Tomcat 10.1 — nueva versión siendo validada
}

# Si el usuario tiene una cookie "canary=true", siempre va al canary.
# Útil para que el equipo de QA y early adopters siempre usen la nueva versión.
map \$http_cookie \$backend {
    default         "tomcat_stable";
    "~*canary=true" "tomcat_canary";
}

# Para usuarios sin cookie, distribuir por peso aleatorio
split_clients "\${remote_addr}\${http_user_agent}" \$weight_backend {
    ${CANARY_WEIGHT}%  "tomcat_canary";
    *                  "tomcat_stable";
}

server {
    listen 443 ssl http2;
    server_name app.miempresa.com;

    location / {
        # Si tiene cookie de canary, usarla. Si no, usar la distribución por peso.
        set \$target \$backend;
        if (\$target = "tomcat_stable") {
            set \$target \$weight_backend;
        }

        proxy_pass         http://\$target;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;

        # Esta cabecera en la respuesta indica qué versión sirvió la petición.
        # Útil para debuggear y para verificar que el split funciona correctamente.
        add_header X-Served-By \$target always;
    }
}
NGINX

nginx -t && nginx -s reload
echo "✅ Canary activo: ${CANARY_WEIGHT}% de las peticiones van a Tomcat 10.1"
echo ""
echo "Para aumentar el canary al 50%: ./canary-migration.sh 50"
echo "Para completar la migración:    ./canary-migration.sh 100"
echo "Para rollback:                  ./canary-migration.sh 0"
```

# 8. Script de Migración Integral

Este script analiza una instalación Tomcat existente y genera un informe completo de qué hay que hacer antes de migrar a la versión objetivo:

```bash
#!/bin/bash
# tomcat-migration-advisor.sh
# Analiza la instalación actual y genera un plan de migración

set -euo pipefail

CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"
TARGET_VERSION="${1:-10.1}"    # Versión a la que quieres migrar
SERVER_XML="$CATALINA_BASE/conf/server.xml"
WEBAPPS_DIR="$CATALINA_BASE/webapps"

ISSUES=0    # Problemas bloqueantes: DEBEN resolverse antes de migrar
WARNINGS=0  # Advertencias: deben revisarse, pueden ser aceptables
INFO=0      # Información: no requieren acción pero son útiles de saber

# Funciones de logging con formato consistente
issue()   { echo "  ❌ ISSUE:  $1"; ISSUES=$((ISSUES+1)); }
warning() { echo "  ⚠️  WARN:  $1"; WARNINGS=$((WARNINGS+1)); }
info()    { echo "  ℹ️  INFO:  $1"; INFO=$((INFO+1)); }
ok()      { echo "  ✅ OK:    $1"; }

echo "╔══════════════════════════════════════════════════════════╗"
echo "║     Tomcat Migration Advisor                             ║"
echo "║     Destino: Tomcat $TARGET_VERSION                      "
echo "║     Base: $CATALINA_BASE                                 "
echo "║     $(date)                                              "
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Detectar la versión actual de Tomcat instalada
CURRENT_VERSION=$("$CATALINA_BASE/bin/version.sh" 2>/dev/null \
    | grep "Server version" | grep -o '[0-9]\+\.[0-9]\+' | head -1 \
    || echo "desconocida")
echo "Versión actual: Tomcat $CURRENT_VERSION"
echo "Versión destino: Tomcat $TARGET_VERSION"
echo ""

# ===== Análisis de server.xml =====
echo "━━━ Análisis de server.xml ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Protocolo BIO — eliminado en Tomcat 9
if grep -qE "Http11BioProtocol|AjpBioProtocol" "$SERVER_XML" 2>/dev/null; then
    issue "Protocolo BIO encontrado — ELIMINADO en Tomcat 9+"
    echo "         Acción: cambiar a Http11NioProtocol en server.xml"
else
    ok "Sin protocolo BIO"
fi

# AJP sin autenticación — vulnerabilidad Ghostcat
if grep -qE "AJP|ajp" "$SERVER_XML" 2>/dev/null; then
    if ! grep -q 'secretRequired="true"' "$SERVER_XML" 2>/dev/null; then
        issue "Conector AJP sin secretRequired=true — vulnerable a Ghostcat CVE-2020-1938"
        echo "         Acción: añadir secretRequired='true' y requiredSecret='<clave>' en el conector AJP"
    else
        ok "AJP con secretRequired=true configurado"
    fi
fi

# Formato SSL
if grep -q 'SSLEnabled="true"' "$SERVER_XML" 2>/dev/null; then
    if grep -q "SSLHostConfig" "$SERVER_XML" 2>/dev/null; then
        ok "SSL con SSLHostConfig (formato actual)"
    else
        warning "SSL con atributos directos en Connector — deprecado desde Tomcat 8.5"
        echo "         Acción recomendada: migrar a SSLHostConfig + Certificate"
    fi
fi

# Puerto de shutdown habilitado
if grep -q 'port="-1"' "$SERVER_XML" 2>/dev/null; then
    ok "Puerto de shutdown deshabilitado (seguro)"
else
    warning "Puerto de shutdown habilitado — se recomienda deshabilitar en producción"
    echo "         Acción: cambiar <Server port='8005'...> por <Server port='-1'...>"
fi

# ===== Análisis del JDK =====
echo ""
echo "━━━ Análisis del JDK ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' \
    | sed 's/^1\.//' | cut -d'.' -f1)

echo "  JDK actual: Java $JAVA_VER"

# Determinar el JDK mínimo requerido para la versión destino
case "$TARGET_VERSION" in
    "8.5") MIN_JAVA=7 ;;
    "9.0") MIN_JAVA=8 ;;
    "10.0") MIN_JAVA=8 ;;
    "10.1") MIN_JAVA=11 ;;
    "11.0") MIN_JAVA=17 ;;
    *) MIN_JAVA=11 ;;
esac

if [ "$JAVA_VER" -ge "$MIN_JAVA" ] 2>/dev/null; then
    ok "JDK $JAVA_VER es suficiente para Tomcat $TARGET_VERSION (mínimo: Java $MIN_JAVA)"
else
    issue "JDK $JAVA_VER es insuficiente para Tomcat $TARGET_VERSION (requiere Java $MIN_JAVA+)"
    echo "         Acción: actualizar JDK antes de instalar Tomcat $TARGET_VERSION"
fi

# ===== Análisis del namespace (solo para migraciones a Tomcat 10+) =====
if [[ "$TARGET_VERSION" == "10"* ]] || [[ "$TARGET_VERSION" == "11"* ]]; then
    echo ""
    echo "━━━ Análisis de Namespace javax.* → jakarta.* ━━━━━━━━━━"
    echo "  (Solo relevante para migraciones a Tomcat 10+)"

    # Buscar archivos Java fuente con imports de javax.servlet
    JAVAX_IN_SRC=$(find "$WEBAPPS_DIR" -name "*.java" 2>/dev/null \
        | xargs grep -l "import javax.servlet" 2>/dev/null | wc -l || echo 0)

    if [ "$JAVAX_IN_SRC" -gt 0 ] 2>/dev/null; then
        issue "Encontrados $JAVAX_IN_SRC archivos .java con 'import javax.servlet.*'"
        echo "         Acción: ejecutar jakartaee-migration-tool o actualizar imports manualmente"
    fi

    # Verificar el namespace del web.xml de cada aplicación
    find "$WEBAPPS_DIR" -name "web.xml" 2>/dev/null | while read webxml; do
        APP=$(echo "$webxml" | sed "s|$WEBAPPS_DIR/||" | cut -d'/' -f1)
        if grep -q "xmlns.jcp.org\|java.sun.com" "$webxml" 2>/dev/null; then
            issue "web.xml de '$APP' usa namespace javax — requiere actualización"
            echo "         Acción: cambiar xmlns a https://jakarta.ee/xml/ns/jakartaee"
        else
            ok "web.xml de '$APP' — namespace correcto (jakarta)"
        fi
    done

    # Detectar librerías de terceros incompatibles con jakarta.*
    find "$WEBAPPS_DIR" -path "*/WEB-INF/lib/*.jar" 2>/dev/null | while read jar; do
        JAR_NAME=$(basename "$jar")
        APP=$(echo "$jar" | sed "s|$WEBAPPS_DIR/||" | cut -d'/' -f1)

        # Spring 5.x es incompatible con jakarta.* (requiere Spring 6.x)
        if echo "$JAR_NAME" | grep -qi "spring-webmvc-5\|spring-web-5"; then
            issue "[$APP] Spring 5.x detectado — incompatible con jakarta.*"
            echo "         Acción: actualizar a Spring 6.x"
        fi

        # Hibernate 5.x es incompatible con jakarta.* (requiere Hibernate 6.x)
        if echo "$JAR_NAME" | grep -qi "hibernate-core-5"; then
            issue "[$APP] Hibernate 5.x detectado — incompatible con jakarta.*"
            echo "         Acción: actualizar a Hibernate 6.x"
        fi

        # Jersey 2.x puede necesitar actualización a Jersey 3.x
        if echo "$JAR_NAME" | grep -qi "jersey.*2\.[0-9]"; then
            warning "[$APP] Jersey 2.x detectado — verificar compatibilidad con jakarta.*"
            echo "         Acción recomendada: actualizar a Jersey 3.x"
        fi
    done
fi

# ===== Análisis de aplicaciones =====
echo ""
echo "━━━ Análisis de Aplicaciones ━━━━━━━━━━━━━━━━━━━━━━━━━━"

for APP_DIR in "$WEBAPPS_DIR"/*/; do
    APP_NAME=$(basename "$APP_DIR")
    # Ignorar aplicaciones de administración de Tomcat
    [ "$APP_NAME" = "manager" ] && continue
    [ "$APP_NAME" = "host-manager" ] && continue
    [ "$APP_NAME" = "docs" ] && continue
    [ "$APP_NAME" = "examples" ] && continue

    echo "  Aplicación: $APP_NAME"

    # Verificar si la app tiene descriptor de sesión distribuible
    # (necesario para clustering)
    WEB_XML="$APP_DIR/WEB-INF/web.xml"
    if [ -f "$WEB_XML" ]; then
        if grep -q "<distributable" "$WEB_XML" 2>/dev/null; then
            ok "  $APP_NAME: <distributable/> presente (apta para clúster)"
        else
            info "  $APP_NAME: sin <distributable/> — sesiones no se replican en clúster"
        fi
    fi

    # Verificar si tiene descriptor de contexto externo (recomendado)
    CONTEXT_DESC="$CATALINA_BASE/conf/Catalina/localhost/${APP_NAME}.xml"
    if [ -f "$CONTEXT_DESC" ]; then
        ok "  $APP_NAME: descriptor de contexto externo encontrado"
    else
        info "  $APP_NAME: sin descriptor externo — usando META-INF/context.xml del WAR"
    fi
done

# ===== Resumen y plan de acción =====
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                    Resumen del Análisis                  ║"
echo "╠══════════════════════════════════════════════════════════╣"
printf "║  Issues críticos:   %d (deben resolverse antes de migrar)\n" $ISSUES
printf "║  Advertencias:      %d (revisar antes de migrar)          \n" $WARNINGS
printf "║  Informativos:      %d (no requieren acción)              \n" $INFO
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
echo "║  1. Resolver todos los issues críticos (❌)              ║"
echo "║  2. Actualizar JDK al mínimo requerido si aplica         ║"
echo "║  3. Ejecutar jakartaee-migration-tool (si va a T10+)     ║"
echo "║  4. Actualizar librerías de terceros incompatibles       ║"
echo "║  5. Probar toda la funcionalidad en staging              ║"
echo "║  6. Ejecutar tests de regresión completos                ║"
echo "║  7. Migrar con Blue-Green en producción                  ║"
echo "╚══════════════════════════════════════════════════════════╝"

# El script retorna 1 si hay issues bloqueantes,
# para que pueda usarse en pipelines de CI/CD
[ $ISSUES -gt 0 ] && exit 1 || exit 0
```

# 9. Tabla Maestra de Cambios por Versión

Esta tabla consolida todos los cambios importantes de configuración a lo largo de las versiones, útil como referencia rápida cuando necesitas saber exactamente cuándo apareció o desapareció una funcionalidad:

| Configuración / Funcionalidad               | 8.0  | 8.5     | 9.0    | 10.0  | 10.1  | 11.0  |
|---------------------------------------------|------|---------|--------|-------|-------|-------|
| Protocolo HTTP BIO                          | ✅   | ⚠️ Dep. | ❌ Elim.| ❌    | ❌    | ❌    |
| Protocolo HTTP NIO                          | ✅   | ✅      | ✅     | ✅    | ✅    | ✅    |
| HTTP/2 (UpgradeProtocol)                    | ❌   | ✅      | ✅     | ✅    | ✅    | ✅    |
| SSLHostConfig + Certificate                 | ❌   | ✅      | ✅     | ✅    | ✅    | ✅    |
| TLS 1.3                                     | ❌   | ❌      | ✅ *   | ✅ *  | ✅    | ✅    |
| CredentialHandler (PBKDF2, SHA-256)         | ❌   | ✅      | ✅     | ✅    | ✅    | ✅    |
| AJP secretRequired (post-Ghostcat)          | ❌   | ✅ **   | ✅ **  | ✅    | ✅    | ✅    |
| Namespace `javax.servlet.*`                 | ✅   | ✅      | ✅     | ❌    | ❌    | ❌    |
| Namespace `jakarta.servlet.*`               | ❌   | ❌      | ❌     | ✅    | ✅    | ✅    |
| Servlet 4.0 (PushBuilder javax.*)           | ❌   | ❌      | ✅     | ❌    | ❌    | ❌    |
| Servlet 5.0 (PushBuilder jakarta.*)         | ❌   | ❌      | ❌     | ✅    | ❌    | ❌    |
| Servlet 6.0                                 | ❌   | ❌      | ❌     | ❌    | ✅    | ❌    |
| Servlet 6.1                                 | ❌   | ❌      | ❌     | ❌    | ❌    | ✅    |
| **Java mínimo requerido**                   | **7**| **7**   | **8**  | **8** | **11**| **17**|
| Virtual Threads (StandardVirtualThreadExec.)| ❌   | ❌      | ❌     | ❌    | ❌    | ✅    |
| OpenSSL via FFM (sin librería nativa)       | ❌   | ❌      | ❌     | ❌    | ❌    | ✅    |
| HTTP TRACE deshabilitado por defecto        | ❌   | ❌      | ❌     | ❌    | ✅    | ✅    |
| TLS 1.0/1.1 deshabilitado por defecto       | ❌   | ❌      | ❌     | ✅    | ✅    | ✅    |
| Generational ZGC (Java 21)                  | ❌   | ❌      | ❌     | ❌    | ❌    | ✅    |
| AsyncFileHandler JULI (logs asíncronos)     | ❌   | ✅      | ✅     | ✅    | ✅    | ✅    |
| SameSite cookies                            | ❌   | ✅      | ✅     | ✅    | ✅    | ✅    |
| Rfc6265CookieProcessor por defecto          | ❌   | ✅      | ✅     | ✅    | ✅    | ✅    |

*Requiere JDK 11+
**Disponible en versiones de parche posteriores a la corrección de Ghostcat (8.5.51+, 9.0.31+)

# 10. Guía de Rollback de Emergencia

## ¿Qué es un rollback y cuándo ejecutarlo?

Un rollback es volver a la versión anterior cuando la nueva versión tiene un problema grave que no puedes resolver rápidamente. Los criterios para decidir hacer rollback son:

- Tasa de errores HTTP (5xx) significativamente más alta que antes
- Tiempo de respuesta mucho mayor que antes
- Funcionalidad crítica del negocio rota
- Problemas de seguridad detectados en la nueva versión

El rollback debe estar siempre preparado y probado **antes** de hacer la migración. Si no tienes un plan de rollback documentado y probado, no deberías migrar en producción.

```bash
#!/bin/bash
# rollback-tomcat.sh
# Volver a la versión anterior en caso de emergencia
# Uso: ./rollback-tomcat.sh [directorio_version_anterior] [directorio_actual] [config_nginx]

set -euo pipefail

PREVIOUS_TOMCAT="${1:-/opt/tomcat-previous}"  # Directorio del Tomcat anterior
CURRENT_TOMCAT="${2:-/opt/tomcat}"            # Directorio del Tomcat actual
LB_CONFIG="${3:-/etc/nginx/conf.d/app.conf}"  # Configuración del balanceador
BACKUP_LB="${LB_CONFIG}.bak"

echo "=== ROLLBACK DE EMERGENCIA ==="
echo "Timestamp: $(date)"
echo "Volviendo de: $CURRENT_TOMCAT"
echo "Volviendo a:  $PREVIOUS_TOMCAT"
echo ""

# 1. Verificar que la versión anterior existe
if [ ! -d "$PREVIOUS_TOMCAT" ]; then
    echo "❌ CRÍTICO: El directorio $PREVIOUS_TOMCAT no existe"
    echo "   No es posible hacer rollback automático"
    echo "   Acción manual requerida"
    exit 1
fi

# 2. Parar la versión actual
echo "Parando la versión actual..."
if [ -f "$CURRENT_TOMCAT/temp/tomcat.pid" ]; then
    CURRENT_PID=$(cat "$CURRENT_TOMCAT/temp/tomcat.pid")
    # Intentar parada limpia primero (15 segundos de gracia)
    "$CURRENT_TOMCAT/bin/shutdown.sh" 15 -force 2>/dev/null || true
    sleep 5
    # Si sigue corriendo, forzar la parada
    kill -9 "$CURRENT_PID" 2>/dev/null || true
fi
echo "✅ Versión actual parada"

# 3. Arrancar la versión anterior
echo "Arrancando versión anterior..."
export CATALINA_HOME="$PREVIOUS_TOMCAT"
export CATALINA_BASE="$PREVIOUS_TOMCAT"
"$PREVIOUS_TOMCAT/bin/startup.sh"

# 4. Esperar a que la versión anterior esté disponible
echo "Esperando disponibilidad de la versión anterior..."
for i in $(seq 1 30); do
    if curl -sf "http://localhost:8080/health" >/dev/null 2>&1; then
        echo "✅ Versión anterior disponible"
        break
    fi
    sleep 2
    if [ $i -eq 30 ]; then
        echo "❌ La versión anterior tampoco responde. Requiere intervención manual."
    fi
done

# 5. Restaurar la configuración del balanceador de carga
if [ -f "$BACKUP_LB" ]; then
    cp "$BACKUP_LB" "$LB_CONFIG"
    nginx -t && nginx -s reload
    echo "✅ Balanceador de carga restaurado desde backup"
else
    echo "⚠️  No hay backup del balanceador — configurar manualmente"
    echo "   El tráfico puede seguir yendo a la versión nueva (que está parada)"
fi

# 6. Registrar el rollback para auditoría
echo "$(date): ROLLBACK ejecutado — de $CURRENT_TOMCAT a $PREVIOUS_TOMCAT" \
    >> /var/log/tomcat-migrations.log

echo ""
echo "=== ROLLBACK COMPLETADO ==="
echo "Acciones inmediatas recomendadas:"
echo "  1. Verificar que la aplicación funciona correctamente"
echo "  2. Notificar al equipo de operaciones y al equipo de desarrollo"
echo "  3. Revisar los logs de la versión nueva para entender el fallo:"
echo "     tail -100 $CURRENT_TOMCAT/logs/catalina.out"
echo "  4. No eliminar $CURRENT_TOMCAT hasta entender la causa del fallo"
```
# 11. Puntos Clave

- El cambio más crítico en la historia de Tomcat es el **cambio de namespace `javax.*` → `jakarta.*`** en Tomcat 10. Todas las aplicaciones que usan APIs Servlet, JSP, EL o WebSocket deben migrar sus imports o convertirse con la Migration Tool. Es un trabajo que se hace una vez y no hay que repetirlo.

- La migración **8.0 → 8.5** es la más sencilla: el único cambio impactante es la deprecación del BIO (que en 8.5 aún funciona pero con aviso) y el nuevo formato SSL con `SSLHostConfig`. La mayoría de apps no necesitan ningún cambio.

- La migración **8.5 → 9.0** tiene un bloqueante muy concreto: el BIO está **eliminado**. Si tu `server.xml` tiene `Http11BioProtocol`, Tomcat 9 no arrancará. Es el primer cambio que hay que verificar.

- La migración **9 → 10** requiere actualizar el código Java de la aplicación (cambio de `javax.*` a `jakarta.*`) o usar la Jakarta EE Migration Tool. También hay que actualizar las librerías de terceros (Spring, Hibernate, Jersey) a sus versiones compatibles con jakarta.

- Las migraciones **10.0 → 10.1** y **10.1 → 11.0** no tienen cambio de namespace pero sí requieren actualizar el JDK mínimo (Java 11 y Java 17 respectivamente). Verificar siempre el JDK antes de instalar.

- **Tomcat 11 con Java 21** introduce Virtual Threads que eliminan el límite práctico de `maxThreads` para cargas I/O-bound. El cambio en `server.xml` es mínimo: cambiar `StandardThreadExecutor` por `StandardVirtualThreadExecutor`. El código de la aplicación no cambia.

- Usar siempre la estrategia **Blue-Green o Canary** para migraciones en producción. Nunca reemplazar directamente el Tomcat activo sin tener la versión anterior disponible para rollback inmediato.

- El **script de Migration Advisor** debe ejecutarse antes de cualquier migración para identificar todos los issues bloqueantes. Ningún issue bloqueante sin resolver debe llegar a producción.

- Tener siempre un **plan de rollback documentado, con el script preparado y probado** antes de ejecutar la migración. Si el rollback no se ha probado nunca, no existe.

- Las librerías de terceros más comunes (**Spring, Hibernate, Jersey, JSF**) tienen versiones diferentes para `javax.*` y `jakarta.*`. Actualizar ambas en paralelo con la migración de Tomcat: Spring 5→6, Hibernate 5→6, Jersey 2→3.
ENDOFFILE
Salida

exit code 0
Listo
