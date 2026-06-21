> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Arquitectura de Clustering en Tomcat](#1-arquitectura-de-clustering-en-tomcat)
  - [¿Qué es un cluster y por qué se necesita?](#qué-es-un-cluster-y-por-qué-se-necesita)
  - [El problema de las sesiones en un cluster](#el-problema-de-las-sesiones-en-un-cluster)
  - [Cómo funciona el clustering en Tomcat: Tribes](#cómo-funciona-el-clustering-en-tomcat-tribes)
  - [Modos de replicación de sesiones](#modos-de-replicación-de-sesiones)
- [2. Configuración del Cluster con DeltaManager](#2-configuración-del-cluster-con-deltamanager)
  - [Configuración completa en server.xml — Nodo 1](#configuración-completa-en-serverxml--nodo-1)
  - [Configuración Nodo 2 — Diferencias mínimas](#configuración-nodo-2--diferencias-mínimas)
- [3. Configuración del Cluster con BackupManager](#3-configuración-del-cluster-con-backupmanager)
- [4. Sesiones Persistentes con PersistentManager](#4-sesiones-persistentes-con-persistentmanager)
  - [Persistencia en base de datos (JDBCStore)](#persistencia-en-base-de-datos-jdbcstore)
  - [Persistencia en sistema de archivos (FileStore)](#persistencia-en-sistema-de-archivos-filestore)
- [5. Configuración del Balanceador de Carga](#5-configuración-del-balanceador-de-carga)
  - [Apache httpd con mod\_proxy\_balancer y Sticky Sessions](#apache-httpd-con-mod_proxy_balancer-y-sticky-sessions)
  - [Nginx con upstream y sticky sessions](#nginx-con-upstream-y-sticky-sessions)
  - [HAProxy para clustering de alta disponibilidad](#haproxy-para-clustering-de-alta-disponibilidad)
- [6. Serialización de Sesiones para Replicación](#6-serialización-de-sesiones-para-replicación)
  - [¿Qué es la serialización y por qué importa en un cluster?](#qué-es-la-serialización-y-por-qué-importa-en-un-cluster)
  - [Objetos de sesión serializables](#objetos-de-sesión-serializables)
  - [Verificación de serialización en tests](#verificación-de-serialización-en-tests)
- [7. Distribución de Sesiones con Redis](#7-distribución-de-sesiones-con-redis)
  - [¿Por qué Redis en lugar de replicación P2P?](#por-qué-redis-en-lugar-de-replicación-p2p)
  - [Configuración con Redisson (cliente Redis para Java)](#configuración-con-redisson-cliente-redis-para-java)
  - [Configuración con jedis-tomcat-redis-session-manager](#configuración-con-jedis-tomcat-redis-session-manager)
- [8. Diseño de Aplicaciones para Cluster](#8-diseño-de-aplicaciones-para-cluster)
  - [Buenas prácticas de sesiones en cluster](#buenas-prácticas-de-sesiones-en-cluster)
  - [Activación del soporte de distribución en web.xml](#activación-del-soporte-de-distribución-en-webxml)
- [9. Monitorización del Cluster](#9-monitorización-del-cluster)
  - [JMX MBeans del Cluster](#jmx-mbeans-del-cluster)
  - [Script de diagnóstico del cluster](#script-de-diagnóstico-del-cluster)
- [10. Diferencias de Clustering entre Versiones de Tomcat](#10-diferencias-de-clustering-entre-versiones-de-tomcat)
- [11. Clustering en Kubernetes con StaticMembership](#11-clustering-en-kubernetes-con-staticmembership)
- [12. Puntos Clave](#12-puntos-clave)

---

# 1. Arquitectura de Clustering en Tomcat

## ¿Qué es un cluster y por qué se necesita?

Una instancia única de Tomcat tiene dos limitaciones fundamentales en producción:

**Limitación de capacidad:** Un servidor tiene CPU, RAM y ancho de banda finitos. Llegado cierto volumen de tráfico, una sola instancia no puede atender todas las peticiones con tiempos de respuesta aceptables.

**Punto único de fallo:** Si ese único servidor se cae (por un bug, por actualizaciones del SO, por un fallo de hardware), toda la aplicación queda inaccesible. En sistemas de alta disponibilidad (HA, *High Availability*), esto es inaceptable.

Un **cluster** resuelve ambos problemas ejecutando múltiples instancias de Tomcat en paralelo, detrás de un **balanceador de carga** que distribuye el tráfico entre ellas. Si una instancia falla, el balanceador redirige el tráfico a las demás. Si la carga crece, se añaden más nodos.

## El problema de las sesiones en un cluster

Sin replicación, las sesiones de usuario son locales a cada nodo. Si el usuario `A` se autentica en `node01` y en la siguiente petición el balanceador la envía a `node02`, ese nodo no tiene la sesión del usuario y le pide que se autentique de nuevo. Esto es inaceptable.

Hay dos soluciones principales:
1. **Sticky sessions (afinidad de sesión):** El balanceador siempre envía las peticiones del mismo usuario al mismo nodo. Las sesiones siguen siendo locales; el balanceador garantiza que siempre se usen. Problema: si el nodo cae, el usuario pierde su sesión.
2. **Replicación de sesiones:** Los nodos del cluster comparten el estado de sesión entre ellos (o en un almacén externo como Redis). Cualquier nodo puede atender cualquier petición de cualquier usuario. Más robusto, pero añade complejidad y overhead de red.

En la práctica, se usa una combinación: sticky sessions como optimización (para evitar replicaciones innecesarias), con replicación como fallback cuando el nodo sticky no está disponible.

## Cómo funciona el clustering en Tomcat: Tribes

Tomcat implementa el clustering mediante el subsistema **Tribes**, un framework de comunicación en grupo que soporta mensajería multicast y unicast entre nodos. El clustering en Tomcat abarca dos responsabilidades principales:

1. **Replicación de sesiones HTTP** entre nodos del cluster.
2. **Despliegue distribuido** de aplicaciones en todos los nodos (opcional).

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

**`jvmRoute`:** Identificador único de cada nodo en el cluster. Tomcat lo añade como sufijo al JSESSIONID: `abc123.node01`. Cuando el balanceador recibe una petición, lee el sufijo y sabe a qué nodo enviarla. Cada nodo del cluster debe tener un `jvmRoute` diferente.

**Tribes:** Es la capa de transporte del cluster. Gestiona el descubrimiento de nodos (¿quién está en el cluster?), la transmisión de mensajes entre nodos, y la detección de fallos.

## Modos de replicación de sesiones

| Modo             | Descripción                                              | Nodos afectados  | Uso recomendado        |
|------------------|----------------------------------------------------------|------------------|------------------------|
| `DeltaManager`   | Replica los **cambios** (deltas) a TODOS los nodos       | Todos (all-to-all)| Clusters pequeños ≤6  |
| `BackupManager`  | Replica la sesión completa a UN nodo de backup           | 1 nodo backup    | Clusters grandes       |
| `PersistentManager` + Store | Persiste sesiones en BD o filesystem        | Ninguno (externo)| Clusters muy grandes   |
| Redis/Memcached  | Sesiones en almacén externo compartido                   | Ninguno (externo)| Microservicios / Cloud |

**DeltaManager:** Cuando un usuario modifica algo en su sesión (p.ej. añade un artículo al carrito), el nodo que procesó esa petición envía solo el "delta" (el cambio) a **todos** los demás nodos del cluster. Con N nodos, cada cambio genera N-1 mensajes de red. En un cluster de 4 nodos, cada modificación de sesión genera 3 mensajes. Con 20 nodos, serían 19 mensajes por cada modificación de sesión de cada usuario. Por eso se limita a clusters pequeños.

**BackupManager:** En lugar de replicar a todos, cada sesión tiene un nodo "primario" (donde fue creada) y un único nodo "backup". Solo esos dos nodos tienen la sesión. Mucho menor overhead de red, pero si caen simultáneamente primario y backup, la sesión se pierde.

**PersistentManager + Store:** Las sesiones no se replican entre nodos; se persisten en un almacén externo (base de datos o sistema de archivos). Los nodos las leen y escriben independientemente. Más simple de escalar, pero introduce latencia de I/O en cada acceso a la sesión.

**Redis/Memcached:** La opción moderna para cloud y microservicios. Las sesiones viven en un sistema externo en memoria (Redis). Cualquier nodo lee y escribe directamente en Redis. No hay comunicación P2P entre nodos Tomcat. Escala horizontalmente de forma transparente.

# 2. Configuración del Cluster con DeltaManager

## Configuración completa en server.xml — Nodo 1

La configuración del cluster se añade dentro del elemento `<Engine>` en `server.xml`. Cada elemento tiene un rol específico en el sistema de replicación.

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

    <!--
      Conector AJP: protocolo de comunicación entre Apache httpd y Tomcat.
      AJP (Apache JServ Protocol) es más eficiente que HTTP para la comunicación
      interna entre el balanceador y los nodos Tomcat cuando se usa Apache httpd.
      
      address="127.0.0.1": Solo escucha en loopback. Si httpd y Tomcat están
      en máquinas diferentes, poner la IP de la interfaz de red interna.
      secretRequired y requiredSecret: protección contra Ghostcat (CVE-2020-1938).
      
      tomcatAuthentication="false": Cuando httpd gestiona la autenticación
      (via mod_auth), Tomcat acepta el usuario ya autenticado que httpd pasa.
    -->
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
    <!--
      jvmRoute="node01": CRÍTICO para las sticky sessions.
      Este identificador se añade al JSESSIONID: "abc123.node01"
      El balanceador lo lee para saber a qué nodo enviar la petición.
      DEBE ser único en cada nodo del cluster.
      DEBE coincidir exactamente con el "route" configurado en el balanceador.
    -->

      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>

      <!-- ============================================================ -->
      <!-- CONFIGURACIÓN DEL CLUSTER                                    -->
      <!-- ============================================================ -->
      <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
               channelSendOptions="8"
               channelStartOptions="3">
      <!--
        SimpleTcpCluster: Implementación principal del cluster en Tomcat.
        
        channelSendOptions="8": Controla el modo de envío de mensajes Tribes.
          2 = Síncrono (espera ACK del receptor)
          4 = Asíncrono sin ACK
          8 = Asíncrono con ACK (recomendado: buen balance entre rendimiento y fiabilidad)
        
        channelStartOptions="3": Qué partes del Channel iniciar.
          1 = Solo Sender
          2 = Solo Receiver  
          3 = Sender + Receiver (ambos, lo normal)
      -->

        <!--
          DeltaManager: El componente que gestiona la replicación de sesiones.
          
          Cuando un Servlet modifica la sesión (session.setAttribute(...)),
          DeltaManager registra ese cambio como un "delta". Al terminar la
          petición HTTP, el ReplicationValve (definido más abajo) dispara
          el envío de ese delta a todos los demás nodos del cluster.
        -->
        <Manager className="org.apache.catalina.ha.session.DeltaManager"
                 expireSessionsOnShutdown="false"
                 <!--
                   expireSessionsOnShutdown=false: Cuando este nodo se para,
                   NO invalida las sesiones. Los otros nodos siguen teniendo
                   sus copias. Si fuera true, al parar un nodo en rolling
                   deployment, todos los usuarios perderían su sesión.
                 -->
                 notifyListenersOnReplication="true"
                 <!--
                   notifyListenersOnReplication=true: Cuando se recibe una
                   sesión replicada, se notifica a los HttpSessionListeners
                   locales. Útil para mantener contadores de sesiones activas
                   o para propagar eventos de sesión a sistemas externos.
                 -->
                 stateTransferTimeout="60"
                 <!--
                   Cuando un nodo nuevo se une al cluster, solicita el estado
                   completo de las sesiones activas a los nodos existentes.
                   stateTransferTimeout=60 segundos: tiempo máximo para que
                   otro nodo responda con el estado. Si no responde, el nuevo
                   nodo arranca sin estado (las sesiones existentes redirigidas
                   a él requerirán re-autenticación).
                 -->
                 sendAllSessions="false"
                 <!--
                   sendAllSessions=false: Al hacer el state transfer inicial,
                   enviar solo las sesiones activas, no todas las registradas.
                   Reduce el tráfico de red en el arranque de un nuevo nodo.
                 -->
                 maxInactiveInterval="1800"
                 <!--
                   Tiempo de inactividad en segundos antes de expirar la sesión.
                   1800s = 30 minutos. Debe coincidir con el session-timeout de web.xml.
                 -->
                 sessionIdLength="32"/>
                 <!--
                   Longitud del JSESSIONID en bytes. 32 bytes = 256 bits de entropía.
                   Suficiente para hacer el ID imposible de adivinar.
                 -->

        <!--
          Channel: Capa de comunicación del cluster (Tribes).
          Gestiona el descubrimiento de nodos, el envío y la recepción de mensajes.
        -->
        <Channel className="org.apache.catalina.tribes.group.GroupChannel">

          <!--
            MembershipService: Cómo los nodos se descubren mutuamente.
            
            McastService usa multicast UDP: el nodo envía periódicamente
            un anuncio a la dirección multicast. Todos los nodos escuchando
            en esa dirección lo reciben y saben que el nodo está vivo.
            
            REQUISITO: Todos los nodos del cluster DEBEN usar la MISMA
            dirección y puerto multicast. Es como una "frecuencia de radio"
            compartida por todos los nodos.
            
            LIMITACIÓN: Multicast no funciona en Docker/Kubernetes/AWS VPC
            por defecto (las redes de contenedores no lo enrutan).
            Para esos entornos, usar StaticMembershipService (ver sección 8.11).
          -->
          <Membership
            className="org.apache.catalina.tribes.membership.McastService"
            address="228.0.0.4"
            <!--
              Dirección multicast. Rango válido: 224.0.0.0 a 239.255.255.255.
              228.0.0.4 es la dirección que Tomcat usa por defecto.
              Cambiarla si hay múltiples clusters en la misma red para evitar
              que los nodos de un cluster "vean" los del otro.
            -->
            port="45564"
            <!--
              Puerto UDP del canal multicast. Mismo para todos los nodos.
            -->
            frequency="500"
            <!--
              Intervalo en ms entre anuncios de presencia.
              Cada 500ms este nodo envía un mensaje multicast diciendo "sigo vivo".
            -->
            dropTime="3000"
            <!--
              Si un nodo no envía su anuncio durante 3000ms, se considera caído
              y se elimina del cluster. Con frequency=500, son 6 anuncios perdidos.
            -->
            bind="0.0.0.0"
            <!--
              IP de la interfaz de red local donde escuchar el multicast.
              0.0.0.0 = todas las interfaces. Especificar una IP concreta si
              el servidor tiene múltiples interfaces y solo una está en la
              red del cluster.
            -->
            ttl="1"
            <!--
              Time To Live del paquete multicast UDP. 1 = solo llega al
              segmento de red local (no atraviesa routers). Suficiente para
              clusters en la misma red local. Aumentar si los nodos están
              en subredes diferentes.
            -->
            recoveryEnabled="true"
            recoveryCounter="10"
            recoveryDelay="5000"/>
            <!--
              Si el canal multicast falla, intentar recuperarlo.
              recoveryCounter=10 intentos, cada recoveryDelay=5000ms.
            -->

          <!--
            Receiver: El servidor TCP que recibe mensajes de replicación
            de los demás nodos del cluster.
            
            address: IP de ESTA máquina accesible desde los otros nodos.
            Es la IP por la que los otros nodos enviarán los deltas de sesión.
            DEBE ser la IP real de la interfaz de red, no 0.0.0.0 ni 127.0.0.1,
            porque los otros nodos necesitan conectar a esta IP.
            
            port: Puerto TCP donde este nodo escucha mensajes del cluster.
            Debe estar abierto en el firewall para los otros nodos.
          -->
          <Receiver
            className="org.apache.catalina.tribes.transport.nio.NioReceiver"
            address="192.168.1.101"
            port="4000"
            autoBind="100"
            <!--
              autoBind=100: Si el puerto 4000 está ocupado, prueba hasta
              el puerto 4100 (100 puertos más). Útil cuando se ejecutan
              múltiples instancias Tomcat en la misma máquina.
            -->
            selectorTimeout="5000"
            <!--
              Timeout del selector NIO en ms. El Receiver usa Java NIO para
              gestionar múltiples conexiones con un solo hilo.
            -->
            maxThreads="6"
            minThreads="6"
            <!--
              Hilos del pool del Receiver. Cada hilo puede procesar un mensaje
              de replicación de forma paralela. 6 es adecuado para clusters
              pequeños; aumentar para clusters con mucha carga de replicación.
            -->
            ooBInline="true"/>
            <!--
              Optimización TCP: procesar datos out-of-band inline.
            -->

          <!--
            Sender: Envía mensajes de replicación a otros nodos.
            PooledParallelSender mantiene conexiones persistentes a cada nodo
            (no abre una nueva conexión TCP por cada mensaje, lo que sería
            muy costoso).
          -->
          <Sender
            className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
            <Transport
              className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"
              timeout="60000"
              <!--
                Timeout en ms para que el nodo destino confirme la recepción.
                Si en 60 segundos no hay confirmación, el envío falla.
              -->
              maxRetryAttempts="3"
              <!--
                Reintentos si el envío falla antes de considerar el nodo caído.
              -->
              rxBufSize="43800"
              txBufSize="25188"
              <!--
                Tamaños del buffer de recepción y transmisión TCP en bytes.
                Ajustar según el tamaño típico de las sesiones replicadas.
              -->
              keepAliveTimeout="60000"
              keepAliveCount="100"/>
              <!--
                Mantener la conexión TCP persistente entre nodos.
                keepAliveTimeout=60000ms: cerrar la conexión tras 60s de inactividad.
                keepAliveCount=100: cerrar tras 100 mensajes enviados por la misma conexión.
              -->
          </Sender>

          <!--
            Interceptors: Cadena de procesamiento de mensajes Tribes.
            Similar a los Filtros HTTP: cada interceptor procesa el mensaje
            y lo pasa al siguiente. El orden importa: se aplican de arriba
            abajo al enviar y de abajo arriba al recibir.
          -->

          <!--
            TcpFailureDetector: Verifica que un nodo realmente está caído
            antes de marcarlo como inactivo. Evita falsos positivos donde
            un nodo parece caído por un pico de carga pero en realidad sigue activo.
            Intenta una conexión TCP directa al nodo "caído" para confirmarlo.
          -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"
            connectTimeout="1000"
            performSendTest="true"
            sendPingTimeout="10000"/>

          <!--
            MessageDispatchInterceptor: Gestiona el despacho asíncrono
            de mensajes. Con optionFlag="8" (asíncrono con ACK), los mensajes
            se envían en un hilo separado, liberando el hilo HTTP de la
            espera de confirmación.
          -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.MessageDispatchInterceptor"
            optionFlag="8"/>

          <!--
            OrderInterceptor: Garantiza que los mensajes se entregan en el
            mismo orden en que fueron enviados. Importante para que los
            cambios de sesión se apliquen en el orden correcto en el nodo receptor.
          -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.OrderInterceptor"/>

          <!--
            GzipInterceptor: Comprime los mensajes de replicación antes de
            enviarlos por red. Reduce el ancho de banda consumido por la
            replicación, especialmente útil cuando las sesiones contienen
            objetos grandes o hay mucha actividad de escritura en sesión.
          -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.GzipInterceptor"/>

          <!--
            ThroughputInterceptor: Registra estadísticas de throughput del canal
            (bytes enviados/recibidos, mensajes/segundo). Útil para monitorización
            y para detectar cuellos de botella en la replicación.
          -->
          <Interceptor
            className="org.apache.catalina.tribes.group.interceptors.ThroughputInterceptor"/>

        </Channel>

        <!--
          ReplicationValve: Intercepta el final de cada petición HTTP.
          Cuando el Servlet termina de procesar la petición, este Valve
          comprueba si hubo cambios en la sesión y, si los hay, dispara
          el envío de los deltas al resto del cluster.
          
          DEBE estar presente para que la replicación funcione.
          
          filter: Patrón de URLs cuyas peticiones NO disparan replicación.
          Las peticiones de recursos estáticos (imágenes, CSS, JS) no
          modifican la sesión, pero sin el filtro dispararían un chequeo
          de replicación igualmente. El filtro evita ese overhead innecesario.
          
          primaryIndicator=true: Añade un atributo en el request indicando
          si este nodo es el "primario" de la sesión (la creó originalmente).
          Permite que el código de la aplicación sepa si está en el nodo
          primario (útil para tareas que solo debe hacer uno de los nodos).
        -->
        <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
               filter=".*\.gif|.*\.jpg|.*\.jpeg|.*\.png|.*\.js|.*\.css|.*\.ico"
               primaryIndicator="true"
               primaryIndicatorName="org.apache.catalina.ha.tcp.isPrimarySession"/>

        <!--
          ClusterSessionListener: Procesa los mensajes de replicación RECIBIDOS
          de otros nodos. Cuando un nodo envía un delta de sesión, este Listener
          en el nodo receptor lo aplica a su copia local de la sesión.
        -->
        <ClusterListener
          className="org.apache.catalina.ha.session.ClusterSessionListener"/>

        <!--
          FarmWarDeployer: Despliegue coordinado en cluster.
          Cuando se despliega un WAR en este nodo (via Manager API),
          FarmWarDeployer lo replica automáticamente a todos los demás nodos.
          
          watchDir: Si se copia un WAR aquí, se despliega automáticamente
          en todo el cluster.
          watchEnabled=false: No monitorizar el directorio automáticamente
          (el despliegue se hace manualmente o via CI/CD).
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
            <!--
              autoDeploy=false en producción: Evita que Tomcat despliegue
              automáticamente archivos WAR que aparezcan en webapps/.
              En cluster, el despliegue debe hacerse de forma coordinada
              (via FarmWarDeployer o pipeline CI/CD) para que todos los
              nodos tengan la misma versión simultáneamente.
            -->
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

## Configuración Nodo 2 — Diferencias mínimas

La configuración de todos los nodos del cluster es casi idéntica. Solo cambian dos cosas fundamentales entre nodos:

```xml
<!--
  En node02 SOLO cambian:
  
  1. jvmRoute="node02" — Identificador único de este nodo.
     Si dos nodos tienen el mismo jvmRoute, las sticky sessions
     del balanceador no funcionarán correctamente.
  
  2. Receiver address="192.168.1.102" — IP de ESTA máquina.
     Si todos los nodos pusieran la misma IP, los mensajes de
     replicación no llegarían al destinatario correcto.
  
  Todo lo demás (address/port del multicast, channelSendOptions,
  configuración del Manager, Interceptors) es IDÉNTICO en todos
  los nodos. Es crítico mantener la consistencia de configuración.
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

      <!-- Misma dirección y puerto multicast que node01 -->
      <Membership
        className="org.apache.catalina.tribes.membership.McastService"
        address="228.0.0.4"
        port="45564"
        frequency="500"
        dropTime="3000"/>

      <!-- Solo cambia la address: IP de este nodo (node02) -->
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

# 3. Configuración del Cluster con BackupManager

`BackupManager` es una alternativa a `DeltaManager` diseñada para clusters más grandes. En lugar de replicar a todos los nodos, cada sesión tiene un único nodo de backup.

**Funcionamiento:**
- La sesión se crea en `node01` (nodo primario).
- `BackupManager` elige `node02` como nodo de backup para esa sesión.
- Solo esos dos nodos tienen la sesión. Los demás nodos no la conocen.
- Si `node01` cae, el balanceador redirige al usuario a `node02`, que tiene la sesión completa.

**Cuándo usar BackupManager vs DeltaManager:**
- 2-6 nodos → `DeltaManager` (overhead de red aceptable, mayor resiliencia).
- 7+ nodos → `BackupManager` (el overhead all-to-all de DeltaManager sería excesivo).

```xml
<!--
  BackupManager: alternativa a DeltaManager para clusters grandes.
  Solo replica la sesión a UN nodo de backup (no a todos).
  Menor overhead de red. Si el nodo primario cae, el backup
  tiene la sesión más reciente.
  
  LIMITACIÓN: Solo garantiza que UN nodo tiene el backup.
  Si caen simultáneamente el primario y el backup,
  la sesión se pierde. DeltaManager sería más resiliente
  porque todos los nodos tienen la sesión.
-->
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
         channelSendOptions="6">
         <!--
           channelSendOptions=6 (en lugar de 8 de DeltaManager):
           Modo de envío sincrónico con ACK inmediato, apropiado para
           BackupManager donde la sesión solo va a un nodo y se necesita
           confirmar que llegó.
         -->

  <Manager className="org.apache.catalina.ha.session.BackupManager"
           expireSessionsOnShutdown="false"
           notifyListenersOnReplication="true"
           mapSendOptions="6"
           maxInactiveInterval="1800"
           sessionIdLength="32"
           rpcTimeout="15000"/>
           <!--
             rpcTimeout=15000ms: Tiempo máximo para que el nodo de backup
             confirme que recibió la sesión. Si no responde en 15 segundos,
             se elige otro nodo como backup.
           -->

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
      <!--
        ${cluster.node.address}: Propiedad del sistema que contiene la IP
        de este nodo. Se puede pasar al arranque con:
        -Dcluster.node.address=192.168.1.101
        Útil para usar la misma server.xml en todos los nodos,
        cambiando solo esta variable de entorno.
      -->
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

# 4. Sesiones Persistentes con PersistentManager

`PersistentManager` es un gestor de sesiones que persiste las sesiones en un almacén externo (base de datos o sistema de archivos), en lugar de replicarlas entre nodos.

**Diferencia conceptual con DeltaManager/BackupManager:**
- DeltaManager y BackupManager mantienen las sesiones EN MEMORIA en múltiples nodos. La persistencia es en los nodos del cluster (en RAM).
- PersistentManager persiste las sesiones en un almacén externo (BD, disco). Las sesiones se leen del almacén cuando se necesitan y se escriben de vuelta cuando cambian.

**Uso típico de PersistentManager:**
- **Sesiones inactivas en BD:** Las sesiones que llevan `minIdleSwap` minutos sin actividad se "hacen swap" a la BD, liberando memoria RAM. Si el usuario regresa, la sesión se carga de la BD.
- **Supervivencia a reinicios:** Las sesiones persisten aunque Tomcat se reinicie (`saveOnRestart=true`). Útil para mantenimientos programados.
- **Clusters sin red de replicación:** Todos los nodos leen y escriben las sesiones en la misma BD. No hay comunicación P2P entre nodos, pero la BD se convierte en un punto central (y potencial cuello de botella).

## Persistencia en base de datos (JDBCStore)

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Manager className="org.apache.catalina.session.PersistentManager"
           maxActiveSessions="-1"
           <!--
             -1 = Sin límite de sesiones activas en memoria.
             Un valor positivo (p.ej. 10000) limita cuántas sesiones
             se mantienen en RAM simultáneamente. Las que superen el límite
             se hacen swap a la BD.
           -->
           minIdleSwap="60"
           <!--
             Minutos de inactividad antes de considerar una sesión para swap.
             Una sesión que lleve 60 minutos sin actividad es candidata a
             ser movida a la BD para liberar memoria.
           -->
           maxIdleSwap="120"
           <!--
             Minutos máximos que una sesión puede estar idle en memoria
             antes de ser forzosamente movida a la BD.
           -->
           maxIdleBackup="30"
           <!--
             Minutos de inactividad antes de hacer backup de la sesión en la BD
             (aunque no se haya hecho swap completo aún). Garantiza que los datos
             de sesión recientes están en la BD incluso para sesiones activas.
           -->
           saveOnRestart="true"
           <!--
             Si true: Al parar Tomcat (reinicio, actualización), guardar TODAS
             las sesiones activas en la BD. Al volver a arrancar, cargarlas.
             Los usuarios no notan el reinicio.
           -->
           maxInactiveInterval="1800"
           processExpiresFrequency="6"
           <!--
             Cada cuántos ciclos del manager se procesan las sesiones expiradas.
             6 ciclos de 10 segundos = cada 60 segundos se limpian las expiradas.
           -->
           sessionIdLength="32">

    <!--
      JDBCStore: Almacena las sesiones en una tabla de base de datos.
      Cada sesión se serializa a bytes (BYTEA/BLOB) y se almacena en un registro.
      
      NOTA: JDBCStore usa su propia conexión JDBC directa, no un pool JNDI.
      Para usar el pool JNDI, habría que implementar un Store personalizado.
      Las credenciales deben pasarse como propiedades del sistema.
    -->
    <Store className="org.apache.catalina.session.JDBCStore"
           driverName="org.postgresql.Driver"
           connectionURL="jdbc:postgresql://db-host:5432/sessions_db"
           connectionName="${session.db.username}"
           connectionPassword="${session.db.password}"

           sessionTable="tomcat_sessions"
           <!--
             Nombre de la tabla donde se almacenan las sesiones.
             La estructura debe coincidir con las columnas configuradas abajo.
           -->
           sessionIdCol="session_id"
           sessionDataCol="session_data"
           <!--
             Columna donde se almacena el objeto de sesión serializado.
             En PostgreSQL: BYTEA. En MySQL: MEDIUMBLOB.
           -->
           sessionValidCol="valid_session"
           sessionMaxInactiveCol="max_inactive"
           sessionLastAccessedCol="last_access"
           sessionAppCol="app_name"
           <!--
             Permite que múltiples aplicaciones compartan la misma tabla
             de sesiones, diferenciadas por el nombre de la aplicación.
           -->

           checkInterval="60"
           <!--
             Cada 60 segundos, JDBCStore limpia las sesiones expiradas de la BD.
           -->
           maxIdleBackup="30"/>

  </Manager>

</Context>
```

```sql
-- DDL para la tabla de sesiones (PostgreSQL)
-- Esta estructura la requiere JDBCStore. No puede cambiarse arbitrariamente;
-- los nombres de columna deben coincidir con los configurados en el Store.
CREATE TABLE tomcat_sessions (
    session_id          VARCHAR(100)  NOT NULL PRIMARY KEY,
    valid_session       CHAR(1)       NOT NULL,
    -- '1' = sesión válida, '0' = sesión invalidada
    max_inactive        INT           NOT NULL,
    -- Tiempo máximo de inactividad en segundos (copia del maxInactiveInterval)
    last_access         BIGINT        NOT NULL,
    -- Timestamp del último acceso en milisegundos (System.currentTimeMillis())
    app_name            VARCHAR(255),
    session_data        BYTEA,
    -- El objeto HttpSession completo serializado a binario
    created_at          TIMESTAMP     NOT NULL DEFAULT NOW()
);

-- Índices para las consultas más frecuentes de JDBCStore:
-- Por app_name (para listar/limpiar sesiones de una aplicación)
CREATE INDEX idx_tomcat_sessions_app     ON tomcat_sessions(app_name);
-- Por last_access (para encontrar y expirar sesiones antiguas)
CREATE INDEX idx_tomcat_sessions_access  ON tomcat_sessions(last_access);
-- Por valid_session (para filtrar sesiones válidas)
CREATE INDEX idx_tomcat_sessions_valid   ON tomcat_sessions(valid_session);

-- DDL para MySQL / MariaDB (MEDIUMBLOB en lugar de BYTEA)
CREATE TABLE tomcat_sessions (
    session_id          VARCHAR(100)   NOT NULL PRIMARY KEY,
    valid_session       CHAR(1)        NOT NULL,
    max_inactive        INT            NOT NULL,
    last_access         BIGINT         NOT NULL,
    app_name            VARCHAR(255),
    session_data        MEDIUMBLOB,
    -- MEDIUMBLOB soporta hasta 16 MB. Suficiente para sesiones normales.
    -- Si las sesiones son muy grandes, usar LONGBLOB (hasta 4 GB).
    created_at          TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_app_name  (app_name),
    INDEX idx_last_acc  (last_access)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Limpieza periódica de sesiones expiradas.
-- JDBCStore limpia automáticamente, pero si Tomcat está parado
-- mucho tiempo, esta query puede ejecutarse via cron o pg_cron.
DELETE FROM tomcat_sessions
WHERE valid_session = '0'
   OR (last_access + max_inactive * 1000) < EXTRACT(EPOCH FROM NOW()) * 1000;
-- La fórmula compara last_access (en milisegundos) + max_inactive*1000
-- con el timestamp actual. Si la suma es menor que ahora, la sesión expiró.
```

## Persistencia en sistema de archivos (FileStore)

`FileStore` es la alternativa más simple: cada sesión se serializa a un archivo en disco, identificado por el JSESSIONID.

**Cuándo usar FileStore vs JDBCStore:**
- FileStore: entornos de desarrollo, servidores únicos donde solo necesitas supervivencia a reinicios.
- JDBCStore: entornos de producción multi-nodo o cuando necesitas la BD para gestión centralizada de sesiones.

```xml
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Manager className="org.apache.catalina.session.PersistentManager"
           maxActiveSessions="10000"
           minIdleSwap="30"
           maxIdleSwap="60"
           maxIdleBackup="15"
           saveOnRestart="true">

    <Store className="org.apache.catalina.session.FileStore"
           directory="/opt/sessions/myapp"
           <!--
             Directorio donde se guardan los archivos de sesión.
             Cada sesión genera un archivo: {sessionId}.session
             Debe existir y tener permisos de escritura para el usuario de Tomcat.
             
             Para clusters multi-nodo: Montar este directorio en NFS/GlusterFS
             para que todos los nodos compartan el mismo almacén de sesiones.
             CUIDADO: Acceso concurrente sin coordinación puede causar corrupción.
             Para producción multi-nodo, JDBCStore es más seguro.
           -->
           checkInterval="60"
           filenameSuffix=".session"/>
           <!--
             Extensión de los archivos de sesión. Facilita identificarlos
             en el directorio y limpiarlos manualmente si es necesario.
           -->

  </Manager>

</Context>
```

```bash
# Crear el directorio y asignar permisos al usuario de Tomcat
mkdir -p /opt/sessions/myapp
chown tomcat:tomcat /opt/sessions/myapp
# 750: propietario puede leer/escribir/ejecutar, grupo puede leer, otros nada.
# Las sesiones contienen datos sensibles de usuario; no deben ser legibles
# por otros usuarios del sistema.
chmod 750 /opt/sessions/myapp

# Para múltiples nodos compartiendo el mismo directorio via NFS:
# mount -t nfs nfs-server:/sessions /opt/sessions
# IMPORTANTE: Verificar que el NFS soporta file locking para evitar
# corrupción cuando dos nodos intentan escribir la misma sesión simultáneamente.
```

# 5. Configuración del Balanceador de Carga

El balanceador de carga (*load balancer*) es el componente que recibe todas las peticiones externas y las distribuye entre los nodos del cluster. Es responsable de:
- **Distribución de carga:** Enviar peticiones al nodo menos cargado.
- **Sticky sessions:** Enviar peticiones del mismo usuario siempre al mismo nodo.
- **Health checks:** Detectar nodos caídos y dejar de enviarles tráfico.
- **Terminación TLS:** En muchas arquitecturas, el balanceador gestiona HTTPS y las conexiones internas van sin cifrar (más eficiente).

## Apache httpd con mod_proxy_balancer y Sticky Sessions

Apache httpd es la opción más integrada con Tomcat cuando se usa el protocolo AJP, que es más eficiente que HTTP para la comunicación interna.

```apache
# /etc/apache2/sites-available/cluster.conf

# Módulos necesarios para el balanceo
LoadModule proxy_module         modules/mod_proxy.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule proxy_ajp_module     modules/mod_proxy_ajp.so
# Algoritmos de balanceo disponibles:
# byrequests: Distribución por número de peticiones (round-robin ponderado)
# bybusyness: Envía al nodo con menos peticiones activas en ese momento (recomendado)
# bytraffic:  Distribución por bytes transferidos
LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so

<VirtualHost *:443>
    ServerName app.miempresa.com

    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/miempresa.crt
    SSLCertificateKeyFile /etc/ssl/private/miempresa.key

    <!--
      Balancer con sticky sessions via JSESSIONID.
      
      ¿Cómo funcionan las sticky sessions aquí?
      1. El usuario hace login en node01.
      2. Tomcat crea la sesión con ID "abc123" y jvmRoute "node01".
         La cookie JSESSIONID queda como "abc123.node01".
      3. En la siguiente petición, Apache lee el sufijo ".node01"
         de la cookie JSESSIONID y envía la petición a node01.
      4. El usuario siempre va a node01 mientras ese nodo esté disponible.
      5. Si node01 cae, Apache elimina el sufijo del JSESSIONID y
         envía la petición a otro nodo disponible (que tendrá la sesión
         gracias a la replicación DeltaManager/BackupManager).
    -->
    <Proxy balancer://tomcatcluster>

        <!-- Nodo 1 (ajp:// usa el protocolo AJP, más eficiente que http://) -->
        BalancerMember ajp://192.168.1.101:8009
            route=node01
            <!--
              route=node01 DEBE coincidir exactamente con jvmRoute="node01"
              en el server.xml de ese Tomcat. Es el mecanismo de sticky sessions.
            -->
            secret=mi-secreto-ajp
            <!--
              Secreto AJP para autenticación (protección Ghostcat).
              Debe coincidir con requiredSecret en el Connector AJP de Tomcat.
            -->
            loadfactor=1
            <!--
              Peso relativo para el balanceo. Con loadfactor=1 en todos,
              el tráfico se distribuye uniformemente. Con loadfactor=2 en
              un nodo y 1 en los demás, ese nodo recibirá el doble de peticiones.
            -->
            retry=60
            <!--
              Segundos que Apache espera antes de reintentar enviar peticiones
              a un nodo que marcó como caído. Con retry=60, si node01 cae
              a las 14:00, Apache empieza a probarle de nuevo a las 14:01.
            -->
            timeout=60
            acquire=3000
            <!--
              acquire=3000ms: Tiempo máximo para adquirir una conexión AJP
              libre del pool hacia el backend. Si todas están en uso, espera
              hasta 3 segundos antes de reintentar en otro nodo.
            -->

        <!-- Nodo 2 -->
        BalancerMember ajp://192.168.1.102:8009
            route=node02
            secret=mi-secreto-ajp
            loadfactor=1
            retry=60
            timeout=60
            acquire=3000

        <!-- Algoritmo de balanceo: bybusyness envía al nodo con menos carga activa -->
        ProxySet lbmethod=bybusyness

        <!-- Cookie para sticky sessions: Apache lee el sufijo del JSESSIONID -->
        ProxySet stickysession=JSESSIONID|jsessionid
        <!--
          JSESSIONID: Nombre de la cookie HTTP
          jsessionid: Parámetro de URL (para cuando las sesiones van en URL, no cookie)
          El "|" separa ambas formas para que Apache maneje los dos casos.
        -->

        ProxySet scolonpathdelim=On
        <!--
          Activa el parsing del JSESSIONID con punto y coma como delimitador.
          Necesario para URLs del tipo: /myapp/pagina;jsessionid=abc123.node01
        -->

        <!--
          Nodo de hot-standby: Solo recibe tráfico si TODOS los nodos
          activos están caídos. status=+H lo marca como standby.
          Útil como "último recurso" para mostrar página de mantenimiento.
        -->
        BalancerMember ajp://192.168.1.103:8009
            route=node03
            secret=mi-secreto-ajp
            status=+H
            loadfactor=1

    </Proxy>

    ProxyRequests Off        <!-- Desactivar proxy forward (solo proxy reverse) -->
    ProxyPreserveHost On     <!-- Pasar el Host header original al backend Tomcat -->
    ProxyPass        /excluded !   <!-- Excluir la ruta /excluded del proxy -->
    ProxyPass        / balancer://tomcatcluster/
    ProxyPassReverse / balancer://tomcatcluster/

    # Interfaz de gestión del balanceador (solo accesible desde red interna)
    <Location /balancer-manager>
        SetHandler balancer-manager
        Require ip 127.0.0.1 192.168.1.0/24
    </Location>

    # Recursos estáticos servidos directamente por Apache (sin pasar por Tomcat)
    # Reduce la carga en los nodos Tomcat para archivos que no cambian
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

## Nginx con upstream y sticky sessions

Nginx es una alternativa a Apache httpd, generalmente preferida por su menor consumo de memoria y mayor rendimiento en conexiones concurrentes. No soporta el protocolo AJP de forma nativa, por lo que la comunicación con Tomcat va por HTTP.

```nginx
# /etc/nginx/conf.d/cluster.conf

upstream tomcat_cluster {
    # ip_hash: Sticky sessions basado en la IP del cliente.
    # La misma IP del cliente siempre va al mismo servidor backend.
    # Ventaja: No requiere módulo adicional, funciona con Nginx estándar.
    # Desventaja: Menos preciso que cookie-based. Si el usuario cambia de IP
    # (p.ej. en redes móviles) o hay NAT (múltiples usuarios con la misma IP),
    # las sticky sessions no funcionan correctamente.
    ip_hash;

    # weight=1: Peso igual para todos los nodos (distribución uniforme).
    # max_fails=3: Si 3 peticiones consecutivas fallan, marcar el nodo como caído.
    # fail_timeout=30s: Marcar como caído durante 30 segundos antes de reintentar.
    server 192.168.1.101:8080 weight=1 max_fails=3 fail_timeout=30s;
    server 192.168.1.102:8080 weight=1 max_fails=3 fail_timeout=30s;
    # backup: Solo se usa si los nodos principales están todos caídos.
    server 192.168.1.103:8080 weight=1 max_fails=3 fail_timeout=30s backup;

    # keepalive: Mantener hasta 32 conexiones HTTP keep-alive hacia cada backend.
    # Evita el overhead de abrir nuevas conexiones TCP en cada petición.
    keepalive 32;
}

# Alternativa: sticky sessions basada en cookie (más precisa que ip_hash)
# Requiere instalar el módulo nginx-sticky-module-ng (no incluido en el Nginx estándar).
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

    # Health check: silenciar logs para no llenar el disco con checks periódicos
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
        # Connection "" con HTTP/1.1: Desactivar "Connection: close" del HTTP/1.0.
        # Necesario para que funcione keepalive con el backend.
        proxy_set_header   Connection         "";
        proxy_set_header   Host               $host;
        # X-Real-IP: La IP real del cliente (para logs en Tomcat).
        # Sin esto, Tomcat vería la IP de Nginx en lugar de la del usuario.
        proxy_set_header   X-Real-IP          $remote_addr;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        # X-Forwarded-Proto: Indica a Tomcat que la petición llegó por HTTPS.
        # Sin esto, request.isSecure() devuelve false aunque el usuario usó HTTPS.
        proxy_set_header   X-Forwarded-Proto  $scheme;

        proxy_connect_timeout 10s;   # Tiempo para conectar al backend Tomcat
        proxy_send_timeout    60s;   # Tiempo para enviar la petición al backend
        proxy_read_timeout    60s;   # Tiempo para recibir la respuesta del backend

        proxy_buffering       on;
        proxy_buffer_size     16k;
        proxy_buffers         8 16k;
        # Buffering: Nginx acumula la respuesta completa del backend antes de
        # enviarla al cliente. Libera el hilo del backend más rápido pero
        # usa más memoria en Nginx. Adecuado para respuestas pequeñas.

        # Si hay error de conexión, timeout o 503, reintentar en el siguiente nodo.
        # proxy_next_upstream_tries=2: Máximo 2 nodos a probar antes de devolver error.
        proxy_next_upstream   error timeout http_503;
        proxy_next_upstream_tries 2;
    }

    # Recursos estáticos servidos directamente por Nginx (sin pasar por Tomcat)
    location /static/ {
        alias /opt/static-files/;
        expires 30d;
        # Cache-Control: immutable indica al navegador que el archivo no cambia.
        # El cliente lo guarda en caché y no lo solicita de nuevo en 30 días.
        add_header Cache-Control "public, immutable";
        access_log off;  # Silenciar logs de estáticos
    }
}
```

## HAProxy para clustering de alta disponibilidad

HAProxy es un balanceador de carga especializado, reconocido como el más robusto y de mayor rendimiento para tráfico HTTP/TCP en producción. Es la opción estándar en entornos empresariales cuando se necesita alta disponibilidad y soporte avanzado de health checks.

```
# /etc/haproxy/haproxy.cfg

global
    log /dev/log local0           # Enviar logs al syslog local
    log /dev/log local1 notice
    maxconn 50000                 # Máximo de conexiones TCP simultáneas
    user haproxy
    group haproxy
    daemon                        # Ejecutar como proceso en segundo plano
    # Socket de administración: permite gestionar HAProxy en tiempo real
    # (añadir/quitar nodos, ver estadísticas) sin reiniciar
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners

defaults
    log     global
    mode    http                  # Modo HTTP (en lugar de TCP genérico)
    option  httplog               # Log detallado de peticiones HTTP
    option  dontlognull           # No loguear peticiones sin datos (health checks vacíos)
    timeout connect 5s            # Timeout para conectar al backend
    timeout client  60s           # Timeout de inactividad del cliente
    timeout server  60s           # Timeout de inactividad del servidor
    option  forwardfor            # Añadir cabecera X-Forwarded-For con IP del cliente
    option  http-server-close     # Cerrar conexiones al backend tras cada petición
    retries 3                     # Reintentar 3 veces en el backend antes de error

# ===== Frontend HTTPS =====
# El "frontend" es el punto de entrada: donde HAProxy escucha conexiones externas.
frontend https_frontend
    bind *:443 ssl crt /etc/ssl/certs/miempresa.pem
    bind *:80
    # Redirigir HTTP a HTTPS (código 301 = redirección permanente)
    redirect scheme https code 301 if !{ ssl_fc }

    # Sticky sessions con tabla de estado:
    # HAProxy mantiene una tabla en memoria que mapea cada valor de cookie
    # JSESSIONID a un nodo del backend.
    # type string len 100: La clave es un string de hasta 100 chars (el JSESSIONID)
    # size 100k: Hasta 100.000 entradas en la tabla (100.000 sesiones activas)
    # expire 30m: Las entradas se eliminan tras 30 minutos de inactividad
    stick-table type string len 100 size 100k expire 30m
    stick on cookie(JSESSIONID) table https_backend
    # stick on: Extraer el JSESSIONID de la cookie y usarlo como clave de la tabla.
    # Las peticiones con el mismo JSESSIONID van siempre al mismo backend.

    default_backend tomcat_backend

# ===== Backend Tomcat =====
# El "backend" define los servidores de destino y cómo HAProxy les envía tráfico.
backend tomcat_backend
    balance roundrobin             # Algoritmo de balanceo: round-robin
    # Health check HTTP: GET /health. Si no responde 200, marcar como caído.
    option httpchk GET /health HTTP/1.1\r\nHost:\ localhost

    # HAProxy inserta una cookie SERVERID en la respuesta.
    # El navegador del usuario la guarda y la envía en las siguientes peticiones.
    # HAProxy lee la cookie para saber a qué nodo enviar.
    # insert: HAProxy añade la cookie si no existe
    # indirect: No modificar la cookie si ya existe
    # nocache: Añadir "Cache-Control: no-cache" para que la cookie no se cachee
    # httponly: La cookie no es accesible desde JavaScript
    # secure: La cookie solo se envía en HTTPS
    cookie SERVERID insert indirect nocache httponly secure

    # check: Activar health checks.
    # inter 10s: Verificar cada 10 segundos si el nodo está vivo.
    # rise 2: Después de 2 health checks exitosos, marcar como disponible.
    # fall 3: Después de 3 health checks fallidos, marcar como caído.
    # cookie node01: El valor de la cookie SERVERID para este nodo.
    server node01 192.168.1.101:8080 \
        check inter 10s rise 2 fall 3 \
        cookie node01 \
        weight 100

    server node02 192.168.1.102:8080 \
        check inter 10s rise 2 fall 3 \
        cookie node02 \
        weight 100

    # backup: Este nodo solo recibe tráfico si node01 y node02 están caídos.
    server node03 192.168.1.103:8080 \
        check inter 10s rise 2 fall 3 \
        cookie node03 \
        weight 100 \
        backup

# ===== Panel de estadísticas de HAProxy =====
# Interfaz web que muestra el estado de todos los nodos en tiempo real.
# PROTEGER con contraseña fuerte y acceso restringido por IP en producción.
frontend stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 10s            # Refrescar automáticamente cada 10 segundos
    stats auth admin:statspassword
    stats admin if TRUE           # Permite administrar nodos desde la UI web
```

---

# 6. Serialización de Sesiones para Replicación

## ¿Qué es la serialización y por qué importa en un cluster?

**Serialización** es el proceso de convertir un objeto Java en memoria a una secuencia de bytes que puede transmitirse por red o guardarse en disco. La **deserialización** es el proceso inverso.

Cuando DeltaManager o BackupManager replican una sesión a otro nodo, convierten los objetos de la sesión a bytes (serialización), los envían por la red TCP entre nodos, y el nodo receptor los reconstruye (deserialización).

Si un objeto en la sesión **no puede serializarse** (p.ej. una conexión de base de datos, un `InputStream`, un hilo), el proceso falla. En el mejor caso, lanza una excepción visible. En el peor caso, la sesión se replica pero ese atributo se pierde silenciosamente en el nodo receptor.

## Objetos de sesión serializables

Para ser serializable, una clase debe:
1. Implementar la interfaz `java.io.Serializable`.
2. Declarar un `serialVersionUID` explícito.
3. Asegurarse de que todos sus campos también son serializables (o marcarlos como `transient`).

```java
package com.miempresa.session;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Objeto de sesión de usuario para entorno cluster.
 * Todos los atributos de sesión DEBEN implementar Serializable.
 */
public class UserSession implements Serializable {

    /**
     * serialVersionUID: Identificador de versión de la clase para serialización.
     * 
     * SIEMPRE debe ser explícito y estable.
     * 
     * ¿Por qué importa? Durante un rolling deployment (actualización nodo a nodo),
     * pueden coexistir dos versiones del código en el cluster: node01 con la versión
     * nueva y node02 con la vieja. Si el serialVersionUID cambia entre versiones,
     * node02 no puede deserializar sesiones creadas por node01 (y viceversa), lo que
     * causa errores de InvalidClassException y pérdida de sesiones.
     * 
     * Si Java genera el serialVersionUID automáticamente (sin declararlo), lo calcula
     * a partir del hash de la clase. Cualquier cambio en la clase (añadir un campo,
     * cambiar un método) cambia el hash y rompe la compatibilidad.
     * 
     * Patrón recomendado: Usar un timestamp o número de versión como UID.
     */
    @Serial
    private static final long serialVersionUID = 202401150001L;

    private Long userId;
    private String username;
    private String email;
    private Set<String> roles;        // HashSet implementa Serializable ✅
    private LocalDateTime loginTime;  // LocalDateTime implementa Serializable ✅
    private LocalDateTime lastActivity;
    private String sessionToken;
    private boolean rememberMe;

    /**
     * transient: Este campo NO se serializa.
     * 
     * Usar transient para campos que:
     * 1. No pueden serializarse (conexiones, streams, threads).
     * 2. Son costosos de serializar pero pueden reconstruirse (cachés).
     * 3. Contienen información sensible que no debe transmitirse por red.
     * 
     * IMPORTANTE: Tras deserializar, los campos transient son null.
     * El código que los use debe verificar null y reconstruirlos si es necesario.
     */
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
    public Long getUserId()              { return userId; }
    public void setUserId(Long id)       { this.userId = id; }
    public String getUsername()          { return username; }
    public void setUsername(String un)   { this.username = un; }
    public String getEmail()             { return email; }
    public void setEmail(String em)      { this.email = em; }
    public Set<String> getRoles()        { return roles; }
    public LocalDateTime getLoginTime()  { return loginTime; }
    public LocalDateTime getLastActivity(){ return lastActivity; }
    public boolean isRememberMe()        { return rememberMe; }
    public void setRememberMe(boolean r) { this.rememberMe = r; }
    public String getSessionToken()      { return sessionToken; }
    public void setSessionToken(String t){ this.sessionToken = t; }
    public Object getCachedData()        { return cachedData; }
}
```

## Verificación de serialización en tests

Es fundamental verificar que los objetos de sesión pueden serializarse y deserializarse correctamente **antes de cada release**. Este test simula exactamente lo que hace Tomcat durante la replicación.

```java
package com.miempresa.session;

import org.junit.jupiter.api.Test;
import java.io.*;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Test de serialización de objetos de sesión.
 * 
 * Ejecutar SIEMPRE antes de cada release a producción.
 * Un fallo aquí significa que la replicación en cluster fallará,
 * causando pérdida de sesiones o errores en producción.
 * 
 * Añadir al pipeline CI/CD como test obligatorio (break the build si falla).
 */
class UserSessionSerializationTest {

    @Test
    void shouldSerializeAndDeserialize() throws Exception {
        // Arrange: Crear una sesión con datos reales
        UserSession original = new UserSession();
        original.setUserId(42L);
        original.setUsername("testuser");
        original.setEmail("test@miempresa.com");
        original.addRole("admin");
        original.addRole("user");
        original.setRememberMe(true);

        // Act — Fase 1: Serializar (simula lo que hace el nodo que ENVÍA la sesión)
        byte[] serialized;
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
             ObjectOutputStream oos = new ObjectOutputStream(baos)) {
            oos.writeObject(original);
            serialized = baos.toByteArray();
        }
        // serialized contiene la representación binaria de la sesión.
        // Este es el dato que DeltaManager envía por la red TCP entre nodos.

        // Act — Fase 2: Deserializar (simula lo que hace el nodo que RECIBE la sesión)
        UserSession restored;
        try (ByteArrayInputStream bais = new ByteArrayInputStream(serialized);
             ObjectInputStream ois = new ObjectInputStream(bais)) {
            restored = (UserSession) ois.readObject();
        }

        // Assert: Verificar que todos los datos se conservaron correctamente
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
        // Los campos marcados como "transient" NO se serializan.
        // Después de deserializar, deben ser null.
        // Este test verifica ese comportamiento esperado.
        UserSession session = new UserSession();
        session.setUserId(1L);
        // cachedData es transient; si se asignara antes de serializar,
        // no debería estar presente después de deserializar.

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

        // Los campos transient DEBEN ser null tras deserializar
        assertNull(restored.getCachedData());
        // Verificar que sí se conservó el ID (campo normal, no transient)
        assertEquals(1L, restored.getUserId());
    }
}
```

# 7. Distribución de Sesiones con Redis

Para clusters grandes o arquitecturas cloud-native, Redis es la solución más robusta y escalable para sesiones distribuidas. Elimina completamente la necesidad de replicación P2P entre nodos Tomcat.

## ¿Por qué Redis en lugar de replicación P2P?

**Con DeltaManager/BackupManager:**
- Los nodos Tomcat se comunican directamente entre sí (P2P).
- Escalar de 4 a 8 nodos duplica el tráfico de replicación.
- Requiere que los nodos se "descubran" mutuamente (multicast o configuración estática).
- Multicast no funciona en Docker/Kubernetes sin configuración especial.

**Con Redis:**
- Todas las sesiones viven en Redis (memoria externa).
- Cada nodo Tomcat lee/escribe directamente en Redis.
- Los nodos Tomcat no se comunican entre sí. Son completamente independientes.
- Añadir más nodos no aumenta el tráfico de replicación: cada nuevo nodo solo habla con Redis.
- Redis funciona perfectamente en Docker/Kubernetes/cloud.
- Permite deploys y escalado horizontal sin coordinación entre nodos.

**Trade-off:** Redis introduce una dependencia externa. Si Redis falla, todos los nodos pierden acceso a las sesiones. Se mitiga con Redis en modo Sentinel (HA) o Cluster.

## Configuración con Redisson (cliente Redis para Java)

Redisson es la librería cliente Redis más completa para Java. Incluye soporte nativo para gestión de sesiones Tomcat.

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!--
    RedissonSessionManager sustituye completamente a DeltaManager/BackupManager.
    Las sesiones se almacenan en Redis en lugar de replicarse entre nodos.
    
    Cualquier nodo Tomcat puede atender cualquier petición de cualquier usuario,
    porque todos leen las sesiones de Redis. Las sticky sessions dejan de ser
    necesarias (aunque pueden mantenerse como optimización para reducir reads de Redis).
  -->
  <Manager className="org.redisson.tomcat.RedissonSessionManager"
           configPath="${catalina.base}/conf/redisson.yaml"
           <!--
             Archivo de configuración de Redisson (ver abajo).
             Centraliza la configuración de Redis (modos, pool, timeout, etc.)
           -->
           readMode="REDIS"
           <!--
             REDIS: Leer la sesión directamente de Redis en cada petición.
             LOCAL: Cachear la sesión en memoria local del nodo; sincronizar
             con Redis al final de la petición. Más rápido pero puede causar
             inconsistencias si múltiples nodos modifican la sesión simultáneamente.
           -->
           updateMode="DEFAULT"
           <!--
             DEFAULT: Escribir en Redis solo los atributos que cambiaron.
             AFTER_REQUEST: Escribir toda la sesión al final de cada petición,
             independientemente de si cambió algo.
           -->
           broadcastSessionEvents="false"
           <!--
             Si true: Notificar a todos los nodos cuando una sesión se crea/destruye.
             Útil si los nodos necesitan reaccionar a eventos de sesión de otros nodos.
             false es el valor por defecto y suficiente en la mayoría de casos.
           -->
           keyPrefix="myapp:session:"
           <!--
             Prefijo de las claves en Redis.
             Las sesiones se almacenan como: "myapp:session:{JSESSIONID}"
             Permite que múltiples aplicaciones compartan el mismo Redis
             sin mezclar sus sesiones.
           -->
           codec="org.redisson.codec.SerializationCodec"/>
           <!--
             Codec: Cómo serializar los objetos Java para almacenarlos en Redis.
             SerializationCodec: Usa la serialización Java estándar (igual que
             DeltaManager). Los objetos deben implementar Serializable.
             Alternativas: JsonJacksonCodec (más legible pero mayor overhead),
             Kryo5Codec (más compacto y rápido).
           -->

</Context>
```

```yaml
# conf/redisson.yaml — Configuración de Redisson
# Tres modos posibles según la arquitectura de Redis:

# ===== Modo Single Server (un solo nodo Redis) =====
# Para desarrollo o pequeñas aplicaciones. Sin alta disponibilidad.
singleServerConfig:
  address: "redis://redis-host:6379"
  password: "${redis.password}"
  database: 0
  # Base de datos Redis (0-15). Usar diferentes DBs para separar entornos.
  connectionPoolSize: 50
  # Máximo de conexiones en el pool hacia Redis.
  connectionMinimumIdleSize: 10
  connectTimeout: 10000    # ms para establecer conexión con Redis
  timeout: 3000            # ms para que Redis responda a una operación
  retryAttempts: 3         # Reintentos si Redis no responde
  retryInterval: 1500      # ms entre reintentos
  clientName: "tomcat-session"
  # Nombre con el que este cliente se identifica en Redis (visible en CLIENT LIST).
  sslEnableEndpointIdentification: true
  # Verificar que el certificado TLS de Redis corresponde al hostname.

# ===== Modo Sentinel (alta disponibilidad con failover automático) =====
# Redis Sentinel monitoriza un Redis master y sus réplicas.
# Si el master falla, Sentinel promueve automáticamente una réplica a master.
# sentinelServersConfig:
#   masterName: "mymaster"
#   sentinelAddresses:
#     - "redis://sentinel1:26379"
#     - "redis://sentinel2:26379"
#     - "redis://sentinel3:26379"
#   password: "${redis.password}"
#   masterConnectionPoolSize: 50   # Conexiones al master (para escrituras)
#   slaveConnectionPoolSize: 50    # Conexiones a réplicas (para lecturas)

# ===== Modo Cluster (escalabilidad horizontal) =====
# Redis Cluster distribuye los datos entre múltiples nodos usando hashing.
# Permite escalar más allá de la capacidad de un solo nodo.
# clusterServersConfig:
#   nodeAddresses:
#     - "redis://redis1:6379"
#     - "redis://redis2:6379"
#     - "redis://redis3:6379"
#   password: "${redis.password}"
#   masterConnectionPoolSize: 50
#   slaveConnectionPoolSize: 50
#   readMode: SLAVE         # Leer de réplicas para reducir carga del master
#   subscriptionMode: SLAVE
```

## Configuración con jedis-tomcat-redis-session-manager

Una alternativa más ligera a Redisson, basada en la librería Jedis (cliente Redis para Java). Menos funcionalidades pero menor overhead.

```xml
<!-- Alternativa más ligera con Jedis -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!--
    RedisSessionHandlerValve: Intercepta el inicio y fin de cada petición.
    Al inicio carga la sesión de Redis; al final la guarda de vuelta.
    Debe declararse ANTES del Manager en el context.xml.
  -->
  <Valve className="com.orangefunction.tomcat.redissessions.RedisSessionHandlerValve"/>

  <Manager className="com.orangefunction.tomcat.redissessions.RedisSessionManager"
           host="${redis.host}"
           port="6379"
           password="${redis.password}"
           database="0"
           maxInactiveInterval="1800"
           sessionPersistPolicies="ALWAYS_SAVE_AFTER_REQUEST"
           <!--
             ALWAYS_SAVE_AFTER_REQUEST: Guardar la sesión en Redis al finalizar
             cada petición, aunque no haya cambiado nada.
             Alternativa: DEFAULT (solo guardar si hubo cambios).
             ALWAYS_SAVE es más seguro pero genera más escrituras en Redis.
           -->
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

# 8. Diseño de Aplicaciones para Cluster

Configurar el cluster en el servidor es solo la mitad del trabajo. El código de la aplicación también debe seguir ciertas prácticas para funcionar correctamente en un entorno distribuido.

## Buenas prácticas de sesiones en cluster

```java
package com.miempresa.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet que demuestra las mejores y peores prácticas
 * de gestión de sesiones en entornos cluster.
 */
@WebServlet("/session-demo")
public class ClusterAwareServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(true);
        // getSession(true): Crear sesión si no existe.
        // getSession(false): Devolver null si no existe (no crear).
        // Preferir getSession(false) y comprobar null cuando no es seguro
        // que el usuario tenga sesión.

        // ✅ BIEN: Almacenar objetos pequeños y serializables.
        // La sesión se replicará por la red; objetos grandes = más tráfico.
        UserSession userSession = new UserSession();
        userSession.setUserId(42L);
        userSession.setUsername("testuser");
        session.setAttribute("userSession", userSession);

        // ✅ BIEN: Marcar la sesión como "dirty" explícitamente
        // cuando se modifica un objeto mutable existente.
        //
        // ¿Por qué es necesario hacer setAttribute de nuevo?
        // DeltaManager detecta cambios rastreando las llamadas a setAttribute().
        // Si se modifica el INTERIOR de un objeto ya en sesión sin llamar
        // a setAttribute() de nuevo, DeltaManager no detecta el cambio
        // y NO replica la modificación. El resultado es inconsistencia entre nodos.
        UserSession existing = (UserSession) session.getAttribute("userSession");
        if (existing != null) {
            existing.updateActivity();
            // Sin esto, la modificación de updateActivity() NO se replica:
            session.setAttribute("userSession", existing); // ← NECESARIO
        }

        // ❌ MAL: Objetos grandes en sesión.
        // Una lista con miles de elementos puede ser varios MB de datos.
        // En DeltaManager, este delta se enviaría a TODOS los nodos en cada
        // petición que toque la sesión. Puede saturar la red interna del cluster.
        // session.setAttribute("reportData", largeList);

        // ❌ MAL: Objetos no serializables.
        // Una conexión de BD no puede serializarse. La replicación fallaría
        // con NotSerializableException. Nunca guardar recursos de sistema en sesión.
        // session.setAttribute("dbConnection", conn);

        // ❌ MAL: Streams, sockets, threads.
        // Por la misma razón: no implementan Serializable y no tienen sentido
        // fuera del proceso que los creó.
        // session.setAttribute("fileStream", fis);

        // ✅ BIEN: Usar request attributes para datos temporales
        // que solo se necesitan durante el procesamiento de la petición actual.
        // Los request attributes NO se replican (son locales a la petición).
        request.setAttribute("tempData", "valor temporal");

        // ✅ BIEN: Limpiar atributos de sesión cuando ya no son necesarios.
        // Reduce el tamaño de la sesión y el overhead de replicación.
        session.removeAttribute("temporalSetupData");

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @Override
    protected void doDelete(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {
        // ✅ BIEN: Invalidar la sesión al hacer logout.
        //
        // session.invalidate() hace tres cosas:
        // 1. Elimina la sesión del Manager local.
        // 2. En DeltaManager: propaga la invalidación a todos los nodos del cluster.
        //    Los demás nodos eliminan su copia de la sesión.
        // 3. Notifica a los HttpSessionListeners de contextDestroyed.
        //
        // Sin invalidate(), la sesión permanece en todos los nodos hasta
        // que expira por maxInactiveInterval, ocupando memoria innecesariamente.
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204
    }
}
```

## Activación del soporte de distribución en web.xml

Este es el paso más importante y más fácil de olvidar. Sin el elemento `<distributable/>`, **Tomcat ignora completamente el Cluster configurado en server.xml** para esa aplicación.

```xml
<!-- web.xml de la aplicación -->
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         version="6.0">

  <display-name>Mi App Cluster</display-name>

  <!--
    OBLIGATORIO para habilitar la replicación de sesiones.
    
    ¿Por qué es necesario declararlo?
    Tomcat asume que las aplicaciones no están diseñadas para clusters
    a menos que lo declaren explícitamente. Es un mecanismo de opt-in:
    la aplicación confirma que todos sus objetos de sesión son serializables
    y que el código es "cluster-aware".
    
    Sin <distributable/>:
    - El Cluster de server.xml existe pero no actúa sobre esta aplicación.
    - Las sesiones son locales al nodo (StandardManager en lugar de DeltaManager).
    - El jvmRoute sí se añade al JSESSIONID (útil para sticky sessions),
      pero las sesiones NO se replican si el nodo falla.
    
    Con <distributable/>:
    - Tomcat activa el Manager del Cluster (DeltaManager/BackupManager).
    - Las sesiones se replican automáticamente entre nodos.
    - Se REQUIERE que todos los objetos de sesión implementen Serializable.
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

# 9. Monitorización del Cluster

## JMX MBeans del Cluster

Tomcat expone información del estado del cluster y de las sesiones vía JMX, igual que hace con el pool de conexiones (Módulo 07).

```java
package com.miempresa.monitoring;

import javax.management.*;
import java.lang.management.ManagementFactory;
import java.util.Set;
import java.util.logging.Logger;

/**
 * Monitor del cluster Tomcat via JMX.
 * 
 * Las métricas más importantes a monitorizar en producción:
 * - activeSessions: Número actual de sesiones activas. Un crecimiento continuo
 *   sin descenso puede indicar connection leaks de sesión (no se invalidan).
 * - rejectedSessions: Sesiones rechazadas por haber alcanzado maxActiveSessions.
 *   Si este contador crece, el cluster no tiene capacidad suficiente.
 * - expiredSessions: Sesiones expiradas por timeout. Métrica de comportamiento normal.
 * - counterSend_EVT_SESSION_DELTA: Mensajes de replicación enviados.
 *   Un valor muy alto indica mucha actividad de escritura en sesión.
 */
public class ClusterMonitor {

    private static final Logger log =
        Logger.getLogger(ClusterMonitor.class.getName());

    public static void printClusterStats() throws Exception {
        MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();

        // ===== Estadísticas del Manager (DeltaManager) =====
        // El ObjectName "Catalina:type=Manager,*" devuelve un MBean
        // por cada aplicación desplegada que tenga un Manager activo.
        Set<ObjectName> managers = mbs.queryNames(
            new ObjectName("Catalina:type=Manager,*"),
            null
        );

        for (ObjectName name : managers) {
            String context       = name.getKeyProperty("context");
            int activeSessions   = (int)  mbs.getAttribute(name, "activeSessions");
            int expiredSessions  = (int)  mbs.getAttribute(name, "expiredSessions");
            int rejectedSessions = (int)  mbs.getAttribute(name, "rejectedSessions");
            long sessionCounter  = (long) mbs.getAttribute(name, "sessionCounter");
            int maxActive        = (int)  mbs.getAttribute(name, "maxActive");
            // maxActive: Pico máximo de sesiones activas simultáneas desde el arranque.
            // Útil para dimensionar la capacidad del cluster.

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

            // DeltaManager expone contadores específicos de replicación.
            // Pueden no existir si el Manager no es DeltaManager (por eso el try/catch).
            try {
                long nrOfMsgsRcv  = (long) mbs.getAttribute(name,
                    "counterReceive_EVT_SESSION_DELTA");
                // Mensajes delta recibidos de otros nodos: cambios de sesión
                // que este nodo procesó para mantener su copia actualizada.
                long nrOfMsgsSent = (long) mbs.getAttribute(name,
                    "counterSend_EVT_SESSION_DELTA");
                // Mensajes delta enviados a otros nodos: cuántos cambios de sesión
                // generó este nodo y replicó al resto del cluster.

                log.info(String.format(
                    "  Mensajes delta enviados:   %d%n" +
                    "  Mensajes delta recibidos:  %d",
                    nrOfMsgsSent, nrOfMsgsRcv));
            } catch (AttributeNotFoundException e) {
                // No es DeltaManager (puede ser BackupManager o StandardManager)
            }
        }

        // ===== Miembros del Cluster (nodos activos) =====
        Set<ObjectName> clusters = mbs.queryNames(
            new ObjectName("Catalina:type=Cluster,*"),
            null
        );

        for (ObjectName name : clusters) {
            log.info("Cluster MBean: " + name);
            try {
                // "members": Lista de nodos que el cluster considera activos.
                // Si un nodo cae o se añade, este array cambia.
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

## Script de diagnóstico del cluster

Este script verifica de forma automatizada el estado de todos los nodos del cluster. Ideal para ejecutar periódicamente via cron o integrarlo en pipelines de CI/CD y sistemas de alertas.

```bash
#!/bin/bash
# cluster-health-check.sh
# Verifica el estado de todos los nodos del cluster Tomcat

set -euo pipefail

# Configuración del cluster
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

    # CHECK 1: Verificar que el puerto TCP está accesible
    # nc (netcat) intenta una conexión TCP al puerto con timeout de 3 segundos.
    # Si el puerto no responde (Tomcat caído, firewall bloqueando), el check falla.
    if nc -z -w 3 "$NODE" "$HTTP_PORT" 2>/dev/null; then
        echo "  ✅ Puerto $HTTP_PORT accesible"
    else
        echo "  ❌ Puerto $HTTP_PORT NO accesible"
        ALL_OK=false
        continue  # Si el puerto no responde, no tiene sentido hacer los demás checks
    fi

    # CHECK 2: Health check HTTP de la aplicación
    # -s: Silencioso (sin barra de progreso)
    # -o /dev/null: Descartar el cuerpo de la respuesta
    # -w "%{http_code}": Solo mostrar el código HTTP de respuesta
    # --connect-timeout 5: Máximo 5 segundos para conectar
    # --max-time 10: Máximo 10 segundos para la respuesta completa
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
        --connect-timeout 5 --max-time 10 \
        "http://$NODE:$HTTP_PORT$HEALTH_PATH" 2>/dev/null || echo "000")
    # Si curl falla completamente (p.ej. por timeout), devuelve "000"

    if [ "$HTTP_STATUS" = "200" ]; then
        echo "  ✅ Health check OK (HTTP $HTTP_STATUS)"
    else
        echo "  ❌ Health check FALLO (HTTP $HTTP_STATUS)"
        ALL_OK=false
    fi

    # CHECK 3: Estadísticas del Manager via Manager API
    # Verifica que el Manager de Tomcat responde y muestra cuántas
    # aplicaciones están running/stopped.
    MANAGER_RESP=$(curl -s \
        -u "$MANAGER_USER:$MANAGER_PASS" \
        --connect-timeout 5 --max-time 10 \
        "http://$NODE:$HTTP_PORT/manager/text/list" 2>/dev/null || echo "ERROR")

    if echo "$MANAGER_RESP" | grep -q "OK"; then
        RUNNING=$(echo "$MANAGER_RESP" | grep -c ":running:" || true)
        STOPPED=$(echo "$MANAGER_RESP" | grep -c ":stopped:" || true)
        echo "  ✅ Manager accesible"
        echo "     Apps running: $RUNNING | stopped: $STOPPED"
    else
        echo "  ⚠️  Manager no accesible o error"
        # No marcar como fallo crítico: puede que el Manager esté desactivado
        # intencionalmente en producción por seguridad.
    fi

    # CHECK 4: Tiempo de respuesta del health check
    # %{time_total}: Tiempo total de la petición en segundos (con decimales).
    RESPONSE_TIME=$(curl -s -o /dev/null \
        -w "%{time_total}" \
        --connect-timeout 5 --max-time 10 \
        "http://$NODE:$HTTP_PORT$HEALTH_PATH" 2>/dev/null || echo "99")

    echo "  ⏱️  Tiempo de respuesta: ${RESPONSE_TIME}s"

    # Alerta si el health check tarda más de 2 segundos.
    # Un health check que debería ser instantáneo y tarda 2+ segundos
    # indica que el nodo está bajo presión (GC, BD lenta, CPU saturada).
    if (( $(echo "$RESPONSE_TIME > 2.0" | bc -l) )); then
        echo "  ⚠️  Tiempo de respuesta elevado — revisar carga del nodo"
    fi

    echo ""
done

# Resultado final del check del cluster completo.
# El script retorna exit code 0 si todo está bien, 1 si hay problemas.
# Esto permite que el script sea usado en pipelines CI/CD o
# sistemas de alertas (Nagios, Prometheus, etc.) que verifican el exit code.
echo "============================================="
if $ALL_OK; then
    echo " Estado del cluster: ✅ TODOS LOS NODOS OK"
    exit 0
else
    echo " Estado del cluster: ❌ ALGUNOS NODOS CON PROBLEMAS"
    exit 1
fi
```

# 10. Diferencias de Clustering entre Versiones de Tomcat

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

> ⚠️ **Multicast en Docker/Kubernetes:** El descubrimiento de nodos via multicast generalmente no funciona en entornos containerizados porque las redes de contenedores aíslan el tráfico de broadcast/multicast por diseño (para seguridad y rendimiento). En estos entornos es obligatorio usar `StaticMembershipService` (sección 8.11) o delegar las sesiones a Redis/Memcached.

**Virtual Threads en Tomcat 11:** Java 21 introduce los *Virtual Threads* (hilos virtuales), que son hilos extremadamente ligeros gestionados por la JVM. En Tomcat 11, el subsistema de replicación Tribes puede usar Virtual Threads para los mensajes del cluster, reduciendo el overhead de memoria asociado al mantenimiento de hilos del pool del Receiver. Especialmente beneficioso en clusters con muchos nodos y alta frecuencia de replicación.

# 11. Clustering en Kubernetes con StaticMembership

En Kubernetes, los pods tienen IPs dinámicas que cambian al reiniciarse. El descubrimiento multicast no funciona en la red de Kubernetes. La solución es `StaticMembershipService`, que lista los nodos del cluster de forma estática por hostname.

La clave es usar un **StatefulSet** en lugar de un Deployment: los StatefulSets asignan nombres predecibles y estables a los pods (`tomcat-0`, `tomcat-1`, `tomcat-2`), y con un *headless service* se pueden resolver por DNS: `tomcat-0.tomcat.default.svc.cluster.local`.

```xml
<!--
  StaticMembershipService: Define los nodos del cluster de forma estática.
  Alternativa a McastService para entornos donde multicast no está disponible.
  
  Cada nodo del cluster debe listar a TODOS los demás nodos.
  Si añades un cuarto nodo, debes actualizar la configuración de los tres
  existentes y reiniciarlos (o usar una herramienta de gestión de configuración).
-->
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
         channelSendOptions="8">

  <Manager className="org.apache.catalina.ha.session.DeltaManager"
           expireSessionsOnShutdown="false"
           notifyListenersOnReplication="true"/>

  <Channel className="org.apache.catalina.tribes.group.GroupChannel">

    <!-- Sin McastService — se usa StaticMembership -->
    <Membership
      className="org.apache.catalina.tribes.membership.StaticMembershipService"
      localMemberPort="4000"
      <!--
        Puerto donde este nodo escucha mensajes del cluster.
        Debe ser el mismo en todos los nodos para simplificar la configuración.
      -->
      expireTime="5000">
      <!--
        Tiempo en ms tras el cual un nodo se considera caído si no responde.
        Con StaticMembership, los nodos no se anuncian periódicamente como
        con multicast; TcpFailureDetector es quien detecta los fallos.
      -->

      <!-- Lista explícita de todos los nodos del cluster -->
      <Member className="org.apache.catalina.tribes.membership.StaticMember"
              port="4000"
              securePort="-1"
              <!--
                securePort=-1: Sin puerto TLS para mensajes Tribes.
                Para cifrar la comunicación del cluster, configurar un valor
                positivo y proporcionar los keystores correspondientes.
              -->
              host="tomcat-node01.default.svc.cluster.local"
              <!--
                En Kubernetes con StatefulSet + headless service:
                "tomcat-0.tomcat.default.svc.cluster.local"
                Formato: {pod-name}.{service-name}.{namespace}.svc.cluster.local
              -->
              domain="cluster"
              <!--
                Nombre lógico del cluster. Los nodos con diferente domain
                no se consideran parte del mismo cluster aunque compartan red.
                Útil para tener múltiples clusters independientes.
              -->
              uniqueId="{0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5}"/>
              <!--
                ID único del nodo en el cluster (16 bytes representados como array).
                DEBE ser único para cada nodo. Si dos nodos tienen el mismo uniqueId,
                el cluster los confunde y el comportamiento es impredecible.
              -->

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
# StatefulSet: tipo de recurso Kubernetes para aplicaciones con estado.
# A diferencia de Deployment (pods con nombres aleatorios y efímeros),
# StatefulSet garantiza:
# - Nombres de pod estables y predecibles: tomcat-0, tomcat-1, tomcat-2
# - DNS estable: tomcat-0.tomcat.default.svc.cluster.local
# - Orden de arranque y parada: los pods se crean y destruyen en orden
# Necesario para StaticMembership de Tribes, que necesita hostnames estables.
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: tomcat
  namespace: default
spec:
  serviceName: "tomcat"   # Referencia al headless service (ver abajo)
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
              name: cluster   # Puerto para comunicación Tribes entre nodos
          env:
            - name: CATALINA_OPTS
              value: >-
                -Xms1g -Xmx2g
                -XX:+UseG1GC
                -Dcluster.node.address=$(POD_IP)
            # POD_IP: La IP del pod actual inyectada automáticamente por Kubernetes.
            # Se usa en el Receiver address si se configura con ${cluster.node.address}.
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP

          # Readiness probe: ¿Puede este pod recibir tráfico?
          # Kubernetes no envía tráfico hasta que esta probe responda 200.
          # initialDelaySeconds=30: Esperar 30s antes del primer check (tiempo de arranque).
          # periodSeconds=10: Verificar cada 10 segundos.
          # failureThreshold=3: Marcar como "no listo" tras 3 fallos consecutivos.
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 3

          # Liveness probe: ¿Está vivo el proceso?
          # Kubernetes reinicia el pod si esta probe falla repetidamente.
          # initialDelaySeconds=60: Más tiempo que readiness para que el GC
          # no interfiera en las primeras comprobaciones.
          livenessProbe:
            httpGet:
              path: /health/live
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 30
            failureThreshold: 3

          resources:
            requests:
              memory: "1.5Gi"   # Memoria garantizada por Kubernetes
              cpu: "500m"       # 0.5 vCPU garantizado (500 millicores)
            limits:
              memory: "3Gi"     # Nunca superar 3 GB (OOMKill si se supera)
              cpu: "2000m"      # Nunca superar 2 vCPU

# Service headless: Necesario para que los pods tengan DNS estables.
# clusterIP: None hace que el Service no tenga IP virtual; en su lugar,
# el DNS devuelve directamente las IPs de los pods.
# Esto permite resolver: tomcat-0.tomcat.default.svc.cluster.local → IP del pod 0
apiVersion: v1
kind: Service
metadata:
  name: tomcat
  namespace: default
spec:
  clusterIP: None  # Headless service — sin IP virtual
  selector:
    app: tomcat
  ports:
    - port: 8080
      name: http
    - port: 4000
      name: cluster

# Service para tráfico externo (con IP virtual y balanceo nativo de Kubernetes)
# type: LoadBalancer solicita a la plataforma cloud (AWS, GCP, Azure)
# que provisione un balanceador de carga externo apuntando a los pods.
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

# 12. Puntos Clave

- El **`<distributable/>`** en `web.xml` es **obligatorio** para activar la replicación de sesiones. Sin él, el Cluster configurado en `server.xml` no replica las sesiones de esa aplicación aunque todo lo demás esté correctamente configurado.

- **DeltaManager** replica cambios a todos los nodos (all-to-all). Con N nodos, cada modificación de sesión genera N-1 mensajes de red. Adecuado para clusters de hasta 6 nodos. Con más nodos, el overhead se vuelve significativo.

- **BackupManager** replica solo a un nodo de backup. Menor overhead pero menor redundancia. Adecuado para clusters de más de 6 nodos donde el overhead all-to-all de DeltaManager es inaceptable.

- Todos los objetos almacenados en sesión **deben implementar `Serializable`** con `serialVersionUID` explícito. Objetos no serializables causan errores de replicación silenciosos o excepciones en producción. El test de serialización de la sección 8.6.2 debe ejecutarse en cada release.

- El atributo **`jvmRoute`** del Engine es crítico para las sticky sessions. Debe ser único en cada nodo y coincidir exactamente con el `route` configurado en el balanceador. Si son diferentes, las sticky sessions no funcionan.

- **Multicast no funciona en Docker/Kubernetes** por defecto debido al aislamiento de red de los contenedores. En estos entornos usar `StaticMembershipService` con los hostnames estables del StatefulSet, o externalizar las sesiones a Redis.

- Para clusters grandes o arquitecturas cloud-native, **Redis con Redisson** es la solución más robusta. Elimina completamente la comunicación P2P entre nodos Tomcat, simplifica el scaling horizontal y no requiere multicast ni descubrimiento de nodos.

- El **`ReplicationValve`** con el atributo `filter` debe excluir los recursos estáticos (imágenes, CSS, JS, fuentes) para evitar que cada petición de recurso estático dispare innecesariamente una comprobación de replicación.

- En Kubernetes usar siempre **StatefulSet** (no Deployment) para garantizar hostnames estables necesarios para la comunicación del cluster Tribes vía `StaticMembershipService`.

- **Cuando se modifica un objeto mutable ya guardado en sesión**, se debe llamar a `session.setAttribute()` de nuevo para que DeltaManager detecte el cambio y lo replique. Modificar el interior del objeto sin llamar a `setAttribute()` no dispara la replicación.

- Los health check endpoints `/health/live` (liveness) y `/health/ready` (readiness) son imprescindibles para que el balanceador retire nodos no disponibles del pool de forma automática sin intervención humana.