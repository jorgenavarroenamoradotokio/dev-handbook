> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Observabilidad y Troubleshooting](#1-observabilidad-y-troubleshooting)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [`SLOWLOG` — comandos que tardaron más de lo esperado](#slowlog--comandos-que-tardaron-más-de-lo-esperado)
  - [`LATENCY` — diagnóstico de eventos de latencia por subsistema](#latency--diagnóstico-de-eventos-de-latencia-por-subsistema)
  - [`MONITOR` — inspección en tiempo real (con una advertencia seria)](#monitor--inspección-en-tiempo-real-con-una-advertencia-seria)
  - [Nunca lo dejes corriendo en producción con tráfico real](#nunca-lo-dejes-corriendo-en-producción-con-tráfico-real)
  - [`INFO` — el panorama completo por secciones](#info--el-panorama-completo-por-secciones)
  - [Herramienta externa: `redis-cli --stat` y `--latency`](#herramienta-externa-redis-cli---stat-y---latency)
- [3. Guía de Diagnóstico Paso a Paso](#3-guía-de-diagnóstico-paso-a-paso)
  - [Síntoma: "Redis está lento" (latencia elevada, sin más contexto)](#síntoma-redis-está-lento-latencia-elevada-sin-más-contexto)
  - [Síntoma: uso de memoria creciendo sin razón aparente](#síntoma-uso-de-memoria-creciendo-sin-razón-aparente)
  - [Síntoma: conexiones rechazadas o "too many clients"](#síntoma-conexiones-rechazadas-o-too-many-clients)
  - [Síntoma: réplica desincronizada o con retraso creciente](#síntoma-réplica-desincronizada-o-con-retraso-creciente)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Observabilidad y Troubleshooting

Cuando Redis "va lento" en producción, la causa casi nunca es un misterio — es uno de un conjunto relativamente pequeño y conocido de patrones: un comando bloqueante, una big key, presión de memoria, un `BGSAVE` con fork costoso, o saturación de red. Este módulo es la guía de diagnóstico sistemático para pasar de "algo va mal" a "esto exactamente va mal y esto lo corrige", sin adivinar.

**Analogía:** diagnosticar Redis sin las herramientas de este módulo es como intentar averiguar por qué un coche hace un ruido raro solo escuchándolo desde fuera. `SLOWLOG`, `LATENCY`, `MONITOR` y `INFO` son el equivalente al diagnóstico OBD del coche — te dicen exactamente qué sensor disparó qué código, en vez de conjeturar.

---

## 2. Arquitectura y Componentes

### `SLOWLOG` — comandos que tardaron más de lo esperado

Redis registra automáticamente cualquier comando cuya ejecución supere un umbral configurable (en microsegundos), independientemente de la causa.

```conf
# redis.conf — umbral en microsegundos (10000 = 10ms)
slowlog-log-slower-than 10000
slowlog-max-len 512
```

```bash
# Ver las entradas más recientes del slowlog
SLOWLOG GET 10

# Cada entrada: [id, timestamp, duración_microsegundos, [comando, args...], cliente]
```

**Qué buscar:** comandos recurrentes en el slowlog con el mismo patrón (no un único evento aislado) apuntan a un problema estructural — típicamente un comando O(N) del Módulo 07 ejecutándose sobre una clave que creció más de lo previsto originalmente.

### `LATENCY` — diagnóstico de eventos de latencia por subsistema

Mientras `SLOWLOG` registra comandos lentos, `LATENCY` monitoriza eventos de latencia del propio motor (fork, expiración, I/O), incluso cuando no hay un comando de cliente específico que señalar.

```bash
# Habilitar el monitor de latencia para eventos que superen 100ms
CONFIG SET latency-monitor-threshold 100

# Ver el historial de eventos de latencia por categoría
LATENCY HISTORY fork
LATENCY HISTORY command
LATENCY HISTORY expire-cycle

# Diagnóstico agregado con explicación de la causa más probable
LATENCY DOCTOR
```

`LATENCY DOCTOR` es particularmente útil porque no solo reporta números — da una interpretación en lenguaje natural de la causa probable, correlacionando eventos (ej. "picos de latencia coinciden con `BGSAVE`, revisa el tamaño del dataset frente a la velocidad de disco").

### `MONITOR` — inspección en tiempo real (con una advertencia seria)

```bash
MONITOR
# Imprime CADA comando que Redis ejecuta, en tiempo real, según llega
```

### Nunca lo dejes corriendo en producción con tráfico real
`MONITOR` tiene un impacto de rendimiento significativo y creciente con el volumen de tráfico — está reproduciendo cada comando hacia tu terminal, lo cual consume CPU y ancho de banda proporcional al throughput real de la instancia. Es una herramienta de diagnóstico puntual de segundos, no de minutos, y nunca en una instancia con tráfico de producción alto sin haber medido antes el impacto en un entorno de staging equivalente. Es también la razón por la que la categoría `@dangerous` de ACLs (Módulo 04) restringe su acceso.

### `INFO` — el panorama completo por secciones

```bash
INFO all
# O secciones específicas:
INFO server        # versión, modo, uptime
INFO clients        # conexiones activas, bloqueadas
INFO memory         # uso de memoria, fragmentación (Módulo 07)
INFO persistence    # estado de RDB/AOF (Módulo 03)
INFO stats           # throughput, cache hit ratio, evictions
INFO replication     # estado de réplicas (Módulo 06)
INFO cpu
INFO commandstats    # desglose de uso por comando — requiere activar previamente
INFO latencystats    # percentiles de latencia por comando
```

```bash
# commandstats y latencystats no se recopilan por defecto en todas las versiones
CONFIG SET latency-tracking yes
```

**Métrica que suele pasarse por alto: `keyspace_hits` vs `keyspace_misses`** (en `INFO stats`):
```bash
redis-cli INFO stats | grep keyspace
```
```
keyspace_hits:1834021
keyspace_misses:92104
```
Un ratio de misses creciente en una instancia usada como caché indica que o bien el TTL es demasiado corto, o el patrón de acceso cambió, o el `maxmemory` es insuficiente y se está desalojando contenido que aún se necesita (conecta directamente con `evicted_keys` del Módulo 07).

### Herramienta externa: `redis-cli --stat` y `--latency`

```bash
# Panorama en vivo de throughput, memoria y clientes conectados, refrescado cada segundo
redis-cli --stat

# Medición pura de latencia de red + procesamiento, comando PING repetido
redis-cli --latency
redis-cli --latency-history   # con desglose temporal, útil para detectar picos periódicos
```

---

## 3. Guía de Diagnóstico Paso a Paso

### Síntoma: "Redis está lento" (latencia elevada, sin más contexto)

```bash
# Paso 1: ¿Es la instancia entera o comandos específicos?
redis-cli --latency
# Si el PING básico ya es lento → problema de red o CPU del host, no de un comando específico

# Paso 2: revisar comandos lentos recientes
redis-cli SLOWLOG GET 20

# Paso 3: revisar eventos de latencia del motor (fork, expiración)
redis-cli LATENCY DOCTOR

# Paso 4: revisar si hay presión de memoria activa (evictions, fragmentación)
redis-cli INFO memory | grep -E "evicted_keys|mem_fragmentation_ratio"

# Paso 5: revisar si hay un BGSAVE/BGREWRITEAOF en curso coincidiendo con el síntoma
redis-cli INFO persistence | grep -E "rdb_bgsave_in_progress|aof_rewrite_in_progress"
```

### Síntoma: uso de memoria creciendo sin razón aparente

```bash
# 1. Confirmar que no es fragmentación (memoria reservada vs. usada)
redis-cli INFO memory | grep mem_fragmentation_ratio

# 2. Buscar big keys que puedan haber crecido más de lo esperado
redis-cli --bigkeys -i 0.01

# 3. Verificar que las claves de caché sí tienen TTL asignado (fuga por olvido de EXPIRE)
redis-cli --scan --pattern "cache:*" | head -20
# tomar una muestra y verificar TTL individualmente
redis-cli TTL cache:product:sku-778   # -1 significa sin TTL — señal de alarma si debería tener uno
```

### Síntoma: conexiones rechazadas o "too many clients"

```bash
redis-cli INFO clients
```
```
connected_clients:9847
maxclients:10000
```
```bash
# Ver qué clientes están conectados y desde dónde, para identificar el origen del exceso
redis-cli CLIENT LIST

# Si hay conexiones huérfanas (clientes que ya no responden), cerrarlas explícitamente
redis-cli CLIENT KILL ID <id>
```
**Causa raíz más común:** ausencia de connection pooling correctamente configurado en el lado de la aplicación — cada request abre una conexión nueva en vez de reutilizar un pool. Esto se corrige en la aplicación, no en Redis; aumentar `maxclients` solo pospone el síntoma.

### Síntoma: réplica desincronizada o con retraso creciente

```bash
# En la réplica
redis-cli INFO replication | grep -E "master_link_status|master_repl_offset|slave_repl_offset"
```
Si `master_link_status:down`, la réplica perdió conexión con el primario — revisar conectividad de red y logs (`master_link_down_since_seconds`). Si el link está `up` pero el offset diverge de forma creciente, la réplica no puede procesar el stream de escrituras tan rápido como llega — indica que el hardware de la réplica es insuficiente para el volumen de escritura actual, o que hay un comando bloqueante ejecutándose también en la réplica.

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Dejar `MONITOR` corriendo por error en una sesión SSH olvidada sobre una instancia de producción con tráfico alto.** Es más común de lo que parece, y el impacto de rendimiento es real, no teórico.

- ❌ **Diagnosticar por intuición sin revisar `SLOWLOG`/`LATENCY DOCTOR` primero.** Estas herramientas existen exactamente para reemplazar la conjetura — úsalas como primer paso, no como último recurso tras horas de sospechas.

- ❌ **No tener `slowlog-log-slower-than` configurado de forma deliberada.** El valor por defecto (10ms) es razonable para empezar, pero en una instancia de muy alto throughput donde cada microsegundo cuenta, podrías querer un umbral más bajo para capturar degradaciones sutiles antes de que se conviertan en un problema visible.

- ❌ **Aumentar `maxclients` como respuesta reflejo a "too many clients" sin investigar la causa raíz.** Casi siempre es un problema de pooling de conexiones en el cliente, no de un límite mal configurado en el servidor.

- ✅ **Establece un baseline de métricas normales antes de que ocurra un incidente.** Sin saber cuál es tu `mem_fragmentation_ratio` o `keyspace_hits`/`misses` habitual, no puedes distinguir una anomalía real de una variación normal cuando ocurre.

- ✅ **Correlaciona eventos de latencia con la actividad de persistencia** (`BGSAVE`, `BGREWRITEAOF`) antes de asumir que el problema es de la aplicación — el Módulo 03 explica por qué el fork de `BGSAVE` puede generar picos de memoria y, en consecuencia, de latencia.

- ✅ **Integra `INFO` y `SLOWLOG` con tu stack de observabilidad estándar** (Prometheus + `redis_exporter`, Datadog, etc.) en vez de depender de inspección manual reactiva — el valor de este módulo es mayor cuando las métricas se recolectan de forma continua, no solo cuando ya hay un incidente en curso.