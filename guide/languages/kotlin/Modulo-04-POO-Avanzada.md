> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. POO Avanzada](#1-poo-avanzada)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Clases abstractas](#clases-abstractas)
  - [Interfaces](#interfaces)
  - [Polimorfismo](#polimorfismo)
  - [Data classes](#data-classes)
  - [Object: singletons y companion object](#object-singletons-y-companion-object)
  - [Clases anidadas e internas](#clases-anidadas-e-internas)
  - [Sealed classes](#sealed-classes)
  - [Sobrecarga vs. sobreescritura](#sobrecarga-vs-sobreescritura)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. POO Avanzada 

Este módulo cubre las herramientas que Kotlin añade **encima** de la POO clásica (heredada de Java) para resolver problemas concretos de diseño: cómo definir contratos sin implementación (`interface`, `abstract`), cómo modelar datos puros sin repetir código repetitivo (`data class`), cómo garantizar que existe una única instancia de algo (`object`), y — la pieza más distintiva de Kotlin — cómo modelar un conjunto **cerrado y finito** de posibilidades con `sealed class`.

**El problema que resuelve `sealed class` en particular:** en cualquier sistema con estados (una respuesta de API que puede ser Éxito/Error/Cargando, un pago que puede estar Pendiente/Aprobado/Rechazado), Java te obliga a usar un `enum` (sin datos asociados) o una jerarquía de clases abierta (donde el compilador nunca sabe si cubriste todos los casos). `sealed class` te da lo mejor de ambos: subtipos con sus propios datos, y la garantía en tiempo de compilación de que un `when` los cubre **todos**.

**Analogía:** una `interface` es un contrato de servicio — "quien firme esto, se compromete a ofrecer estas funciones", sin importar cómo las implemente por dentro (un taxi y una bicicleta ambos pueden implementar `Transportable`, de formas completamente distintas). Una `sealed class` es como un menú de opciones de un formulario oficial: no puedes rellenar "otro" a mano, solo puedes elegir entre las opciones predefinidas — y el sistema (el compilador) te avisa si tu formulario de procesamiento (`when`) se olvidó de contemplar alguna.

---

## 2. Arquitectura y Componentes

**a) Interfaces con implementación por defecto rompen la barrera clásica interfaz/clase abstracta.** En Java pre-8, una interfaz solo podía declarar firmas, sin cuerpo. Kotlin (como el Java moderno) permite que una interfaz incluya implementaciones por defecto. Esto reduce la diferencia práctica entre `interface` y `abstract class` a una cosa: **una clase puede implementar múltiples interfaces, pero solo puede heredar de una única clase abstracta** (la JVM no soporta herencia múltiple de estado, solo de comportamiento).

**b) `data class` no es azúcar sintáctica cosmética — genera bytecode real en tiempo de compilación.** Cuando escribes `data class Producto(val nombre: String, val precio: Double)`, el compilador genera automáticamente, como métodos reales en el `.class` resultante:
- `equals()` / `hashCode()` basados en **todas** las propiedades del constructor primario (no en identidad de referencia).
- `toString()` legible: `Producto(nombre=Pan, precio=1.0)`.
- `copy()` para crear una nueva instancia cambiando solo algunas propiedades.
- Funciones `component1()`, `component2()`... que habilitan la **desestructuración**: `val (nombre, precio) = producto`.

**c) `sealed class` restringe la jerarquía a un mismo archivo o módulo (según la versión de Kotlin), y eso es precisamente lo que le permite al compilador razonar de forma exhaustiva.** Cuando escribes un `when` sobre un tipo `sealed`, el compilador conoce el conjunto completo y cerrado de subtipos posibles — por eso puede exigirte (sin necesidad de `else`) que cubras todos los casos, y avisarte en rojo, en el propio editor, el día que añades un nuevo subtipo y olvidas actualizar algún `when` en otra parte del código. Esa propiedad —detectar en compilación un `when` desactualizado— no existe con jerarquías abiertas.

---

## 3. Implementación Paso a Paso

### Clases abstractas

```kotlin
abstract class Figura {
    abstract fun area(): Double          // sin cuerpo: cada subclase DEBE implementarla
    fun describir() = "Esta figura tiene un área de ${area()}"   // método concreto, heredado tal cual
}

class Circulo(val radio: Double) : Figura() {
    override fun area(): Double = Math.PI * radio * radio
}
```

Usa `abstract class` cuando las subclases comparten **estado** (propiedades con valor inicial) además de comportamiento — algo que una interfaz no puede aportar de forma directa.

### Interfaces

```kotlin
interface Vehiculo {
    val ruedas: Int                      // las interfaces pueden declarar propiedades (sin campo de respaldo)
    fun encender()
    fun describir() = "Vehículo con $ruedas ruedas"   // implementación por defecto
}

class Auto : Vehiculo {
    override val ruedas = 4
    override fun encender() = println("Auto encendido")
}
```

Kotlin permite implementar **múltiples** interfaces — la forma real de conseguir "herencia múltiple de comportamiento" en la JVM:

```kotlin
interface Nadador { fun nadar() = println("Nadando") }
interface Volador { fun volar() = println("Volando") }

class Pato : Nadador, Volador   // hereda comportamiento de ambas
```

Si dos interfaces implementadas tienen el mismo método por defecto, Kotlin **exige** resolver el conflicto explícitamente (a diferencia de otros lenguajes que eligen uno arbitrariamente):
```kotlin
class Anfibio : Nadador, Volador {
    override fun nadar() {
        super<Nadador>.nadar()   // sintaxis para elegir explícitamente cuál 'super' invocar
    }
}
```

### Polimorfismo

```kotlin
val lista: List<Figura> = listOf(Circulo(3.0), Circulo(5.0))
for (f in lista) println(f.area())   // cada llamada resuelve dinámicamente a la implementación real
```

El mecanismo real detrás de esto es *dynamic dispatch*: en tiempo de ejecución, la JVM consulta la tabla de métodos virtuales del objeto concreto (no del tipo declarado de la variable) para decidir qué implementación de `area()` ejecutar.

### Data classes

```kotlin
data class Producto(val nombre: String, val precio: Double)

val prod1 = Producto("Pan", 1.0)
val prod2 = prod1.copy(precio = 1.2)   // nueva instancia, solo precio cambia — prod1 no se modifica

println(prod1)             // Producto(nombre=Pan, precio=1.0) — toString() generado
println(prod1 == prod2)    // false — equals() por contenido: precio distinto

val (nombre, precio) = prod1   // desestructuración, gracias a componentN()
```

### Object: singletons y companion object

`object` declara una clase con **una única instancia**, creada de forma perezosa y thread-safe por el propio runtime de Kotlin — sin necesidad de implementar el patrón Singleton a mano como en Java (con doble chequeo de bloqueo, etc.).

```kotlin
object Config {
    val version = "1.0.0"
    fun imprimir() = println("Versión: $version")
}

Config.imprimir()   // se accede directamente por el nombre, no hay que instanciar
```

**`companion object`** — el mecanismo de Kotlin para miembros "estáticos" ligados a una clase (Kotlin no tiene `static` como palabra clave, a propósito, para mantener consistencia: todo pertenece a un objeto, incluso lo "estático"):

```kotlin
class Usuario private constructor(val id: String) {
    companion object {
        fun crear(nombre: String): Usuario = Usuario(id = nombre.lowercase())
    }
}

val u = Usuario.crear("Ana")   // factory method — patrón muy común para constructores complejos
```

### Clases anidadas e internas

```kotlin
class Externa {
    private val mensaje = "Hola"

    class Anidada {                        // NO tiene acceso a la instancia de Externa
        fun saludar() = "Desde clase anidada"
    }

    inner class Interna {                  // SÍ tiene acceso implícito a Externa (incluido lo privado)
        fun saludar() = mensaje
    }
}

val anidada = Externa.Anidada()            // se instancia sin necesitar una Externa
val interna = Externa().Interna()          // requiere una instancia de Externa primero
```

La diferencia entre `class Anidada` e `inner class Interna` es exactamente el mismo matiz que en Java entre clase estática anidada y clase interna no estática — pero en Kotlin la palabra clave `inner` lo hace explícito en vez de ser el comportamiento por defecto (evitando fugas de memoria accidentales por referencias implícitas al exterior).

### Sealed classes

```kotlin
sealed class Resultado
data class Exito(val datos: String) : Resultado()
data class Error(val mensaje: String) : Resultado()
object Cargando : Resultado()

fun manejar(r: Resultado) = when (r) {
    is Exito -> println("OK: ${r.datos}")
    is Error -> println("Error: ${r.mensaje}")
    Cargando -> println("Cargando...")
    // sin 'else' — y si mañana añades un cuarto subtipo, este 'when' NO compilará
    // hasta que lo contemples. Esa es la garantía de exhaustividad.
}
```

Este patrón es el estándar de facto en Android/Kotlin moderno para modelar respuestas de red, estados de UI y resultados de operaciones — reemplaza por completo el antipatrón de usar `Boolean` + `String?` + `Exception?` sueltos para representar "puede haber salido bien o mal".

### Sobrecarga vs. sobreescritura

```kotlin
class Calculadora {
    fun sumar(a: Int, b: Int): Int = a + b          // sobrecarga: mismo nombre, distinta firma
    fun sumar(a: Double, b: Double): Double = a + b
}
```

- **Sobrecarga** (*overloading*): se resuelve en tiempo de **compilación**, según los tipos de los argumentos.
- **Sobreescritura** (*overriding*, `override`): se resuelve en tiempo de **ejecución**, según el tipo real del objeto (ver 3.3, polimorfismo).

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | Modelar un conjunto cerrado de estados con `enum` cuando cada estado necesita datos distintos | `enum` no puede llevar datos de forma heterogénea entre sus constantes de forma limpia. | Usa `sealed class`: cada subtipo lleva exactamente los datos que necesita. |
| 2 | Usar jerarquía abierta (`open class` + subclases sueltas) para representar estados | El compilador nunca puede garantizar que un `when` cubre todos los casos; añadir un estado nuevo no avisa de los `when` desactualizados. | Usa `sealed class`/`sealed interface` siempre que el conjunto de posibilidades sea cerrado y conocido de antemano. |
| 3 | Añadir un `else` "por si acaso" en un `when` sobre una `sealed class` | Elimina la garantía de exhaustividad: el día que añadas un subtipo nuevo, caerá silenciosamente en el `else` en vez de forzarte a manejarlo. | Omite el `else` deliberadamente cuando el `when` es sobre un tipo sellado — dejar que no compile es la funcionalidad, no un fallo. |
| 4 | Definir `equals()`/`hashCode()` a mano en una clase que solo almacena datos | Código repetitivo y propenso a errores (olvidar un campo nuevo al actualizar `equals`). | Usa `data class`: los genera automáticamente y de forma consistente. |
| 5 | Usar `data class` para entidades con identidad propia (ej. una entidad de base de datos con ciclo de vida) | `equals()` por contenido puede ser semánticamente incorrecto: dos entidades con el mismo contenido pero distinta identidad de negocio no deberían ser "iguales". | Usa una `class` normal (o define `equals` explícitamente por ID) cuando la identidad importa más que el contenido. |
| 6 | Implementar el patrón Singleton manualmente (constructor privado + variable estática + doble chequeo) | Kotlin ya resuelve esto de forma segura y concisa con `object`. | Usa `object NombreSingleton { ... }` directamente. |
| 7 | Usar `class Anidada` normal cuando en realidad necesitas acceso al estado de la clase externa | La clase anidada normal no tiene referencia implícita a la instancia externa — el código no compila al intentar acceder a sus miembros. | Marca la clase como `inner class` cuando necesite ese acceso. |

**Buenas prácticas:**
- Antes de elegir entre `interface` y `abstract class`, pregúntate si necesitas herencia múltiple (→ interface) o si necesitas compartir estado inicial entre subclases (→ abstract class). No son intercambiables por gusto.
- Combina `sealed class` con `when` como patrón por defecto para cualquier resultado de operación que pueda fallar (llamadas de red, validaciones, parseo) — es más expresivo y seguro que excepciones para flujo de control normal.
- Usa `companion object` con una función `crear()`/`of()` como *factory method* cuando el constructor necesite validación compleja o lógica condicional — mantiene el constructor primario simple y predecible.