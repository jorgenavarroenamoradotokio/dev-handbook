> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Que es mockito](#1-que-es-mockito)
- [2. Arquitectura y Componentes](#2-arquitectura-y-componentes)
  - [Dependencias necesarias](#dependencias-necesarias)
  - [Conceptos clave](#conceptos-clave)
  - [Características y Limitaciones](#características-y-limitaciones)
- [3. Implementación Paso a Paso](#3-implementación-paso-a-paso)
  - [Inyección de Mocks (Anotaciones)](#inyección-de-mocks-anotaciones)
    - [Activación de Anotaciones (JUnit 5)](#activación-de-anotaciones-junit-5)
    - [Anotaciones esenciales](#anotaciones-esenciales)
    - [Ejemplo básico](#ejemplo-básico)
  - [Simulación de Valor de Retorno](#simulación-de-valor-de-retorno)
  - [Simulación de Excepciones](#simulación-de-excepciones)
  - [Verificación y Captura de Argumentos](#verificación-y-captura-de-argumentos)
    - [Verificación de llamadas (`verify`)](#verificación-de-llamadas-verify)
    - [Argument Matchers](#argument-matchers)
    - [Captura de argumentos (`ArgumentCaptor`)](#captura-de-argumentos-argumentcaptor)
  - [Spy](#spy)
  - [Comportamiento Personalizado (Answer)](#comportamiento-personalizado-answer)
  - [Mocking de Métodos Estáticos y Finales](#mocking-de-métodos-estáticos-y-finales)
  - [Manejo de Métodos Privados](#manejo-de-métodos-privados)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  - [Errores que rompen builds y dan falsos negativos](#errores-que-rompen-builds-y-dan-falsos-negativos)
  - [Buenas prácticas recomendadas](#buenas-prácticas-recomendadas)

---

# 1. Que es mockito

**Qué es:** Mockito es el framework de mocking más usado en el ecosistema Java. Crea objetos simulados ("dobles de prueba") que sustituyen a las dependencias reales de una clase, permitiéndote controlar exactamente qué devuelven o cómo se comportan durante un test.

**Por qué importa:** Sin mocking, probar una clase de servicio implica arrastrar su base de datos, su API externa o su sistema de ficheros real. Eso convierte tus tests unitarios en tests de integración lentos, frágiles y dependientes de factores que no controlas (red caída, datos cambiantes, límites de rate). Mockito rompe esa dependencia: aísla la unidad bajo prueba para que falle (o pase) **solo** por su propia lógica.

**Analogía:** Piensa en probar el airbag de un coche. No estrellas un coche real cada vez que quieres validar el sistema — usas un maniquí de pruebas (*crash dummy*) con sensores que simulan exactamente la fuerza del impacto que quieres medir. El mock es ese maniquí: no es el componente real, pero reacciona de forma controlada y medible para que puedas validar la lógica que sí te interesa (el airbag, en este caso tu clase de servicio).

# 2. Arquitectura y Componentes

## Dependencias necesarias

> ⚠️ **Corrección importante sobre versiones**: desde **Mockito 5.0.0**, el *mockmaker* `mockito-inline` pasó a ser el predeterminado **dentro de `mockito-core`**. Ya no necesitas declararlo como dependencia separada para mockear `static`, `final` o constructores — viene incluido. Declararlo de forma explícita es redundante y, en builds recientes, puede generar conflictos de versión.

```xml
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>5.14.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-junit-jupiter</artifactId>
    <version>5.14.2</version>
    <scope>test</scope>
</dependency>
```

**¿Cuándo SÍ necesitas `mockito-inline` explícita?** Solo si estás en una versión `4.x` o anterior y quieres el comportamiento inline sin migrar a Mockito 5. Si tu proyecto es nuevo, ignora ese artefacto por completo.

## Conceptos clave

| Concepto     | Descripción                                                                  |
| ------------ | ---------------------------------------------------------------------------- |
| **Mock**     | Objeto simulado totalmente controlado por Mockito. No ejecuta lógica real.   |
| **Spy**      | Envuelve un objeto real; ejecuta los métodos reales salvo los que se mockeen explícitamente. |
| **Stubbing** | Definir qué debe devolver un mock ante una llamada concreta.                |
| **Verify**   | Confirmar si un método fue invocado y cuántas veces.                        |
| **Captor**   | Capturar el valor exacto de un argumento pasado a un mock, para inspeccionarlo. |
| **Answer**   | Lógica de simulación dinámica basada en los parámetros recibidos en tiempo de ejecución. |

## Características y Limitaciones

- **Métodos mockeables**: solo métodos públicos o `default`. Mockito trabaja generando subclases/proxies dinámicos en tiempo de ejecución; no puede interceptar lo que no puede sobreescribir o interceptar a nivel de bytecode sin el mockmaker inline.
- **Creación manual de mocks**:
  - Sintaxis completa: `MiClase mock = Mockito.mock(MiClase.class);`
  - Sintaxis abreviada (con `import static org.mockito.Mockito.*`): `MiClase mock = mock(MiClase.class);`
- **Métodos privados**: Mockito no los simula directamente, por diseño. La unidad bajo prueba debe testearse a través de su contrato público. La solución estándar es **refactorizar** (extraer la lógica a un colaborador inyectable o relajar la visibilidad a `protected`/`default`). **PowerMock** es un último recurso para código legado — sin mantenimiento activo y con fuerte fricción frente a JUnit 5/Mockito moderno. No lo introduzcas en proyectos nuevos.
- **Métodos estáticos y finales**: soportados de forma nativa desde Mockito 5.x (sin dependencia adicional).

# 3. Implementación Paso a Paso

## Inyección de Mocks (Anotaciones)

### Activación de Anotaciones (JUnit 5)

```java
@ExtendWith(MockitoExtension.class)
class MiTest { }
```

> Sin esta extensión, las anotaciones `@Mock`, `@Spy`, `@InjectMocks` y `@Captor` quedan sin inicializar y obtienes `NullPointerException` en tiempo de ejecución, no un error claro de Mockito. Es el fallo número uno de quien empieza con Mockito + JUnit 5.

### Anotaciones esenciales

| Anotación        | Propósito                                                                  |
| ---------------- | -------------------------------------------------------------------------- |
| **@Mock**        | Crea un objeto simulado. Equivale a `Mockito.mock()`. |
| **@Spy**         | Crea un espía de un objeto real; llama a los métodos reales por defecto. |
| **@InjectMocks** | Instancia la clase bajo prueba e inyecta automáticamente los `@Mock`/`@Spy` necesarios. La clase debe ser una implementación concreta, **no una interfaz**. |
| **@Captor**      | Crea una instancia de `ArgumentCaptor` para capturar argumentos pasados a un mock. |

### Ejemplo básico

```java
@ExtendWith(MockitoExtension.class)
class AddServiceTest {

    @InjectMocks
    private Add addService; // Clase bajo prueba (real)

    @Mock
    private ValidNumber validNumberMock; // Dependencia (simulada)

    @Test
    void addTest() {
        // Arrange: el mock ya está inyectado por la extensión.
        // Act: usamos el servicio real, que internamente usa el mock.
        addService.add(3, 2);

        // Assert: verificamos que el mock fue invocado con el argumento esperado.
        Mockito.verify(validNumberMock).check(3);
    }
}
```

## Simulación de Valor de Retorno

```java
@Test
void addCalculadoraTest() {
    // Arrange: cuando se llame a sumar(2, 3), el mock devolverá 5.
    when(calculadoraMock.sumar(2, 3)).thenReturn(5);

    // Act + Assert
    assertEquals(5, calculadoraMock.sumar(2, 3));
}
```

## Simulación de Excepciones

```java
@Test
void addMockExceptionTest() {
    // Arrange: checkZero(0) lanzará una ArithmeticException.
    when(validNumberMock.checkZero(0)).thenThrow(new ArithmeticException("msg"));

    // Act + Assert
    assertThrows(ArithmeticException.class, () -> {
        validNumberMock.checkZero(0);
    });
}
```

## Verificación y Captura de Argumentos

### Verificación de llamadas (`verify`)

| Concepto | Descripción | Sintaxis |
|----------|-------------|----------|
| **Llamada simple** | Fue llamado exactamente una vez. | `verify(mock).metodo(args);` |
| **Número específico** | Fue llamado *n* veces. | `verify(mock, times(2)).metodo(args);` |
| **Nunca llamado** | No fue llamado nunca. | `verify(mock, never()).metodo(args);` |
| **Al menos *n* veces** | Llamado *n* veces o más. | `verify(mock, atLeast(2)).metodo(args);` |
| **Al menos una vez** | Llamado una vez o más. | `verify(mock, atLeastOnce()).metodo(args);` |
| **Como máximo *n* veces** | Llamado *n* veces o menos. | `verify(mock, atMost(4)).metodo(args);` |
| **Sin interacciones** | Ningún método fue invocado en los mocks dados. | `verifyNoInteractions(mock1, mock2);` |

### Argument Matchers

Permiten validar llamadas sin fijar valores exactos. Útiles cuando el valor concreto del argumento es irrelevante para el test o se genera dinámicamente.

- **Comodines comunes**: `anyInt()`, `anyString()`, `any(Clase.class)`, `eq(valor)` (para mezclar un valor exacto con un matcher en la misma llamada).

```java
@Test
void argumentMatcherTest() {
    // Arrange: devuelve TRUE si se llama con cualquier entero.
    when(validNumberMock.check(anyInt())).thenReturn(true);

    // Act + Assert
    assertTrue(validNumberMock.check(4));
    assertTrue(validNumberMock.check(100));

    verify(validNumberMock).check(anyInt());
}
```

> ⚠️ **Regla de oro**: si usas un matcher (`any()`, `eq()`, etc.) en uno de los argumentos de una llamada con varios parámetros, **todos** los demás argumentos de esa llamada deben usar matchers también. No se pueden mezclar valores literales con matchers en la misma invocación (excepto a través de `eq()`).

### Captura de argumentos (`ArgumentCaptor`)

Útil cuando necesitas inspeccionar el valor exacto que la clase bajo prueba generó internamente y pasó al mock.

```java
@Test
void testProcesarGuardaDatoProcesado(@Captor ArgumentCaptor<String> captor) {
    // Arrange
    servicio.procesar("dato");

    // Act: verificamos la llamada y capturamos el argumento real recibido.
    verify(repositorioMock).guardar(captor.capture());

    // Assert: inspeccionamos el valor capturado.
    String valorCapturado = captor.getValue();
    assertEquals("dato_procesado", valorCapturado);
}
```

## Spy

Un **Spy** envuelve una instancia real: por defecto ejecuta los métodos reales, salvo aquellos que mockees explícitamente.

- **Uso ideal**: cuando solo necesitas alterar el comportamiento de algunos métodos de una clase real, manteniendo el resto intacto.
- **Restricción**: solo aplicable a clases no-finales.

```java
@Spy
private Calculadora calculadoraSpy = new Calculadora(); // Instancia real

@Test
void spyTest() {
    // Recomendado: doReturn() evita ejecutar el método real antes de stubarlo.
    doReturn(100).when(calculadoraSpy).sumar(10, 5);

    assertEquals(100, calculadoraSpy.sumar(10, 5)); // Simulado
    assertEquals(5, calculadoraSpy.restar(10, 5));  // Real (no stubeado)
}
```

> **Por qué `doReturn()` y no `when()` en un Spy**: `when(spy.metodo())` ejecuta primero el método real para poder interceptarlo después, porque Mockito necesita invocar la llamada real como parte del mecanismo de matching antes de sobreescribir el resultado. Si ese método real tiene efectos secundarios (escribe en BD, lanza una excepción, hace una llamada de red), los disparas sin querer durante el propio `arrange` del test. `doReturn()` evita esa ejecución por completo.

## Comportamiento Personalizado (Answer)

Útil cuando el resultado simulado depende de los parámetros recibidos o requiere lógica más compleja que un simple `thenReturn`.

```java
@Test
void addDoubleToIntTest() {
    when(validNumberMock.dobleToInt(anyDouble()))
        .thenAnswer(invocation -> {
            double valor = invocation.getArgument(0);
            return (int) Math.floor(valor);
        });

    assertEquals(7, validNumberMock.dobleToInt(7.7));
    assertEquals(5, validNumberMock.dobleToInt(5.9));
}
```

## Mocking de Métodos Estáticos y Finales

Desde Mockito 5.x, esta capacidad **viene incluida en `mockito-core`** (ver corrección en la sección 2). Se accede mediante `Mockito.mockStatic()`.

```java
@Test
void mockStaticMethodTest() {
    // try-with-resources es obligatorio: limita el scope del mock estático
    // y lo desactiva automáticamente al salir del bloque.
    try (MockedStatic<UtilidadesEstaticas> mockedStatic = Mockito.mockStatic(UtilidadesEstaticas.class)) {

        mockedStatic.when(UtilidadesEstaticas::obtenerFechaActual).thenReturn("2025-01-01");

        assertEquals("2025-01-01", UtilidadesEstaticas.obtenerFechaActual());
    }
    // Fuera del bloque, el método estático vuelve a su comportamiento real.
}
```

> 🚨 **Riesgo real de producción**: si no usas `try-with-resources` (o no cierras manualmente el `MockedStatic`), el mock estático **se queda activo para otros tests** que se ejecuten en el mismo hilo, contaminando resultados de forma intermitente y muy difícil de depurar. Es uno de los bugs de test-suite más silenciosos que existen.

## Manejo de Métodos Privados

Mockito no soporta mockear métodos privados, por diseño: el test debe validar el comportamiento público observable, no la implementación interna.

- **Opción recomendada (refactorización)**:
  - Extraer la lógica privada a una clase colaboradora inyectable.
  - Relajar la visibilidad (a `protected` o `default`) solo si es estrictamente necesario para testear, preservando encapsulamiento donde sea posible.
- **Solución de último recurso (PowerMock)**: permite mockear métodos privados, pero su uso está **fuertemente desaconsejado** en proyectos activos: añade complejidad, choca con las APIs modernas de Mockito/JUnit 5 y carece de mantenimiento activo. Solo se justifica en código legado que no puedes refactorizar a corto plazo.

# 4. Errores Comunes y Buenas Prácticas

## Errores que rompen builds y dan falsos negativos

| Error / Síntoma | Causa real | Solución |
|---|---|---|
| `NullPointerException` en un `@Mock` | Falta `@ExtendWith(MockitoExtension.class)` en la clase de test. | Añadir la extensión; sin ella, las anotaciones no se inicializan. |
| `UnnecessaryStubbingException` | Se define un `when(...).thenReturn(...)` que el test nunca llega a invocar (a menudo tras refactors). | Eliminar el stub no usado, o usar `lenient()` solo si es intencional y documentado. |
| `MissingMethodInvocationException` al usar `mockStatic` | Se intenta mockear un método que no es estático, o se usa fuera de un bloque válido. | Confirmar que el método referenciado es realmente `static` y que el `MockedStatic` está abierto en ese punto. |
| Spy ejecuta lógica real "por sorpresa" | Se usó `when(spy.metodo())` en vez de `doReturn().when(spy)`. | Sustituir siempre `when()` por `doReturn()` al stubar Spies. |
| Tests que pasan en local pero fallan en CI de forma intermitente | `MockedStatic` no cerrado correctamente (sin try-with-resources) contaminando otros tests del mismo hilo. | Siempre usar `try (MockedStatic<...> m = mockStatic(...)) { ... }`. |
| `InvalidUseOfMatchersException` | Se mezclan argumentos literales con matchers (`any()`, `eq()`) en la misma llamada sin envolver el resto en `eq()`. | Si usas un matcher, todos los argumentos de esa llamada deben ser matchers. |
| `@InjectMocks` no inyecta nada (campo queda real, no falla pero el test es incorrecto) | La clase bajo prueba usa inyección por interfaz/constructor que Mockito no puede resolver, o tiene múltiples constructores ambiguos. | Preferir un único constructor con las dependencias explícitas; revisar con `verbose` si la inyección fue correcta. |

## Buenas prácticas recomendadas

- **Mockea solo lo necesario**
  - No mockees objetos simples (POJOs, DTOs).
  - No mockees colecciones, `String` o tipos primitivos.
  - No mockees métodos que ya son deterministas y baratos de ejecutar.
- **Mockea solo las dependencias externas** de la clase bajo prueba.
  - La clase bajo prueba debe ser real, nunca mockeada.
  - Mockea repositorios, clientes de API, servicios externos.
  - No mockees tu propia lógica interna — si necesitas hacerlo, es una señal de que esa lógica debería extraerse a otro colaborador.
- Evita `any()` sin necesidad; prefiere valores concretos cuando el dato importa para el test.
- Usa `eq()` siempre que mezcles `ArgumentMatchers` con valores exactos en la misma llamada.
- Usa `doReturn()` en Spies, nunca `when()`.
- Evita el uso excesivo de `verify()`: verificar todas las llamadas vuelve el test frágil ante refactors triviales; verifica solo las interacciones que realmente importan al contrato.
- Mantén el patrón **AAA** (Arrange – Act – Assert) en cada test.
- Escribe pruebas independientes y deterministas:
  - No dependas del orden de ejecución.
  - Evita datos aleatorios sin semilla fija.
  - No dependas del tiempo real — usa `mockStatic` para `LocalDate.now()`, `Instant.now()`, etc.
- Usa nombres de test descriptivos (qué se prueba + condición + resultado esperado).
- Mantén los tests cortos, con una sola responsabilidad por test.