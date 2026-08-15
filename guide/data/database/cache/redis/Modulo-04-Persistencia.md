> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Persistencia](#1-persistencia)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [RDB — snapshots binarios](#rdb--snapshots-binarios)
  - [AOF — log de comandos append-only](#aof--log-de-comandos-append-only)
  - [⚠️ La decisión real no es técnica, es de negocio](#️-la-decisión-real-no-es-técnica-es-de-negocio)
  - [RDB vs. AOF — no es una elección excluyente](#rdb-vs-aof--no-es-una-elección-excluyente)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Verificar configuración de persistencia activa](#verificar-configuración-de-persistencia-activa)
  - [Forzar un snapshot manual](#forzar-un-snapshot-manual)
    - [nunca uses esto en un servidor con tráfico real Erroneo](#nunca-uses-esto-en-un-servidor-con-tráfico-real-erroneo)
  - [Activar AOF y forzar reescritura del log](#activar-aof-y-forzar-reescritura-del-log)
  - [Configuración completa recomendada (`redis.conf`)](#configuración-completa-recomendada-redisconf)
  - [Simular una recuperación (verificación real, no solo teórica)](#simular-una-recuperación-verificación-real-no-solo-teórica)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Persistencia

Redis mantiene todo el dataset en RAM (Módulo 00). La persistencia es el mecanismo para que, tras un reinicio, un crash del proceso o un fallo del host, ese contenido pueda **reconstruirse desde disco** en vez de perderse por completo. No es un "modo alternativo" de Redis — el camino de lectura/escritura siempre pasa por RAM; la persistencia ocurre en paralelo, de forma asíncrona en la mayoría de configuraciones.

**El problema que resuelve:** sin persistencia, cualquier reinicio del proceso (un deploy, un `OOM kill`, un fallo de hardware) borra el dataset completo. La pregunta que este módulo responde no es "¿activo persistencia sí o no?" — casi siempre sí — sino **"¿qué ventana de pérdida de datos acepto, a cambio de qué coste de rendimiento?"**. Esa pregunta no tiene una respuesta universal; depende de si Redis almacena en tu sistema una caché reconstruible o el estado autoritativo de algo que no existe en ningún otro sitio.

**Analogía:** RDB es como una **fotografía completa de la casa** cada cierto tiempo — rápida de tomar, rápida de restaurar, pero todo lo que pasó entre la última foto y el apagón, se pierde. AOF es como una **cámara de seguridad que graba cada movimiento** — no pierdes nada (o casi nada), pero grabar continuamente cuesta más recursos y "rebobinar" la grabación completa para reconstruir el estado tarda más que mirar una foto.

---

## 2. Arquitectura y Componentes

### RDB — snapshots binarios

**RDB significa Redis Database** (no "Backup" ni "Database Backup" — son nombres que circulan de forma imprecisa e incluso aparecían así, incorrectamente, en la versión anterior de esta guía). Es un archivo binario comprimido (`dump.rdb`) que contiene una foto completa del dataset en un instante concreto.

**Cómo se genera sin bloquear el hilo principal:** Redis usa `fork()` para crear un proceso hijo. Gracias a **copy-on-write** del sistema operativo, el proceso hijo comparte inicialmente toda la memoria con el padre sin duplicarla — solo cuando el padre modifica una página de memoria mientras el hijo sigue escribiendo el snapshot, el kernel duplica *esa página concreta*. El hilo principal (padre) sigue atendiendo comandos con normalidad durante todo el proceso; el hijo escribe el snapshot de forma independiente y termina.

**Consecuencia práctica del fork:** en datasets muy grandes con alta tasa de escritura durante el snapshot, el copy-on-write puede duplicar una fracción significativa de memoria de forma temporal. Si tu host está al límite de `maxmemory` justo cuando se dispara un `BGSAVE`, el pico de memoria del fork puede provocar presión de memoria o incluso un OOM — esto se retoma en el Módulo 07.

### AOF — log de comandos append-only

AOF (*Append Only File*) registra cada operación de escritura según se ejecuta, en un log que puede reproducirse secuencialmente para reconstruir el estado. Desde Redis 7.0, el formato AOF usa **multi-part AOF**: un archivo base (snapshot inicial) + archivos incrementales, reescritos periódicamente para no crecer indefinidamente (`BGREWRITEAOF`).

**El parámetro que define tu ventana de pérdida real: `appendfsync`**

| Valor | Cuándo se hace `fsync()` a disco | Pérdida máxima ante crash | Coste de rendimiento |
|---|---|---|---|
| `always` | Después de cada escritura | Prácticamente ninguna | Alto — cada comando espera confirmación de disco |
| `everysec` (default) | Una vez por segundo, en background | Hasta ~1 segundo de escrituras | Bajo — buen equilibrio para la mayoría de casos |
| `no` | Delegado al sistema operativo (puede tardar minutos) | Hasta lo que el SO tenga sin volcar — potencialmente varios GB en un sistema con mucha escritura | Mínimo — pero sin control real sobre cuándo se persiste |

### ⚠️ La decisión real no es técnica, es de negocio
`everysec` es el default razonable para la mayoría de aplicaciones. `always` solo se justifica cuando la pérdida de 1 segundo de datos es literalmente inaceptable para el caso de uso (ej. Redis como sistema de registro de transacciones financieras, no como caché) — y aun así, en ese escenario, evalúa seriamente si Redis debería ser la fuente de verdad o si necesitas un motor transaccional en disco delante.

### RDB vs. AOF — no es una elección excluyente

| | Solo RDB | Solo AOF | RDB + AOF (recomendado) |
|---|---|---|---|
| Pérdida máxima ante crash | Desde el último snapshot (minutos) | Según `appendfsync` (~1s con `everysec`) | Según `appendfsync` |
| Tamaño en disco | Compacto | Mayor (log de comandos) | Mayor, pero el RDB acelera el arranque |
| Velocidad de arranque tras reinicio | Rápida (carga snapshot binario) | Más lenta (reproduce el log completo) | Rápida — Redis usa el RDB embebido como base del AOF y aplica solo los incrementales |
| Uso típico | Backups periódicos, entornos donde perder minutos es aceptable | Cuando la durabilidad es prioridad sobre velocidad de arranque | Producción por defecto |

**Configuración recomendada por defecto en producción:**
```conf
appendonly yes
appendfsync everysec

save 3600 1
save 300 100
save 60 10000
```
Las líneas `save` definen los disparadores automáticos de `BGSAVE` (formato `save <segundos> <cambios_mínimos>`): "si han pasado 3600s y hubo al menos 1 cambio, o 300s con al menos 100 cambios, o 60s con al menos 10000 cambios, dispara un snapshot". Esto da una capa adicional de recuperación rápida (RDB) por encima de la durabilidad fina que ya da AOF.

---

## 3. Implementación Paso a Paso

### Verificar configuración de persistencia activa

```bash
redis-cli CONFIG GET save
redis-cli CONFIG GET appendonly
redis-cli CONFIG GET appendfsync
redis-cli CONFIG GET dir          # directorio donde se escriben dump.rdb / appendonlydir
```

### Forzar un snapshot manual

```bash
# BGSAVE: no bloqueante, usa fork() — la opción correcta en producción
redis-cli BGSAVE

# Verificar que terminó y cuándo fue el último snapshot exitoso
redis-cli INFO persistence | grep rdb_last_save_time
redis-cli INFO persistence | grep rdb_bgsave_in_progress
```

#### nunca uses esto en un servidor con tráfico real Erroneo
```bash
SAVE   # bloqueante: congela TODO el servidor hasta que termina el snapshot
```
`SAVE` ejecuta el snapshot en el hilo principal, sin fork. Durante datasets grandes, esto puede significar segundos u horas de indisponibilidad total. La única razón legítima para usar `SAVE` es un apagado controlado manual sin proceso hijo disponible (extremadamente raro) — en cualquier flujo automatizado, es siempre `BGSAVE`.

### Activar AOF y forzar reescritura del log

```bash
redis-cli CONFIG SET appendonly yes

# Reescribir el AOF de forma compacta (elimina comandos redundantes acumulados)
redis-cli BGREWRITEAOF

redis-cli INFO persistence | grep aof_rewrite_in_progress
```

### Configuración completa recomendada (`redis.conf`)

```conf
# --- RDB ---
save 3600 1
save 300 100
save 60 10000
dbfilename dump.rdb
dir /var/lib/redis

# --- AOF ---
appendonly yes
appendfsync everysec
appenddirname "appendonlydir"
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# Evita servir escrituras si la persistencia está fallando silenciosamente
# (protección explícita: prefieres error visible a pérdida de datos silenciosa)
stop-writes-on-bgsave-error yes
```

### Simular una recuperación (verificación real, no solo teórica)

```bash
# 1. Confirmar el estado actual
redis-cli DBSIZE

# 2. Forzar snapshot
redis-cli BGSAVE

# 3. Detener el servicio (simulando un crash)
sudo systemctl stop redis-server

# 4. Confirmar que el archivo existe donde CONFIG GET dir indicó
ls -la /var/lib/redis/dump.rdb

# 5. Arrancar de nuevo y verificar que el dataset se recuperó
sudo systemctl start redis-server
redis-cli DBSIZE   # debe coincidir con el paso 1 (o estar muy cerca, según ventana de AOF)
```

**Haz este ejercicio en un entorno de staging, no lo des por hecho.** Un plan de recuperación que nunca se probó no es un plan de recuperación — es una suposición.

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Confundir RDB con un backup completo y suficiente.** Un `dump.rdb` en el mismo disco/volumen que la instancia de Redis no te protege de un fallo de ese disco o esa instancia completa. Cópialo a almacenamiento externo (S3, otro host) de forma regular si es tu única capa de recuperación.

- ❌ **Usar `SAVE` en vez de `BGSAVE` en cualquier automatización o cron.** Ver sección 3.2 — bloquea el servidor completo.

- ❌ **Asumir que `appendfsync everysec` significa "cero pérdida de datos".** Significa hasta ~1 segundo de pérdida ante un crash del proceso, y potencialmente más si el propio sistema operativo o el disco fallan durante ese segundo. Documenta esta ventana como una cifra conocida, no como "prácticamente nunca pasa".

- ❌ **No monitorizar si la persistencia está fallando silenciosamente.** Sin `stop-writes-on-bgsave-error yes`, Redis puede seguir aceptando escrituras mientras el `BGSAVE` falla repetidamente (disco lleno, permisos) — sigues sirviendo tráfico creyendo que persistes, y no es así.

- ❌ **Fork de RDB en un host sin margen de memoria.** Si `maxmemory` está fijado muy cerca del límite físico disponible, el pico de copy-on-write durante un `BGSAVE` con alta tasa de escritura concurrente puede agotar la memoria. Deja margen (Módulo 01, sección "endurecimiento") pensando explícitamente en este escenario, no solo en el uso base del dataset.

- ✅ **En producción, la configuración por defecto razonable es RDB + AOF combinados**, con `appendfsync everysec`. Solo te apartas de esto si tienes una razón de negocio explícita y documentada (no "por si acaso").

- ✅ **Prueba la recuperación real periódicamente** (sección 3.5), especialmente después de cualquier cambio de configuración de persistencia. Un `dump.rdb` corrupto o un AOF truncado no se descubren leyendo la documentación — se descubren restaurando.

- ✅ **Diferencia explícitamente, para cada instancia de Redis que operes, si es caché reconstruible (persistencia opcional, prioriza rendimiento) o estado no reconstruible desde otra fuente (persistencia crítica, revisa `appendfsync always` o reconsidera si Redis debe ser la fuente de verdad).** Esta clasificación debería vivir en tu documentación de arquitectura, no solo en la cabeza de quien configuró la instancia.