> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Anotaciones](#1-anotaciones)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Anotaciones de interoperabilidad con Java](#anotaciones-de-interoperabilidad-con-java)
  - [Llamar código Java desde Kotlin: la plataforma-tipo](#llamar-código-java-desde-kotlin-la-plataforma-tipo)
  - [Llamar código Kotlin desde Java](#llamar-código-kotlin-desde-java)
  - [Anotaciones de serialización](#anotaciones-de-serialización)
  - [Anotaciones de Android más comunes](#anotaciones-de-android-más-comunes)
  - [Anotaciones propias](#anotaciones-propias)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Anotaciones

Kotlin fue diseñado desde el primer día para coexistir con bases de código Java existentes — no como un reemplazo que exige migrar todo de golpe, sino como un lenguaje que puedes introducir archivo por archivo dentro de un proyecto Java ya en producción. Esa interoperabilidad no es perfecta por accidente: requiere un conjunto de anotaciones y reglas específicas para tender el puente entre dos lenguajes con modelos de tipos distintos (Kotlin con null safety nativo, Java sin él; Kotlin sin `static`, Java con él).

**El problema que resuelve:** sin estas herramientas, cada llamada entre Kotlin y Java perdería información importante — un método Kotlin con parámetros por defecto se vería desde Java como si exigiera siempre todos los argumentos; una propiedad de `companion object` no sería accesible como un verdadero `static` de Java; y sobre todo, el compilador de Kotlin no tendría forma de saber si un valor que viene de Java puede ser `null`, rompiendo la garantía central del lenguaje.

**Analogía:** piensa en estas anotaciones como los enchufes universales de viaje. Kotlin y Java "hablan electricidad" de forma compatible (misma JVM, mismo bytecode), pero la forma del enchufe —qué parámetros son opcionales, qué es estático, qué puede ser nulo— es distinta en cada país. Las anotaciones son el adaptador que hace que ambos lados puedan conectarse sin perder funcionalidad ni quemar el aparato.

---

## 2. Arquitectura y Componentes

**a) Los tipos plataforma (*platform types*) son la pieza más importante y menos entendida de esta interoperabilidad.** Cuando código Kotlin recibe un valor desde una API de Java (ej. `String` desde una librería Java sin anotaciones de nulabilidad), Kotlin **no puede saber** si ese valor puede ser `null`, porque Java no tiene esa información en su sistema de tipos. En vez de asumir "nullable" o "no-nullable" a ciegas, Kotlin lo marca internamente como `String!` — un tipo plataforma que **desactiva las comprobaciones de null safety** para ese valor específico, confiando en el desarrollador. Esto significa que **el punto más común donde un `NullPointerException` sobrevive en código Kotlin real es precisamente en la frontera con librerías Java sin anotar.**

**b) `@JvmStatic` no mueve código — genera un método `static` real adicional en el bytecode.** Un `companion object` en Kotlin es, por debajo, una clase singleton normal con una instancia (idéntico al patrón `object` del Módulo 04). Sin `@JvmStatic`, sus métodos son técnicamente instancia de esa clase singleton — accesibles desde Java como `Clase.Companion.metodo()`. `@JvmStatic` le dice al compilador que genere, **además**, un método verdaderamente `static` en el bytecode de la clase contenedora, para que Java pueda llamarlo de forma natural: `Clase.metodo()`.

**c) `@JvmOverloads` resuelve el problema de los parámetros por defecto, que no existen en Java.** Java no tiene el concepto de "parámetro con valor por defecto" — cada combinación de argumentos necesita su propio método sobrecargado. Cuando defines `fun saludar(nombre: String, saludo: String = "Hola")` en Kotlin, desde Java solo verías la firma completa con ambos parámetros obligatorios, a menos que añadas `@JvmOverloads`, que genera automáticamente todas las sobrecargas necesarias.

---

## 3. Implementación Paso a Paso

### Anotaciones de interoperabilidad con Java

| Anotación | Propósito | Ejemplo de uso |
|---|---|---|
| `@JvmStatic` | Genera un método `static` real accesible desde Java sin pasar por `.Companion` | `companion object { @JvmStatic fun crear() = ... }` |
| `@JvmOverloads` | Genera sobrecargas para cada combinación de parámetros con valor por defecto | `fun f(@JvmOverloads a: Int, b: Int = 0)` |
| `@JvmField` | Expone una propiedad Kotlin como campo público plano, sin generar `getX()`/`setX()` | `@JvmField val version = "1.0"` |
| `@JvmName` | Cambia el nombre del método/función generado en el bytecode, útil para evitar colisiones de sobrecarga por *type erasure* | `@JvmName("filterInts") fun List<Int>.filter(...)` |
| `@Throws` | Declara qué excepciones lanza una función Kotlin, para que Java (con excepciones comprobadas) lo sepa | `@Throws(IOException::class) fun leer()` |

```kotlin
class Configuracion private constructor(val entorno: String) {
    companion object {
        @JvmStatic
        fun produccion() = Configuracion("prod")

        @JvmField
        val VERSION_API = "v2"
    }
}
```

Desde Java, esto se ve exactamente como un método y un campo estáticos normales:
```java
Configuracion config = Configuracion.produccion();   // sin @JvmStatic sería Configuracion.Companion.produccion()
String v = Configuracion.VERSION_API;                 // sin @JvmField sería Configuracion.Companion.getVERSION_API()
```

### Llamar código Java desde Kotlin: la plataforma-tipo

```kotlin
// Supongamos una clase Java: public class LibreriaJava { public String obtenerDato() { ... } }

val dato = LibreriaJava().obtenerDato()   // el compilador ve esto como String! (tipo plataforma)
println(dato.length)                      // compila SIN warning, aunque 'dato' pudiera ser null en runtime
```

Kotlin te deja tratar `dato` como no-nulo sin quejarse — la responsabilidad de comprobarlo pasa a ser completamente tuya, exactamente como en Java. Esta es la única grieta real en la garantía de null safety del lenguaje, y es importante saber que existe.

### Llamar código Kotlin desde Java

Algunas construcciones idiomáticas de Kotlin se ven distintas desde el lado Java:

```kotlin
// Kotlin
data class Producto(val nombre: String, val precio: Double)

fun calcularTotal(items: List<Producto>): Double = items.sumOf { it.precio }
```

```java
// Java
Producto p = new Producto("Pan", 1.0);
String nombre = p.getNombre();      // Kotlin generó getNombre()/getPrecio() automáticamente
double total = ArchivoKt.calcularTotal(lista);   // funciones de nivel superior viven en una clase "NombreArchivoKt"
```

Ese sufijo `Kt` en el nombre de la clase generada para funciones sueltas de nivel superior es automático y puede personalizarse con `@file:JvmName("Utilidades")` al principio del archivo `.kt`.

### Anotaciones de serialización

```kotlin
import kotlinx.serialization.Serializable

@Serializable
data class Usuario(val id: String, val nombre: String, val edad: Int)
```

`@Serializable` (de la librería `kotlinx.serialization`, no de Java) genera en tiempo de compilación el código de serialización/deserialización a JSON (u otros formatos) sin usar reflexión en tiempo de ejecución — a diferencia de librerías como Gson en Java, esto significa mejor rendimiento y detección de errores de esquema en compilación, no en producción.

### Anotaciones de Android más comunes

Aunque este repositorio no es específico de Android, estas anotaciones aparecen con frecuencia en código Kotlin real y merecen mención porque dependen fuertemente de la interoperabilidad JVM descrita arriba:

| Anotación | Propósito |
|---|---|
| `@Parcelize` | Genera automáticamente la implementación de `Parcelable` (mecanismo de Android para pasar objetos entre componentes) |
| `@Inject` | Marca un punto de inyección de dependencias (Dagger/Hilt) |
| `@HiltAndroidApp` | Marca la clase `Application` como punto de entrada de Hilt |
| `@Composable` | Marca una función como parte de la UI declarativa de Jetpack Compose |

### Anotaciones propias

Puedes definir tus propias anotaciones para metadatos de dominio, procesadas en compilación o vía reflexión:

```kotlin
@Target(AnnotationTarget.FUNCTION)
@Retention(AnnotationRetention.RUNTIME)
annotation class RequiereAutenticacion

class ServicioUsuarios {
    @RequiereAutenticacion
    fun eliminarCuenta(id: String) { /* ... */ }
}
```

`@Target` controla dónde puede aplicarse (función, clase, propiedad...); `@Retention` controla si sobrevive solo en el código fuente, en el bytecode compilado, o también en tiempo de ejecución (necesario si planeas leerla con reflexión, como haría un *framework* de autenticación por interceptores).

---

## 4. Errores Comunes y Buenas Prácticas

| # | Error / Antipatrón | Por qué falla | Solución |
|---|---|---|---|
| 1 | Tratar un tipo plataforma (`String!`) proveniente de Java como garantizado no-nulo, sin comprobación | Es el punto de fuga real de `NullPointerException` en proyectos mixtos Kotlin/Java — el compilador no protege aquí. | Comprueba explícitamente con `?.`/`?:` cualquier valor que provenga de una API Java sin anotaciones `@Nullable`/`@NonNull`. |
| 2 | Olvidar `@JvmStatic` en un `companion object` que debe consumirse desde Java | Java se ve forzado a escribir `Clase.Companion.metodo()`, sintaxis no idiomática y confusa para el equipo Java. | Añade `@JvmStatic` a cualquier miembro de `companion object` pensado para ser llamado desde código Java. |
| 3 | Exponer una función con parámetros por defecto a una librería/API consumida desde Java sin `@JvmOverloads` | Java solo ve la firma completa; pierde la ergonomía de los valores por defecto. | Añade `@JvmOverloads` si la función es parte de una API pública consumida (también) desde Java. |
| 4 | Anotar librerías Java propias sin `@Nullable`/`@NonNull` (JSR-305 / JetBrains annotations) | Kotlin no puede inferir nulabilidad real y trata todo como tipo plataforma, perdiendo la protección de null safety en ese límite. | Si controlas el código Java, anótalo con `@Nullable`/`@NotNull` — Kotlin las respeta y genera tipos `String?`/`String` reales, no plataforma. |
| 5 | Asumir que `@Serializable` de kotlinx.serialization funciona igual que Gson/Jackson de Java | Kotlinx.serialization genera código en compilación (requiere el plugin de compilador); no usa reflexión como Gson, y no serializa clases no marcadas. | Configura el plugin `kotlinx-serialization` en el build, y marca explícitamente cada clase que necesite (de)serializarse. |
| 6 | No revisar el nombre de clase generado (`ArchivoKt`) al exponer funciones de nivel superior a Java | Puede resultar en nombres poco descriptivos o colisiones si varios archivos generan el mismo sufijo. | Usa `@file:JvmName("NombreDescriptivo")` al inicio del archivo `.kt` para controlar el nombre generado. |

**Buenas prácticas:**
- En cualquier proyecto que mezcle Kotlin y Java, trata la frontera entre ambos como una zona de riesgo explícita para null safety — documenta y comprueba, no asumas.
- Si estás diseñando una librería Kotlin que será consumida por consumidores Java (SDK, API pública), aplica `@JvmStatic`, `@JvmOverloads` y `@JvmName` de forma proactiva — no como parche reactivo cuando alguien se queje.
- Prefiere `kotlinx.serialization` sobre Gson/Jackson en proyectos Kotlin puros nuevos: la detección de errores en compilación (en vez de en producción, vía reflexión fallida) vale la fricción inicial de configurar el plugin.