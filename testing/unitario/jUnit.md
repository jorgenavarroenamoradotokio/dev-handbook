> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. ¿Qué es JUnit 5?](#1-qué-es-junit-5)
  - [¿Por qué es crítico en producción?](#por-qué-es-crítico-en-producción)
  - [Tipos de pruebas que cubre](#tipos-de-pruebas-que-cubre)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [JUnit Platform](#junit-platform)
  - [JUnit Jupiter](#junit-jupiter)
  - [JUnit Vintage](#junit-vintage)
  - [Dependencias Maven (configuración mínima production-ready)](#dependencias-maven-configuración-mínima-production-ready)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Estructura básica de una clase de test](#estructura-básica-de-una-clase-de-test)
  - [Anotaciones del ciclo de vida](#anotaciones-del-ciclo-de-vida)
  - [Asserts y Grupo de Assertions](#asserts-y-grupo-de-assertions)
    - [Grupo de Assertions con `assertAll`](#grupo-de-assertions-con-assertall)
  - [Organización: Nested, Tags y Display Names](#organización-nested-tags-y-display-names)
    - [`@Nested` — Agrupar tests relacionados](#nested--agrupar-tests-relacionados)
    - [`@Tag` — Clasificar y filtrar tests en el pipeline](#tag--clasificar-y-filtrar-tests-en-el-pipeline)
  - [Tests Parametrizados](#tests-parametrizados)
    - [`@ValueSource` — Lista simple de valores](#valuesource--lista-simple-de-valores)
    - [`@EnumSource` — Filtrar valores de un enum](#enumsource--filtrar-valores-de-un-enum)
    - [`@MethodSource` — Casos de prueba complejos con múltiples argumentos](#methodsource--casos-de-prueba-complejos-con-múltiples-argumentos)
    - [`@CsvSource` y `@CsvFileSource` — Datos tabulares](#csvsource-y-csvfilesource--datos-tabulares)
  - [Control de Tiempo de Ejecución](#control-de-tiempo-de-ejecución)
    - [`@Timeout` — Interrumpir un test "colgado" (comportamiento agresivo)](#timeout--interrumpir-un-test-colgado-comportamiento-agresivo)
    - [`assertTimeout` — Verificar el tiempo de un bloque específico (comportamiento suave)](#asserttimeout--verificar-el-tiempo-de-un-bloque-específico-comportamiento-suave)
  - [Ciclo de Vida de la Instancia](#ciclo-de-vida-de-la-instancia)
    - [`PER_METHOD` (comportamiento por defecto)](#per_method-comportamiento-por-defecto)
    - [`PER_CLASS` — Una instancia para todos los tests](#per_class--una-instancia-para-todos-los-tests)
  - [Condiciones de Ejecución por Entorno](#condiciones-de-ejecución-por-entorno)
  - [Inyección de Dependencias: TestInfo y TestReporter](#inyección-de-dependencias-testinfo-y-testreporter)
  - [TDD: Test-Driven Development](#tdd-test-driven-development)
    - [Ejemplo práctico: Calculadora de descuentos](#ejemplo-práctico-calculadora-de-descuentos)
    - [Flujo TDD en un equipo ágil](#flujo-tdd-en-un-equipo-ágil)
    - [Limitaciones reales de TDD (sin suavizarlas)](#limitaciones-reales-de-tdd-sin-suavizarlas)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  - [Errores frecuentes en producción](#errores-frecuentes-en-producción)
  - [Checklist de buenas prácticas](#checklist-de-buenas-prácticas)

---

# 1. ¿Qué es JUnit 5?

**JUnit 5** es el framework estándar de la industria para escribir y ejecutar pruebas automatizadas en proyectos Java. Proporciona las herramientas, anotaciones y métodos de aserción necesarios para verificar que cada unidad de tu código funciona exactamente como se espera, ahora y en el futuro.

## ¿Por qué es crítico en producción?

El problema real que resuelve es la **regresión silenciosa**: un cambio en el módulo A rompe el módulo B sin que nadie lo detecte hasta que llega a producción. JUnit convierte ese escenario en un fallo inmediato y localizado en el pipeline de CI/CD, antes de que el código llegue a ningún servidor.

> 💡 **Analogía:** Imagina que fabricas coches. Antes de ensamblar el vehículo final, cada pieza individual (motor, frenos, dirección) pasa por un banco de pruebas específico. JUnit es ese banco de pruebas para cada "pieza" de tu software. Si los frenos fallan en el banco, no llegan al coche. Si un método falla en JUnit, no llega a producción.

## Tipos de pruebas que cubre

| Tipo | Descripción | Herramienta complementaria |
|---|---|---|
| **Unitaria** | Prueba una sola clase/método en aislamiento | JUnit 5 + Mockito |
| **Integración** | Prueba la interacción entre varios componentes | JUnit 5 + Spring Test |
| **Parametrizada** | Ejecuta el mismo test con múltiples conjuntos de datos | JUnit 5 nativo |

# 2. Arquitectura y Componentes

JUnit 5 no es un JAR monolítico. Está diseñado como una plataforma extensible compuesta por **3 subproyectos independientes**. Entender esta separación es clave para configurar correctamente tu proyecto.

```
┌─────────────────────────────────────────────────────────┐
│                    Tu IDE / Maven / Gradle               │
└───────────────────────────┬─────────────────────────────┘
                            │ usa
┌───────────────────────────▼─────────────────────────────┐
│                    JUnit PLATFORM                        │
│  (Descubre y lanza tests. Define la API TestEngine)      │
└────────────┬──────────────────────────┬─────────────────┘
             │ implementa               │ implementa
┌────────────▼───────────┐  ┌──────────▼──────────────────┐
│    JUnit JUPITER        │  │     JUnit VINTAGE            │
│  (JUnit 5: el que usas) │  │  (Compatibilidad JUnit 3/4) │
└─────────────────────────┘  └─────────────────────────────┘
```

## JUnit Platform

La **capa de infraestructura**. No escribes código aquí; es el motor que permite a IntelliJ, Eclipse, Maven y Gradle descubrir y ejecutar tus tests. Define la interfaz `TestEngine` que cualquier framework de testing puede implementar para integrarse.

## JUnit Jupiter

El subproyecto con el que trabajas a diario. Contiene:
- El **modelo de programación** (todas las anotaciones: `@Test`, `@BeforeEach`, etc.)
- El **modelo de extensiones** (para crear comportamiento personalizado con `@ExtendWith`)
- Su propio `TestEngine` que registra automáticamente en la Platform

## JUnit Vintage

Un puente de retrocompatibilidad. Si tu proyecto tiene tests escritos con JUnit 3 o JUnit 4, este engine los ejecuta dentro de la nueva plataforma sin reescribirlos.

## Dependencias Maven (configuración mínima production-ready)

```xml
<dependencies>
    <!-- Motor principal de JUnit 5 -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.10.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <plugin>
            <!-- CRÍTICO: Sin esta configuración, Maven no ejecuta tests de JUnit 5 -->
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.2.5</version>
        </plugin>
    </plugins>
</build>
```

> ⚠️ **Error frecuente en proyectos nuevos:** Añadir `junit-jupiter` pero olvidar actualizar `maven-surefire-plugin`. La versión por defecto de Surefire no detecta JUnit 5 y tus tests simplemente no se ejecutan (sin error, sin aviso). Siempre declara la versión explícitamente.

# 3. Implementación Paso a Paso

## Estructura básica de una clase de test

```java
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

// Convención: el nombre de la clase de test = ClaseAProbar + "Test"
class CalculadoraTest {

    private Calculadora calculadora;

    @BeforeEach
    void setUp() {
        // Se ejecuta ANTES de cada @Test → garantiza estado limpio
        calculadora = new Calculadora();
    }

    @Test
    @DisplayName("Debe sumar dos números positivos correctamente")
    void sumarDosPositivos() {
        // Patrón AAA: Arrange → Act → Assert
        int resultado = calculadora.sumar(2, 3); // Act
        assertEquals(5, resultado);              // Assert
    }

    @AfterEach
    void tearDown() {
        // Se ejecuta DESPUÉS de cada @Test → limpieza de recursos (BD, ficheros, etc.)
        calculadora = null;
    }
}
```

## Anotaciones del ciclo de vida

| Anotación | Cuándo se ejecuta | Caso de uso típico |
|---|---|---|
| `@BeforeAll` | Una vez, antes de todos los tests | Inicializar conexión a BD de pruebas |
| `@BeforeEach` | Antes de cada `@Test` | Resetear el estado del objeto bajo prueba |
| `@AfterEach` | Después de cada `@Test` | Liberar recursos por test |
| `@AfterAll` | Una vez, después de todos los tests | Cerrar conexión a BD de pruebas |
| `@Test` | Marca un método como caso de prueba | — |
| `@Disabled("motivo")` | — | Deshabilitar un test temporalmente con justificación |

> 💡 **Regla de oro:** `@BeforeAll` y `@AfterAll` deben ser `static` por defecto (ciclo de vida `PER_METHOD`). Si necesitas que sean de instancia, usa `@TestInstance(Lifecycle.PER_CLASS)` (ver sección de ciclo de vida).

```java
@BeforeAll
static void inicializarRecursosGlobales() {
    // static porque JUnit crea una nueva instancia por cada @Test (PER_METHOD)
    System.out.println("Configuración global una sola vez");
}
```

## Asserts y Grupo de Assertions

Las aserciones son el núcleo de cualquier test: verifican que el resultado real coincide con el esperado. Un fallo en una aserción detiene el test inmediatamente.

```java
@Test
void demostracionDeAsserts() {
    // assertEquals: compara valor esperado vs real
    // Para primitivos usa ==, para objetos usa .equals()
    assertEquals(10, calculadora.sumar(4, 6));

    // Delta para comparación de decimales (evita problemas de precisión flotante)
    assertEquals(0.3, 0.1 + 0.2, 0.0001); // sin delta, este test fallaría

    // assertSame / assertNotSame: compara referencia de objeto (como ==)
    String a = "hola";
    String b = a;
    assertSame(a, b); // mismo objeto en memoria

    // assertTrue / assertFalse
    assertTrue(calculadora.esPar(4));
    assertFalse(calculadora.esPar(3));

    // assertNull / assertNotNull
    assertNull(calculadora.buscar(-1));
    assertNotNull(calculadora.buscar(1));

    // assertThrows: verifica que se lanza la excepción correcta
    assertThrows(
        ArithmeticException.class,
        () -> calculadora.dividir(10, 0),
        "Debe lanzar ArithmeticException al dividir entre cero"
    );
}
```

### Grupo de Assertions con `assertAll`

El problema de las aserciones individuales: si la primera falla, las siguientes no se ejecutan, ocultando errores adicionales. `assertAll` ejecuta **todas** las aserciones y reporta todos los fallos de una vez.

```java
@Test
@DisplayName("Validar todos los campos del objeto Usuario")
void validarUsuario() {
    Usuario usuario = servicio.crearUsuario("Ana", "ana@empresa.com", 30);

    // Si assertEquals(nombre) falla, las otras dos igualmente se ejecutan
    assertAll("Validación completa del Usuario",
        () -> assertEquals("Ana", usuario.getNombre()),
        () -> assertEquals("ana@empresa.com", usuario.getEmail()),
        () -> assertEquals(30, usuario.getEdad())
    );
}
```

> 💡 **Cuándo usar `assertAll`:** Siempre que estés validando múltiples campos de un objeto o múltiples condiciones de un resultado. Ahorra ciclos de depuración al mostrar todos los fallos en una sola ejecución.

## Organización: Nested, Tags y Display Names

### `@Nested` — Agrupar tests relacionados

```java
@DisplayName("Tests de la Calculadora")
class CalculadoraTest {

    @Nested
    @DisplayName("Operaciones de suma")
    class SumaTest {

        @Test
        @DisplayName("Suma de positivos")
        void sumaPositivos() { assertEquals(5, calc.sumar(2, 3)); }

        @Test
        @DisplayName("Suma con negativos")
        void sumaNegativos() { assertEquals(-1, calc.sumar(2, -3)); }
    }

    @Nested
    @DisplayName("Operaciones de división")
    class DivisionTest {

        @Test
        @DisplayName("División exacta")
        void divisionExacta() { assertEquals(5, calc.dividir(10, 2)); }
    }
}
```

### `@Tag` — Clasificar y filtrar tests en el pipeline

```java
@Test
@Tag("rapido")     // se ejecuta en cada commit
void testUnitarioRapido() { /* ... */ }

@Test
@Tag("lento")      // se ejecuta solo en el pipeline nocturno
@Tag("integracion")
void testConBaseDeDatos() { /* ... */ }
```

Configuración en Maven para ejecutar solo un tag específico:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <!-- Ejecuta solo tests marcados como "rapido" -->
        <groups>rapido</groups>
        <!-- Excluye tests marcados como "lento" -->
        <excludedGroups>lento</excludedGroups>
    </configuration>
</plugin>
```

## Tests Parametrizados

La parametrización elimina el copy-paste de tests que difieren solo en los datos de entrada. Requiere la dependencia `junit-jupiter-params` (incluida en `junit-jupiter`).

### `@ValueSource` — Lista simple de valores

```java
@ParameterizedTest(name = "[{index}] El valor \"{0}\" debe ser blank")
@ValueSource(strings = {"", "  ", "\t", "\n"})
void stringsBlancos(String valor) {
    assertTrue(StringUtils.isBlank(valor));
}
```

### `@EnumSource` — Filtrar valores de un enum

```java
enum Rol { ADMIN, EDITOR, VIEWER, GUEST }

@ParameterizedTest
@EnumSource(value = Rol.class, names = {"ADMIN", "EDITOR"})
void rolesConPermisoDeEscritura(Rol rol) {
    assertTrue(permisos.puedeEscribir(rol));
}

@ParameterizedTest
@EnumSource(value = Rol.class, names = {"VIEWER", "GUEST"}, mode = EnumSource.Mode.INCLUDE)
void rolesSinPermisoDeEscritura(Rol rol) {
    assertFalse(permisos.puedeEscribir(rol));
}
```

### `@MethodSource` — Casos de prueba complejos con múltiples argumentos

```java
@ParameterizedTest(name = "[{index}] {0} + {1} = {2}")
@MethodSource("proveedorDatos")
void sumaParametrizada(int a, int b, int resultadoEsperado) {
    assertEquals(resultadoEsperado, calculadora.sumar(a, b));
}

// El método proveedor DEBE ser static y devolver Stream<Arguments>
private static Stream<Arguments> proveedorDatos() {
    return Stream.of(
        Arguments.of(2,   3,   5),
        Arguments.of(-2, -3,  -5),
        Arguments.of(0,   0,   0),
        Arguments.of(Integer.MAX_VALUE, 0, Integer.MAX_VALUE)
    );
}
```

### `@CsvSource` y `@CsvFileSource` — Datos tabulares

```java
// Datos inline con @CsvSource
@ParameterizedTest(name = "Precio de {0} = {1}€")
@CsvSource({
    "Laptop,  1200",
    "Ratón,     25",
    "Monitor,  350"
})
void preciosProductos(String nombre, int precio) {
    assertEquals(precio, catalogo.getPrecio(nombre));
}

// Datos desde fichero externo con @CsvFileSource
@ParameterizedTest
@CsvFileSource(resources = "/datos/productos.csv", numLinesToSkip = 1) // salta la cabecera
void preciosDesdefichero(String nombre, int precio) {
    assertEquals(precio, catalogo.getPrecio(nombre));
}
```

## Control de Tiempo de Ejecución

JUnit 5 ofrece dos mecanismos con comportamientos distintos. Es importante entender la diferencia antes de elegir cuál usar.

### `@Timeout` — Interrumpir un test "colgado" (comportamiento agresivo)

Termina el hilo del test si supera el tiempo límite. Útil para detectar deadlocks o llamadas bloqueantes que nunca devuelven.

```java
@Test
@Timeout(5) // unidad por defecto: segundos
void testQueNoPuedeTardarMasDe5Segundos() {
    servicio.operacionPotencialmenteBloquante();
}

@Test
@Timeout(value = 200, unit = TimeUnit.MILLISECONDS)
void testDeRendimiento() {
    algoritmo.ordenar(dataset);
}
```

### `assertTimeout` — Verificar el tiempo de un bloque específico (comportamiento suave)

No interrumpe el test; lo deja terminar y luego informa si superó el límite. Útil para medir rendimiento sin matar el proceso.

```java
@Test
void verificarRendimientoDeBusqueda() {
    assertTimeout(Duration.ofMillis(100), () -> {
        // Este bloque DEBE completarse en menos de 100ms
        List<Producto> resultado = repositorio.buscarPorCategoria("electronica");
        assertFalse(resultado.isEmpty());
    });
}
```

> ⚠️ **Diferencia clave:** `@Timeout` **interrumpe** el hilo si se supera el límite. `assertTimeout` **espera** a que termine y luego falla si tardó demasiado. Para tests de integración con recursos externos, `assertTimeout` es más seguro para evitar corrupción de estado.

## Ciclo de Vida de la Instancia

Define **cuándo** JUnit crea la instancia de tu clase de test. Tiene implicaciones directas sobre el aislamiento entre pruebas y el uso de `@BeforeAll`/`@AfterAll`.

### `PER_METHOD` (comportamiento por defecto)

JUnit crea una **nueva instancia** de la clase por cada método `@Test`. Garantiza aislamiento total entre pruebas, pero `@BeforeAll` y `@AfterAll` **deben ser `static`**.

```java
// Sin @TestInstance → comportamiento PER_METHOD por defecto
class CalculadoraTest {

    @BeforeAll
    static void configuracionGlobal() { /* debe ser static */ }

    @Test
    void test1() { /* instancia nueva */ }

    @Test
    void test2() { /* otra instancia nueva, independiente de test1 */ }
}
```

### `PER_CLASS` — Una instancia para todos los tests

Útil cuando la inicialización es costosa (levantar un servidor embebido, conectar a una BD) y quieres hacerla una sola vez. `@BeforeAll` puede ser un método de instancia (no `static`).

```java
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class IntegracionRepositorioTest {

    private DataSource dataSource;

    @BeforeAll
    void inicializarBaseDeDatos() {
        // No necesita ser static. Solo se ejecuta una vez para todos los tests.
        dataSource = TestDataSourceFactory.crear();
    }

    @AfterAll
    void cerrarConexion() {
        dataSource.close();
    }

    @BeforeEach
    void limpiarDatos() {
        // Limpia los datos entre tests para mantener el aislamiento
        TestDataSourceFactory.limpiar(dataSource);
    }
}
```

> 💡 **Regla práctica:** Usa `PER_CLASS` solo para tests de integración donde la inicialización es cara. Para tests unitarios, mantén el `PER_METHOD` por defecto; el aislamiento entre tests es más importante que los milisegundos de instanciación.

## Condiciones de Ejecución por Entorno

JUnit 5 permite activar o desactivar tests según el entorno de ejecución. Imprescindible en proyectos que se ejecutan en múltiples sistemas operativos o versiones de Java.

```java
class TestsCondicionales {

    // Por sistema operativo
    @Test
    @EnabledOnOs(OS.LINUX)
    void soloEnLinux() { /* Solo se ejecuta en servidores Linux */ }

    @Test
    @DisabledOnOs({OS.WINDOWS, OS.MAC})
    void deshabilitadoEnWindowsYMac() { /* ... */ }

    // Por versión de JRE
    @Test
    @EnabledOnJre(JRE.JAVA_17)
    void usaFeaturesDeJava17() { /* Records, sealed classes, etc. */ }

    @Test
    @DisabledOnJre(JRE.JAVA_8)
    void requiereJava11oSuperior() { /* ... */ }

    // Por propiedad del sistema
    @Test
    @EnabledIfSystemProperty(named = "env", matches = "ci")
    void soloEnPipelineDeCI() { /* ... */ }

    // Por variable de entorno
    @Test
    @EnabledIfEnvironmentVariable(named = "DATABASE_URL", matches = ".*staging.*")
    void soloContraBaseDeDatosDeStaging() { /* ... */ }
}
```

## Inyección de Dependencias: TestInfo y TestReporter

JUnit 5 puede inyectar automáticamente información del test en ejecución como parámetro del método.

```java
@Test
@Tag("auditoria")
@DisplayName("Test de creación de usuario")
void testConInfoContextual(TestInfo testInfo) {
    // TestInfo expone metadatos del test en ejecución
    System.out.println("Ejecutando: " + testInfo.getDisplayName());
    System.out.println("Tags:       " + testInfo.getTags());
    System.out.println("Método:     " + testInfo.getTestMethod().map(Method::getName).orElse("N/A"));

    // Tu lógica de prueba aquí
    assertNotNull(servicio.crearUsuario("test@mail.com"));
}

@Test
void testConReporteEnriquecido(TestReporter testReporter) {
    // TestReporter añade entradas al log de JUnit con timestamp
    // Visible en reportes de Maven Surefire y herramientas de CI
    testReporter.publishEntry("ambiente", System.getProperty("env", "local"));
    testReporter.publishEntry("timestamp_inicio", Instant.now().toString());

    Pedido pedido = servicio.procesarPedido(123L);

    testReporter.publishEntry("pedido_id", pedido.getId().toString());
    assertEquals(EstadoPedido.PROCESADO, pedido.getEstado());
}
```

> 💡 **`TestInfo` vs `TestReporter`:** `TestInfo` es de **lectura** (quién soy, qué tags tengo). `TestReporter` es de **escritura** (emite entradas al log con timestamp). Úsalos juntos para trazabilidad en pipelines de CI complejos.

## TDD: Test-Driven Development

TDD no es una feature de JUnit; es una **disciplina de diseño** que usa JUnit como herramienta. El ciclo es: **Red → Green → Refactor**.

```
┌─────────────────────────────────────────────────────────┐
│                    CICLO TDD                            │
│                                                         │
│   1. RED     → Escribe el test. Ejecútalo. DEBE fallar. │
│   2. GREEN   → Escribe el mínimo código para que pase.  │
│   3. REFACTOR→ Mejora el código sin romper los tests.   │
│                                                         │
│   Repite para cada criterio de aceptación.              │
└─────────────────────────────────────────────────────────┘
```

### Ejemplo práctico: Calculadora de descuentos

**Paso 1 — RED: el test existe pero el código no**

```java
@Test
@DisplayName("Cliente VIP obtiene 20% de descuento")
void clienteVipObtiene20PorCientoDescuento() {
    // Este test FALLA porque DescuentoService no existe todavía
    DescuentoService service = new DescuentoService();
    double precioFinal = service.aplicar(100.0, TipoCliente.VIP);
    assertEquals(80.0, precioFinal);
}
```

**Paso 2 — GREEN: implementación mínima para pasar el test**

```java
public class DescuentoService {
    public double aplicar(double precio, TipoCliente tipo) {
        if (tipo == TipoCliente.VIP) {
            return precio * 0.80;
        }
        return precio;
    }
}
```

**Paso 3 — REFACTOR: mejorar sin romper**

```java
public class DescuentoService {

    private static final Map<TipoCliente, Double> DESCUENTOS = Map.of(
        TipoCliente.VIP,      0.20,
        TipoCliente.PREMIUM,  0.10,
        TipoCliente.ESTANDAR, 0.0
    );

    public double aplicar(double precio, TipoCliente tipo) {
        double descuento = DESCUENTOS.getOrDefault(tipo, 0.0);
        return precio * (1 - descuento);
    }
}
// Los tests siguen en verde. El código es más limpio y extensible.
```

### Flujo TDD en un equipo ágil

1. El cliente escribe la **historia de usuario**
2. El equipo define los **criterios de aceptación** junto al cliente
3. Se selecciona un criterio → se escribe el test (RED)
4. Se implementa el mínimo código para pasarlo (GREEN)
5. Se refactoriza (REFACTOR)
6. Se ejecuta **toda** la suite de tests para verificar no hay regresión
7. Se vuelve al paso 3 con el siguiente criterio

### Limitaciones reales de TDD (sin suavizarlas)

- **Interfaces gráficas:** Difíciles de testear en TDD puro. Solución: separar lógica de presentación (patrón MVP/MVVM) y testear solo la lógica.
- **Bases de datos:** Los tests no pueden depender de datos reales variables. Solución: usar objetos `Mock` con Mockito o bases de datos en memoria como H2.
- **Curva de aprendizaje:** TDD mal aplicado produce tests frágiles que se rompen con cada refactorización. La clave es testear **comportamiento**, no **implementación interna**.


# 4. Errores Comunes y Buenas Prácticas

## Errores frecuentes en producción

**1. Tests que dependen del orden de ejecución**

```java
// ❌ MAL: Este test asume que test1() se ejecutó antes
static int contador = 0;

@Test
void test1() { contador++; }

@Test
void test2() { assertEquals(1, contador); } // Falla si JUnit los reordena
```

```java
// ✅ BIEN: Cada test inicializa su propio estado
@BeforeEach
void setUp() { contador = 0; }

@Test
void test2() {
    contador++;
    assertEquals(1, contador);
}
```

**2. Verificar implementación interna en vez de comportamiento**

```java
// ❌ MAL: Verifica cómo se hace, no qué resultado produce
@Test
void testInterno() {
    servicio.procesar(pedido);
    verify(repositorio, times(1)).save(any()); // frágil ante refactorizaciones
}
```

```java
// ✅ BIEN: Verifica el resultado observable del sistema
@Test
void testComportamiento() {
    Pedido resultado = servicio.procesar(pedido);
    assertEquals(EstadoPedido.CONFIRMADO, resultado.getEstado());
}
```

**3. Tests lentos que ralentizan el pipeline**

```java
// ❌ MAL: Llama a una API externa en un test unitario
@Test
void testConApiExterna() {
    // 2-5 segundos de latencia, falla si la red está caída
    Respuesta r = clienteHttp.llamar("https://api.externa.com/datos");
    assertNotNull(r);
}
```

```java
// ✅ BIEN: Mockear dependencias externas
@Test
void testConMock() {
    when(clienteHttp.llamar(anyString()))
        .thenReturn(new Respuesta("datos_simulados"));

    Respuesta r = servicio.obtenerDatos();
    assertNotNull(r); // Milisegundos, sin red
}
```

**4. Nombres de tests que no explican el fallo**

```java
// ❌ MAL: ¿Qué significa esto cuando falla en CI a las 3am?
@Test
void test1() { }

@Test
void testUsuario() { }
```

```java
// ✅ BIEN: El nombre es el contrato. Léelo como una oración.
@Test
@DisplayName("Debe lanzar IllegalArgumentException cuando el email está vacío")
void debeRechazarEmailVacio() { }

@Test
@DisplayName("Usuario con rol ADMIN puede acceder a /admin/panel")
void adminPuedeAccederAlPanel() { }
```

## Checklist de buenas prácticas

- **Un assert por test** como regla general (o `assertAll` cuando valides un objeto completo)
- **Nombra tus tests** como oraciones: `debeRetornarNullCuandoProductoNoExiste()`
- **Patrón AAA** siempre: Arrange (prepara datos) → Act (ejecuta) → Assert (verifica)
- **Tests independientes:** ningún test debe crear datos que otro test necesite
- **Usa `@Tag`** para separar tests unitarios (rápidos) de integración (lentos) en tu pipeline
- **Mockea dependencias externas** (BD, APIs, sistema de ficheros) en tests unitarios
- **Tests cortos:** si un test supera las 20 líneas, es señal de que el método bajo prueba hace demasiado
- **Datos legibles:** usa constantes con nombres descriptivos en lugar de literales mágicos

```java
// ❌ MAL
assertEquals(3, resultado.size());

// ✅ BIEN
final int NUMERO_ESPERADO_DE_PRODUCTOS_ACTIVOS = 3;
assertEquals(NUMERO_ESPERADO_DE_PRODUCTOS_ACTIVOS, resultado.size());
```