> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Testing y Validación](#1-testing-y-validación)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Niveles de testing para código que depende de Redis](#niveles-de-testing-para-código-que-depende-de-redis)
  - [❌ MAL — testear solo con mock, incluso para lógica de concurrencia](#-mal--testear-solo-con-mock-incluso-para-lógica-de-concurrencia)
  - [✅ BIEN — integración con Redis real vía contenedor efímero](#-bien--integración-con-redis-real-vía-contenedor-efímero)
  - [Probar el patrón de lock bajo concurrencia real](#probar-el-patrón-de-lock-bajo-concurrencia-real)
  - [Validar TTL y expiración con precisión](#validar-ttl-y-expiración-con-precisión)
  - [⚠️ Evita TTLs de test demasiado cortos](#️-evita-ttls-de-test-demasiado-cortos)
  - [Testing de scripts Lua de forma aislada](#testing-de-scripts-lua-de-forma-aislada)
  - [Pruebas de carga con `redis-benchmark` y `memtier_benchmark`](#pruebas-de-carga-con-redis-benchmark-y-memtier_benchmark)
  - [Validar comportamiento ante failover (Módulo 06) — prueba de resiliencia dirigida](#validar-comportamiento-ante-failover-módulo-06--prueba-de-resiliencia-dirigida)
- [3. Implementación Paso a Paso (Hands-On) — checklist de suite de testing](#3-implementación-paso-a-paso-hands-on--checklist-de-suite-de-testing)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Testing y Validación

Testear código que usa Redis no es lo mismo que testear código que usa una base de datos relacional embebida en memoria — Redis tiene comportamientos que solo se manifiestan bajo condiciones específicas: concurrencia real (el lock del Módulo 05 solo revela su bug con múltiples procesos genuinamente concurrentes, no con llamadas secuenciales en un test unitario), fallos de red parciales, y failover (Módulo 06). Un test que solo verifica "el comando devuelve lo esperado" no prueba nada sobre las garantías que realmente importan en producción.

**Analogía:** testear solo la happy path de Redis es como probar los frenos de un coche solo en un día seco y llano — pasa la prueba, y no te dice nada sobre lo que va a pasar la primera vez que llueva o haya una cuesta. Este módulo trata sobre diseñar las pruebas que sí simulan lluvia y cuesta: concurrencia, fallos parciales, carga real.

---

## 2. Arquitectura y Componentes

### Niveles de testing para código que depende de Redis

| Nivel | Qué valida | Herramienta típica | Cuándo NO es suficiente |
|---|---|---|---|
| Unitario con mock/fake | Lógica de tu aplicación aislada de Redis | `fakeredis`, mocks manuales | Nunca valida comportamiento real de concurrencia, TTL, o Lua scripts |
| Integración con Redis real (contenedor efímero) | Comandos reales, TTLs reales, scripts Lua reales | Testcontainers, Docker Compose en CI | No valida comportamiento bajo fallos de red o failover |
| Carga / rendimiento | Comportamiento bajo volumen y concurrencia real | `redis-benchmark`, `memtier_benchmark`, scripts propios con locust/k6 | No sustituye pruebas de resiliencia dirigidas |
| Resiliencia / chaos | Comportamiento ante caída de nodo, partición de red, latencia inyectada | Toxiproxy, `redis-cli DEBUG SLEEP`, kill de procesos en staging | — |

### ❌ MAL — testear solo con mock, incluso para lógica de concurrencia
```python
# fakeredis simula la API, pero no replica el comportamiento real
# de expiración por tiempo, memoria, ni concurrencia genuina entre procesos
def test_lock_acquisition():
    fake_redis.set("lock:resource", "token1", nx=True)
    assert fake_redis.get("lock:resource") == "token1"
    # Esto NO prueba que el lock del Módulo 05 resista dos procesos reales compitiendo
```

### ✅ BIEN — integración con Redis real vía contenedor efímero
```python
import testcontainers.redis as tc_redis

def test_lock_acquisition_real():
    with tc_redis.RedisContainer("redis:8-alpine") as redis_container:
        client = redis_container.get_client()
        # Ahora el TTL, la atomicidad de SET NX PX, y el script Lua de liberación
        # se ejecutan contra un Redis real, no una simulación de su API
        token = acquire_lock(client, "resource")
        assert token is not None
```

### Probar el patrón de lock bajo concurrencia real

El bug del lock sin token (Módulo 05, sección 2.6) **no se detecta con un test secuencial de un solo proceso** — necesitas concurrencia genuina para reproducirlo.

```python
import concurrent.futures

def test_lock_prevents_double_acquisition():
    resource = "test-resource"
    results = []

    def try_acquire():
        token = acquire_lock(resource, ttl_ms=2000)
        results.append(token is not None)
        if token:
            time.sleep(0.5)  # simula trabajo bajo el lock
            release_lock(resource, token)

    # 20 procesos "compitiendo" genuinamente por el mismo lock
    with concurrent.futures.ThreadPoolExecutor(max_workers=20) as executor:
        futures = [executor.submit(try_acquire) for _ in range(20)]
        concurrent.futures.wait(futures)

    # En cualquier instante dado, nunca debería haber más de 1 adquisición exitosa
    # simultánea — esto se valida con un contador compartido dentro de la sección crítica,
    # no solo contando éxitos totales
```

### Validar TTL y expiración con precisión

```python
def test_ttl_expiration():
    redis_client.set("temp:key", "value", ex=1)
    assert redis_client.get("temp:key") == b"value"

    time.sleep(1.2)  # margen sobre el TTL exacto, evita flakiness por timing del test runner
    assert redis_client.get("temp:key") is None
```

### ⚠️ Evita TTLs de test demasiado cortos
Un TTL de 1 segundo en CI puede generar tests intermitentes (*flaky*) si el runner está bajo carga y el `sleep` no es suficientemente preciso. Prefiere TTLs de al menos 2-3 segundos en pruebas automatizadas, o usa `DEBUG SET-ACTIVE-EXPIRE 0` combinado con manipulación explícita del tiempo cuando el framework de testing lo soporte, en vez de depender de `sleep` real.

### Testing de scripts Lua de forma aislada

```python
def test_lock_release_script_rejects_wrong_token():
    redis_client.set("lock:resource", "correct-token")

    # Intentar liberar con un token incorrecto no debe borrar el lock
    redis_client.eval(RELEASE_SCRIPT, 1, "lock:resource", "wrong-token")
    assert redis_client.get("lock:resource") == b"correct-token"

    # Liberar con el token correcto sí debe borrarlo
    redis_client.eval(RELEASE_SCRIPT, 1, "lock:resource", "correct-token")
    assert redis_client.get("lock:resource") is None
```

### Pruebas de carga con `redis-benchmark` y `memtier_benchmark`

```bash
# Benchmark estándar incluido con Redis — bueno para comparativas rápidas
redis-benchmark -h redis.staging -p 6379 -a "$PASSWORD" \
  -t set,get,incr,lpush \
  -n 1000000 -c 50 -P 16 -q
```

```bash
# memtier_benchmark (Redis Labs) — más control sobre distribución de tamaños de payload,
# ratio lectura/escritura, y patrones de acceso que se acercan más a tráfico real
memtier_benchmark -s redis.staging -p 6379 -a "$PASSWORD" \
  --ratio=1:9 \
  --key-pattern=R:R \
  --data-size=512 \
  --clients=50 --threads=4 \
  --test-time=120
```
`--ratio=1:9` simula un patrón realista de caché (1 escritura por cada 9 lecturas) en vez del 50/50 por defecto de `redis-benchmark`, que rara vez refleja tráfico real de producción.

### Validar comportamiento ante failover (Módulo 06) — prueba de resiliencia dirigida

```bash
# En staging, con Sentinel configurado (Módulo 06, sección 3.1):

# 1. Lanzar tráfico continuo desde la aplicación de prueba
# 2. Mientras el tráfico corre, forzar la caída del primario
sudo systemctl stop redis-server   # en el host del primario

# 3. Medir: ¿cuántos requests fallaron durante la ventana de failover?
#    ¿el cliente se reconectó automáticamente al nuevo primario sin intervención manual?
#    ¿hubo escrituras confirmadas al cliente que se perdieron (Módulo 06, sección 2.3)?
```

Esto no es opcional para sistemas donde la disponibilidad de Redis es crítica — es la única forma real de conocer el tiempo de indisponibilidad efectivo que tu aplicación experimenta durante un failover, en vez de asumir la cifra de `failover-timeout` de la configuración como si fuera garantía.

---

## 3. Implementación Paso a Paso (Hands-On) — checklist de suite de testing

| Qué probar | Nivel | Frecuencia recomendada |
|---|---|---|
| Lógica de negocio con Redis mockeado | Unitario | Cada commit (CI) |
| Comandos reales, TTLs, scripts Lua | Integración (contenedor efímero) | Cada commit (CI) |
| Locks y patrones de concurrencia bajo carga real | Integración + concurrencia dirigida | Cada release, o al modificar el patrón |
| Throughput y latencia bajo volumen esperado | Carga | Antes de cambios de capacidad, tras cambios de configuración de memoria/persistencia |
| Comportamiento ante failover | Resiliencia | Periódicamente en staging (trimestral es un punto de partida razonable), y tras cualquier cambio de topología |

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Confiar únicamente en `fakeredis` o mocks para validar patrones de concurrencia.** Ver sección 2.1 — un mock no puede reproducir una condición de carrera real entre procesos, porque no hay procesos reales compitiendo.

- ❌ **Testear el patrón de lock del Módulo 05 con llamadas secuenciales en vez de concurrencia genuina.** El bug que corrige el token de propiedad solo se manifiesta bajo competencia real — un test secuencial siempre "pasa" independientemente de si el patrón es correcto.

- ❌ **Usar `redis-benchmark` con su ratio 50/50 por defecto como única medición de capacidad**, cuando el tráfico real de tu aplicación es predominantemente de lectura (o escritura). Ajusta el patrón de prueba a tu realidad, no al default de la herramienta.

- ❌ **No probar failover nunca hasta que ocurre en producción por primera vez sin haber sido planeado.** Ver Módulo 06, sección 3.1 y este módulo, sección 2.6 — es una prueba que se puede y se debe ejecutar de forma controlada en staging.

- ✅ **Usa contenedores efímeros (Testcontainers o equivalente) para integración en CI**, no una instancia compartida de Redis de "desarrollo" que acumula estado entre ejecuciones de tests y genera falsos positivos/negativos intermitentes.

- ✅ **Incluye pruebas explícitas de scripts Lua con casos de rechazo** (sección 2.4), no solo el camino feliz — el propósito del script de liberación de lock es precisamente rechazar tokens incorrectos, y eso merece su propio test dedicado.

- ✅ **Documenta el resultado de cada prueba de resiliencia** (tiempo de indisponibilidad medido, escrituras perdidas si las hubo) como un dato de arquitectura conocido, no como un ejercicio que se hace una vez y se olvida.