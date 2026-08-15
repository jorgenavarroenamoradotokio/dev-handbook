> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Alta Disponibilidad y Escalabilidad](#1-alta-disponibilidad-y-escalabilidad)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Replicación asíncrona — el mecanismo base](#replicación-asíncrona--el-mecanismo-base)
  - [Sentinel — failover automático](#sentinel--failover-automático)
  - [La ventana de pérdida de datos en un failover — sé explícito sobre esto](#la-ventana-de-pérdida-de-datos-en-un-failover--sé-explícito-sobre-esto)
  - [Redis Cluster — particionado horizontal](#redis-cluster--particionado-horizontal)
  - [Hash tags — controlar en qué slot cae cada clave](#hash-tags--controlar-en-qué-slot-cae-cada-clave)
  - [❌ MAL](#-mal)
  - [✅ BIEN — si necesitas atomicidad multi-clave, agrupa deliberadamente con hash tags](#-bien--si-necesitas-atomicidad-multi-clave-agrupa-deliberadamente-con-hash-tags)
  - [Resharding — mover slots sin downtime](#resharding--mover-slots-sin-downtime)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Simular un failover con Sentinel (staging, no producción)](#simular-un-failover-con-sentinel-staging-no-producción)
  - [Verificar el estado de salud de un Cluster](#verificar-el-estado-de-salud-de-un-cluster)
  - [Elegir entre replicación+Sentinel y Cluster — decisión práctica](#elegir-entre-replicaciónsentinel-y-cluster--decisión-práctica)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Alta Disponibilidad y Escalabilidad

Una única instancia de Redis tiene dos límites duros: **disponibilidad** (si el proceso o el host caen, el servicio entero cae con él) y **capacidad** (el dataset está acotado por la RAM de una sola máquina, y el throughput por un único hilo ejecutando comandos, Módulo 00). Este módulo cubre las dos soluciones de Redis a esos límites — que son **mecanismos distintos para problemas distintos**, y mezclar sus propósitos es el error conceptual más común en esta área:

- **Replicación + Sentinel** resuelve disponibilidad: si el nodo principal cae, otro toma su lugar automáticamente. No aumenta la capacidad de escritura ni el tamaño máximo del dataset.
- **Redis Cluster** resuelve capacidad: particiona el dataset entre múltiples nodos, cada uno con su propio límite de RAM y su propio hilo de ejecución. Opcionalmente, cada partición del Cluster puede tener también sus propias réplicas para disponibilidad.

**Analogía:** la replicación con Sentinel es tener un **piloto suplente** que toma los mandos si el piloto principal se incapacita — el avión sigue siendo uno solo, con la misma capacidad de pasajeros. Redis Cluster es **dividir la carga entre varios aviones** — cada uno lleva una parte de los pasajeros (los datos), y puedes añadir más aviones si necesitas transportar a más gente de la que cabe en uno solo. Un Cluster bien diseñado tiene, además, un piloto suplente en cada avión.

**Importante como principio de diseño, no como detalle técnico:** Redis prioriza disponibilidad y rendimiento sobre consistencia estricta — es un sistema **AP**, no CP, en términos del teorema CAP. La replicación es asíncrona por defecto: es posible perder escrituras confirmadas al cliente si el nodo principal cae antes de replicarlas. Esto se detalla en la sección 2.3, y define expectativas realistas frente a "Redis nunca pierde datos si tengo réplicas", que es falso.

---

## 2. Arquitectura y Componentes

### Replicación asíncrona — el mecanismo base

Un nodo **replica** (secundario) mantiene una copia del dataset del nodo **primario**, aplicando el stream de comandos de escritura que el primario le envía.

```bash
# En el nodo réplica
REPLICAOF <ip-del-primario> 6379

# Verificar el estado de replicación
INFO replication
```

```
role:slave
master_host:10.0.1.10
master_link_status:up
master_repl_offset:184920
slave_repl_offset:184920
```

`master_repl_offset` vs `slave_repl_offset` te dice cuánto va retrasada la réplica respecto al primario — en bytes del stream de replicación, no en tiempo directamente, pero un salto creciente entre ambos valores indica retraso acumulándose.

**Uso legítimo de las réplicas más allá de failover:** escalar lecturas repartiendo tráfico de solo-lectura entre varias réplicas (`READONLY` en el cliente o vía proxy), y aislar cargas de analítica pesada (`SCAN` masivos, exports) del primario que sirve tráfico transaccional.

### Sentinel — failover automático

Sentinel es un proceso independiente (se ejecutan típicamente 3 o 5 instancias, en hosts distintos) que monitoriza primario y réplicas, y **promueve automáticamente una réplica a primario** si detecta que el primario dejó de responder.

```conf
# sentinel.conf
sentinel monitor mymaster 10.0.1.10 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 60000
sentinel parallel-syncs mymaster 1
```

El `2` en `sentinel monitor mymaster 10.0.1.10 6379 2` es el **quorum**: número mínimo de Sentinels que deben coincidir en que el primario está caído antes de iniciar un failover. Con 3 Sentinels y quorum 2, se necesita mayoría — esto evita que un Sentinel aislado por una partición de red (que ve al primario como caído solo porque *él* perdió conectividad, no porque el primario realmente falló) dispare un failover innecesario.

**Por qué Sentinel necesita un número impar de nodos (típicamente 3 o 5), no 2:** con solo 2 Sentinels, una partición de red los deja a 1 y 1 — ninguno tiene mayoría propia, y el sistema no puede decidir con confianza. Con 3, una partición deja como mucho un grupo de 2 y uno de 1 — el grupo de 2 tiene quorum y puede actuar con seguridad.

**El cliente de la aplicación no se conecta directamente al primario por IP fija** — se conecta a Sentinel, que le informa cuál es el primario actual:

```python
from redis.sentinel import Sentinel

sentinel = Sentinel([('sentinel1', 26379), ('sentinel2', 26379), ('sentinel3', 26379)])
primario = sentinel.master_for('mymaster', socket_timeout=0.5)
replica  = sentinel.slave_for('mymaster', socket_timeout=0.5)

primario.set('key', 'value')
replica.get('key')
```

### La ventana de pérdida de datos en un failover — sé explícito sobre esto

La replicación es asíncrona: el primario confirma una escritura al cliente **antes** de que la réplica la haya recibido necesariamente. Si el primario cae en ese instante, esa escritura nunca llegó a la réplica que va a ser promovida — se pierde, aunque el cliente ya recibió confirmación de éxito.

```conf
# Mitigación parcial (no elimina el riesgo, lo acota):
# exige al menos 1 réplica confirmando escrituras recientes antes de aceptar más escrituras
min-replicas-to-write 1
min-replicas-max-lag 10
```

Esto no hace la replicación síncrona — reduce la ventana de inconsistencia rechazando escrituras si las réplicas están demasiado atrasadas, a costa de disponibilidad de escritura si las réplicas no logran mantenerse al día.

### Redis Cluster — particionado horizontal

Redis Cluster divide el espacio de claves en **16384 hash slots**. Cada clave se asigna a un slot mediante `CRC16(key) % 16384`, y cada slot pertenece a exactamente un nodo primario del clúster (que puede tener sus propias réplicas).

```bash
# Crear un clúster con 3 primarios y 1 réplica por primario (6 nodos totales)
redis-cli --cluster create \
  10.0.1.10:6379 10.0.1.11:6379 10.0.1.12:6379 \
  10.0.1.13:6379 10.0.1.14:6379 10.0.1.15:6379 \
  --cluster-replicas 1
```

```bash
# Verificar distribución de slots
redis-cli -c -h 10.0.1.10 CLUSTER SLOTS
redis-cli -c -h 10.0.1.10 CLUSTER NODES
```

El flag `-c` en `redis-cli` habilita **modo cluster-aware**: si consultas una clave que no pertenece al nodo al que te conectaste, el cliente sigue automáticamente la redirección `MOVED` al nodo correcto. Sin `-c`, recibes el error de redirección crudo.

### Hash tags — controlar en qué slot cae cada clave

Por defecto, claves relacionadas pueden caer en slots (y por tanto nodos) distintos, lo que impide operaciones multi-clave atómicas o transacciones sobre ellas. Los **hash tags** (`{...}` dentro del nombre de la clave) fuerzan a que el hash se calcule solo sobre esa porción del nombre:

```bash
# Sin hash tag: pueden caer en nodos distintos, MGET/transacción fallaría entre ellas
SET order:88213:items "..."
SET order:88213:total "..."

# Con hash tag {order:88213}: ambas claves garantizado en el mismo slot/nodo
SET order:{88213}:items "..."
SET order:{88213}:total "..."

# Ahora esto funciona porque ambas claves están en el mismo nodo
MGET order:{88213}:items order:{88213}:total
```

### ❌ MAL
```bash
MSET user:1042:name "Ana" user:2001:email "x@y.com"
```
Si `user:1042:*` y `user:2001:*` caen en slots distintos, `MSET` sobre claves en nodos distintos falla directamente en Cluster (`CROSSSLOT` error) — no es una cuestión de rendimiento, es un error duro.

### ✅ BIEN — si necesitas atomicidad multi-clave, agrupa deliberadamente con hash tags
```bash
MSET user:{1042}:name "Ana" user:{1042}:email "ana@ejemplo.com"
```

### Resharding — mover slots sin downtime

Añadir o quitar nodos de un Cluster existente requiere redistribuir slots. Redis lo hace de forma incremental, sin bloquear el clúster completo:

```bash
# Añadir un nuevo nodo primario al clúster existente
redis-cli --cluster add-node 10.0.1.16:6379 10.0.1.10:6379

# Redistribuir slots hacia el nuevo nodo (mueve 1000 slots, ejemplo)
redis-cli --cluster reshard 10.0.1.10:6379 \
  --cluster-from all \
  --cluster-to <id-del-nuevo-nodo> \
  --cluster-slots 1000
```

**Lo que ocurre durante el resharding que debes anticipar:** mientras un slot está en tránsito entre dos nodos, las claves de ese slot concreto pueden requerir un salto adicional (`ASK` redirect) hasta que la migración de ese slot termina. Es transparente para clientes cluster-aware bien implementados, pero añade latencia puntual — planifica resharding fuera de picos de tráfico si el volumen a mover es grande, aunque técnicamente no requiera downtime.

---

## 3. Implementación Paso a Paso

### Simular un failover con Sentinel (staging, no producción)

```bash
# 1. Confirmar quién es el primario actual
redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster

# 2. Forzar caída del primario (simulación)
sudo systemctl stop redis-server   # en el host del primario

# 3. Observar el failover en los logs de Sentinel
tail -f /var/log/redis/sentinel.log
# busca líneas "+sdown", "+odown", "+switch-master"

# 4. Confirmar que Sentinel reporta el nuevo primario
redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
```

### Verificar el estado de salud de un Cluster

```bash
redis-cli --cluster check 10.0.1.10:6379
# Reporta: slots cubiertos, nodos caídos, desbalance de slots entre nodos
```

### Elegir entre replicación+Sentinel y Cluster — decisión práctica

| Situación | Recomendación |
|---|---|
| El dataset cabe cómodamente en un solo nodo, necesito tolerancia a fallos | Replicación + Sentinel |
| El dataset excede la RAM de un solo host viable, o el throughput de escritura supera lo que un hilo puede sostener | Redis Cluster |
| Necesito operaciones multi-clave atómicas sin restricciones de slot | Replicación + Sentinel (evita la complejidad de hash tags) |
| Ya opero Kubernetes/orquestación y quiero que el propio operador gestione topología | Evalúa un operador de Cluster (ej. Redis Operator) en vez de Sentinel manual |

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Asumir que tener réplicas significa cero pérdida de datos ante un failover.** Ver sección 2.3 — la replicación asíncrona por defecto tiene una ventana real de pérdida. Si tu caso de uso no la tolera, configura `min-replicas-to-write` y evalúa el trade-off de disponibilidad que introduce.

- ❌ **Desplegar Sentinel con 2 instancias en vez de un número impar (3, 5).** Con 2, cualquier partición de red deja al sistema sin mayoría clara para decidir un failover con seguridad.

- ❌ **Ignorar hash tags y descubrir `CROSSSLOT` errors en producción.** Diseña el esquema de nombrado de claves pensando en Cluster desde el principio si vas a operar en Cluster — migrar el naming de claves después de tener datos reales es mucho más costoso que decidirlo antes.

- ❌ **Confundir el propósito de Cluster con el de Sentinel y usar Cluster solo por "más disponibilidad" cuando el problema real es que un dataset ya no cabe en RAM.** Cluster añade complejidad operativa real (hash tags, resharding, clientes cluster-aware) — no la asumas si Sentinel resuelve tu problema real de disponibilidad sin esa complejidad.

- ❌ **Reshardear un clúster de producción bajo pico de tráfico sin necesidad.** Aunque no cause downtime, sí añade latencia por redirecciones `ASK` durante la migración de slots activos.

- ✅ **Monitoriza `master_repl_offset` vs `slave_repl_offset` de forma continua**, no solo durante incidentes — un retraso creciente es la señal temprana de que una réplica no va a estar al día si necesitas promoverla de emergencia.

- ✅ **Prueba el failover en staging de forma periódica** (sección 3.1), no solo lo despliegues y confíes en que funcionará cuando de verdad lo necesites.

- ✅ **Documenta explícitamente si tu instancia de Redis es AP (aceptas la ventana de pérdida asíncrona) o si has invertido en mitigarlo hacia más CP** (`min-replicas-to-write`, `appendfsync always` del Módulo 03) — esta decisión debería estar en tu documentación de arquitectura, no implícita en la configuración por defecto que nadie revisó.

---