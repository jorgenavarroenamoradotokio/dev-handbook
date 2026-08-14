> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Metodología de Tuning: Enfoque Sistemático](#1-metodología-de-tuning-enfoque-sistemático)
  - [¿Qué significa hacer "tuning" y por qué hay que hacerlo bien?](#qué-significa-hacer-tuning-y-por-qué-hay-que-hacerlo-bien)
  - [Jerarquía de cuellos de botella: ¿por dónde empezar a buscar?](#jerarquía-de-cuellos-de-botella-por-dónde-empezar-a-buscar)
- [2. Tuning de la JVM](#2-tuning-de-la-jvm)
    - [¿Por qué ajustar la JVM y no solo Tomcat?](#por-qué-ajustar-la-jvm-y-no-solo-tomcat)
  - [Configuración de Heap y Garbage Collector](#configuración-de-heap-y-garbage-collector)
  - [Comparativa de Garbage Collectors para Tomcat](#comparativa-de-garbage-collectors-para-tomcat)
- [3. Tuning del Conector HTTP](#3-tuning-del-conector-http)
  - [Dimensionamiento del pool de hilos](#dimensionamiento-del-pool-de-hilos)
  - [Análisis de keep-alive vs nuevas conexiones](#análisis-de-keep-alive-vs-nuevas-conexiones)
- [4. Tuning de JSP y Recursos Estáticos](#4-tuning-de-jsp-y-recursos-estáticos)
  - [Pre-compilación de JSPs](#pre-compilación-de-jsps)
    - [¿Por qué las primeras peticiones a JSPs son lentas?](#por-qué-las-primeras-peticiones-a-jsps-son-lentas)
  - [Caché de recursos estáticos del DefaultServlet](#caché-de-recursos-estáticos-del-defaultservlet)
- [5. Monitorización con JMX](#5-monitorización-con-jmx)
  - [¿Qué es JMX y para qué sirve en Tomcat?](#qué-es-jmx-y-para-qué-sirve-en-tomcat)
  - [Configuración de JMX Remoto](#configuración-de-jmx-remoto)
  - [Catálogo completo de MBeans de Tomcat](#catálogo-completo-de-mbeans-de-tomcat)
- [6 Profiling con Java Flight Recorder (JFR)](#6-profiling-con-java-flight-recorder-jfr)
  - [¿Qué es JFR y por qué es la herramienta de profiling preferida en producción?](#qué-es-jfr-y-por-qué-es-la-herramienta-de-profiling-preferida-en-producción)
  - [Uso de JFR](#uso-de-jfr)
  - [Análisis de JFR con la herramienta jfr CLI](#análisis-de-jfr-con-la-herramienta-jfr-cli)
- [7 Herramientas de Load Testing](#7-herramientas-de-load-testing)
  - [¿Para qué sirve el load testing?](#para-qué-sirve-el-load-testing)
  - [Apache JMeter — Plan de prueba para Tomcat](#apache-jmeter--plan-de-prueba-para-tomcat)
  - [wrk — Load testing de alto rendimiento](#wrk--load-testing-de-alto-rendimiento)
- [8. Integración con Prometheus y Grafana](#8-integración-con-prometheus-y-grafana)
  - [¿Qué es Prometheus y cómo encaja con Tomcat?](#qué-es-prometheus-y-cómo-encaja-con-tomcat)
  - [Exposición de métricas con JMX Exporter](#exposición-de-métricas-con-jmx-exporter)
  - [Dashboard Grafana — Métricas clave](#dashboard-grafana--métricas-clave)
- [9. Script de Diagnóstico de Rendimiento Completo](#9-script-de-diagnóstico-de-rendimiento-completo)
- [10. Tabla de Referencia Rápida de Tuning](#10-tabla-de-referencia-rápida-de-tuning)
- [11. Diferencias de Rendimiento y Monitorización entre Versiones](#11-diferencias-de-rendimiento-y-monitorización-entre-versiones)
- [12. Puntos Clave](#12-puntos-clave)


# 1. Metodología de Tuning: Enfoque Sistemático

## ¿Qué significa hacer "tuning" y por qué hay que hacerlo bien?

"Tuning" es el proceso de ajustar la configuración de Tomcat y la JVM para que el servidor rinda mejor: responda más rápido, aguante más carga, consuma menos memoria, o todo a la vez.

El error más común es aplicar configuraciones copiadas de internet sin medir primero. Un ajuste que funciona perfectamente en el servidor de otra empresa puede empeorar el rendimiento en el tuyo, porque el problema que ellos tenían no es el mismo que tienes tú.

La regla de oro del tuning es: **primero medir, después cambiar, después volver a medir**.

```
┌─────────────────────────────────────────────────────────────────┐
│              Ciclo de Tuning de Tomcat                          │
│                                                                 │
│  1. MEDIR    → ¿Cuánto tarda? ¿Cuánta CPU? ¿Cuánta memoria?     │
│       ↓         Establece un "baseline" con carga real          │
│  2. ANALIZAR → ¿Dónde está el cuello de botella?                │
│       ↓         ¿BD? ¿GC? ¿Hilos? ¿CPU?                         │
│  3. AJUSTAR  → Modifica UN parámetro a la vez                   │
│       ↓         Si cambias varios a la vez, no sabes qué ayudó  │
│  4. VALIDAR  → Mide de nuevo con la MISMA carga                 │
│       ↓         ¿Mejoró? ¿Empeoró? ¿Cuánto?                     │
│  5. DOCUMENTAR → Registra qué cambiaste y por qué               │
│       └────────────────────────────────────────────────┐        │
│                                              ¿Suficiente?       │
│                                         Sí → Producción         │
│                                         No → Volver al paso 2   │
└─────────────────────────────────────────────────────────────────┘
```

## Jerarquía de cuellos de botella: ¿por dónde empezar a buscar?

Antes de tocar ningún parámetro de Tomcat, conviene conocer el orden de frecuencia con que aparecen los problemas de rendimiento en aplicaciones Java web. Empezar siempre por arriba:

```
1. Base de datos          → Queries lentas, pool de conexiones agotado, deadlocks
                            (causa el 60-70% de los problemas de rendimiento)

2. JVM Heap / GC          → El recolector de basura pausa la aplicación,
                            memory leaks que van consumiendo RAM hasta OOM

3. Pool de hilos          → maxThreads muy bajo, todas las peticiones esperando
                            cola llena bajo picos de tráfico

4. I/O de red             → Latencia alta, buffers mal configurados,
                            conexiones keep-alive no aprovechadas

5. CPU                    → Código Java ineficiente, serialización/deserialización
                            costosa (JSON, XML)

6. Configuración Tomcat   → Timeouts, compresión, parámetros del conector
                            (afectan al rendimiento pero raramente son LA causa)
```

> 💡 Si las consultas a tu base de datos tardan 2 segundos cada una, aumentar `maxThreads` de 200 a 400 solo significa que ahora tienes el doble de hilos esperando esos 2 segundos. El problema sigue siendo la BD.

# 2. Tuning de la JVM

### ¿Por qué ajustar la JVM y no solo Tomcat?

Tomcat corre dentro de la JVM (Java Virtual Machine). La JVM gestiona la memoria de todos los objetos Java que crea tu aplicación. Si la JVM está mal configurada, puedes tener problemas graves independientemente de cómo esté configurado Tomcat:

- **Demasiado poco heap:** la aplicación se queda sin memoria y lanza `OutOfMemoryError`
- **Demasiado heap:** el Garbage Collector tarda más en hacer su trabajo, causando pausas largas
- **GC mal elegido:** pausas frecuentes que "congelan" la aplicación durante varios cientos de milisegundos

## Configuración de Heap y Garbage Collector

Todo lo siguiente va en `$CATALINA_BASE/bin/setenv.sh`:

```bash
#!/bin/bash
# $CATALINA_BASE/bin/setenv.sh — Tuning JVM para Producción

# ============================================================
# HEAP SIZING: cuánta memoria reservar para los objetos Java
# ============================================================
# El "heap" es la zona de memoria donde Java aloja los objetos.
# -Xms: tamaño inicial del heap (reservado al arrancar)
# -Xmx: tamaño máximo que puede alcanzar el heap
#
# REGLA: Poner Xms = Xmx en producción.
# Si Xms < Xmx, la JVM empieza con heap pequeño y va creciendo
# a medida que la app necesita más memoria. Cada expansión del
# heap causa una pausa del GC. Ponerlos iguales elimina esas
# pausas de expansión y hace el comportamiento más predecible.
#
# ¿Cuánto asignar?
# Regla general: 75-80% de la RAM disponible del servidor.
# Dejar margen para: el propio SO, Metaspace (ver abajo),
# Direct Memory (buffers NIO), y los stacks de los hilos.
#
# Ejemplo: servidor con 8 GB de RAM → Heap = 6 GB

CATALINA_OPTS="$CATALINA_OPTS -Xms6g"  # Tamaño inicial del heap
CATALINA_OPTS="$CATALINA_OPTS -Xmx6g"  # Tamaño máximo del heap

# ============================================================
# METASPACE: donde Java guarda la "descripción" de las clases
# ============================================================
# El Metaspace (antes llamado "PermGen" en Java 7 y anteriores)
# almacena los metadatos de las clases cargadas: nombres de métodos,
# firmas, información de reflexión, proxies dinámicos, etc.
# Es diferente al heap y tiene su propio límite.
#
# Sin MaxMetaspaceSize, puede crecer indefinidamente y consumir
# toda la RAM disponible. Hay que poner siempre un límite.

CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=256m"
# Tamaño inicial del Metaspace. Si la app necesita más,
# el GC tendrá que hacer una recarga completa de clases.
# Empezar en 256m evita esa recarga inicial.

CATALINA_OPTS="$CATALINA_OPTS -XX:MaxMetaspaceSize=512m"
# Límite máximo. Aumentar si la app carga muchas librerías
# o usa mucho frameworks de reflexión (Spring, Hibernate, etc.)

# ============================================================
# DIRECT MEMORY: memoria fuera del heap para buffers NIO
# ============================================================
# Los conectores NIO de Tomcat usan "Direct Memory" (fuera del
# heap) para los buffers de red. Establecer un límite evita
# consumo excesivo de memoria nativa.

CATALINA_OPTS="$CATALINA_OPTS -XX:MaxDirectMemorySize=1g"

# ============================================================
# STACK SIZE: tamaño del stack por hilo
# ============================================================
# Cada hilo tiene su propio stack para almacenar llamadas a métodos.
# El valor por defecto es 512k-1MB dependiendo de la plataforma.
# Si tienes muchos hilos (maxThreads=400), cada KB que ahorras
# en el stack se multiplica por 400.
# 512k es suficiente para la mayoría de aplicaciones web.

CATALINA_OPTS="$CATALINA_OPTS -Xss512k"

# ============================================================
# GARBAGE COLLECTOR (GC): el recolector de basura
# ============================================================
# El GC se encarga de liberar la memoria de los objetos Java que
# ya no se usan. Hay varios algoritmos con diferentes características.
# El más recomendado para servidores web es G1GC.

# --- G1GC (Garbage First GC) — Recomendado para Tomcat ---
# Es el GC por defecto desde Java 9. Diseñado para balancear
# throughput (velocidad total) y latencia (pausas cortas).
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"

CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=200"
# Objetivo de pausa máxima del GC en milisegundos.
# G1GC intentará (sin garantía absoluta) que ninguna pausa
# dure más de 200ms. Si el servidor recibe peticiones cada
# 50ms y el GC hace una pausa de 200ms, el usuario sentirá
# la pausa como un lag de 200ms.

CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m"
# G1GC divide el heap en "regiones" del mismo tamaño.
# 16MB es un buen valor para heaps entre 6-16 GB.
# Debe ser potencia de 2 (1, 2, 4, 8, 16, 32 MB).

CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=45"
# Cuando el heap está al 45% de uso, G1GC inicia el ciclo
# de recolección concurrente (que no pausa la app).
# Reducir este valor si tienes muchas pausas "Full GC".

CATALINA_OPTS="$CATALINA_OPTS -XX:G1NewSizePercent=20"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1MaxNewSizePercent=40"
# Porcentaje del heap reservado para objetos nuevos ("young gen").
# La mayoría de objetos en una app web son de vida corta
# (objetos de petición), así que el young gen tiene mucho trabajo.

CATALINA_OPTS="$CATALINA_OPTS -XX:G1ReservePercent=10"
# Reserva el 10% del heap para situaciones de emergencia.
# Reduce la probabilidad de "evacuation failure" (cuando G1GC
# no puede mover objetos y cae a una Full GC bloqueante).

CATALINA_OPTS="$CATALINA_OPTS -XX:+UseStringDeduplication"
# G1GC puede detectar Strings con el mismo contenido y
# hacer que compartan la misma memoria interna.
# En aplicaciones con muchos Strings repetidos (URLs, valores
# de BD, JSON) puede ahorrar 10-20% del heap.

# --- ZGC — Para aplicaciones con requisitos de latencia muy baja ---
# ZGC mantiene pausas menores de 1ms incluso con heaps de TB.
# Úsalo si necesitas latencias sub-milisegundo (APIs de trading,
# gaming, real-time). Requiere Java 15+ (estable).
# CATALINA_OPTS="$CATALINA_OPTS -XX:+UseZGC"
# CATALINA_OPTS="$CATALINA_OPTS -XX:+ZGenerational"  # Java 21+: mejor throughput

# --- Shenandoah GC — Alternativa a ZGC en OpenJDK ---
# Similar a ZGC: pausas muy bajas. Solo disponible en OpenJDK.
# CATALINA_OPTS="$CATALINA_OPTS -XX:+UseShenandoahGC"

# ============================================================
# GC LOGGING: registrar lo que hace el GC
# ============================================================
# El log del GC es ESENCIAL para diagnosticar problemas de memoria.
# Sin este log, es muy difícil saber si el GC está causando problemas.
# Este formato es para Java 9+ (Unified Logging).
#
# Qué significan los parámetros:
#   gc*             → todos los eventos relacionados con GC
#   gc+heap=debug   → nivel debug para eventos de heap
#   gc+phases=debug → nivel debug para las fases del GC
#   file=...        → archivo donde guardar el log
#   time,uptime,level,tags → formato de cada línea
#   filecount=10    → mantener los últimos 10 archivos
#   filesize=50m    → cada archivo tiene máximo 50 MB

CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*,gc+heap=debug,gc+phases=debug\
:file=${CATALINA_BASE}/logs/gc.log\
:time,uptime,level,tags\
:filecount=10,filesize=50m"

# ============================================================
# JIT COMPILER: optimización del código en tiempo de ejecución
# ============================================================
# La JVM compila el código Java a código nativo de la CPU mientras
# el programa corre (Just-In-Time compilation). Estas opciones
# le ayudan a hacerlo más eficientemente.

CATALINA_OPTS="$CATALINA_OPTS -server"
# Activa las optimizaciones orientadas a procesos de larga duración.
# La JVM invierte más tiempo compilando para obtener código más
# rápido. Esencial en producción.

CATALINA_OPTS="$CATALINA_OPTS -XX:+OptimizeStringConcat"
# Optimiza las concatenaciones de Strings con el operador +.

CATALINA_OPTS="$CATALINA_OPTS -XX:+UseCompressedOops"
# Usa punteros de 32 bits en heaps < 32 GB, ahorrando memoria.
# Activo por defecto cuando el heap es < 32 GB.

CATALINA_OPTS="$CATALINA_OPTS -XX:+UseCompressedClassPointers"
# Similar a lo anterior, para los punteros a clases.

CATALINA_OPTS="$CATALINA_OPTS -XX:CICompilerCount=4"
# Número de hilos del compilador JIT. 4 es apropiado para
# servidores con 4-8 núcleos. Aumentar en servidores más grandes.

# ============================================================
# DIAGNÓSTICO Y SAFETY NETS: red de seguridad
# ============================================================

# Heap dump automático en OutOfMemoryError
# Cuando la JVM se queda sin memoria, genera automáticamente un archivo
# "heap dump" con todos los objetos que había en memoria.
# Puedes analizarlo después con herramientas como Eclipse MAT o
# VisualVM para descubrir qué estaba consumiendo la memoria.
CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=${CATALINA_BASE}/logs/"
# El archivo se llama heapdump-<pid>.hprof y puede ser varios GB.

# Acción en OutOfMemoryError: matar el proceso
# Tras un OOM, el proceso Java puede quedar en estado inconsistente
# (algunos hilos pueden seguir corriendo, otros habrán fallado).
# Es más seguro matar el proceso limpiamente y dejar que systemd
# lo reinicie desde cero.
CATALINA_OPTS="$CATALINA_OPTS -XX:OnOutOfMemoryError='kill -9 %p'"

# Flight Recorder: activo en todo momento (ver sección 9.6)
# Graba continuamente los últimos 24h de métricas con overhead < 1%
CATALINA_OPTS="$CATALINA_OPTS -XX:+FlightRecorder"
CATALINA_OPTS="$CATALINA_OPTS -XX:StartFlightRecording=\
duration=0,\
filename=${CATALINA_BASE}/logs/tomcat.jfr,\
settings=profile,\
maxsize=256m,\
maxage=24h,\
name=TomcatRecording"

# ============================================================
# ENCODING, TIMEZONE Y MISC
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Dsun.jnu.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Europe/Madrid"
CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"
# /dev/./urandom evita bloqueos en la generación de números aleatorios
# (usados para generar IDs de sesión) en servidores Linux sin suficiente
# "entropía" de hardware.

CATALINA_OPTS="$CATALINA_OPTS -Dsun.net.inetaddr.ttl=60"
# Re-resolver DNS cada 60 segundos. Sin esto Java cachea DNS
# indefinidamente, lo que puede causar problemas si una IP cambia
# (failover de base de datos, cambios de DNS).

export CATALINA_OPTS
```

## Comparativa de Garbage Collectors para Tomcat

¿Cuál elegir? Esta tabla resume las características más relevantes para tomar la decisión:

| GC         | Latencia (pausas) | Throughput     | Pausa máx típica | Java mínimo | Cuándo usarlo                      |
|------------|-------------------|----------------|------------------|-------------|------------------------------------|
| G1GC       | Media (acceptable)| Alto           | ~100-300ms       | Java 9      | La gran mayoría de casos en producción |
| ZGC        | Muy baja          | Medio-alto     | <1ms             | Java 15     | APIs donde cada milisegundo importa|
| Shenandoah | Muy baja          | Medio          | <1ms             | Java 12     | Alternativa a ZGC en OpenJDK       |
| ParallelGC | Alta              | Muy alto       | Variable (seg)   | Java 8      | Procesamiento batch sin usuarios   |
| SerialGC   | Variable          | Bajo           | Variable         | Java 8      | Solo para JVMs con 1 CPU           |

**Regla práctica:**
- Para una aplicación web normal → **G1GC** (ya es el default de Java 9+, no hay que hacer nada)
- Para APIs de trading, gaming o cualquier cosa donde una pausa de 200ms sea inaceptable → **ZGC**
- Si dudas → **G1GC**

# 3. Tuning del Conector HTTP

## Dimensionamiento del pool de hilos

El pool de hilos es el conjunto de hilos Java disponibles para procesar peticiones HTTP. Si llegan más peticiones simultáneas que hilos disponibles, las peticiones extra esperan en la cola (`acceptCount`). Si la cola también se llena, nuevas peticiones son rechazadas.

**¿Cómo calcular el `maxThreads` correcto?**

```
Fórmula:
maxThreads = TPS_objetivo × tiempo_medio_respuesta_en_segundos + margen_seguridad

Ejemplo concreto:
  Objetivo: manejar 500 peticiones por segundo (TPS)
  Tiempo medio de respuesta: 200ms = 0.2 segundos

  Hilos necesarios = 500 × 0.2 = 100 hilos activos

  Pero no todos los hilos estarán al 100% de uso simultáneo.
  Añadir un 25-30% de margen de seguridad:

  maxThreads recomendado = 100 × 1.25 = 125 → usar 150-200

IMPORTANTE: Aumentar maxThreads NO mejora el rendimiento
si el cuello de botella es la base de datos o la CPU.
Si cada petición tarda 2 segundos porque la BD es lenta,
tener 400 hilos solo significa 400 hilos esperando a la BD.
El throughput total no mejora.

Rango típico de producción: 200-400 hilos
Si necesitas más de 500: investiga por qué las peticiones son lentas
```

```xml
<!-- Conector HTTP con pool de hilos compartido y optimizado para producción -->

<!-- Primero declaramos el Executor (pool de hilos) -->
<Executor name="tomcatThreadPool"
          namePrefix="catalina-exec-"
          <!-- Prefijo del nombre de cada hilo: útil para identificarlos
               en herramientas de monitorización y en thread dumps -->

          maxThreads="300"
          <!-- Máximo de peticiones procesándose simultáneamente -->

          minSpareThreads="30"
          <!-- Hilos siempre en standby. Cuando llega una ráfaga de
               tráfico, estos hilos reaccionan inmediatamente sin
               esperar a que se creen nuevos. -->

          maxSpareThreads="100"
          <!-- Si hay más de 100 hilos ociosos, Tomcat los termina
               para liberar memoria. -->

          maxQueueSize="200"
          <!-- Si todos los hilos están ocupados, las nuevas peticiones
               entran en esta cola. Si la cola se llena, se rechaza la
               petición con error. Nunca poner -1 (sin límite): con una
               cola ilimitada, bajo ataque DoS el servidor puede quedarse
               sin memoria acumulando peticiones. -->

          prestartminSpareThreads="true"
          <!-- Crear los minSpareThreads al arrancar, no en la primera
               petición. Las primeras peticiones tienen latencia normal. -->

          maxIdleTime="60000"
          <!-- Un hilo en exceso (más de minSpareThreads) que lleve 60s
               sin trabajo se termina para liberar memoria. -->

          threadPriority="5"
          daemon="true"
          className="org.apache.catalina.core.StandardThreadExecutor"/>

<!-- El Connector usa el Executor compartido -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="tomcatThreadPool"

           maxConnections="10000"
           <!-- Conexiones TCP simultáneas totales. Con NIO, un hilo puede
                vigilar miles de conexiones inactivas (keep-alive). Este
                valor puede ser mucho mayor que maxThreads. -->

           acceptCount="300"
           <!-- Cola del SO para conexiones cuando maxConnections se alcanza -->

           connectionTimeout="15000"
           <!-- 15s para recibir la primera línea HTTP -->

           keepAliveTimeout="20000"
           <!-- Mantener conexiones keep-alive abiertas 20s entre peticiones -->

           maxKeepAliveRequests="200"
           <!-- Máximo de peticiones por conexión keep-alive -->

           URIEncoding="UTF-8"
           maxHttpHeaderSize="16384"
           maxPostSize="10485760"
           maxParameterCount="1000"

           compression="on"
           compressionMinSize="1024"
           compressibleMimeType="text/html,text/xml,text/plain,
                                  text/css,text/javascript,
                                  application/json,application/xml,
                                  application/javascript"

           server="Apache"
           rejectIllegalHeader="true"

           acceptorThreadCount="2"
           pollerThreadCount="2"
           selectorTimeout="1000"

           redirectPort="8443"/>
```

## Análisis de keep-alive vs nuevas conexiones

Keep-alive es una técnica donde el cliente y el servidor reutilizan la misma conexión TCP para varias peticiones HTTP. Sin keep-alive, cada recurso de una página (CSS, JS, imagen) requiere abrir y cerrar una conexión TCP, lo que añade latencia y carga al servidor.

Si keep-alive no está funcionando correctamente, verás muchas conexiones `TIME_WAIT` acumulándose en el servidor:

```bash
# Ver las conexiones activas al puerto 8080
ss -tn state established '( dport = :8080 or sport = :8080 )'

# Ver un resumen del estado de todas las conexiones TCP
ss -s

# Contar cuántas conexiones están en estado TIME_WAIT
# (esperando que expire el timeout de cierre de TCP)
ss -tn | grep TIME-WAIT | wc -l
# Si este número crece continuamente hasta miles, keep-alive
# no está siendo efectivo: los clientes están cerrando conexiones
# en lugar de reutilizarlas.

# Si hay muchas TIME_WAIT, ajustar estos parámetros del kernel Linux:
echo 1    > /proc/sys/net/ipv4/tcp_tw_reuse
# Permite reutilizar conexiones TIME_WAIT para nuevas conexiones

echo 30   > /proc/sys/net/ipv4/tcp_fin_timeout
# Reducir de 60s (default) a 30s el tiempo que una conexión
# cerrada permanece en TIME_WAIT

echo 2    > /proc/sys/net/ipv4/tcp_keepalive_time
# Verificar conexiones idle cada 2 minutos (default 2h)
```

# 4. Tuning de JSP y Recursos Estáticos

## Pre-compilación de JSPs

### ¿Por qué las primeras peticiones a JSPs son lentas?

Cuando un usuario accede por primera vez a una página JSP, Tomcat tiene que:
1. Leer el archivo `.jsp`
2. Convertirlo a código Java (un Servlet)
3. Compilar ese código Java a bytecode (`.class`)
4. Cargar el `.class` en memoria
5. Ejecutarlo para generar el HTML

Los pasos 2 y 3 pueden tardar varios segundos para JSPs complejos. Las peticiones siguientes son instantáneas porque Tomcat reutiliza el `.class` compilado.

En producción, este retraso en la primera petición es inaceptable. La solución es **pre-compilar los JSPs durante el build**, antes de desplegar, para que ya estén compilados cuando llegue el primer usuario.

Además, hay parámetros del Servlet JSP que mejoran el comportamiento en producción:

```xml
<!-- En conf/web.xml global de Tomcat — configurar el JspServlet -->
<servlet>
    <servlet-name>jsp</servlet-name>
    <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>

    <init-param>
        <param-name>development</param-name>
        <param-value>false</param-value>
        <!-- CLAVE: false en producción.
             En modo "development=true" (el default), Tomcat comprueba
             en CADA petición si el .jsp ha cambiado para recompilarlo.
             Eso añade una operación de sistema de archivos a cada petición.
             En producción los JSPs no cambian, así que false ahorra esa
             comprobación en cada petición. -->
    </init-param>

    <init-param>
        <param-name>trimSpaces</param-name>
        <param-value>true</param-value>
        <!-- Elimina espacios en blanco y saltos de línea innecesarios
             del HTML generado. Reduce el tamaño de la respuesta. -->
    </init-param>

    <init-param>
        <param-name>enablePooling</param-name>
        <param-value>true</param-value>
        <!-- Reutiliza objetos internos de evaluación de expresiones EL
             en lugar de crear nuevos en cada petición. Reduce el trabajo
             del GC. -->
    </init-param>

    <init-param>
        <param-name>genStrAsCharArray</param-name>
        <param-value>false</param-value>
        <!-- false: el texto estático de los JSPs se genera como Strings.
             true: como arrays de char (puede ser más eficiente en casos
             específicos pero raramente hace diferencia). -->
    </init-param>

    <init-param>
        <param-name>compilerTargetVM</param-name>
        <param-value>17</param-value>
        <!-- Versión de Java de destino para la compilación de JSPs.
             Debe coincidir con la versión de Java que usa Tomcat. -->
    </init-param>

    <init-param>
        <param-name>compilerSourceVM</param-name>
        <param-value>17</param-value>
    </init-param>

    <load-on-startup>3</load-on-startup>
    <!-- Inicializar el JspServlet al arrancar Tomcat, no en la primera
         petición. El número indica el orden de inicialización. -->
</servlet>
```

```bash
# Pre-compilar JSPs manualmente con JspC (el compilador de JSPs de Tomcat)
# Esto se hace durante el proceso de build, antes de crear el WAR.
$JAVA_HOME/bin/java \
  -classpath "$CATALINA_HOME/lib/jasper.jar:\
              $CATALINA_HOME/lib/jsp-api.jar:\
              $CATALINA_HOME/lib/el-api.jar:\
              $CATALINA_HOME/lib/servlet-api.jar" \
  org.apache.jasper.JspC \
  -webapp /opt/apps/myapp \   # Directorio de la aplicación
  -d /tmp/jspc-output \       # Directorio de salida para los .java y .class generados
  -p com.miempresa.jsp \      # Paquete Java para las clases generadas
  -compile \                  # Compilar a .class además de generar .java
  -source 17 \                # Versión de Java fuente
  -target 17                  # Versión de Java destino
```

## Caché de recursos estáticos del DefaultServlet

El **DefaultServlet** es el Servlet de Tomcat que sirve los archivos estáticos de las aplicaciones: HTML, CSS, JavaScript, imágenes, fuentes. Tiene un sistema de caché en memoria que puede acelerar significativamente la entrega de recursos estáticos:

```xml
<!-- En conf/web.xml global de Tomcat -->
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>

    <init-param>
        <param-name>listings</param-name>
        <param-value>false</param-value>
        <!-- IMPORTANTE: false en producción.
             Si true, cuando un usuario accede a un directorio sin
             index.html, Tomcat muestra una lista de todos los archivos.
             Esto es un riesgo de seguridad (revela la estructura interna)
             y nunca debe estar activo en producción. -->
    </init-param>

    <init-param>
        <param-name>cacheTtl</param-name>
        <param-value>5000</param-value>
        <!-- Tiempo en milisegundos que Tomcat mantiene los metadatos de
             un archivo en caché (tamaño, fecha de modificación).
             5000ms = 5 segundos. Si el archivo cambia, Tomcat lo detectará
             en la siguiente petición pasados 5s. En producción los archivos
             no cambian, así que se puede poner más alto (30000ms). -->
    </init-param>

    <init-param>
        <param-name>cacheMaxSize</param-name>
        <param-value>102400</param-value>
        <!-- Tamaño máximo total del caché de recursos en KB.
             102400 KB = 100 MB. Tomcat guarda en memoria los archivos
             estáticos más frecuentemente accedidos hasta este límite.
             Ajustar según la RAM disponible y el tamaño de los recursos. -->
    </init-param>

    <init-param>
        <param-name>cacheObjectMaxSize</param-name>
        <param-value>512</param-value>
        <!-- Tamaño máximo de un archivo individual que se guarda en caché.
             512 KB. Archivos más grandes (videos, ZIPs grandes) no se
             cachean para no desperdiciar memoria en objetos enormes. -->
    </init-param>

    <init-param>
        <param-name>input</param-name>
        <param-value>4096</param-value>
        <!-- Tamaño del buffer de lectura en KB al leer archivos del disco. -->
    </init-param>

    <init-param>
        <param-name>output</param-name>
        <param-value>4096</param-value>
        <!-- Tamaño del buffer de escritura en KB al enviar al cliente. -->
    </init-param>

    <init-param>
        <param-name>useAcceptRanges</param-name>
        <param-value>true</param-value>
        <!-- Habilita las peticiones de rango (Range requests).
             Esto permite a los clientes descargar solo una parte de un archivo
             (útil para reanudar descargas o para streaming de video). -->
    </init-param>

    <init-param>
        <param-name>gzip</param-name>
        <param-value>true</param-value>
        <!-- Servir versiones pre-comprimidas (.gz) de los archivos estáticos
             si existen junto al original. Esto es más eficiente que comprimir
             en tiempo real con el Connector: el archivo se comprime una vez
             durante el build y se sirve ya comprimido. -->
    </init-param>

    <load-on-startup>1</load-on-startup>
</servlet>
```

> 💡 **Consideración importante:** Si tienes Nginx u otro proxy sirviendo los archivos estáticos directamente (lo cual es el patrón recomendado para producción), la configuración del DefaultServlet tiene menos impacto porque esos archivos nunca llegan a Tomcat.

# 5. Monitorización con JMX

## ¿Qué es JMX y para qué sirve en Tomcat?

**JMX** (Java Management Extensions) es un sistema estándar de Java para exponer métricas y controles de una aplicación en ejecución. Tomcat usa JMX extensamente: expone cientos de métricas en tiempo real sobre su estado interno.

Estas métricas se organizan en **MBeans** (Management Beans): objetos Java accesibles remotamente que representan componentes del servidor (el Connector HTTP, el manager de sesiones, cada aplicación desplegada, etc.).

Con JMX puedes:
- Ver cuántos hilos están ocupados ahora mismo
- Ver cuántas sesiones activas tiene una aplicación
- Monitorizar el uso de memoria de la JVM
- Detectar hilos bloqueados
- Incluso recargar una aplicación sin reiniciar Tomcat

## Configuración de JMX Remoto

Para conectar herramientas de monitorización externas (JConsole, VisualVM, Prometheus) a Tomcat, hay que activar JMX remoto en `setenv.sh`:

```bash
# ============================================================
# OPCIÓN A: JMX sin autenticación (solo red interna / localhost)
# Adecuado cuando la red interna está controlada y no hay riesgo
# de acceso no autorizado al puerto 9090.
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.rmi.port=9090"
# Poner el mismo puerto para RMI y JMX simplifica la configuración
# de firewalls: solo hay que abrir un puerto.

CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
CATALINA_OPTS="$CATALINA_OPTS -Djava.rmi.server.hostname=127.0.0.1"
# hostname=127.0.0.1: JMX solo accesible desde localhost.
# Para acceso remoto, cambiar a la IP de la interfaz de red interna.

# ============================================================
# OPCIÓN B: JMX con autenticación (recomendado para producción)
# Requiere crear archivos de contraseñas y permisos.
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.rmi.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=true"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
CATALINA_OPTS="$CATALINA_OPTS \
  -Dcom.sun.management.jmxremote.password.file=${CATALINA_BASE}/conf/jmxremote.password"
CATALINA_OPTS="$CATALINA_OPTS \
  -Dcom.sun.management.jmxremote.access.file=${CATALINA_BASE}/conf/jmxremote.access"
CATALINA_OPTS="$CATALINA_OPTS -Djava.rmi.server.hostname=192.168.1.101"
# Cambiar a la IP del servidor Tomcat accesible desde la red de monitorización
```

```properties
# conf/jmxremote.password
# Formato: usuario contraseña
# Este archivo DEBE tener permisos 600 (solo el propietario puede leerlo)
# Si los permisos son incorrectos, la JVM rechaza el archivo al arrancar.
monitor  monitorpass123
admin    adminpass456
```

```properties
# conf/jmxremote.access
# Define qué puede hacer cada usuario
monitor  readonly     # puede leer métricas pero no ejecutar operaciones
admin    readwrite    # puede leer métricas y ejecutar operaciones (reload, etc.)
```

```bash
# Aplicar permisos obligatorios al archivo de contraseñas
chmod 600 $CATALINA_BASE/conf/jmxremote.password
chown tomcat:tomcat $CATALINA_BASE/conf/jmxremote.password
```

## Catálogo completo de MBeans de Tomcat

Este cliente JMX en Java muestra cómo leer las métricas más importantes de Tomcat programáticamente. Sirve tanto para herramientas de monitorización personalizadas como para entender qué métricas están disponibles:

```java
package com.miempresa.monitoring;

import javax.management.*;
import javax.management.remote.*;
import java.lang.management.*;
import java.util.*;
import java.util.logging.Logger;

/**
 * Cliente JMX para leer métricas de Tomcat.
 * Puede conectarse al mismo proceso (local) o a un Tomcat remoto.
 */
public class TomcatJmxMonitor {

    private static final Logger log =
        Logger.getLogger(TomcatJmxMonitor.class.getName());

    private final MBeanServerConnection mbsc;

    /** Constructor para monitorizar el mismo proceso JVM (sin red) */
    public TomcatJmxMonitor() {
        this.mbsc = ManagementFactory.getPlatformMBeanServer();
    }

    /**
     * Constructor para conectarse a un Tomcat remoto.
     * host y port son los del servidor Tomcat.
     * user y password son los definidos en jmxremote.password.
     */
    public TomcatJmxMonitor(String host, int port,
                             String user, String password)
            throws Exception {
        // La URL de servicio JMX tiene siempre esta forma para RMI
        JMXServiceURL url = new JMXServiceURL(
            "service:jmx:rmi:///jndi/rmi://" + host + ":" + port + "/jmxrmi"
        );

        Map<String, Object> env = new HashMap<>();
        if (user != null) {
            // Las credenciales se pasan como array [usuario, contraseña]
            env.put(JMXConnector.CREDENTIALS,
                new String[]{user, password});
        }

        JMXConnector connector = JMXConnectorFactory.connect(url, env);
        this.mbsc = connector.getMBeanServerConnection();
    }

    // =========================================================
    // MÉTRICAS DEL CONECTOR HTTP
    // Las más importantes para el día a día de operaciones
    // =========================================================

    public void printConnectorMetrics(String connectorName) throws Exception {
        // El ObjectName identifica el MBean en JMX.
        // "http-nio-8080" es el nombre del conector NIO en el puerto 8080.
        // Para el HTTPS sería "http-nio-8443", para AJP "ajp-nio-8009".
        ObjectName threadPool = new ObjectName(
            "Catalina:type=ThreadPool,name=\"" + connectorName + "\""
        );

        // Métricas del pool de hilos
        int maxThreads      = (int)  mbsc.getAttribute(threadPool, "maxThreads");
        int currentThreads  = (int)  mbsc.getAttribute(threadPool, "currentThreadCount");
        int busyThreads     = (int)  mbsc.getAttribute(threadPool, "currentThreadsBusy");
        int connectionCount = (int)  mbsc.getAttribute(threadPool, "connectionCount");
        long maxConnections = (long) mbsc.getAttribute(threadPool, "maxConnections");

        // Métricas de las peticiones HTTP procesadas
        ObjectName reqProc = new ObjectName(
            "Catalina:type=GlobalRequestProcessor,name=\"" + connectorName + "\""
        );

        long requestCount   = (long) mbsc.getAttribute(reqProc, "requestCount");
        long errorCount     = (long) mbsc.getAttribute(reqProc, "errorCount");
        long processingTime = (long) mbsc.getAttribute(reqProc, "processingTime");
        long maxTime        = (long) mbsc.getAttribute(reqProc, "maxTime");
        long bytesReceived  = (long) mbsc.getAttribute(reqProc, "bytesReceived");
        long bytesSent      = (long) mbsc.getAttribute(reqProc, "bytesSent");

        // Calcular métricas derivadas
        double avgResponseMs = requestCount > 0
            ? (double) processingTime / requestCount : 0;
        double errorRate     = requestCount > 0
            ? (double) errorCount / requestCount * 100 : 0;
        double threadUsage   = maxThreads > 0
            ? (double) busyThreads / maxThreads * 100 : 0;

        // Imprimir el informe
        // Si threadUsage > 80-90% frecuentemente → el pool está saturado
        // Si errorRate > 1% → hay problemas con las peticiones
        // Si avgResponseMs > 1000 → las respuestas son lentas (investigar BD)
        log.info(String.format("""
            ═══════════════════════════════════════
             Conector: %s
            ═══════════════════════════════════════
             Hilos:
               Máximo:       %d
               Total:        %d
               Ocupados:     %d (%.1f%%)
             Conexiones:
               Activas:      %d / %d
             Peticiones:
               Total:        %d
               Errores:      %d (%.2f%%)
               Avg resp:     %.2f ms
               Max resp:     %d ms
             Tráfico:
               Recibido:     %.2f MB
               Enviado:      %.2f MB
            ═══════════════════════════════════════
            """,
            connectorName,
            maxThreads, currentThreads, busyThreads, threadUsage,
            connectionCount, maxConnections,
            requestCount, errorCount, errorRate,
            avgResponseMs, maxTime,
            bytesReceived  / 1024.0 / 1024.0,
            bytesSent      / 1024.0 / 1024.0
        ));
    }

    // =========================================================
    // MÉTRICAS DE SESIONES HTTP
    // Útiles para detectar memory leaks de sesiones y ataques DoS
    // =========================================================

    public void printSessionMetrics() throws Exception {
        // Buscar todos los Managers (uno por cada aplicación desplegada)
        Set<ObjectName> managers = mbsc.queryNames(
            new ObjectName("Catalina:type=Manager,*"), null
        );

        for (ObjectName name : managers) {
            String context       = name.getKeyProperty("context");
            String host          = name.getKeyProperty("host");
            int activeSessions   = (int)  mbsc.getAttribute(name, "activeSessions");
            int expiredSessions  = (int)  mbsc.getAttribute(name, "expiredSessions");
            int maxActive        = (int)  mbsc.getAttribute(name, "maxActive");
            long sessionCounter  = (long) mbsc.getAttribute(name, "sessionCounter");
            int rejectedSessions = (int)  mbsc.getAttribute(name, "rejectedSessions");

            // rejectedSessions > 0 indica que se alcanzó maxActiveSessions
            // → posible ataque DoS por creación masiva de sesiones
            log.info(String.format("""
                Sesiones [%s%s]:
                  Activas:    %d (máximo histórico: %d)
                  Expiradas:  %d
                  Rechazadas: %d
                  Total hist: %d
                """,
                host, context,
                activeSessions, maxActive,
                expiredSessions, rejectedSessions,
                sessionCounter));
        }
    }

    // =========================================================
    // MÉTRICAS DE JVM
    // =========================================================

    public void printJvmMetrics() throws Exception {
        // Memoria heap
        MemoryMXBean memBean = ManagementFactory.getMemoryMXBean();
        MemoryUsage heap    = memBean.getHeapMemoryUsage();
        MemoryUsage nonHeap = memBean.getNonHeapMemoryUsage();

        // GC
        List<GarbageCollectorMXBean> gcBeans =
            ManagementFactory.getGarbageCollectorMXBeans();

        // Hilos
        ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();

        // Runtime (uptime)
        RuntimeMXBean runtimeBean = ManagementFactory.getRuntimeMXBean();
        long uptime = runtimeBean.getUptime();

        log.info(String.format("""
            ═══════════════════════════════════════
             JVM Metrics
            ═══════════════════════════════════════
             Uptime: %d h %d m %d s

             Heap Memory:
               Used:       %.2f MB
               Committed:  %.2f MB
               Max:        %.2f MB
               Usage:      %.1f%%
             (Si Usage > 85-90%% frecuentemente → aumentar -Xmx)

             Non-Heap (Metaspace):
               Used:       %.2f MB
               Committed:  %.2f MB

             Threads:
               Total:      %d
               Daemon:     %d
               Peak:       %d
               Deadlocked: %s
             (Deadlocked indica un bug grave en la aplicación)
            ═══════════════════════════════════════
            """,
            uptime / 3600000,
            (uptime % 3600000) / 60000,
            (uptime % 60000) / 1000,

            heap.getUsed()      / 1024.0 / 1024.0,
            heap.getCommitted() / 1024.0 / 1024.0,
            heap.getMax()       / 1024.0 / 1024.0,
            (double) heap.getUsed() / heap.getMax() * 100,

            nonHeap.getUsed()      / 1024.0 / 1024.0,
            nonHeap.getCommitted() / 1024.0 / 1024.0,

            threadBean.getThreadCount(),
            threadBean.getDaemonThreadCount(),
            threadBean.getPeakThreadCount(),
            threadBean.findDeadlockedThreads() != null
                ? "DETECTADO ⚠️" : "Ninguno"
        ));

        // Estadísticas de cada GC
        for (GarbageCollectorMXBean gc : gcBeans) {
            log.info(String.format(
                "GC [%s]: colecciones=%d, tiempo total=%d ms",
                gc.getName(),
                gc.getCollectionCount(),
                gc.getCollectionTime()
                // Si el tiempo acumulado de GC es > 5-10% del uptime
                // total → el GC está consumiendo demasiado tiempo.
            ));
        }
    }

    // =========================================================
    // MÉTRICAS DE APLICACIONES
    // =========================================================

    public void printApplicationMetrics() throws Exception {
        Set<ObjectName> contexts = mbsc.queryNames(
            new ObjectName("Catalina:type=Context,*"), null
        );

        for (ObjectName name : contexts) {
            String path    = (String)  mbsc.getAttribute(name, "path");
            String docBase = (String)  mbsc.getAttribute(name, "docBase");
            String state   = (String)  mbsc.getAttribute(name, "stateName");
            boolean available = (boolean) mbsc.getAttribute(name, "available");

            // state puede ser: STARTED, STOPPED, FAILED
            // available=false indica que la aplicación tuvo un error al arrancar
            log.info(String.format(
                "Aplicación: path=%-20s state=%-10s available=%b docBase=%s",
                path, state, available, docBase
            ));
        }
    }

    // =========================================================
    // DETECCIÓN DE HILOS BLOQUEADOS
    // =========================================================

    public void detectStuckThreads() throws Exception {
        // StuckThreadDetectionValve expone via JMX los hilos bloqueados
        Set<ObjectName> stuckValves = mbsc.queryNames(
            new ObjectName("Catalina:type=Valve,*StuckThreadDetection*"),
            null
        );

        for (ObjectName name : stuckValves) {
            String[] stuckThreads = (String[])
                mbsc.getAttribute(name, "stuckThreadNames");

            if (stuckThreads != null && stuckThreads.length > 0) {
                log.warning("HILOS BLOQUEADOS DETECTADOS:");
                for (String thread : stuckThreads) {
                    log.warning("  → " + thread);
                }
                // Un hilo bloqueado suele indicar: query SQL sin timeout,
                // llamada a servicio externo colgada, deadlock en código.
            } else {
                log.info("No hay hilos bloqueados");
            }
        }
    }

    // =========================================================
    // OPERACIONES VIA JMX (no solo lectura, también control)
    // =========================================================

    /** Recarga una aplicación sin reiniciar todo Tomcat */
    public void reloadApplication(String contextPath) throws Exception {
        ObjectName contextObj = new ObjectName(
            "Catalina:type=Context,context=" + contextPath
                + ",host=localhost"
        );
        mbsc.invoke(contextObj, "reload", null, null);
        log.info("Aplicación recargada: " + contextPath);
        // Equivale a hacer undeploy + deploy pero sin perder la configuración.
        // Las sesiones activas se pierden a menos que uses PersistentManager.
    }

    /** Expira sesiones que llevan N minutos inactivas */
    public void expireSessions(String host,
                               String context,
                               int idleMinutes) throws Exception {
        ObjectName managerName = new ObjectName(
            "Catalina:type=Manager,context=" + context
                + ",host=" + host
        );
        mbsc.invoke(
            managerName,
            "expireSession",
            new Object[]{idleMinutes},
            new String[]{"int"}
        );
        log.info("Sesiones con más de " + idleMinutes
            + " min de inactividad expiradas en: " + host + context);
    }
}
```

# 6 Profiling con Java Flight Recorder (JFR)

## ¿Qué es JFR y por qué es la herramienta de profiling preferida en producción?

El **Java Flight Recorder** es un sistema de grabación continua de eventos de la JVM. Desde Java 11 (donde se liberó como open source), viene incluido en el JDK sin coste adicional.

La característica que lo hace especial para producción es su **overhead mínimo**: graba continuamente con menos del 1% de impacto en el rendimiento. Esto significa que puedes tenerlo activo en producción en todo momento, y cuando ocurre un problema, ya tienes grabado lo que pasaba antes, durante y después.

Con JFR puedes ver:
- Qué métodos consumen más CPU (profiling)
- Cuánto tiempo espera cada hilo y por qué (bloqueos, I/O)
- Detalle completo del comportamiento del GC
- Qué clases se están allocando más (para encontrar memory leaks)
- Tiempos de compilación JIT

## Uso de JFR

```bash
# ============================================================
# MÉTODO 1: Activar JFR al arrancar Tomcat (en setenv.sh)
# Recomendado para producción: graba continuamente.
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS \
  -XX:+FlightRecorder \
  -XX:StartFlightRecording=\
    duration=0,\
    filename=${CATALINA_BASE}/logs/tomcat-$(date +%Y%m%d).jfr,\
    settings=profile,\
    maxsize=500m,\
    maxage=24h,\
    name=TomcatRecording"
# duration=0: grabar indefinidamente (no parar)
# maxsize=500m: el archivo de grabación no supera 500 MB
# maxage=24h: mantener solo las últimas 24h de datos
# settings=profile: nivel de detalle "profile" (más detallado que "default")

# ============================================================
# MÉTODO 2: Iniciar/detener grabación en caliente con jcmd
# Útil cuando necesitas investigar un problema ahora mismo,
# sin reiniciar Tomcat.
# ============================================================

# Encontrar el PID del proceso Tomcat
TOMCAT_PID=$(pgrep -f catalina)
echo "Tomcat PID: $TOMCAT_PID"

# Ver qué grabaciones JFR están activas ahora mismo
jcmd $TOMCAT_PID JFR.check

# Iniciar una grabación de 5 minutos
jcmd $TOMCAT_PID JFR.start \
  name=ProfilingSession \
  duration=5m \
  filename=/tmp/tomcat-profile.jfr \
  settings=profile
# La grabación se vuelca automáticamente al archivo cuando terminen los 5 minutos.

# Volcar los datos grabados hasta ahora (sin detener la grabación)
# Útil para ver el estado actual sin esperar a que termine la grabación
jcmd $TOMCAT_PID JFR.dump \
  name=ProfilingSession \
  filename=/tmp/tomcat-dump.jfr

# Detener la grabación y guardar el archivo final
jcmd $TOMCAT_PID JFR.stop \
  name=ProfilingSession \
  filename=/tmp/tomcat-final.jfr
```

## Análisis de JFR con la herramienta jfr CLI

```bash
# Ver un resumen del archivo: cuántos eventos hay de cada tipo,
# el período de tiempo cubierto, el tamaño...
jfr summary /tmp/tomcat-profile.jfr

# Ver los métodos que más CPU consumieron (top flame graph textual)
# Muestra los stack traces de los hilos cuando estaban activos
jfr print --events jdk.ExecutionSample \
  --stack-depth 5 \
  /tmp/tomcat-profile.jfr | head -100

# Ver todos los eventos de GC: cuándo ocurrieron, cuánto duraron,
# cuánta memoria se liberó
jfr print --events jdk.GarbageCollection \
  /tmp/tomcat-profile.jfr

# Ver dónde se bloquean los hilos: parkeos (esperas), monitores
# Útil para encontrar cuellos de botella en sincronización
jfr print --events jdk.ThreadPark,jdk.JavaMonitorWait \
  /tmp/tomcat-profile.jfr

# Exportar todos los eventos a JSON para análisis en otras herramientas
jfr print --json /tmp/tomcat-profile.jfr > /tmp/tomcat-profile.json

# Para análisis visual, usar JDK Mission Control (JMC):
# Es una aplicación gráfica que muestra flamegraphs, timelinas de GC,
# uso de memoria, hilos... todo de forma visual e interactiva.
# Descargar desde: https://jdk.java.net/jmc/
```

# 7 Herramientas de Load Testing

## ¿Para qué sirve el load testing?

Antes de configurar cualquier parámetro de rendimiento, necesitas saber cuál es el estado actual: ¿cuántas peticiones por segundo aguanta el servidor ahora mismo? ¿A partir de cuántas conexiones simultáneas empieza a degradarse la latencia?

Las herramientas de load testing simulan muchos usuarios accediendo a la vez, permitiendo medir el rendimiento real del servidor bajo carga controlada.

## Apache JMeter — Plan de prueba para Tomcat

JMeter es la herramienta de load testing más completa y popular en el ecosistema Java. Permite simular miles de usuarios con escenarios complejos (login, flujos de varias peticiones, aserciones sobre las respuestas, etc.).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="5.0">
  <hashTree>
    <TestPlan guiclass="TestPlanGui"
              testclass="TestPlan"
              testname="Tomcat Load Test Plan">

      <!-- Variables parametrizables: se pueden sobreescribir desde la línea de comandos -->
      <elementProp name="TestPlan.user_defined_variables"
                   elementType="Arguments">
        <collectionProp name="Arguments.arguments">
          <elementProp name="HOST" elementType="Argument">
            <stringProp name="Argument.name">HOST</stringProp>
            <stringProp name="Argument.value">app.miempresa.com</stringProp>
          </elementProp>
          <elementProp name="PORT" elementType="Argument">
            <stringProp name="Argument.name">PORT</stringProp>
            <stringProp name="Argument.value">8443</stringProp>
          </elementProp>
          <elementProp name="THREADS" elementType="Argument">
            <stringProp name="Argument.name">THREADS</stringProp>
            <stringProp name="Argument.value">200</stringProp>
            <!-- 200 usuarios virtuales simultáneos -->
          </elementProp>
          <elementProp name="RAMP_UP" elementType="Argument">
            <stringProp name="Argument.name">RAMP_UP</stringProp>
            <stringProp name="Argument.value">60</stringProp>
            <!-- 60 segundos para ir de 0 a 200 usuarios.
                 No empezar con todos de golpe: simula la llegada gradual real. -->
          </elementProp>
          <elementProp name="DURATION" elementType="Argument">
            <stringProp name="Argument.name">DURATION</stringProp>
            <stringProp name="Argument.value">300</stringProp>
            <!-- Duración de 5 minutos: suficiente para que el servidor
                 llegue a estado estable y para detectar memory leaks. -->
          </elementProp>
        </collectionProp>
      </elementProp>

    </TestPlan>
    <hashTree>

      <ThreadGroup guiclass="ThreadGroupGui"
                   testname="Usuarios Concurrentes"
                   enabled="true">
        <intProp name="ThreadGroup.num_threads">${THREADS}</intProp>
        <intProp name="ThreadGroup.ramp_time">${RAMP_UP}</intProp>
        <boolProp name="ThreadGroup.scheduler">true</boolProp>
        <stringProp name="ThreadGroup.duration">${DURATION}</stringProp>
      </ThreadGroup>

      <hashTree>
        <!-- Petición HTTP que se repite en bucle durante el test -->
        <HTTPSamplerProxy testname="GET /api/users">
          <stringProp name="HTTPSampler.domain">${HOST}</stringProp>
          <stringProp name="HTTPSampler.port">${PORT}</stringProp>
          <stringProp name="HTTPSampler.protocol">https</stringProp>
          <stringProp name="HTTPSampler.path">/myapp/api/users</stringProp>
          <stringProp name="HTTPSampler.method">GET</stringProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <!-- use_keepalive=true: simula el comportamiento real de los navegadores -->
        </HTTPSamplerProxy>

        <!-- Verificación: la respuesta debe ser HTTP 200 -->
        <ResponseAssertion testname="Verificar HTTP 200">
          <collectionProp name="Asserion.test_strings">
            <stringProp>200</stringProp>
          </collectionProp>
          <intProp name="Assertion.test_type">8</intProp>
          <stringProp name="Assertion.test_field">
            Assertion.response_code
          </stringProp>
        </ResponseAssertion>

        <!-- Verificación: la respuesta debe llegar en menos de 2 segundos -->
        <DurationAssertion testname="Verificar tiempo menor a 2s">
          <stringProp name="DurationAssertion.duration">2000</stringProp>
          <!-- Si alguna petición tarda más de 2000ms, JMeter la marcará
               como fallo en los resultados. -->
        </DurationAssertion>

      </hashTree>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

```bash
# Ejecutar JMeter en modo no-gráfico (lo correcto para load testing real).
# La interfaz gráfica de JMeter consume mucha CPU y distorsiona los resultados.
jmeter -n \
  -t tomcat-load-test.jmx \
  -l /tmp/results-$(date +%Y%m%d-%H%M%S).jtl \   # Archivo con todos los resultados
  -e \                                              # Generar reporte HTML al finalizar
  -o /tmp/jmeter-report-$(date +%Y%m%d-%H%M%S) \  # Directorio del reporte HTML
  -Jthreads=200 \
  -Jramp_up=60 \
  -Jduration=300 \
  -JHOST=app.miempresa.com \
  -JPORT=8443
```

## wrk — Load testing de alto rendimiento

`wrk` es una herramienta de load testing de línea de comandos muy eficiente, capaz de generar muchísimas peticiones por segundo desde una sola máquina. Es ideal para pruebas rápidas:

```bash
# Instalar wrk
sudo apt-get install -y wrk

# Test básico: 12 hilos, 200 conexiones, 60 segundos
# El flag --latency muestra la distribución percentil de latencias
wrk -t12 -c200 -d60s \
  --latency \
  https://app.miempresa.com/myapp/api/health

# Test más elaborado con script Lua: añadir cabeceras personalizadas
# (por ejemplo, para APIs que requieren autenticación JWT)
cat > test-api.lua << 'LUA'
wrk.method  = "GET"
wrk.headers["Authorization"] = "Bearer mi-token-jwt"
wrk.headers["Content-Type"]  = "application/json"
wrk.headers["Accept"]        = "application/json"

-- Esta función se llama por cada respuesta recibida
function response(status, headers, body)
    if status ~= 200 then
        io.write("Error HTTP " .. status .. "\n")
    end
end
LUA

wrk -t12 -c200 -d60s \
  --latency \
  --script test-api.lua \
  https://app.miempresa.com/myapp/api/users

# Ejemplo de salida e interpretación:
# Thread Stats   Avg      Stdev     Max    +/- Stdev
#   Latency    45.23ms   12.34ms 234.56ms   89.12%
# ↑ latencia media de 45ms, máximo 234ms
#
#   Req/Sec   456.78     34.56   512.00     78.34%
# ↑ ~457 peticiones/segundo por hilo, 12 hilos ≈ 5.500 req/s totales
#
# Latency Distribution
#    50%   42.12ms   ← la mitad de las peticiones responden en < 42ms
#    75%   51.23ms
#    90%   62.34ms
#    99%  123.45ms   ← el 1% peor tarda hasta 123ms
#
# 164,456 requests in 1.00m    → 2.740 req/s en total durante el test
```

# 8. Integración con Prometheus y Grafana

## ¿Qué es Prometheus y cómo encaja con Tomcat?

**Prometheus** es un sistema de monitorización que recoge métricas de las aplicaciones y las almacena para análisis histórico. **Grafana** es una herramienta de visualización que lee esas métricas y las muestra en dashboards interactivos.

El flujo es:
```
Tomcat → JMX Exporter → Prometheus → Grafana → Dashboard
         (convierte JMX    (recoge las  (visualiza
          a formato        métricas     gráficas,
          Prometheus)      cada 15s)    alertas)
```

## Exposición de métricas con JMX Exporter

El **JMX Exporter** es un agente Java que se activa al arrancar Tomcat, lee los MBeans JMX y los expone en formato Prometheus en un endpoint HTTP (típicamente `:9100/metrics`). Prometheus recoge ese endpoint periódicamente.

```yaml
# jmx-exporter-config.yaml
# Define qué MBeans de JMX exportar y cómo nombrar las métricas

---
startDelaySeconds: 0
hostPort: 127.0.0.1:9090    # JMX está en el puerto 9090
ssl: false

rules:
  # ===== Pool de hilos del Conector =====
  # El patrón es una expresión regular sobre el nombre del MBean
  - pattern: 'Catalina<type=ThreadPool, name="(\w+-\w+-\d+)"><>(currentThreadCount|currentThreadsBusy|maxThreads|connectionCount|maxConnections)'
    name: tomcat_threadpool_$2       # Nombre de la métrica en Prometheus
    labels:
      connector: $1                  # Etiqueta para diferenciar por conector
    type: GAUGE                      # GAUGE = valor que sube y baja (no acumulativo)

  # ===== Estadísticas de peticiones HTTP =====
  - pattern: 'Catalina<type=GlobalRequestProcessor, name="(\w+-\w+-\d+)"><>(requestCount|errorCount|processingTime|bytesSent|bytesReceived|maxTime)'
    name: tomcat_request_$2_total
    labels:
      connector: $1
    type: COUNTER                    # COUNTER = valor que solo sube (acumulativo)

  # ===== Sesiones =====
  - pattern: 'Catalina<type=Manager, host=(\w+), context=(.+)><>(activeSessions|expiredSessions|sessionCounter|rejectedSessions|maxActive)'
    name: tomcat_session_$3
    labels:
      host: $1
      context: $2
    type: GAUGE

  # ===== Memoria heap de la JVM =====
  - pattern: 'java.lang<type=Memory><HeapMemoryUsage>(used|committed|max)'
    name: jvm_heap_memory_$1_bytes
    type: GAUGE

  # ===== Estadísticas del GC =====
  - pattern: 'java.lang<type=GarbageCollector, name=(.+)><>(CollectionCount|CollectionTime)'
    name: jvm_gc_$2_total
    labels:
      gc: $1
    type: COUNTER

  # ===== Hilos de la JVM =====
  - pattern: 'java.lang<type=Threading><>(ThreadCount|DaemonThreadCount|PeakThreadCount)'
    name: jvm_threads_$1
    type: GAUGE

  # ===== Pool de conexiones a BD =====
  - pattern: 'Catalina<type=DataSource, class=javax.sql.DataSource, name="(.+)".*><>(numActive|numIdle|maxTotal|minIdle|maxIdle)'
    name: tomcat_datasource_$2
    labels:
      pool: $1
    type: GAUGE
```

```bash
# En setenv.sh: activar el JMX Exporter como Java Agent
# Un "Java Agent" es una librería que se inyecta en el proceso JVM
# al arrancar y puede interceptar cualquier cosa.
JAVA_AGENT_JAR="/opt/jmx-exporter/jmx_prometheus_javaagent-0.20.0.jar"
JAVA_AGENT_CONFIG="/opt/jmx-exporter/jmx-exporter-config.yaml"
JAVA_AGENT_PORT="9100"   # Puerto donde el exporter expone las métricas

CATALINA_OPTS="$CATALINA_OPTS \
  -javaagent:${JAVA_AGENT_JAR}=${JAVA_AGENT_PORT}:${JAVA_AGENT_CONFIG}"

# Después de esto, las métricas estarán disponibles en:
# http://localhost:9100/metrics
# Prometheus lo recoge periódicamente (cada 15s por defecto).
```

## Dashboard Grafana — Métricas clave

Este es un ejemplo de configuración de dashboard Grafana en JSON. Define los paneles más importantes para monitorizar Tomcat:

```json
{
  "title": "Tomcat Performance Dashboard",
  "panels": [
    {
      "title": "Uso del Pool de Hilos (%)",
      "description": "Si supera el 80-90% frecuentemente, el pool está a punto de saturarse",
      "type": "graph",
      "targets": [
        {
          "expr": "tomcat_threadpool_currentThreadsBusy{job='tomcat'}",
          "legendFormat": "Hilos ocupados - {{connector}}"
        },
        {
          "expr": "tomcat_threadpool_maxThreads{job='tomcat'}",
          "legendFormat": "Máximo - {{connector}}"
        }
      ]
    },
    {
      "title": "Peticiones por Segundo (RPS)",
      "description": "El throughput total del servidor",
      "type": "graph",
      "targets": [
        {
          "expr": "rate(tomcat_request_requestCount_total{job='tomcat'}[1m])",
          "legendFormat": "req/s - {{connector}}"
        }
      ]
    },
    {
      "title": "Tasa de Errores (%)",
      "description": "Si supera el 1% investigar qué está fallando",
      "type": "gauge",
      "targets": [
        {
          "expr": "rate(tomcat_request_errorCount_total[1m]) / rate(tomcat_request_requestCount_total[1m]) * 100",
          "legendFormat": "Error %"
        }
      ]
    },
    {
      "title": "Tiempo Medio de Respuesta (ms)",
      "description": "Si sube, buscar queries lentas o servicios externos lentos",
      "type": "graph",
      "targets": [
        {
          "expr": "rate(tomcat_request_processingTime_total[1m]) / rate(tomcat_request_requestCount_total[1m])",
          "legendFormat": "ms medio"
        }
      ]
    },
    {
      "title": "Sesiones HTTP Activas",
      "description": "Un crecimiento continuo sin estabilizarse puede indicar memory leak",
      "type": "graph",
      "targets": [
        {
          "expr": "tomcat_session_activeSessions{job='tomcat'}",
          "legendFormat": "Sesiones - {{context}}"
        }
      ]
    },
    {
      "title": "Uso del Heap JVM (%)",
      "description": "Si supera el 85% frecuentemente → aumentar -Xmx",
      "type": "graph",
      "targets": [
        {
          "expr": "jvm_heap_memory_used_bytes / jvm_heap_memory_max_bytes * 100",
          "legendFormat": "Heap %"
        }
      ]
    },
    {
      "title": "Tiempo de GC (ms/min)",
      "description": "El tiempo que la JVM pasa en GC. Si supera el 5% del tiempo total → problema",
      "type": "graph",
      "targets": [
        {
          "expr": "rate(jvm_gc_CollectionTime_total[1m]) * 1000",
          "legendFormat": "ms/min - {{gc}}"
        }
      ]
    },
    {
      "title": "Conexiones Activas al Pool de BD",
      "description": "Si llega al máximo (maxTotal), las peticiones esperan conexión a BD",
      "type": "graph",
      "targets": [
        {
          "expr": "tomcat_datasource_numActive{job='tomcat'}",
          "legendFormat": "Conexiones activas - {{pool}}"
        }
      ]
    }
  ]
}
```

# 9. Script de Diagnóstico de Rendimiento Completo

Este script realiza un diagnóstico rápido y completo del estado de un servidor Tomcat. Útil para ejecutar cuando se detecta un problema o como parte de una revisión rutinaria:

```bash
#!/bin/bash
# tomcat-perf-check.sh
# Diagnóstico completo de rendimiento de una instancia Tomcat
# Uso: ./tomcat-perf-check.sh [host] [puerto_http] [path_app]

set -euo pipefail

TOMCAT_HOST="${1:-localhost}"
TOMCAT_PORT="${2:-8080}"
MANAGER_USER="${MANAGER_USER:-admin}"       # Usuario del Manager de Tomcat
MANAGER_PASS="${MANAGER_PASS:-password}"    # Contraseña del Manager
APP_PATH="${3:-/myapp}"
CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"

echo "╔══════════════════════════════════════════════════════╗"
echo "║     Diagnóstico de Rendimiento — Apache Tomcat       ║"
echo "║     Host: $TOMCAT_HOST:$TOMCAT_PORT                  "
echo "║     $(date)                                          "
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# ===== 1. ESTADO DEL PROCESO =====
echo "━━━ 1. Proceso Tomcat ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
TOMCAT_PID=$(pgrep -f catalina.jar || pgrep -f bootstrap.jar || echo "")

if [ -z "$TOMCAT_PID" ]; then
    echo "  ❌ Tomcat NO está corriendo"
    exit 1
fi

echo "  PID:    $TOMCAT_PID"
echo "  Uptime: $(ps -p $TOMCAT_PID -o etime= 2>/dev/null || echo 'N/A')"
echo "  CPU:    $(ps -p $TOMCAT_PID -o %cpu= 2>/dev/null || echo 'N/A')%"
echo "  MEM:    $(ps -p $TOMCAT_PID -o %mem= 2>/dev/null || echo 'N/A')%"
echo "  RSS:    $(ps -p $TOMCAT_PID -o rss= 2>/dev/null \
             | awk '{printf "%.1f MB\n", $1/1024}' || echo 'N/A')"
# RSS (Resident Set Size) = memoria RAM real que ocupa el proceso
# Un RSS que crece continuamente sin estabilizarse = posible memory leak

echo ""

# ===== 2. PUERTOS EN ESCUCHA =====
echo "━━━ 2. Puertos en Escucha ━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ss -tlnp | grep java | awk '{print "  " $4}' || echo "  (no disponible)"
# Deben aparecer los puertos configurados en server.xml (8080, 8443, etc.)

echo ""

# ===== 3. TIEMPO DE RESPUESTA =====
echo "━━━ 3. Tiempo de Respuesta ━━━━━━━━━━━━━━━━━━━━━━━━━━"
for endpoint in "/health" "$APP_PATH/health" "/manager/text/serverinfo"; do
    RESULT=$(curl -s -o /dev/null -w "%{http_code}|%{time_total}|%{time_connect}" \
        -u "$MANAGER_USER:$MANAGER_PASS" \
        --connect-timeout 5 --max-time 10 \
        "http://$TOMCAT_HOST:$TOMCAT_PORT$endpoint" 2>/dev/null \
        || echo "000|99.999|99.999")

    HTTP_CODE=$(echo $RESULT | cut -d'|' -f1)
    TIME_TOTAL=$(echo $RESULT | cut -d'|' -f2)
    TIME_CONN=$(echo $RESULT | cut -d'|' -f3)

    STATUS_ICON="✅"
    [ "$HTTP_CODE" != "200" ] && STATUS_ICON="⚠️"
    [ "$HTTP_CODE" = "000" ] && STATUS_ICON="❌"

    echo "  $STATUS_ICON $endpoint → HTTP $HTTP_CODE | Total: ${TIME_TOTAL}s | Conexión: ${TIME_CONN}s"
done

echo ""

# ===== 4. MEMORIA JVM =====
echo "━━━ 4. Memoria JVM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v jcmd &>/dev/null; then
    echo "  Heap Info:"
    jcmd $TOMCAT_PID GC.heap_info 2>/dev/null \
        | awk '{print "  " $0}' \
        || echo "  (no disponible)"
fi

echo ""

# ===== 5. ANÁLISIS DE HILOS =====
echo "━━━ 5. Hilos del Proceso ━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v jstack &>/dev/null; then
    TOTAL_THREADS=$(jstack $TOMCAT_PID 2>/dev/null | grep "^\"" | wc -l || echo "N/A")
    BLOCKED_THREADS=$(jstack $TOMCAT_PID 2>/dev/null | grep "BLOCKED" | wc -l || echo "0")
    WAITING_THREADS=$(jstack $TOMCAT_PID 2>/dev/null | grep "WAITING" | wc -l || echo "0")
    RUNNABLE_THREADS=$(jstack $TOMCAT_PID 2>/dev/null | grep "RUNNABLE" | wc -l || echo "0")

    echo "  Total:      $TOTAL_THREADS"
    echo "  Runnable:   $RUNNABLE_THREADS  (procesando activamente)"
    echo "  Waiting:    $WAITING_THREADS   (esperando señal — normal si no hay carga)"
    if [ "$BLOCKED_THREADS" -gt 0 ] 2>/dev/null; then
        echo "  ⚠️  Bloqueados: $BLOCKED_THREADS (investigar posibles deadlocks)"
        # BLOCKED significa que un hilo intenta entrar a un bloque synchronized
        # que otro hilo ya tiene. Si persiste, es un problema de concurrencia.
    else
        echo "  Bloqueados: 0  (todo OK)"
    fi
fi

echo ""

# ===== 6. ERRORES RECIENTES EN LOGS =====
echo "━━━ 6. Errores Recientes en Logs ━━━━━━━━━━━━━━━━━━━"
if [ -f "$CATALINA_BASE/logs/catalina.out" ]; then
    ERROR_COUNT=$(grep -c "SEVERE\|Exception\|OutOfMemory" \
        "$CATALINA_BASE/logs/catalina.out" 2>/dev/null || echo "0")
    echo "  Errores SEVERE/Exception en catalina.out: $ERROR_COUNT total"

    echo "  Últimos 5 errores:"
    grep -i "SEVERE\|OutOfMemory\|Exception" \
        "$CATALINA_BASE/logs/catalina.out" \
        2>/dev/null | tail -5 \
        | awk '{print "    " $0}' \
        || echo "    (No se pueden leer los logs)"
fi

echo ""

# ===== 7. APLICACIONES DESPLEGADAS (VIA MANAGER) =====
echo "━━━ 7. Aplicaciones Desplegadas ━━━━━━━━━━━━━━━━━━━━"
MANAGER_LIST=$(curl -s \
    -u "$MANAGER_USER:$MANAGER_PASS" \
    --connect-timeout 5 --max-time 10 \
    "http://$TOMCAT_HOST:$TOMCAT_PORT/manager/text/list" 2>/dev/null \
    || echo "ERROR")

if echo "$MANAGER_LIST" | grep -q "^OK"; then
    echo "$MANAGER_LIST" | grep -v "^OK" | grep -v "^$" \
        | awk -F: '{printf "  %-30s %-10s sesiones=%-6s\n", $1, $2, $3}'
    # Formato: /ruta   running   sesiones=123
else
    echo "  Manager no accesible (revisar credenciales o restricción IP)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Diagnóstico completado: $(date)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

# 10. Tabla de Referencia Rápida de Tuning

Esta tabla es un punto de partida. Los valores óptimos dependen del hardware, de la aplicación y del tipo de carga. Medir y ajustar siempre:

| Parámetro                       | Baja carga      | Carga media       | Alta carga          |
|---------------------------------|-----------------|-------------------|---------------------|
| `maxThreads`                    | 100             | 200-300           | 400-500             |
| `minSpareThreads`               | 10              | 25                | 50                  |
| `maxConnections`                | 5.000           | 10.000            | 15.000-20.000       |
| `acceptCount`                   | 100             | 200               | 300-500             |
| `connectionTimeout` (ms)        | 30.000          | 20.000            | 10.000-15.000       |
| `keepAliveTimeout` (ms)         | 60.000          | 30.000            | 15.000-20.000       |
| `maxKeepAliveRequests`          | 100             | 200               | 500                 |
| Heap `-Xmx`                     | 512m-1g         | 2g-4g             | 4g-8g               |
| `MaxGCPauseMillis` (G1GC)       | 500             | 200               | 100                 |
| Pool BD `maxTotal`              | 10              | 30-50             | 50-100              |
| Pool BD `testOnBorrow`          | true            | true              | true                |
| `compressionMinSize` (bytes)    | 4.096           | 2.048             | 1.024               |
| `cacheTtl` DefaultServlet (ms)  | 0 (dev)         | 5.000             | 30.000              |
| `cacheMaxSize` (KB)             | 10.240          | 51.200            | 102.400             |

> ⚠️ **Nota sobre `connectionTimeout`:** A mayor carga, menor timeout. En un servidor muy cargado, las conexiones lentas o atacantes que abren conexiones sin enviar datos bloquean recursos que necesitan los usuarios legítimos.

# 11. Diferencias de Rendimiento y Monitorización entre Versiones

| Característica                          | 8.0   | 8.5   | 9.0   | 10.x  | 11.0   |
|-----------------------------------------|-------|-------|-------|-------|--------|
| NIO2 Connector                          | ✅    | ✅    | ✅    | ✅    | ✅     |
| HTTP/2 (UpgradeProtocol)                | ❌    | ✅    | ✅    | ✅    | ✅     |
| JFR integrado (requiere JDK 11+)        | ❌    | ❌    | ✅*   | ✅    | ✅     |
| ZGC soporte                             | ❌    | ❌    | ✅*   | ✅    | ✅     |
| Virtual Threads Executor                | ❌    | ❌    | ❌    | ❌    | ✅     |
| OpenSSL via FFM (TLS rápido)            | ❌    | ❌    | ❌    | ❌    | ✅     |
| StuckThreadDetectionValve               | ✅    | ✅    | ✅    | ✅    | ✅     |
| JMX MBeans completos                    | ✅    | ✅    | ✅    | ✅    | ✅     |
| AsyncFileHandler (JULI)                 | ❌    | ✅    | ✅    | ✅    | ✅     |
| SSL reload sin reinicio de Tomcat       | ❌    | ✅    | ✅    | ✅    | ✅     |
| `maxParameterCount` en Conector         | ❌    | ✅    | ✅    | ✅    | ✅     |
| G1GC como GC por defecto de la JVM      | ❌    | ❌    | ✅*   | ✅    | ✅     |
| ZGC Generacional (Java 21+)             | ❌    | ❌    | ❌    | ❌    | ✅**   |

*Requiere la versión de JDK apropiada
**Requiere JDK 21+

**Los cambios más importantes:**
- **Tomcat 8.5:** introduce `AsyncFileHandler` en JULI (logs asíncronos que no bloquean hilos) y HTTP/2
- **Tomcat 9+:** con JDK 11+ ya puedes usar JFR y ZGC
- **Tomcat 11:** Virtual Threads (el cambio más grande desde NIO), OpenSSL via FFM (Foreign Function & Memory API de Java 22+) sin necesidad de compilar librerías nativas

# 12. Puntos Clave

- **Medir antes de ajustar.** El cuello de botella más frecuente es la base de datos, no Tomcat ni la JVM. Aumentar `maxThreads` cuando el problema es la BD no mejora nada.

- **`Xms = Xmx` en producción.** Si ambos valores son iguales, la JVM no necesita expandir el heap dinámicamente, eliminando pausas de GC adicionales. El comportamiento es más predecible.

- **G1GC para la mayoría de casos, ZGC para latencia ultra-baja.** G1GC es el default desde Java 9 y está bien probado. ZGC (Java 15+) mantiene pausas < 1ms pero con un overhead de CPU ligeramente mayor.

- **El `maxThreads` óptimo se calcula** como `TPS_objetivo × tiempo_respuesta_segundos + margen`. No aumentarlo ciegamente: más hilos = más memoria, y si el problema es otro, no ayuda.

- **Java Flight Recorder es la herramienta de profiling de producción.** Overhead < 1%, viene gratis con el JDK 11+. Actívalo en todos los servidores de producción para tener datos históricos cuando aparezca un problema.

- **Los MBeans JMX exponen todo lo que necesitas saber** sobre el estado en tiempo real: hilos ocupados, sesiones activas, errores, tiempos de respuesta. Integrar con Prometheus + Grafana para monitorización continua con alertas.

- **El JMX Exporter de Prometheus** como Java Agent es la forma más sencilla de conectar JMX con el ecosistema Prometheus/Grafana sin modificar el código de la aplicación.

- **`StuckThreadDetectionValve` es obligatorio en producción.** Detecta y alerta sobre hilos bloqueados en operaciones externas (consultas BD sin timeout, llamadas a APIs colgadas). Sin este Valve, esos hilos agotan el pool silenciosamente y el servidor se degrada sin aviso claro.

- **`AsyncFileHandler` de JULI** escribe los logs en un buffer asíncrono en lugar de bloquearse en disco en cada línea de log. En producción con mucho tráfico, el logging síncrono puede convertirse en un cuello de botella.

- **Los Virtual Threads de Tomcat 11** (Java 21+) eliminan el límite práctico de `maxThreads` para cargas I/O-bound. Es la evolución natural del modelo thread-per-request y no requiere cambios en el código de las aplicaciones.