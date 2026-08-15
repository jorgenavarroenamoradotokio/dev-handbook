> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Redis](#1-redis)
  - [Cómo NO pensar en Redis](#cómo-no-pensar-en-redis)
  - [Cómo pensar en Redis](#cómo-pensar-en-redis)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Modelo single-threaded + event loop](#modelo-single-threaded--event-loop)
  - [Dónde SÍ hay paralelismo real](#dónde-sí-hay-paralelismo-real)
  - [Modelo de memoria y relación con la persistencia](#modelo-de-memoria-y-relación-con-la-persistencia)
- [3. Verificación Práctica](#3-verificación-práctica)
  - [Sobre la licencia y qué versión deberías tener delante](#sobre-la-licencia-y-qué-versión-deberías-tener-delante)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---


## 1. Redis

**Redis** (*REmote DIctionary Server*) es un almacén de estructuras de datos en memoria, usado como base de datos clave-valor, caché y message broker. Desde la versión 8.0 (mayo 2025) integra en el core capacidades que antes eran módulos separados: búsqueda vectorial, JSON nativo, series temporales y estructuras probabilísticas.

**El problema que resuelve:** las bases de datos relacionales tradicionales están optimizadas para durabilidad e integridad transaccional, no para velocidad de acceso. Cuando tu aplicación necesita leer el mismo dato miles de veces por segundo (un perfil de usuario, un contador, el estado de una sesión), pagar el coste de disco, parsing SQL y bloqueos de una base relacional en cada lectura es un desperdicio de recursos y una fuente de latencia innecesaria. Redis resuelve esto sirviendo los datos directamente desde RAM.

**Analogía:** piensa en una base de datos relacional como el **archivo central de una biblioteca** — todo está ahí, organizado, catalogado, pero para consultar un libro tienes que ir físicamente hasta la estantería correcta. Redis es el **escritorio del bibliotecario**: tiene encima los 50 libros que la gente pide constantemente. No sustituye al archivo central (ahí está la verdad completa y duradera), pero para el 90% de las consultas frecuentes, evita el viaje hasta la estantería.

### Cómo NO pensar en Redis
> "Redis es una base de datos rápida, así que voy a usarla como mi base de datos principal para todo."

Redis no reemplaza a una base de datos relacional o documental como fuente de verdad en la mayoría de los casos: la RAM es cara y volátil. Su persistencia (RDB/AOF, ver Módulo 03) es un mecanismo de **recuperación ante fallos**, no una garantía de durabilidad equivalente a un motor transaccional en disco con ACID completo.

### Cómo pensar en Redis
> "Redis es una capa de acceso ultrarrápido para datos que se consultan mucho más de lo que se escriben, para coordinación entre servicios (locks, colas, pub/sub), o para estructuras de datos que otras bases no ofrecen de forma nativa (sorted sets, HyperLogLog, streams)."

---

## 2. Arquitectura y Componentes

### Modelo single-threaded + event loop

El núcleo de ejecución de comandos en Redis es **single-threaded**: un único hilo procesa todos los comandos, uno detrás de otro, sin interrupciones entre ellos. Esto no es una limitación de diseño accidental — es una decisión deliberada.

**Por qué funciona:**
- **Atomicidad gratuita.** Como cada comando se ejecuta de principio a fin sin que otro comando se intercale, operaciones como `INCR` o `HSET` son atómicas por construcción, sin necesidad de locks explícitos ni de gestionar condiciones de carrera a nivel de aplicación.
- **Sin overhead de sincronización.** No hay mutexes, no hay cambios de contexto entre hilos compitiendo por la misma estructura de datos. Eso es tiempo de CPU que en un motor multi-hilo se gasta en coordinación, y que Redis dedica directamente a servir comandos.
- **I/O no bloqueante vía event loop.** Redis usa multiplexado de E/S (epoll en Linux, kqueue en BSD/macOS) para atender miles de conexiones concurrentes sin necesitar un hilo por conexión. El hilo principal nunca se queda "esperando" una operación de red; el sistema operativo le avisa cuándo un socket tiene datos listos.

**Analogía:** el hilo único de Redis es como un **cajero de ventanilla única extremadamente rápido**, en lugar de veinte cajeros lentos peleándose por la misma caja registradora. Atiende un cliente a la vez, pero cada atención dura microsegundos, así que el rendimiento agregado supera al de tener múltiples cajeros que constantemente tienen que coordinarse entre sí para no cobrar dos veces lo mismo.

### Dónde SÍ hay paralelismo real

Desde Redis 4.0/6.0 esto se matiza — es importante no repetir el mito de "Redis usa un solo hilo para todo":

| Componente | Hilo(s) | Motivo |
|---|---|---|
| Ejecución de comandos (`SET`, `GET`, `LPUSH`...) | 1 hilo principal | Atomicidad sin locks |
| I/O de red (lectura/escritura de sockets) | Multi-hilo opcional (`io-threads`, desde Redis 6.0) | Descargar el hilo principal del trabajo de serializar/deserializar el protocolo RESP |
| Borrado de claves grandes (`UNLINK`, expiración lazy) | Hilos en background | Evitar bloquear el hilo principal al liberar memoria de estructuras grandes |
| Persistencia RDB | Proceso hijo (fork) | El snapshot no compite por el hilo principal |
| Persistencia AOF (fsync) | Hilo en background | Escribir a disco sin bloquear comandos |

**Consecuencia práctica:** escalar Redis verticalmente (más CPU en un solo nodo) tiene rendimientos decrecientes más allá de cierto punto, porque el cuello de botella sigue siendo un único hilo ejecutando comandos. Para escalar de verdad, la vía es horizontal — replicación para lectura (Módulo 06) o particionado con Redis Cluster (Módulo 06) — no añadir más cores a una única instancia.

### Modelo de memoria y relación con la persistencia

Redis mantiene el dataset completo en RAM. Esto define su ventaja (latencia de microsegundos) y su restricción principal (el tamaño de tu dataset está limitado por la memoria disponible, no por el disco).

La persistencia (cubierta en profundidad en el **Módulo 03**) no es un "modo alternativo" de funcionamiento — Redis sigue sirviendo desde RAM siempre; RDB y AOF son mecanismos para que, tras un reinicio o fallo, el contenido de esa RAM pueda reconstruirse desde disco. Confundir esto lleva al error de pensar que Redis "escribe a disco cada vez", cuando en realidad la escritura a disco es asíncrona y desacoplada del camino de respuesta al cliente (salvo en configuraciones AOF `always`, que sacrifican rendimiento por durabilidad estricta).

---

## 3. Verificación Práctica

Antes de instalar (eso es el Módulo 01), esto te permite confirmar arquitectura y versión en cualquier instancia Redis a la que tengas acceso — útil para auditar entornos existentes.

```bash
# Conectarse a una instancia Redis
redis-cli -h <host> -p 6379

# Dentro de redis-cli: identificar versión, modo y arquitectura de memoria
INFO server
```

Salida relevante a inspeccionar (fragmento típico):

```
redis_version:8.10.2
redis_mode:standalone       # o "cluster" / "sentinel"
os:Linux 6.8.0-generic x86_64
arch_bits:64
process_id:1
run_id:...
io_threads_active:1         # confirma si io-threads está habilitado
```

```bash
# Ver estadísticas de memoria en tiempo real
INFO memory

# Confirmar la política de persistencia activa
CONFIG GET save
CONFIG GET appendonly
```

### Sobre la licencia y qué versión deberías tener delante

Esto no es una nota al pie — es un dato que debes verificar en cualquier auditoría de infraestructura, porque cambia obligaciones legales y opciones de proveedor gestionado:

| Línea de versión | Licencia | Estado |
|---|---|---|
| ≤ 7.2.4 | BSD-3-Clause | Última línea totalmente permisiva. Sin backports de seguridad garantizados a largo plazo. |
| 7.4 – 7.8 | RSALv2 / SSPLv1 (elección) | *Source-available*, no aprobada por OSI. Restringe ofrecer Redis como servicio gestionado competidor. |
| ≥ 8.0 | RSALv2 / SSPLv1 / **AGPLv3** (elección) | AGPLv3 es open source aprobado por OSI. Si tu organización tiene políticas estrictas de licenciamiento copyleft de red (AGPL obliga a publicar el código si expones el software como servicio de red modificado), esto requiere revisión legal. |
| **Valkey** (fork de Linux Foundation, desde 7.2.4) | BSD-3-Clause | Alternativa sin restricciones copyleft, API-compatible con Redis hasta el punto de fork. Relevante si tu política corporativa prohíbe AGPL/SSPL. |

**Decisión de arquitectura real, no teórica:** si vas a ofrecer Redis como parte de un servicio gestionado a terceros, o si tu departamento legal prohíbe AGPLv3, la conversación no es "Redis sí o no", es "Redis 8.x AGPL vs. Valkey BSD". Documenta esta decisión explícitamente en cualquier ADR (Architecture Decision Record) de tu proyecto — no la des por hecha.

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **"Single-threaded significa lento."** Falso. Significa *predecible y sin overhead de sincronización*. Redis maneja cientos de miles de operaciones por segundo en hardware modesto precisamente por esto. El single-thread es una limitación de *paralelismo*, no de *rendimiento absoluto* para las cargas de trabajo típicas de Redis (operaciones cortas, en memoria).

- ❌ **Ignorar que un comando O(N) bloquea todo lo demás.** Como hay un único hilo ejecutando comandos, un comando costoso (`KEYS *` sobre un dataset grande, un `SORT` sobre una lista enorme, un `SMEMBERS` de un set con millones de elementos) bloquea *todas* las demás operaciones mientras se ejecuta. Esto no es un edge case — es la causa más común de incidentes de latencia en producción con Redis. Se profundiza en el Módulo 08 (Troubleshooting), pero la regla de oro desde ya: **evita comandos que escaneen el dataset completo en producción; usa siempre las variantes con cursor (`SCAN`, `HSCAN`, `SSCAN`, `ZSCAN`)**.

- ❌ **Confundir "en memoria" con "sin garantías de durabilidad posibles."** Con AOF configurado en modo `everysec` o `always`, Redis puede ofrecer garantías de durabilidad razonables para la mayoría de los casos de negocio. La discusión seria no es "Redis pierde datos sí/no", es "qué ventana de pérdida aceptas a cambio de qué rendimiento" (se detalla en Módulo 03).

- ✅ **Verifica siempre `redis_version` y el modo (`standalone`/`cluster`/`sentinel`) antes de operar sobre una instancia que no configuraste tú.** Suposiciones equivocadas sobre la topología son la causa de más de un incidente de "por qué mis escrituras no se replican".

- ✅ **Trata la elección de licencia (Redis AGPL vs. Valkey BSD) como una decisión de arquitectura documentada**, no como un detalle que se resuelve solo porque "ya lo instalamos así".
