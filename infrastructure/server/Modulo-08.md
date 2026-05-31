## Módulo 08: Clustering y Sesiones Distribuidas

## 8.1 Arquitectura de Clustering en Tomcat

Tomcat implementa clustering mediante el subsistema **Tribes**, un framework de comunicación en grupo que soporta mensajería multicast y unicast entre nodos. El clustering en Tomcat abarca dos responsabilidades principales:

1. **Replicación de sesiones HTTP** entre nodos del cluster.
2. **Despliegue distribuido** de aplicaciones en todos los nodos.

```
                    ┌─────────────────────────────────────┐
                    │         Load Balancer               │
                    │   (Apache httpd / Nginx / HAProxy)  │
                    │                                     │
                    │  Sticky Sessions: JSESSIONID.nodeN  │
                    └──────────┬──────────────┬───────────┘
                               │              │
                   ┌───────────▼──┐    ┌──────▼───────────┐
                   │  Tomcat      │    │  Tomcat           │
                   │  node01      │◄──►│  node02           │
                   │  :8080       │    │  :8080            │
                   │              │    │                   │
                   │  jvmRoute=   │    │  jvmRoute=        │
                   │  node01      │    │  node02           │
                   └──────┬───────┘    └──────┬────────────┘
                          │    Tribes         │
                          │  (Multicast/      │
                          │   Unicast)        │
                   ┌──────▼───────────────────▼────────────┐
                   │       Sesiones Replicadas              │
                   │    (DeltaManager / BackupManager)      │
                   └───────────────────────────────────────┘
```

### 8.1.1 Modos de replicación de sesiones

| Modo             | Descripción                                              | Nodos afectados  | Uso recomendado        |
|------------------|----------------------------------------------------------|------------------|------------------------|
| `DeltaManager`   | Replica los **cambios** (deltas) a TODOS los nodos       | Todos (all-to-all)| Clusters pequeños ≤6  |
| `BackupManager`  | Replica la sesión completa a UN nodo de backup           | 1 nodo backup    | Clusters grandes       |
| `PersistentManager` + Store | Persiste sesiones en BD o filesystem        | Ninguno (externo)| Clusters muy grandes   |
| Redis/Memcached  | Sesiones en almacén externo compartido                   | Ninguno (externo)| Microservicios / Cloud |

---

## 8.2 Configuración del Cluster con DeltaManager

### 8.2.1 Configuración completa en server.xml — Nodo 1

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Server port="-1" shutdown="SHUTDOWN">

  <Listener className="org.apache.catalina.startup.VersionLoggerListener"/>
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on"/>
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"/>
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

  <GlobalNamingResources>
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" readonly="true"/>
  </GlobalNamingResources>

  <Service name="Catalina">

    <Executor name="tomcatThreadPool"
              namePrefix="catalina-exec-"
              maxThreads="400"
              minSpareThreads="25"/>

    <Connector port="8080"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               executor="tomcatThreadPool"
               connectionTimeout="20000"
               redirectPort="8443"
               URIEncoding="UTF-8"/>

    <!-- AJP para comunicación con Apache httpd (balanceador) -->
    <Connector protocol="AJP/1.3"
               address="127.0.0.1"
               port="8009"
               redirectPort="8443"
               secretRequired="true"
               requiredSecret="${ajp.secret}"
               tomcatAuthentication="false"/>

    <Engine name="Catalina"
            defaultHost="localhost"
            jvmRoute="node01">

      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>

      <!-- ============================================================ -->
      <!-- CLUSTER CONFIGURATION                                        -->
      <!-- ============================================================ -->
      <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
               channelSendOptions="8"
               channelStartOptions="3">

        <!--
          Manager: gestiona la replicación de sesiones.
          DeltaManager: replica solo los cambios de sesión (delta)
          a todos los nodos del cluster.
        -->
        <Manager className="org.apache.catalina.ha.session.DeltaManager"
                 expireSessionsOnShutdown="false"
                 notifyListenersOnReplication="true"
                 stateTransferTimeout="60"
                 sendAllSessions="false"
                 maxInactiveInterval="1800"
                 sessionIdLength="32"/>

        <!--
          Channel: capa de comunicación del cluster.
          Usa el framework Tribes internamente.
        -->
        <Channel className="org.apache.catalina.tribes.group.GroupChannel">

          <!--
            MembershipService: descubrimiento de nodos del cluster.
            Multicast: los nodos se anuncian en la dirección multicast.
            Todos los nodos del cluster DEBEN usar la misma dirección
            y puerto multicast.
          -->
          <Membership
            className="org.apache.catalina.tribes.membership.McastService"
            address="228.0.0.4"
            port="45564"
            frequency="500"
            dropTime="3000"
            bind="0.0.0.0"
            ttl="1"
            recoveryEnabled="true"
            recoveryCounter="10"
            recoveryDelay="5000"/>

          <!--
            Receiver: recibe mensajes de otros nodos del cluster.
            address: IP de esta máquina accesible desde otros nodos.
            port: debe ser único por nodo.
          -->
          <Receiver
            className="org.apache.catalina.tribes.transport.nio.NioReceiver"
            address="192.168.1.101"
            port="4000"
            autoBind="100"
            selectorTimeout="5000"
            maxThreads="6"
            minThreads="6"
            ooBInline="true"/>

          <!--
            Sender: envía mensajes a otros nodos.
          -->
          <Sender
            className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
            <Transport
              className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"
              timeout="60000"
              maxRetryAttempts="3"
              rxBufSize="43800"
              txBufSize="25188"
              keepAliveTimeout="60000"
              keepAliveCount="100"/>
          </Sender>

          <!--
            Interceptors: cadena de procesamiento de mensajes Tribes.
            El orden importa: se procesan de arriba a abajo al enviar
            y de abajo a arriba al recibir.
          -->

          <!-- Fragmentación y reensamblado de mensajes grandes -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"
            connectTimeout="1000"
            performSendTest="true"
            sendPingTimeout="10000"/>

          <!-- Fragmentar mensajes grandes para transmisión eficiente -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.MessageDispatchInterceptor"
            optionFlag="8"/>

          <!-- Ordering: garantiza el orden de entrega de mensajes -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.OrderInterceptor"/>

          <!-- Compresión de mensajes de replicación -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.GzipInterceptor"/>

          <!-- Confirmación de entrega (threaded) -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.ThroughputInterceptor"/>

        </Channel>

        <!--
          Valve: intercepta el fin de cada petición HTTP
          para replicar los cambios de sesión.
          DEBE estar en el pipeline del cluster.
        -->
        <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
               filter=".*\.gif|.*\.jpg|.*\.jpeg|.*\.png|.*\.js|.*\.css|.*\.ico"
               primaryIndicator="true"
               primaryIndicatorName="org.apache.catalina.ha.tcp.isPrimarySession"/>

        <!--
          ClusterListener: procesa los mensajes de replicación recibidos.
        -->
        <ClusterListener
          className="org.apache.catalina.ha.session.ClusterSessionListener"/>

        <!--
          Deployer: despliegue coordinado entre nodos del cluster.
          Cuando se despliega en un nodo, se replica al resto.
        -->
        <Deployer
          className="org.apache.catalina.ha.deploy.FarmWarDeployer"
          tempDir="/tmp/cluster-wars"
          deployDir="${catalina.base}/webapps"
          watchDir="${catalina.base}/cluster-deploy"
          watchEnabled="false"/>

      </Cluster>

      <Host name="localhost"
            appBase="webapps"
            unpackWARs="true"
            autoDeploy="false"
            deployOnStartup="true">

        <Valve className="org.apache.catalina.valves.AccessLogValve"
               directory="${catalina.base}/logs"
               prefix="access"
               suffix=".log"
               pattern="%h %l %u %t &quot;%r&quot; %s %b %D"/>

        <Valve className="org.apache.catalina.valves.ErrorReportValve"
               showReport="false"
               showServerInfo="false"/>

      </Host>

    </Engine>
  </Service>
</Server>
```

### 8.2.2 Configuración Nodo 2 — Diferencias mínimas

```xml
<!--
  En node02 solo cambian:
  1. jvmRoute="node02"
  2. Receiver address="192.168.1.102" (IP de este nodo)
  3. El puerto de shutdown y conectores pueden variar si están en el mismo host
-->
<Engine name="Catalina"
        defaultHost="localhost"
        jvmRoute="node02">

  <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
           channelSendOptions="8">
    <Manager className="org.apache.catalina.ha.session.DeltaManager"
             expireSessionsOnShutdown="false"
             notifyListenersOnReplication="true"/>

    <Channel className="org.apache.catalina.tribes.group.GroupChannel">

      <Membership
        className="org.apache.catalina.tribes.membership.McastService"
        address="228.0.0.4"
        port="45564"
        frequency="500"
        dropTime="3000"/>

      <!-- Solo cambia la address del Receiver -->
      <Receiver
        className="org.apache.catalina.tribes.transport.nio.NioReceiver"
        address="192.168.1.102"
        port="4000"
        autoBind="100"
        selectorTimeout="5000"
        maxThreads="6"/>

      <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
        <Transport
          className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"
          timeout="60000"/>
      </Sender>

      <Interceptor
        className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>
      <Interceptor
        className="org.apache.catalina.tribes.group.interceptors.MessageDispatchInterceptor"
        optionFlag="8"/>
    </Channel>

    <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
           filter=".*\.gif|.*\.jpg|.*\.png|.*\.js|.*\.css|.*\.ico"/>

    <ClusterListener
      className="org.apache.catalina.ha.session.ClusterSessionListener"/>

  </Cluster>

</Engine>
```

---

## 8.3 Configuración del Cluster con BackupManager

```xml
<!--
  BackupManager: alternativa a DeltaManager para clusters grandes.
  Solo replica la sesión a UN nodo de backup (no a todos).
  Menor overhead de red. Si el nodo primario cae, el backup
  tiene la sesión más reciente.
  
  LIMITACIÓN: Solo garantiza que UN nodo tiene el backup.
  Si caen tanto el primario como el backup simultáneamente,
  la sesión se pierde.
-->
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
         channelSendOptions="6">

  <Manager className="org.apache.catalina.ha.session.BackupManager"
           expireSessionsOnShutdown="false"
           notifyListenersOnReplication="true"
           mapSendOptions="6"
           maxInactiveInterval="1800"
           sessionIdLength="32"
           rpcTimeout="15000"/>

  <Channel className="org.apache.catalina.tribes.group.GroupChannel">

    <Membership
      className="org.apache.catalina.tribes.membership.McastService"
      address="228.0.0.4"
      port="45564"
      frequency="500"
      dropTime="3000"/>

    <Receiver
      className="org.apache.catalina.tribes.transport.nio.NioReceiver"
      address="${cluster.node.address}"
      port="4000"
      autoBind="100"
      maxThreads="6"/>

    <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
      <Transport
        className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"
        timeout="60000"/>
    </Sender>

    <Interceptor
      className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"
      connectTimeout="1000"/>
    <Interceptor
      className="org.apache.catalina.tribes.group.interceptors.MessageDispatchInterceptor"
      optionFlag="8"/>
    <Interceptor
      className="org.apache.catalina.tribes.group.interceptors.ThroughputInterceptor"/>

  </Channel>

  <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
         filter=".*\.gif|.*\.jpg|.*\.png|.*\.js|.*\.css|.*\.ico|.*\.woff2"/>

  <ClusterListener
    className="org.apache.catalina.ha.session.ClusterSessionListener"/>

</Cluster>
```

---

## 8.4 Sesiones Persistentes con PersistentManager

### 8.4.1 Persistencia en base de datos (JDBCStore)

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!--
    PersistentManager con JDBCStore:
    Las sesiones se persisten en base de datos.
    Permite recuperar sesiones tras reinicio de Tomcat.
    Compatible con arquitecturas donde los nodos NO comparten estado.
  -->
  <Manager className="org.apache.catalina.session.PersistentManager"
           maxActiveSessions="-1"
           minIdleSwap="60"
           maxIdleSwap="120"
           maxIdleBackup="30"
           saveOnRestart="true"
           maxInactiveInterval="1800"
           processExpiresFrequency="6"
           sessionIdLength="32">

    <Store className="org.apache.catalina.session.JDBCStore"
           driverName="org.postgresql.Driver"
           connectionURL="jdbc:postgresql://db-host:5432/sessions_db"
           connectionName="${session.db.username}"
           connectionPassword="${session.db.password}"

           sessionTable="tomcat_sessions"
           sessionIdCol="session_id"
           sessionDataCol="session_data"
           sessionValidCol="valid_session"
           sessionMaxInactiveCol="max_inactive"
           sessionLastAccessedCol="last_access"
           sessionAppCol="app_name"

           checkInterval="60"
           maxIdleBackup="30"/>

  </Manager>

</Context>
```

```sql
-- DDL para la tabla de sesiones (PostgreSQL)
CREATE TABLE tomcat_sessions (
    session_id          VARCHAR(100)  NOT NULL PRIMARY KEY,
    valid_session       CHAR(1)       NOT NULL,
    max_inactive        INT           NOT NULL,
    last_access         BIGINT        NOT NULL,
    app_name            VARCHAR(255),
    session_data        BYTEA,
    created_at          TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tomcat_sessions_app     ON tomcat_sessions(app_name);
CREATE INDEX idx_tomcat_sessions_access  ON tomcat_sessions(last_access);
CREATE INDEX idx_tomcat_sessions_valid   ON tomcat_sessions(valid_session);

-- DDL para MySQL / MariaDB
CREATE TABLE tomcat_sessions (
    session_id          VARCHAR(100)   NOT NULL PRIMARY KEY,
    valid_session       CHAR(1)        NOT NULL,
    max_inactive        INT            NOT NULL,
    last_access         BIGINT         NOT NULL,
    app_name            VARCHAR(255),
    session_data        MEDIUMBLOB,
    created_at          TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_app_name  (app_name),
    INDEX idx_last_acc  (last_access)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Limpieza automática de sesiones expiradas (PostgreSQL)
-- Ejecutar periódicamente via cron o pg_cron
DELETE FROM tomcat_sessions
WHERE valid_session = '0'
   OR (last_access + max_inactive * 1000) < EXTRACT(EPOCH FROM NOW()) * 1000;
```

### 8.4.2 Persistencia en sistema de archivos (FileStore)

```xml
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Manager className="org.apache.catalina.session.PersistentManager"
           maxActiveSessions="10000"
           minIdleSwap="30"
           maxIdleSwap="60"
           maxIdleBackup="15"
           saveOnRestart="true">

    <!--
      FileStore: serializa sesiones en archivos en disco.
      Más simple que JDBCStore pero no apto para
      múltiples nodos leyendo del mismo directorio sin NFS/GlusterFS.
    -->
    <Store className="org.apache.catalina.session.FileStore"
           directory="/opt/sessions/myapp"
           checkInterval="60"
           filenameSuffix=".session"/>

  </Manager>

</Context>
```

```bash
# Permisos del directorio de sesiones
mkdir -p /opt/sessions/myapp
chown tomcat:tomcat /opt/sessions/myapp
chmod 750 /opt/sessions/myapp

# En NFS compartido para múltiples nodos
# mount -t nfs nfs-server:/sessions /opt/sessions
```

---

## 8.5 Configuración del Balanceador de Carga

### 8.5.1 Apache httpd con mod_proxy_balancer y Sticky Sessions

```apache
# /etc/apache2/sites-available/cluster.conf

LoadModule proxy_module         modules/mod_proxy.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule proxy_ajp_module     modules/mod_proxy_ajp.so
LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so

<VirtualHost *:443>
    ServerName app.miempresa.com

    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/miempresa.crt
    SSLCertificateKeyFile /etc/ssl/private/miempresa.key

    <!--
      Balancer con sticky sessions via JSESSIONID.
      El jvmRoute de cada Tomcat se añade al JSESSIONID:
      JSESSIONID=abc123.node01 → Apache envía a node01
      JSESSIONID=abc123.node02 → Apache envía a node02
    -->
    <Proxy balancer://tomcatcluster>

        <!-- Nodo 1 -->
        BalancerMember ajp://192.168.1.101:8009
            route=node01
            secret=mi-secreto-ajp
            loadfactor=1
            retry=60
            timeout=60
            acquire=3000

        <!-- Nodo 2 -->
        BalancerMember ajp://192.168.1.102:8009
            route=node02
            secret=mi-secreto-ajp
            loadfactor=1
            retry=60
            timeout=60
            acquire=3000

        <!-- Algoritmo de balanceo: byrequests, bybusyness, bytraffic -->
        ProxySet lbmethod=bybusyness

        <!-- Sticky sessions: nombre de la cookie y parámetro URL -->
        ProxySet stickysession=JSESSIONID|jsessionid

        <!-- Comportamiento cuando el nodo sticky no está disponible -->
        ProxySet scolonpathdelim=On

        <!-- Nodo de hot-standby (solo se usa si todos los activos caen) -->
        BalancerMember ajp://192.168.1.103:8009
            route=node03
            secret=mi-secreto-ajp
            status=+H
            loadfactor=1

    </Proxy>

    ProxyRequests Off
    ProxyPreserveHost On
    ProxyPass        /excluded !
    ProxyPass        / balancer://tomcatcluster/
    ProxyPassReverse / balancer://tomcatcluster/

    # Interfaz de gestión del balanceador (proteger en producción)
    <Location /balancer-manager>
        SetHandler balancer-manager
        Require ip 127.0.0.1 192.168.1.0/24
    </Location>

    # Archivos estáticos servidos directamente por Apache
    Alias /static /opt/static-files
    <Directory /opt/static-files>
        Require all granted
        Options -Indexes
        ExpiresActive On
        ExpiresDefault "access plus 30 days"
    </Directory>

    ErrorLog  /var/log/apache2/cluster-error.log
    CustomLog /var/log/apache2/cluster-access.log combined

</VirtualHost>
```

### 8.5.2 Nginx con upstream y sticky sessions

```nginx
# /etc/nginx/conf.d/cluster.conf

upstream tomcat_cluster {
    # ip_hash para sticky sessions basado en IP del cliente
    # (menos preciso que cookie-based, pero no requiere módulo adicional)
    ip_hash;

    server 192.168.1.101:8080 weight=1 max_fails=3 fail_timeout=30s;
    server 192.168.1.102:8080 weight=1 max_fails=3 fail_timeout=30s;
    server 192.168.1.103:8080 weight=1 max_fails=3 fail_timeout=30s backup;

    keepalive 32;
}

# Sticky sessions basado en cookie (requiere nginx-sticky-module-ng)
# upstream tomcat_cluster {
#     sticky cookie SERVERID expires=1h domain=.miempresa.com path=/;
#     server 192.168.1.101:8080;
#     server 192.168.1.102:8080;
# }

server {
    listen 443 ssl http2;
    server_name app.miempresa.com;

    ssl_certificate     /etc/ssl/certs/miempresa.crt;
    ssl_certificate_key /etc/ssl/private/miempresa.key;
    ssl_protocols       TLSv1.2 TLSv1.3;

    # Health check del balanceador
    location /health {
        proxy_pass         http://tomcat_cluster;
        proxy_set_header   Host               $host;
        proxy_set_header   X-Real-IP          $remote_addr;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto  $scheme;
        access_log off;
    }

    location / {
        proxy_pass         http://tomcat_cluster;
        proxy_http_version 1.1;
        proxy_set_header   Connection         "";
        proxy_set_header   Host               $host;
        proxy_set_header   X-Real-IP          $remote_addr;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto  $scheme;

        # Timeouts
        proxy_connect_timeout 10s;
        proxy_send_timeout    60s;
        proxy_read_timeout    60s;

        # Buffers
        proxy_buffering       on;
        proxy_buffer_size     16k;
        proxy_buffers         8 16k;

        # Reintentar en el siguiente nodo si hay error de conexión
        proxy_next_upstream   error timeout http_503;
        proxy_next_upstream_tries 2;
    }

    location /static/ {
        alias /opt/static-files/;
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
}
```

### 8.5.3 HAProxy para clustering de alta disponibilidad

```
# /etc/haproxy/haproxy.cfg

global
    log /dev/log local0
    log /dev/log local1 notice
    maxconn 50000
    user haproxy
    group haproxy
    daemon
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5s
    timeout client  60s
    timeout server  60s
    option  forwardfor
    option  http-server-close
    retries 3

# ===== Frontend HTTPS =====
frontend https_frontend
    bind *:443 ssl crt /etc/ssl/certs/miempresa.pem
    bind *:80
    redirect scheme https code 301 if !{ ssl_fc }

    # Sticky session basada en cookie JSESSIONID
    stick-table type string len 100 size 100k expire 30m
    stick on cookie(JSESSIONID) table https_backend

    default_backend tomcat_backend

# ===== Backend Tomcat =====
backend tomcat_backend
    balance roundrobin
    option httpchk GET /health HTTP/1.1\r\nHost:\ localhost

    # Cookie para sticky sessions
    cookie SERVERID insert indirect nocache httponly secure

    # Nodos del cluster
    server node01 192.168.1.101:8080 \
        check inter 10s rise 2 fall 3 \
        cookie node01 \
        weight 100

    server node02 192.168.1.102:8080 \
        check inter 10s rise 2 fall 3 \
        cookie node02 \
        weight 100

    server node03 192.168.1.103:8080 \
        check inter 10s rise 2 fall 3 \
        cookie node03 \
        weight 100 \
        backup

# ===== Stats =====
frontend stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 10s
    stats auth admin:statspassword
    stats admin if TRUE
```

---

## 8.6 Serialización de Sesiones para Replicación

Para que la replicación de sesiones funcione correctamente, todos los objetos almacenados en la sesión HTTP deben ser **serializables**.

### 8.6.1 Objetos de sesión serializables

```java
package com.miempresa.session;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Objeto de sesión de usuario.
 * DEBE implementar Serializable para replicación en cluster.
 * serialVersionUID DEBE ser explícito para control de versiones.
 */
public class UserSession implements Serializable {

    @Serial
    private static final long serialVersionUID = 202401150001L;

    private Long userId;
    private String username;
    private String email;
    private Set<String> roles;
    private LocalDateTime loginTime;
    private LocalDateTime lastActivity;
    private String sessionToken;
    private boolean rememberMe;

    // Campos NO serializables deben marcarse como transient
    // y reconstruirse al deserializar
    private transient Object cachedData;

    public UserSession() {
        this.roles        = new HashSet<>();
        this.loginTime    = LocalDateTime.now();
        this.lastActivity = LocalDateTime.now();
    }

    public void addRole(String role) {
        this.roles.add(role);
    }

    public boolean hasRole(String role) {
        return this.roles.contains(role);
    }

    public void updateActivity() {
        this.lastActivity = LocalDateTime.now();
    }

    // Getters y setters
    public Long getUserId()            { return userId; }
    public void setUserId(Long id)     { this.userId = id; }
    public String getUsername()        { return username; }
    public void setUsername(String un) { this.username = un; }
    public String getEmail()           { return email; }
    public void setEmail(String em)    { this.email = em; }
    public Set<String> getRoles()      { return roles; }
    public LocalDateTime getLoginTime(){ return loginTime; }
    public LocalDateTime getLastActivity(){ return lastActivity; }
    public boolean isRememberMe()      { return rememberMe; }
    public void setRememberMe(boolean r){ this.rememberMe = r; }
    public String getSessionToken()    { return sessionToken; }
    public void setSessionToken(String t){ this.sessionToken = t; }
}
```

### 8.6.2 Verificación de serialización en tests

```java
package com.miempresa.session;

import org.junit.jupiter.api.Test;
import java.io.*;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Test de serialización de objetos de sesión.
 * Ejecutar antes de cada release para garantizar compatibilidad.
 */
class UserSessionSerializationTest {

    @Test
    void shouldSerializeAndDeserialize() throws Exception {
        // Arrange
        UserSession original = new UserSession();
        original.setUserId(42L);
        original.setUsername("testuser");
        original.setEmail("test@miempresa.com");
        original.addRole("admin");
        original.addRole("user");
        original.setRememberMe(true);

        // Serializar a bytes (simula lo que hace Tomcat al replicar)
        byte[] serialized;
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
             ObjectOutputStream oos = new ObjectOutputStream(baos)) {
            oos.writeObject(original);
            serialized = baos.toByteArray();
        }

        // Deserializar (simula lo que hace el nodo receptor)
        UserSession restored;
        try (ByteArrayInputStream bais = new ByteArrayInputStream(serialized);
             ObjectInputStream ois = new ObjectInputStream(bais)) {
            restored = (UserSession) ois.readObject();
        }

        // Assert
        assertNotNull(restored);
        assertEquals(original.getUserId(),   restored.getUserId());
        assertEquals(original.getUsername(), restored.getUsername());
        assertEquals(original.getEmail(),    restored.getEmail());
        assertEquals(original.getRoles(),    restored.getRoles());
        assertTrue(restored.isRememberMe());
        assertNotNull(restored.getLoginTime());
    }

    @Test
    void transientFieldsShouldBeNullAfterDeserialization() throws Exception {
        UserSession session = new UserSession();
        session.setUserId(1L);

        byte[] serialized;
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
             ObjectOutputStream oos = new ObjectOutputStream(baos)) {
            oos.writeObject(session);
            serialized = baos.toByteArray();
        }

        UserSession restored;
        try (ByteArrayInputStream bais = new ByteArrayInputStream(serialized);
             ObjectInputStream ois = new ObjectInputStream(bais)) {
            restored = (UserSession) ois.readObject();
        }

        // Los campos transient deben ser null tras deserializar
        assertNull(restored.getCachedData());
    }
}
```

---

## 8.7 Distribución de Sesiones con Redis

Para clusters grandes o arquitecturas de microservicios, Redis es la solución más habitual para sesiones distribuidas sin replicación P2P entre nodos Tomcat.

### 8.7.1 Configuración con Redisson (cliente Redis para Java)

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!--
    RedissonSessionManager:
    Almacena las sesiones directamente en Redis.
    Los nodos Tomcat NO se comunican entre sí.
    Cualquier nodo puede atender cualquier petición
    porque todos leen/escriben en Redis.
  -->
  <Manager className="org.redisson.tomcat.RedissonSessionManager"
           configPath="${catalina.base}/conf/redisson.yaml"
           readMode="REDIS"
           updateMode="DEFAULT"
           broadcastSessionEvents="false"
           keyPrefix="myapp:session:"
           codec="org.redisson.codec.SerializationCodec"/>

</Context>
```

```yaml
# conf/redisson.yaml — Configuración de Redisson

# Modo Single Server (desarrollo)
singleServerConfig:
  address: "redis://redis-host:6379"
  password: "${redis.password}"
  database: 0
  connectionPoolSize: 50
  connectionMinimumIdleSize: 10
  connectTimeout: 10000
  timeout: 3000
  retryAttempts: 3
  retryInterval: 1500
  clientName: "tomcat-session"
  sslEnableEndpointIdentification: true

# Modo Sentinel (alta disponibilidad)
# sentinelServersConfig:
#   masterName: "mymaster"
#   sentinelAddresses:
#     - "redis://sentinel1:26379"
#     - "redis://sentinel2:26379"
#     - "redis://sentinel3:26379"
#   password: "${redis.password}"
#   masterConnectionPoolSize: 50
#   slaveConnectionPoolSize: 50

# Modo Cluster (escalabilidad horizontal)
# clusterServersConfig:
#   nodeAddresses:
#     - "redis://redis1:6379"
#     - "redis://redis2:6379"
#     - "redis://redis3:6379"
#   password: "${redis.password}"
#   masterConnectionPoolSize: 50
#   slaveConnectionPoolSize: 50
#   readMode: SLAVE
#   subscriptionMode: SLAVE
```

### 8.7.2 Configuración con jedis-tomcat-redis-session-manager

```xml
<!-- Alternativa más ligera con Jedis -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Valve className="com.orangefunction.tomcat.redissessions.RedisSessionHandlerValve"/>

  <Manager className="com.orangefunction.tomcat.redissessions.RedisSessionManager"
           host="${redis.host}"
           port="6379"
           password="${redis.password}"
           database="0"
           maxInactiveInterval="1800"
           sessionPersistPolicies="ALWAYS_SAVE_AFTER_REQUEST"
           connectionPoolMaxTotal="50"
           connectionPoolMaxIdle="10"
           connectionPoolMinIdle="5"
           connectionPoolTestOnBorrow="true"
           connectionPoolTestWhileIdle="true"
           connectionPoolTimeBetweenEvictionRunsMillis="30000"
           keyPrefix="myapp:session:"/>

</Context>
```

---

## 8.8 Diseño de Aplicaciones para Cluster

### 8.8.1 Buenas prácticas de sesiones en cluster

```java
package com.miempresa.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet que demuestra las mejores prácticas
 * de gestión de sesiones en entornos cluster.
 */
@WebServlet("/session-demo")
public class ClusterAwareServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(true);

        // ✅ BIEN: Almacenar solo objetos pequeños y serializables
        UserSession userSession = new UserSession();
        userSession.setUserId(42L);
        userSession.setUsername("testuser");
        session.setAttribute("userSession", userSession);

        // ✅ BIEN: Marcar la sesión como dirty explícitamente
        // cuando se modifica un objeto mutable existente
        UserSession existing = (UserSession) session.getAttribute("userSession");
        if (existing != null) {
            existing.updateActivity();
            // Con DeltaManager, volver a hacer setAttribute
            // para marcar el atributo como modificado
            session.setAttribute("userSession", existing);
        }

        // ❌ MAL: Objetos grandes en sesión
        // session.setAttribute("reportData", largeList); // MB de datos

        // ❌ MAL: Objetos no serializables
        // session.setAttribute("dbConnection", conn); // No serializable

        // ❌ MAL: Streams, sockets, threads
        // session.setAttribute("fileStream", fis); // No serializable

        // ✅ BIEN: Usar request attributes para datos temporales
        // que no necesitan persistir entre peticiones
        request.setAttribute("tempData", "valor temporal");

        // ✅ BIEN: Minimizar el tamaño de la sesión
        // Eliminar atributos que ya no se necesitan
        session.removeAttribute("temporalSetupData");

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @Override
    protected void doDelete(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {
        // ✅ BIEN: Invalidar la sesión al logout
        // (propaga la invalidación a todos los nodos en DeltaManager)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }
}
```

### 8.8.2 Activación del soporte de distribución en web.xml

```xml
<!-- web.xml de la aplicación -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         version="6.0">

  <display-name>Mi App Cluster</display-name>

  <!--
    OBLIGATORIO para habilitar la replicación de sesiones.
    Sin este elemento, Tomcat NO replicará las sesiones
    aunque el Cluster esté configurado en server.xml.
    Indica que la aplicación es consciente de la distribución.
  -->
  <distributable/>

  <session-config>
    <session-timeout>30</session-timeout>
    <cookie-config>
      <name>MYAPP_SESSIONID</name>
      <http-only>true</http-only>
      <secure>true</secure>
    </cookie-config>
    <tracking-mode>COOKIE</tracking-mode>
  </session-config>

</web-app>
```

---

## 8.9 Monitorización del Cluster

### 8.9.1 JMX MBeans del Cluster

```java
package com.miempresa.monitoring;

import javax.management.*;
import java.lang.management.ManagementFactory;
import java.util.Set;
import java.util.logging.Logger;

/**
 * Monitor del cluster Tomcat via JMX.
 */
public class ClusterMonitor {

    private static final Logger log =
        Logger.getLogger(ClusterMonitor.class.getName());

    public static void printClusterStats() throws Exception {
        MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();

        // ===== Estadísticas del Manager (DeltaManager) =====
        Set<ObjectName> managers = mbs.queryNames(
            new ObjectName("Catalina:type=Manager,*"),
            null
        );

        for (ObjectName name : managers) {
            String context      = name.getKeyProperty("context");
            int activeSessions  = (int)  mbs.getAttribute(name, "activeSessions");
            int expiredSessions = (int)  mbs.getAttribute(name, "expiredSessions");
            int rejectedSessions= (int)  mbs.getAttribute(name, "rejectedSessions");
            long sessionCounter = (long) mbs.getAttribute(name, "sessionCounter");
            int maxActive       = (int)  mbs.getAttribute(name, "maxActive");

            log.info(String.format("""
                === Session Manager: %s ===
                Sesiones activas:   %d
                Sesiones máximas:   %d
                Sesiones expiradas: %d
                Sesiones rechazadas:%d
                Total creadas:      %d
                """,
                context,
                activeSessions, maxActive,
                expiredSessions, rejectedSessions,
                sessionCounter));

            // Atributos específicos de DeltaManager
            try {
                int clusterSendFreq  = (int) mbs.getAttribute(name,
                    "rejectedSessions");
                long nrOfMsgsRcv     = (long) mbs.getAttribute(name,
                    "counterReceive_EVT_SESSION_DELTA");
                long nrOfMsgsSent    = (long) mbs.getAttribute(name,
                    "counterSend_EVT_SESSION_DELTA");

                log.info(String.format(
                    "  Mensajes delta enviados:   %d%n" +
                    "  Mensajes delta recibidos:  %d",
                    nrOfMsgsSent, nrOfMsgsRcv));
            } catch (AttributeNotFoundException e) {
                // No es DeltaManager
            }
        }

        // ===== Miembros del Cluster (nodos) =====
        Set<ObjectName> clusters = mbs.queryNames(
            new ObjectName("Catalina:type=Cluster,*"),
            null
        );

        for (ObjectName name : clusters) {
            log.info("Cluster MBean: " + name);
            try {
                String[] members = (String[]) mbs.getAttribute(name, "members");
                if (members != null) {
                    log.info("Miembros del cluster: " + members.length);
                    for (String member : members) {
                        log.info("  → " + member);
                    }
                }
            } catch (Exception e) {
                log.warning("No se pueden obtener miembros: " + e.getMessage());
            }
        }
    }
}
```

### 8.9.2 Script de diagnóstico del cluster

```bash
#!/bin/bash
# cluster-health-check.sh
# Verifica el estado de todos los nodos del cluster

set -euo pipefail

NODES=("192.168.1.101" "192.168.1.102" "192.168.1.103")
HTTP_PORT=8080
HEALTH_PATH="/myapp/health"
MANAGER_USER="manager-status-user"
MANAGER_PASS="password"

echo "============================================="
echo " Health Check del Cluster Tomcat"
echo " $(date)"
echo "============================================="
echo ""

ALL_OK=true

for NODE in "${NODES[@]}"; do

    echo "--- Nodo: $NODE ---"

    # 1. Verificar que el puerto está accesible
    if nc -z -w 3 "$NODE" "$HTTP_PORT" 2>/dev/null; then
        echo "  ✅ Puerto $HTTP_PORT accesible"
    else
        echo "  ❌ Puerto $HTTP_PORT NO accesible"
        ALL_OK=false
        continue
    fi

    # 2. Health check HTTP
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
        --connect-timeout 5 --max-time 10 \
        "http://$NODE:$HTTP_PORT$HEALTH_PATH" 2>/dev/null || echo "000")

    if [ "$HTTP_STATUS" = "200" ]; then
        echo "  ✅ Health check OK (HTTP $HTTP_STATUS)"
    else
        echo "  ❌ Health check FALLO (HTTP $HTTP_STATUS)"
        ALL_OK=false
    fi

    # 3. Estadísticas del Manager via Manager API
    MANAGER_RESP=$(curl -s \
        -u "$MANAGER_USER:$MANAGER_PASS" \
        --connect-timeout 5 --max-time 10 \
        "http://$NODE:$HTTP_PORT/manager/text/list" 2>/dev/null || echo "ERROR")

    if echo "$MANAGER_RESP" | grep -q "OK"; then
        # Contar aplicaciones en ejecución
        RUNNING=$(echo "$MANAGER_RESP" | grep -c ":running:" || true)
        STOPPED=$(echo "$MANAGER_RESP" | grep -c ":stopped:" || true)
        echo "  ✅ Manager accesible"
        echo "     Apps running: $RUNNING | stopped: $STOPPED"
    else
        echo "  ⚠️  Manager no accesible o error"
    fi

    # 4. Verificar tiempo de respuesta
    RESPONSE_TIME=$(curl -s -o /dev/null \
        -w "%{time_total}" \
        --connect-timeout 5 --max-time 10 \
        "http://$NODE:$HTTP_PORT$HEALTH_PATH" 2>/dev/null || echo "99")

    echo "  ⏱️  Tiempo de respuesta: ${RESPONSE_TIME}s"

    # Alerta si respuesta > 2 segundos
    if (( $(echo "$RESPONSE_TIME > 2.0" | bc -l) )); then
        echo "  ⚠️  Tiempo de respuesta elevado"
    fi

    echo ""
done

echo "============================================="
if $ALL_OK; then
    echo " Estado del cluster: ✅ TODOS LOS NODOS OK"
    exit 0
else
    echo " Estado del cluster: ❌ ALGUNOS NODOS CON PROBLEMAS"
    exit 1
fi
```

---

## 8.10 Diferencias de Clustering entre Versiones de Tomcat

| Característica                              | 8.0   | 8.5   | 9.0   | 10.x  | 11.0  |
|---------------------------------------------|-------|-------|-------|-------|-------|
| DeltaManager                                | ✅    | ✅    | ✅    | ✅    | ✅    |
| BackupManager                               | ✅    | ✅    | ✅    | ✅    | ✅    |
| PersistentManager + JDBCStore               | ✅    | ✅    | ✅    | ✅    | ✅    |
| Tribes NIO Receiver                         | ✅    | ✅    | ✅    | ✅    | ✅    |
| StaticMembershipService (sin multicast)     | ✅    | ✅    | ✅    | ✅    | ✅    |
| GzipInterceptor en Tribes                   | ✅    | ✅    | ✅    | ✅    | ✅    |
| ThroughputInterceptor                       | ✅    | ✅    | ✅    | ✅    | ✅    |
| FarmWarDeployer                             | ✅    | ✅    | ✅    | ✅    | ✅    |
| Replicación con Virtual Threads             | ❌    | ❌    | ❌    | ❌    | ✅    |
| Soporte multicast en contenedores (Docker)  | ⚠️   | ⚠️   | ⚠️   | ⚠️   | ⚠️   |

> ⚠️ **Multicast en Docker/Kubernetes:** El descubrimiento de nodos via multicast generalmente no funciona en entornos containerizados (Docker, Kubernetes) debido a las restricciones de red de los contenedores. En estos entornos usar `StaticMembershipService` o delegar las sesiones a Redis/Memcached.

---

## 8.11 Clustering en Kubernetes con StaticMembership

```xml
<!--
  StaticMembershipService: alternativa a McastService para entornos
  donde multicast no está disponible (Docker, Kubernetes, AWS VPC).
  Los nodos se definen estáticamente por IP/hostname.
-->
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
         channelSendOptions="8">

  <Manager className="org.apache.catalina.ha.session.DeltaManager"
           expireSessionsOnShutdown="false"
           notifyListenersOnReplication="true"/>

  <Channel className="org.apache.catalina.tribes.group.GroupChannel">

    <!-- Sin McastService — uso de StaticMembership -->
    <Membership
      className="org.apache.catalina.tribes.membership.StaticMembershipService"
      localMemberPort="4000"
      expireTime="5000">

      <!-- Listar todos los nodos del cluster explícitamente -->
      <Member className="org.apache.catalina.tribes.membership.StaticMember"
              port="4000"
              securePort="-1"
              host="tomcat-node01.default.svc.cluster.local"
              domain="cluster"
              uniqueId="{0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5}"/>

      <Member className="org.apache.catalina.tribes.membership.StaticMember"
              port="4000"
              securePort="-1"
              host="tomcat-node02.default.svc.cluster.local"
              domain="cluster"
              uniqueId="{1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6}"/>

      <Member className="org.apache.catalina.tribes.membership.StaticMember"
              port="4000"
              securePort="-1"
              host="tomcat-node03.default.svc.cluster.local"
              domain="cluster"
              uniqueId="{2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7}"/>

    </Membership>

    <Receiver
      className="org.apache.catalina.tribes.transport.nio.NioReceiver"
      address="0.0.0.0"
      port="4000"
      autoBind="0"
      selectorTimeout="5000"
      maxThreads="6"/>

    <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
      <Transport
        className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"
        timeout="60000"/>
    </Sender>

    <Interceptor
      className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>
    <Interceptor
      className="org.apache.catalina.tribes.group.interceptors.MessageDispatchInterceptor"
      optionFlag="8"/>

  </Channel>

  <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
         filter=".*\.gif|.*\.png|.*\.jpg|.*\.js|.*\.css|.*\.ico"/>

  <ClusterListener
    className="org.apache.catalina.ha.session.ClusterSessionListener"/>

</Cluster>
```

```yaml
# kubernetes/tomcat-statefulset.yaml
# StatefulSet garantiza hostnames estables para StaticMembership
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: tomcat
  namespace: default
spec:
  serviceName: "tomcat"
  replicas: 3
  selector:
    matchLabels:
      app: tomcat
  template:
    metadata:
      labels:
        app: tomcat
    spec:
      containers:
        - name: tomcat
          image: mycompany/tomcat-app:10.1.20
          ports:
            - containerPort: 8080
              name: http
            - containerPort: 4000
              name: cluster
          env:
            - name: CATALINA_OPTS
              value: >-
                -Xms1g -Xmx2g
                -XX:+UseG1GC
                -Dcluster.node.address=$(POD_IP)
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /health/live
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 30
            failureThreshold: 3
          resources:
            requests:
              memory: "1.5Gi"
              cpu: "500m"
            limits:
              memory: "3Gi"
              cpu: "2000m"

---
# Service headless para StatefulSet (resolución DNS por pod)
apiVersion: v1
kind: Service
metadata:
  name: tomcat
  namespace: default
spec:
  clusterIP: None  # Headless service
  selector:
    app: tomcat
  ports:
    - port: 8080
      name: http
    - port: 4000
      name: cluster

---
# Service para tráfico externo
apiVersion: v1
kind: Service
metadata:
  name: tomcat-external
  namespace: default
spec:
  selector:
    app: tomcat
  ports:
    - port: 80
      targetPort: 8080
  type: LoadBalancer
```

---

## Puntos Clave del Módulo 08

- El **`<distributable/>`** en `web.xml` es **obligatorio** para activar la replicación. Sin él, el Cluster configurado en `server.xml` no replica las sesiones de esa aplicación.
- **DeltaManager** replica cambios a todos los nodos (all-to-all). Adecuado para clusters de hasta 6 nodos. Con más nodos, el overhead de red se vuelve significativo.
- **BackupManager** replica solo a un nodo de backup. Menor overhead pero menor redundancia. Adecuado para clusters grandes.
- Todos los objetos almacenados en sesión **deben implementar `Serializable`** con `serialVersionUID` explícito. Objetos no serializables causan errores silenciosos de replicación.
- El atributo **`jvmRoute`** del Engine es crítico para las sticky sessions. Debe ser único en cada nodo y coincidir con el `route` configurado en el balanceador.
- **Multicast no funciona en Docker/Kubernetes** por defecto. Usar `StaticMembershipService` o externalizar las sesiones a Redis.
- Para clusters grandes o arquitecturas cloud-native, **Redis con Redisson** es la solución más robusta. Elimina la comunicación P2P entre nodos Tomcat y simplifica el scaling horizontal.
- El **`ReplicationValve`** debe filtrar los recursos estáticos (imágenes, CSS, JS) para evitar replicaciones innecesarias en cada petición de recurso estático.
- En Kubernetes usar **StatefulSet** (no Deployment) para garantizar hostnames estables necesarios para la comunicación del cluster Tribes.
- Los health check endpoints `/health/live` y `/health/ready` son imprescindibles para que el balanceador retire nodos enfermos del pool de forma automática.