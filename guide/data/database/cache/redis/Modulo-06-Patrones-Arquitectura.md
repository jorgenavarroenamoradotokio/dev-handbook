> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Patrones Arquitectonicos](#1-patrones-arquitectonicos)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Cache-Aside (el patrón de caché por defecto)](#cache-aside-el-patrón-de-caché-por-defecto)
    - [MAL — sin protección de stampede](#mal--sin-protección-de-stampede)
    - [BIEN — lock de recomputación con `SET NX`](#bien--lock-de-recomputación-con-set-nx)
  - [Sesiones de usuario](#sesiones-de-usuario)
  - [Pub/Sub — mensajería efímera, sin persistencia](#pubsub--mensajería-efímera-sin-persistencia)
    - [Limitación crítica que el patrón no oculta pero que se olvida en la práctica](#limitación-crítica-que-el-patrón-no-oculta-pero-que-se-olvida-en-la-práctica)
  - [Streams — colas con garantías de entrega y consumer groups](#streams--colas-con-garantías-de-entrega-y-consumer-groups)
  - [Rate Limiting — sliding window con Sorted Set](#rate-limiting--sliding-window-con-sorted-set)
    - [MAL — contador simple con `INCR` + `EXPIRE` (ventanas fijas, permite ráfagas en el borde)](#mal--contador-simple-con-incr--expire-ventanas-fijas-permite-ráfagas-en-el-borde)
    - [BIEN — sliding window log con Sorted Set](#bien--sliding-window-log-con-sorted-set)
  - [Locks distribuidos — la versión que realmente funciona](#locks-distribuidos--la-versión-que-realmente-funciona)
    - [El patrón que aparecía en la guía original Erroneo](#el-patrón-que-aparecía-en-la-guía-original-erroneo)
    - [token único + liberación atómica vía Lua correcto](#token-único--liberación-atómica-vía-lua-correcto)
    - [Sobre Redlock — no lo presentes como solución cerrada Warning](#sobre-redlock--no-lo-presentes-como-solución-cerrada-warning)
  - [Geolocalización y catálogos con filtrado combinado](#geolocalización-y-catálogos-con-filtrado-combinado)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Patrones Arquitectonicos

Este módulo no trata sobre comandos individuales — trata sobre **composiciones de comandos que resuelven problemas de coordinación distribuida**: cachear sin servir datos obsoletos a miles de clientes a la vez, coordinar acceso exclusivo entre procesos que no confían entre sí, limitar tasa de uso sin condiciones de carrera, y mover mensajes entre servicios con garantías de entrega.

**Por qué esto es lo más fácil de hacer mal:** cada patrón de esta sección *parece* trivial con dos comandos de Redis, y esa aparente simplicidad es exactamente lo que hace que la mayoría de implementaciones en producción tengan un bug de concurrencia latente que solo aparece bajo carga real. Este módulo prioriza mostrarte la versión correcta y explicar por qué la versión "obvia" falla, no solo la versión que funciona en una demo de un único cliente.

---

## 2. Arquitectura y Componentes

### Cache-Aside (el patrón de caché por defecto)

El patrón más común: la aplicación consulta Redis primero; si no está (*cache miss*), consulta la fuente de verdad (base de datos), y escribe el resultado en Redis para la próxima vez.

```
Lectura:  App → Redis (¿existe?) → SI: devuelve
                                  → NO: App → DB → App escribe en Redis → devuelve
Escritura: App → DB (fuente de verdad) → App invalida/actualiza la clave en Redis
```

**El problema que nadie resuelve por defecto: cache stampede.** Si una clave popular expira y 500 requests concurrentes reciben un *cache miss* al mismo tiempo, los 500 golpean la base de datos simultáneamente para recalcular el mismo valor — el escenario exacto que la caché existía para evitar, disparado justo por su propio mecanismo de expiración.

#### MAL — sin protección de stampede
```python
def get_product(sku):
    value = redis.get(f"cache:product:{sku}")
    if value is None:
        value = db.query_product(sku)      # 500 requests concurrentes = 500 queries a DB
        redis.set(f"cache:product:{sku}", value, ex=300)
    return value
```

#### BIEN — lock de recomputación con `SET NX`
```python
def get_product(sku):
    key = f"cache:product:{sku}"
    value = redis.get(key)
    if value is not None:
        return value

    lock_key = f"lock:{key}"
    # Solo un proceso gana el lock; SET NX EX es atómico (una sola operación de red)
    got_lock = redis.set(lock_key, "1", nx=True, ex=10)

    if got_lock:
        try:
            value = db.query_product(sku)
            redis.set(key, value, ex=300)
        finally:
            redis.delete(lock_key)
        return value
    else:
        # Los demás esperan brevemente y reintentan leer de caché
        # en vez de golpear la DB también
        time.sleep(0.05)
        return get_product(sku)
```

**Alternativa complementaria:** añadir jitter aleatorio al TTL (`ex=300 + random.randint(0, 30)`) para que claves cacheadas en el mismo instante no expiren todas exactamente a la vez — reduce la probabilidad de que el stampede ocurra siquiera.

### Sesiones de usuario

```bash
HSET session:abc123 user_id "1042" role "admin" issued_at "2026-08-15T10:00:00Z"
EXPIRE session:abc123 1800

# Renovar la sesión en cada actividad (sliding expiration)
EXPIRE session:abc123 1800
```

**Decisión de arquitectura relevante:** en un sistema con múltiples instancias de Redis (Cluster, Módulo 06), asegúrate de que todas las claves de una misma sesión usen el mismo *hash tag* si necesitas operaciones multi-clave atómicas sobre esa sesión — se detalla en el Módulo 06.

### Pub/Sub — mensajería efímera, sin persistencia

```bash
# Suscriptor
SUBSCRIBE notifications:user:1042

# Publicador (desde otro proceso/servicio)
PUBLISH notifications:user:1042 '{"type":"order_shipped","order_id":88213}'
```

#### Limitación crítica que el patrón no oculta pero que se olvida en la práctica
Pub/Sub en Redis **no tiene persistencia ni entrega garantizada.** Si el suscriptor no está conectado en el momento exacto del `PUBLISH`, el mensaje se pierde para siempre — no hay cola, no hay reintento, no hay ack. Es correcto para notificaciones en tiempo real donde perder un mensaje ocasional es aceptable (ej. "actualizar un contador en pantalla en vivo"). **No es correcto para nada que requiera garantía de entrega** — para eso, usa Streams (sección 2.4).

### Streams — colas con garantías de entrega y consumer groups

A diferencia de `List` (Módulo 02, cola simple sin reintento) o Pub/Sub (sin persistencia), **Streams** ofrece un log persistente con IDs ordenados, múltiples consumidores agrupados, y confirmación explícita (`XACK`) de que un mensaje fue procesado.

```bash
# Productor añade un evento al stream
XADD orders:events "*" type "created" order_id "88213" amount "149.90"

# Crear un consumer group (una sola vez, ignorable si ya existe)
XGROUP CREATE orders:events billing_service "$" MKSTREAM

# Consumidor lee mensajes pendientes para su grupo
XREADGROUP GROUP billing_service worker-1 COUNT 10 STREAMS orders:events ">"

# Tras procesar exitosamente, confirma — si no se confirma, el mensaje
# queda "pending" y puede reasignarse a otro worker
XACK orders:events billing_service <id-del-mensaje>

# Reclamar mensajes que quedaron pendientes de un worker caído (>60s sin ack)
XAUTOCLAIM orders:events billing_service worker-2 60000 0
```

**Cuándo Streams es la elección correcta frente a List o Pub/Sub:** necesitas que múltiples consumidores procesen el mismo flujo de eventos de forma independiente (consumer groups), necesitas reintentar mensajes que un worker no confirmó, o necesitas conservar el historial de eventos para replay. Si solo necesitas "notificar en tiempo real sin garantías", Pub/Sub es más simple y suficiente.

### Rate Limiting — sliding window con Sorted Set

#### MAL — contador simple con `INCR` + `EXPIRE` (ventanas fijas, permite ráfagas en el borde)
```python
key = f"ratelimit:{user_id}:{current_minute}"
count = redis.incr(key)
redis.expire(key, 60)
if count > 100:
    reject()
```
Problema: un usuario puede hacer 100 requests en el último segundo del minuto 1 y otros 100 en el primer segundo del minuto 2 — 200 requests en 2 segundos reales, pasando ambas ventanas fijas sin activar el límite.

#### BIEN — sliding window log con Sorted Set
```python
def is_allowed(user_id, limit=100, window_seconds=60):
    key = f"ratelimit:{user_id}"
    now = time.time()
    window_start = now - window_seconds

    pipe = redis.pipeline()
    pipe.zremrangebyscore(key, 0, window_start)   # descarta eventos fuera de ventana
    pipe.zadd(key, {str(now): now})               # registra este request
    pipe.zcard(key)                                # cuenta eventos en ventana actual
    pipe.expire(key, window_seconds)
    _, _, request_count, _ = pipe.execute()

    return request_count <= limit
```
El uso de `pipeline()` agrupa las cuatro operaciones en una sola ida y vuelta de red (ver Módulo 07 para el detalle de pipelining), pero **no las hace atómicas entre sí** frente a otros clientes — para atomicidad real bajo alta concurrencia, esto se implementa como script Lua (sección 2.6).

### Locks distribuidos — la versión que realmente funciona

Esta es la corrección directa del patrón incompleto de la guía original, que usaba `SETNX` sin liberación atómica.

#### El patrón que aparecía en la guía original Erroneo
```python
redis.setnx(f"lock:{resource}", "locked")
# ... hacer trabajo ...
redis.delete(f"lock:{resource}")   # PELIGRO: borra el lock sin verificar quién lo puso
```
**El bug concreto:** si el proceso A obtiene el lock, tarda más de lo esperado (GC pause, red lenta) y su lock expira por TTL, otro proceso B puede obtener el lock legítimamente. Cuando A finalmente termina y ejecuta `DELETE`, borra el lock de **B**, no el suyo — dos procesos terminan creyendo que tienen exclusividad simultáneamente. Esto es el problema exacto que un lock distribuido existe para evitar.

#### token único + liberación atómica vía Lua correcto
```python
import uuid

def acquire_lock(resource, ttl_ms=10000):
    token = str(uuid.uuid4())
    acquired = redis.set(f"lock:{resource}", token, nx=True, px=ttl_ms)
    return token if acquired else None

# Script Lua: compara el token antes de borrar — ejecuta atómicamente en Redis,
# sin ventana de tiempo entre el "check" y el "delete"
RELEASE_SCRIPT = """
if redis.call("GET", KEYS[1]) == ARGV[1] then
    return redis.call("DEL", KEYS[1])
else
    return 0
end
"""

def release_lock(resource, token):
    redis.eval(RELEASE_SCRIPT, 1, f"lock:{resource}", token)
```
El script Lua se ejecuta de forma atómica dentro de Redis (recuerda el Módulo 00: un único hilo, sin interrupciones) — no hay ventana entre comprobar el token y borrar la clave en la que otro proceso pueda intervenir.

#### Sobre Redlock — no lo presentes como solución cerrada Warning
El algoritmo **Redlock** (adquirir el lock en mayoría de N instancias independientes de Redis) es la propuesta oficial de Redis para locks distribuidos con mayor tolerancia a fallos que una sola instancia. Tiene una **crítica seria y ampliamente citada de Martin Kleppmann**: bajo pausas de GC largas, relojes desincronizados entre nodos, o retrasos de red impredecibles, Redlock no garantiza exclusión mutua estricta en todos los escenarios — el proceso que "tiene" el lock puede ya no tenerlo realmente en el momento en que actúa sobre el recurso protegido.

**Postura honesta para tu arquitectura:**
- Si el lock protege una operación donde la peor consecuencia de una violación es un trabajo duplicado tolerable (ej. reenviar un email dos veces), Redlock o el patrón single-instance de esta sección son razonables.
- Si el lock protege algo donde la exclusión mutua real es crítica (ej. evitar doble cobro, evitar corrupción de estado financiero), no confíes en Redis como única fuente de exclusión — usa un sistema diseñado explícitamente para consenso distribuido (ej. locks basados en Zookeeper/etcd con fencing tokens), o añade un fencing token verificado en la propia operación protegida, no solo en la adquisición del lock.

### Geolocalización y catálogos con filtrado combinado

Combina `GEOSEARCH` (Módulo 02) con `SINTERSTORE` para resolver "tiendas cercanas que además tienen stock":

```bash
GEOSEARCH tiendas FROMLONLAT -3.70 40.41 BYRADIUS 20 km STORE tiendas:cercanas
SINTERSTORE resultado tiendas:cercanas stock:sku-778
```

---

## 3. Implementación Paso a Paso

| Necesito... | Patrón |
|---|---|
| Reducir carga sobre mi base de datos para lecturas frecuentes | Cache-Aside + protección de stampede (2.1) |
| Notificar en tiempo real sin importar perder algún mensaje ocasional | Pub/Sub (2.3) |
| Procesar eventos con garantía de que cada uno se maneja al menos una vez, con reintentos | Streams + consumer groups (2.4) |
| Limitar requests por usuario/IP con precisión, sin ráfagas en el borde de ventana | Sliding window con Sorted Set (2.5) |
| Exclusión mutua entre procesos, tolerable a duplicación ocasional | Lock single-instance con token + Lua (2.6) |
| Exclusión mutua donde una violación es inaceptable (dinero, estado crítico) | No solo Redis — sistema de consenso dedicado + fencing tokens |

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Locks con `SETNX`/`DEL` sin token de propiedad.** Ver sección 2.6 — es el bug de concurrencia más reproducible bajo carga real, y el que tenía el documento original de este repo.

- ❌ **Presentar Redlock como solución perfecta de consenso distribuido.** No lo es, y decirlo explícitamente en tu documentación te ahorra un incidente donde alguien confía en Redlock para algo que necesitaba garantías más fuertes.

- ❌ **Usar Pub/Sub para algo que no puede permitirse perder mensajes.** Es el error de patrón más común: "funciona en desarrollo" porque el suscriptor siempre está conectado en local; en producción, un deploy, un reinicio o un pico de latencia del suscriptor pierde mensajes de forma silenciosa.

- ❌ **Rate limiting con contador de ventana fija cuando el requisito real es proteger contra ráfagas.** Ver sección 2.5 — la ventana fija dejar pasar el doble del límite nominal en el peor caso.

- ❌ **No poner TTL a las claves de lock.** Si el proceso que adquirió el lock muere sin liberar y no hay expiración, el recurso queda bloqueado indefinidamente — siempre `SET ... NX PX <ttl>` en la misma operación de adquisición, nunca `SET` seguido de un `EXPIRE` separado (eso reintroduce una ventana no atómica).

- ✅ **En cache-aside, añade jitter al TTL de claves con patrones de expiración correlacionados** (ver sección 2.1) — es una mitigación barata contra stampede que no requiere lógica de lock.

- ✅ **Para cualquier patrón de coordinación entre procesos, pregúntate explícitamente: "¿qué pasa si el proceso que tiene el lock/token muere a mitad de la operación?"** Si no tienes una respuesta clara, el patrón tiene un bug latente, no importa qué tan bien funcione en pruebas con un solo proceso.
