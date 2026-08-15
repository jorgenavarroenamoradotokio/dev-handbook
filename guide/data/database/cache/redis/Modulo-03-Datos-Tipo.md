> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Modelado de datos y tipos](#1-modelado-de-datos-y-tipos)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Convención de nombrado de claves](#convención-de-nombrado-de-claves)
  - [MAL](#mal)
  - [BIEN](#bien)
  - [Mapa de tipos: cuándo usar cada uno](#mapa-de-tipos-cuándo-usar-cada-uno)
  - [El error de modelado más común: todo-en-un-string](#el-error-de-modelado-más-común-todo-en-un-string)
    - [Perfil de usuario como JSON serializado en un string Erroneo](#perfil-de-usuario-como-json-serializado-en-un-string-erroneo)
    - [Perfil de usuario como Hash Correcto](#perfil-de-usuario-como-hash-correcto)
  - [JSON nativo (Redis 8.x) vs. Hash vs. String](#json-nativo-redis-8x-vs-hash-vs-string)
  - [Vector Sets — búsqueda por similitud (novedad 8.0)](#vector-sets--búsqueda-por-similitud-novedad-80)
- [3. Implementación Paso a Paso (Hands-On)](#3-implementación-paso-a-paso-hands-on)
  - [String — contadores atómicos](#string--contadores-atómicos)
  - [List — cola de trabajo simple (FIFO)](#list--cola-de-trabajo-simple-fifo)
  - [Sorted Set — leaderboard](#sorted-set--leaderboard)
  - [Set — pertenencia y operaciones de conjunto](#set--pertenencia-y-operaciones-de-conjunto)
  - [HyperLogLog — conteo aproximado de únicos a escala](#hyperloglog--conteo-aproximado-de-únicos-a-escala)
  - [Geospatial — proximidad](#geospatial--proximidad)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Modelado de datos y tipos

Redis no es "una base de valores string con nombres raros". Cada tipo de dato que ofrece es una **estructura de datos con una API de operaciones específica**, elegida para resolver un problema de acceso concreto en O(1) o O(log N) en vez de forzarte a traer el dato entero, deserializarlo en tu aplicación y volver a guardarlo — que es lo que harías si todo fuera un string JSON.

**El problema que resuelve modelar bien:** usar el tipo equivocado no rompe la aplicación, pero convierte operaciones que deberían costar microsegundos en operaciones que cuestan milisegundos o que bloquean el hilo único (Módulo 00) por completo. Modelar datos en Redis es, en la práctica, **elegir la estructura cuya complejidad algorítmica coincide con el patrón de acceso real de tu aplicación.**

**Analogía:** si todo en Redis fuera un string, sería como guardar toda tu casa en cajas de mudanza sin etiquetar — para sacar un tenedor, sacas la caja de la cocina entera. Los tipos especializados (hash, list, set, sorted set...) son como tener cajones etiquetados: accedes directamente al compartimento que necesitas sin remover el resto.

---

## 2. Arquitectura y Componentes

### Convención de nombrado de claves

Redis no impone estructura en los nombres de clave — es texto plano. La convención de facto en la industria es **`namespace:entidad:id:atributo`**, separado por dos puntos:

```
user:1042:profile
user:1042:sessions
order:88213:items
cache:product:sku-778:pricing
```

### MAL
```
u1042
UserProfile_1042
"user 1042 profile"   # espacios: fuente de bugs al construir claves dinámicamente
```

### BIEN
```
user:1042:profile
```

**Por qué importa más allá de la legibilidad:** comandos como `SCAN` con patrones (`SCAN 0 MATCH user:1042:*`) y herramientas de observabilidad dependen de que el namespace sea consistente y prefijable. Un naming caótico hace imposible hacer introspección segura de un dataset en producción sin arriesgarte a un `KEYS *` completo (prohibido, ver Módulo 00 y 08).

### Mapa de tipos: cuándo usar cada uno

| Tipo | Estructura interna | Complejidad típica | Caso de uso real |
|---|---|---|---|
| **String** | Secuencia de bytes (hasta 512 MB) | O(1) lectura/escritura | Caché de valores simples, contadores (`INCR`), flags, JSON serializado pequeño |
| **Hash** | Mapa campo→valor | O(1) por campo | Objetos con múltiples atributos (perfil de usuario) sin traer el objeto completo para leer un campo |
| **List** | Lista doblemente enlazada (quicklist internamente) | O(1) en extremos, O(N) en medio | Colas FIFO/LIFO, feeds de actividad recientes, buffers de trabajo |
| **Set** | Tabla hash sin valores (o intset si son solo enteros) | O(1) membresía | Pertenencia sin duplicados, operaciones de conjuntos (unión/intersección) |
| **Sorted Set (ZSet)** | Skip list + tabla hash | O(log N) inserción/rango | Rankings, leaderboards, colas de prioridad, datos ordenados por timestamp |
| **Bitmap** | String tratado a nivel de bit | O(1) por bit | Flags masivos por ID (usuarios activos por día), estructuras de presencia |
| **HyperLogLog** | Estructura probabilística | O(1), memoria constante (~12 KB) | Conteo de elementos únicos aproximado a gran escala (visitantes únicos) |
| **Stream** | Log append-only con IDs | O(log N) | Event sourcing, colas de mensajes con consumer groups |
| **Geospatial** | Sorted set con geohash codificado | O(log N) | Búsquedas por proximidad (tiendas cercanas) |
| **JSON** (nativo desde 8.0, antes módulo RedisJSON) | Árbol de documento | O(1)-O(log N) según path | Documentos anidados que necesitas consultar/modificar parcialmente sin deserializar todo en la aplicación |
| **Vector Set** (nuevo en 8.0) | Estructura optimizada para similitud vectorial | Sublineal (HNSW) | Búsqueda semántica, RAG, recomendación por similitud de embeddings |

### El error de modelado más común: todo-en-un-string

#### Perfil de usuario como JSON serializado en un string Erroneo
```
SET user:1042:profile '{"name":"Ana","email":"ana@ejemplo.com","plan":"pro","last_login":"2026-08-14"}'
```
Para actualizar solo `last_login`, tienes que: `GET` el string completo, deserializar en tu aplicación, mutar el campo, serializar de nuevo, `SET` el string completo. Dos operaciones de red, transferencia de todo el payload por un solo campo, y una condición de carrera si dos procesos actualizan campos distintos al mismo tiempo (el segundo `SET` pisa el cambio del primero salvo que uses `WATCH`/`MULTI` o Lua).

#### Perfil de usuario como Hash Correcto
```bash
HSET user:1042:profile name "Ana" email "ana@ejemplo.com" plan "pro" last_login "2026-08-14"

# Actualizar un solo campo: una operación, atómica, sin traer el resto
HSET user:1042:profile last_login "2026-08-15"

# Leer un solo campo sin traer el objeto completo
HGET user:1042:profile plan
```

**Cuándo el string-JSON SÍ es correcto:** cuando el documento se lee y escribe siempre como unidad completa (nunca campos individuales) y necesitas estructuras anidadas profundas que un hash plano no representa bien. En ese caso, evalúa el tipo **JSON nativo** (sección 2.4) antes que un string, porque te da acceso por path sin perder la atomicidad de campo.

### JSON nativo (Redis 8.x) vs. Hash vs. String

Desde Redis 8.0, el soporte de JSON que antes era el módulo separado RedisJSON está integrado en el core.

```bash
JSON.SET user:1042:profile $ '{"name":"Ana","address":{"city":"Madrid","zip":"28001"},"tags":["pro","beta"]}'

# Leer solo un campo anidado, sin traer el documento completo
JSON.GET user:1042:profile $.address.city

# Modificar un campo anidado sin reescribir el documento
JSON.SET user:1042:profile $.address.city '"Barcelona"'

# Operar sobre un array anidado directamente
JSON.ARRAPPEND user:1042:profile $.tags '"enterprise"'
```

**Criterio de decisión real:**

| Necesitas... | Usa |
|---|---|
| Estructura plana de campo→valor, sin anidamiento | **Hash** |
| Documento con anidamiento real (objetos dentro de objetos, arrays de objetos) y necesitas consultar/mutar rutas específicas | **JSON nativo** |
| Blob que siempre se lee/escribe como unidad completa, sin necesidad de acceso parcial | **String** |

### Vector Sets — búsqueda por similitud (novedad 8.0)

Diseñado para embeddings de modelos de IA (búsqueda semántica, RAG, recomendación). Antes de 8.0 esto requería el módulo RediSearch por separado; ahora es un tipo de primer nivel.

```bash
# Añadir un vector (embedding) asociado a un elemento
VADD productos VALUES 4 0.12 0.98 -0.45 0.33 producto:778

# Buscar los N elementos más similares a un vector dado
VSIM productos VALUES 4 0.10 0.95 -0.40 0.30 COUNT 5
```

**Cuándo usarlo:** cuando ya generas embeddings (vía un modelo de lenguaje o de visión) y necesitas recuperar los K vecinos más cercanos con baja latencia — el caso clásico de RAG (Retrieval-Augmented Generation) o "productos similares a este". No es sustituto de una base de datos vectorial dedicada (Pinecone, Qdrant, Weaviate) si tu carga de trabajo es *exclusivamente* vectorial a gran escala; es la opción correcta cuando ya tienes Redis en tu stack y quieres evitar añadir un sistema más para un volumen moderado.

---

## 3. Implementación Paso a Paso (Hands-On)

### String — contadores atómicos

```bash
# Atómico: seguro con miles de escrituras concurrentes, sin condición de carrera
INCR page:home:views
INCRBY inventory:sku-778 -3   # decremento atómico de stock

# Expiración en la misma operación de escritura (evita una segunda llamada de red)
SET session:abc123 "user:1042" EX 1800   # expira en 1800s
```

### List — cola de trabajo simple (FIFO)

```bash
# Productor: encola al final
RPUSH queue:emails "user:1042:welcome"

# Consumidor: extrae del principio (bloqueante, evita polling activo)
BLPOP queue:emails 5   # espera hasta 5s si la cola está vacía
```

> Para colas de producción con garantías de entrega, reintentos y consumer groups, no uses `List` — usa **Streams** (`XADD`/`XREADGROUP`), cubierto en detalle en el Módulo 05 (Patrones de Arquitectura). `List` está bien para colas simples de un solo consumidor sin necesidad de reprocesar mensajes fallidos.

### Sorted Set — leaderboard

```bash
# Puntuación como score: inserción y actualización son la misma operación
ZADD leaderboard:weekly 1500 "player:42"
ZADD leaderboard:weekly 2300 "player:99"

# Top 10 con puntuación descendente
ZREVRANGE leaderboard:weekly 0 9 WITHSCORES

# Posición (ranking) de un jugador específico — O(log N), no requiere escanear todo
ZREVRANK leaderboard:weekly "player:42"
```

### Set — pertenencia y operaciones de conjunto

```bash
SADD user:1042:roles "editor" "reviewer"
SADD user:2001:roles "editor" "admin"

# Intersección: usuarios que comparten rol — operación nativa, no lógica en tu app
SINTER user:1042:roles user:2001:roles
```

### HyperLogLog — conteo aproximado de únicos a escala

```bash
# Cada visita registra el ID de usuario; HLL deduplica internamente
PFADD unique_visitors:2026-08-14 "user:1042" "user:2001" "user:1042"

# Cardinalidad aproximada (margen de error ~0.81%), memoria constante ~12KB
# sin importar si son 1.000 o 100.000.000 de elementos
PFCOUNT unique_visitors:2026-08-14
```

**Trade-off explícito:** no es exacto. Si necesitas el conteo exacto de un conjunto pequeño, usa `SCARD` sobre un `Set` normal. HyperLogLog es la herramienta correcta cuando el conteo exacto es inviable en memoria (millones/miles de millones de elementos) y un margen de error <1% es aceptable para el caso de negocio (analítica, no facturación).

### Geospatial — proximidad

```bash
GEOADD tiendas -3.7038 40.4168 "tienda:madrid-centro"
GEOADD tiendas 2.1734 41.3851 "tienda:barcelona-centro"

# Tiendas en un radio de 50km desde un punto dado
GEOSEARCH tiendas FROMLONLAT -3.70 40.41 BYRADIUS 50 km ASC
```

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Guardar objetos completos como JSON en un String cuando se actualizan campos individuales con frecuencia.** Ver sección 2.3 — es el antipatrón más extendido, generalmente por venir de un mindset de "Redis = caché de documentos" sin considerar el tipo Hash o JSON nativo.

- ❌ **Usar `List` como cola de producción sin mecanismo de reintento.** Si el consumidor extrae un mensaje con `BLPOP` y el proceso muere antes de completarlo, el mensaje se pierde — no hay ack ni reentrega. Para eso existen los Streams con consumer groups (Módulo 05).

- ❌ **Sets o Hashes que crecen sin límite conocido ("big keys").** Un `Set` con 5 millones de miembros bajo una sola clave no es un problema hasta que necesitas borrarlo, replicarlo, o migrarlo en un resharding de Cluster — entonces esa única clave se convierte en un cuello de botella que bloquea el hilo principal (Módulo 00) de forma desproporcionada. Vigila el tamaño con `MEMORY USAGE <key>` y considera particionar (`user:1042:roles:shard1`, etc.) si una clave crece sin cota clara. Se detalla en profundidad en el Módulo 07.

- ❌ **Elegir HyperLogLog cuando el negocio necesita el número exacto** (por ejemplo, para facturación por "usuarios activos"). El margen de error de ~0.81% es aceptable para un dashboard, no para un ciclo de cobro.

- ✅ **Usa `OBJECT ENCODING <key>` para verificar qué representación interna está usando Redis realmente** — Redis optimiza automáticamente estructuras pequeñas (ej. un hash con pocos campos se codifica como `listpack` en vez de tabla hash completa, mucho más compacto en memoria):
```bash
OBJECT ENCODING user:1042:profile
# listpack (pocos campos) vs. hashtable (muchos campos) — el umbral se configura
# con hash-max-listpack-entries / hash-max-listpack-value
```

- ✅ **Define un TTL explícito para cualquier clave que sea caché** (no datos primarios). Una clave de caché sin expiración es, con el tiempo, una fuga de memoria disfrazada de feature.