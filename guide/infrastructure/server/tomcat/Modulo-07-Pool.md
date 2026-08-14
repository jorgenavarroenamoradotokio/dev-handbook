> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Arquitectura JNDI en Tomcat](#1-arquitectura-jndi-en-tomcat)
  - [¿Por qué necesitamos un pool de conexiones?](#por-qué-necesitamos-un-pool-de-conexiones)
  - [¿Qué es JNDI y por qué se usa para el pool?](#qué-es-jndi-y-por-qué-se-usa-para-el-pool)
  - [Jerarquía del árbol JNDI en Tomcat](#jerarquía-del-árbol-jndi-en-tomcat)
  - [Lookup de recursos JNDI en código Java](#lookup-de-recursos-jndi-en-código-java)
- [2. Implementaciones de Pool de Conexiones en Tomcat](#2-implementaciones-de-pool-de-conexiones-en-tomcat)
  - [Comparativa de rendimiento](#comparativa-de-rendimiento)
- [3. Configuración con Apache DBCP2](#3-configuración-con-apache-dbcp2)
  - [Configuración completa en Context descriptor](#configuración-completa-en-context-descriptor)
  - [Configuración para múltiples bases de datos](#configuración-para-múltiples-bases-de-datos)
- [4. Configuración con Tomcat JDBC Pool](#4-configuración-con-tomcat-jdbc-pool)
  - [Configuración completa](#configuración-completa)
  - [Interceptor personalizado para auditoría](#interceptor-personalizado-para-auditoría)
- [5. Configuración con HikariCP (Externa)](#5-configuración-con-hikaricp-externa)
  - [Configuración via Context descriptor con factory personalizado](#configuración-via-context-descriptor-con-factory-personalizado)
  - [Configuración programática con ServletContextListener](#configuración-programática-con-servletcontextlistener)
- [6. Recursos JNDI Globales y ResourceLink](#6-recursos-jndi-globales-y-resourcelink)
  - [¿Cuándo usar recursos globales?](#cuándo-usar-recursos-globales)
  - [Definición de recursos globales](#definición-de-recursos-globales)
  - [ResourceLink: conectar recursos globales con aplicaciones](#resourcelink-conectar-recursos-globales-con-aplicaciones)
- [7. Monitorización del Pool de Conexiones](#7-monitorización-del-pool-de-conexiones)
  - [¿Por qué monitorizar el pool?](#por-qué-monitorizar-el-pool)
  - [Monitorización via JMX](#monitorización-via-jmx)
  - [Endpoint de health check del pool](#endpoint-de-health-check-del-pool)
- [8. Anti-Patrones y Problemas Comunes del Pool](#8-anti-patrones-y-problemas-comunes-del-pool)
  - [Connection Leak — Conexión no devuelta al pool](#connection-leak--conexión-no-devuelta-al-pool)
  - [Pool Exhaustion bajo carga](#pool-exhaustion-bajo-carga)
  - [Tabla de síntomas y diagnóstico](#tabla-de-síntomas-y-diagnóstico)
- [9. Configuración de JNDI para Otros Recursos](#9-configuración-de-jndi-para-otros-recursos)
  - [JavaMail Session](#javamail-session)
  - [Variable de entorno JNDI](#variable-de-entorno-jndi)
- [10. Diferencias de JNDI y Pools entre Versiones de Tomcat](#10-diferencias-de-jndi-y-pools-entre-versiones-de-tomcat)
- [11. Puntos Clave](#11-puntos-clave)

---

# 1. Arquitectura JNDI en Tomcat

## ¿Por qué necesitamos un pool de conexiones?

Antes de entrar en la arquitectura, es necesario entender el problema que resuelve.

Cuando tu aplicación necesita leer o escribir datos en una base de datos, debe establecer una **conexión TCP** con el servidor de BD. Abrir esa conexión es costoso: implica la negociación TCP (three-way handshake), autenticación con el servidor de BD, negociación de parámetros de sesión, etc. Este proceso puede tardar entre 20 y 100 milisegundos según la red y el servidor.

Si tu aplicación abre una conexión nueva para cada petición HTTP y la cierra al terminar, con 200 peticiones concurrentes estarías abriendo y cerrando 200 conexiones simultáneamente. Esto satura el servidor de BD, desperdicia tiempo y degrada el rendimiento de toda la aplicación.

Un **pool de conexiones** resuelve esto manteniendo un conjunto de conexiones ya abiertas y listas para usar. Cuando tu código necesita una conexión, la *toma prestada* del pool (operación instantánea); cuando termina, la *devuelve* al pool (no la cierra). La conexión vuelve al pool disponible para la siguiente petición.

## ¿Qué es JNDI y por qué se usa para el pool?

**JNDI** (*Java Naming and Directory Interface*) es un servicio de nombres estándar de Java EE / Jakarta EE. Funciona como una "guía telefónica" o "registro" donde los objetos Java se registran bajo un nombre, y los consumidores los buscan por ese nombre sin saber cómo están implementados.

En el contexto del pool de conexiones, JNDI desacopla la **configuración** del pool (que la hace el administrador del servidor en `context.xml` o `server.xml`) del **uso** del pool (que hace el desarrollador en el código Java). El desarrollador solo conoce el nombre JNDI (`jdbc/AppDB`); no necesita saber si se usa DBCP2, HikariCP, o cualquier otra implementación, ni las credenciales de la BD, ni el número de conexiones del pool.

Este desacoplamiento tiene ventajas prácticas: se puede cambiar la implementación del pool, mover la BD o cambiar contraseñas sin tocar el código de la aplicación, solo modificando la configuración del servidor.

## Jerarquía del árbol JNDI en Tomcat

El espacio de nombres JNDI en Tomcat tiene una estructura jerárquica similar a un sistema de archivos:

```
java:
├── comp/
│   └── env/                          ← Espacio de nombres de la aplicación
│       ├── jdbc/
│       │   ├── AppDB                 ← DataSource local al Context
│       │   └── SharedDB              ← ResourceLink a recurso global
│       ├── mail/
│       │   └── Session               ← JavaMail Session
│       ├── jms/
│       │   ├── ConnectionFactory
│       │   └── Queue/MyQueue
│       └── bean/
│           └── MyEJB
└── global/                           ← Recursos globales del servidor
    └── jdbc/
        └── GlobalDB                  ← DataSource global (GlobalNamingResources)
```

**`java:comp/env/`**: Es el espacio de nombres *local* de cada aplicación web. Los recursos definidos en el `context.xml` de una aplicación específica se registran aquí. Son accesibles solo desde esa aplicación. El prefijo completo de un recurso siempre es `java:comp/env/nombre-del-recurso`.

**`java:global/`** (o `GlobalNamingResources`): Son recursos definidos a nivel de servidor en `server.xml`. Son accesibles desde cualquier aplicación del servidor, pero las aplicaciones no acceden a ellos directamente — lo hacen a través de un `ResourceLink` que los "proyecta" en su propio `java:comp/env/`.

## Lookup de recursos JNDI en código Java

El siguiente ejemplo muestra el patrón estándar para usar el pool de conexiones en un DAO (*Data Access Object*):

```java
package com.miempresa.dao;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

/**
 * Patrón DAO con lookup JNDI del DataSource.
 * El lookup se realiza UNA SOLA VEZ en la inicialización
 * y se cachea en la variable de instancia.
 */
public class UserDao {

    private static final Logger log =
        Logger.getLogger(UserDao.class.getName());

    // Nombre JNDI del DataSource (relativo a java:comp/env/)
    private static final String DATASOURCE_JNDI = "jdbc/AppDB";

    // Guardar la referencia al DataSource como variable de instancia.
    // El DataSource (el pool en sí) es thread-safe y puede compartirse
    // entre hilos. Lo que NO se comparte son las conexiones individuales
    // obtenidas del pool.
    private final DataSource dataSource;

    public UserDao() {
        this.dataSource = lookupDataSource();
    }

    private DataSource lookupDataSource() {
        try {
            // InitialContext: Punto de entrada al árbol JNDI de Tomcat.
            // Solo funciona dentro de una aplicación desplegada en Tomcat;
            // lanzará NamingException si se llama fuera de un contenedor.
            Context initCtx = new InitialContext();

            // Navegar al subcontexto "java:comp/env" (el espacio de nombres
            // de esta aplicación). Equivale a entrar en una carpeta del árbol.
            Context envCtx = (Context) initCtx.lookup("java:comp/env");

            // Buscar el DataSource por su nombre dentro de java:comp/env.
            // Tomcat devuelve el objeto DataSource configurado en context.xml.
            DataSource ds = (DataSource) envCtx.lookup(DATASOURCE_JNDI);
            log.info("DataSource JNDI obtenido: " + DATASOURCE_JNDI);
            return ds;

        } catch (NamingException e) {
            // NamingException significa que el recurso no existe en JNDI.
            // Causas comunes:
            //   - El nombre en context.xml no coincide con DATASOURCE_JNDI
            //   - La aplicación no tiene <resource-ref> en web.xml
            //   - El driver JDBC no está en $CATALINA_HOME/lib/
            throw new RuntimeException(
                "No se pudo obtener el DataSource JNDI: " + DATASOURCE_JNDI, e
            );
        }
    }

    /**
     * Patrón correcto de uso del pool de conexiones.
     * 
     * REGLA FUNDAMENTAL: Cada Connection, Statement y ResultSet debe
     * cerrarse después de su uso. El try-with-resources de Java garantiza
     * que el método close() se llama SIEMPRE, incluso si se lanza una
     * excepción en cualquier punto del bloque.
     * 
     * Cuando llamas a conn.close() en una conexión del pool, en realidad
     * NO se cierra la conexión TCP. El pool la recoge y la pone de nuevo
     * disponible. Si no llamas a close(), la conexión queda "prestada"
     * indefinidamente (connection leak) hasta que el pool agota sus
     * conexiones y comienza a rechazar peticiones.
     */
    public User findById(Long id) throws SQLException {
        String sql = "SELECT id, username, email, created_at " +
                     "FROM app_users WHERE id = ? AND enabled = TRUE";

        // try-with-resources abre los tres recursos y los cierra en orden
        // inverso (ResultSet → PreparedStatement → Connection) tanto en
        // el camino normal como si se lanza una excepción.
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Parámetro posicional: evita SQL Injection.
            // El driver JDBC envía la query y los parámetros por separado;
            // el servidor de BD nunca interpreta los parámetros como SQL.
            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
                return null; // Usuario no encontrado
            }
        }
        // La conexión se devuelve AUTOMÁTICAMENTE al pool aquí,
        // gracias al try-with-resources
    }

    public void save(User user) throws SQLException {
        String sql = "INSERT INTO app_users " +
                     "(username, email, password_hash, created_at) " +
                     "VALUES (?, ?, ?, NOW())";

        try (Connection conn = dataSource.getConnection()) {
            // Desactivar autocommit para manejar la transacción manualmente.
            // Por defecto, cada statement se confirma automáticamente.
            // Con autocommit=false, puedes ejecutar varios statements y
            // confirmarlos todos juntos (commit) o deshacerlos todos (rollback).
            conn.setAutoCommit(false);

            try (PreparedStatement stmt = conn.prepareStatement(
                    sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                // RETURN_GENERATED_KEYS: Pide al driver que devuelva las
                // claves generadas automáticamente (p.ej. el ID autoincrementado).

                stmt.setString(1, user.getUsername());
                stmt.setString(2, user.getEmail());
                stmt.setString(3, user.getPasswordHash());

                int rows = stmt.executeUpdate();

                if (rows != 1) {
                    conn.rollback(); // Deshacer si no se insertó ninguna fila
                    throw new SQLException("Insert no afectó a ninguna fila");
                }

                // Recuperar el ID generado por la BD y asignarlo al objeto
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        user.setId(keys.getLong(1));
                    }
                }

                conn.commit(); // Confirmar la transacción

            } catch (SQLException e) {
                conn.rollback(); // Deshacer en caso de error
                throw e;         // Re-lanzar para que el llamador lo gestione
            } finally {
                // IMPORTANTE: Restaurar autocommit=true antes de devolver
                // la conexión al pool. Si se devuelve con autocommit=false,
                // la siguiente operación que use esa conexión del pool
                // también tendrá autocommit=false de forma inesperada.
                conn.setAutoCommit(true);
            }
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return user;
    }
}
```

# 2. Implementaciones de Pool de Conexiones en Tomcat

Tomcat incluye dos implementaciones propias y es compatible con librerías externas. La elección depende del rendimiento requerido y la complejidad de configuración aceptable.

| Implementación            | Incluida en Tomcat | Recomendada para       | Jar                    |
|---------------------------|--------------------|------------------------|------------------------|
| Apache DBCP2              | ✅ Sí              | Uso general            | `tomcat-dbcp.jar`      |
| Tomcat JDBC Pool          | ✅ Sí              | Alto rendimiento       | `tomcat-jdbc.jar`      |
| HikariCP                  | ❌ Externa         | Máximo rendimiento     | `HikariCP-*.jar`       |
| c3p0                      | ❌ Externa         | Legacy                 | `c3p0-*.jar`           |

**Apache DBCP2** (*Database Connection Pool 2*): Implementación madura y estable incluida en Tomcat. Es la opción por defecto y suficiente para la mayoría de aplicaciones. Bien documentada y con larga trayectoria.

**Tomcat JDBC Pool**: También incluida en Tomcat, diseñada específicamente para entornos multihilo de alta carga. Su ventaja diferencial son los **Interceptors**: un sistema de plugins que permite interceptar operaciones del pool (queries, conexiones) para añadir funcionalidad como caché de statements, logging de queries lentas o timeouts automáticos.

**HikariCP**: La implementación de terceros con mejor rendimiento bruto. No está incluida en Tomcat y requiere añadir el JAR manualmente, pero es la más usada en proyectos modernos (es la implementación por defecto de Spring Boot). Exige una factory JNDI personalizada para integrarse con el sistema JNDI de Tomcat.

**c3p0**: Implementación legacy, prácticamente en desuso. Solo mantener si ya existe código heredado que la use.

## Comparativa de rendimiento

| Métrica                        | DBCP2     | Tomcat JDBC | HikariCP  |
|--------------------------------|-----------|-------------|-----------|
| Latencia de adquisición        | Media     | Baja        | Muy baja  |
| Throughput bajo carga          | Medio     | Alto        | Muy alto  |
| Overhead de memoria            | Medio     | Bajo        | Muy bajo  |
| Complejidad de configuración   | Media     | Media       | Baja      |
| Detección de conexiones rotas  | Sí        | Sí          | Sí        |
| Statement caching              | Sí        | Sí          | No        |
| Interceptors                   | No        | ✅ Sí       | No        |

**¿Cuándo importa el rendimiento del pool?**
En la mayoría de aplicaciones, el cuello de botella no está en el pool sino en las propias queries SQL. DBCP2 es completamente adecuado para cargas de cientos de peticiones por segundo. HikariCP empieza a marcar diferencia en sistemas con miles de peticiones por segundo o con conexiones muy cortas y frecuentes.

# 3. Configuración con Apache DBCP2

## Configuración completa en Context descriptor

El Context descriptor es un archivo XML en `conf/Catalina/localhost/nombre-app.xml` (o en `META-INF/context.xml` dentro del WAR) que configura el contexto de despliegue de una aplicación específica.

Dentro de él, el elemento `<Resource>` define un recurso JNDI — en este caso, el pool de conexiones.

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Resource
    name="jdbc/AppDB"
    <!--
      Nombre con el que se registra el recurso en JNDI.
      La aplicación lo busca como "java:comp/env/jdbc/AppDB".
      Convención: jdbc/ para DataSources, mail/ para sesiones de correo, etc.
    -->
    auth="Container"
    <!--
      auth="Container": Tomcat gestiona la autenticación con la BD.
      auth="Application": La aplicación proporciona usuario/contraseña en cada conexión.
      Casi siempre se usa "Container".
    -->
    type="javax.sql.DataSource"
    <!--
      Tipo Java del objeto que se registra en JNDI.
      javax.sql.DataSource es la interfaz estándar de Java para pools de conexiones.
      No cambia de namespace (es Java SE, no Jakarta EE).
    -->

    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"
    <!--
      Factory: La clase que Tomcat usa para crear el objeto DataSource.
      Cada implementación de pool tiene su propia factory.
      Cambiar esta línea es suficiente para cambiar de implementación de pool.
    -->

    <!-- ===== Driver y URL de conexión ===== -->
    driverClassName="org.postgresql.Driver"
    <!--
      Clase del driver JDBC de la base de datos.
      El JAR del driver (p.ej. postgresql-42.x.jar) debe estar en
      $CATALINA_HOME/lib/ para que Tomcat pueda cargarlo.
      Si solo está en WEB-INF/lib/, el pool no puede acceder a él
      (pertenece al classloader de la aplicación, no al de Tomcat).
    -->
    url="jdbc:postgresql://db-host:5432/appdb
         ?ssl=true
         &amp;sslmode=require
         &amp;connectTimeout=10
         &amp;socketTimeout=30
         &amp;ApplicationName=myapp-tomcat"
    <!--
      URL JDBC de conexión. Formato: jdbc:[driver]://host:puerto/basedatos?params
      
      ssl=true y sslmode=require: Cifrar la conexión entre Tomcat y la BD.
      Fundamental en producción para que las credenciales y datos no viajen
      en texto plano por la red interna.
      
      connectTimeout=10: Segundos máximos para establecer la conexión TCP.
      socketTimeout=30: Segundos máximos para que una query responda.
      
      ApplicationName: Nombre con el que se identifica esta conexión
      en el servidor de BD (útil en pg_stat_activity de PostgreSQL para
      identificar qué proceso abrió qué conexión).
      
      NOTA: En XML, "&" se escribe "&amp;" porque es un caracter especial.
    -->
    username="${db.username}"
    password="${db.password}"
    <!--
      Las credenciales se referencian como variables de propiedades del sistema.
      Se configuran en conf/catalina.properties o se pasan al arranque con -D.
      NUNCA escribir contraseñas en texto plano en archivos de configuración
      que puedan acabar en un repositorio de código.
    -->

    <!-- ===== Tamaño del Pool ===== -->
    maxTotal="50"
    <!--
      Número MÁXIMO de conexiones (activas + idle) que el pool puede tener.
      Una petición que solicite una conexión cuando todas están en uso
      espera hasta maxWaitMillis ms; si sigue sin haber, lanza excepción.
      
      IMPORTANTE: maxTotal * número_de_instancias_Tomcat <= max_connections_BD
      Si tienes maxTotal=50 y 3 instancias de Tomcat, la BD necesita aguantar
      al menos 150 conexiones simultáneas.
    -->
    maxIdle="10"
    <!--
      Número máximo de conexiones que se mantienen "idle" (disponibles, sin usar)
      en el pool cuando no hay carga. Las conexiones en exceso de maxIdle
      se cierran cuando se devuelven al pool.
      
      Valor razonable: entre 20-40% de maxTotal. Un valor muy alto desperdicia
      recursos en el servidor de BD (conexiones abiertas sin usar).
    -->
    minIdle="5"
    <!--
      Número mínimo de conexiones idle que el pool mantiene siempre abiertas.
      El hilo de mantenimiento crea nuevas conexiones si cae por debajo de este valor.
      Tener minIdle > 0 garantiza que hay conexiones disponibles instantáneamente
      cuando llega una petición, sin esperar a crear una nueva.
    -->
    initialSize="5"
    <!--
      Conexiones que se crean al arrancar la aplicación ("warm-up" del pool).
      Evita que las primeras peticiones a la aplicación recién desplegada
      sean lentas por tener que crear conexiones desde cero.
      Valor razonable: igual a minIdle.
    -->

    <!-- ===== Timeouts ===== -->
    maxWaitMillis="30000"
    <!--
      Tiempo máximo en milisegundos que el código espera para obtener
      una conexión del pool si todas están en uso.
      30 segundos es generoso; en APIs REST es preferible fallar rápido
      (5-10 segundos) para no acumular peticiones bloqueadas.
      -1 = esperar indefinidamente (nunca usar en producción).
    -->
    minEvictableIdleTimeMillis="300000"
    <!--
      Tiempo mínimo en ms que una conexión debe estar idle antes de ser
      candidata a ser eliminada por el hilo de mantenimiento.
      300000 ms = 5 minutos. Las conexiones idle más de 5 minutos pueden
      ser cerradas por el pool (si hay más que minIdle).
      Previene que la BD cierre conexiones inactivas por timeout.
    -->
    maxConnLifetimeMillis="3600000"
    <!--
      Tiempo máximo de vida de una conexión en ms, independientemente
      de si está activa o idle. 3600000 ms = 1 hora.
      Cuando una conexión se devuelve al pool y ha superado su lifetime,
      se cierra y se crea una nueva. Evita problemas con conexiones muy
      antiguas que puedan estar en estado inconsistente.
      Disponible desde DBCP2 2.1 (Tomcat 8.5+).
    -->

    <!-- ===== Validación de Conexiones ===== -->
    validationQuery="SELECT 1"
    <!--
      Query SQL que se ejecuta para verificar que una conexión está viva.
      "SELECT 1" es la más eficiente (retorna inmediatamente).
      Para Oracle: "SELECT 1 FROM DUAL".
      Alternativa moderna: usar isValid() del driver JDBC en lugar de una query.
    -->
    validationQueryTimeout="5"
    <!--
      Timeout en SEGUNDOS para la validationQuery. Si no responde en 5 segundos,
      la conexión se considera muerta y se descarta.
    -->
    testOnBorrow="true"
    <!--
      Si true: ejecutar la validationQuery CADA VEZ que se toma una conexión del pool.
      Garantiza que el código nunca recibe una conexión rota o caducada.
      Coste: una query adicional por cada uso de conexión (normalmente imperceptible).
      RECOMENDADO en producción donde la BD puede reiniciarse o hay failover.
    -->
    testOnReturn="false"
    <!--
      Si true: validar la conexión al DEVOLVERLA al pool.
      Generalmente innecesario si testOnBorrow=true. false por defecto.
    -->
    testWhileIdle="true"
    <!--
      Si true: el hilo de mantenimiento ejecuta la validationQuery en las
      conexiones idle periódicamente. Detecta y elimina conexiones muertas
      en reposo antes de que se las den a un cliente.
    -->
    timeBetweenEvictionRunsMillis="30000"
    <!--
      Intervalo en ms entre ejecuciones del hilo de mantenimiento.
      Este hilo valida conexiones idle (testWhileIdle), elimina las expiradas
      (minEvictableIdleTimeMillis) y crea nuevas si hay menos de minIdle.
      30000 ms = 30 segundos es un valor equilibrado.
    -->
    numTestsPerEvictionRun="5"
    <!--
      Número de conexiones idle que el hilo de mantenimiento verifica
      por cada ejecución. Limitar esto evita que el mantenimiento
      bloquee el pool durante demasiado tiempo en cada ciclo.
    -->

    <!-- ===== Conexiones Abandonadas ===== -->
    removeAbandonedOnBorrow="true"
    <!--
      Si true: cuando se solicita una conexión del pool y todas están en uso,
      el pool busca conexiones "abandonadas" (prestadas desde hace más de
      removeAbandonedTimeout segundos) y las recupera forzosamente.
      Esto detecta y soluciona connection leaks durante la ejecución.
    -->
    removeAbandonedOnMaintenance="true"
    <!--
      Si true: el hilo de mantenimiento también busca y recupera conexiones
      abandonadas periódicamente, aunque el pool no esté lleno.
    -->
    removeAbandonedTimeout="60"
    <!--
      Segundos tras los cuales una conexión prestada se considera "abandonada".
      Debe ser mayor que el tiempo que puede tardar la query más lenta legítima
      de tu aplicación. Si una query tarda >60s normalmente, aumentar este valor.
    -->
    logAbandoned="true"
    <!--
      Si true: cuando se recupera una conexión abandonada, el pool loguea
      el stack trace del código que la tomó y no la devolvió.
      ESENCIAL para depurar connection leaks. El stack trace te dice
      exactamente en qué línea de qué clase se produjo el leak.
    -->
    abandonedUsageTracking="true"
    <!--
      Monitorización más detallada del uso de las conexiones abandonadas.
      Captura cada llamada a métodos de la conexión para el log de abandono.
    -->

    <!-- ===== Statement Cache (PreparedStatement) ===== -->
    poolPreparedStatements="true"
    <!--
      Si true: el pool cachea los PreparedStatements a nivel de conexión.
      Un PreparedStatement ya "compilado" en el servidor de BD no necesita
      ser reanalizado en cada ejecución.
      Beneficio: menor carga en el servidor de BD para queries repetitivas.
    -->
    maxOpenPreparedStatements="200"
    <!--
      Número máximo de PreparedStatements en caché por conexión.
      Ajustar según el número de queries distintas que hace la aplicación.
    -->

    <!-- ===== Propiedades adicionales de la conexión ===== -->
    connectionProperties="useUnicode=true;characterEncoding=utf8;
                          rewriteBatchedStatements=true"
    <!--
      Propiedades que se pasan directamente al driver JDBC al crear cada conexión.
      rewriteBatchedStatements=true: Para MySQL/MariaDB, agrupa los INSERT
      en batch en una sola operación de red (mejora masiva en bulk inserts).
    -->

    <!-- ===== Estado por defecto de las conexiones ===== -->
    defaultAutoCommit="true"
    <!--
      Estado de autocommit de las conexiones cuando se toman del pool.
      true: cada statement se confirma inmediatamente (comportamiento por defecto JDBC).
      false: requiere commit/rollback explícito.
      Se recomienda true para el pool y gestionar transacciones explícitamente
      en el código cuando sea necesario (como en el ejemplo de save() anterior).
    -->
    defaultTransactionIsolation="READ_COMMITTED"
    <!--
      Nivel de aislamiento de transacciones por defecto.
      READ_COMMITTED: Solo se ven datos ya confirmados. Previene dirty reads.
      Es el nivel por defecto en PostgreSQL, MySQL y SQL Server.
      Niveles más altos (REPEATABLE_READ, SERIALIZABLE) añaden consistencia
      pero reducen concurrencia.
    -->
    defaultReadOnly="false"
    <!--
      Si true, las conexiones son de solo lectura. El driver puede
      optimizar las queries (sin logging de transacciones). Usar
      para réplicas de lectura.
    -->

    <!-- ===== Comportamiento al devolver al pool ===== -->
    rollbackOnReturn="true"
    <!--
      Si true: cuando se devuelve una conexión al pool, se hace automáticamente
      un ROLLBACK si hay una transacción pendiente sin confirmar.
      Previene que transacciones no confirmadas "contaminen" la siguiente
      operación que use esa conexión.
    -->
    enableAutoCommitOnReturn="true"
    <!--
      Si true: cuando se devuelve la conexión, se restaura autocommit=true
      aunque el código lo hubiera cambiado. Garantiza estado limpio en el pool.
    -->

    connectionInitSqls="SET application_name='myapp-tomcat'"
    <!--
      SQL ejecutado una vez al CREAR cada nueva conexión (no en cada borrow).
      Útil para configurar parámetros de sesión específicos de la BD.
    -->
    description="Pool de conexiones principal de myapp"/>

</Context>
```

## Configuración para múltiples bases de datos

Una aplicación puede usar múltiples bases de datos simultáneamente. Se definen múltiples elementos `<Resource>` con nombres JNDI diferentes, uno por cada BD.

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!-- Base de datos principal (PostgreSQL) -->
  <Resource
    name="jdbc/MainDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"
    driverClassName="org.postgresql.Driver"
    url="jdbc:postgresql://pg-host:5432/maindb?ssl=true&amp;sslmode=require"
    username="${db.main.username}"
    password="${db.main.password}"
    maxTotal="50"
    maxIdle="10"
    minIdle="5"
    initialSize="5"
    maxWaitMillis="30000"
    testOnBorrow="true"
    validationQuery="SELECT 1"
    testWhileIdle="true"
    timeBetweenEvictionRunsMillis="30000"
    removeAbandonedOnBorrow="true"
    removeAbandonedTimeout="60"
    logAbandoned="true"/>

  <!-- Base de datos de reportes (MySQL read replica)
       Configurada con maxTotal más bajo (menos carga esperada)
       y defaultReadOnly=true (es una réplica de solo lectura). -->
  <Resource
    name="jdbc/ReportsDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"
    driverClassName="com.mysql.cj.jdbc.Driver"
    url="jdbc:mysql://mysql-replica:3306/reportsdb
         ?useSSL=true
         &amp;serverTimezone=Europe/Madrid
         &amp;useUnicode=true
         &amp;characterEncoding=UTF-8
         &amp;rewriteBatchedStatements=true
         &amp;useServerPrepStmts=true"
    <!--
      Parámetros específicos del driver MySQL:
      serverTimezone: Evita ambigüedades de zona horaria en timestamps.
      useServerPrepStmts=true: Usar PreparedStatements del lado del servidor
      (el servidor MySQL almacena el plan de ejecución).
    -->
    username="${db.reports.username}"
    password="${db.reports.password}"
    maxTotal="20"
    maxIdle="5"
    minIdle="2"
    initialSize="2"
    maxWaitMillis="15000"
    testOnBorrow="true"
    validationQuery="SELECT 1"
    defaultReadOnly="true"
    testWhileIdle="true"
    timeBetweenEvictionRunsMillis="60000"
    removeAbandonedOnBorrow="true"
    removeAbandonedTimeout="120"
    logAbandoned="true"/>

  <!-- Oracle Database
       Nota: validationQuery para Oracle usa "SELECT 1 FROM DUAL"
       porque Oracle no acepta "SELECT 1" sin FROM en versiones antiguas. -->
  <Resource
    name="jdbc/OracleDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"
    driverClassName="oracle.jdbc.OracleDriver"
    url="jdbc:oracle:thin:@//oracle-host:1521/ORCLPDB1"
    <!--
      oracle:thin: Driver JDBC puro Java de Oracle (sin dependencias nativas).
      @// indica el formato de URL "Easy Connect" de Oracle.
      ORCLPDB1 es el nombre del Pluggable Database (PDB) en Oracle 12c+.
    -->
    username="${db.oracle.username}"
    password="${db.oracle.password}"
    maxTotal="30"
    maxIdle="8"
    minIdle="3"
    initialSize="3"
    maxWaitMillis="30000"
    testOnBorrow="true"
    validationQuery="SELECT 1 FROM DUAL"
    timeBetweenEvictionRunsMillis="30000"
    removeAbandonedOnBorrow="true"
    removeAbandonedTimeout="60"
    logAbandoned="true"
    connectionProperties="oracle.jdbc.ReadTimeout=30000;
                          oracle.net.CONNECT_TIMEOUT=10000"/>

  <!-- SQL Server -->
  <Resource
    name="jdbc/SqlServerDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"
    driverClassName="com.microsoft.sqlserver.jdbc.SQLServerDriver"
    url="jdbc:sqlserver://sqlserver-host:1433;
         databaseName=appdb;
         encrypt=true;
         trustServerCertificate=false;
         loginTimeout=10;
         applicationName=myapp-tomcat"
    <!--
      Para SQL Server, los parámetros de conexión van en la URL separados
      por ";" en lugar de "?" como en PostgreSQL/MySQL.
      encrypt=true: Cifrar la conexión (equivalente a ssl=true en PostgreSQL).
      trustServerCertificate=false: Verificar el certificado del servidor
      SQL Server. Solo poner true en entornos de desarrollo con certificados
      autofirmados.
    -->
    username="${db.sqlserver.username}"
    password="${db.sqlserver.password}"
    maxTotal="30"
    maxIdle="8"
    minIdle="3"
    initialSize="3"
    maxWaitMillis="30000"
    testOnBorrow="true"
    validationQuery="SELECT 1"
    timeBetweenEvictionRunsMillis="30000"
    removeAbandonedOnBorrow="true"
    removeAbandonedTimeout="60"
    logAbandoned="true"/>

</Context>
```

# 4. Configuración con Tomcat JDBC Pool

El Tomcat JDBC Pool es una alternativa a DBCP2 con mayor rendimiento en entornos de alta carga, diseñada específicamente para el modelo de concurrencia de Tomcat. Su característica más importante son los **Interceptors**: un sistema de AOP (*Aspect-Oriented Programming*) que permite interceptar operaciones del pool para añadir funcionalidad transversal.

## Configuración completa

```xml
<Resource
  name="jdbc/AppDB"
  auth="Container"
  type="javax.sql.DataSource"

  factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
  <!--
    Factory específica del Tomcat JDBC Pool.
    Cambiar esto (y los parámetros específicos) es todo lo necesario
    para migrar de DBCP2 a Tomcat JDBC Pool.
  -->

  <!-- ===== Driver y URL ===== -->
  driverClassName="org.postgresql.Driver"
  url="jdbc:postgresql://db-host:5432/appdb?ssl=true&amp;sslmode=require"
  username="${db.username}"
  password="${db.password}"

  <!-- ===== Tamaño del Pool ===== -->
  initialSize="10"
  maxActive="100"
  <!--
    En Tomcat JDBC Pool el parámetro se llama "maxActive" (no "maxTotal" como en DBCP2).
    Equivale al número máximo de conexiones simultáneas.
  -->
  maxIdle="20"
  minIdle="10"
  maxWait="30000"
  <!-- En Tomcat JDBC Pool: "maxWait" (no "maxWaitMillis") -->

  <!-- ===== Validación ===== -->
  testOnBorrow="true"
  testOnReturn="false"
  testWhileIdle="true"
  validationQuery="SELECT 1"
  validationQueryTimeout="5"
  validationInterval="30000"
  <!--
    validationInterval: Tiempo mínimo en ms entre validaciones de la misma conexión.
    Si una conexión fue validada hace menos de 30 segundos, no se vuelve a validar
    aunque testOnBorrow=true. Reduce el overhead de validación en conexiones muy activas.
    Parámetro exclusivo del Tomcat JDBC Pool (no existe en DBCP2).
  -->

  <!-- ===== Mantenimiento ===== -->
  timeBetweenEvictionRunsMillis="30000"
  minEvictableIdleTimeMillis="60000"
  maxAge="3600000"
  <!--
    maxAge: Tiempo máximo de vida de una conexión en ms.
    Equivale a maxConnLifetimeMillis de DBCP2.
    1 hora = 3600000 ms.
  -->

  <!-- ===== Conexiones Abandonadas ===== -->
  removeAbandoned="true"
  <!--
    En Tomcat JDBC Pool el parámetro es "removeAbandoned" (no "removeAbandonedOnBorrow").
    Combina las funciones de removeAbandonedOnBorrow y removeAbandonedOnMaintenance de DBCP2.
  -->
  removeAbandonedTimeout="60"
  logAbandoned="true"
  abandonWhenPercentageFull="50"
  <!--
    Parámetro exclusivo del Tomcat JDBC Pool:
    Solo activa la búsqueda de conexiones abandonadas cuando el pool está
    al menos al 50% de uso (maxActive). Evita overhead en situaciones de
    baja carga donde los abandoned timeouts no son urgentes.
  -->

  <!-- ===== Transacciones ===== -->
  defaultAutoCommit="true"
  defaultTransactionIsolation="READ_COMMITTED"
  rollbackOnReturn="false"
  commitOnReturn="false"
  <!--
    rollbackOnReturn=false y commitOnReturn=false: No hacer rollback/commit
    automático al devolver la conexión. La responsabilidad de gestionar
    transacciones queda completamente en el código de la aplicación.
    Adecuado cuando se usan frameworks como JPA/Hibernate que gestionan
    las transacciones externamente.
  -->

  <!-- ===== Interceptors del Tomcat JDBC Pool ===== -->
  jdbcInterceptors="ResetAbandonedTimer;
                    StatementFinalizer;
                    StatementCache(max=500);
                    SlowQueryReport(threshold=1000,maxQueries=1000);
                    ConnectionState;
                    QueryTimeoutInterceptor(queryTimeout=30)"
  <!--
    Los Interceptors son la característica diferencial del Tomcat JDBC Pool.
    Se ejecutan en cadena (como filtros HTTP) para cada operación del pool.
    
    ResetAbandonedTimer: Cada vez que se usa la conexión (ejecutar una query,
      etc.), reinicia el timer de abandoned. Previene que conexiones activas
      con queries largas sean marcadas como abandonadas erróneamente.
    
    StatementFinalizer: Cierra automáticamente cualquier Statement que no
      haya sido cerrado explícitamente antes de devolver la conexión al pool.
      Es una red de seguridad contra statement leaks (similares a connection leaks
      pero con PreparedStatements/Statements).
    
    StatementCache(max=500): Cachea hasta 500 PreparedStatements a nivel de
      POOL (no solo de conexión como en DBCP2). Las conexiones comparten el
      caché, lo que hace este mecanismo más eficiente en memoria.
    
    SlowQueryReport(threshold=1000, maxQueries=1000): Registra y expone via
      JMX las queries que tardan más de 1000 ms. maxQueries limita cuántas
      queries lentas distintas se rastrean (para no llenar la memoria).
      Imprescindible para detectar problemas de rendimiento en producción.
    
    ConnectionState: Gestiona y restaura el estado de autocommit, readOnly y
      transactionIsolation de la conexión al devolverla al pool, garantizando
      que la siguiente operación recibe la conexión en estado conocido.
    
    QueryTimeoutInterceptor(queryTimeout=30): Aplica automáticamente un
      timeout de 30 segundos a cada Statement. Previene que queries bloqueadas
      o en deadlock mantengan la conexión ocupada indefinidamente.
      30 segundos es el límite; ajustar según las queries más lentas legítimas.
  -->

  <!-- ===== Fair Queue ===== -->
  fairQueue="true"
  <!--
    Si true: Las peticiones de conexión se atienden en orden FIFO estricto.
    Si false: El hilo del sistema operativo que primero consiga el lock
    obtiene la conexión (no determinista). 
    fairQueue=true garantiza equidad bajo carga pero tiene un pequeño
    coste de rendimiento por la gestión de la cola.
  -->

  <!-- ===== JMX ===== -->
  jmxEnabled="true"
  <!--
    Registra MBeans en el JMX MBeanServer de la JVM.
    Permite monitorizar el pool en tiempo real desde JConsole, VisualVM
    o cualquier sistema de monitorización que soporte JMX (Prometheus,
    Datadog, etc.).
  -->

  connectionProperties="ApplicationName=myapp-tomcat;
                        connectTimeout=10000;
                        socketTimeout=30000"/>
```

## Interceptor personalizado para auditoría

Los Interceptors del Tomcat JDBC Pool son extensibles. Puedes crear tu propia implementación para añadir lógica de auditoría, métricas personalizadas o integraciones con sistemas externos.

```java
package com.miempresa.jdbc.interceptor;

import org.apache.tomcat.jdbc.pool.interceptor.AbstractQueryReport;
import java.lang.reflect.Method;
import java.util.logging.Logger;

/**
 * Interceptor personalizado para Tomcat JDBC Pool.
 * 
 * AbstractQueryReport es la clase base para interceptors que necesitan
 * acceder a las queries SQL ejecutadas. Tomcat la invoca automáticamente
 * para cada operación de PreparedStatement/Statement/CallableStatement.
 * 
 * Para usar este interceptor, añadirlo a jdbcInterceptors en la configuración:
 *   jdbcInterceptors="...;com.miempresa.jdbc.interceptor.AuditQueryInterceptor(threshold=500)"
 */
public class AuditQueryInterceptor extends AbstractQueryReport {

    private static final Logger log =
        Logger.getLogger(AuditQueryInterceptor.class.getName());

    // Umbral en ms para considerar una query como lenta.
    // Puede configurarse desde jdbcInterceptors con threshold=500.
    private long slowQueryThreshold = 500;

    /**
     * reportFailedQuery: Llamado cuando una query lanza una excepción.
     * 
     * @param query  El SQL que falló
     * @param args   Los parámetros de la query (si es PreparedStatement)
     * @param name   El nombre del método invocado (executeQuery, executeUpdate, etc.)
     * @param start  Timestamp de inicio en milisegundos
     * @param t      La excepción que ocurrió
     */
    @Override
    protected String reportFailedQuery(String query,
                                       Object[] args,
                                       String name,
                                       long start,
                                       Throwable t) {
        long elapsed = System.currentTimeMillis() - start;
        log.severe(String.format(
            "QUERY FALLIDA [%d ms] [%s]: %s | Error: %s",
            elapsed, name, query, t.getMessage()
        ));
        return query;
    }

    /**
     * reportSlowQuery: Llamado cuando una query supera el threshold del
     * interceptor padre (SlowQueryReport). Solo si AuditQueryInterceptor
     * está encadenado con SlowQueryReport.
     */
    @Override
    protected String reportSlowQuery(String query,
                                     Object[] args,
                                     String name,
                                     long start,
                                     long delta) {
        log.warning(String.format(
            "QUERY LENTA [%d ms] [%s]: %s",
            delta, name, query
        ));
        return query;
    }

    /**
     * reportQuery: Llamado para TODAS las queries (no solo las lentas).
     * Aquí se filtra por el threshold propio del interceptor.
     */
    @Override
    protected String reportQuery(String query,
                                 Object[] args,
                                 String name,
                                 long start,
                                 long delta) {
        if (delta >= slowQueryThreshold) {
            log.info(String.format(
                "QUERY [%d ms] [%s]: %s",
                delta, name, query
            ));
        }
        return query;
    }

    /**
     * invoke: Punto de entrada del interceptor. Se llama para cada método
     * de Statement/PreparedStatement. super.invoke() maneja la lógica base
     * de AbstractQueryReport (medir tiempo, llamar a reportQuery, etc.).
     */
    @Override
    public Object invoke(Object proxy, Method method, Object[] args)
            throws Throwable {
        return super.invoke(proxy, method, args);
    }
}
```

# 5. Configuración con HikariCP (Externa)

HikariCP es la implementación de pool de conexiones con mayor rendimiento disponible para Java. Es el pool por defecto en Spring Boot desde la versión 2.0. Su filosofía de diseño se centra en la mínima latencia y el mínimo overhead de memoria.

**Limitación JNDI:** HikariCP no incluye una factory JNDI estándar (a diferencia de DBCP2 y Tomcat JDBC Pool). Para registrarlo en el JNDI de Tomcat, necesitas una de estas dos opciones: una factory personalizada (sección 7.5.1) o inicialización programática en un Listener (sección 7.5.2).

Requiere añadir `HikariCP-*.jar` en `$CATALINA_HOME/lib/` o en `WEB-INF/lib/`.

## Configuración via Context descriptor con factory personalizado

Esta aproximación mantiene la configuración centralizada en el context descriptor XML, como con DBCP2, pero requiere implementar una factory propia.

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Resource
    name="jdbc/AppDB"
    auth="Container"
    type="javax.sql.DataSource"

    factory="com.miempresa.jndi.HikariDataSourceFactory"
    <!--
      Factory personalizada (implementada más abajo).
      Tomcat la llama al crear el DataSource y le pasa todos los atributos
      del <Resource> como RefAddr objects.
    -->

    driverClassName="org.postgresql.Driver"
    jdbcUrl="jdbc:postgresql://db-host:5432/appdb?ssl=true&amp;sslmode=require"
    <!--
      HikariCP usa "jdbcUrl" en lugar de "url". Es el único parámetro de
      nombre diferente respecto a DBCP2.
    -->
    username="${db.username}"
    password="${db.password}"

    <!-- Parámetros específicos de HikariCP -->
    poolName="MyAppHikariPool"
    <!--
      Nombre del pool. Aparece en logs y en JMX. Útil para identificar
      el pool en sistemas con múltiples DataSources.
    -->
    maximumPoolSize="50"
    <!--
      Máximo número de conexiones en el pool (activas + idle).
      Equivale a maxTotal en DBCP2 o maxActive en Tomcat JDBC Pool.
    -->
    minimumIdle="10"
    <!--
      Mínimo de conexiones idle que HikariCP mantiene.
      HikariCP recomienda igualar maximumPoolSize y minimumIdle para
      un pool de tamaño fijo (más predecible bajo carga variable).
    -->
    connectionTimeout="30000"
    <!--
      Tiempo máximo en ms que el cliente espera para obtener una conexión
      del pool. Equivale a maxWaitMillis en DBCP2.
    -->
    idleTimeout="600000"
    <!--
      Tiempo en ms que una conexión puede estar idle antes de ser eliminada
      (si hay más que minimumIdle). 600000 ms = 10 minutos.
      Equivale a minEvictableIdleTimeMillis en DBCP2.
    -->
    maxLifetime="1800000"
    <!--
      Tiempo máximo de vida de una conexión en ms. 1800000 ms = 30 minutos.
      HikariCP retira conexiones que alcanzan su maxLifetime y las reemplaza.
      Equivale a maxConnLifetimeMillis en DBCP2.
      IMPORTANTE: debe ser varios segundos menor que el timeout de
      conexiones inactivas configurado en el servidor de BD, para que
      HikariCP retire la conexión antes de que la BD la cierre.
    -->
    keepaliveTime="60000"
    <!--
      Si el pool está idle, HikariCP envía la connectionTestQuery cada
      keepaliveTime ms para mantener las conexiones vivas.
      Equivale al efecto de testWhileIdle de DBCP2. 60000 ms = 1 minuto.
    -->
    connectionTestQuery="SELECT 1"
    <!--
      Query de validación. HikariCP usa por defecto la API isValid() del
      driver JDBC (más eficiente que una query), pero algunos drivers
      antiguos no la implementan correctamente; en esos casos, especificar
      esta query.
    -->
    leakDetectionThreshold="60000"
    <!--
      Si una conexión está fuera del pool más de este tiempo (en ms),
      HikariCP registra un warning en el log con el stack trace del código
      que la tomó. Similar a removeAbandonedTimeout + logAbandoned de DBCP2,
      pero HikariCP NO recupera la conexión; solo avisa.
      60000 ms = 60 segundos.
    -->
    autoCommit="true"
    readOnly="false"
    transactionIsolation="TRANSACTION_READ_COMMITTED"
    initializationFailTimeout="1"
    <!--
      Si HikariCP no puede crear una conexión inicial en este tiempo (ms),
      lanza excepción al inicializar el pool y falla el arranque de la app.
      1 ms significa "falla inmediatamente si no puede conectar".
      -1 = intentar indefinidamente (no recomendado en producción).
      0 = no intentar crear conexión inicial (lazy init).
    -->
    isolateInternalQueries="false"
    <!--
      Si true: HikariCP ejecuta sus queries internas (keepalive, isAlive)
      en una transacción separada aislada del estado actual de la conexión.
      false está bien para la mayoría de casos.
    -->
    registerMbeans="true"
    <!--
      Registrar MBeans JMX para monitorización del pool.
      Equivale a jmxEnabled=true en Tomcat JDBC Pool.
    -->

    <!-- Propiedades del driver PostgreSQL pasadas directamente al DataSource
         (prefijo "dataSource.") -->
    dataSource.ssl="true"
    dataSource.sslmode="require"
    dataSource.connectTimeout="10"
    dataSource.socketTimeout="30"
    dataSource.applicationName="myapp-hikari"/>

</Context>
```

```java
package com.miempresa.jndi;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import javax.naming.*;
import javax.naming.spi.ObjectFactory;
import javax.sql.DataSource;
import java.util.Enumeration;
import java.util.Hashtable;

/**
 * Factory JNDI para HikariCP.
 * 
 * Tomcat llama a getObjectInstance() cuando la aplicación hace lookup del
 * DataSource en JNDI por primera vez. La factory recibe los atributos del
 * <Resource> XML como un objeto Reference, los traduce a HikariConfig,
 * y devuelve un HikariDataSource listo para usar.
 * 
 * Esta clase debe estar en $CATALINA_HOME/lib/ (no en WEB-INF/lib/)
 * porque es cargada por el classloader de Tomcat, no por el de la app.
 */
public class HikariDataSourceFactory implements ObjectFactory {

    @Override
    public Object getObjectInstance(Object obj,
                                    Name name,
                                    Context nameCtx,
                                    Hashtable<?, ?> environment)
            throws Exception {

        // obj es un Reference con todos los atributos del <Resource> XML
        Reference ref = (Reference) obj;
        HikariConfig config = new HikariConfig();

        // Iterar sobre todos los atributos del <Resource> y mapear
        // cada uno al setter correspondiente de HikariConfig
        Enumeration<RefAddr> addrs = ref.getAll();
        while (addrs.hasMoreElements()) {
            RefAddr addr = addrs.nextElement();
            String addrName  = addr.getType();
            String addrValue = addr.getContent().toString();

            // Switch expression de Java 14+ para mapear cada atributo
            switch (addrName) {
                case "driverClassName"     -> config.setDriverClassName(addrValue);
                case "jdbcUrl"             -> config.setJdbcUrl(addrValue);
                case "username"            -> config.setUsername(addrValue);
                case "password"            -> config.setPassword(addrValue);
                case "maximumPoolSize"     -> config.setMaximumPoolSize(Integer.parseInt(addrValue));
                case "minimumIdle"         -> config.setMinimumIdle(Integer.parseInt(addrValue));
                case "connectionTimeout"   -> config.setConnectionTimeout(Long.parseLong(addrValue));
                case "idleTimeout"         -> config.setIdleTimeout(Long.parseLong(addrValue));
                case "maxLifetime"         -> config.setMaxLifetime(Long.parseLong(addrValue));
                case "keepaliveTime"       -> config.setKeepaliveTime(Long.parseLong(addrValue));
                case "connectionTestQuery" -> config.setConnectionTestQuery(addrValue);
                case "poolName"            -> config.setPoolName(addrValue);
                case "autoCommit"          -> config.setAutoCommit(Boolean.parseBoolean(addrValue));
                case "readOnly"            -> config.setReadOnly(Boolean.parseBoolean(addrValue));
                case "leakDetectionThreshold" ->
                    config.setLeakDetectionThreshold(Long.parseLong(addrValue));
                case "registerMbeans"      -> config.setRegisterMbeans(Boolean.parseBoolean(addrValue));
                case "transactionIsolation"-> config.setTransactionIsolation(addrValue);
                default -> {
                    // Los atributos con prefijo "dataSource." se pasan
                    // directamente como propiedades del DataSource subyacente
                    if (addrName.startsWith("dataSource.")) {
                        config.addDataSourceProperty(
                            addrName.substring("dataSource.".length()),
                            addrValue
                        );
                    }
                    // Los atributos desconocidos se ignoran silenciosamente
                }
            }
        }

        // Crear y devolver el HikariDataSource configurado.
        // Tomcat lo registra en JNDI y lo devuelve cada vez que la
        // aplicación hace lookup("java:comp/env/jdbc/AppDB").
        return new HikariDataSource(config);
    }
}
```

## Configuración programática con ServletContextListener

Esta alternativa crea el DataSource directamente en código Java dentro del `contextInitialized()` del Listener, y lo publica en el `ServletContext` (en lugar de en JNDI).

**Cuándo usar este enfoque:**
- Cuando la factory JNDI personalizada es demasiado complejidad de mantener.
- Cuando se quiere leer la configuración desde variables de entorno (más común en entornos Docker/Kubernetes).
- Cuando ya se usa Spring o un framework que gestiona el ciclo de vida de los DataSources.

**Limitación:** El DataSource se obtiene de `servletContext.getAttribute("dataSource")` en lugar de `InitialContext.lookup("java:comp/env/jdbc/AppDB")`. Esto rompe la compatibilidad con el patrón JNDI estándar.

```java
package com.miempresa.listener;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import javax.naming.Context;
import javax.naming.InitialContext;

/**
 * Inicialización programática de HikariCP.
 * Alternativa cuando no se puede usar el JNDI factory.
 * El DataSource se publica en el ServletContext para
 * que los DAOs puedan acceder a él.
 */
@WebListener
public class DataSourceInitializer implements ServletContextListener {

    private HikariDataSource dataSource;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext ctx = event.getServletContext();

        HikariConfig config = new HikariConfig();

        // Obtener configuración con prioridad de fuentes:
        // 1. Variables de entorno del SO (ideal para Docker/K8s)
        // 2. Parámetros de contexto de web.xml (<context-param>)
        // 3. Valor por defecto hardcodeado
        config.setJdbcUrl(getConfig(ctx, "db.url",
            "jdbc:postgresql://localhost:5432/appdb"));
        config.setUsername(getConfig(ctx, "db.username", "appuser"));
        config.setPassword(getConfig(ctx, "db.password", ""));
        config.setDriverClassName("org.postgresql.Driver");

        // Configuración del pool
        config.setMaximumPoolSize(50);
        config.setMinimumIdle(10);
        config.setConnectionTimeout(30_000);   // 30 segundos
        config.setIdleTimeout(600_000);        // 10 minutos
        config.setMaxLifetime(1_800_000);      // 30 minutos
        config.setKeepaliveTime(60_000);       // 1 minuto
        config.setLeakDetectionThreshold(60_000); // 1 minuto

        // Identificación y métricas
        config.setPoolName("AppHikariPool");
        config.setRegisterMbeans(true); // Exponer via JMX
        config.setAutoCommit(true);
        config.setTransactionIsolation("TRANSACTION_READ_COMMITTED");

        // Propiedades específicas del driver PostgreSQL
        // (pasadas directamente al DataSource subyacente de PostgreSQL)
        config.addDataSourceProperty("ssl",             "true");
        config.addDataSourceProperty("sslmode",         "require");
        config.addDataSourceProperty("connectTimeout",  "10");
        config.addDataSourceProperty("socketTimeout",   "30");
        config.addDataSourceProperty("applicationName", "myapp-hikari");
        config.addDataSourceProperty("reWriteBatchedInserts", "true");
        // Cache de PreparedStatements del driver PostgreSQL
        config.addDataSourceProperty("preparedStatementCacheQueries", "250");
        config.addDataSourceProperty("preparedStatementCacheSizeMiB", "5");

        dataSource = new HikariDataSource(config);

        // Publicar el DataSource en el ServletContext como atributo.
        // Los DAOs lo recuperan con:
        //   DataSource ds = (DataSource) servletContext.getAttribute("dataSource");
        // O si el DAO tiene acceso al contexto:
        //   DataSource ds = (DataSource) getServletContext().getAttribute("dataSource");
        ctx.setAttribute("dataSource", dataSource);

        ctx.log("HikariCP DataSource inicializado. Pool: "
            + config.getPoolName()
            + ", MaxPool: " + config.getMaximumPoolSize());
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        // CRÍTICO: cerrar el HikariDataSource al parar la aplicación.
        // Si no se hace, los hilos internos de HikariCP (pool maintenance,
        // keepalive) siguen corriendo y bloquean la JVM al parar.
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            event.getServletContext().log("HikariCP DataSource cerrado");
        }
    }

    /**
     * Lee un parámetro de configuración con prioridad de fuentes.
     * Orden: variable de entorno > context-param de web.xml > valor por defecto.
     * 
     * Para Docker/Kubernetes: las variables de entorno se convierten a mayúsculas
     * con puntos reemplazados por guiones bajos.
     * p.ej: "db.url" → variable de entorno "DB_URL"
     */
    private String getConfig(ServletContext ctx, String key, String defaultValue) {
        String envValue = System.getenv(key.replace(".", "_").toUpperCase());
        if (envValue != null && !envValue.isEmpty()) return envValue;

        String ctxValue = ctx.getInitParameter(key);
        if (ctxValue != null && !ctxValue.isEmpty()) return ctxValue;

        return defaultValue;
    }
}
```

# 6. Recursos JNDI Globales y ResourceLink

## ¿Cuándo usar recursos globales?

Cuando tienes múltiples aplicaciones desplegadas en el mismo Tomcat que todas necesitan conectar a la misma base de datos, hay dos opciones:

1. **Recursos locales**: Cada aplicación tiene su propio pool configurado en su `context.xml`. Con 3 aplicaciones y `maxTotal=50` cada una, tienes potencialmente 150 conexiones abiertas al servidor de BD, aunque solo haya 10 peticiones activas en total.

2. **Recursos globales + ResourceLink**: El pool se define una sola vez a nivel del servidor. Todas las aplicaciones comparten ese único pool. Con `maxTotal=100`, nunca habrá más de 100 conexiones independientemente de cuántas aplicaciones haya. Mucho más eficiente.

## Definición de recursos globales

Los recursos globales se definen en el elemento `<GlobalNamingResources>` de `server.xml`:

```xml
<!-- server.xml -->
<GlobalNamingResources>

  <!-- ===== DataSource Global Compartido ===== -->
  <!--
    Este DataSource es compartido por TODAS las aplicaciones del servidor.
    Se define aquí una sola vez y se enlaza a cada aplicación con ResourceLink.
    maxTotal=100 es el límite TOTAL de conexiones para todas las aplicaciones.
  -->
  <Resource
    name="jdbc/GlobalDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"
    driverClassName="org.postgresql.Driver"
    url="jdbc:postgresql://db-host:5432/globaldb?ssl=true&amp;sslmode=require"
    username="${global.db.username}"
    password="${global.db.password}"
    maxTotal="100"
    maxIdle="20"
    minIdle="10"
    initialSize="10"
    maxWaitMillis="30000"
    testOnBorrow="true"
    validationQuery="SELECT 1"
    testWhileIdle="true"
    timeBetweenEvictionRunsMillis="30000"
    removeAbandonedOnBorrow="true"
    removeAbandonedTimeout="60"
    logAbandoned="true"/>

  <!-- ===== UserDatabase para la aplicación Manager de Tomcat ===== -->
  <!--
    Este es un recurso especial que Tomcat necesita internamente.
    Es la fuente de datos para el MemoryRealm (ver Módulo 06).
    Se define como recurso global y se referencia en el Realm de server.xml.
  -->
  <Resource
    name="UserDatabase"
    auth="Container"
    type="org.apache.catalina.UserDatabase"
    factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
    pathname="conf/tomcat-users.xml"
    readonly="true"/>

  <!-- ===== JavaMail Session Global ===== -->
  <!--
    Una sesión de correo compartida por todas las aplicaciones.
    Ver sección 7.9.1 para más detalles sobre JavaMail.
  -->
  <Resource
    name="mail/GlobalSession"
    auth="Container"
    type="javax.mail.Session"
    mail.smtp.host="smtp.miempresa.com"
    mail.smtp.port="587"
    mail.smtp.auth="true"
    mail.smtp.starttls.enable="true"
    mail.smtp.ssl.trust="smtp.miempresa.com"
    mail.smtp.user="${mail.username}"
    mail.smtp.password="${mail.password}"
    mail.debug="false"
    mail.transport.protocol="smtp"/>

</GlobalNamingResources>
```

## ResourceLink: conectar recursos globales con aplicaciones

El `<ResourceLink>` crea un enlace entre el nombre JNDI global y el nombre local que la aplicación usa para buscarlo. Es como un enlace simbólico en el sistema de archivos.

```xml
<!-- conf/Catalina/localhost/app1.xml -->
<Context path="/app1" docBase="/opt/apps/app1">

  <!--
    ResourceLink: "apunta" el nombre local "jdbc/MyDB" al recurso global "jdbc/GlobalDB".
    
    La aplicación app1 hace lookup("java:comp/env/jdbc/MyDB")
    y Tomcat le entrega el DataSource global "jdbc/GlobalDB".
    
    Esto permite que:
    1. El código de la aplicación use siempre "jdbc/MyDB" sin conocer si
       es un pool local o un enlace a un pool global.
    2. Puedas cambiar el pool global sin modificar el código de ninguna app.
    3. Múltiples apps compartan el mismo pool usando los ResourceLinks.
  -->
  <ResourceLink
    name="jdbc/MyDB"
    global="jdbc/GlobalDB"
    type="javax.sql.DataSource"/>

  <ResourceLink
    name="mail/Session"
    global="mail/GlobalSession"
    type="javax.mail.Session"/>

</Context>
```

```xml
<!-- conf/Catalina/localhost/app2.xml -->
<Context path="/app2" docBase="/opt/apps/app2">

  <!-- app1 y app2 comparten el MISMO pool de conexiones global.
       Las 100 conexiones de maxTotal se reparten entre ambas aplicaciones. -->
  <ResourceLink
    name="jdbc/MyDB"
    global="jdbc/GlobalDB"
    type="javax.sql.DataSource"/>

</Context>
```

```java
// El lookup del recurso en la aplicación es IDÉNTICO
// independientemente de si es un pool local o un ResourceLink.
// La abstracción JNDI oculta completamente si es local o global.
Context initCtx = new InitialContext();
DataSource ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/MyDB");
```

# 7. Monitorización del Pool de Conexiones

## ¿Por qué monitorizar el pool?

El pool de conexiones es un recurso compartido y finito. Si se agota (todas las conexiones están en uso), las peticiones comienzan a fallar o a retrasarse. Los problemas típicos que la monitorización permite detectar antes de que afecten a usuarios son:

- **Connection leaks:** El número de conexiones activas crece lentamente con el tiempo aunque la carga sea constante. Indica que algún código no devuelve las conexiones correctamente.
- **Pool exhaustion:** Picos de carga hacen que el pool llegue al 100% de uso. Puede requerir aumentar `maxTotal` o detectar queries lentas que retienen conexiones durante demasiado tiempo.
- **Conexiones rotas:** El servidor de BD se restaureó y el pool tiene conexiones inválidas que dan errores cuando se usan.

## Monitorización via JMX

**JMX** (*Java Management Extensions*) es el sistema estándar de Java para exponer métricas y operaciones de gestión en tiempo de ejecución. DBCP2 y Tomcat JDBC Pool registran automáticamente MBeans (Managed Beans) en el servidor JMX de la JVM con estadísticas del pool.

```java
package com.miempresa.monitoring;

import javax.management.*;
import java.lang.management.ManagementFactory;
import java.util.Set;
import java.util.logging.Logger;

/**
 * Monitor del pool de conexiones DBCP2 via JMX.
 * DBCP2 registra MBeans automáticamente en el MBeanServer de la JVM.
 * 
 * Los MBeans exponen métricas como:
 * - NumActive: conexiones actualmente prestadas al código
 * - NumIdle: conexiones disponibles en el pool
 * - MaxTotal: límite máximo de conexiones
 * - BorrowedCount: total de veces que se tomó una conexión (contador acumulado)
 * - ReturnedCount: total de veces que se devolvió una conexión
 */
public class ConnectionPoolMonitor {

    private static final Logger log =
        Logger.getLogger(ConnectionPoolMonitor.class.getName());

    public static void printPoolStats(String poolName) throws Exception {
        // Obtener el MBeanServer local de la JVM (hay uno por JVM)
        MBeanServer mbeanServer = ManagementFactory.getPlatformMBeanServer();

        // Buscar todos los MBeans del pool DBCP2 registrados.
        // El nombre ObjectName sigue el patrón:
        // "org.apache.commons.pool2:type=GenericObjectPool,name=*"
        // donde * es el nombre del pool.
        Set<ObjectName> names = mbeanServer.queryNames(
            new ObjectName("org.apache.commons.pool2:type=GenericObjectPool,name=*"),
            null
        );

        for (ObjectName name : names) {
            // Filtrar por el nombre del pool que nos interesa
            if (name.toString().contains(poolName)) {
                int numActive   = (int) mbeanServer.getAttribute(name, "NumActive");
                int numIdle     = (int) mbeanServer.getAttribute(name, "NumIdle");
                int maxTotal    = (int) mbeanServer.getAttribute(name, "MaxTotal");
                int maxIdle     = (int) mbeanServer.getAttribute(name, "MaxIdle");
                int minIdle     = (int) mbeanServer.getAttribute(name, "MinIdle");
                long waitCount     = (long) mbeanServer.getAttribute(name, "BorrowedCount");
                long returnedCount = (long) mbeanServer.getAttribute(name, "ReturnedCount");

                log.info(String.format("""
                    === Pool de Conexiones: %s ===
                    Activas:     %d / %d (máx)
                    Idle:        %d (min: %d, max: %d)
                    Prestadas:   %d | Devueltas: %d
                    Uso (%%):    %.1f
                    """,
                    poolName,
                    numActive, maxTotal,
                    numIdle, minIdle, maxIdle,
                    waitCount, returnedCount,
                    (double) numActive / maxTotal * 100
                ));

                // ALERTA: Si el uso supera el 80%, es un síntoma de que
                // podría agotarse bajo picos de carga. Alertar proactivamente.
                if ((double) numActive / maxTotal > 0.8) {
                    log.warning(String.format(
                        "⚠ ALERTA: Pool '%s' al %.0f%% de capacidad (%d/%d conexiones activas)",
                        poolName, (double) numActive / maxTotal * 100, numActive, maxTotal
                    ));
                }
            }
        }

        // Tomcat JDBC Pool usa un ObjectName diferente
        Set<ObjectName> tomcatPoolNames = mbeanServer.queryNames(
            new ObjectName("Catalina:type=DataSource,*"),
            null
        );

        for (ObjectName name : tomcatPoolNames) {
            log.info("Tomcat JDBC Pool MBean: " + name);
        }
    }

    /**
     * Monitorización continua en un hilo background.
     * 
     * Iniciarlo desde el contextInitialized() del AppContextListener.
     * El hilo es daemon (setDaemon(true)) para que no bloquee la JVM
     * al apagar la aplicación.
     * 
     * Lanza una alerta si el uso del pool supera el 80% de capacidad,
     * dando tiempo a escalar o investigar antes de que se agote.
     */
    public static void startContinuousMonitoring(String poolName,
                                                  int intervalSeconds) {
        Thread monitor = new Thread(() -> {
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    printPoolStats(poolName);
                    Thread.sleep(intervalSeconds * 1000L);
                } catch (InterruptedException e) {
                    // Preservar el flag de interrupción y salir del loop
                    Thread.currentThread().interrupt();
                    break;
                } catch (Exception e) {
                    log.warning("Error monitorizando pool: " + e.getMessage());
                }
            }
        }, "pool-monitor-thread");

        // setDaemon(true): El hilo no impedirá que la JVM se apague
        monitor.setDaemon(true);
        monitor.start();
    }
}
```

## Endpoint de health check del pool

Un health check endpoint es una URL HTTP que los **load balancers** y orquestadores (Kubernetes, AWS ELB, HAProxy) consultan periódicamente para saber si una instancia de la aplicación está sana y puede recibir tráfico.

Si el health check responde 200 OK, el balanceador envía tráfico. Si responde 503 Service Unavailable (o falla), el balanceador retira ese nodo del pool de servidores activos hasta que se recupere.

Kubernetes distingue dos tipos de checks:
- **Liveness probe:** ¿Está vivo el proceso? ¿Debe reiniciarse? Comprobación mínima.
- **Readiness probe:** ¿Puede aceptar tráfico ahora mismo? Comprobación de dependencias (BD, etc.).

```java
package com.miempresa.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Health check endpoint para el pool de conexiones.
 * 
 * Endpoints:
 *   GET /health/live  → Liveness:  ¿Está vivo el proceso?
 *   GET /health/ready → Readiness: ¿Puede aceptar tráfico (BD accesible)?
 *   GET /health       → Full:      Estado completo (BD + memoria)
 */
@WebServlet(urlPatterns = {"/health", "/health/db", "/health/live", "/health/ready"})
public class HealthCheckServlet extends HttpServlet {

    private DataSource dataSource;

    @Override
    public void init() {
        try {
            InitialContext ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/AppDB");
        } catch (Exception e) {
            // Si el DataSource no está disponible al inicializar, el Servlet
            // sigue arrancando pero el readiness check fallará.
            getServletContext().log("HealthCheck: DataSource no disponible", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String path = request.getServletPath();

        response.setContentType("application/json; charset=UTF-8");
        // Los health checks nunca deben ser cacheados por proxies
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("X-Health-Check", "tomcat-pool");

        switch (path) {
            case "/health/live"  -> checkLiveness(response);
            case "/health/ready" -> checkReadiness(response);
            default              -> checkFull(response);
        }
    }

    /**
     * Liveness check: Solo verifica que el proceso Java está respondiendo.
     * No comprueba la BD. Kubernetes usa esto para decidir si reiniciar el pod.
     * Si este check falla, es porque la JVM está bloqueada o en un estado irrecuperable.
     */
    private void checkLiveness(HttpServletResponse response)
            throws IOException {
        response.setStatus(HttpServletResponse.SC_OK); // 200
        response.getWriter().println("{\"status\":\"UP\",\"check\":\"liveness\"}");
    }

    /**
     * Readiness check: Verifica que la aplicación puede atender peticiones.
     * Incluye la verificación de la BD, ya que sin BD la app no puede funcionar.
     * Kubernetes usa esto para decidir si enviar tráfico al pod.
     * Un pod puede estar "vivo" (liveness=UP) pero "no listo" (readiness=DOWN)
     * si la BD no está accesible.
     */
    private void checkReadiness(HttpServletResponse response)
            throws IOException {
        long start = System.currentTimeMillis();

        if (dataSource == null) {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE); // 503
            response.getWriter().println("""
                {"status":"DOWN","check":"readiness",
                 "error":"DataSource no inicializado"}""");
            return;
        }

        try (Connection conn = dataSource.getConnection();
             Statement stmt  = conn.createStatement();
             ResultSet rs    = stmt.executeQuery("SELECT 1")) {

            long elapsed = System.currentTimeMillis() - start;
            rs.next(); // Consumir el resultado para completar la query

            response.setStatus(HttpServletResponse.SC_OK); // 200
            try (PrintWriter out = response.getWriter()) {
                out.printf("""
                    {"status":"UP","check":"readiness",
                     "database":"connected","responseMs":%d}%n""",
                    elapsed);
            }

        } catch (Exception e) {
            // La BD no está accesible. 503 indica al balanceador que
            // retire este nodo del pool de servidores activos.
            long elapsed = System.currentTimeMillis() - start;
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE); // 503
            try (PrintWriter out = response.getWriter()) {
                out.printf("""
                    {"status":"DOWN","check":"readiness",
                     "database":"unreachable",
                     "responseMs":%d,"error":"%s"}%n""",
                    elapsed, e.getMessage().replace("\"", "'"));
            }
        }
    }

    /**
     * Full health check: Estado completo de la aplicación.
     * Incluye estado de BD y uso de memoria heap.
     * Útil para dashboards de monitorización.
     */
    private void checkFull(HttpServletResponse response)
            throws IOException {

        boolean dbOk    = false;
        long    dbMs    = 0;
        String  dbError = null;

        if (dataSource != null) {
            long start = System.currentTimeMillis();
            try (Connection conn = dataSource.getConnection();
                 Statement stmt  = conn.createStatement()) {
                stmt.executeQuery("SELECT 1");
                dbOk = true;
                dbMs = System.currentTimeMillis() - start;
            } catch (Exception e) {
                dbMs    = System.currentTimeMillis() - start;
                dbError = e.getMessage();
            }
        }

        // Métricas de memoria de la JVM
        long heapUsed  = Runtime.getRuntime().totalMemory()
                       - Runtime.getRuntime().freeMemory();
        long heapMax   = Runtime.getRuntime().maxMemory();
        // Porcentaje de uso del heap: alta utilización persistente indica
        // que se aproxima un OutOfMemoryError
        double heapPct = (double) heapUsed / heapMax * 100;

        // El status global es DOWN si cualquier componente crítico está caído
        if (dbOk) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        }

        try (PrintWriter out = response.getWriter()) {
            out.printf("""
                {
                  "status": "%s",
                  "checks": {
                    "database": {
                      "status": "%s",
                      "responseMs": %d%s
                    },
                    "memory": {
                      "heapUsedMB": %d,
                      "heapMaxMB": %d,
                      "heapUsedPct": %.1f
                    }
                  }
                }%n""",
                dbOk ? "UP" : "DOWN",
                dbOk ? "UP" : "DOWN",
                dbMs,
                dbError != null
                    ? ",\"error\":\"" + dbError.replace("\"", "'") + "\""
                    : "",
                heapUsed / 1024 / 1024,
                heapMax  / 1024 / 1024,
                heapPct
            );
        }
    }
}
```

# 8. Anti-Patrones y Problemas Comunes del Pool

Esta sección muestra los errores más frecuentes que causan problemas de rendimiento y disponibilidad relacionados con el pool de conexiones.

## Connection Leak — Conexión no devuelta al pool

Un **connection leak** ocurre cuando el código toma una conexión del pool pero no la devuelve. La conexión queda "prestada" indefinidamente, reduciendo las conexiones disponibles. Con suficientes leaks, el pool se agota y todas las peticiones comienzan a fallar con `Cannot get connection, pool timeout`.

```java
// ❌ MAL: Si se lanza una excepción ANTES de conn.close(),
// la conexión nunca se devuelve al pool → connection leak.
// Con el tiempo, el pool se agota.
public void badExample() throws SQLException {
    Connection conn = dataSource.getConnection();
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users");
    ResultSet rs = stmt.executeQuery();
    processResults(rs); // ← Si esto lanza RuntimeException...
    stmt.close();
    conn.close(); // ← NUNCA SE EJECUTA si hay excepción arriba
}

// ✅ BIEN: try-with-resources garantiza el cierre SIEMPRE.
// El compilador Java genera automáticamente el bloque finally
// con las llamadas a close() en orden inverso al de apertura.
public void goodExample() throws SQLException {
    try (Connection conn = dataSource.getConnection();
         PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users");
         ResultSet rs = stmt.executeQuery()) {
        processResults(rs);
    } // ← conn.close() llamado SIEMPRE (éxito o excepción)
}
```

## Pool Exhaustion bajo carga

El **pool exhaustion** ocurre cuando todas las conexiones del pool están en uso y no hay disponibles para nuevas peticiones. Las causas más comunes son connection leaks, queries muy lentas que retienen conexiones durante mucho tiempo, o un pool demasiado pequeño para la carga real.

```java
// ❌ MAL: Guardar la conexión en un campo de instancia del Servlet.
// Un Servlet tiene UNA SOLA instancia que atiende TODAS las peticiones concurrentes.
// Guardar la conexión aquí significa que solo hay UNA conexión para todas las peticiones
// simultáneas → serialización y bloqueo.
public class BadServlet extends HttpServlet {
    private Connection conn; // ← NUNCA guardar en campo de instancia

    public void init() throws ServletException {
        try {
            // Esta única conexión atiende a todos los usuarios concurrentes
            conn = dataSource.getConnection();
        } catch (SQLException e) { throw new ServletException(e); }
    }
    // Además, si el Servlet se destruye sin cerrar conn, es un leak permanente
}

// ❌ MAL: Obtener la conexión mucho antes de necesitarla.
// La conexión está "prestada" (y no disponible para otros) durante toda
// la lógica de negocio previa a la query, aunque esa lógica no use la BD.
public void badScope() throws SQLException {
    Connection conn = dataSource.getConnection(); // ← Obtener aquí (demasiado pronto)
    doSomeBusinessLogic();    // Operaciones sin BD (la conexión está bloqueada sin usar)
    doMoreBusinessLogic();    // Más tiempo con la conexión bloqueada
    PreparedStatement stmt = conn.prepareStatement("SELECT 1");
    // ... usar la conexión ...
    conn.close(); // Devolver la conexión al pool (demasiado tarde)
}

// ✅ BIEN: Obtener la conexión lo más tarde posible y cerrarla inmediatamente.
// La conexión solo está "prestada" durante el tiempo estrictamente necesario
// para ejecutar las operaciones de BD. El resto del tiempo, está disponible
// en el pool para otras peticiones.
public void goodScope() throws SQLException {
    doSomeBusinessLogic();    // Sin conexión → conexión libre en el pool
    doMoreBusinessLogic();    // Sin conexión → conexión libre en el pool

    // Solo tener la conexión durante el tiempo estrictamente necesario
    try (Connection conn = dataSource.getConnection();
         PreparedStatement stmt = conn.prepareStatement("SELECT 1")) {
        // ... operación de BD rápida ...
    } // ← conexión devuelta al pool inmediatamente
}
```

## Tabla de síntomas y diagnóstico

Cuando el pool da problemas, los errores en los logs pueden ser crípticos. Esta tabla mapea síntomas a causas y soluciones:

| Síntoma                                    | Causa probable                          | Solución                                      |
|--------------------------------------------|-----------------------------------------|-----------------------------------------------|
| `Cannot get connection, pool timeout`      | Pool exhausto (maxTotal alcanzado)      | Aumentar `maxTotal`, buscar connection leaks  |
| Queries muy lentas intermitentemente       | Conexiones obsoletas/rotas en el pool   | Habilitar `testOnBorrow=true`                 |
| `Connection is closed` en producción       | Conexión idle expirada por la BD        | Configurar `testWhileIdle` y `validationQuery`|
| Pool se queda con conexiones abandonadas   | Código no cierra conexiones             | Habilitar `removeAbandonedOnBorrow=true`      |
| OutOfMemory relacionado con JDBC           | Statement leak (no se cierran Statements)| Usar `StatementFinalizer` interceptor        |
| BD rechaza nuevas conexiones               | `maxTotal` demasiado alto vs límites BD | Reducir `maxTotal`, revisar `max_connections` |
| Deadlock en inicio de la app               | `initialSize` > límite BD en ese momento| Reducir `initialSize` o usar lazy init       |

**Notas de diagnóstico:**

**`Cannot get connection, pool timeout`:** Revisar los logs de abandoned connections (`logAbandoned=true`) para identificar dónde se produce el leak. Verificar en la BD cuántas conexiones reales están abiertas (`SELECT count(*) FROM pg_stat_activity` en PostgreSQL) para comparar con las que el pool cree tener.

**`Connection is closed`:** Ocurre cuando el servidor de BD cierra conexiones inactivas por su propio timeout (común en MySQL con `wait_timeout=28800`). La solución es que el pool detecte y descarte esas conexiones antes de dárselas al código. `testOnBorrow=true` es la solución directa; `testWhileIdle` es más eficiente (los detecta en background antes de que los pida el código).

**BD rechaza conexiones:** Cada base de datos tiene un límite de conexiones simultáneas (`max_connections` en PostgreSQL, `max_connections` en MySQL). Si `maxTotal * instancias_tomcat > max_connections`, la BD empezará a rechazar conexiones bajo carga. La solución es usar recursos globales con `ResourceLink` para compartir un pool entre aplicaciones, o reducir `maxTotal`.

# 9. Configuración de JNDI para Otros Recursos

JNDI no solo gestiona DataSources de bases de datos. Puede registrar cualquier tipo de recurso compartido que la aplicación necesite.

## JavaMail Session

JavaMail es la API de Java para enviar y recibir correo electrónico. Configurar la sesión SMTP via JNDI permite cambiar el servidor de correo o las credenciales sin recompilar la aplicación.

```xml
<!-- context.xml / server.xml GlobalNamingResources -->
<Resource
  name="mail/AppMailSession"
  auth="Container"
  type="javax.mail.Session"
  <!--
    Tipo JavaMail Session. Requiere tener el JAR de JavaMail/Jakarta Mail
    en $CATALINA_HOME/lib/:
    - jakarta.mail-*.jar (para Tomcat 10+)
    - javax.mail-*.jar  (para Tomcat 9-)
  -->
  mail.smtp.host="smtp.miempresa.com"
  mail.smtp.port="587"
  <!--
    Puerto 587: SMTP con STARTTLS (el más habitual hoy en día).
    Puerto 465: SMTPS (SMTP sobre TLS directo, legacy).
    Puerto 25:  SMTP sin cifrar (solo para servidores internos confiables).
  -->
  mail.smtp.auth="true"
  <!--
    Requiere autenticación con usuario/contraseña en el servidor SMTP.
    Obligatorio en cualquier servidor SMTP externo moderno.
  -->
  mail.smtp.starttls.enable="true"
  <!--
    STARTTLS: La conexión empieza sin cifrar (puerto 587) y luego se
    actualiza a TLS. Diferente a SSL directo (puerto 465).
  -->
  mail.smtp.starttls.required="true"
  <!--
    Si el servidor no soporta STARTTLS, fallar (no enviar sin cifrar).
  -->
  mail.smtp.ssl.protocols="TLSv1.2 TLSv1.3"
  <!--
    Solo usar TLS 1.2 o superior. Por seguridad, no aceptar TLS 1.0/1.1.
  -->
  mail.smtp.connectiontimeout="10000"  <!-- Timeout de conexión TCP al SMTP en ms -->
  mail.smtp.timeout="30000"            <!-- Timeout de operaciones SMTP en ms -->
  mail.smtp.writetimeout="30000"       <!-- Timeout para escribir datos al SMTP en ms -->
  mail.from="noreply@miempresa.com"
  mail.debug="false"/>
  <!--
    mail.debug=true: Muestra todo el diálogo SMTP en los logs.
    NUNCA en producción (expone contenido de los mensajes y credenciales).
    Usar solo para depurar problemas de envío en desarrollo.
  -->
```

```java
// Uso de JavaMail via JNDI
// La Session se obtiene una vez y se reutiliza (es thread-safe)
Context ctx     = new InitialContext();
Session session = (Session) ctx.lookup("java:comp/env/mail/AppMailSession");

Message message = new MimeMessage(session);
message.setFrom(new InternetAddress("noreply@miempresa.com"));
message.setRecipients(Message.RecipientType.TO,
    InternetAddress.parse("usuario@ejemplo.com"));
message.setSubject("Notificación del sistema");
message.setText("Contenido del mensaje");

// Si las credenciales SMTP no están en el Resource JNDI,
// se proporcionan aquí al crear el Transport
Transport transport = session.getTransport("smtp");
transport.connect("${mail.username}", "${mail.password}");
transport.sendMessage(message, message.getAllRecipients());
transport.close(); // IMPORTANTE: cerrar el Transport al terminar
```

## Variable de entorno JNDI

JNDI también puede usarse para publicar constantes de configuración (no solo DataSources). Es una alternativa a los `context-param` de `web.xml` para configuración que cambia entre entornos.

**Ventaja sobre context-param:** Las `<Environment>` JNDI se pueden definir en el context descriptor específico del entorno (dev, staging, prod) sin modificar el WAR. Los `context-param` de `web.xml` están dentro del WAR y requieren recompilar para cambiarlos.

```xml
<!-- Context descriptor específico del entorno -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Environment
    name="maxConcurrentUsers"
    value="5000"
    type="java.lang.Integer"
    <!--
      Tipo Java del valor. JNDI hace la conversión de String a Integer
      automáticamente al hacer el lookup.
    -->
    override="false"
    <!--
      override=false: La aplicación NO puede sobreescribir este valor
      en tiempo de ejecución. La configuración del servidor prevalece
      sobre cualquier intento de la aplicación de cambiarla.
    -->
    description="Máximo de usuarios concurrentes permitidos"/>

  <Environment
    name="featureFlags/newDashboard"
    value="true"
    type="java.lang.Boolean"
    <!--
      Los flags de funcionalidades (feature flags) permiten activar/desactivar
      funcionalidades sin redesplegar. Aquí se configuran por entorno.
    -->
    override="false"/>

  <Environment
    name="config/apiBaseUrl"
    value="https://api.miempresa.com/v2"
    type="java.lang.String"
    override="false"/>

</Context>
```

```java
// Lookup de variables de entorno JNDI
// El tipo devuelto por lookup() es Object; el cast es seguro porque
// JNDI ya hizo la conversión al tipo declarado en <Environment>.
Context ctx = new InitialContext();
Integer maxUsers = (Integer) ctx.lookup(
    "java:comp/env/maxConcurrentUsers");
Boolean newDashboard = (Boolean) ctx.lookup(
    "java:comp/env/featureFlags/newDashboard");
String apiUrl = (String) ctx.lookup(
    "java:comp/env/config/apiBaseUrl");
```

# 10. Diferencias de JNDI y Pools entre Versiones de Tomcat

| Característica                              | 8.0   | 8.5   | 9.0   | 10.x  | 11.0  |
|---------------------------------------------|-------|-------|-------|-------|-------|
| DBCP2 incluido                              | ✅    | ✅    | ✅    | ✅    | ✅    |
| Tomcat JDBC Pool incluido                   | ✅    | ✅    | ✅    | ✅    | ✅    |
| HikariCP integrado nativamente              | ❌    | ❌    | ❌    | ❌    | ❌    |
| `javax.sql.DataSource` namespace            | ✅    | ✅    | ✅    | ✅*   | ✅*   |
| SlowQueryReport interceptor                 | ✅    | ✅    | ✅    | ✅    | ✅    |
| ResourceLink a recursos globales            | ✅    | ✅    | ✅    | ✅    | ✅    |
| Variables de entorno JNDI (`<Environment>`) | ✅    | ✅    | ✅    | ✅    | ✅    |
| JMX MBeans del pool automáticos             | ✅    | ✅    | ✅    | ✅    | ✅    |
| `maxConnLifetimeMillis` en DBCP2            | ❌    | ✅    | ✅    | ✅    | ✅    |
| `keepaliveTime` en HikariCP                 | N/A   | N/A   | N/A   | N/A   | N/A   |

*`javax.sql.DataSource` es parte de **Java SE** (paquete `javax.sql`), no de Jakarta EE. Por eso no cambia de namespace cuando se pasa de Tomcat 9 a Tomcat 10+. El cambio `javax.*` → `jakarta.*` solo afecta a las APIs propias de Jakarta EE (Servlet, JPA, CDI, etc.), no a las APIs de Java SE.

**HikariCP nunca estará integrado nativamente** en Tomcat porque es una librería de terceros (Brettwooldridge/zaxxer). Tomcat solo puede incluir código bajo la licencia Apache. HikariCP siempre requerirá añadir el JAR manualmente.

**`maxConnLifetimeMillis`** disponible desde DBCP2 2.1, incluido en Tomcat 8.5+. En Tomcat 8.0 (DBCP2 anterior), las conexiones no tenían tiempo de vida máximo, lo que podía causar que conexiones muy antiguas con problemas persistieran indefinidamente.

# 11. Puntos Clave

- Un **pool de conexiones** mantiene conexiones abiertas y reutilizables a la BD. Abrirlas en cada petición es demasiado costoso (20-100 ms por conexión) para un servidor de alta carga.

- El árbol JNDI de Tomcat tiene dos espacios: `java:comp/env/` para recursos locales de la aplicación y `java:/global/` para recursos globales del servidor accesibles vía `ResourceLink`.

- **Siempre usar `try-with-resources`** con `Connection`, `Statement` y `ResultSet`. Es la única garantía de que la conexión se devuelve al pool en cualquier circunstancia, incluyendo excepciones no controladas.

- El **Tomcat JDBC Pool** es superior a DBCP2 en entornos de alta carga gracias a los **Interceptors** (`SlowQueryReport`, `StatementFinalizer`, `StatementCache`), que añaden funcionalidad transversal sin modificar el código de la aplicación.

- **HikariCP** proporciona el mejor rendimiento bruto pero requiere una factory JNDI personalizada o inicialización programática en un Listener. No está integrado de forma nativa en Tomcat.

- Configurar siempre `testOnBorrow=true` y `validationQuery` para detectar conexiones rotas (causadas por reinicios de la BD, timeouts de red, etc.) antes de entregarlas a la aplicación.

- Habilitar `removeAbandonedOnBorrow=true` con `logAbandoned=true` para detectar y diagnosticar connection leaks. El stack trace del log indica exactamente en qué línea de código se produjo el leak.

- Usar **`ResourceLink`** para compartir un pool de conexiones entre múltiples aplicaciones del mismo servidor, evitando la multiplicación de pools y el agotamiento de conexiones en la BD.

- El **health check endpoint** es imprescindible en entornos con load balancer. Responde 200 si la BD está accesible, 503 si no. El balanceador retira del tráfico los nodos que responden 503.

- Obtener la conexión del pool **lo más tarde posible** y cerrarla **lo más pronto posible**. Cada milisegundo que la conexión está prestada es tiempo que no está disponible para otras peticiones.

- El `maxTotal` del pool **nunca debe superar** el límite de conexiones simultáneas de la base de datos dividido entre el número de instancias de Tomcat. Superar este límite hace que la BD rechace conexiones bajo carga.

- El driver JDBC de la BD (PostgreSQL, MySQL, Oracle, etc.) debe estar en **`$CATALINA_HOME/lib/`**, no en `WEB-INF/lib/`. El pool de conexiones es un componente de Tomcat, no de la aplicación, y carga clases desde el classloader del servidor.