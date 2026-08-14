> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Que son las colecciones](#1-que-son-las-colecciones)
- [2. Propiedades](#2-propiedades)
- [3. Tipos](#3-tipos)
  - [Arrays](#arrays)
  - [List](#list)
  - [Set](#set)
  - [Map](#map)
  - [Operaciones funcionales sobre colecciones](#operaciones-funcionales-sobre-colecciones)
  - [Sequences: colecciones perezosas](#sequences-colecciones-perezosas)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Que son las colecciones

Una colección es una estructura que agrupa múltiples elementos bajo un mismo tipo, permitiéndote operar sobre todos ellos de forma coherente en vez de gestionar variables sueltas. Kotlin hereda el framework de colecciones de Java (`List`, `Set`, `Map` de `java.util`) pero le añade una capa crítica encima: **la distinción explícita entre interfaces de solo lectura y mutables**, algo que Java nunca tuvo de forma nativa.

**El problema que resuelve:** en Java, si una función recibe un `List<String>`, nada te garantiza que esa función no lo vaya a modificar por dentro — tienes que leer el código o confiar en la documentación. En Kotlin, si la firma dice `List<String>` (sin "mutable"), el compilador **prohíbe** llamar a `.add()` sobre esa referencia. El contrato de "esto no se toca" queda escrito en el sistema de tipos, no en un comentario.

**Analogía:** piensa en `List` como un menú de restaurante impreso — puedes leerlo, pero no puedes tacharle platos con un bolígrafo. `MutableList` es la pizarra de especiales del día: cualquiera con acceso puede borrar y escribir. Kotlin te obliga a decidir, en el momento de declarar la variable, cuál de las dos le estás entregando a cada función.

---

## 2. Propiedades

**a) "Inmutable" en Kotlin no siempre significa inmutable de verdad.** Esto sorprende a mucha gente: `listOf(...)` no crea una colección inmutable a nivel de implementación — crea una **interfaz de solo lectura** sobre un objeto que, por debajo, sigue siendo un `ArrayList` mutable de Java. Si alguien tiene una referencia al mismo objeto tipada como `MutableList`, puede modificarlo, y tu referencia `List` verá el cambio.

```kotlin
val mutable: MutableList<Int> = mutableListOf(1, 2, 3)
val soloLectura: List<Int> = mutable   // misma instancia, distinta "ventana" de acceso

mutable.add(4)
println(soloLectura)   // [1, 2, 3, 4] → ¡cambió, porque es el MISMO objeto!
```

Para inmutabilidad real (una copia independiente que nadie más puede tocar), necesitas `toList()` / `toMutableList()`, que crean una copia nueva:
```kotlin
val copiaSegura: List<Int> = mutable.toList()
```

**b) Jerarquía de interfaces.** `List`, `Set` y `Map` heredan de `Collection` (excepto `Map`, que es independiente por no ser una secuencia de elementos sino de pares). Cada una tiene su contraparte `Mutable*`:

```
Iterable
   └── Collection
          ├── List / MutableList        (ordenada, permite duplicados)
          └── Set  / MutableSet         (sin duplicados)
Map / MutableMap                        (independiente: clave → valor)
```

**c) Implementación real bajo cada `xOf()`:**

| Función | Devuelve (interfaz) | Implementación real por debajo |
|---|---|---|
| `listOf()` / `mutableListOf()` | `List` / `MutableList` | `java.util.ArrayList` (array redimensionable, acceso O(1) por índice) |
| `setOf()` / `mutableSetOf()` | `Set` / `MutableSet` | `LinkedHashSet` (tabla hash + orden de inserción preservado) |
| `mapOf()` / `mutableMapOf()` | `Map` / `MutableMap` | `LinkedHashMap` |

Esto importa para decisiones de rendimiento: si necesitas orden natural en un `Set`, `LinkedHashSet` no lo da por defecto (da orden de inserción); necesitarías `sortedSetOf()` (respaldado por `TreeSet`, con inserción O(log n) pero siempre ordenado).

---

## 3. Tipos

### Arrays

`Array` es de tamaño fijo tras su creación y es el tipo que mapea directamente a los arrays nativos de la JVM.

```kotlin
val numeros = arrayOf(1, 2, 3, 4, 5)
val vacio = arrayOfNulls<String>(3)      // [null, null, null]
val cuadrados = Array(5) { i -> i * i }  // [0, 1, 4, 9, 16] — lambda generadora por índice

// Variantes primitivas SIN boxing (ver Módulo 01, sección 2 — Arquitectura)
val edades = intArrayOf(10, 20, 30)      // se compila a int[], no a Integer[]
val notas = doubleArrayOf(8.5, 7.0, 9.2)

val matriz = arrayOf(
    arrayOf(1, 2, 3),
    arrayOf(4, 5, 6),
    arrayOf(7, 8, 9)
)
```

**¿Cuándo usar `Array` en vez de `List`?** Casi nunca en código de aplicación normal. `Array` existe principalmente por interoperabilidad con APIs de Java que lo exigen, o por rendimiento extremo (`IntArray` en cálculo numérico intensivo). Para el 95% de los casos de negocio, `List`/`MutableList` es la elección idiomática.

### List

Colección **ordenada** que permite elementos duplicados.

```kotlin
val lista: List<String> = listOf("Lunes", "Martes")           // solo lectura
val mutable: MutableList<String> = mutableListOf("A")
mutable.add("B")
mutable.removeAt(0)
mutable.sortDescending()
```

**Métodos principales:**

| Método | Qué hace |
|---|---|
| `add(elemento)` / `add(index, elemento)` | Añade al final o en una posición |
| `removeAt(index)` / `remove(elemento)` | Elimina por posición o por valor |
| `sort()` / `sortDescending()` | Ordena in-place (requiere `MutableList`) |
| `contains(elemento)` | `true`/`false` — O(n) en `ArrayList` |
| `indexOf(elemento)` | Posición del elemento, `-1` si no existe |
| `getOrNull(index)` | Devuelve el elemento o `null` en vez de lanzar excepción |
| `getOrElse(index) { default }` | Devuelve el elemento o un valor calculado si el índice no existe |

**Recorrer una lista:**
```kotlin
for (fruta in listOf("Manzana", "Banana")) println(fruta)
listOf("Manzana", "Banana").forEach { println(it) }
listOf("Manzana", "Banana").forEachIndexed { i, fruta -> println("$i: $fruta") }
```

### Set

Colección que **no permite duplicados**. El orden depende de la implementación: `setOf`/`mutableSetOf` preservan orden de inserción (`LinkedHashSet`); si necesitas orden alfabético/natural, usa `sortedSetOf`.

```kotlin
val conjunto = setOf(1, 2, 2, 3)       // [1, 2, 3] — el duplicado se descarta silenciosamente
val ordenado = sortedSetOf(3, 1, 2)    // [1, 2, 3] — siempre ordenado, respaldado por TreeSet
```

**Métodos principales:** `add()`, `remove()`, `contains()` — mismas firmas que `List`, pero `add()` devuelve `Boolean` (indica si realmente se añadió, útil para detectar duplicados sin una comprobación previa):

```kotlin
val vistos = mutableSetOf<String>()
if (vistos.add(idUsuario)) {
    println("Primera vez que vemos a $idUsuario")
} else {
    println("Ya estaba registrado")
}
```

**Operaciones de teoría de conjuntos** (muy usadas y poco conocidas):
```kotlin
val a = setOf(1, 2, 3)
val b = setOf(2, 3, 4)
println(a union b)         // [1, 2, 3, 4]
println(a intersect b)     // [2, 3]
println(a subtract b)      // [1]
```

### Map

Colección de pares **clave → valor**, con claves únicas.

```kotlin
val mapa: Map<String, Any> = mapOf("nombre" to "Ana", "edad" to 30)

val mapaMutable = mutableMapOf<String, Int>()
mapaMutable["uno"] = 1              // operador de índice, equivalente a .put()
mapaMutable.put("dos", 2)

for ((clave, valor) in mapa) println("$clave → $valor")
```

**Métodos principales:**

| Método | Qué hace |
|---|---|
| `put(k, v)` / `map[k] = v` | Inserta o sobrescribe |
| `remove(k)` | Elimina por clave |
| `keys` | `Set` con todas las claves |
| `values` | `Collection` con todos los valores |
| `entries` | `Set<Map.Entry<K,V>>`, iterable como pares |
| `getOrDefault(k, default)` | Evita comprobar `containsKey` manualmente |
| `getOrPut(k) { calcular() }` | Si la clave no existe, la calcula, la inserta y la devuelve — patrón de caché en una línea |

```kotlin
val cache = mutableMapOf<String, Int>()
val valor = cache.getOrPut("clave1") {
    println("Calculando (solo pasa una vez por clave)...")
    costosoCalculo()
}
```

### Operaciones funcionales sobre colecciones

Esta es la parte que separa código Kotlin idiomático de código "Java traducido literalmente". Las colecciones de Kotlin incluyen decenas de funciones de extensión funcionales:

```kotlin
val numeros = listOf(1, 2, 3, 4, 5, 6)

numeros.filter { it % 2 == 0 }              // [2, 4, 6]
numeros.map { it * it }                     // [1, 4, 9, 16, 25, 36]
numeros.reduce { acc, n -> acc + n }         // 21 (suma acumulada, empieza en el 1er elemento)
numeros.fold(100) { acc, n -> acc + n }      // 121 (como reduce, pero con valor inicial explícito)
numeros.groupBy { if (it % 2 == 0) "par" else "impar" }   // {impar=[1,3,5], par=[2,4,6]}
numeros.sortedByDescending { it }            // [6, 5, 4, 3, 2, 1]
numeros.take(3)                              // [1, 2, 3]
numeros.chunked(2)                           // [[1,2],[3,4],[5,6]]
numeros.any { it > 5 }                       // true
numeros.all { it > 0 }                       // true
numeros.firstOrNull { it > 10 }              // null (en vez de lanzar excepción)
```

### Sequences: colecciones perezosas

**El problema real:** encadenar `.filter().map()` sobre un `List` grande crea una **lista intermedia completa** en cada paso. Con un millón de elementos y tres operaciones encadenadas, estás creando tres listas de un millón de elementos en memoria, aunque solo necesites el primer resultado.

**Analogía:** una `List` procesada con `.filter().map()` es como una fábrica donde cada estación termina TODA la producción del día antes de pasarla a la siguiente estación — se acumulan montañas de producto a medio hacer entre estaciones. Una `Sequence` es una cadena de montaje: cada pieza pasa por todas las estaciones antes de que empiece la siguiente pieza. No hay acumulación intermedia.

```kotlin
val resultado = (1..1_000_000)
    .asSequence()               // convierte a evaluación perezosa
    .filter { it % 2 == 0 }
    .map { it * it }
    .first { it > 1000 }        // solo se procesan los elementos necesarios hasta encontrar el resultado
```

**Regla práctica:** usa `Sequence` cuando encadenes 2+ operaciones sobre colecciones grandes (miles de elementos o más). Para colecciones pequeñas o una sola operación, `List` es igual de rápido y más simple de leer.

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | Asumir que `listOf()` crea inmutabilidad profunda | Es solo una interfaz de solo lectura; si otra referencia mutable apunta al mismo objeto, puede cambiar por debajo. | Usa `.toList()` para obtener una copia real e independiente cuando la inmutabilidad importe (ej. exponer estado desde un `ViewModel`). |
| 2 | Encadenar `.filter().map()` sobre colecciones grandes sin `Sequence` | Crea una lista intermedia completa por cada operación — coste de memoria y CPU innecesario. | Usa `.asSequence()` antes de encadenar operaciones sobre colecciones de tamaño considerable. |
| 3 | Usar `List` cuando la propiedad real del dato es "sin duplicados" | Permite duplicados accidentales que luego causan bugs sutiles (ej. IDs repetidos). | Modela con `Set` desde el inicio: el tipo comunica la invariante. |
| 4 | Acceder con `list[index]` sin comprobar límites | Lanza `IndexOutOfBoundsException` si el índice no existe. | Usa `getOrNull(index)` o `getOrElse(index) { valorPorDefecto }`. |
| 5 | Usar `Array<Int>` para cálculo numérico intensivo | Boxing de cada elemento como objeto `Integer` (ver Módulo 01). | Usa `IntArray`, `DoubleArray`, etc. |
| 6 | Confundir `mapOf()` con un objeto de configuración tipado | `Map<String, Any>` pierde seguridad de tipos: cualquier valor puede ser cualquier cosa, y hay que castear al leer. | Para datos con forma fija y conocida, usa una `data class` (ver Módulo 04), no un `Map` genérico. |
| 7 | Modificar una colección mientras se itera sobre ella con `for` | Lanza `ConcurrentModificationException` en tiempo de ejecución. | Usa `removeAll { condición }`, o itera sobre una copia (`.toList()`) si necesitas modificar el original. |

**Buenas prácticas:**
- Expón siempre `List`/`Set`/`Map` (interfaces de solo lectura) en las firmas públicas de tus funciones y clases; usa las versiones `Mutable*` solo internamente. Esto es el equivalente en colecciones al principio de encapsulación.
- Prefiere las funciones funcionales (`filter`, `map`, `groupBy`...) sobre bucles `for` manuales con acumuladores: son más declarativas, más difíciles de hacer mal, y el compilador las optimiza bien.
- Cuando una función puede no encontrar un resultado, usa las variantes `xOrNull` (`firstOrNull`, `getOrNull`, `maxOrNull`) en vez de dejar que lance una excepción — es la misma filosofía de null safety del Módulo 01 aplicada a colecciones.