> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Que es POO](#1-que-es-poo)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Modificadores de acceso](#modificadores-de-acceso)
  - [Constructores: primario, secundario y `init`](#constructores-primario-secundario-y-init)
  - [Encapsulación real con `get`/`set` personalizados](#encapsulación-real-con-getset-personalizados)
  - [Herencia](#herencia)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Que es POO

La Programación Orientada a Objetos organiza el código en unidades (clases) que combinan estado (propiedades) y comportamiento (funciones), modelando entidades del dominio del problema. Kotlin implementa POO sobre el mismo modelo de objetos de la JVM que Java, pero invierte una decisión de diseño fundamental: **las clases son `final` (no heredables) por defecto**, mientras que en Java son heredables por defecto y hay que marcarlas explícitamente como `final` para cerrarlas.

**El problema que resuelve:** la herencia sin restricciones es una de las causas más documentadas de acoplamiento frágil en sistemas grandes — el "problema de la clase base frágil" (*fragile base class problem*), donde cambiar una clase padre rompe silenciosamente a sus hijas porque nadie diseñó la clase para ser extendida. Kotlin te obliga a tomar esa decisión de forma consciente con la palabra clave `open`, en vez de dejarla abierta por omisión.

**Analogía:** una clase `final` en Kotlin es como un contrato de alquiler cerrado — nadie puede hacer obras estructurales sin permiso explícito del propietario. Marcarla `open` es como firmar una cláusula que dice "el inquilino puede tirar esta pared si quiere" — una decisión de arquitectura, no un descuido.

---

## 2. Arquitectura y Componentes

**a) Toda clase Kotlin hereda implícitamente de `Any`**, el equivalente a `Object` en Java, pero con una diferencia: `Any` solo define `equals()`, `hashCode()` y `toString()` — no tiene `wait()`, `notify()` ni el resto del arsenal de sincronización de bajo nivel que trae `Object`. Esas herramientas de concurrencia clásica de Java siguen disponibles (porque bajo el capó sigue siendo un `Object` de la JVM), pero Kotlin no las expone como parte del contrato base, empujándote hacia corrutinas (Módulo 07) para concurrencia.

**b) El constructor primario no es un bloque de código — es parte de la cabecera de la clase.** Esto es distinto a Java, donde el constructor siempre es un bloque `{ }` separado. En Kotlin, `class Persona(val nombre: String)` declara simultáneamente: la clase, sus parámetros de construcción, y (gracias a `val`) las propiedades de instancia correspondientes, en una sola línea. El bloque `init` existe precisamente para el código que Java pondría dentro del constructor pero que Kotlin no puede expresar en la cabecera.

**c) `field` es una palabra clave especial, no una propiedad tuya.** Cuando escribes un `set` personalizado, `field` es un identificador que el compilador genera automáticamente para referirse al almacenamiento real *detrás* de la propiedad — es lo que evita la recursión infinita que ocurriría si escribieras `edad = value` dentro del propio `set` de `edad` (eso volvería a llamar al `set`, causando un `StackOverflowError`).

---

## 3. Implementación Paso a Paso

### Modificadores de acceso

| Modificador | Visibilidad | Equivalente conceptual en Java |
|---|---|---|
| `public` (por defecto, no hace falta escribirlo) | Accesible desde cualquier lugar | `public` |
| `private` | Solo dentro de la clase (o el archivo, si es de nivel superior) | `private` |
| `protected` | La clase y sus subclases | `protected` |
| `internal` | Dentro del mismo módulo de compilación (ej. el mismo módulo Gradle) | Sin equivalente exacto en Java — más permisivo que `package-private`, más restrictivo que `public` |

```kotlin
class Persona {
    private var secreto = "1234"   // nadie fuera de esta clase puede leerlo ni escribirlo
    var nombre = "Juan"             // public implícito
}
```

### Constructores: primario, secundario y `init`

**Constructor primario** — la forma idiomática y más usada en código de producción:

```kotlin
class Persona(val nombre: String, var edad: Int)

val p = Persona("Luis", 25)
println(p.nombre)  // Luis
```

`val`/`var` en los parámetros del constructor primario los convierte automáticamente en propiedades de la clase. Si omites `val`/`var`, el parámetro solo existe dentro del constructor y no queda accesible después.

**Bloque `init`** — se ejecuta inmediatamente después de que se asignan los parámetros del constructor primario. Úsalo para validaciones o lógica de inicialización que no cabe en la cabecera:

```kotlin
class Estudiante(val nombre: String, val edad: Int) {
    init {
        require(edad >= 0) { "La edad no puede ser negativa" }   // lanza IllegalArgumentException si falla
        println("Creando estudiante: $nombre")
    }
}
```

Si hay varios bloques `init` y propiedades con inicializadores, se ejecutan **en el orden en que aparecen** en el código fuente — esto sorprende a quien viene de Java, donde el orden de inicialización es menos visible.

**Constructor secundario** — necesario cuando quieres múltiples formas de construir el objeto con lógica distinta, o al interoperar con frameworks Java que exigen constructores sin argumentos:

```kotlin
class Alumno {
    var nombre: String
    var edad: Int

    constructor(nombre: String, edad: Int) {
        this.nombre = nombre
        this.edad = edad
    }

    // Constructor secundario delegando al primario con 'this(...)'
    constructor(nombre: String) : this(nombre, edad = 18)
}
```

❌ **MAL** — usar constructores secundarios cuando un valor por defecto resolvería lo mismo:
```kotlin
class Alumno {
    var nombre: String
    var edad: Int
    constructor(nombre: String, edad: Int) { this.nombre = nombre; this.edad = edad }
    constructor(nombre: String) : this(nombre, 18)
}
```

✅ **BIEN** — parámetros con valor por defecto en el constructor primario, mucho más idiomático:
```kotlin
class Alumno(val nombre: String, val edad: Int = 18)
```

### Encapsulación real con `get`/`set` personalizados

```kotlin
class Usuario {
    var edad: Int = 0
        set(value) {
            field = if (value < 0) 0 else value   // 'field' referencia el almacenamiento real
        }
        get() = field   // getter explícito (equivalente al implícito, mostrado por claridad)
}
```

Un caso real de uso — validar y normalizar en el `set`, calcular en el `get`:

```kotlin
class Producto(precioInicial: Double) {
    var precio: Double = precioInicial
        set(value) {
            require(value >= 0) { "El precio no puede ser negativo" }
            field = value
        }

    val precioConIva: Double   // propiedad calculada, sin campo de respaldo: se recalcula en cada acceso
        get() = precio * 1.21
}
```

### Herencia

```kotlin
open class Animal(val nombre: String) {
    open fun hablar() {
        println("$nombre hace un sonido")
    }
}

class Perro(nombre: String) : Animal(nombre) {
    override fun hablar() {
        println("$nombre dice: Guau")
        super.hablar()   // opcional: invoca también el comportamiento del padre
    }
}

val perro: Animal = Perro("Max")
perro.hablar()   // "Max dice: Guau" seguido de "Max hace un sonido"
```

Reglas clave que Kotlin fuerza y Java no:
- La clase debe ser `open` para poder heredarse.
- Cada función/propiedad que quieras sobreescribir debe ser `open` en el padre.
- `override` es **obligatorio** en la clase hija (Java lo hace opcional con `@Override`, Kotlin lo exige).

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | `set(value) { edad = value }` dentro del propio setter de `edad` | Recursión infinita → `StackOverflowError` en tiempo de ejecución. | Usa `field = value`, la palabra clave especial que apunta al almacenamiento real. |
| 2 | Olvidar `open` en la clase o en la función a sobreescribir | Error de compilación: "this type is final, so it cannot be inherited from" / "overriding is disallowed". | Marca explícitamente `open class` y `open fun` — es una decisión de diseño deliberada, no un trámite. |
| 3 | Multiplicar constructores secundarios en vez de usar valores por defecto | Código repetitivo y más difícil de mantener que la alternativa idiomática. | Usa parámetros con valor por defecto en el constructor primario siempre que la lógica lo permita. |
| 4 | Poner lógica de validación pesada o llamadas a I/O dentro de `init` | El bloque `init` se ejecuta en cada construcción del objeto; una consulta a base de datos ahí bloquea la creación y es difícil de testear. | Mantén `init` para validaciones puras y rápidas; mueve la lógica de I/O a métodos de fábrica o funciones `suspend` explícitas. |
| 5 | Exponer propiedades `var` públicas sin `set` personalizado cuando el dominio tiene invariantes (ej. edad no negativa, precio no negativo) | Cualquier código externo puede dejar el objeto en un estado inválido. | Usa un `set` personalizado con `require()`, o hazla `private set` y expón una función que valide antes de mutar. |
| 6 | Usar `protected` esperando el mismo comportamiento que en Java (accesible desde el mismo paquete) | En Kotlin, `protected` NO da acceso a nivel de paquete — solo a la clase y sus subclases. | Si necesitas compartir dentro de un módulo sin exponerlo públicamente, usa `internal`. |

**Buenas prácticas:**
- Prefiere `val` con constructor primario sobre propiedades mutables con lógica de asignación dispersa en varios constructores — es más fácil de razonar y testear.
- Antes de marcar una clase `open`, pregúntate si el problema se resuelve mejor con composición (una clase que *usa* otra) en vez de herencia (una clase que *es* otra). La herencia es la relación más rígida y acoplada que existe en POO; resérvala para jerarquías genuinamente "es-un" y estables.
- Usa `private set` como patrón por defecto para propiedades que deben ser legibles desde fuera pero solo modificables desde dentro de la clase: `var estado: String private set`.