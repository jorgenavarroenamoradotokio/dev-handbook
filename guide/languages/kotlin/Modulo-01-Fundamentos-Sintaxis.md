> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Introduccion](#1-introduccion)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Variables: `val` y `var`](#variables-val-y-var)
  - [Ámbito y ciclo de vida de las variables](#ámbito-y-ciclo-de-vida-de-las-variables)
  - [Inicialización diferida: `lateinit` y `lazy`](#inicialización-diferida-lateinit-y-lazy)
  - [Tipos de datos y su representación en la JVM](#tipos-de-datos-y-su-representación-en-la-jvm)
  - [Conversiones y Casting (Smart, Unsafe, Safe)](#conversiones-y-casting-smart-unsafe-safe)
  - [String: literales, templates y raw strings](#string-literales-templates-y-raw-strings)
  - [Operadores](#operadores)
  - [Null Safety](#null-safety)
  - [Estructuras de control](#estructuras-de-control)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Introduccion

Kotlin es un lenguaje de programación estáticamente tipado que corre sobre la JVM (y también compila a JavaScript y a binarios nativos vía Kotlin/Native), diseñado por JetBrains para eliminar categorías enteras de errores — sobre todo el `NullPointerException` — sin sacrificar el rendimiento ni la interoperabilidad con Java.

**El problema que resuelve:** en Java, cualquier referencia puede ser `null` en cualquier momento, y el compilador no te avisa. Eso genera el error en tiempo de ejecución más común de la historia del software empresarial (Tony Hoare, quien inventó la referencia nula en 1965, lo llamó públicamente su "error de mil millones de dólares"). Kotlin mueve esa comprobación del *runtime* al *compile time*: si tu código compila, es matemáticamente imposible que tengas un `NullPointerException` proveniente de una variable declarada como no-nula.

**Analogía:** piensa en el sistema de tipos de Kotlin como un control de aduanas en un aeropuerto. Java te deja subir al avión (ejecutar el programa) y solo descubre en pleno vuelo que llevabas algo prohibido (`null` donde no debía haber `null`) — el avión se cae. Kotlin te revisa la maleta en el mostrador (compilación): si algo puede ser nulo, te obliga a declararlo explícitamente y a manejarlo antes de embarcar. El vuelo nunca se cae por esa causa.

---

## 2. Arquitectura y Componentes

Antes de tocar sintaxis, hay tres piezas de "bajo el capó" que un desarrollador junior normalmente nunca ve, y que marcan la diferencia entre escribir Kotlin y *entender* Kotlin:

**a) Todo compila a bytecode JVM (o a JS/nativo).** El compilador `kotlinc` traduce tu código a bytecode `.class`, idéntico en naturaleza al que genera `javac`. Por eso puedes llamar código Java desde Kotlin y viceversa sin capas de traducción: comparten la misma máquina virtual y el mismo *classloader*.

**c) `val` no es lo mismo que `final` en el sentido de inmutabilidad de datos.** `val` congela la **referencia**, no el contenido:

```kotlin
val lista = mutableListOf(1, 2, 3)
lista.add(4)        // ✅ Válido: el contenido del objeto cambia
lista = mutableListOf(5) // ❌ Error de compilación: la referencia es fija
```

**b) El sistema de tipos primitivos vs. objetos es una ficción controlada por el compilador.** En el código fuente, `Int`, `Boolean`, `Char`, etc. son clases con métodos. Pero el compilador los optimiza a los tipos primitivos de la JVM (`int`, `boolean`, `char`) **siempre que puede probar que nunca serán `null`**. En el momento en que declaras `Int?` (nullable) o usas un tipo genérico como `List<Int>`, el compilador se ve forzado a *boxear* el valor — envolverlo en un objeto — con el consiguiente coste de memoria e indirección.

Esto no es un detalle académico: es la razón por la que existen `IntArray`, `DoubleArray`, `BooleanArray`, etc. como tipos separados de `Array<Int>`. `IntArray` se compila directamente a `int[]` de la JVM (sin boxing); `Array<Int>` se compila a `Integer[]` (con boxing de cada elemento). En un bucle de un millón de iteraciones, esa diferencia es medible en rendimiento real.

---

## 3. Implementación Paso a Paso

**Requisitos previos:** Kotlin 1.9+ / 2.0+, JDK 17+ (LTS vigente). Puedes ejecutar todos los ejemplos en el [Kotlin Playground](https://play.kotlinlang.org/) sin instalar nada, o localmente con `kotlinc archivo.kt -include-runtime -d app.jar`.

### Variables: `val` y `var`

```kotlin
val nombre = "Kotlin"   // Inmutable (equivalente a 'final' de Java) → úsalo por defecto
var edad = 10            // Mutable → solo cuando de verdad necesitas reasignar

// Inferencia de tipos: el compilador deduce el tipo, pero puedes ser explícito
val activo: Boolean = true
```

❌ **MAL** — usar `var` como hábito por costumbre de otros lenguajes:
```kotlin
var pi = 3.14159
var nombreUsuario = "ana"
```

✅ **BIEN** — `val` por defecto, `var` solo cuando el valor **debe** cambiar:
```kotlin
val pi = 3.14159
var contadorIntentos = 0  // legítimo: se reasigna en un bucle de reintentos
```

**Por qué importa:** el 90% de los bugs de concurrencia y de "estado inesperado" en código de producción vienen de mutabilidad innecesaria. Cada `var` es una pregunta que te vas a hacer seis meses después: *"¿quién cambió esto y cuándo?"*.

### Ámbito y ciclo de vida de las variables

| Ámbito | Dónde vive | Duración |
|---|---|---|
| **Local** | Dentro de una función o bloque `{ }` | Se destruye al salir del bloque (se libera de la pila o el objeto queda elegible para GC) |
| **De instancia** | Propiedad de una clase | Vive mientras exista el objeto (gestionada por el *Garbage Collector*) |
| **Estática** (`companion object`) | Asociada a la clase, no a la instancia | Vive mientras la clase esté cargada en memoria (una única copia compartida) |
| **Parámetro** | Firma de una función | Vive durante la ejecución de esa llamada |

**Valores por defecto al declarar sin inicializar** (aplica a propiedades de clase, no a variables locales — Kotlin nunca permite una variable local sin inicializar):

| Tipo | Valor por defecto |
|---|---|
| `Int`, `Long`, `Short`, `Byte` | `0` |
| `Float`, `Double` | `0.0` |
| `Boolean` | `false` |
| `Char` | `\u0000` |
| Tipo nullable (`String?`, etc.) | `null` |

### Inicialización diferida: `lateinit` y `lazy`

**Analogía:** `lateinit` es como reservar un casillero vacío con la promesa de que lo llenarás antes de necesitarlo — si lo abres antes de tiempo, el sistema te avisa con una excepción clara. `lazy` es un casillero que se llena **automáticamente y solo una vez**, la primera vez que alguien lo abre.

```kotlin
class Usuario {
    lateinit var nombre: String   // Debe ser 'var', no puede ser tipo primitivo (Int, Boolean...)

    fun inicializar() { nombre = "Carlos" }
    fun mostrar() {
        if (::nombre.isInitialized) println("Nombre: $nombre")
        else println("Aún no inicializado")
    }
}
```

```kotlin
val mensaje: String by lazy {
    println("Calculando (esto solo se imprime una vez)...")
    "Hola Kotlin"
}
// 'lazy' es thread-safe por defecto (modo LazyThreadSafetyMode.SYNCHRONIZED)
// En código de alto rendimiento con un solo hilo, puedes usar:
val rapido by lazy(LazyThreadSafetyMode.NONE) { calcularAlgoCostoso() }
```

❌ **MAL** — usar `lateinit` con tipos primitivos:
```kotlin
lateinit var edad: Int   // ❌ Error de compilación: lateinit no soporta tipos primitivos
```

✅ **BIEN** — para primitivos que se inicializan tarde, usa nullable o `Delegates.notNull()`:
```kotlin
var edad: Int by Delegates.notNull()
```

### Tipos de datos y su representación en la JVM

| Tipo Kotlin | Bits | Tipo JVM equivalente | Ejemplo |
|---|---|---|---|
| `Boolean` | 1 | `boolean` | `true` |
| `Byte` | 8 | `byte` | `10` |
| `Short` | 16 | `short` | `1000` |
| `Int` | 32 | `int` | `42` |
| `Long` | 64 | `long` | `42L` |
| `Float` | 32 | `float` | `3.14f` |
| `Double` | 64 | `double` | `2.718` |
| `Char` | 16 | `char` | `'A'`|
| `String` | — | `java.lang.String` | `"Hola"` |

Versiones sin signo (útiles en protocolos binarios, checksums, criptografía — donde no tiene sentido un valor negativo):

| Tipo | Rango |
|---|---|
| `UByte` | 0 a 255 |
| `UShort` | 0 a 65 535 |
| `UInt` | 0 a 4 294 967 295 |
| `ULong` | 0 a 18 446 744 073 709 551 615 |

### Conversiones y Casting (Smart, Unsafe, Safe)

Las conversiones numéricas son **siempre explícitas** en Kotlin (a diferencia de Java, que promociona automáticamente `int` a `long`). Esto evita pérdidas de precisión silenciosas.

```kotlin
val x: Int = 10
val y: Long = x.toLong()          // ✅ explícito
// val y: Long = x               // ❌ Error de compilación, ni siquiera esto está permitido

val floatVal: Float = 3.14f
val intFromFloat: Int = floatVal.toInt()  // 3 — pierde los decimales, y es tu responsabilidad saberlo
```

**Las tres formas de casting**, de más segura a más peligrosa:

```kotlin
// 1) Smart-cast: el compilador infiere el tipo tras un chequeo 'is'. No hay riesgo de excepción.
fun procesar(x: Any) {
    if (x is String) println(x.length)   // dentro del if, x YA es String
}

// 2) Safe-cast ('as?'): devuelve null si el cast falla, en vez de explotar. Úsalo casi siempre.
val dato: Any = 42
val texto: String? = dato as? String     // null, sin excepción
println(texto?.length ?: "No era String")

// 3) Unsafe-cast ('as'): lanza ClassCastException si falla. Reserválo para casos donde
//    estás 100% seguro del tipo (p.ej. tras deserializar un contrato de API ya validado).
val animal: Any = "Gato"
val nombreAnimal: String = animal as String   // OK
```

❌ **MAL** — usar `as` como default:
```kotlin
fun procesarRespuestaApi(json: Any): String {
    return json as String   // 💣 Si el backend cambia el formato, esto revienta en producción
}
```

✅ **BIEN** — `as?` + manejo explícito del caso nulo:
```kotlin
fun procesarRespuestaApi(json: Any): String {
    return json as? String ?: throw IllegalArgumentException("Formato de respuesta inesperado: $json")
}
```

### String: literales, templates y raw strings

```kotlin
val mensaje = "Hola, Kotlin"
println(mensaje.length)            // 12
println(mensaje.substring(0, 4))   // "Hola"
println(mensaje.contains("Kot"))   // true
println(mensaje.equals("hola, kotlin", ignoreCase = true)) // true
```

**String templates** — interpolación directa, sin concatenación manual:
```kotlin
val edad = 30
val saludo = "Tienes $edad años"
val futuro = "En 5 años tendrás ${edad + 5} años"   // ${} para expresiones, no solo variables
```

**Raw strings** (`"""..."""`) — ideales para JSON, SQL o *prompts* de LLM embebidos, sin escapar `\n` o `\"`:
```kotlin
val consultaSql = """
    SELECT id, nombre
    FROM usuarios
    WHERE activo = true
""".trimIndent()   // elimina la indentación común — sin esto, arrastras los espacios del código fuente
```

### Operadores

| Categoría | Operadores |
|---|---|
| Aritméticos | `+` `-` `*` `/` `%` `++` `--` |
| Asignación compuesta | `+=` `-=` `*=` `/=` `%=` |
| Comparación | `<` `>` `<=` `>=` `==` (igualdad **estructural**, llama a `equals()`) `!=` |
| Referencial | `===` (misma referencia de memoria) `!==` |
| Lógicos | `&&` `\|\|` `!` |

**Trampa clásica venida de Java:** `==` en Kotlin **no** compara referencias como en Java — compara contenido (`equals()`). Para comparar identidad de objeto (misma dirección de memoria) usas `===`.

```kotlin
val a = "hola"
val b = "hola"
println(a == b)   // true → mismo contenido
println(a === b)  // true en este caso por el pool de Strings de la JVM, pero NO confíes en esto para objetos propios

data class Punto(val x: Int, val y: Int)
val p1 = Punto(1, 1)
val p2 = Punto(1, 1)
println(p1 == p2)   // true → equals() generado por data class compara contenido
println(p1 === p2)  // false → son dos objetos distintos en memoria
```

### Null Safety

Este es el pilar diferencial del lenguaje (ver Gran Cuadro). Herramientas disponibles:

```kotlin
val nombre: String? = null

val longitud = nombre?.length ?: 0        // ?. llamada segura, ?: operador Elvis (valor por defecto)
val saludo = nombre ?: "Desconocido"

nombre?.let {
    println("El nombre tiene ${it.length} letras")   // solo se ejecuta si nombre NO es null
}

val obligatorio = nombre!!  // !! → "confío ciegamente". Lanza NPE si nombre es null.
```

❌ **MAL** — abusar de `!!` para silenciar al compilador:
```kotlin
fun obtenerUsuario(id: String): Usuario {
    val usuario = repositorio.buscar(id)
    return usuario!!   // 💣 Reintroduces el NullPointerException que Kotlin existe para evitar
}
```

✅ **BIEN** — modelar la ausencia de valor como parte del contrato de la función:
```kotlin
fun obtenerUsuario(id: String): Usuario? = repositorio.buscar(id)

// En el llamador, obligas a manejar el caso explícitamente:
val usuario = obtenerUsuario("123") ?: return println("Usuario no encontrado")
```

### Estructuras de control

```kotlin
// if como EXPRESIÓN (devuelve valor) — patrón idiomático en Kotlin, no como sentencia
val max = if (a > b) a else b

// when — reemplazo exhaustivo del switch de Java
when (x) {
    x < 0 -> println("Negativo")
    1 -> println("Uno")
    in 2..5 -> println("Rango")
    else -> println("Otro")
}

// when con tipos (equivalente a un pattern matching básico)
when (valor) {
    is Int -> println("Es un entero")
    is String -> println("Es un texto")
    else -> println("Tipo desconocido")
}
```

**Bucles:**
```kotlin
for (i in 1..5) println(i)                 // 1..5 inclusive
for (i in 1..10 step 2) println(i)          // 1, 3, 5, 7, 9
for (i in 5 downTo 1) println(i)            // 5, 4, 3, 2, 1
for (i in 0 until 5) println(i)             // 0..4, excluye el último

val frutas = listOf("Manzana", "Banana", "Naranja")
for (fruta in frutas) println(fruta)

while (x < 10) x++
do { println(x) } while (x < 10)
```

**Break, continue y etiquetas** (imprescindibles en bucles anidados):
```kotlin
outer@ for (i in 1..3) {
    for (j in 1..3) {
        if (i == 2) break@outer   // rompe el bucle EXTERNO, no solo el interno
    }
}
```

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | `fun f(): String = return "x"` | Mezclar sintaxis de cuerpo-expresión (`=`) con `return` — **no compila**. | `fun f(): String = "x"` o usa cuerpo con llaves: `fun f(): String { return "x" }` |
| 2 | Uso indiscriminado de `!!` | Reintroduce el `NullPointerException` que el lenguaje está diseñado para eliminar. | Usa `?.`, `?:`, `let`, o rediseña la función para que el `null` sea parte explícita del contrato. |
| 3 | `Array<Int>` en bucles críticos de rendimiento | Cada elemento se *boxea* como objeto `Integer`, con coste de memoria e indirección. | Usa `IntArray`, `DoubleArray`, `LongArray`, etc. cuando el rendimiento importa. |
| 4 | Comparar objetos propios con `===` esperando igualdad de contenido | `===` compara identidad de referencia, no contenido. | Usa `==` (que invoca `equals()`), y si es una clase de datos, apóyate en `data class` para que `equals()` se genere automáticamente. |
| 5 | `lateinit` en tipos primitivos (`Int`, `Boolean`) | El compilador lo rechaza: `lateinit` requiere un tipo referencia. | Usa `Int?` con valor por defecto, o `by Delegates.notNull<Int>()`. |
| 6 | Acceder a una propiedad `lateinit` antes de inicializarla | Lanza `UninitializedPropertyAccessException` en tiempo de ejecución — el compilador no te avisa. | Comprueba con `::propiedad.isInitialized` antes de acceder en rutas de código no garantizadas. |
| 7 | Usar `as` en vez de `as?` al deserializar datos externos (JSON, respuestas de API) | Cualquier cambio de formato en el backend provoca `ClassCastException` no controlada en producción. | Usa `as?` y maneja el `null` explícitamente con un mensaje de error significativo. |
| 8 | No usar `trimIndent()` en raw strings multilínea | El texto arrastra la indentación del código fuente, rompiendo formatos como JSON o SQL. | Encadena siempre `.trimIndent()` (o `.trimMargin()` si usas un prefijo como `|`). |

**Buenas prácticas de rendimiento y seguridad:**
- Prefiere `val` sobre `var` siempre que el valor no cambie — reduce superficie de bugs y facilita razonar sobre concurrencia.
- En APIs públicas, evita exponer tipos nullable innecesariamente: cada `?` en una firma pública es una responsabilidad que trasladas a quien consume tu código.
- Para checksums, protocolos de red o criptografía, usa los tipos sin signo (`UInt`, `ULong`) en vez de simular rangos positivos con `Int`.