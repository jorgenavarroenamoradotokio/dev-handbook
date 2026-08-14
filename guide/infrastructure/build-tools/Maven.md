> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [Maven: Guía Completa de Arquitectura y Producción](#maven-guía-completa-de-arquitectura-y-producción)
  - [1. 🎯 El Gran Cuadro (The Big Picture)](#1--el-gran-cuadro-the-big-picture)
  - [2. 🧱 Arquitectura y Componentes (Para Profesionales)](#2--arquitectura-y-componentes-para-profesionales)
    - [Los cinco pilares de la arquitectura](#los-cinco-pilares-de-la-arquitectura)
    - [Ciclos de vida: hay tres, no uno](#ciclos-de-vida-hay-tres-no-uno)
      - [Ciclo `clean`](#ciclo-clean)
      - [Ciclo `default` (el que usas el 95% del tiempo)](#ciclo-default-el-que-usas-el-95-del-tiempo)
      - [Ciclo `site`](#ciclo-site)
    - [Personalización: plugins y bindings explícitos](#personalización-plugins-y-bindings-explícitos)
  - [3. 🛠️ Instalación (Hands-On)](#3-️-instalación-hands-on)
    - [Requisitos previos](#requisitos-previos)
    - [Instalación manual](#instalación-manual)
    - [Instalación mediante gestor de paquetes](#instalación-mediante-gestor-de-paquetes)
    - [Entornos Docker (reproducibilidad real)](#entornos-docker-reproducibilidad-real)
    - [Múltiples versiones de Maven en paralelo](#múltiples-versiones-de-maven-en-paralelo)
- [Bloque 2: El Archivo POM en Profundidad](#bloque-2-el-archivo-pom-en-profundidad)
  - [1. 🎯 El Gran Cuadro](#1--el-gran-cuadro)
  - [2. 🧱 Arquitectura y Componentes](#2--arquitectura-y-componentes)
    - [Anatomía mínima de un POM](#anatomía-mínima-de-un-pom)
    - [`parent` POM vs BOM: la confusión que casi todo el mundo tiene](#parent-pom-vs-bom-la-confusión-que-casi-todo-el-mundo-tiene)
    - [`dependencyManagement`: gobierna versiones sin forzar inclusión](#dependencymanagement-gobierna-versiones-sin-forzar-inclusión)
    - [Propiedades del POM](#propiedades-del-pom)
  - [3. 🛠️ Implementación Paso a Paso (Hands-On)](#3-️-implementación-paso-a-paso-hands-on)
  - [4. 🚨 Errores Comunes y Buenas Prácticas](#4--errores-comunes-y-buenas-prácticas)
- [Bloque 3: Gestión de Dependencias](#bloque-3-gestión-de-dependencias)
  - [1. 🎯 El Gran Cuadro](#1--el-gran-cuadro-1)
  - [2. 🧱 Arquitectura y Componentes](#2--arquitectura-y-componentes-1)
    - [El `scope`: cuándo y dónde vive cada dependencia](#el-scope-cuándo-y-dónde-vive-cada-dependencia)
    - [Dependencias transitivas: cómo Maven decide qué versión "gana"](#dependencias-transitivas-cómo-maven-decide-qué-versión-gana)
    - [Dependencias opcionales](#dependencias-opcionales)
    - [Exclusiones: cortando dependencias transitivas no deseadas](#exclusiones-cortando-dependencias-transitivas-no-deseadas)
  - [3. 🛠️ Implementación Paso a Paso (Hands-On)](#3-️-implementación-paso-a-paso-hands-on-1)
    - [Visualizar el árbol de dependencias](#visualizar-el-árbol-de-dependencias)
    - [Detectar dependencias mal declaradas](#detectar-dependencias-mal-declaradas)
    - [Versionado semántico (SemVer) aplicado a tu estrategia de dependencias](#versionado-semántico-semver-aplicado-a-tu-estrategia-de-dependencias)
  - [4. 🚨 Errores Comunes y Buenas Prácticas](#4--errores-comunes-y-buenas-prácticas-1)
- [Bloque 4: Plugins Esenciales y Avanzados](#bloque-4-plugins-esenciales-y-avanzados)
  - [1. 🎯 El Gran Cuadro](#1--el-gran-cuadro-2)
  - [2. 🧱 Arquitectura y Componentes](#2--arquitectura-y-componentes-2)
    - [Mapa de los plugins esenciales y su fase de binding](#mapa-de-los-plugins-esenciales-y-su-fase-de-binding)
    - [Surefire vs Failsafe: la distinción que el original simplificaba de menos](#surefire-vs-failsafe-la-distinción-que-el-original-simplificaba-de-menos)
  - [3. 🛠️ Implementación Paso a Paso (Hands-On)](#3-️-implementación-paso-a-paso-hands-on-2)
    - [`maven-compiler-plugin`: compilación con soporte para Lombok](#maven-compiler-plugin-compilación-con-soporte-para-lombok)
    - [`maven-surefire-plugin` y `maven-failsafe-plugin`: separación real de unitarios e integración](#maven-surefire-plugin-y-maven-failsafe-plugin-separación-real-de-unitarios-e-integración)
    - [`maven-resources-plugin`: filtrado de recursos con variables del POM](#maven-resources-plugin-filtrado-de-recursos-con-variables-del-pom)
    - [`maven-shade-plugin`: uber-jar ejecutable de forma autónoma](#maven-shade-plugin-uber-jar-ejecutable-de-forma-autónoma)
    - [`maven-dependency-plugin`: copiar dependencias a un directorio (sin crear uber-jar)](#maven-dependency-plugin-copiar-dependencias-a-un-directorio-sin-crear-uber-jar)
  - [4. 🚨 Errores Comunes y Buenas Prácticas](#4--errores-comunes-y-buenas-prácticas-2)
- [Bloque 5: Proyectos Multi-Módulo](#bloque-5-proyectos-multi-módulo)
  - [1. 🎯 El Gran Cuadro](#1--el-gran-cuadro-3)
  - [2. 🧱 Arquitectura y Componentes](#2--arquitectura-y-componentes-3)
    - [Anatomía de un proyecto multi-módulo](#anatomía-de-un-proyecto-multi-módulo)
    - [El Reactor: cómo Maven decide el orden de construcción](#el-reactor-cómo-maven-decide-el-orden-de-construcción)
  - [3. 🛠️ Implementación Paso a Paso (Hands-On)](#3-️-implementación-paso-a-paso-hands-on-3)
    - [Diseño: separación de responsabilidades por capa](#diseño-separación-de-responsabilidades-por-capa)
    - [Construir solo un módulo y sus dependencias (sin reconstruir todo)](#construir-solo-un-módulo-y-sus-dependencias-sin-reconstruir-todo)
    - [Empaquetado y despliegue: las dos estrategias reales](#empaquetado-y-despliegue-las-dos-estrategias-reales)
    - [Versionado en proyectos multi-módulo](#versionado-en-proyectos-multi-módulo)
  - [4. 🚨 Errores Comunes y Buenas Prácticas](#4--errores-comunes-y-buenas-prácticas-3)
- [Bloque 6: Gestión de Repositorios](#bloque-6-gestión-de-repositorios)
  - [1. 🎯 El Gran Cuadro](#1--el-gran-cuadro-4)
  - [2. 🧱 Arquitectura y Componentes](#2--arquitectura-y-componentes-4)
    - [Los cuatro niveles, y el orden real en que Maven los consulta](#los-cuatro-niveles-y-el-orden-real-en-que-maven-los-consulta)
    - [Repositorio local: más que una simple caché](#repositorio-local-más-que-una-simple-caché)
  - [3. 🛠️ Implementación Paso a Paso (Hands-On)](#3-️-implementación-paso-a-paso-hands-on-4)
    - [Configurar un repositorio privado como mirror (recomendado en empresa)](#configurar-un-repositorio-privado-como-mirror-recomendado-en-empresa)
    - [Configurar un repositorio privado como repositorio adicional (no mirror)](#configurar-un-repositorio-privado-como-repositorio-adicional-no-mirror)
    - [Publicar (`deploy`) en un repositorio privado](#publicar-deploy-en-un-repositorio-privado)
  - [4. 🚨 Errores Comunes y Buenas Prácticas](#4--errores-comunes-y-buenas-prácticas-4)
- [Bloque 7: Perfiles](#bloque-7-perfiles)
  - [1. 🎯 El Gran Cuadro](#1--el-gran-cuadro-5)
  - [2. 🧱 Arquitectura y Componentes](#2--arquitectura-y-componentes-5)
    - [Dos ubicaciones posibles, con alcance muy distinto](#dos-ubicaciones-posibles-con-alcance-muy-distinto)
    - [Mecanismos de activación](#mecanismos-de-activación)
  - [3. 🛠️ Implementación Paso a Paso (Hands-On)](#3-️-implementación-paso-a-paso-hands-on-5)
    - [Perfiles por entorno en el POM (caso de uso más común)](#perfiles-por-entorno-en-el-pom-caso-de-uso-más-común)
    - [Perfiles a nivel de `settings.xml` (credenciales y configuración local)](#perfiles-a-nivel-de-settingsxml-credenciales-y-configuración-local)
    - [Combinar perfiles con ejecución condicional de plugins](#combinar-perfiles-con-ejecución-condicional-de-plugins)
  - [4. 🚨 Errores Comunes y Buenas Prácticas](#4--errores-comunes-y-buenas-prácticas-5)
- [Bloque 8: La Carpeta `target/` y `settings.xml`](#bloque-8-la-carpeta-target-y-settingsxml)
  - [1. 🎯 El Gran Cuadro](#1--el-gran-cuadro-6)
  - [2. 🧱 Arquitectura y Componentes](#2--arquitectura-y-componentes-6)
    - [Estructura real de `target/`](#estructura-real-de-target)
    - [`settings.xml`: global vs local, y cómo se combinan](#settingsxml-global-vs-local-y-cómo-se-combinan)
  - [3. 🛠️ Implementación Paso a Paso (Hands-On)](#3-️-implementación-paso-a-paso-hands-on-6)
    - [Modificar la ubicación del repositorio local](#modificar-la-ubicación-del-repositorio-local)
    - [Configurar Maven detrás de un proxy corporativo](#configurar-maven-detrás-de-un-proxy-corporativo)
    - [Ubicaciones predeterminadas, por sistema operativo](#ubicaciones-predeterminadas-por-sistema-operativo)
  - [4. 🚨 Errores Comunes y Buenas Prácticas](#4--errores-comunes-y-buenas-prácticas-6)

---

# Maven: Guía Completa de Arquitectura y Producción

## 1. 🎯 El Gran Cuadro (The Big Picture)

**Maven es una herramienta de gestión y construcción (*build*) de proyectos** que automatiza la compilación, las pruebas, el empaquetado y la distribución de software, principalmente en el ecosistema JVM (Java, Kotlin, Scala). Todo su comportamiento se describe en un único archivo declarativo, el `pom.xml`, en lugar de en scripts imperativos paso a paso.

**¿Por qué existe?** Antes de Maven, cada equipo tenía su propio script de `build` (normalmente Ant) con su propia estructura de carpetas, su propia forma de descargar librerías (a menudo copiándolas a mano en un `/lib`) y su propia lógica de compilación. Resultado: incorporarse a un proyecto nuevo significaba semanas entendiendo "cómo se construye esto aquí". Maven resuelve ese problema imponiendo **convención sobre configuración**: si sigues su estructura estándar, el 90% del trabajo ya está hecho.

> 🧠 **Analogía:** Piensa en Maven como el **manual de instrucciones de IKEA universal**. No importa qué mueble compres (tu proyecto), si sigues la numeración de pasos (el ciclo de vida) y usas las piezas que vienen en la caja (las dependencias declaradas en el POM), el montaje es predecible. Ant, en cambio, es como recibir las piezas sueltas y tener que escribir tú mismo el manual de instrucciones cada vez.

**Lo que NO es Maven:** no es un IDE, no es un servidor de aplicaciones y no sustituye a un repositorio de artefactos como Nexus o Artifactory — los necesita para funcionar en equipo.

---

## 2. 🧱 Arquitectura y Componentes (Para Profesionales)

Maven no es un monolito. Es un **núcleo de ejecución mínimo** que delega prácticamente todo el trabajo real a plugins. Esta distinción es la que más confunde a un junior y la que un arquitecto debe dominar para depurar problemas de `build` en CI/CD.

### Los cinco pilares de la arquitectura

| Componente | Función | Analogía |
|---|---|---|
| **POM (`pom.xml`)** | Modelo de objetos del proyecto. Metadatos, dependencias, configuración de plugins. Es la única fuente de verdad. | El **plano arquitectónico** de un edificio: no construye nada por sí mismo, pero todo el equipo se rige por él. |
| **Ciclo de Vida (*Lifecycle*)** | Secuencia ordenada de **fases** (validate, compile, test, package...). Maven ejecuta fases, nunca "tareas" sueltas. | Las **estaciones de una cadena de montaje**: el coche no llega pintado antes de tener carrocería, por mucho que quieras saltarte el orden. |
| **Plugins** | Unidades de código (JARs) que implementan la lógica real. Cada plugin expone **goals** (objetivos) ejecutables. | Las **herramientas eléctricas** que usan los operarios en cada estación de la cadena. El "ciclo de vida" dice *cuándo* atornillar; el plugin es *el destornillador* que ejecuta el atornillado. |
| **Bindings** | La asociación entre una fase del ciclo de vida y el goal de un plugin que se ejecuta en ella. | El **turno asignado**: qué operario (plugin/goal) trabaja en qué estación (fase) de la cadena. |
| **Repositorios** | Almacenes de artefactos (JAR, WAR, POM) — local, remoto/central, privado de empresa. | El **almacén de piezas**: primero miras en tu taller (local); si no está, pides al proveedor central o al almacén interno de tu empresa. |

**Cómo interactúan en la práctica:** cuando ejecutas `mvn install`, Maven Core lee el POM, determina qué ciclo de vida aplica (`default`, `clean` o `site`), recorre sus fases en orden, y en cada fase invoca los goals de plugin que estén *bindeados* a ella — bien por convención (binding implícito según el `packaging`) o porque tú los declaraste explícitamente en `<build><plugins>`.

### Ciclos de vida: hay tres, no uno

Este es un error común en documentación: tratar "el ciclo de vida" como si fuera singular. Maven define **tres ciclos de vida independientes**, cada uno con sus propias fases. Ejecutar una fase de uno no dispara las de otro automáticamente.

#### Ciclo `clean`
Prepara el terreno eliminando artefactos de builds anteriores.

| Fase | Qué hace |
|---|---|
| `pre-clean` | Tareas previas a la limpieza (hooks personalizados). |
| `clean` | Elimina el directorio `target/` (por defecto, vía `maven-clean-plugin`). |
| `post-clean` | Tareas posteriores a la limpieza. |

#### Ciclo `default` (el que usas el 95% del tiempo)

| Fase | Qué hace | ❌ Error de novato |
|---|---|---|
| `validate` | Verifica que el POM es correcto y la estructura del proyecto es válida antes de gastar tiempo de CPU. | Ignorar errores de validación pensando que "ya compilará". |
| `compile` | Compila `src/main/java` → `target/classes`. | Asumir que "compile" ejecuta también los tests (no lo hace). |
| `test` | Ejecuta tests unitarios (`src/test/java`) vía Surefire. **No empaqueta nada.** | Pensar que si `mvn test` pasa, el JAR ya está listo para usar — no lo está, ni se ha generado. |
| `package` | Empaqueta el compilado en el formato definido (`jar`, `war`...). | Olvidar que `package` no ejecuta tests de integración. |
| `verify` | Ejecuta validaciones adicionales — tests de integración (Failsafe), análisis de calidad — sobre el paquete ya construido. | Confundir `verify` con `test`: son fases distintas con responsabilidades distintas. |
| `install` | Copia el artefacto a tu repositorio local (`~/.m2/repository`) para que otros proyectos locales puedan usarlo como dependencia. | Creer que `install` sube nada a un servidor remoto — **no lo hace**, es 100% local. |
| `deploy` | Sube el artefacto a un repositorio **remoto** (Nexus, Artifactory) para que otros equipos lo consuman. | Ejecutar `deploy` en local sin repositorio remoto configurado — fallará o, peor, no hace nada útil. |

> 🚨 **Regla de oro que evita el 80% de la confusión de un junior:** en Maven, cada fase posterior **ejecuta automáticamente todas las anteriores** del mismo ciclo. `mvn install` no salta a "instalar": primero valida, compila, testea, empaqueta y verifica. Es secuencial e inevitable — no puedes "saltarte" `compile` para llegar a `package`.

#### Ciclo `site`
Genera documentación y reportes del proyecto, independiente del ciclo `default`.

| Fase | Qué hace |
|---|---|
| `pre-site` | Tareas previas a la generación. |
| `site` | Genera el sitio de documentación (Javadoc, informes de cobertura, etc.). |
| `post-site` | Tareas posteriores. |
| `site-deploy` | Publica el sitio generado en un servidor remoto. |

### Personalización: plugins y bindings explícitos

Maven ya trae bindings implícitos razonables (por ejemplo, en un proyecto `jar`, la fase `package` está ligada al goal `jar:jar`). Pero en producción, frecuentemente necesitas ejecutar lógica adicional en una fase concreta — generación de código, validaciones custom, tareas de Ant legacy. Esto se hace declarando el plugin con su `<execution>` y la `<phase>` exacta:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-antrun-plugin</artifactId>
      <version>3.1.0</version>
      <executions>
        <execution>
          <!-- Se ejecuta ANTES de compilar, útil para generar código fuente -->
          <phase>generate-sources</phase>
          <goals>
            <goal>run</goal>
          </goals>
          <configuration>
            <target>
              <echo>Generando código fuente...</echo>
            </target>
          </configuration>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

> ⚠️ **Nota de precisión técnica:** la etiqueta `<tasks>` que aparece en versiones antiguas de `maven-antrun-plugin` (1.x) fue reemplazada por `<target>` desde la versión 1.7+. Si ves `<tasks>` en código de ejemplo de internet, es obsoleto — usa `<target>`.

**Ejecución condicional por perfil** (útil cuando solo quieres correr ciertos plugins en un entorno):

```xml
<profiles>
  <profile>
    <id>testing</id>
    <activation>
      <property>
        <name>env</name>
        <value>test</value>
      </property>
    </activation>
    <build>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-surefire-plugin</artifactId>
          <configuration>
            <skipTests>false</skipTests>
          </configuration>
        </plugin>
      </plugins>
    </build>
  </profile>
</profiles>
```

Se activaría con: `mvn install -Denv=test`

---

## 3. 🛠️ Instalación (Hands-On)

### Requisitos previos

- **JDK 17 o 21 (LTS)**. JDK 8 ya no recibe soporte público de Oracle y solo debería usarse para mantenimiento de sistemas legacy — no es la baseline recomendable para un proyecto nuevo en 2026.
- Variable de entorno `JAVA_HOME` apuntando al JDK instalado.
- `PATH` con el directorio `bin` de Maven incluido.

```bash
# Verificar versión de Java activa
java -version

# Verificar que JAVA_HOME está correctamente configurado
echo $JAVA_HOME        # Linux/macOS
echo %JAVA_HOME%       # Windows (cmd)
```

### Instalación manual

1. Descarga el binario desde `https://maven.apache.org/download.cgi`.
2. Descomprime en un directorio fijo, p. ej. `/opt/maven` o `C:\tools\maven`.
3. Configura las variables de entorno:

```bash
# ~/.bashrc o ~/.zshrc (Linux/macOS)
export MAVEN_HOME=/opt/maven
export PATH=$MAVEN_HOME/bin:$PATH
```

4. Verifica la instalación:

```bash
mvn -v
```

Este comando debe mostrar la versión de Maven, la versión de Java que está usando y el sistema operativo. **Si `mvn -v` muestra una versión de Java distinta a la que esperas**, revisa `JAVA_HOME` — es la causa nº1 de "funciona en mi máquina pero no en CI".

### Instalación mediante gestor de paquetes

```bash
# Homebrew (macOS/Linux)
brew install maven
brew upgrade maven

# Chocolatey (Windows)
choco install maven
choco upgrade maven

# SDKMAN (Linux/macOS/WSL) — recomendado si gestionas varias versiones de Java/Maven
sdk install maven
sdk use maven <versión>
sdk list maven
```

> 💡 **Recomendación de arquitecto:** en equipos donde convive más de un proyecto con requisitos de versión distintos, **SDKMAN** es superior a una instalación manual porque permite cambiar de versión activa con un solo comando, sin tocar variables de entorno a mano.

### Entornos Docker (reproducibilidad real)

```dockerfile
FROM maven:3.9.9-eclipse-temurin-21
WORKDIR /usr/src/app
COPY . .
RUN mvn clean install
CMD ["mvn", "exec:java"]
```

> ⚠️ **Corrección importante:** la imagen oficial `maven:3.8.6-jdk-11` que circula en muchos tutoriales usa una etiqueta de JDK obsoleta (`jdk-11` con sintaxis antigua). Las imágenes oficiales actuales en Docker Hub siguen el patrón `maven:<versión-maven>-eclipse-temurin-<versión-java>`. Verifica siempre las tags vigentes en [hub.docker.com/_/maven](https://hub.docker.com/_/maven) antes de fijar una versión en tu `Dockerfile`, porque las imágenes antiguas dejan de recibir parches de seguridad.

Para compartir el caché de dependencias entre el host y el contenedor (evita re-descargar todo en cada build):

```bash
docker run -it --rm \
  -v ~/.m2:/root/.m2 \
  -v $(pwd):/usr/src/app \
  -w /usr/src/app \
  maven:3.9.9-eclipse-temurin-21 mvn clean install
```

### Múltiples versiones de Maven en paralelo

Si trabajas con proyectos legacy que requieren Maven 3.6 junto a proyectos modernos en 3.9, **SDKMAN sigue siendo la opción más limpia**:

```bash
sdk use maven 3.6.3   # para el proyecto legacy
sdk use maven 3.9.9   # para el proyecto moderno
```

La alternativa manual (descomprimir varios binarios y usar alias de shell) funciona, pero es frágil: cualquier desarrollador nuevo en el equipo tendrá que replicar esos alias a mano, mientras que SDKMAN centraliza la gestión de versiones en un solo comando estándar.

---

# Bloque 2: El Archivo POM en Profundidad

## 1. 🎯 El Gran Cuadro

El `pom.xml` (**Project Object Model**) es el único archivo que Maven necesita leer para saber qué es tu proyecto, qué necesita y cómo construirlo. Todo lo demás —dependencias, plugins, perfiles, propiedades— vive ahí dentro, declarado, nunca en un script imperativo.

**¿Por qué importa tanto entenderlo bien?** Porque la mayoría de los problemas de producción en Maven ("funciona en mi máquina, falla en CI", "versión incorrecta de una librería en runtime", "conflictos de dependencias en proyectos multi-módulo") no son bugs de Maven — son POMs mal diseñados.

> 🧠 **Analogía:** El POM es la **receta de cocina**, no el plato. No contiene la comida (el código compilado), contiene la lista exacta de ingredientes (dependencias), las cantidades (versiones) y el orden de los pasos (ciclo de vida + plugins). Si la receta dice "harina" sin especificar cuánta, cada cocinero (cada módulo del proyecto) decidirá una cantidad distinta — y ahí empiezan los conflictos de versión.

---

## 2. 🧱 Arquitectura y Componentes

### Anatomía mínima de un POM

| Elemento | Función | Obligatorio |
|---|---|---|
| `modelVersion` | Versión del esquema XML del POM. Hoy siempre `4.0.0`. | Sí |
| `groupId` | Identificador de la organización, en notación de dominio inverso (`com.empresa.proyecto`). | Sí |
| `artifactId` | Nombre único del artefacto dentro del `groupId`. | Sí |
| `version` | Versión del propio proyecto (`1.0.0`, `1.0-SNAPSHOT`). | Sí |
| `packaging` | Formato de salida: `jar`, `war`, `pom`, `ear`... Por defecto `jar`. | No |
| `dependencies` | Librerías que el código necesita para compilar, testear o ejecutarse. | No, pero casi siempre presente |
| `parent` | POM padre del que se heredan configuraciones, propiedades y gestión de versiones. | No |
| `modules` | Lista de submódulos en un proyecto multi-módulo. | No |
| `properties` | Variables reutilizables, referenciables con `${nombre}`. | No |
| `build > plugins` | Configuración de los plugins que ejecutan la lógica de construcción. | No |

> 🚨 **Distinción crítica que el original no aclaraba bien:** `groupId:artifactId:version` (las "coordenadas GAV") identifican de forma **única e inequívoca** un artefacto en cualquier repositorio Maven del mundo. Si dos equipos publican el mismo `groupId:artifactId` con distinta versión, no hay conflicto — son artefactos distintos por definición. El conflicto real aparece cuando dos *dependencias transitivas* exigen versiones diferentes del *mismo* GA. Eso se resuelve con `dependencyManagement` (lo vemos abajo) o con `<exclusions>`.

### `parent` POM vs BOM: la confusión que casi todo el mundo tiene

Esta es la distinción conceptual que el documento original omitía y que cualquier arquitecto debe tener clarísima:

| | **Parent POM** | **BOM (Bill of Materials)** |
|---|---|---|
| **Qué es** | Un POM completo del que se **hereda todo**: plugins, propiedades, perfiles, `dependencyManagement`. | Un POM especial (`packaging=pom`) que **solo** declara versiones en `dependencyManagement`. No aporta plugins ni herencia de configuración. |
| **Relación** | `<parent>` — solo puedes tener **un único padre**. | `<dependencyManagement><dependency><scope>import</scope></dependency>` — puedes **importar varios BOMs**. |
| **Caso de uso típico** | Estandarizar el `build` de todos los proyectos de tu empresa (mismo compilador, mismos plugins de calidad). | Fijar de forma centralizada las versiones de un ecosistema de librerías (todas las de Spring Boot, todas las de un módulo Jackson). |
| **Ejemplo real** | Un `company-parent-pom` interno con versión fija de `maven-compiler-plugin`, `checkstyle`, etc. | `spring-boot-dependencies`, `aws-java-sdk-bom`. |

> 🧠 **Analogía:** El **parent POM** es como heredar el ADN completo de un progenitor — apariencia, comportamiento, todo. El **BOM** es como una **lista de precios actualizada de un proveedor**: te dice "estas son las versiones recomendadas que funcionan bien juntas", pero no te obliga a comprar nada ni te impone cómo cocinas. Puedes usar varias listas de precios de proveedores distintos a la vez; solo puedes tener un padre.

### `dependencyManagement`: gobierna versiones sin forzar inclusión

```xml
<dependencyManagement>
    <dependencies>
        <!-- Importación de BOM: fija versiones de TODO el ecosistema Spring Boot -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.3.5</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>

        <!-- Fijación de versión para una librería puntual,
             compartida por todos los módulos del proyecto -->
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-lang3</artifactId>
            <version>3.17.0</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

**Lo que hace exactamente, sin ambigüedad:**
1. **No añade ninguna dependencia al classpath.** Declarar algo aquí no lo incluye en tu proyecto — solo registra "si alguien pide esta librería, esta es la versión que se usará".
2. **Se propaga a módulos hijos** en proyectos multi-módulo: el padre centraliza, los hijos solo declaran `groupId` + `artifactId` (sin `version`) en su `<dependencies>` y heredan la versión correcta.
3. **Resuelve conflictos de dependencias transitivas**: si `libreria-A` exige `commons-lang3:3.10` y `libreria-B` exige `3.15`, lo que declares en `dependencyManagement` gana, sin importar la "regla del más cercano" por defecto de Maven.

> ❌ **MAL** — versión repetida en cada módulo, fuente garantizada de inconsistencias:
> ```xml
> <!-- módulo-a/pom.xml -->
> <dependency>
>   <groupId>org.apache.commons</groupId>
>   <artifactId>commons-lang3</artifactId>
>   <version>3.12.0</version>
> </dependency>
>
> <!-- módulo-b/pom.xml -->
> <dependency>
>   <groupId>org.apache.commons</groupId>
>   <artifactId>commons-lang3</artifactId>
>   <version>3.15.0</version> <!-- distinta sin querer -->
> </dependency>
> ```

> ✅ **BIEN** — versión centralizada en el padre, módulos sin riesgo de desincronía:
> ```xml
> <!-- pom.xml padre -->
> <dependencyManagement>
>   <dependencies>
>     <dependency>
>       <groupId>org.apache.commons</groupId>
>       <artifactId>commons-lang3</artifactId>
>       <version>3.17.0</version>
>     </dependency>
>   </dependencies>
> </dependencyManagement>
>
> <!-- módulo-a/pom.xml y módulo-b/pom.xml -->
> <dependency>
>   <groupId>org.apache.commons</groupId>
>   <artifactId>commons-lang3</artifactId>
>   <!-- sin version: hereda 3.17.0 automáticamente -->
> </dependency>
> ```

### Propiedades del POM

| Tipo | Prefijo | Ejemplo |
|---|---|---|
| Variables de entorno del SO | `env.` | `${env.HOME}` |
| Variables estándar del propio POM | `project.` | `${project.version}`, `${project.artifactId}` |
| Variables de configuración de Maven | `settings.` | `${settings.localRepository}` |
| Propiedades personalizadas | (ninguno) | `${java.version}` definida en `<properties>` |

```xml
<properties>
    <java.version>21</java.version>
    <maven.compiler.source>${java.version}</maven.compiler.source>
    <maven.compiler.target>${java.version}</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

> 💡 **Buena práctica de producción:** define `<maven.compiler.release>` en lugar de `source`/`target` por separado cuando uses Java 9+. Una sola propiedad, sin posibilidad de que `source` y `target` queden desincronizados:
> ```xml
> <properties>
>     <maven.compiler.release>21</maven.compiler.release>
> </properties>
> ```

---

## 3. 🛠️ Implementación Paso a Paso (Hands-On)

POM de producción completo, comentado, con versiones vigentes (verificadas a fecha de esta guía):

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>advanced-project</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <!-- 1. Propiedades centralizadas: una sola fuente de verdad para versiones clave -->
    <properties>
        <maven.compiler.release>21</maven.compiler.release>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <spring-boot.version>3.3.5</spring-boot.version>
    </properties>

    <!-- 2. dependencyManagement: gobierna versiones, no las incluye -->
    <dependencyManagement>
        <dependencies>
            <!-- Importación de BOM de Spring Boot: fija versiones de TODO su ecosistema -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>${spring-boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!-- 3. Dependencias reales del proyecto -->
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
            <!-- Sin <version>: la resuelve el BOM importado arriba -->
        </dependency>

        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <!-- 4. Perfiles: cambian propiedades según el entorno de ejecución -->
    <profiles>
        <profile>
            <id>development</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <db.url>jdbc:h2:mem:dev</db.url>
            </properties>
        </profile>
        <profile>
            <id>production</id>
            <properties>
                <db.url>jdbc:postgresql://prod-db-server:5432/prod</db.url>
            </properties>
        </profile>
    </profiles>

    <!-- 5. Plugins: SIEMPRE con versión explícita (ver nota de Enforcer abajo) -->
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.15.0</version>
            </plugin>

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-enforcer-plugin</artifactId>
                <version>3.6.3</version>
                <executions>
                    <execution>
                        <id>enforce-rules</id>
                        <goals>
                            <goal>enforce</goal>
                        </goals>
                        <configuration>
                            <rules>
                                <!-- Bloquea SNAPSHOTs en builds de release: evita
                                     que un artefacto inestable llegue a producción -->
                                <requireReleaseDeps>
                                    <onlyWhenRelease>true</onlyWhenRelease>
                                </requireReleaseDeps>
                                <requireMavenVersion>
                                    <version>3.9.0</version>
                                </requireMavenVersion>
                                <requireJavaVersion>
                                    <version>21</version>
                                </requireJavaVersion>
                            </rules>
                            <fail>true</fail>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

> 🚨 **`maven-enforcer-plugin` no estaba en el documento original y es estándar en cualquier organización seria.** Su función es hacer fallar el `build` ANTES de que un problema llegue a producción: versión de Java incorrecta, dependencias `SNAPSHOT` coladas en un release, versiones de plugin sin fijar. Es la diferencia entre detectar un problema en 30 segundos en tu máquina y detectarlo 3 horas después en un pipeline de CI compartido por todo el equipo.

---

## 4. 🚨 Errores Comunes y Buenas Prácticas

| Problema en producción | Causa raíz | Solución |
|---|---|---|
| Dos módulos del mismo proyecto compilan con versiones distintas de una librería compartida. | No se usó `dependencyManagement`; cada módulo fijó su propia versión. | Centralizar TODAS las versiones compartidas en el `dependencyManagement` del POM padre. |
| `mvn clean install` funciona en local pero falla en el pipeline de CI con un error de versión de plugin distinto. | El plugin no tiene `<version>` fijada — Maven resuelve "la más reciente disponible en ese momento", que cambia con el tiempo. | Fijar SIEMPRE versión explícita en cada plugin. Añadir `maven-enforcer-plugin` con `requirePluginVersions` para que el build falle si alguien olvida una versión. |
| Un `SNAPSHOT` de una dependencia interna acaba en un artefacto de producción. | No hay control sobre qué tipo de dependencias se permiten en un build de `release`. | Regla `requireReleaseDeps` del Enforcer, activa solo cuando el build es de release. |
| El BOM importado no parece aplicar la versión esperada a una dependencia. | Se declaró la dependencia con `<version>` explícita en el módulo, lo cual **siempre gana** sobre lo heredado del `dependencyManagement`/BOM. | Eliminar la versión explícita del módulo si quieres que la gobierne el BOM/padre — la ausencia de `<version>` es la señal de "hereda de arriba". |

---

# Bloque 3: Gestión de Dependencias

## 1. 🎯 El Gran Cuadro

Una dependencia es cualquier librería externa que tu código necesita para compilar, testear o ejecutarse. El problema real no es declararlas — eso es trivial. El problema es que **cada dependencia trae sus propias dependencias** (las *transitivas*), y cuando dos de ellas exigen versiones distintas de una misma librería, tienes un conflicto que puede romper tu aplicación en tiempo de ejecución sin que el compilador se queje.

**Por qué es crítico en producción:** un conflicto de versiones mal resuelto no siempre falla al compilar. A menudo falla con un `NoSuchMethodError` o `ClassNotFoundException` en tiempo de ejecución, en producción, porque Maven eligió silenciosamente una versión incompatible con lo que tu código espera.

> 🧠 **Analogía:** Gestionar dependencias transitivas es como **organizar una cena con invitados que tienen alergias cruzadas**. Invitas a A (necesita gambas) y a B (necesita maní), pero A es alérgico al maní y B es alérgico al marisco. Si no decides explícitamente el menú (las versiones), cada invitado intentará imponer el suyo y alguien se va a la urgencia (tu aplicación a producción con un `ClassNotFoundException`).

---

## 2. 🧱 Arquitectura y Componentes

### El `scope`: cuándo y dónde vive cada dependencia

El `scope` no es metadata decorativa — determina en qué fases del ciclo de vida una dependencia está disponible, y si viaja o no en el artefacto final.

| Scope | Disponible en compilación | Disponible en test | Disponible en runtime | ¿Va en el JAR/WAR final? | Caso de uso típico |
|---|---|---|---|---|---|
| `compile` (default) | ✅ | ✅ | ✅ | ✅ | Librerías que tu código usa siempre: Jackson, Apache Commons. |
| `provided` | ✅ | ✅ | ❌ (la aporta el entorno) | ❌ | Servlet API en una app desplegada en Tomcat — el contenedor ya la trae. |
| `runtime` | ❌ | ✅ | ✅ | ✅ | Driver JDBC: tu código compila contra una interfaz (`java.sql.Driver`), no contra la implementación concreta. |
| `test` | ❌ | ✅ | ❌ | ❌ | JUnit, Mockito. |
| `system` | ✅ | ✅ | ❌ | ❌ | JARs locales fuera de cualquier repositorio (uso desaconsejado: rompe la reproducibilidad). |
| `import` | — | — | — | — | Solo válido dentro de `dependencyManagement`, para importar BOMs. |

> 🚨 **Error de producción muy común:** declarar el driver de base de datos (p. ej. `postgresql`) con scope `compile` cuando debería ser `runtime`. Consecuencia práctica: ningún error visible, pero estás permitiendo que el código de la aplicación importe directamente clases del driver concreto en lugar de programar contra la interfaz JDBC estándar — acoplamiento que dificulta cambiar de base de datos el día de mañana.

### Dependencias transitivas: cómo Maven decide qué versión "gana"

Cuando dos rutas de dependencias transitivas chocan en la misma librería con distinta versión, Maven aplica la **regla de la ruta más cercana** (*nearest definition wins*): gana la versión declarada al nivel de profundidad más bajo en el árbol de dependencias. Si hay igualdad de profundidad, gana la que aparece primero declarada en el POM.

> ⚠️ **Esto NO es lo mismo que "la versión más reciente gana".** Es una trampa frecuente: Maven no es Gradle por defecto en este punto — no resuelve por "mayor versión semántica", resuelve por cercanía en el árbol. Si necesitas control explícito, no confíes en esta regla implícita: usa `dependencyManagement` para fijar la versión que realmente quieres.

### Dependencias opcionales

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>some-library</artifactId>
    <version>1.0.0</version>
    <optional>true</optional>
</dependency>
```

`optional=true` significa: "esta dependencia es necesaria para *algunas* funcionalidades de mi librería, pero no la propago automáticamente a quien me consuma a mí". Si publicas una librería interna y la usa otro equipo, ellos tendrán que declarar explícitamente esta dependencia opcional si necesitan esa funcionalidad concreta.

### Exclusiones: cortando dependencias transitivas no deseadas

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>parent-library</artifactId>
    <version>2.0.0</version>
    <exclusions>
        <exclusion>
            <groupId>com.unwanted</groupId>
            <artifactId>unwanted-library</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

Casos de uso reales para excluir:
- Una librería transitiva tiene una **vulnerabilidad de seguridad conocida** (CVE) y quieres forzar otra versión o eliminarla.
- Conflicto de logging: `commons-logging` vs `slf4j` es el ejemplo clásico — casi todo proyecto Spring termina excluyendo `commons-logging` de alguna dependencia transitiva.
- Reducir el tamaño del artefacto final eliminando transitivas que nunca se usan.

---

## 3. 🛠️ Implementación Paso a Paso (Hands-On)

### Visualizar el árbol de dependencias

```bash
mvn dependency:tree
```

Salida típica (interpretación línea por línea):

```
[INFO] com.example:advanced-project:jar:1.0.0
[INFO] +- org.springframework.boot:spring-boot-starter:jar:3.3.5:compile
[INFO] |  +- org.springframework.boot:spring-boot:jar:3.3.5:compile
[INFO] |  \- org.slf4j:slf4j-api:jar:2.0.16:compile
[INFO] \- org.apache.commons:commons-lang3:jar:3.17.0:compile
```

- El símbolo `+-` indica una dependencia directa o transitiva en una rama.
- La indentación (`|  +-`) indica profundidad: cuanto más anidado, más "lejana" es la dependencia transitiva.
- Si ves la **misma librería dos veces con versiones distintas** en la salida, ahí tienes tu conflicto — Maven habrá elegido una por la regla de cercanía, pero conviene fijarla explícitamente con `dependencyManagement` en lugar de confiar en la resolución implícita.

Para detectar conflictos de forma más dirigida, filtra por el artefacto sospechoso:

```bash
mvn dependency:tree -Dincludes=com.fasterxml.jackson.core:jackson-databind
```

### Detectar dependencias mal declaradas

```bash
mvn dependency:analyze
```

Esto reporta dos categorías de problemas, ambos relevantes para mantener un POM limpio:

```
[WARNING] Used undeclared dependencies found:
[WARNING]    com.google.guava:guava:jar:33.0.0:compile
[WARNING] Unused declared dependencies found:
[WARNING]    org.apache.commons:commons-io:jar:2.16.1:compile
```

- **"Used undeclared"**: tu código usa una clase de esa librería, pero no la declaraste directamente — la estás obteniendo "gratis" como transitiva de otra dependencia. **Riesgo real:** si esa dependencia padre cambia de versión y deja de traer esa transitiva, tu build se rompe sin aviso previo. Decláralo explícitamente.
- **"Unused declared"**: la declaraste pero no la usas. Elimínala — reduce superficie de ataque de seguridad y tiempo de build.

> 💡 **Para resolución completa de versiones, no solo análisis de uso:**
> ```bash
> mvn dependency:analyze-dep-mgt
> ```
> Detecta discrepancias entre lo que declaras en `dependencyManagement` y las versiones realmente resueltas — útil para verificar que tu centralización de versiones está funcionando como crees.

### Versionado semántico (SemVer) aplicado a tu estrategia de dependencias

Formato `MAJOR.MINOR.PATCH`:

| Cambio | Significado | Riesgo al actualizar |
|---|---|---|
| `PATCH` (1.2.**3** → 1.2.**4**) | Corrección de bugs, sin cambios de API. | Bajo — actualización segura casi siempre. |
| `MINOR` (1.**2**.3 → 1.**3**.0) | Funcionalidad nueva, compatible hacia atrás. | Bajo-medio — revisar changelog por deprecaciones. |
| `MAJOR` (**1**.2.3 → **2**.0.0) | Cambios incompatibles en la API pública. | Alto — requiere revisión de código, no solo cambiar el número. |

> 🚨 **Práctica de producción que el documento original no mencionaba:** evita rangos de versión abiertos (`[1.0,)`, `LATEST`, `RELEASE`) en proyectos de producción. Son **enemigos directos de la reproducibilidad de builds**: el mismo `pom.xml`, ejecutado en dos fechas distintas, puede resolver dos versiones distintas de la misma dependencia sin que cambies una sola línea. Para builds reproducibles, fija siempre versiones exactas y delega la *actualización controlada* al `versions-maven-plugin`:

```bash
# Detecta qué dependencias tienen versión más reciente disponible, SIN tocar nada
mvn versions:display-dependency-updates

# Solo entonces, decide manualmente o vía pipeline automatizado, actualizar
mvn versions:use-latest-releases
```

---

## 4. 🚨 Errores Comunes y Buenas Prácticas

| Síntoma | Causa raíz | Solución |
|---|---|---|
| `NoSuchMethodError` en producción, el código compiló sin problema. | Conflicto de versión transitiva resuelto silenciosamente por la regla de "ruta más cercana"; la versión elegida no tiene el método que tu código espera. | Ejecutar `mvn dependency:tree` para localizar el conflicto y fijar la versión correcta en `dependencyManagement`. |
| El build de hoy usa una versión distinta de una librería que el build de la semana pasada, sin cambios en el código. | Uso de rangos de versión abiertos (`LATEST`, `RELEASE`, `[1.0,)`). | Fijar siempre versiones exactas. Usar `versions-maven-plugin` para actualizaciones deliberadas y auditables. |
| Conflictos de logging (`commons-logging` vs `slf4j`, mensajes duplicados o `ClassCastException` en frameworks de logging). | Una dependencia transitiva arrastra una implementación de logging distinta a la que usa el resto del proyecto. | Excluir la transitiva conflictiva con `<exclusions>` y declarar explícitamente la implementación de logging deseada. |
| Vulnerabilidad de seguridad reportada en una librería que nunca declaraste a propósito. | Es una dependencia transitiva de tercer o cuarto nivel, invisible si solo miras tus `<dependencies>` directas. | `mvn dependency:tree` regularmente (o integrado en CI) + herramientas de SCA (Dependabot, Snyk, OWASP Dependency-Check) para detectar CVEs en transitivas. |
| El proyecto tiene 40 dependencias declaradas y nadie sabe cuáles se usan realmente. | Nunca se ejecutó limpieza con `dependency:analyze`. | Incorporar `mvn dependency:analyze` al pipeline de CI como check de calidad, fallando el build si hay "unused declared" sin justificación documentada. |

# Bloque 4: Plugins Esenciales y Avanzados

## 1. 🎯 El Gran Cuadro

Maven Core, por sí solo, no compila nada, no ejecuta tests y no empaqueta nada. **Todo el trabajo real lo hacen los plugins.** Esto no es un detalle de implementación: es la razón por la que entender qué plugin hace qué, en qué fase, y con qué versión, es la habilidad más práctica que puedes tener trabajando con Maven a diario.

> 🧠 **Analogía:** Si el ciclo de vida es el guión de una obra de teatro (qué pasa y en qué orden), los plugins son los **actores que interpretan cada escena**. El guión dice "en la escena 3 (fase `test`) hay un combate"; el plugin Surefire es el actor que coreografía y ejecuta ese combate concretamente. Cambiar de plugin (o de versión) es como cambiar de actor para el mismo papel: el guión no cambia, pero la ejecución sí puede.

---

## 2. 🧱 Arquitectura y Componentes

### Mapa de los plugins esenciales y su fase de binding

| Plugin | Fase principal | Qué hace exactamente | Versión estable actual |
|---|---|---|---|
| `maven-clean-plugin` | `clean` | Elimina `target/`. | 3.4.1 |
| `maven-compiler-plugin` | `compile`, `test-compile` | Compila `.java` → `.class`. | **3.15.0** |
| `maven-surefire-plugin` | `test` | Ejecuta tests unitarios. | **3.5.6** |
| `maven-failsafe-plugin` | `integration-test`, `verify` | Ejecuta tests de integración. | **3.5.6** |
| `maven-resources-plugin` | `process-resources` | Copia recursos (`src/main/resources`) a `target/classes`. | **3.5.0** |
| `maven-jar-plugin` | `package` | Empaqueta `.class` + recursos en un `.jar`. | **3.5.0** |
| `maven-shade-plugin` | `package` | Crea un *uber-jar* (JAR con todas las dependencias incluidas). | **3.6.2** |
| `maven-dependency-plugin` | varias (manual) | Análisis y manipulación de dependencias. | **3.11.0** |
| `maven-enforcer-plugin` | `validate` (típico) | Bloquea el build si no se cumplen reglas de entorno/versiones. | **3.6.3** |

> 🚨 **Nota de seguridad operativa, aplicable a TODOS los plugins de esta tabla:** las versiones aquí indicadas son las vigentes en el momento de escribir esta guía. Los plugins de Maven se actualizan con frecuencia (parches de seguridad, soporte para nuevas versiones de Java). **Nunca copies un número de versión de una guía y lo dejes fijo para siempre.** Verifica periódicamente en [mvnrepository.com](https://mvnrepository.com) o ejecuta `mvn versions:display-plugin-updates` para saber si hay una versión más reciente.

### Surefire vs Failsafe: la distinción que el original simplificaba de menos

| | Surefire | Failsafe |
|---|---|---|
| **Fase de ejecución** | `test` | `integration-test` + `verify` |
| **Convención de nombres** | `*Test.java`, `Test*.java` | `*IT.java`, `IT*.java`, `*ITCase.java` |
| **Si falla un test, ¿se detiene el build inmediatamente?** | Sí, en la misma fase. | **No** — Failsafe separa intencionadamente la *ejecución* (`integration-test`) de la *verificación del resultado* (`verify`). |
| **Por qué importa esa separación** | — | Permite que un *hook* de limpieza (apagar un contenedor Docker, una base de datos de prueba) se ejecute **siempre**, incluso si los tests de integración fallaron, antes de que el build falle oficialmente. |

> 🧠 **Analogía:** Surefire es un examen con corrección **inmediata**: fallas una pregunta, el examen se detiene ahí. Failsafe es un examen donde primero completas **todas** las preguntas (fase `integration-test`), y solo al final, con todo ya hecho, se revisa si aprobaste (fase `verify`) — así te da tiempo a "recoger tus cosas del aula" (apagar recursos de test) antes de saber el resultado.

---

## 3. 🛠️ Implementación Paso a Paso (Hands-On)

### `maven-compiler-plugin`: compilación con soporte para Lombok

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.15.0</version>
            <configuration>
                <!-- release sustituye a source+target por separado:
                     una sola fuente de verdad, sin riesgo de desincronía -->
                <release>21</release>
                <compilerArgs>
                    <arg>-Xlint:all</arg> <!-- activa todos los warnings del compilador -->
                </compilerArgs>
                <annotationProcessorPaths>
                    <path>
                        <groupId>org.projectlombok</groupId>
                        <artifactId>lombok</artifactId>
                        <version>1.18.34</version>
                    </path>
                </annotationProcessorPaths>
            </configuration>
        </plugin>
    </plugins>
</build>
```

> ⚠️ **Corrección respecto a configuraciones antiguas que circulan online:** la etiqueta `<compilerArgument>` (singular) está deprecada; usa `<compilerArgs>` (plural, acepta una lista). Y `<annotationProcessorPath>` (singular, dentro de `<annotationProcessorPaths>`) ha sido reemplazado por `<path>` en versiones recientes del plugin — revisa siempre la documentación oficial de la versión exacta que uses, porque estos detalles de sintaxis cambian entre major versions.

### `maven-surefire-plugin` y `maven-failsafe-plugin`: separación real de unitarios e integración

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-plugin</artifactId>
      <version>3.5.6</version>
      <configuration>
        <includes>
          <include>**/*Test.java</include>
        </includes>
        <!-- Excluye explícitamente los de integración para que
             Surefire nunca los ejecute por accidente -->
        <excludes>
          <exclude>**/*IT.java</exclude>
        </excludes>
      </configuration>
    </plugin>

    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-failsafe-plugin</artifactId>
      <version>3.5.6</version>
      <executions>
        <execution>
          <goals>
            <goal>integration-test</goal>
            <goal>verify</goal>
          </goals>
        </execution>
      </executions>
      <configuration>
        <includes>
          <include>**/*IT.java</include>
        </includes>
      </configuration>
    </plugin>
  </plugins>
</build>
```

> ❌ **MAL** — sin la sección `<executions>` en Failsafe:
> ```xml
> <plugin>
>   <groupId>org.apache.maven.plugins</groupId>
>   <artifactId>maven-failsafe-plugin</artifactId>
>   <version>3.5.6</version>
> </plugin>
> ```
> Sin `<executions>` explícitas, Failsafe **no se ejecuta nunca automáticamente** en el ciclo de vida — a diferencia de Surefire, que sí tiene binding implícito a la fase `test`. Es un error silencioso: el plugin está ahí, parece configurado, pero tus tests de integración jamás corren.

> ✅ **BIEN** — como en el bloque de código de arriba: declarando explícitamente los goals `integration-test` y `verify` en `<executions>`.

### `maven-resources-plugin`: filtrado de recursos con variables del POM

Caso de uso real de producción: inyectar la versión del proyecto en un archivo de propiedades que la aplicación lee en runtime.

```xml
<build>
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <filtering>true</filtering> <!-- habilita sustitución de ${...} -->
        </resource>
    </resources>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-resources-plugin</artifactId>
            <version>3.5.0</version>
        </plugin>
    </plugins>
</build>
```

```properties
# src/main/resources/application.properties
app.version=${project.version}
app.build.timestamp=${maven.build.timestamp}
```

Tras `mvn process-resources`, `target/classes/application.properties` contendrá la versión real del proyecto, no el literal `${project.version}`. Esto evita el clásico problema de "qué versión está realmente desplegada" sin tener que hardcodear nada a mano antes de cada release.

### `maven-shade-plugin`: uber-jar ejecutable de forma autónoma

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <version>3.6.2</version>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>shade</goal>
                    </goals>
                    <configuration>
                        <createDependencyReducedPom>false</createDependencyReducedPom>
                        <transformers>
                            <!-- Define la clase main ejecutable con 'java -jar' -->
                            <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                <mainClass>com.example.MainApplication</mainClass>
                            </transformer>
                        </transformers>
                        <filters>
                            <filter>
                                <artifact>*:*</artifact>
                                <excludes>
                                    <!-- Excluye firmas criptográficas de las dependencias originales:
                                         tras combinar JARs, esas firmas ya no son válidas y rompen el classpath -->
                                    <exclude>META-INF/*.SF</exclude>
                                    <exclude>META-INF/*.DSA</exclude>
                                    <exclude>META-INF/*.RSA</exclude>
                                </excludes>
                            </filter>
                        </filters>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

> 🚨 **Corrección sobre el filtro del documento original:** la configuración original incluía únicamente `**/*.class` como filtro positivo dentro de `<includes>`, lo cual en la práctica puede excluir recursos no-class necesarios (`META-INF/services/*` para SPI, archivos de configuración). El patrón production-ready es justo el opuesto: **incluir todo por defecto y excluir explícitamente** las firmas criptográficas conflictivas (`*.SF`, `*.DSA`, `*.RSA`), que es el problema real y documentado que rompe los uber-jars con dependencias firmadas.

### `maven-dependency-plugin`: copiar dependencias a un directorio (sin crear uber-jar)

Alternativa a Shade cuando no quieres fusionar JARs sino mantenerlos como archivos separados (típico en imágenes Docker multi-capa, para aprovechar el cacheo de capas):

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-dependency-plugin</artifactId>
            <version>3.11.0</version>
            <executions>
                <execution>
                    <id>copy-dependencies</id>
                    <phase>prepare-package</phase>
                    <goals>
                        <goal>copy-dependencies</goal>
                    </goals>
                    <configuration>
                        <outputDirectory>${project.build.directory}/lib</outputDirectory>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

> 💡 **¿Shade o `copy-dependencies`? Criterio de decisión real:** usa **Shade** cuando distribuyes un único artefacto autocontenido (CLI tools, jobs batch). Usa **`copy-dependencies`** cuando construyes imágenes Docker, porque separar el JAR de la aplicación de sus librerías en capas distintas permite que Docker **cachee la capa de dependencias** y solo reconstruya la capa de tu código cuando este cambia — builds de imagen mucho más rápidos en CI.

---

## 4. 🚨 Errores Comunes y Buenas Prácticas

| Problema en producción | Causa raíz | Solución |
|---|---|---|
| Los tests de integración nunca se ejecutan en CI, aunque el plugin Failsafe está en el POM. | Falta la sección `<executions>` con los goals `integration-test` y `verify` — Failsafe no tiene binding implícito como Surefire. | Declarar explícitamente las `<executions>` con ambos goals. |
| El uber-jar generado con Shade lanza `SecurityException: Invalid signature file digest` al ejecutarlo. | Las firmas criptográficas (`*.SF`, `*.DSA`, `*.RSA`) de las dependencias originales sobreviven en el JAR fusionado y ya no son válidas tras el reempaquetado. | Excluir esos patrones con un `<filter>` en la configuración de Shade (ver ejemplo arriba). |
| `mvn test` pasa en local pero el mismo test falla de forma intermitente en CI. | Tests no aislados que comparten estado (ficheros temporales, puertos, bases de datos en memoria) y Surefire los ejecuta en paralelo o en distinto orden. | Configurar `<forkCount>` y `<reuseForks>` explícitamente en Surefire; aislar el estado de cada test (`@BeforeEach` limpio, recursos por test). |
| El build de Docker reconstruye toda la imagen desde cero cada vez que cambia una línea de código. | Se usa Shade para crear un uber-jar monolítico que cambia entero con cualquier modificación, invalidando el caché de capas de Docker. | Usar `maven-dependency-plugin:copy-dependencies` para separar dependencias (capa estable) del JAR de la aplicación (capa que cambia), y construir el `Dockerfile` en capas correspondientes. |
| Alguien actualiza `maven-compiler-plugin` y el build empieza a fallar con errores de sintaxis de configuración. | Cambios de API entre versiones major del plugin (p. ej. `<compilerArgument>` → `<compilerArgs>`). | Revisar el *release notes* del plugin antes de saltar de versión major, no solo confiar en que "una versión más nueva siempre es compatible". |

# Bloque 5: Proyectos Multi-Módulo

## 1. 🎯 El Gran Cuadro

Un proyecto multi-módulo es una **estructura de un único repositorio (o monorepo) dividida en varios artefactos Maven independientes**, coordinados por un POM padre de tipo `pom` que no genera código por sí mismo, solo orquesta a sus hijos.

**Por qué importa en el mundo real:** a partir de cierto tamaño, un proyecto monolítico en un solo `pom.xml` se vuelve insostenible — compilar todo para cambiar una línea, tests que tardan 40 minutos, equipos que se pisan los cambios en el mismo módulo. Dividir en módulos permite compilar, testear y versionar partes del sistema de forma independiente, sin renunciar a la coordinación centralizada.

> 🧠 **Analogía:** Un proyecto multi-módulo es como una **editorial que publica una colección de libros**. La editorial (el POM padre, `packaging=pom`) no escribe ningún libro ella misma; define el formato común (tamaño de página, tipografía, normas de estilo = propiedades y `dependencyManagement` heredados), pero cada libro (módulo) tiene su propio autor, su propio contenido y se puede reimprimir o corregir de forma independiente sin reeditar toda la colección.

---

## 2. 🧱 Arquitectura y Componentes

### Anatomía de un proyecto multi-módulo

```
mi-proyecto/                  <- POM padre, packaging=pom
├── pom.xml
├── core/                     <- Módulo de lógica de negocio
│   └── pom.xml
├── api/                      <- Módulo de exposición REST (depende de core)
│   └── pom.xml
├── persistence/              <- Módulo de acceso a datos (depende de core)
│   └── pom.xml
└── app/                      <- Módulo ensamblador final (depende de api + persistence)
    └── pom.xml
```

```xml
<!-- mi-proyecto/pom.xml (padre) -->
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>mi-proyecto</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging> <!-- el padre NO produce un JAR -->

    <modules>
        <module>core</module>
        <module>persistence</module>
        <module>api</module>
        <module>app</module>
    </modules>
</project>
```

```xml
<!-- mi-proyecto/api/pom.xml (hijo) -->
<project>
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.example</groupId>
        <artifactId>mi-proyecto</artifactId>
        <version>1.0.0</version>
    </parent>

    <artifactId>api</artifactId>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>com.example</groupId>
            <artifactId>core</artifactId>
            <version>${project.version}</version>
        </dependency>
    </dependencies>
</project>
```

> 🚨 **Distinción que el documento original no marcaba con claridad:** `<modules>` (en el padre) y `<parent>` (en el hijo) son **relaciones distintas y no necesariamente acopladas**:
> - `<modules>` le dice a Maven **qué carpetas construir y en qué orden** cuando ejecutas el build desde la raíz (relación de *agregación* — el llamado **reactor**).
> - `<parent>` le dice a un módulo concreto **de quién hereda configuración** (relación de *herencia*).
>
> En el 90% de los proyectos coinciden (el padre que agrega también es el padre del que se hereda), pero **no es obligatorio**. Puedes tener un POM agregador que no sea el padre de herencia de sus módulos, y viceversa. Confundir agregación con herencia es la causa de bastantes POMs mal diseñados en proyectos grandes.

### El Reactor: cómo Maven decide el orden de construcción

Cuando ejecutas `mvn install` desde la raíz de un proyecto multi-módulo, Maven no construye los módulos en el orden en que aparecen en `<modules>`. Construye un **grafo de dependencias entre módulos** (el *reactor*) y determina el orden topológicamente correcto: si `api` depende de `core`, `core` se construye primero, sin que tengas que ordenarlo tú a mano en el XML.

```bash
# Ver el orden real que el reactor calculará, sin ejecutar nada
mvn validate -pl api -am
```

> 💡 El flag `-am` (*also make*) le dice a Maven: "construye también los módulos de los que `api` depende". El flag `-pl` (*project list*) limita la ejecución a módulos concretos — esencial en monorepos grandes donde reconstruir todo en cada cambio sería absurdamente lento.

---

## 3. 🛠️ Implementación Paso a Paso (Hands-On)

### Diseño: separación de responsabilidades por capa

Estructura recomendada para un servicio típico, con responsabilidad clara de cada módulo:

| Módulo | Responsabilidad | Depende de |
|---|---|---|
| `core` (o `domain`) | Lógica de negocio pura, entidades, sin frameworks. | Nada (o solo librerías de utilidad). |
| `persistence` | Implementación de acceso a datos (JPA, repositorios). | `core` |
| `api` | Controladores REST, DTOs, serialización. | `core` |
| `app` | Módulo ensamblador: arranca la aplicación, junta `api` + `persistence`. | `api`, `persistence` |

> ⚠️ **Regla de diseño que el original mencionaba en abstracto sin dar el criterio práctico:** si `core` empieza a depender de `persistence` o de `api`, tienes una **dependencia circular a nivel de arquitectura**, aunque Maven no te deje crear un ciclo real entre módulos (el reactor lo detectaría y fallaría). La señal de alarma es más sutil: significa que tu "núcleo de negocio" está acoplado a detalles de infraestructura, lo cual rompe el principio de que el dominio no debería saber cómo se persiste ni cómo se expone por HTTP.

### Construir solo un módulo y sus dependencias (sin reconstruir todo)

```bash
# Construye SOLO 'api' y los módulos de los que depende, sin tocar el resto
mvn install -pl api -am

# Construye 'api' y todos los módulos que DEPENDEN de 'api' (para validar impacto de un cambio)
mvn install -pl api -amd
```

> 🧠 **Analogía:** `-am` (*also make*) es "tráeme los ingredientes que necesito"; `-amd` (*also make dependents*) es "avísame a quién más le afecta si cambio esta receta". En un monorepo con 30 módulos, usar siempre `mvn install` sin filtros es como repintar la casa entera porque cambiaste el color de una puerta — funciona, pero es brutalmente ineficiente.

### Empaquetado y despliegue: las dos estrategias reales

```xml
<!-- Estrategia A: cada módulo se despliega como artefacto independiente -->
<!-- api/pom.xml -->
<packaging>jar</packaging>
<distributionManagement>
    <repository>
        <id>internal-releases</id>
        <url>https://nexus.miempresa.com/repository/releases/</url>
    </repository>
</distributionManagement>
```

```bash
mvn deploy -pl api    # solo despliega el módulo api, versionado de forma independiente
```

```xml
<!-- Estrategia B: ensamblado final único que empaqueta todo junto -->
<!-- app/pom.xml -->
<packaging>jar</packaging>
<dependencies>
    <dependency>
        <groupId>com.example</groupId>
        <artifactId>api</artifactId>
        <version>${project.version}</version>
    </dependency>
    <dependency>
        <groupId>com.example</groupId>
        <artifactId>persistence</artifactId>
        <version>${project.version}</version>
    </dependency>
</dependencies>
<!-- + maven-shade-plugin o spring-boot-maven-plugin para generar
     un único artefacto desplegable -->
```

| Estrategia | Cuándo usarla | Trade-off |
|---|---|---|
| **A — Módulos independientes** | Cuando otros equipos/proyectos consumen tus módulos como librerías (p. ej., `core` lo usa también otro microservicio). | Más flexible, pero requiere disciplina de versionado: si `core` rompe compatibilidad, todos sus consumidores se ven afectados. |
| **B — Ensamblado único** | Microservicio autocontenido que se despliega como una unidad (un solo JAR/contenedor). | Más simple operativamente, pero pierdes la capacidad de reutilizar módulos individuales fuera de este proyecto. |

### Versionado en proyectos multi-módulo

```xml
<!-- Todos los módulos hijos heredan automáticamente esta versión del padre -->
<parent>
    <groupId>com.example</groupId>
    <artifactId>mi-proyecto</artifactId>
    <version>1.4.0</version> <!-- cambia aquí, se propaga a todos -->
</parent>
```

Para actualizar la versión de TODOS los módulos a la vez sin editar cada `pom.xml` a mano:

```bash
mvn versions:set -DnewVersion=1.5.0
# Confirmada la actualización correcta:
mvn versions:commit
# Si algo salió mal, revertir:
mvn versions:revert
```

---

## 4. 🚨 Errores Comunes y Buenas Prácticas

| Problema en producción | Causa raíz | Solución |
|---|---|---|
| Cambiar una línea en un módulo dispara la reconstrucción de los 30 módulos del monorepo en CI, builds de 25+ minutos. | El pipeline de CI ejecuta `mvn install` desde la raíz sin filtros, ignorando el reactor de dependencias real. | Usar `-pl <módulo> -amd` para construir solo lo afectado; integrar detección de cambios (p. ej., comparando contra la rama base) para decidir qué módulos tocar. |
| El módulo `core` termina con un `import` de una clase de `persistence`, generando una dependencia circular conceptual. | Falta de disciplina arquitectónica: nadie revisó que la dirección de dependencias respetara la separación de capas. | Reforzar la regla con `maven-enforcer-plugin` y la regla `bannedDependencies`, o con herramientas de análisis de arquitectura como ArchUnit en los tests. |
| Dos módulos hermanos (`api` y `persistence`) declaran versiones distintas de la misma librería transitiva. | No existe `dependencyManagement` centralizado en el POM padre — cada módulo gestiona sus versiones por su cuenta. | Centralizar TODAS las versiones compartidas en `dependencyManagement` del padre (ver Bloque 2). |
| Tras un `mvn versions:set`, algunos módulos quedan con la versión antigua y otros con la nueva. | Edición manual parcial de versiones, o un módulo no estaba listado correctamente en `<modules>` del padre y quedó huérfano del proceso. | Usar siempre `versions-maven-plugin` para cambios de versión masivos, nunca editar a mano módulo por módulo; verificar con `mvn versions:commit` que el cambio se aplicó en TODOS los POMs antes de hacer commit en Git. |

---

# Bloque 6: Gestión de Repositorios

## 1. 🎯 El Gran Cuadro

Un repositorio Maven es un **almacén de artefactos** (JAR, WAR, POM, y sus metadatos) organizado según las coordenadas `groupId:artifactId:version`. Maven nunca "busca" una librería de forma ambigua: siempre resuelve una ruta exacta y predecible dentro de un repositorio, basada en esas coordenadas.

**Por qué importa a nivel de arquitectura:** la elección de qué repositorios usa tu organización —y en qué orden los consulta— determina la velocidad de tus builds, tu exposición a riesgos de cadena de suministro de software (*supply chain attacks*) y tu capacidad de operar sin depender de internet.

> 🧠 **Analogía:** Piensa en los repositorios como una jerarquía de **bibliotecas**. Tu repositorio **local** es la estantería de tu propia mesa de estudio — lo que ya tienes a mano, sin desplazarte. El repositorio **central** es la biblioteca pública nacional — inmensa, abierta a cualquiera, pero no la controlas tú. El repositorio **privado de empresa** es la biblioteca interna de tu compañía: tiene copias de la biblioteca pública (cacheadas, para no depender de internet) y además libros que solo existen ahí dentro (vuestras propias librerías internas).

---

## 2. 🧱 Arquitectura y Componentes

### Los cuatro niveles, y el orden real en que Maven los consulta

| Tipo | Ubicación | Quién lo gestiona | Maven lo consulta... |
|---|---|---|---|
| **Local** | `~/.m2/repository` (Unix/macOS) o `C:\Users\<usuario>\.m2\repository` (Windows) | Automáticamente, por Maven, en cada máquina. | **Primero, siempre.** Si el artefacto exacto ya está aquí, no se descarga nada. |
| **Remoto / Central** | `repo.maven.apache.org` (Maven Central). | La comunidad Apache / Sonatype. | Si no está en local, y no hay un repositorio privado configurado que lo intercepte. |
| **Privado de empresa** | Nexus, Artifactory, GitHub Packages — alojado por tu organización. | Tu equipo de plataforma/DevOps. | Depende de cómo se configure: como repositorio adicional, o como **mirror** que sustituye por completo el acceso directo a Central. |

> 🚨 **Matiz que el documento original no explicaba y es operativamente importante:** un repositorio privado puede configurarse de dos formas muy distintas, con implicaciones de seguridad opuestas:
> - **Como repositorio adicional** (`<repositories>`): Maven consulta primero el privado, y si no encuentra el artefacto, **va directamente a Internet** (Maven Central) sin pasar por tu empresa.
> - **Como mirror** (`<mirrors>` en `settings.xml`): Maven **nunca contacta directamente con Internet**; todo pasa por el repositorio interno, que a su vez actúa de *proxy* cacheado hacia Central.
>
> La segunda opción es la práctica estándar en cualquier empresa con políticas de seguridad serias: te permite **auditar y bloquear** artefactos antes de que lleguen a un desarrollador, y evita que un build dependa de que Maven Central esté disponible en ese instante.

### Repositorio local: más que una simple caché

```
~/.m2/repository/
└── org/
    └── apache/
        └── commons/
            └── commons-lang3/
                ├── 3.17.0/
                │   ├── commons-lang3-3.17.0.jar
                │   ├── commons-lang3-3.17.0.pom
                │   └── _remote.repositories
```

La ruta se construye determinísticamente desde las coordenadas GAV: `groupId` con los puntos convertidos en `/`, luego `artifactId`, luego `version`. Esto es lo que permite que `mvn install` simplemente copie el artefacto a la ruta calculada, sin necesidad de ningún índice adicional.

---

## 3. 🛠️ Implementación Paso a Paso (Hands-On)

### Configurar un repositorio privado como mirror (recomendado en empresa)

```xml
<!-- ~/.m2/settings.xml -->
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.xsd">
    <mirrors>
        <mirror>
            <id>empresa-mirror</id>
            <!-- mirrorOf=* intercepta TODAS las peticiones, incluso a Central -->
            <mirrorOf>*</mirrorOf>
            <url>https://nexus.miempresa.com/repository/maven-public/</url>
        </mirror>
    </mirrors>

    <servers>
        <server>
            <id>empresa-mirror</id>
            <username>${env.NEXUS_USER}</username>
            <password>${env.NEXUS_PASSWORD}</password>
        </server>
    </servers>
</settings>
```

> 🚨 **Corrección de seguridad respecto al documento original:** el original mostraba credenciales en texto plano (`<password>prod-password</password>`) directamente en el XML. **Esto es una mala práctica grave** que nunca debería aparecer ni en un ejemplo educativo, porque normaliza un patrón peligroso. En su lugar:
> - Usa **variables de entorno** (`${env.NEXUS_PASSWORD}`), inyectadas por el sistema de CI/CD (GitHub Actions Secrets, Vault, etc.), nunca commiteadas en el repositorio Git.
> - Para credenciales gestionadas localmente, Maven ofrece **cifrado nativo** vía `settings-security.xml`:
> ```bash
> # Genera una contraseña maestra cifrada (una sola vez, por desarrollador)
> mvn --encrypt-master-password
> # Cifra la contraseña real de un servidor usando esa clave maestra
> mvn --encrypt-password
> ```
> El resultado se referencia en `settings.xml` como `{COQLCE6DU6GtcS5P=}`, nunca como texto plano.

### Configurar un repositorio privado como repositorio adicional (no mirror)

Útil cuando solo necesitas exponer artefactos internos sin interceptar el tráfico hacia Central:

```xml
<!-- pom.xml -->
<repositories>
    <repository>
        <id>empresa-releases</id>
        <url>https://nexus.miempresa.com/repository/releases/</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>false</enabled> <!-- evita resolver SNAPSHOTs en builds de release -->
        </snapshots>
    </repository>
</repositories>
```

### Publicar (`deploy`) en un repositorio privado

```xml
<!-- pom.xml -->
<distributionManagement>
    <repository>
        <id>empresa-releases</id>
        <url>https://nexus.miempresa.com/repository/releases/</url>
    </repository>
    <snapshotRepository>
        <id>empresa-snapshots</id>
        <url>https://nexus.miempresa.com/repository/snapshots/</url>
    </snapshotRepository>
</distributionManagement>
```

```bash
mvn deploy
```

> 💡 **Nota práctica:** el `id` usado en `<distributionManagement>` debe coincidir exactamente con el `id` de un `<server>` en `settings.xml` para que Maven sepa qué credenciales usar al publicar. Es una fuente común de error: si los IDs no coinciden, Maven intentará publicar sin autenticación y fallará con un 401.

---

## 4. 🚨 Errores Comunes y Buenas Prácticas

| Problema en producción | Causa raíz | Solución |
|---|---|---|
| El build falla en CI con "Could not resolve dependencies" pese a que el artefacto existe en Maven Central. | El repositorio interno está configurado como `mirrorOf=*` pero no tiene configurado un proxy/cache hacia Central, o ese proxy está caído. | Verificar la configuración del *proxy repository* en Nexus/Artifactory; tener un plan de contingencia (mirror secundario) documentado. |
| Credenciales de un repositorio privado expuestas en un repositorio Git público por error. | Contraseña en texto plano directamente en `pom.xml` o `settings.xml` versionado. | Nunca commitear `settings.xml` con credenciales reales; usar variables de entorno o el cifrado nativo de Maven (`settings-security.xml`); rotar la credencial expuesta inmediatamente. |
| Un build de "release" termina usando, sin que nadie se diera cuenta, una dependencia `SNAPSHOT` inestable. | El repositorio de snapshots está habilitado (`<snapshots><enabled>true</enabled></snapshots>`) en un contexto donde no debería estarlo. | Deshabilitar snapshots en los repositorios usados para builds de release; combinar con `maven-enforcer-plugin` y la regla `requireReleaseDeps` (ver Bloque 2). |
| `mvn deploy` falla con error 401 aunque las credenciales en `settings.xml` son correctas. | El `id` del `<server>` en `settings.xml` no coincide exactamente (mayúsculas, guiones) con el `id` declarado en `<distributionManagement>` del POM. | Verificar que ambos IDs sean idénticos carácter por carácter. |

---

# Bloque 7: Perfiles

## 1. 🎯 El Gran Cuadro

Un perfil (`<profile>`) es un **bloque de configuración condicional** dentro de Maven: un conjunto de propiedades, dependencias, plugins o repositorios que solo se activan si se cumple cierta condición (un flag manual, una propiedad de sistema, el sistema operativo, la presencia de un archivo...).

**Por qué existen:** sin perfiles, cualquier diferencia entre entornos (dev, test, producción) te obligaría a mantener varios `pom.xml` distintos, o a editar el mismo archivo cada vez que cambias de contexto — ambas opciones son frágiles y propensas a errores humanos.

> 🧠 **Analogía:** Un perfil es como un **interruptor de modo en una cámara de fotos**. La cámara (el POM base) es la misma, pero seleccionar "modo retrato" o "modo paisaje" (el perfil activo) cambia automáticamente apertura, ISO y velocidad de obturación (propiedades, dependencias, configuraciones) sin que tengas que ajustar cada parámetro manualmente cada vez.

---

## 2. 🧱 Arquitectura y Componentes

### Dos ubicaciones posibles, con alcance muy distinto

| | Perfil en `pom.xml` | Perfil en `settings.xml` |
|---|---|---|
| **Alcance** | Específico de ESTE proyecto. Se versiona en Git, lo ve todo el equipo. | Específico de ESTA máquina/usuario. No se versiona, no lo ve nadie más. |
| **Caso de uso típico** | Cambiar dependencias o plugins según el entorno de build (`dev` vs `prod`). | Credenciales personales, rutas locales, configuración de proxy de un desarrollador concreto. |
| **¿Debería contener secretos?** | **Nunca** — se sube a Git. | Es el lugar correcto, combinado con cifrado nativo (ver Bloque 6). |

> 🚨 **Error conceptual frecuente que el original no aclaraba:** mezclar ambos alcances es una fuente típica de bugs de "funciona en mi máquina". Si un perfil que debería ser **del proyecto** (p. ej., qué base de datos usar en `test`) se define solo en el `settings.xml` personal de un desarrollador, **nadie más en el equipo lo tendrá**, y el build fallará de forma inconsistente entre máquinas. Regla simple: si afecta a cómo se construye el proyecto, va en `pom.xml`; si afecta solo a credenciales o configuración personal de la máquina, va en `settings.xml`.

### Mecanismos de activación

| Mecanismo | Ejemplo | Activación |
|---|---|---|
| Manual, por línea de comandos | `<id>prod</id>` | `mvn install -Pprod` |
| Propiedad de sistema | `<activation><property><name>env</name><value>test</value></property></activation>` | `mvn install -Denv=test` |
| Activo por defecto | `<activation><activeByDefault>true</activeByDefault></activation>` | Se activa solo si **ningún otro perfil** se activa explícitamente. |
| Presencia de un archivo | `<activation><file><exists>src/main/resources/prod.yml</exists></file></activation>` | Automático, sin flags — útil para detectar configuraciones de entorno ya presentes. |
| Sistema operativo | `<activation><os><family>windows</family></os></activation>` | Automático, según el SO donde corre el build. |

> ⚠️ **Trampa común con `activeByDefault`:** este perfil **deja de activarse en cuanto activas cualquier otro perfil manualmente**, incluso si no tienen relación entre sí. Si tu perfil `development` tiene `activeByDefault=true` y alguien ejecuta `mvn install -PotroPerfilCualquiera`, `development` se desactiva silenciosamente — no es aditivo, es excluyente por defecto salvo que se diseñe explícitamente para coexistir.

---

## 3. 🛠️ Implementación Paso a Paso (Hands-On)

### Perfiles por entorno en el POM (caso de uso más común)

```xml
<profiles>
    <profile>
        <id>development</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <db.url>jdbc:h2:mem:dev</db.url>
            <logging.level>DEBUG</logging.level>
        </properties>
    </profile>

    <profile>
        <id>production</id>
        <properties>
            <db.url>jdbc:postgresql://prod-db-server:5432/prod</db.url>
            <logging.level>WARN</logging.level>
        </properties>
        <build>
            <plugins>
                <!-- Plugins de calidad/seguridad que solo quieres
                     ejecutar (y que ralenticen el build) en release real -->
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-enforcer-plugin</artifactId>
                    <version>3.6.3</version>
                    <executions>
                        <execution>
                            <goals>
                                <goal>enforce</goal>
                            </goals>
                            <configuration>
                                <rules>
                                    <requireReleaseDeps/>
                                </rules>
                            </configuration>
                        </execution>
                    </executions>
                </plugin>
            </plugins>
        </build>
    </profile>
</profiles>
```

```bash
# Build normal de desarrollo (activeByDefault se aplica solo)
mvn clean install

# Build de producción explícito
mvn clean install -Pproduction
```

### Perfiles a nivel de `settings.xml` (credenciales y configuración local)

```xml
<!-- ~/.m2/settings.xml -->
<settings>
    <profiles>
        <profile>
            <id>nexus-empresa</id>
            <repositories>
                <repository>
                    <id>empresa-releases</id>
                    <url>https://nexus.miempresa.com/repository/releases/</url>
                </repository>
            </repositories>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>nexus-empresa</activeProfile>
    </activeProfiles>
</settings>
```

> 💡 Nota la diferencia con el POM: en `settings.xml` puedes forzar la activación con `<activeProfiles>` directamente, sin depender de flags de línea de comandos — útil para que un perfil esté **siempre** activo para un desarrollador concreto, en todos sus proyectos.

### Combinar perfiles con ejecución condicional de plugins

```xml
<profile>
    <id>skip-tests-fast-build</id>
    <properties>
        <skipTests>true</skipTests>
    </properties>
</profile>
```

```bash
mvn install -Pskip-tests-fast-build
```

> 🚨 **Advertencia de buena práctica, no en el original:** un perfil que salta tests es razonable para iteración local rápida, pero **nunca debería poder activarse por accidente en un pipeline de CI/CD que construye un artefacto de release**. Si necesitas builds rápidos en CI para feedback temprano, sepáralos claramente en etapas distintas del pipeline (build rápido sin tests → build completo con tests → release), nunca dependas de que alguien "se olvide" de pasar el flag.

---

## 4. 🚨 Errores Comunes y Buenas Prácticas

| Problema en producción | Causa raíz | Solución |
|---|---|---|
| El perfil de desarrollo deja de aplicarse sin que nadie cambiara nada en el POM. | Alguien activó otro perfil con `-P` en el comando de build, lo que desactiva silenciosamente el `activeByDefault`. | Documentar explícitamente qué perfiles son mutuamente excluyentes; considerar nombrar los perfiles de forma que su propósito sea inequívoco en logs de CI. |
| Un desarrollador nuevo en el equipo no consigue compilar el proyecto: "falta una propiedad". | El perfil necesario está definido solo en el `settings.xml` personal de otro desarrollador, nunca se documentó ni se subió al repositorio. | Mover cualquier perfil que afecte al *build* del proyecto (no a credenciales personales) al `pom.xml`, versionado en Git. |
| Un build de "producción" se ejecutó accidentalmente con tests deshabilitados. | Un perfil de conveniencia (`skip-tests`) quedó disponible sin restricción en el mismo pipeline que genera artefactos de release. | Separar etapas de CI/CD claramente; no dejar perfiles de "atajo" accesibles en pipelines de release; usar `maven-enforcer-plugin` para bloquear builds con `skipTests=true` en la rama de producción si es necesario. |
| Dos perfiles definen la misma propiedad con valores distintos y ambos se activan a la vez. | Activación simultánea por distintos mecanismos (uno por `-P`, otro por `activeByDefault` que no se desactivó como se esperaba en alguna versión de Maven). | Evitar solapamiento de propiedades entre perfiles que puedan coexistir; si dos perfiles son mutuamente excluyentes por diseño, verificarlo explícitamente en el pipeline (`mvn help:active-profiles`). |

---

# Bloque 8: La Carpeta `target/` y `settings.xml`

## 1. 🎯 El Gran Cuadro

`target/` es el directorio donde Maven deposita **todo lo generado durante el build**: clases compiladas, artefactos empaquetados, reportes, logs. Es completamente desechable y regenerable — nunca debería contener nada que necesites conservar manualmente. `settings.xml`, en cambio, es donde vive la configuración **del entorno de Maven en esa máquina**: rutas, proxies, credenciales, perfiles activos — todo lo que no pertenece al proyecto en sí, sino a cómo *ese desarrollador o ese servidor de CI* ejecuta Maven.

**Por qué la distinción importa:** confundir "configuración del proyecto" (POM) con "configuración del entorno" (`settings.xml`) es la causa de buena parte de los problemas de portabilidad entre máquinas de un equipo.

> 🧠 **Analogía:** `target/` es la **mesa de trabajo de un taller de carpintería** — llena de virutas, piezas a medio montar y el mueble final, pero que se barre y queda vacía cada vez que empiezas un mueble nuevo. `settings.xml` es la **caja de herramientas personal** del carpintero: sus propias llaves de acceso al almacén de materiales, configurada una vez, que usa para *cualquier* mueble que construya, no solo para el actual.

---

## 2. 🧱 Arquitectura y Componentes

### Estructura real de `target/`

```
target/
├── classes/              # .class compilados de src/main/java
├── test-classes/         # .class compilados de src/test/java
├── generated-sources/    # código generado por plugins (p. ej. anotaciones)
├── maven-status/         # metadatos internos de Maven sobre el estado del build
├── maven-archiver/       # metadatos del manifiesto del JAR/WAR generado
├── surefire-reports/     # resultados de tests unitarios (XML + texto)
├── site/                 # documentación generada por 'mvn site'
└── mi-proyecto-1.0.0.jar # el artefacto final empaquetado
```

> ⚠️ **Corrección respecto al original:** el documento original listaba una carpeta `logs/` dentro de `target/` como si fuera estándar — **no lo es**. Maven no genera una carpeta `logs/` por defecto; lo que sí existe de forma estándar es `surefire-reports/` (resultados de test) y, si usas JaCoCo, `site/jacoco/`. Si ves logs ahí, es porque algún plugin específico (o tu propia configuración de logging de aplicación) los está escribiendo ahí, no porque sea un comportamiento nativo de Maven.

> 🚨 **Regla no negociable:** `target/` **nunca** debe subirse a control de versiones. Si tu `.gitignore` no excluye esta carpeta, cualquier compañero que clone el repo arrastrará binarios obsoletos que pueden enmascarar errores reales de compilación.
> ```gitignore
> target/
> ```

### `settings.xml`: global vs local, y cómo se combinan

| | Configuración global | Configuración local (usuario) |
|---|---|---|
| **Ubicación** | `<directorio-instalación-maven>/conf/settings.xml` | `~/.m2/settings.xml` |
| **Afecta a** | Todos los usuarios de esa máquina. | Solo al usuario actual. |
| **Prioridad si hay conflicto** | Menor — el local la sobrescribe. | **Mayor** — siempre gana sobre la global si ambas definen la misma propiedad. |

Las propiedades configurables principales:

| Propiedad | Función |
|---|---|
| `localRepository` | Ruta del repositorio local (por defecto `~/.m2/repository`). |
| `offline` | Si `true`, Maven nunca intenta contactar repositorios remotos — falla si falta algo en local. |
| `proxies` | Configuración de proxy HTTP/HTTPS corporativo. |
| `mirrors` | Redirige peticiones de repositorio (ver Bloque 6). |
| `servers` | Credenciales de autenticación por `id` de repositorio. |
| `profiles` / `activeProfiles` | Perfiles específicos del usuario (ver Bloque 7). |

---

## 3. 🛠️ Implementación Paso a Paso (Hands-On)

### Modificar la ubicación del repositorio local

Útil cuando el disco del sistema tiene poco espacio, o en entornos CI donde quieres apuntar el repositorio local a un volumen persistente cacheado entre builds.

```xml
<!-- ~/.m2/settings.xml -->
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.xsd">
    <localRepository>/data/maven-repo</localRepository>
</settings>
```

> 💡 **Aplicación real en CI/CD:** en pipelines de GitLab CI o GitHub Actions, es común sobreescribir esta ruta vía variable de entorno o flag, en lugar de editar `settings.xml`, para apuntar a un volumen de caché entre ejecuciones del pipeline:
> ```bash
> mvn install -Dmaven.repo.local=/cache/.m2/repository
> ```
> Esto evita que cada ejecución del pipeline tenga que re-descargar todas las dependencias desde cero, acelerando drásticamente los tiempos de CI.

### Configurar Maven detrás de un proxy corporativo

```xml
<proxies>
    <proxy>
        <id>proxy-corporativo</id>
        <active>true</active>
        <protocol>http</protocol>
        <host>proxy.miempresa.com</host>
        <port>8080</port>
        <username>${env.PROXY_USER}</username>
        <password>${env.PROXY_PASSWORD}</password>
        <nonProxyHosts>localhost|*.miempresa.com</nonProxyHosts>
    </proxy>
</proxies>
```

> 🚨 **Misma corrección de seguridad que en bloques anteriores:** nunca texto plano. Variables de entorno o cifrado nativo (`mvn --encrypt-password`), siempre.

### Ubicaciones predeterminadas, por sistema operativo

| | Repositorio local | `settings.xml` |
|---|---|---|
| Linux/macOS | `~/.m2/repository` | `~/.m2/settings.xml` |
| Windows | `C:\Users\<usuario>\.m2\repository` | `C:\Users\<usuario>\.m2\settings.xml` |

---

## 4. 🚨 Errores Comunes y Buenas Prácticas

| Problema en producción | Causa raíz | Solución |
|---|---|---|
| `target/` ocupa varios GB y ralentiza operaciones de Git/IDE. | Carpeta no excluida de `.gitignore`, o herramientas del IDE indexándola innecesariamente. | Excluir `target/` en `.gitignore` y en la configuración de indexación del IDE. |
| Un build "limpio" (`mvn clean install`) sigue mostrando comportamiento de un build anterior. | Algún plugin de terceros escribe fuera de `target/` (caché propia, fuera del control de `maven-clean-plugin`). | Identificar qué plugin genera ese estado persistente y limpiarlo explícitamente, o configurar `maven-clean-plugin` con `<filesets>` adicionales. |
| El pipeline de CI tarda 10+ minutos solo descargando dependencias, en cada ejecución. | El repositorio local (`~/.m2`) no persiste entre ejecuciones del runner de CI — cada build empieza desde cero. | Configurar caché del pipeline (`cache:` en GitLab CI, `actions/cache` en GitHub Actions) apuntando al directorio del repositorio local. |
| Maven falla con error de conexión en una red corporativa, pese a tener internet. | Falta configuración de proxy en `settings.xml`, o el proxy está mal configurado y Maven intenta ir directo a Internet. | Configurar `<proxies>` correctamente; verificar con `mvn -X` (modo debug) qué URL exacta está intentando contactar. |
