> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

## Índice
- [Introducción](#introducción)
  - [¿Por qué migrar a Compose?](#por-qué-migrar-a-compose)
  - [Comparativa rápida: XML vs Compose](#comparativa-rápida-xml-vs-compose)
  - [Requisitos Previos](#requisitos-previos)
- [Fundamentos de Jetpack Compose](#fundamentos-de-jetpack-compose)
  - [¿Qué es un `@Composable`?](#qué-es-un-composable)
  - [Composición y recomposición](#composición-y-recomposición)
  - [Bajo el capó: la Slot Table y la recomposición inteligente](#bajo-el-capó-la-slot-table-y-la-recomposición-inteligente)
  - [Estabilidad y skippability](#estabilidad-y-skippability)
  - [Visualizar vistas previas (@Preview)](#visualizar-vistas-previas-preview)
  - [Ciclo de vida básico en Jetpack Compose](#ciclo-de-vida-básico-en-jetpack-compose)
  - [Gestión de estado: remember y mutableStateOf](#gestión-de-estado-remember-y-mutablestateof)
  - [rememberSaveable: sobreviviendo a cambios de configuración](#remembersaveable-sobreviviendo-a-cambios-de-configuración)
  - [State Hoisting: el patrón fundamental de Compose](#state-hoisting-el-patrón-fundamental-de-compose)
- [Componentes Principales de Jetpack Compose](#componentes-principales-de-jetpack-compose)
  - [Layout](#layout)
    - [Box](#box)
    - [Column (Vertical)](#column-vertical)
    - [Row (Horizontal)](#row-horizontal)
  - [Text](#text)
  - [TextField - Entrada de datos](#textfield---entrada-de-datos)
  - [Componente Buttons](#componente-buttons)
  - [Images e Iconos](#images-e-iconos)
    - [Icono](#icono)
    - [Image](#image)
    - [Imágenes desde la web (usando Coil)](#imágenes-desde-la-web-usando-coil)
  - [ProgressBar](#progressbar)
    - [CircularProgressIndicator](#circularprogressindicator)
    - [LinearProgressIndicator](#linearprogressindicator)
    - [Loading con Lottie (animaciones)](#loading-con-lottie-animaciones)
  - [Control de selección](#control-de-selección)
  - [Slider y RangeSlider](#slider-y-rangeslider)
  - [DropdownMenu](#dropdownmenu)
    - [ExposedDropdownMenuBox](#exposeddropdownmenubox)
  - [Scaffold](#scaffold)
    - [TopAppBar](#topappbar)
    - [BottomAppBar](#bottomappbar)
    - [NavigationBar (antes BottomNavigation)](#navigationbar-antes-bottomnavigation)
    - [FloatingActionButton (FAB)](#floatingactionbutton-fab)
    - [SnackbarHost y Snackbar](#snackbarhost-y-snackbar)
  - [Card](#card)
  - [Badge](#badge)
  - [HorizontalDivider (antes Divider)](#horizontaldivider-antes-divider)
  - [Diálogos](#diálogos)
    - [AlertDialog](#alertdialog)
    - [DatePicker y TimePicker (API nativa de Material 3)](#datepicker-y-timepicker-api-nativa-de-material-3)
  - [Comportamientos avanzados y Side-Effects](#comportamientos-avanzados-y-side-effects)
    - [InteractionSource](#interactionsource)
    - [LaunchedEffect](#launchedeffect)
    - [DisposableEffect](#disposableeffect)
    - [derivedStateOf](#derivedstateof)
  - [CompositionLocal: contexto implícito sin prop-drilling](#compositionlocal-contexto-implícito-sin-prop-drilling)
- [Listas dinámicas (antiguos RecyclerView)](#listas-dinámicas-antiguos-recyclerview)
  - [LazyColumn](#lazycolumn)
  - [LazyRow](#lazyrow)
  - [LazyVerticalGrid](#lazyverticalgrid)
  - [LazyHorizontalGrid](#lazyhorizontalgrid)
  - [Gestión del estado de listas](#gestión-del-estado-de-listas)
- [Navegación (Navigation Compose, type-safe)](#navegación-navigation-compose-type-safe)
  - [Navegación básica](#navegación-básica)
  - [Type-safe Navigation con `@Serializable` (API actual, desde Navigation 2.8)](#type-safe-navigation-con-serializable-api-actual-desde-navigation-28)
  - [Manejo del back stack](#manejo-del-back-stack)
  - [BackHandler](#backhandler)
- [Animaciones](#animaciones)
  - [\*AsState](#asstate)
  - [Crossfade](#crossfade)
  - [AnimatedContent](#animatedcontent)
  - [animateContentSize](#animatecontentsize)
  - [InfiniteTransition](#infinitetransition)
- [Temas y Estilos en Jetpack Compose (Material 3)](#temas-y-estilos-en-jetpack-compose-material-3)
  - [¿Qué es un Tema en Compose?](#qué-es-un-tema-en-compose)
  - [Estructura de theming](#estructura-de-theming)
  - [Definición de colores (`Color.kt`)](#definición-de-colores-colorkt)
  - [Tipografía (`Type.kt`)](#tipografía-typekt)
  - [Theme.kt](#themekt)
  - [Estilos reutilizables](#estilos-reutilizables)
- [Arquitectura Recomendada: MVVM + Jetpack Compose](#arquitectura-recomendada-mvvm--jetpack-compose)
  - [Capas de la arquitectura](#capas-de-la-arquitectura)
  - [Estructura de paquetes sugerida](#estructura-de-paquetes-sugerida)
  - [Ejemplo completo: ViewModel + StateFlow + Composable](#ejemplo-completo-viewmodel--stateflow--composable)
  - [Flujo de datos en Compose con MVVM](#flujo-de-datos-en-compose-con-mvvm)
  - [Ventajas del enfoque MVVM con Compose](#ventajas-del-enfoque-mvvm-con-compose)
  - [Previsualizar UI con fake ViewModel](#previsualizar-ui-con-fake-viewmodel)
- [Testing de Composables](#testing-de-composables)
- [🚨 Errores Comunes en Producción (Checklist Final)](#-errores-comunes-en-producción-checklist-final)

---

# Introducción

Jetpack Compose es el toolkit declarativo de Google para construir UI en Android: en vez de describir *cómo* mutar una jerarquía de vistas paso a paso (el modelo imperativo de XML), describes *qué* debe verse en cada estado y el framework decide cómo llegar ahí de forma eficiente.

**El problema real que resuelve:** en el modelo de Views clásico, el bug más común en producción es la desincronización entre el estado de tus datos y lo que la vista realmente muestra (un `TextView` que quedó con el valor viejo porque alguien olvidó llamar `setText()` en el camino correcto). Compose elimina esa clase de bug por diseño: si la UI depende de un estado, se actualiza sola cuando ese estado cambia. No hay "olvidos" de sincronización manual.

**Analogía:** en Views, tú eres el pintor que repinta manualmente la pared cada vez que cambia el color deseado, acordándote de tapar antes lo viejo. En Compose, tú describes "esta pared es azul" y un sistema de renderizado se encarga de que la pared *sea* azul siempre, sin que tengas que recordar repintarla.

## ¿Por qué migrar a Compose?

* Menos código y menos boilerplate: se elimina la fragmentación entre XML y lógica en Kotlin.
* Integración nativa con `ViewModel`, `StateFlow` y corrutinas.
* Soporte completo y actualizado de Material Design 3.
* Previews en tiempo real (`@Preview`) que aceleran el ciclo de desarrollo.
* Es la dirección oficial de Google: las Views clásicas están en modo mantenimiento, no de innovación activa.

## Comparativa rápida: XML vs Compose

| Característica          | XML + Views                     | Jetpack Compose                  |
|-------------------------|----------------------------------|----------------------------------|
| Definición de UI        | Archivos XML                    | Funciones Kotlin (`@Composable`) |
| Reactividad             | Manual (`setText`, `notifyDataSetChanged`) | Reactivo por defecto  |
| Boilerplate             | Alto (ViewHolders, Adapters)    | Bajo                              |
| Preview en IDE          | Sí                              | Sí (más rápido y flexible)        |
| Rendimiento en listas   | RecyclerView + ViewHolder manual | LazyColumn con recomposición selectiva |
| Mantenimiento           | Fragmentación en clases y XML   | Todo en un solo lugar (Kotlin)    |

## Requisitos Previos

* Android Studio actualizado (verifica siempre la versión estable más reciente en el sitio oficial).
* Kotlin **2.0 o superior** — desde esta versión, el compilador de Compose es un plugin de Kotlin (`org.jetbrains.kotlin.plugin.compose`) y ya no se fija manualmente `kotlinCompilerExtensionVersion`.
* Conocimientos básicos de Kotlin (funciones, lambdas, data classes, corrutinas).
* Gradle con Kotlin DSL (`build.gradle.kts`).
* Familiaridad con corrutinas y `Flow` — imprescindible antes de la sección de arquitectura.

> 💡 **Consejo profesional**: fija siempre las versiones de Compose vía el [BOM (Bill of Materials)](https://developer.android.com/develop/ui/compose/bom/bom-mapping). Sin el BOM, es fácil mezclar versiones incompatibles entre `material3`, `foundation` y `ui`, lo que produce errores de resolución en tiempo de compilación difíciles de diagnosticar.
>
> ```kotlin
> dependencies {
>     val bom = platform("androidx.compose:compose-bom:2024.09.00") // usa siempre la última
>     implementation(bom)
>     implementation("androidx.compose.material3:material3")
>     implementation("androidx.compose.ui:ui-tooling-preview")
>     debugImplementation("androidx.compose.ui:ui-tooling")
> }
> ```

# Fundamentos de Jetpack Compose

## ¿Qué es un `@Composable`?

Un `@Composable` es una función que describe una porción de UI. Recibe datos y "emite" una descripción de interfaz; Compose decide cuándo volver a ejecutarla según los datos de los que depende.

```kotlin
@Composable
fun Bienvenida(nombre: String) {
    Text(text = "Bienvenido, $nombre")
}
```

**Regla de producción:** una función `@Composable` debe ser *idempotente* respecto a sus parámetros: dado el mismo input, debe producir el mismo árbol de UI. Si metes lógica con efectos secundarios (llamadas de red, escritura en disco, logging) directamente en el cuerpo de un composable, esa lógica se ejecutará en cada recomposición, potencialmente varias veces por segundo. Para eso existen las APIs de *side-effects* (`LaunchedEffect`, `DisposableEffect`, `SideEffect`) que se explican más abajo.

## Composición y recomposición

* **Composición**: proceso inicial donde Compose ejecuta tus funciones `@Composable` y construye un árbol de UI en memoria.
* **Recomposición**: cuando un estado leído dentro de un composable cambia, Compose vuelve a ejecutar *solo* las funciones que leen ese estado — no todo el árbol.

## Bajo el capó: la Slot Table y la recomposición inteligente

Esto es lo que separa a un desarrollador junior de Compose de uno que puede diagnosticar problemas de rendimiento en producción.

Internamente, Compose no usa el árbol de Views tradicional. Usa una estructura de datos llamada **Slot Table**: un buffer lineal en el que cada llamada a un `@Composable` ocupa una posición ("slot") determinada por su ubicación en el código fuente, no por un identificador explícito. Esto se llama **memoización posicional** (*positional memoization*).

**Analogía:** imagina un teatro con butacas numeradas por orden de fila y columna, no por el nombre del espectador. Compose sabe qué "butaca" corresponde a cada composable por dónde aparece en tu código, no porque tú le hayas dado un ID. Por eso, si dentro de un `if`/`else` o un bucle cambias el *orden* en que se llaman los composables sin darles una `key` explícita, Compose puede confundir un composable con otro y aplicar el estado equivocado al elemento equivocado (un bug clásico en `LazyColumn` sin `key`, ver sección de Listas).

Cuando un `MutableState` cambia, el runtime de Compose (`Snapshot System`) marca como "sucias" únicamente las regiones de la Slot Table que leyeron ese estado, y solo esas regiones se vuelven a ejecutar. Esto es lo que hace que Compose sea eficiente incluso en árboles de UI grandes.

## Estabilidad y skippability

Para que Compose pueda "saltarse" (skip) la recomposición de un composable cuando sus parámetros no cambiaron, el compilador necesita poder demostrar que esos parámetros son **estables**: si dos instancias son `equals()`, sus lecturas producen el mismo resultado.

* Tipos primitivos, `String`, y lambdas capturadas correctamente son estables por defecto.
* Una `data class` con `val` (inmutable) es estable.
* Una `data class` con `var`, o que contiene `List`/`Map`/`Set` (interfaces, no garantizan inmutabilidad) se considera **inestable**, y Compose recompone el composable en cada pasada aunque el contenido no haya cambiado realmente.

```kotlin
// ❌ MAL: List es una interfaz mutable, el compilador no puede garantizar estabilidad
data class UiState(val items: List<String>)

// ✅ BIEN: usa kotlinx.collections.immutable o marca la clase como @Immutable
// si tú garantizas que nunca mutas su contenido internamente
@Immutable
data class UiState(val items: List<String>)
```

> 💡 **Consejo profesional**: activa el [Compose Compiler Metrics](https://developer.android.com/develop/ui/compose/performance/stability/diagnose) (`freeCompilerArgs` con `-P plugin:androidx.compose.compiler.plugins.kotlin:reportsDestination=...`) para generar un reporte de qué composables son "skippable" y cuáles no. Es la única forma objetiva de saber si tu app tiene problemas de recomposición innecesaria antes de que un usuario se queje de lag.

## Visualizar vistas previas (@Preview)

```kotlin
@Preview(showBackground = true, name = "Vista Bienvenida")
@Composable
fun PreviewBienvenida() {
    Bienvenida(nombre = "Carlos")
}
```

| Opción           | Descripción                                |
| ---------------- | ------------------------------------------ |
| `showBackground` | Muestra un fondo claro                     |
| `name`           | Título de la preview                       |
| `showSystemUi`   | Simula navegación, barra de estado, etc.   |
| `uiMode`         | Cambia entre dark mode, night mode, etc.   |
| `locale`         | Simula localización (`"es"`, `"en"`, etc.) |

## Ciclo de vida básico en Jetpack Compose

| Etapa          | Equivalente en Views               | Descripción                                  |
| -------------- | ----------------------------------- | --------------------------------------------- |
| Composición    | `onCreateView()`                    | Construcción inicial del árbol de UI          |
| Recomposición  | `invalidate()` / `requestLayout()`  | Actualización parcial ante cambios de estado  |
| Descomposición | `onDestroyView()`                   | Limpieza de recursos y nodo del árbol         |

## Gestión de estado: remember y mutableStateOf

```kotlin
@Composable
fun Contador() {
    var contador by remember { mutableIntStateOf(0) }

    Button(onClick = { contador++ }) {
        Text("Contador: $contador")
    }
}
```
> Este estado se pierde si el Composable desaparece del árbol (por ejemplo, rotación de pantalla). Para sobrevivir a eso, usa `rememberSaveable`.

> 💡 **Consejo profesional**: para tipos primitivos usa las variantes especializadas `mutableIntStateOf`, `mutableFloatStateOf`, `mutableLongStateOf`, `mutableDoubleStateOf` en lugar de `mutableStateOf<Int>()`. Evitan el *autoboxing* y reducen presión sobre el recolector de basura — relevante en listas grandes o animaciones frecuentes.

## rememberSaveable: sobreviviendo a cambios de configuración

`remember` pierde su valor cuando la Activity se recrea (rotación, cambio de idioma, modo oscuro). `rememberSaveable` guarda el valor en el `Bundle` de estado, igual que `onSaveInstanceState` en Views.

```kotlin
@Composable
fun ContadorPersistente() {
    var contador by rememberSaveable { mutableIntStateOf(0) }

    Button(onClick = { contador++ }) {
        Text("Contador: $contador")
    }
}
```

Para tipos no `Parcelable` ni primitivos, define un `Saver` personalizado:

```kotlin
data class Filtro(val texto: String, val soloActivos: Boolean)

val FiltroSaver = listSaver<Filtro, Any>(
    save = { listOf(it.texto, it.soloActivos) },
    restore = { Filtro(it[0] as String, it[1] as Boolean) }
)

var filtro by rememberSaveable(stateSaver = FiltroSaver) {
    mutableStateOf(Filtro("", false))
}
```

## State Hoisting: el patrón fundamental de Compose

**State hoisting** ("elevar el estado") es el patrón que hace que un Composable sea reutilizable, testeable y predecible: el componente recibe el valor actual como parámetro (`value`) y notifica cambios hacia arriba mediante un callback (`onValueChange`), sin guardar su propio estado mutable.

```kotlin
// ❌ MAL: estado interno, difícil de reutilizar, testear o controlar desde fuera
@Composable
fun BuscadorConEstado() {
    var texto by remember { mutableStateOf("") }
    TextField(value = texto, onValueChange = { texto = it })
}

// ✅ BIEN: estado elevado (hoisted), reutilizable, testeable, predecible
@Composable
fun Buscador(texto: String, onTextoChange: (String) -> Unit) {
    TextField(value = texto, onValueChange = onTextoChange)
}

@Composable
fun PantallaBusqueda() {
    var query by rememberSaveable { mutableStateOf("") }
    Buscador(texto = query, onTextoChange = { query = it })
}
```

Este patrón sigue el principio de **flujo de datos unidireccional (UDF)**: el estado desciende (*state flows down*), los eventos ascienden (*events flow up*). Es la misma idea que reaparecerá con `StateFlow` en el `ViewModel`.

| Enfoque                  | Ventajas                                                       | Cuándo usarlo                                  |
| ------------------------- | ---------------------------------------------------------------- | ------------------------------------------------- |
| Estado interno (`remember`) | Simple, rápido de escribir                                     | Composables pequeños, de un solo uso, sin lógica de negocio |
| Estado elevado (hoisted)  | Reutilizable, testeable, fuente única de verdad, fácil de preview | Componentes reutilizables, pantallas completas, lógica compartida |

# Componentes Principales de Jetpack Compose

Jetpack Compose ofrece componentes UI reutilizables que reemplazan a `TextView`, `Button`, `RecyclerView`, `EditText`, etc. Son 100% declarativos y adaptables al estado.

## Layout

### Box
Coloca elementos uno encima de otro, como un `FrameLayout`.

```kotlin
@Composable
fun MyBox() {
    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        Box(
            Modifier
                .size(50.dp)
                .background(Color.Red)
                .verticalScroll(rememberScrollState())
        ) {
            Text("Hola Hola Hola Hola Hola Hola")
        }
    }
}
```

> ⚠️ **Errata corregida**: la función original omitía `@Composable` en `fun MyBox()`. Sin esa anotación, el código no compila — solo puedes llamar a `Box`, `Text`, etc. desde dentro de otra función marcada `@Composable`.

### Column (Vertical)
```kotlin
Column {
    Text("Opción 1")
    Text("Opción 2")
}
```

### Row (Horizontal)
```kotlin
Row(verticalAlignment = Alignment.CenterVertically) {
    Text("Modo oscuro")
    Switch(checked = true, onCheckedChange = {})
}
```

> 💡 **Consejo profesional — el orden de `Modifier` importa**: `Modifier.padding(16.dp).background(Color.Red)` no es lo mismo que `Modifier.background(Color.Red).padding(16.dp)`. En el primero, el fondo rojo se pinta *dentro* del padding (el padding queda transparente). En el segundo, el fondo cubre también el padding. Cada `Modifier` envuelve al siguiente como una función de orden superior; léelos de arriba hacia abajo como capas anidadas, no como propiedades CSS independientes.

## Text
```kotlin
Text(
    text = "Monto Total",
    style = MaterialTheme.typography.titleMedium,
    color = Color.Blue
)
```

## TextField - Entrada de datos
```kotlin
var nombre by rememberSaveable { mutableStateOf("") }

TextField(
    value = nombre,
    onValueChange = { nombre = it },
    label = { Text("Nombre del cliente") },
    modifier = Modifier.fillMaxWidth()
)
```
> Usa `rememberSaveable` para que el valor se mantenga tras rotar la pantalla.

## Componente Buttons

| Composable          | Fondo  | Borde | Elevación | Uso típico                          |
| -------------------- | ------ | ----- | --------- | ------------------------------------ |
| `Button`             | Sólido | No    | Baja      | Acción principal                     |
| `OutlinedButton`     | No     | Sí    | No        | Acción secundaria                    |
| `TextButton`         | No     | No    | No        | Acción menor/discreta                |
| `ElevatedButton`     | Claro  | No    | Alta      | Acción destacada, no principal       |
| `FilledTonalButton`  | Tonal  | No    | Baja      | Acción secundaria visualmente clara  |

```kotlin
Button(
    onClick = {},
    colors = ButtonDefaults.buttonColors(
        containerColor = Color.Blue,
        contentColor = Color.White
    ),
    shape = RoundedCornerShape(8.dp),
    elevation = ButtonDefaults.buttonElevation(defaultElevation = 6.dp)
) {
    Icon(Icons.Default.Favorite, contentDescription = null)
    Spacer(Modifier.width(8.dp))
    Text("Favorito")
}
```

```kotlin
OutlinedButton(
    onClick = {},
    border = BorderStroke(1.dp, Color.Gray),
    shape = RoundedCornerShape(12.dp)
) {
    Text("Cancelar")
}
```

```kotlin
TextButton(
    onClick = {},
    colors = ButtonDefaults.textButtonColors(contentColor = Color.Red)
) {
    Text("Eliminar")
}
```

```kotlin
ElevatedButton(onClick = { /* Acción */ }) {
    Text("Continuar")
}
```

```kotlin
FilledTonalButton(onClick = { /* Acción */ }) {
    Text("Agregar")
}
```

## Images e Iconos

| Composable | Usado para    | Fuente de datos      | Escalable | Común en...             |
| ---------- | -------------- | --------------------- | --------- | ------------------------ |
| `Icon`     | Íconos vector  | `Icons.Default`, SVG  | Sí        | Botones, menús, etc.     |
| `Image`    | Imágenes       | Recursos, red         | Depende   | Avatares, ilustraciones  |

### Icono
```kotlin
Icon(
    imageVector = Icons.Filled.Home,
    contentDescription = "Inicio",
    tint = Color.Blue,
    modifier = Modifier.size(32.dp)
)
```

> ⚠️ **Corrección**: `Icons.Filled` requiere la dependencia `material-icons-extended` para el catálogo completo; `Icons.Default` viene incluido con `material3` pero con un set reducido. Si un ícono que buscas no aparece, es casi siempre por esta dependencia faltante, no por un error de tipeo.

### Image
```kotlin
Image(
    painter = painterResource(id = R.drawable.profile),
    contentDescription = "Foto de perfil",
    contentScale = ContentScale.Crop,
    modifier = Modifier
        .size(100.dp)
        .clip(CircleShape)
        .border(2.dp, Color.Gray, CircleShape)
)
```

### Imágenes desde la web (usando Coil)
```gradle
implementation("io.coil-kt:coil-compose:2.6.0") // revisa la última versión
```

```kotlin
import coil.compose.AsyncImage

AsyncImage(
    model = "https://example.com/image.png",
    contentDescription = "Imagen remota",
    contentScale = ContentScale.Crop,
    modifier = Modifier.size(120.dp)
)
```

> ⚠️ **Nota de producción**: `Coil 3.x` (2024+) ya no depende de OkHttp por defecto y separa el artefacto en `coil3`. Si tu proyecto usa Coil 3, el import y el `build.gradle` cambian (`io.coil-kt.coil3:coil-compose`). Verifica la versión mayor antes de copiar snippets de internet — es un error frecuente mezclar APIs de Coil 2 con dependencias de Coil 3.

## ProgressBar

### CircularProgressIndicator
```kotlin
CircularProgressIndicator() // indeterminado
CircularProgressIndicator(progress = { 0.6f }) // determinado, 60%
```

> ⚠️ **Nota de versión**: desde Material3 1.1, `progress: Float` está deprecado en favor de `progress: () -> Float` (lambda). Esto evita recomposiciones del padre cuando el progreso cambia, porque solo se relee dentro del propio indicador. Usa siempre la versión lambda en proyectos nuevos.

### LinearProgressIndicator
```kotlin
LinearProgressIndicator(progress = { 0.4f }) // 40%
```

### Loading con Lottie (animaciones)
```gradle
implementation("com.airbnb.android:lottie-compose:6.4.0") // verifica la última versión
```

```kotlin
import com.airbnb.lottie.compose.*

@Composable
fun LottieLoadingAnimation() {
    val composition by rememberLottieComposition(LottieCompositionSpec.RawRes(R.raw.loading))
    val progress by animateLottieCompositionAsState(composition)

    LottieAnimation(composition, progress, modifier = Modifier.size(150.dp))
}
```

## Control de selección

| Composable          | Tipo      | Estados                        | Selección múltiple | Uso común                         |
| --------------------- | --------- | ---------------------------------- | -------------------- | ------------------------------------ |
| `Switch`             | Binario   | On / Off                          | ❌                    | Configuraciones                     |
| `Checkbox`           | Binario   | Checked / Unchecked               | ✔️                    | Listas de opciones                  |
| `TriStateCheckbox`   | Ternario  | On / Off / Indeterminate          | ✔️ (con jerarquía)    | Selección parcial en listas         |
| `RadioButton`        | Exclusivo | Seleccionado / No seleccionado    | ❌ (1 por grupo)      | Formularios con una sola elección   |

```kotlin
Switch(
    checked = isChecked,
    onCheckedChange = { isChecked = it },
    colors = SwitchDefaults.colors(
        checkedThumbColor = Color.Green,
        uncheckedThumbColor = Color.Gray,
        checkedTrackColor = Color.LightGreen
    )
)
```

```kotlin
Row(verticalAlignment = Alignment.CenterVertically) {
    Checkbox(
        checked = checked,
        onCheckedChange = { checked = it },
        colors = CheckboxDefaults.colors(
            checkedColor = Color.Blue,
            uncheckedColor = Color.Gray
        )
    )
    Text("Aceptar términos")
}
```

Estados de `TriStateCheckbox` (**corregido**: el original tenía la palabra "Ideterminate" mal escrita):
* On (seleccionado) → `ToggleableState.On`
* Off (no seleccionado) → `ToggleableState.Off`
* Indeterminate (estado parcial) → `ToggleableState.Indeterminate`

```kotlin
var state by remember { mutableStateOf(ToggleableState.Indeterminate) }

TriStateCheckbox(
    state = state,
    onClick = {
        state = when (state) {
            ToggleableState.Off -> ToggleableState.On
            ToggleableState.On -> ToggleableState.Indeterminate
            ToggleableState.Indeterminate -> ToggleableState.Off
        }
    }
)
```

```kotlin
var selectedOption by remember { mutableStateOf("Opción A") }

Row(verticalAlignment = Alignment.CenterVertically) {
    RadioButton(
        selected = selectedOption == "Opción A",
        onClick = { selectedOption = "Opción A" },
        colors = RadioButtonDefaults.colors(
            selectedColor = Color.Red,
            unselectedColor = Color.Gray
        )
    )
    Text("Opción A")
}
```

## Slider y RangeSlider

| Composable    | Tipo de valor           | Control de extremos | Uso común                      |
| ------------- | ------------------------- | ---------------------- | --------------------------------- |
| `Slider`      | Un solo valor (`Float`)  | Un thumb               | Volumen, edad, nivel              |
| `RangeSlider` | Rango (`Float..Float`)   | Dos thumbs              | Precio mínimo/máximo, duración   |

```kotlin
Slider(
    value = sliderValue,
    onValueChange = { sliderValue = it },
    valueRange = 0f..10f,
    steps = 4, // 5 pasos intermedios
    onValueChangeFinished = { println("Valor final: $sliderValue") },
    colors = SliderDefaults.colors(
        thumbColor = Color.Red,
        activeTrackColor = Color.Red,
        inactiveTrackColor = Color.Gray
    )
)
```

```kotlin
RangeSlider(
    values = range,
    onValueChange = { range = it },
    valueRange = 0f..100f,
    steps = 9
)
```

## DropdownMenu

| Propiedad          | Descripción                                                            |
| ------------------- | ------------------------------------------------------------------------ |
| `expanded`         | Controla si el menú está visible.                                       |
| `onDismissRequest` | Se llama cuando el menú debería cerrarse.                               |
| `DropdownMenuItem` | Opción dentro del menú.                                                 |

```kotlin
var expanded by remember { mutableStateOf(false) }

Box {
    Button(onClick = { expanded = true }) {
        Text("Seleccionar opción")
    }

    DropdownMenu(
        expanded = expanded,
        onDismissRequest = { expanded = false },
        modifier = Modifier.width(180.dp)
    ) {
        DropdownMenuItem(
            leadingIcon = { Icon(Icons.Default.Settings, contentDescription = null) },
            text = { Text("Configuración") },
            onClick = { expanded = false }
        )
        DropdownMenuItem(text = { Text("Opción 2") }, onClick = { expanded = false })
    }
}
```

### ExposedDropdownMenuBox
```kotlin
var expanded by remember { mutableStateOf(false) }
var selectedOption by remember { mutableStateOf("Opción A") }
val options = listOf("Opción A", "Opción B", "Opción C")

ExposedDropdownMenuBox(
    expanded = expanded,
    onExpandedChange = { expanded = !expanded }
) {
    OutlinedTextField(
        value = selectedOption,
        onValueChange = {},
        readOnly = true,
        label = { Text("Selecciona una opción") },
        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
        modifier = Modifier.menuAnchor()
    )

    ExposedDropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
        options.forEach { selectionOption ->
            DropdownMenuItem(
                text = { Text(selectionOption) },
                onClick = { selectedOption = selectionOption; expanded = false }
            )
        }
    }
}
```

## Scaffold

Contenedor de layout de alto nivel con slots para `topBar`, `bottomBar`, `floatingActionButton`, `snackbarHost` y `content`.

> ⚠️ **Nota de versión crítica**: en `androidx.compose.material3.Scaffold`, los parámetros `scaffoldState`, `drawerContent`, `drawerGesturesEnabled` e `isFloatingActionButtonDocked` **no existen** — pertenecían a Material 2. En Material 3, el drawer lateral se implementa aparte con `ModalNavigationDrawer` envolviendo al `Scaffold`.

```kotlin
@Composable
fun MiPantalla() {
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()

    Scaffold(
        topBar = { TopAppBar(title = { Text("Scaffold Demo") }) },
        snackbarHost = { SnackbarHost(snackbarHostState) },
        floatingActionButton = {
            FloatingActionButton(onClick = {
                coroutineScope.launch {
                    snackbarHostState.showSnackbar("FAB presionado")
                }
            }) {
                Icon(Icons.Default.Add, contentDescription = "Agregar")
            }
        }
    ) { innerPadding ->
        Box(modifier = Modifier.fillMaxSize().padding(innerPadding)) {
            Text("Contenido principal", modifier = Modifier.align(Alignment.Center))
        }
    }
}
```

```kotlin
@Composable
fun PantallaConDrawer() {
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    val coroutineScope = rememberCoroutineScope()

    ModalNavigationDrawer(
        drawerState = drawerState,
        drawerContent = {
            ModalDrawerSheet { Text("Menú lateral", modifier = Modifier.padding(16.dp)) }
        }
    ) {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Mi App") },
                    navigationIcon = {
                        IconButton(onClick = { coroutineScope.launch { drawerState.open() } }) {
                            Icon(Icons.Default.Menu, contentDescription = "Abrir menú")
                        }
                    }
                )
            }
        ) { innerPadding ->
            Box(modifier = Modifier.padding(innerPadding)) {
                Text("Contenido principal")
            }
        }
    }
}
```

### TopAppBar
```kotlin
TopAppBar(
    title = { Text("Mi App") },
    navigationIcon = {
        IconButton(onClick = { /* abrir drawer */ }) {
            Icon(Icons.Default.Menu, contentDescription = "Menú")
        }
    },
    actions = {
        IconButton(onClick = { /* acción */ }) {
            Icon(Icons.Default.Settings, contentDescription = "Ajustes")
        }
    }
)
```

### BottomAppBar
```kotlin
BottomAppBar {
    IconButton(onClick = { /* acción 1 */ }) { Icon(Icons.Default.Home, contentDescription = null) }
    Spacer(Modifier.weight(1f))
    IconButton(onClick = { /* acción 2 */ }) { Icon(Icons.Default.Settings, contentDescription = null) }
}
```

### NavigationBar (antes BottomNavigation)
> ⚠️ **Nota de versión**: `BottomNavigation`/`BottomNavigationItem` son de Material 2. En Material 3 se reemplazan por `NavigationBar`/`NavigationBarItem`.

```kotlin
var selectedItem by remember { mutableIntStateOf(0) }
val items = listOf("Inicio" to Icons.Default.Home, "Perfil" to Icons.Default.Person)

NavigationBar {
    items.forEachIndexed { index, (label, icon) ->
        NavigationBarItem(
            selected = selectedItem == index,
            onClick = { selectedItem = index },
            icon = { Icon(icon, contentDescription = label) },
            label = { Text(label) }
        )
    }
}
```

### FloatingActionButton (FAB)
```kotlin
FloatingActionButton(onClick = { /* acción */ }) {
    Icon(Icons.Default.Add, contentDescription = "Agregar")
}
```

```kotlin
ExtendedFloatingActionButton(
    icon = { Icon(Icons.Default.Add, contentDescription = null) },
    text = { Text("Nuevo") },
    onClick = { /* acción */ }
)
```

### SnackbarHost y Snackbar
```kotlin
val result = snackbarHostState.showSnackbar(
    message = "¿Deshacer?",
    actionLabel = "Sí",
    duration = SnackbarDuration.Short
)
```
> `showSnackbar` es una función `suspend`: solo puede llamarse desde una corrutina (`rememberCoroutineScope().launch { }` o un `LaunchedEffect`), nunca directamente desde un `onClick`.

## Card

```kotlin
Card(
    modifier = Modifier.padding(8.dp).fillMaxWidth(),
    shape = RoundedCornerShape(12.dp),
    elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
) {
    Column(modifier = Modifier.padding(16.dp)) {
        Text("Título de la tarjeta", style = MaterialTheme.typography.titleLarge)
        Text("Contenido de la tarjeta", style = MaterialTheme.typography.bodyMedium)
    }
}
```

> ⚠️ **Nota de versión**: `elevation = 8.dp` (un `Dp` directo) y `MaterialTheme.typography.h6` son de Material 2. En Material 3, la elevación se pasa como `CardElevation` vía `CardDefaults`, y la tipografía cambió de nombres: `h6`→`titleLarge`, `body1`→`bodyLarge`, `body2`→`bodyMedium`, `caption`→`labelSmall`.

## Badge
```kotlin
BadgedBox(badge = { Badge { Text("3") } }) {
    Icon(Icons.Default.Email, contentDescription = "Correo")
}
```

## HorizontalDivider (antes Divider)
> ⚠️ **Nota de versión**: `Divider` está deprecado desde Material3 1.2 en favor de `HorizontalDivider`/`VerticalDivider`.

```kotlin
Column {
    Text("Sección 1")
    HorizontalDivider(color = Color.Gray, thickness = 1.dp)
    Text("Sección 2")
}
```

## Diálogos

| Composable    | Función                                     | Nota importante                                      |
| -------------- | -------------------------------------------- | ------------------------------------------------------ |
| `AlertDialog` | Diálogo modal para alertas y confirmaciones | Composable nativo                                       |
| `DatePicker`  | Selección de fecha                          | Compose Material3 sí tiene `DatePicker` nativo desde 1.1 |
| `TimePicker`  | Selección de hora                           | Compose Material3 sí tiene `TimePicker` nativo desde 1.1 |

### AlertDialog
```kotlin
var openDialog by remember { mutableStateOf(true) }

if (openDialog) {
    AlertDialog(
        onDismissRequest = { openDialog = false },
        title = { Text("Título") },
        text = { Text("¿Quieres continuar?") },
        confirmButton = {
            TextButton(onClick = { openDialog = false }) { Text("Confirmar") }
        },
        dismissButton = {
            TextButton(onClick = { openDialog = false }) { Text("Cancelar") }
        }
    )
}
```

### DatePicker y TimePicker (API nativa de Material 3)

> ⚠️ **Corrección importante**: el documento original afirmaba que Compose "no incluye un composable nativo oficial para DatePicker o TimePicker" y proponía envolver los diálogos clásicos de `android.app.DatePickerDialog`. Eso era cierto en versiones tempranas de Compose (2022), pero **desde Material3 1.1 (2023) existen `DatePicker` y `TimePicker` nativos en Compose**. Usar el diálogo clásico de Views hoy es una regresión visual (rompe el theming de Material You) y ya no es necesario salvo que soportes versiones muy antiguas de la librería.

```kotlin
@Composable
fun DatePickerModalDemo(onFechaSeleccionada: (Long?) -> Unit, onDismiss: () -> Unit) {
    val datePickerState = rememberDatePickerState()

    DatePickerDialog(
        onDismissRequest = onDismiss,
        confirmButton = {
            TextButton(onClick = {
                onFechaSeleccionada(datePickerState.selectedDateMillis)
                onDismiss()
            }) { Text("Aceptar") }
        },
        dismissButton = { TextButton(onClick = onDismiss) { Text("Cancelar") } }
    ) {
        DatePicker(state = datePickerState)
    }
}
```

```kotlin
@Composable
fun TimePickerDemo() {
    val timePickerState = rememberTimePickerState(is24Hour = true)
    TimePicker(state = timePickerState)
    // timePickerState.hour y timePickerState.minute exponen el valor seleccionado
}
```

## Comportamientos avanzados y Side-Effects

| Composable / API    | Propósito principal                                   | Reactivo a cambios          | Uso común                          |
| --------------------- | --------------------------------------------------------- | ------------------------------ | -------------------------------------- |
| `InteractionSource`  | Detectar interacciones (clic, foco, etc.)                | Sí                              | Botones, inputs, efectos visuales      |
| `LaunchedEffect`     | Ejecutar corrutinas al entrar en composición o al cambiar una key | Sí, por clave           | Llamadas API, animaciones, eventos     |
| `DisposableEffect`   | Efecto con limpieza obligatoria al salir de composición  | Sí, por clave                   | Listeners, BroadcastReceivers, sensores |
| `SideEffect`         | Publicar el estado de Compose hacia un sistema no-Compose | En cada recomposición exitosa | Analytics, logging, libs externas       |
| `derivedStateOf`     | Calcular estados derivados optimizados                    | Sí, si dependencias cambian    | Filtrado, cálculos UI                    |

### InteractionSource
```kotlin
val interactionSource = remember { MutableInteractionSource() }
val isPressed by interactionSource.collectIsPressedAsState()

Button(onClick = { /* Acción */ }, interactionSource = interactionSource) {
    Text(if (isPressed) "Presionado" else "No presionado")
}
```

### LaunchedEffect
```kotlin
LaunchedEffect(Unit) {
    delay(1000)
    println("Efecto lanzado al componer")
}
```
`Unit` como key significa "ejecuta una sola vez mientras el composable esté en pantalla". Si pasas una variable como key (`LaunchedEffect(userId)`), el efecto se cancela y se relanza cada vez que esa variable cambia — patrón típico para recargar datos cuando cambia un ID.

### DisposableEffect

**Ausente en la guía original — es una omisión importante.** Se usa cuando el efecto secundario requiere una limpieza explícita al abandonar la composición (evitar memory leaks es la razón de ser de esta API).

```kotlin
@Composable
fun ObservadorDeConectividad(onCambioEstado: (Boolean) -> Unit) {
    val context = LocalContext.current

    DisposableEffect(context) {
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context, intent: Intent) {
                onCambioEstado(isNetworkAvailable(ctx))
            }
        }
        context.registerReceiver(receiver, IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION))

        // Este bloque onDispose es OBLIGATORIO: se ejecuta cuando el composable
        // sale del árbol o cuando la key cambia. Olvidarlo produce fugas de memoria
        // (el receiver queda registrado para siempre).
        onDispose {
            context.unregisterReceiver(receiver)
        }
    }
}
```

> 🚨 **Error de producción muy común**: usar `LaunchedEffect` para registrar un listener (sensor, receiver, callback) en lugar de `DisposableEffect`. `LaunchedEffect` no tiene un mecanismo de limpieza garantizado al desregistro; si necesitas "cuando esto desaparece, deshaz aquello", la respuesta casi siempre es `DisposableEffect`.

### derivedStateOf
```kotlin
val list by remember { mutableStateOf(listOf(1, 2, 3, 4)) }
val evenCount by remember {
    derivedStateOf { list.count { it % 2 == 0 } }
}

Text("Números pares: $evenCount")
```

## CompositionLocal: contexto implícito sin prop-drilling

**Tema ausente en la guía original.** `CompositionLocal` permite exponer un valor implícitamente a todo un subárbol de composables sin pasarlo como parámetro en cada nivel (evita el *prop drilling*). `MaterialTheme.colorScheme` que ya usas en toda la guía es, internamente, un `CompositionLocal`.

```kotlin
val LocalUsuarioActivo = staticCompositionLocalOf<Usuario?> { null }

@Composable
fun PantallaPrincipal(usuario: Usuario) {
    CompositionLocalProvider(LocalUsuarioActivo provides usuario) {
        ContenidoAnidado() // y todo lo que ContenidoAnidado componga
    }
}

@Composable
fun ContenidoAnidado() {
    val usuario = LocalUsuarioActivo.current
    Text("Hola, ${usuario?.nombre ?: "invitado"}")
}
```

> ⚠️ **Úsalo con moderación**: `CompositionLocal` es ideal para theming, configuración transversal (locale, densidad) o inyección de dependencias de UI. **No es un sustituto de un buen manejo de estado ni de un `ViewModel`** — abusar de él para pasar datos de negocio produce un acoplamiento implícito difícil de rastrear y testear.

# Listas dinámicas (antiguos RecyclerView)

| Composable           | Dirección  | Tipo    | Ideal para             |
| ---------------------- | ------------ | --------- | ------------------------- |
| `LazyColumn`          | Vertical    | Lista     | Chats, configuraciones    |
| `LazyRow`             | Horizontal  | Lista     | Carruseles, íconos        |
| `LazyVerticalGrid`    | Vertical    | Rejilla   | Galerías, tarjetas         |
| `LazyHorizontalGrid`  | Horizontal  | Rejilla   | Mosaicos desplazables      |
| `LazyListState`       | —           | Estado    | Control del scroll         |

## LazyColumn

```kotlin
data class Cliente(val id: String, val nombre: String)

val clientes = listOf(Cliente("1", "María"), Cliente("2", "Pedro"), Cliente("3", "Laura"))

LazyColumn(modifier = Modifier.fillMaxSize()) {
    items(
        items = clientes,
        key = { cliente -> cliente.id } // 👈 crítico, ver nota abajo
    ) { cliente ->
        Text(
            text = cliente.nombre,
            modifier = Modifier.fillMaxWidth().padding(12.dp)
        )
        HorizontalDivider()
    }
}
```

> 🚨 **Omisión crítica en la guía original — el parámetro `key`**: la versión anterior de este ejemplo usaba `items(clientes) { cliente -> ... }` sin `key`. Sin `key`, Compose identifica cada ítem por su **posición** en la lista (memoización posicional, ver sección de Arquitectura). Si insertas, eliminas o reordenas elementos, Compose puede reutilizar el estado del ítem equivocado: por ejemplo, un `TextField` con foco o un `Checkbox` marcado "salta" al ítem que ahora ocupa esa posición, en vez de seguir al elemento original. Usa siempre un `key` estable y único (típicamente el ID del dato), nunca el índice (`index`), porque el índice cambia si la lista se reordena — usar el índice como key es equivalente a no poner key.

## LazyRow
```kotlin
LazyRow(
    horizontalArrangement = Arrangement.spacedBy(8.dp),
    contentPadding = PaddingValues(horizontal = 16.dp)
) {
    items(20) { index ->
        Box(
            modifier = Modifier.size(100.dp).background(Color.Gray),
            contentAlignment = Alignment.Center
        ) {
            Text("Item $index")
        }
    }
}
```

## LazyVerticalGrid
```kotlin
LazyVerticalGrid(
    columns = GridCells.Fixed(2),
    contentPadding = PaddingValues(8.dp),
    verticalArrangement = Arrangement.spacedBy(8.dp),
    horizontalArrangement = Arrangement.spacedBy(8.dp)
) {
    items(20) { index ->
        Box(
            modifier = Modifier.aspectRatio(1f).background(Color.LightGray),
            contentAlignment = Alignment.Center
        ) {
            Text("Item $index")
        }
    }
}
```

## LazyHorizontalGrid
```kotlin
LazyHorizontalGrid(
    rows = GridCells.Fixed(2),
    modifier = Modifier.height(200.dp).fillMaxWidth(),
    horizontalArrangement = Arrangement.spacedBy(8.dp),
    verticalArrangement = Arrangement.spacedBy(8.dp),
    contentPadding = PaddingValues(8.dp)
) {
    items(30) { index ->
        Box(
            modifier = Modifier.size(100.dp).background(Color.Cyan),
            contentAlignment = Alignment.Center
        ) {
            Text("Item $index")
        }
    }
}
```

## Gestión del estado de listas
```kotlin
val listState = rememberLazyListState()

LazyColumn(state = listState) {
    items(50) { Text("Ítem $it") }
}

// Desplazamiento programático (requiere una corrutina)
val scope = rememberCoroutineScope()
Button(onClick = { scope.launch { listState.animateScrollToItem(0) } }) {
    Text("Volver arriba")
}
```

# Navegación (Navigation Compose, type-safe)

```kotlin
implementation("androidx.navigation:navigation-compose:2.8.0") // o la más reciente
implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.1")
```

## Navegación básica

```kotlin
@Composable
fun AppNavigation() {
    val navController = rememberNavController()

    NavHost(navController, startDestination = "home") {
        composable("home") { HomeScreen(navController) }
        composable("details") { DetailsScreen() }
    }
}
```

## Type-safe Navigation con `@Serializable` (API actual, desde Navigation 2.8)

> 🚨 **Sección reescrita — la versión original estaba obsoleta.** El documento original describía como "navegación type-safe" un patrón manual con `reified` genéricos y `SavedStateHandle` para pasar objetos `Parcelable`. Ese era un *workaround* de la comunidad para las limitaciones de las rutas basadas en `String` **antes de Navigation Compose 2.8**. Desde 2.8 (2024), la librería soporta rutas tipadas de forma nativa usando `kotlinx.serialization`, sin construir strings de ruta a mano ni depender de `SavedStateHandle` para pasar argumentos. El patrón anterior sigue funcionando pero hoy es la opción "legacy" — no la recomendada para proyectos nuevos.

```kotlin
import kotlinx.serialization.Serializable

// Cada destino es una clase o un object serializable — no un String
@Serializable object Home
@Serializable data class Perfil(val userId: String)
@Serializable data class DetalleProducto(val productId: String, val precio: Double)

@Composable
fun AppNavigation() {
    val navController = rememberNavController()

    NavHost(navController, startDestination = Home) {
        composable<Home> {
            HomeScreen(onIrAPerfil = { id -> navController.navigate(Perfil(userId = id)) })
        }
        composable<Perfil> { backStackEntry ->
            val perfil: Perfil = backStackEntry.toRoute()
            PerfilScreen(userId = perfil.userId)
        }
        composable<DetalleProducto> { backStackEntry ->
            val detalle: DetalleProducto = backStackEntry.toRoute()
            DetalleProductoScreen(id = detalle.productId, precio = detalle.precio)
        }
    }
}
```

**Ventajas frente al enfoque legacy con `String` + `SavedStateHandle`:**
* El compilador detecta en tiempo de compilación si pasas un argumento del tipo equivocado — con rutas `String` ese error solo aparece en runtime.
* Soporta objetos complejos (no solo primitivos) sin serializar manualmente a JSON ni usar `Parcelable`.
* No hay límite práctico de longitud de ruta como con el truco de pasar JSON en la URL (~2kb).

**Cuándo sigue siendo válido el enfoque legacy con `SavedStateHandle`:** si mantienes un proyecto con una versión de `navigation-compose` anterior a 2.8 y no puedes actualizar todavía, o si necesitas pasar un resultado de vuelta desde una pantalla hacia la anterior (por ejemplo, un `ActivityResult`-like flow), `savedStateHandle` sigue siendo la herramienta correcta para ese caso específico, no para el paso de argumentos de navegación hacia adelante.

## Manejo del back stack
```kotlin
navController.popBackStack()

navController.navigate(route) {
    popUpTo("home") { inclusive = true }
}

navController.navigate(Home) {
    popUpTo(0)
}
```

## BackHandler
```kotlin
BackHandler(enabled = true) {
    showExitDialog = true
}
```

# Animaciones

| API                            | Función                                   | Ideal para                        |
| -------------------------------- | -------------------------------------------- | -------------------------------------- |
| `animate*AsState`               | Anima un valor al cambiar                    | Tamaño, color, opacidad                |
| `Crossfade`                     | Cambia de un contenido a otro con fade      | Alternar pantallas/íconos              |
| `AnimatedContent`               | Transiciones de contenido con animación     | Contenido dinámico más complejo        |
| `animateContentSize`            | Anima el cambio de tamaño del componente    | Expansión de tarjetas, diálogos        |
| `rememberInfiniteTransition`    | Animación infinita                           | Carga, parpadeo, loops visuales        |

## \*AsState
```kotlin
val expanded = remember { mutableStateOf(false) }

val boxSize by animateDpAsState(
    targetValue = if (expanded.value) 200.dp else 100.dp,
    animationSpec = tween(durationMillis = 500),
    label = "boxSize" // 👈 recomendado: nombra tus animaciones para depurarlas en el Layout Inspector
)

Box(
    Modifier.size(boxSize).background(Color.Blue).clickable { expanded.value = !expanded.value }
)
```

## Crossfade
```kotlin
var selected by remember { mutableStateOf(true) }

Crossfade(targetState = selected, label = "crossfadeDemo") { isSelected ->
    if (isSelected) Text("Hola") else Icon(Icons.Default.Star, contentDescription = null)
}
```

## AnimatedContent
```kotlin
var count by remember { mutableIntStateOf(0) }

AnimatedContent(
    targetState = count,
    transitionSpec = {
        (slideInVertically { it } + fadeIn())
            .togetherWith(slideOutVertically { -it } + fadeOut())
    },
    label = "contador"
) { targetCount ->
    Text("Count: $targetCount")
}
```
> ⚠️ **Nota de versión**: el infijo `with` para combinar `EnterTransition`/`ExitTransition` está deprecado desde Compose 1.5 (choca con `kotlin.with`). Usa `togetherWith`.

## animateContentSize
```kotlin
var expanded by remember { mutableStateOf(false) }

Box(
    modifier = Modifier
        .clickable { expanded = !expanded }
        .background(Color.Gray)
        .animateContentSize()
        .padding(16.dp)
) {
    Text(if (expanded) "Texto largo con más líneas" else "Texto corto")
}
```

## InfiniteTransition
```kotlin
val infiniteTransition = rememberInfiniteTransition(label = "pulso")

val alpha by infiniteTransition.animateFloat(
    initialValue = 0.3f,
    targetValue = 1f,
    animationSpec = infiniteRepeatable(animation = tween(1000), repeatMode = RepeatMode.Reverse),
    label = "alpha"
)

Box(modifier = Modifier.size(100.dp).background(Color.Red.copy(alpha = alpha)))
```

# Temas y Estilos en Jetpack Compose (Material 3)

## ¿Qué es un Tema en Compose?
Un tema define: paleta de colores (`colorScheme`), tipografía (`Typography`), formas (`Shapes`) y estilos (`MaterialTheme`).

## Estructura de theming
```
├── ui/
│   └── theme/
│       ├── Color.kt
│       ├── Type.kt
│       ├── Shape.kt
│       └── Theme.kt
```

## Definición de colores (`Color.kt`)
```kotlin
val AzulEmpresarial = Color(0xFF0050B3)
val GrisFondo = Color(0xFFF5F5F5)
val RojoError = Color(0xFFD32F2F)
```

## Tipografía (`Type.kt`)
```kotlin
val TipografiaEmpresarial = Typography(
    titleLarge = TextStyle(fontFamily = FontFamily.SansSerif, fontWeight = FontWeight.Bold, fontSize = 22.sp),
    bodyMedium = TextStyle(fontSize = 16.sp)
)
```

## Theme.kt
```kotlin
@Composable
fun MiAppTheme(
    darkTheme: Boolean = isSystemInDarkTheme(), // 👈 respeta el modo oscuro del sistema
    content: @Composable () -> Unit
) {
    val colores = if (darkTheme) {
        darkColorScheme(primary = AzulEmpresarial, error = RojoError)
    } else {
        lightColorScheme(primary = AzulEmpresarial, background = GrisFondo, error = RojoError)
    }

    MaterialTheme(
        colorScheme = colores,
        typography = TipografiaEmpresarial,
        shapes = Shapes(),
        content = content
    )
}
```
> ⚠️ **Omisión en la versión original**: el tema no contemplaba modo oscuro (`darkColorScheme`). Ignorar `isSystemInDarkTheme()` es un defecto de accesibilidad y una queja frecuente de usuarios en producción — Android espera que las apps respeten la preferencia del sistema salvo que el usuario la desactive explícitamente dentro de la app.

```kotlin
setContent {
    MiAppTheme {
        AppContent()
    }
}
```

## Estilos reutilizables
```kotlin
Text(
    text = "Bienvenido",
    style = MaterialTheme.typography.titleLarge,
    color = MaterialTheme.colorScheme.primary
)
```

# Arquitectura Recomendada: MVVM + Jetpack Compose

## Capas de la arquitectura

| Capa       | Rol                                                                 |
| ----------- | ---------------------------------------------------------------------- |
| View       | UI declarativa (`@Composable`), sin lógica de negocio                  |
| ViewModel  | Estado de UI, orquesta casos de uso, sobrevive a rotación              |
| Repository | Abstracción de acceso a datos (red, BD, caché)                         |
| Model      | Entidades y estructuras de datos                                       |

## Estructura de paquetes sugerida
```
├── data/
│   ├── model/
│   └── repository/
├── ui/
│   ├── screen/
│   ├── components/
│   └── theme/
├── viewmodel/
└── MainActivity.kt
```

## Ejemplo completo: ViewModel + StateFlow + Composable

**Ausente en la guía original.** La sección de MVVM solo describía el flujo de datos en prosa, sin código real conectando `ViewModel` → `StateFlow` → Composable. Esto es el corazón práctico de MVVM en Compose; sin este ejemplo, la sección es teórica.

```kotlin
// --- Model ---
data class ProductoUiState(
    val productos: List<Producto> = emptyList(),
    val cargando: Boolean = false,
    val error: String? = null
)

// --- ViewModel ---
class ProductosViewModel(
    private val repository: ProductoRepository // inyectado, p. ej. con Hilt
) : ViewModel() {

    private val _uiState = MutableStateFlow(ProductoUiState())
    val uiState: StateFlow<ProductoUiState> = _uiState.asStateFlow()

    init {
        cargarProductos()
    }

    fun cargarProductos() {
        viewModelScope.launch {
            _uiState.update { it.copy(cargando = true, error = null) }
            try {
                val productos = repository.obtenerProductos()
                _uiState.update { it.copy(productos = productos, cargando = false) }
            } catch (e: IOException) {
                _uiState.update { it.copy(error = "Sin conexión", cargando = false) }
            }
        }
    }
}

// --- View ---
@Composable
fun ProductosScreen(viewModel: ProductosViewModel = hiltViewModel()) {
    // collectAsStateWithLifecycle es la forma recomendada en producción:
    // pausa la recolección cuando la app va a background, evitando trabajo
    // innecesario y posibles crashes por actualizar UI que no está visible.
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    when {
        uiState.cargando -> CircularProgressIndicator()
        uiState.error != null -> Text("Error: ${uiState.error}")
        else -> LazyColumn {
            items(uiState.productos, key = { it.id }) { producto ->
                Text(producto.nombre)
            }
        }
    }
}
```

> 🚨 **Error de producción muy común**: usar `collectAsState()` en vez de `collectAsStateWithLifecycle()`. `collectAsState()` sigue recolectando el `Flow` incluso cuando la app está en background, desperdiciando recursos y — en el peor caso — causando crashes al intentar actualizar composables que ya no están en pantalla. Requiere la dependencia `androidx.lifecycle:lifecycle-runtime-compose`.

## Flujo de datos en Compose con MVVM
View (Composable) ⇄ observa ⇄ ViewModel ⇄ lógica y datos ⇄ Repository/Model

## Ventajas del enfoque MVVM con Compose

| Ventaja                         | Descripción                                        |
| ---------------------------------- | ------------------------------------------------------ |
| Separación de responsabilidades  | La UI no tiene lógica de negocio                       |
| Estados reactivos                | La UI se actualiza automáticamente con `StateFlow`     |
| Pruebas más sencillas            | Puedes testear el ViewModel sin depender de la UI       |
| Reutilización de componentes     | Composables pequeños y probados                         |

## Previsualizar UI con fake ViewModel
```kotlin
@Preview(showBackground = true)
@Composable
fun VistaPreview() {
    val contadorFalso = remember { mutableStateOf(10) }

    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text("Valor actual: ${contadorFalso.value}")
        Button(onClick = { contadorFalso.value++ }) {
            Text("Sumar")
        }
    }
}
```

# Testing de Composables

**Sección ausente en la guía original.** Una guía "profesional" que no cubre testing es una guía incompleta: sin esto, no hay forma de garantizar que un refactor de UI no rompió el comportamiento.

```gradle
androidTestImplementation("androidx.compose.ui:ui-test-junit4:1.7.0")
debugImplementation("androidx.compose.ui:ui-test-manifest:1.7.0")
```

```kotlin
class ContadorTest {

    @get:Rule
    val composeTestRule = createComposeRule()

    @Test
    fun alHacerClicEnBoton_elContadorAumenta() {
        composeTestRule.setContent {
            Contador()
        }

        composeTestRule.onNodeWithText("Contador: 0").assertIsDisplayed()
        composeTestRule.onNodeWithText("Contador: 0").performClick()
        composeTestRule.onNodeWithText("Contador: 1").assertIsDisplayed()
    }
}
```

> 💡 **Consejo profesional**: usa `Modifier.testTag("miTag")` en composables sin texto identificable (íconos, imágenes) para poder ubicarlos con `onNodeWithTag("miTag")` en los tests, en vez de depender de textos visibles que cambian con la localización del idioma.

# 🚨 Errores Comunes en Producción (Checklist Final)

Esta sección consolida los errores que la guía original no mencionaba explícitamente y que son las causas más frecuentes de bugs y lentitud en apps Compose reales:

1. **`LazyColumn`/`LazyRow` sin `key`**: provoca que el estado de un ítem (foco, checkbox marcado, posición de scroll de un elemento anidado) "salte" al ítem incorrecto cuando la lista cambia. Solución: siempre `items(lista, key = { it.id })`.

2. **Lógica con efectos secundarios directamente en el cuerpo de un `@Composable`** (llamadas de red, escritura en `SharedPreferences`, logging): se ejecuta en cada recomposición, no una sola vez. Solución: usa `LaunchedEffect`, `DisposableEffect` o mueve la lógica al `ViewModel`.

3. **`collectAsState()` en vez de `collectAsStateWithLifecycle()`**: sigue observando el `StateFlow` con la app en background. Solución: usa siempre la variante con lifecycle-aware en pantallas reales (no en tests).

4. **Clases de estado inestables** (`List`/`Map`/`Set` sin `@Immutable`, `var` en `data class`): impiden que Compose "salte" recomposiciones innecesarias. Solución: usa `@Immutable`/`@Stable` o colecciones inmutables de `kotlinx.collections.immutable`.

5. **Registrar listeners/receivers con `LaunchedEffect` en lugar de `DisposableEffect`**: produce fugas de memoria porque no hay garantía de limpieza. Solución: `DisposableEffect` con `onDispose { }`.

6. **Ignorar el orden de `Modifier`**: `padding().background()` ≠ `background().padding()`. Revisa siempre el orden cuando el resultado visual no es el esperado.

7. **Usar el `index` de una lista como `key`**: equivale a no tener `key`, porque el índice cambia si la lista se reordena o filtra.

8. **No usar el BOM de Compose**: mezclar versiones sueltas de `material3`, `foundation` y `ui` produce errores de compilación crípticos. Usa siempre `platform("androidx.compose:compose-bom:...")`.

9. **Tema sin soporte de modo oscuro** (`isSystemInDarkTheme()` ignorado): defecto de accesibilidad y UX frecuente en apps que solo probaron en modo claro.

10. **No medir la estabilidad de los composables antes de optimizar a ciegas**: usa el reporte del Compose Compiler (`stability` y `skippable` metrics) para encontrar los composables realmente costosos, en vez de adivinar dónde está el cuello de botella.
