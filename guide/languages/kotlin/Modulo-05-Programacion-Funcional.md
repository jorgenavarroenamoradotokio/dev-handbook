> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Programacion funcional](#1-programacion-funcional)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Funciones: sintaxis base y valores por defecto](#funciones-sintaxis-base-y-valores-por-defecto)
  - [Funciones de extensión](#funciones-de-extensión)
  - [Funciones infix](#funciones-infix)
  - [Parámetros variables (`vararg`)](#parámetros-variables-vararg)
  - [Funciones de orden superior](#funciones-de-orden-superior)
  - [Lambdas en profundidad](#lambdas-en-profundidad)
  - [Scope functions: `let`, `also`, `run`, `apply`, `with`](#scope-functions-let-also-run-apply-with)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Programacion funcional

Este módulo cubre el conjunto de herramientas que hace que Kotlin se sienta radicalmente distinto a Java al escribirlo día a día: funciones como **ciudadanos de primera clase** (se pueden guardar en variables, pasar como argumentos, devolver desde otras funciones), extensiones que añaden comportamiento a clases que no puedes modificar, y las *scope functions*, que no existen como concepto en Java y que estructuran gran parte del código Kotlin idiomático.

**El problema que resuelven las funciones de orden superior y las lambdas:** antes de Java 8, para pasar "comportamiento" como parámetro había que crear una clase entera que implementara una interfaz con un único método (el patrón *Strategy*, con mucho ruido sintáctico). Kotlin (como el Java moderno) te permite pasar directamente el comportamiento — un bloque de código — como si fuera un valor.

**Analogía:** una función de orden superior es como contratar un servicio de catering y decirle "trae la comida, pero el postre lo elijo yo en el momento" — le estás pasando una decisión (una función) como parte del pedido, no un plato ya fijo. Las *scope functions*, por su parte, son como distintos tipos de notas adhesivas para trabajar sobre un objeto: unas te dejan "el objeto mismo" a mano (`this`), otras te dan "una copia con nombre" (`it`); unas te devuelven el resultado del trabajo, otras te devuelven el objeto original ya modificado.

---

## 2. Arquitectura y Componentes

**a) Una lambda no es magia del lenguaje — es azúcar sintáctica sobre una interfaz funcional.** Cuando escribes `val suma: (Int, Int) -> Int = { a, b -> a + b }`, el compilador genera, por debajo, una instancia de una clase que implementa `Function2<Int, Int, Int>` (la familia `FunctionN` de la librería estándar de Kotlin, una por número de parámetros). Esto tiene una consecuencia real de rendimiento: cada lambda que **captura** variables de su entorno (una *closure*) crea un objeto nuevo en el heap cada vez que se ejecuta el bloque que la contiene, salvo que el compilador pueda inlinearla.

**b) `inline` existe para eliminar exactamente ese coste.** Cuando marcas una función de orden superior como `inline`, el compilador **copia el bytecode del cuerpo de la lambda directamente en el punto de la llamada**, en vez de crear un objeto `Function` y hacer una llamada virtual. Esta es la razón técnica por la que `filter`, `map`, `forEach` y prácticamente toda la librería estándar de colecciones están marcadas `inline`: en código de alto rendimiento, encadenar diez `.filter().map()` con `inline` tiene coste cero de creación de objetos adicionales, comparado con la misma cadena sin `inline`.

```kotlin
inline fun <T> medir(bloque: () -> T): T {
    val inicio = System.nanoTime()
    val resultado = bloque()
    println("Tardó ${System.nanoTime() - inicio} ns")
    return resultado
}
```

**c) Las funciones de extensión son resolución estática, no polimorfismo real.** Esto es una fuente clásica de confusión: `fun String.gritar() = this.uppercase() + "!"` **parece** añadir un método a `String`, pero en realidad el compilador lo traduce a una función estática que recibe el `String` como primer parámetro oculto (`gritar(this: String)`). La consecuencia práctica: las extensiones se resuelven según el **tipo declarado** de la variable en tiempo de compilación, no según el tipo real del objeto en tiempo de ejecución — al contrario que los métodos de instancia normales, que sí participan en *dynamic dispatch* (Módulo 04, polimorfismo).

---

## 3. Implementación Paso a Paso

### Funciones: sintaxis base y valores por defecto

```kotlin
// Cuerpo de bloque
fun saludar(nombre: String): String {
    return "Hola, $nombre"
}

// Cuerpo de expresión — equivalente, más idiomático para funciones de una sola expresión
fun saludarCorto(nombre: String): String = "Hola, $nombre"

// Valores por defecto: evita la necesidad de sobrecargar la función
fun saludar(nombre: String = "Invitado") = println("Hola, $nombre")
```

**Argumentos con nombre** — se combinan con valores por defecto para dar claridad y flexibilidad real:

```kotlin
fun mostrar(job: String = "Administrador", language: String) = println("Trabajo $job - Lenguaje $language")

mostrar("Programador", "Kotlin")     // posicional
mostrar(language = "Kotlin")         // usa el 'job' por defecto, salta directo al que necesita
```

### Funciones de extensión

```kotlin
fun String.mayusculas(): String = this.uppercase()

val msg = "hola"
println(msg.mayusculas())   // "HOLA" — se lee como si fuera un método nativo de String
```

Uso real de producción: añadir comportamiento a clases de librerías externas (Java, Android SDK) que no puedes modificar directamente.

```kotlin
fun Double.aPesos(): String = "$%.2f".format(this)
println(19.9.aPesos())   // "$19.90"
```

### Funciones infix

```kotlin
infix fun Int.por(x: Int) = this * x
println(5 por 3)   // 15 — se lee casi como lenguaje natural
```

Requisitos técnicos para declarar una función `infix`: debe ser una función miembro o de extensión, con **exactamente un parámetro**, y sin valor por defecto para ese parámetro.

### Parámetros variables (`vararg`)

```kotlin
fun imprimir(vararg mensajes: String) {
    for (m in mensajes) println(m)
}

imprimir("uno", "dos", "tres")

val arrayDeStrings = arrayOf("a", "b", "c")
imprimir(*arrayDeStrings)   // operador spread '*' para expandir un array existente
```

### Funciones de orden superior

```kotlin
fun operar(a: Int, b: Int, f: (Int, Int) -> Int): Int = f(a, b)

val suma = operar(2, 3) { x, y -> x + y }   // trailing lambda: fuera de los paréntesis
println(suma)   // 5
```

**Devolver una función desde otra función** (fábrica de comportamiento):

```kotlin
fun generadorDeMultiplicador(factor: Int): (Int) -> Int {
    return { numero -> numero * factor }   // esta lambda CAPTURA 'factor' de su entorno (closure)
}

val porTres = generadorDeMultiplicador(3)
println(porTres(4))   // 12
```

### Lambdas en profundidad

```kotlin
// Sintaxis general
val nombreLambda: (TipoParam) -> TipoRetorno = { parametro -> cuerpo }

// Sin parámetros
val saludar = { println("Hola Kotlin") }
saludar()

// Parámetro implícito 'it' — SOLO disponible cuando hay exactamente un parámetro
val cuadrado: (Int) -> Int = { it * it }
println(cuadrado(4))   // 16

// Múltiples parámetros: 'it' deja de estar disponible, hay que nombrarlos
val suma: (Int, Int) -> Int = { a, b -> a + b }
```

**`return` dentro de una lambda** — la trampa más común para quien empieza:

```kotlin
fun buscarPrimeroPar(numeros: List<Int>) {
    numeros.forEach {
        if (it % 2 == 0) return  // ❗ esto NO sale solo del forEach: sale de 'buscarPrimeroPar' entero
        println("Impar: $it")
    }
    println("Esto no se ejecuta si se encontró un par")
}
```

Para salir solo de la lambda (comportamiento tipo `continue`), se usa un `return` etiquetado:
```kotlin
numeros.forEach {
    if (it % 2 == 0) return@forEach   // sale solo de esta iteración de la lambda
    println("Impar: $it")
}
```

### Scope functions: `let`, `also`, `run`, `apply`, `with`

| Función | Referencia al objeto | Qué devuelve | Uso típico |
|---|---|---|---|
| `let` | `it` | Resultado del bloque | Ejecutar lógica solo si no es null; transformar un valor |
| `also` | `it` | El objeto original | Efectos secundarios (logging, validación) sin interrumpir una cadena |
| `run` | `this` | Resultado del bloque | Agrupar cálculo + devolver un valor, sobre un objeto existente |
| `apply` | `this` | El objeto original | Configurar/inicializar un objeto (builder pattern idiomático) |
| `with` | `this` (no es extensión, recibe el objeto como argumento) | Resultado del bloque | Agrupar varias operaciones sobre un objeto ya existente |

```kotlin
// let: transformar un valor nullable de forma segura
val nombre: String? = "Kotlin"
val longitud = nombre?.let { it.length } ?: 0

// also: efecto secundario en medio de una cadena, sin romperla
val lista = mutableListOf("A", "B")
    .also { println("Antes de añadir: $it") }
    .apply { add("C") }

// apply: patrón builder — configurar y devolver el MISMO objeto
data class Persona(var nombre: String = "", var edad: Int = 0)
val usuario = Persona().apply {
    nombre = "Carlos"
    edad = 25
}

// run: calcular algo y devolver el resultado, no el objeto
val longitudSegura = nombre?.run { length } ?: 0

// with: agrupar llamadas sobre un objeto ya existente (no es cadena fluida, es bloque)
val builder = StringBuilder()
val resultado = with(builder) {
    append("Hola, ")
    append("mundo!")
    toString()
}
```

**Cómo decidir cuál usar** — la pregunta correcta no es "¿cuál se ve mejor?", sino dos preguntas concretas:
1. ¿Necesito el objeto como `it` (para usarlo como argumento nombrado) o como `this` (para acceder a sus miembros directamente, como si estuvieras dentro de la clase)?
2. ¿Necesito que la expresión devuelva el objeto (para encadenar) o un resultado calculado?

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | Usar `return` normal dentro de una lambda pasada a `forEach`/`map`/etc. esperando que actúe como `continue` | Sale de la función **contenedora completa**, no solo de la iteración — comportamiento sorprendente y difícil de depurar. | Usa `return@nombreFuncion` (ej. `return@forEach`) para salir solo de la lambda actual. |
| 2 | Elegir `let`/`also`/`run`/`apply` al azar o "por costumbre visual" | Genera código que devuelve el valor equivocado (ej. usar `apply` cuando en realidad necesitabas el resultado calculado por `run`). | Aplica las dos preguntas de la sección 3.7 antes de elegir. |
| 3 | Encadenar más de 2-3 scope functions en una sola expresión | El código se vuelve ilegible y difícil de depurar (no puedes poner un breakpoint fácilmente en medio). | Si necesitas 3+ pasos, usa una función nombrada normal — es más legible que una cadena "elegante" indescifrable. |
| 4 | Marcar como `inline` una función que no recibe lambdas, o que recibe lambdas muy grandes | `inline` copia el bytecode en cada punto de llamada: en funciones grandes, esto infla el tamaño del `.class` sin beneficio real. | Reserva `inline` para funciones de orden superior pequeñas y muy usadas (el propio caso de uso que resuelve). |
| 5 | Depender de que una extensión se comporte como un método polimórfico | Las extensiones se resuelven por el tipo **declarado** en compilación, no por el tipo real en runtime — si declaras `Animal` pero el objeto real es `Perro`, se llama a la extensión de `Animal`, no a una "sobreescrita" en `Perro` (las extensiones no se pueden sobreescribir). | Si necesitas comportamiento polimórfico real, usa un método de instancia normal (`open`/`override`), no una extensión. |
| 6 | Usar `vararg` combinado con parámetros con nombre sin cuidar el orden | Kotlin exige que el parámetro `vararg` esté en una posición donde no genere ambigüedad; si no es el último, los siguientes deben pasarse con nombre obligatoriamente. | Coloca `vararg` al final de la lista de parámetros salvo que tengas una razón explícita, y usa nombres para lo que venga después. |

**Buenas prácticas:**
- Prefiere cuerpo de expresión (`fun f() = ...`) para funciones de una sola línea; usa cuerpo de bloque cuando haya lógica de varios pasos — mezclar ambos innecesariamente reduce legibilidad.
- Usa argumentos con nombre en llamadas con 3+ parámetros del mismo tipo (ej. varios `Int` o `String` seguidos) — evita errores de orden que el compilador no puede detectar.
- Cuando una función de orden superior es simple, corta y se usa en un *hot path* (bucle crítico, colección grande), márcala `inline` — es la diferencia real entre código "elegante" y código "elegante y rápido".