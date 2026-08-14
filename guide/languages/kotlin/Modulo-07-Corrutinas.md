> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Corrutinas](#1-corrutinas)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Requisitos y configuración](#requisitos-y-configuración)
  - [`suspend`: la palabra clave que lo cambia todo](#suspend-la-palabra-clave-que-lo-cambia-todo)
  - [`runBlocking`, `launch` y `async/await`](#runblocking-launch-y-asyncawait)
  - [CoroutineScope y concurrencia estructurada](#coroutinescope-y-concurrencia-estructurada)
  - [Dispatchers: en qué hilo se ejecuta cada cosa](#dispatchers-en-qué-hilo-se-ejecuta-cada-cosa)
  - [Cancelación cooperativa](#cancelación-cooperativa)
  - [Manejo de excepciones en corrutinas](#manejo-de-excepciones-en-corrutinas)
  - [Flow: streams asíncronos](#flow-streams-asíncronos)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Corrutinas

Las corrutinas son el modelo de concurrencia de Kotlin: permiten escribir código asíncrono y no bloqueante con la misma sintaxis lineal y legible que código síncrono, sin la maraña de *callbacks* anidados ni el coste de memoria de un hilo del sistema operativo por cada operación concurrente.

**El problema real que resuelven:** un hilo (`Thread`) de la JVM reserva típicamente entre 512 KB y 1 MB de memoria de pila, y cambiar de contexto entre hilos tiene un coste real gestionado por el sistema operativo. Si tu servidor necesita atender 10.000 peticiones concurrentes esperando respuestas de red o de base de datos, 10.000 hilos del sistema operativo agotan la memoria y el *scheduler* del SO antes de agotar tu lógica de negocio. Las corrutinas son **ligeras**: puedes lanzar cientos de miles de ellas sobre un *pool* de un puñado de hilos reales, porque una corrutina suspendida no bloquea ningún hilo — simplemente libera el hilo para que otra corrutina lo use mientras espera.

**Analogía:** un hilo del sistema operativo es como un camarero que, al llevar un pedido a cocina, se queda plantado frente a la puerta esperando a que esté listo — mientras tanto, no puede atender ninguna otra mesa. Una corrutina es un camarero que deja el pedido en cocina, **anota dónde se quedó**, y va a atender otras mesas; cuando cocina avisa que el plato está listo, retoma exactamente donde lo dejó. Con el modelo de camarero-hilo necesitas cien camareros para cien mesas simultáneas; con el modelo de corrutina, cinco camareros pueden atender cien mesas sin que ninguna espere más de lo estrictamente necesario.

---

## 2. Arquitectura y Componentes

Esta es la sección más importante del módulo: entender **qué es realmente** una corrutina es lo que separa a quien copia patrones de `launch`/`async` de quien diseña sistemas concurrentes correctos.

**a) Una función `suspend` se transforma, en tiempo de compilación, en una máquina de estados.** No hay ninguna magia de "hilos ligeros" a nivel de sistema operativo — el compilador de Kotlin reescribe tu función `suspend` en una clase que implementa `Continuation`, con un campo entero que recuerda "en qué punto de la ejecución me quedé" y un método que retoma desde ahí. Cada punto de suspensión (`delay`, una llamada de red con `suspend`, etc.) es, bajo el capó, un `switch`/`when` sobre ese estado. Esto es exactamente lo mismo que hace un generador o una función `async`/`await` en otros lenguajes modernos (C#, Python) — Kotlin simplemente lo hace explícito en su documentación técnica.

**b) `Dispatchers` no crea hilos — decide en qué *pool* de hilos existente se ejecuta el código.** `Dispatchers.Default` usa un *pool* dimensionado al número de núcleos de CPU (pensado para cálculo intensivo); `Dispatchers.IO` usa un *pool* mucho más grande, pensado para operaciones que bloquean esperando I/O (red, disco, base de datos), donde tener más hilos que núcleos tiene sentido porque la mayoría están dormidos esperando una respuesta, no consumiendo CPU.

**c) La concurrencia estructurada (*structured concurrency*) es el principio de diseño central de toda la librería.** Toda corrutina vive dentro de un `CoroutineScope`, y ese scope define su ciclo de vida: si el scope se cancela, **todas** sus corrutinas hijas se cancelan en cascada; si una corrutina hija lanza una excepción no controlada, por defecto cancela a todas sus hermanas y propaga el error al padre. Esto es deliberado — evita la clase de bug más común en programación asíncrona no estructurada: corrutinas "huérfanas" que siguen ejecutándose después de que la pantalla, la petición HTTP o el proceso que las originó ya terminó, filtrando memoria y trabajo.

```
CoroutineScope (padre)
     ├── launch { A }     → si A lanza excepción, cancela a B y C, y propaga al padre
     ├── launch { B }
     └── launch { C }
```

---

## 3. Implementación Paso a Paso

### Requisitos y configuración

```kotlin
// build.gradle.kts
dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0")
}
```

### `suspend`: la palabra clave que lo cambia todo

```kotlin
suspend fun obtenerUsuario(id: String): Usuario {
    delay(1000)   // simula una llamada de red — NO bloquea el hilo, lo libera durante la espera
    return Usuario(id, "Nombre de ejemplo")
}
```

`suspend` marca una función como "puede pausarse y reanudarse sin bloquear el hilo que la ejecuta". Una función `suspend` **solo puede llamarse desde otra función `suspend` o desde dentro de un *builder* de corrutina** (`launch`, `async`, `runBlocking`) — el compilador lo exige, y es precisamente lo que garantiza que nunca llames código suspendible desde un contexto normal donde bloquearía accidentalmente.

### `runBlocking`, `launch` y `async/await`

| Builder | Bloquea el hilo actual | Devuelve | Uso típico |
|---|---|---|---|
| `runBlocking` | Sí | Resultado del bloque | Puente entre código bloqueante (ej. `fun main()`) y código de corrutinas — principalmente en tests y en el punto de entrada |
| `launch` | No | `Job` (sin resultado) | Disparar una tarea concurrente cuyo resultado no necesitas esperar directamente |
| `async` | No | `Deferred<T>` (con `.await()`) | Ejecutar una tarea concurrente de la que SÍ necesitas un valor de vuelta |

```kotlin
import kotlinx.coroutines.*

fun main() = runBlocking {
    val tiempo = measureTimeMillis {
        val uno = async { tareaPesada(1) }   // arranca inmediatamente, en paralelo
        val dos = async { tareaPesada(2) }   // arranca inmediatamente, en paralelo
        println("Resultado = ${uno.await() + dos.await()}")   // espera a ambas
    }
    println("Completado en $tiempo ms")   // ≈ el tiempo de la MÁS LENTA de las dos, no la suma
}
```

❌ **MAL** — usar `async` sin necesitar el resultado, cuando `launch` es suficiente:
```kotlin
async { guardarLog("evento") }   // resultado ignorado — semánticamente incorrecto, y si falla, el error queda "atrapado" en el Deferred hasta que alguien llame a .await()
```

✅ **BIEN**:
```kotlin
launch { guardarLog("evento") }   // comunica la intención real: "dispara y sigue"
```

### CoroutineScope y concurrencia estructurada

```kotlin
class ReproductorMultimedia {
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    fun reproducir() {
        scope.launch {
            cargarAudio()
            reproducirAudio()
        }
    }

    fun liberar() {
        scope.cancel()   // cancela TODAS las corrutinas lanzadas en este scope, de una vez
    }
}
```

Este patrón — un `CoroutineScope` ligado al ciclo de vida de un componente (una pantalla, un servicio, una conexión) — es la forma correcta de evitar fugas: cuando el componente muere, su scope se cancela, y con él, cualquier trabajo pendiente que ya no tiene sentido continuar.

### Dispatchers: en qué hilo se ejecuta cada cosa

| Dispatcher | Pensado para | Tamaño típico del pool |
|---|---|---|
| `Dispatchers.Default` | Cálculo intensivo de CPU (ordenar, parsear, procesar datos) | = número de núcleos de CPU |
| `Dispatchers.IO` | Operaciones bloqueantes de I/O (red, disco, base de datos) | Mucho mayor (decenas de hilos), porque la mayoría están dormidos esperando |
| `Dispatchers.Main` | Actualizar UI (Android, escritorio) | Un único hilo — el hilo de UI |
| `Dispatchers.Unconfined` | Casos avanzados, no confinado a ningún hilo concreto | — (evitar salvo que sepas exactamente por qué lo necesitas) |

```kotlin
suspend fun cargarYMostrarUsuario(id: String) {
    val usuario = withContext(Dispatchers.IO) {
        repositorio.buscarEnRed(id)   // trabajo de I/O, en el pool adecuado
    }
    withContext(Dispatchers.Main) {
        actualizarUI(usuario)         // vuelta al hilo de UI para pintar el resultado
    }
}
```

### Cancelación cooperativa

**Punto crítico que casi nadie explica bien:** cancelar una corrutina en Kotlin **no la mata a la fuerza** — es cooperativo. La corrutina debe "revisar" periódicamente si fue cancelada (algo que `delay`, `yield` y la mayoría de funciones `suspend` de la librería hacen automáticamente en cada punto de suspensión). Un bucle de cálculo puro sin ningún punto de suspensión **no se cancela nunca**, por mucho que llames a `.cancel()`.

```kotlin
val job = launch {
    var i = 0
    while (isActive) {           // comprobación explícita — necesaria en bucles de cómputo puro
        println("Trabajando... ${i++}")
        delay(500)                // punto de suspensión: aquí SÍ se comprueba la cancelación automáticamente
    }
}
delay(2000)
job.cancel()   // pide la cancelación; la corrutina la atenderá en el siguiente punto de comprobación
job.join()     // espera a que termine de cancelarse realmente
// o, combinado: job.cancelAndJoin()
```

### Manejo de excepciones en corrutinas

Este es el punto donde más bugs de producción aparecen, porque el comportamiento **no** es el mismo que un `try/catch` normal (ver Módulo 06, sección 2c).

```kotlin
// ❌ MAL — el try/catch NO captura nada, porque launch ya devolvió el control antes de fallar
fun cargarDatos() {
    try {
        scope.launch { obtenerUsuario("id-inexistente") }   // si esto lanza, el catch de fuera NUNCA lo ve
    } catch (e: Exception) {
        println("Esto nunca se imprime")
    }
}

// ✅ BIEN — el try/catch va DENTRO del bloque de la corrutina
fun cargarDatos() {
    scope.launch {
        try {
            obtenerUsuario("id-inexistente")
        } catch (e: Exception) {
            println("Error real capturado: ${e.message}")
        }
    }
}
```

**`CoroutineExceptionHandler`** — captura excepciones no manejadas a nivel de scope, como red de seguridad global (no reemplaza al `try/catch` local, lo complementa):

```kotlin
val manejador = CoroutineExceptionHandler { _, excepcion ->
    println("Excepción no capturada: ${excepcion.message}")
}

val scope = CoroutineScope(Dispatchers.Default + manejador)
scope.launch { throw RuntimeException("Fallo inesperado") }   // el manejador lo captura, no crashea el proceso
```

**`SupervisorJob`** — cambia el comportamiento por defecto de propagación de errores entre hermanas:

```kotlin
val supervisorScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

supervisorScope.launch { throw RuntimeException("Falla la tarea A") }   // A falla...
supervisorScope.launch { println("Tarea B sigue ejecutándose normalmente") }   // ...pero B NO se cancela
```

Sin `SupervisorJob` (con un `Job` normal), el fallo de A cancelaría automáticamente a B — es el comportamiento de concurrencia estructurada por defecto. `SupervisorJob` lo relaja deliberadamente para casos donde las tareas hijas son independientes entre sí (ej. varios *widgets* de una pantalla que no deberían caer todos porque uno falló).

### Flow: streams asíncronos

Cuando necesitas no un único valor asíncrono (`suspend fun`) sino una **secuencia** de valores asíncronos a lo largo del tiempo (actualizaciones de un sensor, resultados paginados, eventos), `Flow` es la herramienta — el equivalente asíncrono de `Sequence` (Módulo 02):

```kotlin
fun contadorCada1s(): Flow<Int> = flow {
    var i = 0
    while (true) {
        emit(i++)      // produce un valor
        delay(1000)
    }
}

suspend fun main() {
    contadorCada1s()
        .filter { it % 2 == 0 }
        .map { it * it }
        .take(5)
        .collect { println(it) }   // 'collect' es lo que realmente dispara la ejecución (Flow es "frío")
}
```

Igual que las `Sequence`, un `Flow` es **frío** (*cold*): no produce nada hasta que alguien llama a `collect`, y cada llamada a `collect` reinicia la producción desde el principio — a diferencia de un `StateFlow`/`SharedFlow`, que son "calientes" y comparten emisión entre múltiples colectores.

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | `try/catch` envolviendo un `launch { }` desde fuera | El bloque `try` ya terminó de evaluarse cuando la corrutina interna lanza la excepción de forma asíncrona — nunca se captura. | Coloca el `try/catch` **dentro** del bloque `launch`/`async`, o usa `CoroutineExceptionHandler` a nivel de scope. |
| 2 | Usar `GlobalScope.launch` en vez de un scope ligado al ciclo de vida del componente | La corrutina vive tanto como el proceso completo — fuga de memoria y trabajo huérfano si el componente que la originó ya no existe. | Crea un `CoroutineScope` propio ligado al ciclo de vida (o usa el que ofrezca tu framework: `viewModelScope`, `lifecycleScope`, etc.) y cancélalo explícitamente. |
| 3 | Bucle de cómputo puro sin ningún punto de suspensión, esperando que `.cancel()` lo detenga | La cancelación es cooperativa: sin un punto donde se compruebe, la corrutina nunca se entera de que fue cancelada. | Comprueba `isActive` explícitamente en bucles largos de cómputo, o inserta `yield()` periódicamente. |
| 4 | Llamar a una función bloqueante de I/O tradicional (ej. `Thread.sleep`, una librería JDBC síncrona) dentro de una corrutina sin `withContext(Dispatchers.IO)` | Bloquea un hilo real del *pool* de la corrutina, anulando la ventaja de ligereza que la corrutina te ofrece. | Envuelve siempre las llamadas bloqueantes con `withContext(Dispatchers.IO)`. |
| 5 | Usar `async { }` seguido inmediatamente de `.await()` en la misma línea, en vez de `launch`, cuando no necesitas el resultado | Ejecuta el trabajo de forma secuencial en lugar de aprovechar la concurrencia, y además usa la herramienta semánticamente equivocada (ver 3.3). | Usa `launch` cuando no necesites un valor de retorno; usa `async` solo cuando vayas a lanzar varias tareas en paralelo y esperarlas juntas con `.await()`. |
| 6 | Olvidar `SupervisorJob` en un scope donde las tareas hijas deben ser independientes entre sí | Un fallo en cualquier corrutina hija cancela automáticamente a todas sus hermanas — comportamiento no deseado si son tareas realmente independientes. | Usa `SupervisorJob()` explícitamente cuando el fallo de una tarea no debería afectar a las demás. |
| 7 | Llamar a `collect` sobre el mismo `Flow` esperando que comparta el trabajo entre varios colectores | Cada `collect` reinicia la producción desde cero — un `Flow` normal es frío, no comparte emisión. | Si necesitas compartir un flujo de datos entre múltiples consumidores, usa `StateFlow`/`SharedFlow` en vez de un `Flow` normal. |

**Buenas prácticas:**
- Nunca uses `GlobalScope` en código de producción salvo casos verdaderamente globales y justificados (es prácticamente siempre un antipatrón) — ata cada scope al ciclo de vida real de lo que representa.
- Trata `runBlocking` como una herramienta de frontera (tests, `fun main`), nunca como parte del código de negocio async — usarlo dentro de código que ya corre en una corrutina bloquea un hilo innecesariamente.
- Cuando lances varias tareas independientes en paralelo con `async`, llama a todos los `.await()` **después** de haber lanzado todas las tareas (como en el ejemplo 3.3) — llamar a `.await()` inmediatamente tras cada `async` individual serializa el trabajo y elimina el paralelismo.