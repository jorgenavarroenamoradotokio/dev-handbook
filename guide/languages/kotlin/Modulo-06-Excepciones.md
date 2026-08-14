> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Excepciones](#1-excepciones)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Sintaxis base: try / catch / finally](#sintaxis-base-try--catch--finally)
  - [`try` como expresión](#try-como-expresión)
  - [Lanzar excepciones y `throw` como expresión](#lanzar-excepciones-y-throw-como-expresión)
  - [Excepciones personalizadas](#excepciones-personalizadas)
  - [`require`, `check` y `error`](#require-check-y-error)
  - [Gestión de recursos: `use`](#gestión-de-recursos-use)
  - [Excepciones vs. `sealed class` / `Result`](#excepciones-vs-sealed-class--result)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Excepciones

Una excepción es un mecanismo para interrumpir el flujo normal de ejecución cuando ocurre una condición que la función que la detecta no sabe cómo resolver, delegando la decisión a quien la llamó (y, si tampoco sabe, a quien llamó a ese, subiendo por la pila de llamadas hasta que alguien la maneje o el programa termine).

**La decisión de diseño más importante de Kotlin en este tema, y la que más sorprende a quien viene de Java:** Kotlin **no tiene excepciones comprobadas** (*checked exceptions*). En Java, si una función declara `throws IOException`, el compilador obliga a quien la llama a manejarla o repropagarla explícitamente. Kotlin elimina esa obligación por completo — todas las excepciones se comportan como las *unchecked* de Java (`RuntimeException`).

**El problema que esto resuelve (y el que introduce):** JetBrains decidió eliminar las excepciones comprobadas porque en la práctica llevaban a un antipatrón extendido en código Java: capturar la excepción y no hacer nada (`catch (Exception e) {}`) solo para satisfacer al compilador, ocultando errores reales. El coste es que en Kotlin **no hay ninguna garantía en tiempo de compilación de que manejaste un caso de error** — la disciplina depende enteramente de la documentación y de la cultura del equipo.

**Analogía:** una excepción comprobada en Java es como una alarma de incendios que no puedes silenciar sin antes confirmar por escrito que revisaste la causa. Kotlin te da una alarma que puedes silenciar con un botón, sin preguntas — es más rápido en el día a día, pero significa que el sistema ya no te obliga a mirar. La disciplina de "revisar antes de silenciar" pasa a ser tuya, no del compilador.

---

## 2. Arquitectura y Componentes

**a) Jerarquía real de excepciones (heredada directamente de Java, porque Kotlin corre sobre la JVM):**

```
Throwable
 ├── Error            (fallos graves del sistema: OutOfMemoryError, StackOverflowError — NO se capturan en código de negocio)
 └── Exception
      ├── RuntimeException   (todas las excepciones "normales" de Kotlin viven aquí conceptualmente)
      │    ├── NullPointerException
      │    ├── IllegalArgumentException   (generada por require())
      │    ├── IllegalStateException      (generada por check())
      │    ├── IndexOutOfBoundsException
      │    └── ClassCastException         (generada por 'as' fallido — Módulo 01)
      └── IOException, SQLException...    (checked en Java, pero Kotlin las trata igual que las demás)
```

**b) `Nothing` — el tipo que representa "esta función nunca retorna con normalidad".** `throw` es una **expresión**, no una sentencia, y su tipo es `Nothing`. `Nothing` es un subtipo de todos los tipos en el sistema de Kotlin, lo cual permite que el compilador acepte código como este sin quejarse de incompatibilidad de tipos:

```kotlin
fun obtenerValor(x: Int?): Int = x ?: throw IllegalArgumentException("x no puede ser null")
//                                     ^^^^^ tipo Nothing, compatible con cualquier rama de tipo Int
```

**c) El manejo de excepciones en corrutinas rompe las reglas de `try/catch` tradicionales.** Esto se cubre en profundidad en el Módulo 07, pero es importante saberlo ahora: un `try/catch` alrededor de un `launch {}` **no captura nada**, porque el bloque interno se ejecuta en otra corrutina, de forma asíncrona, después de que el `try` ya ha terminado de evaluarse. El manejo de errores en código concurrente requiere mecanismos específicos (`CoroutineExceptionHandler`, `supervisorScope`).

---

## 3. Implementación Paso a Paso

### Sintaxis base: try / catch / finally

```kotlin
try {
    val resultado = 10 / 0
} catch (e: ArithmeticException) {
    println("Error: ${e.message}")
} finally {
    println("Esto se ejecuta SIEMPRE, haya o no excepción")
}
```

Múltiples tipos de excepción, capturados de más específico a más general (Kotlin, como Java, evalúa los `catch` en orden y usa el primero que coincida):

```kotlin
try {
    procesarArchivo("datos.csv")
} catch (e: FileNotFoundException) {
    println("Archivo no encontrado: ${e.message}")
} catch (e: IOException) {
    println("Error de lectura: ${e.message}")
} catch (e: Exception) {
    println("Error inesperado: ${e.message}")   // red de seguridad, al final
}
```

### `try` como expresión

Igual que `if`, `try` puede **devolver un valor** — patrón muy usado en código idiomático de Kotlin:

```kotlin
val numero: Int = try {
    texto.toInt()
} catch (e: NumberFormatException) {
    0   // valor de recuperación si el parseo falla
}
```

### Lanzar excepciones y `throw` como expresión

```kotlin
fun validarEdad(edad: Int) {
    if (edad < 18) {
        throw IllegalArgumentException("Debe ser mayor de edad, recibido: $edad")
    }
}
```

Gracias a que `throw` tiene tipo `Nothing`, puedes usarlo directamente como rama de una expresión:

```kotlin
val edad = leerEdadDesdeInput() ?: throw IllegalStateException("No se pudo leer la edad")
```

### Excepciones personalizadas

Modelar errores de dominio con tus propias clases de excepción hace que el código de manejo de errores sea autoexplicativo:

```kotlin
class SaldoInsuficienteException(
    val saldoActual: Double,
    val montoSolicitado: Double
) : Exception("Saldo insuficiente: disponible $saldoActual, solicitado $montoSolicitado")

class CuentaBancaria(private var saldo: Double) {
    fun retirar(monto: Double) {
        if (monto > saldo) {
            throw SaldoInsuficienteException(saldoActual = saldo, montoSolicitado = monto)
        }
        saldo -= monto
    }
}

try {
    CuentaBancaria(100.0).retirar(500.0)
} catch (e: SaldoInsuficienteException) {
    println("No se pudo procesar: faltan ${e.montoSolicitado - e.saldoActual}")
    // acceso directo a los datos estructurados de la excepción, no solo al mensaje de texto
}
```

### `require`, `check` y `error`

Kotlin ofrece funciones estándar para validaciones que lanzan excepciones estándar con mensajes claros, evitando escribir `if (...) throw ...` repetidamente:

```kotlin
fun crearUsuario(nombre: String, edad: Int) {
    require(nombre.isNotBlank()) { "El nombre no puede estar vacío" }       // → IllegalArgumentException
    require(edad in 0..120) { "Edad fuera de rango: $edad" }                // → IllegalArgumentException

    check(baseDatosDisponible()) { "La base de datos no está disponible" }  // → IllegalStateException
}

fun procesar(estado: String) {
    when (estado) {
        "activo" -> println("Procesando")
        "inactivo" -> println("Ignorado")
        else -> error("Estado desconocido: $estado")   // → IllegalStateException, atajo de 'throw'
    }
}
```

**Diferencia semántica importante:** `require` valida **argumentos de entrada** (responsabilidad de quien llama); `check` valida **estado interno** del objeto/sistema (responsabilidad de la propia lógica). Elegir el correcto comunica dónde está el error con precisión.

### Gestión de recursos: `use`

Equivalente a `try-with-resources` de Java, pero como función de extensión sobre `Closeable`/`AutoCloseable`:

```kotlin
import java.io.File

fun leerPrimeraLinea(ruta: String): String {
    File(ruta).bufferedReader().use { reader ->
        return reader.readLine()
    }
    // 'use' garantiza que reader.close() se llama SIEMPRE, incluso si readLine() lanza excepción
}
```

### Excepciones vs. `sealed class` / `Result`

**Este es el criterio de diseño más importante del módulo, y el que casi ninguna guía introductoria cubre.** Las excepciones tienen un coste real (capturar el *stack trace* no es gratis, y romper el flujo de control con `throw`/`catch` es más lento que un `return` normal) y semánticamente deberían reservarse para condiciones **excepcionales** — no para flujo de control esperado del dominio de negocio.

```kotlin
// ❌ Usar excepciones para un caso de negocio ESPERADO (usuario no encontrado no es "excepcional")
fun buscarUsuario(id: String): Usuario {
    return repositorio.buscar(id) ?: throw UsuarioNoEncontradoException(id)
}

// ✅ Modelar el resultado esperado con sealed class — el llamador está obligado a manejar ambos casos
sealed class ResultadoBusqueda
data class Encontrado(val usuario: Usuario) : ResultadoBusqueda()
data class NoEncontrado(val id: String) : ResultadoBusqueda()

fun buscarUsuario(id: String): ResultadoBusqueda {
    val usuario = repositorio.buscar(id)
    return if (usuario != null) Encontrado(usuario) else NoEncontrado(id)
}
```

La librería estándar también ofrece `Result<T>` para este mismo propósito de forma genérica:

```kotlin
fun dividir(a: Int, b: Int): Result<Int> =
    if (b == 0) Result.failure(ArithmeticException("División por cero"))
    else Result.success(a / b)

dividir(10, 0)
    .onSuccess { println("Resultado: $it") }
    .onFailure { println("Error: ${it.message}") }
```

**Regla práctica:** reserva `throw`/excepciones para errores que de verdad rompen una invariante o un contrato técnico (I/O fallido, datos corruptos, configuración inválida). Para resultados de negocio donde "no encontrado" o "inválido" son casos normales y esperados, modela con `sealed class` o `Result<T>`.

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | `catch (e: Exception) {}` vacío | Silencia cualquier error, incluidos bugs graves, sin dejar rastro — el antipatrón más peligroso de manejo de errores. | Como mínimo, registra el error (`log.error(...)`) aunque decidas no repropagarlo. Nunca un catch completamente vacío. |
| 2 | Envolver un `launch { }` de corrutinas en un `try/catch` esperando capturar sus errores | El `try` ya terminó de ejecutarse cuando la corrutina lanza la excepción de forma asíncrona — no se captura nada. | Usa `CoroutineExceptionHandler` o pon el `try/catch` **dentro** del bloque de la corrutina (ver Módulo 07). |
| 3 | Usar excepciones para flujo de control esperado (ej. "usuario no encontrado", "validación de formulario") | Coste de rendimiento innecesario y fuerza al llamador a usar `try/catch` para casos que son parte normal del negocio. | Modela con `sealed class` o `Result<T>` cuando el "fallo" es un resultado esperado, no una condición excepcional. |
| 4 | Capturar `Exception` genérica antes que las excepciones específicas en la misma cadena `catch` | El compilador marca error o advertencia: el bloque genérico nunca se alcanza si está antes que uno más específico. | Ordena los `catch` de más específico a más genérico, siempre. |
| 5 | Abrir un recurso (`File`, conexión de red, `Closeable`) sin `use` | Si ocurre una excepción antes del cierre manual, el recurso queda abierto — fuga de descriptores de archivo/conexiones. | Usa siempre `use { }` para cualquier `Closeable`/`AutoCloseable`. |
| 6 | Confundir cuándo usar `require` vs. `check` | Comunica mal dónde está la responsabilidad del error: usar `check` para validar un argumento de entrada culpa al sistema de algo que es culpa del llamador. | `require` = "quien me llamó pasó algo inválido"; `check` = "mi propio estado interno es inválido". |
| 7 | Perder la causa original al relanzar una excepción envuelta | `throw MiExcepcion("algo falló")` sin pasar la excepción original oculta el *stack trace* real, dificultando la depuración en producción. | Usa el parámetro `cause`: `throw MiExcepcion("algo falló", cause = e)`. |

**Buenas prácticas:**
- Diseña tu jerarquía de excepciones personalizadas alrededor del **dominio del negocio**, no de la implementación técnica (`SaldoInsuficienteException` es mejor que `ValidacionException` genérica).
- En librerías o APIs públicas, documenta explícitamente qué excepciones puede lanzar cada función pública, ya que el compilador no te obliga a declararlo como en Java — es tu única red de seguridad para los consumidores de tu código.
- Prefiere `Result<T>` o `sealed class` sobre excepciones para cualquier función cuyo "camino de error" sea parte esperada del flujo normal (parseo de input de usuario, validación de formularios, llamadas de red con reintentos).