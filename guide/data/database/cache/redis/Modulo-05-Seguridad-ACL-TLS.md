> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Seguridad](#1-seguridad)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [`requirepass` — autenticación legacy, un único usuario](#requirepass--autenticación-legacy-un-único-usuario)
  - [ACL (desde Redis 6.0) — usuarios y permisos granulares](#acl-desde-redis-60--usuarios-y-permisos-granulares)
    - [MAL](#mal)
    - [BIEN](#bien)
  - [Persistir las ACLs](#persistir-las-acls)
  - [TLS — cifrado en tránsito](#tls--cifrado-en-tránsito)
  - [Aislamiento de red — la capa que evita necesitar las demás con urgencia](#aislamiento-de-red--la-capa-que-evita-necesitar-las-demás-con-urgencia)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Migrar de `requirepass` a ACLs sin downtime](#migrar-de-requirepass-a-acls-sin-downtime)
  - [Auditar accesos y detectar uso indebido](#auditar-accesos-y-detectar-uso-indebido)
  - [Verificar que el puerto no cifrado esté realmente cerrado](#verificar-que-el-puerto-no-cifrado-esté-realmente-cerrado)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Seguridad

Redis, por diseño, prioriza rendimiento sobre defensa en profundidad: el protocolo RESP no tiene rate-limiting de intentos de autenticación, ni aislamiento de datos entre "bases" más allá de un índice numérico (`SELECT 0-15`), ni cifrado en tránsito por defecto. Esto no es un descuido — es coherente con su propósito original de ser un componente interno de infraestructura, no un servicio expuesto directamente a clientes no confiables.

**El problema que resuelve este módulo:** la seguridad de Redis no es "activar una opción", es **capas independientes que se refuerzan entre sí** — red, autenticación, autorización granular y cifrado. Fallar en una capa no debería significar comprometer el dataset completo.

**Analogía:** securizar Redis solo con `requirepass` es como poner una cerradura muy buena en la puerta principal de un edificio, pero dejar todas las puertas interiores sin cerradura y sin identificar quién puede entrar a qué piso. Las ACLs (sección 2.2) son las cerraduras de cada piso; TLS es que nadie pueda escuchar lo que dices por el pasillo; el aislamiento de red es que el edificio ni siquiera tenga entrada directa desde la calle.

---

## 2. Arquitectura y Componentes

### `requirepass` — autenticación legacy, un único usuario

Antes de Redis 6.0, la única autenticación disponible era una contraseña global compartida (`requirepass`), sin distinción de usuarios ni de permisos: quien conoce la contraseña puede ejecutar cualquier comando sobre cualquier clave, incluido `FLUSHALL`.

```bash
redis-cli -a "password" CONFIG SET requirepass "nueva-password"
```

**Por qué no es suficiente en producción moderna:** no hay forma de dar a un servicio de "solo lectura para analítica" acceso distinto al de un servicio con permisos de escritura completos. Todo o nada.

### ACL (desde Redis 6.0) — usuarios y permisos granulares

Las ACLs permiten definir **usuarios** con permisos específicos sobre **comandos** y **patrones de claves**. Esta es la forma correcta de gestionar acceso en cualquier instancia con más de un cliente/servicio conectándose.

```bash
# Usuario de solo lectura, limitado al namespace "cache:*"
ACL SETUSER analytics_readonly on >password_seguro \
  ~cache:* \
  +@read \
  -@write \
  -@dangerous

# Usuario de aplicación con permisos completos sobre su propio namespace,
# pero sin acceso a comandos administrativos
ACL SETUSER app_orders on >otro_password_seguro \
  ~order:* \
  ~inventory:* \
  +@all \
  -@admin \
  -@dangerous \
  -FLUSHALL -FLUSHDB -CONFIG -SHUTDOWN
```

| Elemento de la sintaxis | Significado |
|---|---|
| `on` / `off` | Usuario habilitado o deshabilitado |
| `>password` | Añade una contraseña (se puede repetir para rotación con doble password activa) |
| `~patron` | Restringe qué claves puede tocar (`~order:*` = solo claves bajo ese prefijo) |
| `+@categoria` / `-@categoria` | Permite/deniega categorías completas de comandos (`@read`, `@write`, `@admin`, `@dangerous`) |
| `+COMANDO` / `-COMANDO` | Permite/deniega un comando específico, con granularidad fina sobre la categoría |

**Categorías relevantes para separar responsabilidades:**

| Categoría | Incluye | Quién debería tenerla |
|---|---|---|
| `@read` | `GET`, `HGET`, `ZRANGE`... | Servicios de solo lectura, dashboards, réplicas de analítica |
| `@write` | `SET`, `HSET`, `DEL`... | Servicios de aplicación con necesidad real de escritura |
| `@admin` | `CONFIG`, `SHUTDOWN`, `DEBUG` | Solo operadores humanos o herramientas de infraestructura, nunca aplicaciones |
| `@dangerous` | `FLUSHALL`, `FLUSHDB`, `KEYS`, `MONITOR` | Nadie por defecto — habilítalo explícitamente y de forma temporal si es imprescindible |

#### MAL
```bash
# Un único usuario "app" con acceso total, compartido entre todos los microservicios
ACL SETUSER app on >password +@all ~*
```
Si un solo microservicio se ve comprometido (una dependencia con una vulnerabilidad, una credencial filtrada en un log), el atacante tiene el mismo nivel de acceso que el operador de la instancia completa.

#### BIEN
```bash
# Un usuario ACL por servicio, con el mínimo privilegio necesario
ACL SETUSER svc_notifications on >pw1 ~notif:* +@read +@write -@admin -@dangerous
ACL SETUSER svc_billing       on >pw2 ~billing:* +@read +@write -@admin -@dangerous
ACL SETUSER svc_analytics     on >pw3 ~* +@read -@write -@admin -@dangerous
```
Comprometer `svc_analytics` no da acceso de escritura a nada; comprometer `svc_notifications` no da visibilidad sobre `billing:*`.

### Persistir las ACLs

Las ACLs definidas con `ACL SETUSER` en caliente **no sobreviven un reinicio** salvo que las persistas:

```bash
# Opción A: archivo externo dedicado (recomendado — separa ACLs de la config general)
# En redis.conf:
aclfile /etc/redis/users.acl

# Guardar el estado actual de ACLs en ese archivo
ACL SAVE

# Opción B: definir usuarios directamente en redis.conf con directivas "user"
user svc_notifications on >pw1 ~notif:* +@read +@write -@admin -@dangerous
```

### TLS — cifrado en tránsito

Por defecto, Redis transmite en texto plano — cualquiera con acceso a la red por la que viaja el tráfico (un switch comprometido, una VPC mal segmentada) puede leer comandos, valores y la propia contraseña de autenticación. TLS cierra esto.

```conf
# redis.conf
tls-port 6380
port 0                          # deshabilita el puerto no cifrado por completo
tls-cert-file /etc/redis/tls/redis.crt
tls-key-file /etc/redis/tls/redis.key
tls-ca-cert-file /etc/redis/tls/ca.crt
tls-auth-clients yes            # exige certificado de cliente (mTLS), no solo servidor
```

```bash
redis-cli --tls \
  --cert /etc/redis/tls/client.crt \
  --key /etc/redis/tls/client.key \
  --cacert /etc/redis/tls/ca.crt \
  -h redis.internal -p 6380 ping
```

**`port 0` es la línea que de verdad importa aquí:** activar `tls-port` sin desactivar `port` dejas ambos escuchando — el atacante simplemente usa el puerto sin cifrar y TLS no aporta nada. Si necesitas coexistencia temporal durante una migración, documenta explícitamente la fecha en la que `port 0` se aplicará.

### Aislamiento de red — la capa que evita necesitar las demás con urgencia

Ninguna de las capas anteriores sustituye a no exponer Redis directamente. La postura por defecto correcta:

- Redis en una **subred privada** sin ruta directa desde Internet.
- Acceso solo desde los security groups / grupos de red de los servicios que legítimamente lo necesitan (no `0.0.0.0/0`).
- Si necesitas acceso administrativo puntual desde fuera de la red privada, un **bastion host** o túnel, nunca el puerto de Redis publicado directamente.

---

## 3. Implementación Paso a Paso

### Migrar de `requirepass` a ACLs sin downtime

```bash
# 1. Mantén requirepass activo mientras migras (compatibilidad con clientes existentes)
redis-cli -a "$OLD_PASSWORD" CONFIG GET requirepass

# 2. Crea el usuario "default" explícito con las mismas credenciales, y usuarios nuevos por servicio
redis-cli -a "$OLD_PASSWORD" ACL SETUSER default on >"$OLD_PASSWORD" ~* +@all

redis-cli -a "$OLD_PASSWORD" ACL SETUSER svc_orders on >"$(openssl rand -base64 24)" \
  ~order:* ~inventory:* +@read +@write -@admin -@dangerous

# 3. Migra cada servicio a su usuario dedicado, uno a uno, verificando conectividad
redis-cli --user svc_orders --pass "nueva-password" -h redis.internal ping

# 4. Una vez todos los servicios migrados, restringe o deshabilita "default"
redis-cli -a "$OLD_PASSWORD" ACL SETUSER default off

# 5. Persiste el estado
redis-cli -a "$OLD_PASSWORD" ACL SAVE
```

### Auditar accesos y detectar uso indebido

```bash
# Listar todos los usuarios ACL configurados
ACL LIST

# Ver qué comandos ha intentado ejecutar un usuario y le fueron denegados
ACL LOG

# Limpiar el log de auditoría tras revisarlo
ACL LOG RESET
```

### Verificar que el puerto no cifrado esté realmente cerrado

```bash
# Desde fuera del host, confirmar que el puerto 6379 (sin TLS) no responde
nc -zv redis.internal 6379    # debe fallar si port 0 está aplicado

# Confirmar que 6380 (TLS) sí responde y exige certificado
openssl s_client -connect redis.internal:6380 -cert client.crt -key client.key -CAfile ca.crt
```

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Un único usuario compartido entre todos los microservicios.** Ver sección 2.2 — elimina cualquier contención de daño ante una credencial filtrada.

- ❌ **Definir ACLs solo en caliente con `ACL SETUSER`, sin `ACL SAVE` ni `aclfile`.** Un reinicio del servicio vuelve al estado de configuración estática, revirtiendo silenciosamente tus restricciones de seguridad.

- ❌ **Activar `tls-port` sin poner `port 0`.** Deja el puerto sin cifrar abierto en paralelo — la vulnerabilidad más común al "añadir TLS" sin completar la migración.

- ❌ **Usar contraseñas de Redis hardcodeadas en `redis.conf` versionado en Git**, en vez de referenciarlas desde un gestor de secretos o inyectarlas vía variable de entorno en el arranque del servicio.

- ❌ **Confiar en `rename-command` como medida de seguridad primaria.** Renombrar `FLUSHALL` a una cadena aleatoria (mencionado en el Módulo 01) es una capa adicional de fricción, no una barrera real — cualquiera con acceso al binario o a `CONFIG GET` en ciertas configuraciones puede descubrirlo. Las ACLs (`-@dangerous`) son el control real; `rename-command` es defensa superficial complementaria, no sustituta.

- ✅ **Aplica el principio de mínimo privilegio por servicio, no por conveniencia de desarrollo.** Es más trabajo inicial definir un usuario ACL por servicio que compartir uno — es exactamente ese trabajo el que limita el radio de explosión de un incidente.

- ✅ **Revisa `ACL LOG` como parte de tu rutina de observabilidad**, no solo cuando sospechas un incidente. Intentos denegados repetidos desde un servicio son señal de una credencial mal rotada o de un ataque activo.

- ✅ **Rota credenciales de Redis con el mismo rigor que credenciales de base de datos relacional.** El hecho de que históricamente se tratara como "solo caché" no reduce el impacto real de una filtración cuando almacena sesiones, tokens o datos de negocio.