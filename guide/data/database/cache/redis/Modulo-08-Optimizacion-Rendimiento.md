> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Optimización y Rendimiento](#1-optimización-y-rendimiento)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Complejidad algorítmica: la variable que más importa](#complejidad-algorítmica-la-variable-que-más-importa)
  - [❌ MAL](#-mal)
  - [✅ BIEN](#-bien)
  - [Big Keys — el problema que no se ve hasta que ya pasó](#big-keys--el-problema-que-no-se-ve-hasta-que-ya-pasó)
  - [✅ BIEN — mitigación de big keys](#-bien--mitigación-de-big-keys)
  - [Políticas de `maxmemory-policy` — qué se descarta cuando la memoria se llena](#políticas-de-maxmemory-policy--qué-se-descarta-cuando-la-memoria-se-llena)
  - [⚠️ El error de configuración más costoso de esta sección](#️-el-error-de-configuración-más-costoso-de-esta-sección)
  - [Pipelining — reducir el coste de round-trip de red](#pipelining--reducir-el-coste-de-round-trip-de-red)
  - [Client-side caching (tracking) — desde RESP3](#client-side-caching-tracking--desde-resp3)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Auditoría de memoria de una instancia en producción](#auditoría-de-memoria-de-una-instancia-en-producción)
  - [Encontrar y corregir big keys de forma segura en producción](#encontrar-y-corregir-big-keys-de-forma-segura-en-producción)
  - [Medir el impacto real de pipelining (benchmark propio, no solo teoría)](#medir-el-impacto-real-de-pipelining-benchmark-propio-no-solo-teoría)
  - [Configuración de memoria recomendada como punto de partida](#configuración-de-memoria-recomendada-como-punto-de-partida)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Optimización y Rendimiento

Redis ya es rápido por defecto — la mayoría de problemas de rendimiento que se ven en producción no vienen de que "Redis sea lento", vienen de **patrones de uso que ignoran las dos restricciones estructurales de su arquitectura**: un único hilo ejecutando comandos (Módulo 00) y un límite de memoria física real. Este módulo trata sobre cómo detectar y evitar los patrones que violan esas restricciones antes de que se conviertan en un incidente.

**Analogía:** Redis es un atleta de velocidad extraordinaria en distancias cortas. El trabajo de este módulo es asegurarte de que nunca le pidas correr una maratón cargando una mochila de 40kg (un comando O(N) sobre una estructura gigante) cuando lo que necesitas es que siga corriendo sprints — cada comando, una operación acotada y predecible.

---

## 2. Arquitectura y Componentes

### Complejidad algorítmica: la variable que más importa

Cada comando de Redis tiene una complejidad documentada (`O(1)`, `O(log N)`, `O(N)`...). En un motor single-threaded, un comando `O(N)` sobre una estructura con N muy grande no es "más lento" — **bloquea literalmente todas las demás operaciones** mientras se ejecuta, porque no hay otro hilo que pueda atender al resto de clientes mientras tanto.

| Comando peligroso | Complejidad | Alternativa segura |
|---|---|---|
| `KEYS *` | O(N) sobre el total de claves | `SCAN` con cursor |
| `SMEMBERS` sobre un set enorme | O(N) | `SSCAN` con cursor |
| `HGETALL` sobre un hash enorme | O(N) | `HSCAN` con cursor, o rediseñar el modelo |
| `LRANGE key 0 -1` sobre una lista enorme | O(N) | Paginar con rangos acotados |
| `SORT` sin `LIMIT` sobre colección grande | O(N log N) | `SORT ... LIMIT` o precalcular con Sorted Set |
| `FLUSHALL` / `FLUSHDB` (síncrono) | O(N) | `FLUSHALL ASYNC` (Redis ≥ 4.0) |

### ❌ MAL
```bash
KEYS user:*   # escanea TODO el keyspace, bloquea el hilo principal durante el escaneo completo
```

### ✅ BIEN
```bash
SCAN 0 MATCH user:* COUNT 100
# Devuelve un cursor + un lote de resultados. Se itera llamando SCAN de nuevo
# con el cursor devuelto, hasta que el cursor vuelve a 0.
# Cada llamada es O(COUNT), no O(N) del total — no bloquea de forma prolongada.
```

### Big Keys — el problema que no se ve hasta que ya pasó

Una "big key" es una clave individual (string, hash, set, list, zset) cuyo tamaño es desproporcionadamente grande frente al resto del dataset. No es un problema de memoria per se — es un problema de **operaciones que tocan esa clave completa**: un `DEL` sobre un hash de 5 millones de campos, replicarla, o migrarla durante un resharding de Cluster (Módulo 06), bloquean el hilo principal proporcionalmente a su tamaño.

```bash
# Detectar las claves más grandes del dataset (usa muestreo, no escanea todo de golpe)
redis-cli --bigkeys

# Medir el tamaño real en memoria de una clave específica
redis-cli MEMORY USAGE user:1042:profile

# Analizar distribución de tamaños con más detalle (offline, no en producción con tráfico alto)
redis-cli --memkeys
```

### ✅ BIEN — mitigación de big keys
- **Particiona claves que crecen sin límite conocido**: en vez de `set:global_tags` con millones de miembros, `set:global_tags:{shard}` distribuido por hash del propio valor.
- **Usa `UNLINK` en vez de `DEL` para claves grandes**: `UNLINK` libera la memoria de forma asíncrona en un hilo de background (Módulo 00, sección 2.2), sin bloquear el hilo principal durante la liberación.
```bash
UNLINK user:1042:huge_set   # no DEL, si la clave es grande
```
- **Activa `lazyfree` para operaciones automáticas de liberación** (expiración, eviction), no solo para `DEL` manual:
```conf
lazyfree-lazy-expire yes
lazyfree-lazy-eviction yes
lazyfree-lazy-server-del yes
replica-lazy-flush yes
```

### Políticas de `maxmemory-policy` — qué se descarta cuando la memoria se llena

Cuando el dataset alcanza `maxmemory` (Módulo 01), Redis necesita liberar espacio. La política define **qué se sacrifica**:

| Política | Comportamiento | Cuándo usarla |
|---|---|---|
| `noeviction` | Rechaza nuevas escrituras con error, no borra nada | Redis como almacén primario donde perder cualquier dato es inaceptable — prioriza error visible sobre pérdida silenciosa |
| `allkeys-lru` | Descarta la clave usada menos recientemente, de cualquier clave | Caché general sin distinción de importancia entre claves |
| `allkeys-lfu` | Descarta la clave usada con menor frecuencia (no solo recencia) | Caché donde el patrón de acceso es más "algunas claves calientes constantes" que "recencia simple" |
| `volatile-lru` | Como `allkeys-lru`, pero solo entre claves con TTL configurado | Mezcla de datos persistentes (sin TTL, nunca se tocan) y caché (con TTL) en la misma instancia |
| `volatile-lfu` | Como `allkeys-lfu`, pero solo entre claves con TTL | Igual que arriba, con patrón de frecuencia |
| `volatile-ttl` | Descarta la clave con menor TTL restante primero | Cuando quieres priorizar mantener vivo lo que expira más tarde |
| `volatile-random` / `allkeys-random` | Descarte aleatorio | Rara vez es la elección correcta — casi siempre LRU o LFU son mejores por patrón real |

### ⚠️ El error de configuración más costoso de esta sección
Usar `allkeys-lru`/`allkeys-lfu` en una instancia que además almacena datos **no reconstruibles** (no son caché, son estado primario). Redis puede desalojar esos datos igual que desaloja caché — no distingue "esto es importante" de "esto es descartable" salvo por la presencia de TTL (`volatile-*`). Si mezclas caché y datos primarios en la misma instancia, usa `volatile-*` y asegúrate de que **solo** las claves de caché tengan TTL asignado.

### Pipelining — reducir el coste de round-trip de red

Cada comando de Redis normalmente implica una ida y vuelta de red completa (request → response). Cuando necesitas ejecutar muchos comandos independientes, el pipelining agrupa varios comandos en un solo envío, sin esperar la respuesta de cada uno antes de enviar el siguiente.

```python
# ❌ MAL — N round-trips de red completos
for i in range(10000):
    redis.set(f"key:{i}", i)

# ✅ BIEN — 1 round-trip de red para las 10.000 operaciones
pipe = redis.pipeline()
for i in range(10000):
    pipe.set(f"key:{i}", i)
pipe.execute()
```

**Diferencia importante entre pipeline y transacción (`MULTI`/`EXEC`):** un pipeline agrupa comandos por eficiencia de red, pero **no garantiza atomicidad** — otro cliente puede intercalar comandos entre los tuyos si no usas `MULTI`/`EXEC` dentro del pipeline. Y como se mencionó en el Módulo 05, `MULTI`/`EXEC` tampoco ofrece rollback ante errores de un comando individual — solo garantiza que ningún otro cliente ejecuta comandos *entre* los tuyos.

### Client-side caching (tracking) — desde RESP3

Redis 6+ con protocolo RESP3 soporta **client-side caching**: el servidor notifica al cliente cuándo una clave que consultó recientemente cambió, permitiendo al cliente mantener una caché local en memoria de su propio proceso sin necesidad de re-consultar Redis constantemente para datos que no han cambiado.

```bash
# Habilitar tracking en la conexión actual (requiere cliente RESP3)
CLIENT TRACKING ON
```

**Cuándo aporta valor real:** patrones de lectura extremadamente repetitiva sobre las mismas claves desde el mismo proceso cliente (ej. datos de configuración consultados en cada request). No es una optimización de primer recurso — evalúala después de confirmar, con medición real, que la latencia de red hacia Redis es un cuello de botella significativo.

---

## 3. Implementación Paso a Paso

### Auditoría de memoria de una instancia en producción

```bash
redis-cli INFO memory
```
Campos clave a revisar:
```
used_memory_human:1.82G        # memoria usada por el dataset + overhead
maxmemory_human:2.00G
mem_fragmentation_ratio:1.42   # >1.5 sugiere fragmentación significativa
evicted_keys:18420             # si crece de forma sostenida, tu maxmemory es insuficiente
```

**`mem_fragmentation_ratio` — qué significa y qué hacer si es alto:**
Es la relación entre memoria reservada por el sistema operativo y memoria realmente usada por Redis. Un valor >1.5 de forma sostenida sugiere fragmentación del allocator de memoria (típicamente por patrones de escritura/borrado con tamaños muy variables). Mitígalo activando el defragmentador activo:
```conf
activedefrag yes
active-defrag-ignore-bytes 100mb
active-defrag-threshold-lower 10
active-defrag-threshold-upper 100
```

### Encontrar y corregir big keys de forma segura en producción

```bash
# --bigkeys usa SCAN internamente (no bloquea) y añade una pequeña pausa configurable
redis-cli --bigkeys -i 0.01
```
El flag `-i 0.01` introduce una pausa de 10ms entre lotes de escaneo — reduce la carga sobre la instancia mientras se ejecuta el análisis en un servidor con tráfico real, a costa de que el análisis tarda más en completarse.

### Medir el impacto real de pipelining (benchmark propio, no solo teoría)

```bash
# Benchmark sin pipelining
redis-benchmark -t set,get -n 100000 -q

# Benchmark con pipelining (agrupa 16 comandos por request)
redis-benchmark -t set,get -n 100000 -P 16 -q
```
Compara el throughput reportado (`requests per second`) entre ambos — la diferencia cuantifica exactamente cuánto te cuesta el overhead de round-trip en tu entorno de red específico, en vez de asumir una cifra genérica de la documentación.

### Configuración de memoria recomendada como punto de partida

```conf
maxmemory 4gb
maxmemory-policy volatile-lru        # ajusta según si mezclas caché y datos primarios (sección 2.3)

lazyfree-lazy-expire yes
lazyfree-lazy-eviction yes
lazyfree-lazy-server-del yes

activedefrag yes
```

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Ejecutar `KEYS *`, `SMEMBERS`, `HGETALL` sin límite sobre estructuras cuyo tamaño no controlas, en producción.** Ver sección 2.1 — es la causa más común y más evitable de incidentes de latencia en Redis.

- ❌ **Usar `allkeys-lru` en una instancia que mezcla caché y datos primarios sin TTL.** Ver sección 2.3 — Redis desalojará datos que no deberían poder desalojarse nunca.

- ❌ **No monitorizar `evicted_keys` de forma continua.** Un crecimiento sostenido significa que tu `maxmemory` es insuficiente para el patrón de tráfico actual — no es solo una métrica curiosa, es una señal de capacidad insuficiente antes de que se convierta en un incidente de rendimiento visible para el usuario final.

- ❌ **Confundir pipelining con atomicidad transaccional.** Ver sección 2.4 — son propósitos distintos (rendimiento de red vs. exclusión de otros clientes).

- ❌ **Usar `DEL` en vez de `UNLINK` para claves grandes en instancias con tráfico activo.** La liberación síncrona de una estructura de millones de elementos bloquea el hilo principal proporcionalmente a su tamaño.

- ✅ **Mide antes de optimizar.** El benchmark de la sección 3.3 con tus datos reales de red y tamaño de payload vale más que cualquier cifra genérica citada de la documentación oficial — la latencia de red entre tu aplicación y Redis varía significativamente según topología (misma zona de disponibilidad vs. cross-region, por ejemplo).

- ✅ **Revisa `mem_fragmentation_ratio` como parte de tu rutina de observabilidad**, no solo cuando notas consumo de memoria anómalo.

- ✅ **Define explícitamente, para cada instancia, si `maxmemory-policy` debe ser `noeviction` (datos primarios) o alguna variante `*-lru`/`*-lfu` (caché)** — y documenta esa decisión junto a la clasificación de persistencia del Módulo 03. Ambas decisiones están relacionadas y deberían tomarse juntas, no de forma aislada.