## Módulo 07: Pools de Conexiones JNDI y DataSources

## 7.1 Arquitectura JNDI en Tomcat

JNDI (Java Naming and Directory Interface) es el mecanismo estándar de Java EE / Jakarta EE para el registro y localización de recursos compartidos. En Tomcat, JNDI actúa como un **registro de recursos** que permite a las aplicaciones obtener referencias a DataSources, colas JMS, configuraciones y otros objetos sin acoplar el código a implementaciones concretas.

### 7.1.1 Jerarquía del árbol JNDI en Tomcat

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

### 7.1.2 Lookup de recursos JNDI en código Java

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

    // Cache del DataSource — el pool en sí es thread-safe
    private final DataSource dataSource;

    public UserDao() {
        this.dataSource = lookupDataSource();
    }

    private DataSource lookupDataSource() {
        try {
            // InitialContext obtiene el contexto JNDI de Tomcat
            Context initCtx = new InitialContext();

            // java:comp/env/ es el prefijo estándar para recursos del contexto
            Context envCtx = (Context) initCtx.lookup("java:comp/env");

            DataSource ds = (DataSource) envCtx.lookup(DATASOURCE_JNDI);
            log.info("DataSource JNDI obtenido: " + DATASOURCE_JNDI);
            return ds;

        } catch (NamingException e) {
            throw new RuntimeException(
                "No se pudo obtener el DataSource JNDI: " + DATASOURCE_JNDI, e
            );
        }
    }

    /**
     * Patrón correcto de uso del pool de conexiones:
     * try-with-resources garantiza el retorno de la conexión al pool
     * incluso en caso de excepción.
     */
    public User findById(Long id) throws SQLException {
        String sql = "SELECT id, username, email, created_at " +
                     "FROM app_users WHERE id = ? AND enabled = TRUE";

        // CRÍTICO: siempre usar try-with-resources con Connection
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
                return null;
            }
        }
        // La conexión se devuelve AUTOMÁTICAMENTE al pool aquí
    }

    public void save(User user) throws SQLException {
        String sql = "INSERT INTO app_users " +
                     "(username, email, password_hash, created_at) " +
                     "VALUES (?, ?, ?, NOW())";

        try (Connection conn = dataSource.getConnection()) {
            // Desactivar autocommit para transacciones explícitas
            conn.setAutoCommit(false);

            try (PreparedStatement stmt = conn.prepareStatement(
                    sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

                stmt.setString(1, user.getUsername());
                stmt.setString(2, user.getEmail());
                stmt.setString(3, user.getPasswordHash());

                int rows = stmt.executeUpdate();

                if (rows != 1) {
                    conn.rollback();
                    throw new SQLException("Insert no afectó a ninguna fila");
                }

                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        user.setId(keys.getLong(1));
                    }
                }

                conn.commit();

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
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

---

## 7.2 Implementaciones de Pool de Conexiones en Tomcat

Tomcat incluye dos implementaciones propias de pool de conexiones y es compatible con librerías de terceros:

| Implementación            | Incluida en Tomcat | Recomendada para       | Jar                    |
|---------------------------|--------------------|------------------------|------------------------|
| Apache DBCP2              | ✅ Sí              | Uso general            | `tomcat-dbcp.jar`      |
| Tomcat JDBC Pool          | ✅ Sí              | Alto rendimiento       | `tomcat-jdbc.jar`      |
| HikariCP                  | ❌ Externa         | Máximo rendimiento     | `HikariCP-*.jar`       |
| c3p0                      | ❌ Externa         | Legacy                 | `c3p0-*.jar`           |

### Comparativa de rendimiento

| Métrica                        | DBCP2     | Tomcat JDBC | HikariCP  |
|--------------------------------|-----------|-------------|-----------|
| Latencia de adquisición        | Media     | Baja        | Muy baja  |
| Throughput bajo carga          | Medio     | Alto        | Muy alto  |
| Overhead de memoria            | Medio     | Bajo        | Muy bajo  |
| Complejidad de configuración   | Media     | Media       | Baja      |
| Detección de conexiones rotas  | Sí        | Sí          | Sí        |
| Statement caching              | Sí        | Sí          | No        |
| Interceptors                   | No        | ✅ Sí       | No        |

---

## 7.3 Configuración con Apache DBCP2

### 7.3.1 Configuración completa en Context descriptor

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Resource
    name="jdbc/AppDB"
    auth="Container"
    type="javax.sql.DataSource"

    <!-- Factory de DBCP2 -->
    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"

    <!-- ===== Driver y URL ===== -->
    driverClassName="org.postgresql.Driver"
    url="jdbc:postgresql://db-host:5432/appdb
         ?ssl=true
         &amp;sslmode=require
         &amp;connectTimeout=10
         &amp;socketTimeout=30
         &amp;ApplicationName=myapp-tomcat"
    username="${db.username}"
    password="${db.password}"

    <!-- ===== Tamaño del Pool ===== -->
    <!-- Conexiones máximas simultáneas -->
    maxTotal="50"
    <!-- Conexiones máximas en estado idle (inactivas) -->
    maxIdle="10"
    <!-- Conexiones mínimas mantenidas en idle -->
    minIdle="5"
    <!-- Conexiones creadas al arrancar (warm-up del pool) -->
    initialSize="5"

    <!-- ===== Timeouts ===== -->
    <!-- Tiempo máximo de espera para obtener conexión del pool (ms) -->
    maxWaitMillis="30000"
    <!-- Tiempo que una conexión puede estar idle antes de ser eliminada (ms) -->
    minEvictableIdleTimeMillis="300000"
    <!-- Tiempo máximo de vida de una conexión (ms). 0 = indefinido -->
    maxConnLifetimeMillis="3600000"

    <!-- ===== Validación de Conexiones ===== -->
    <!-- Query de validación de la conexión -->
    validationQuery="SELECT 1"
    <!-- Timeout de la query de validación (segundos) -->
    validationQueryTimeout="5"
    <!-- Validar conexión al obtenerla del pool -->
    testOnBorrow="true"
    <!-- Validar conexión al devolverla al pool -->
    testOnReturn="false"
    <!-- Validar conexiones idle en background -->
    testWhileIdle="true"
    <!-- Intervalo entre ejecuciones del hilo de mantenimiento (ms) -->
    timeBetweenEvictionRunsMillis="30000"
    <!-- Número de conexiones idle verificadas por ciclo de mantenimiento -->
    numTestsPerEvictionRun="5"

    <!-- ===== Conexiones Abandonadas ===== -->
    <!-- Eliminar conexiones no devueltas al pool tras N segundos -->
    removeAbandonedOnBorrow="true"
    removeAbandonedOnMaintenance="true"
    removeAbandonedTimeout="60"
    <!-- Loguear el stack trace del código que abandonó la conexión -->
    logAbandoned="true"
    abandonedUsageTracking="true"

    <!-- ===== Statement Cache (PreparedStatement) ===== -->
    poolPreparedStatements="true"
    maxOpenPreparedStatements="200"

    <!-- ===== Propiedades de conexión adicionales ===== -->
    connectionProperties="useUnicode=true;characterEncoding=utf8;
                          rewriteBatchedStatements=true"

    <!-- ===== Configuración de autocommit ===== -->
    defaultAutoCommit="true"
    defaultTransactionIsolation="READ_COMMITTED"
    defaultReadOnly="false"

    <!-- ===== Rollback en retorno al pool ===== -->
    rollbackOnReturn="true"
    enableAutoCommitOnReturn="true"

    <!-- Nombre de la conexión para identificación en BD -->
    connectionInitSqls="SET application_name='myapp-tomcat'"
    description="Pool de conexiones principal de myapp"/>

</Context>
```

### 7.3.2 Configuración para múltiples bases de datos

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

  <!-- Base de datos de reportes (MySQL read replica) -->
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

  <!-- Oracle Database -->
  <Resource
    name="jdbc/OracleDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory"
    driverClassName="oracle.jdbc.OracleDriver"
    url="jdbc:oracle:thin:@//oracle-host:1521/ORCLPDB1"
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

---

## 7.4 Configuración con Tomcat JDBC Pool

El Tomcat JDBC Pool es una alternativa a DBCP2 con mayor rendimiento, diseñada específicamente para entornos multi-hilo de alta carga. Su característica más importante son los **Interceptors**.

### 7.4.1 Configuración completa

```xml
<Resource
  name="jdbc/AppDB"
  auth="Container"
  type="javax.sql.DataSource"

  <!-- Factory del Tomcat JDBC Pool -->
  factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"

  <!-- ===== Driver y URL ===== -->
  driverClassName="org.postgresql.Driver"
  url="jdbc:postgresql://db-host:5432/appdb?ssl=true&amp;sslmode=require"
  username="${db.username}"
  password="${db.password}"

  <!-- ===== Tamaño del Pool ===== -->
  initialSize="10"
  maxActive="100"
  maxIdle="20"
  minIdle="10"
  maxWait="30000"

  <!-- ===== Validación ===== -->
  testOnBorrow="true"
  testOnReturn="false"
  testWhileIdle="true"
  validationQuery="SELECT 1"
  validationQueryTimeout="5"
  validationInterval="30000"

  <!-- ===== Mantenimiento ===== -->
  timeBetweenEvictionRunsMillis="30000"
  minEvictableIdleTimeMillis="60000"
  maxAge="3600000"

  <!-- ===== Conexiones Abandonadas ===== -->
  removeAbandoned="true"
  removeAbandonedTimeout="60"
  logAbandoned="true"
  abandonWhenPercentageFull="50"

  <!-- ===== Transacciones ===== -->
  defaultAutoCommit="true"
  defaultTransactionIsolation="READ_COMMITTED"
  rollbackOnReturn="false"
  commitOnReturn="false"

  <!-- ===== Interceptors del Tomcat JDBC Pool ===== -->
  <!--
    Interceptors: cadena de procesamiento AOP sobre el pool.
    Se ejecutan en orden para cada operación del pool.

    ResetAbandonedTimer: reinicia el timer de abandoned al usar la conexión
    StatementFinalizer:  cierra Statements no cerrados explícitamente
    StatementCache:      caché de PreparedStatements a nivel de pool
    SlowQueryReport:     reporta queries que superan el threshold (ms)
    ConnectionState:     gestiona el estado de autocommit/readOnly/isolation
    QueryTimeoutInterceptor: establece timeout en cada Statement
  -->
  jdbcInterceptors="ResetAbandonedTimer;
                    StatementFinalizer;
                    StatementCache(max=500);
                    SlowQueryReport(threshold=1000,maxQueries=1000);
                    ConnectionState;
                    QueryTimeoutInterceptor(queryTimeout=30)"

  <!-- ===== Fair Queue ===== -->
  <!-- Si true, las peticiones de conexión se sirven en orden FIFO -->
  fairQueue="true"

  <!-- ===== JMX ===== -->
  jmxEnabled="true"

  <!-- ===== Propiedades adicionales de la conexión ===== -->
  connectionProperties="ApplicationName=myapp-tomcat;
                        connectTimeout=10000;
                        socketTimeout=30000"/>
```

### 7.4.2 Interceptor personalizado para auditoría

```java
package com.miempresa.jdbc.interceptor;

import org.apache.tomcat.jdbc.pool.interceptor.AbstractQueryReport;
import java.lang.reflect.Method;
import java.util.logging.Logger;

/**
 * Interceptor personalizado para Tomcat JDBC Pool.
 * Registra todas las queries con su tiempo de ejecución
 * e identifica las queries lentas.
 */
public class AuditQueryInterceptor extends AbstractQueryReport {

    private static final Logger log =
        Logger.getLogger(AuditQueryInterceptor.class.getName());

    // Threshold en ms para considerar una query como lenta
    private long slowQueryThreshold = 500;

    @Override
    public void setProperties(java.util.Map<String, java.util.concurrent.atomic.AtomicInteger> properties) {
        // Configurar desde jdbcInterceptors="AuditQueryInterceptor(threshold=500)"
    }

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

    @Override
    public Object invoke(Object proxy, Method method, Object[] args)
            throws Throwable {
        return super.invoke(proxy, method, args);
    }
}
```

---

## 7.5 Configuración con HikariCP (Externa)

HikariCP es la implementación de pool de conexiones de mayor rendimiento disponible para Java. Requiere incluir el JAR en `WEB-INF/lib/` o en `$CATALINA_HOME/lib/`.

### 7.5.1 Configuración via Context descriptor con factory personalizado

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Resource
    name="jdbc/AppDB"
    auth="Container"
    type="javax.sql.DataSource"

    <!-- Factory personalizado para HikariCP -->
    factory="com.miempresa.jndi.HikariDataSourceFactory"

    driverClassName="org.postgresql.Driver"
    jdbcUrl="jdbc:postgresql://db-host:5432/appdb?ssl=true&amp;sslmode=require"
    username="${db.username}"
    password="${db.password}"

    <!-- HikariCP específicos -->
    poolName="MyAppHikariPool"
    maximumPoolSize="50"
    minimumIdle="10"
    connectionTimeout="30000"
    idleTimeout="600000"
    maxLifetime="1800000"
    keepaliveTime="60000"
    connectionTestQuery="SELECT 1"
    leakDetectionThreshold="60000"
    autoCommit="true"
    readOnly="false"
    transactionIsolation="TRANSACTION_READ_COMMITTED"
    initializationFailTimeout="1"
    isolateInternalQueries="false"
    registerMbeans="true"

    <!-- Propiedades del driver PostgreSQL -->
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
import java.util.Properties;

/**
 * Factory JNDI para HikariCP.
 * Permite registrar HikariDataSource como recurso JNDI en Tomcat.
 */
public class HikariDataSourceFactory implements ObjectFactory {

    @Override
    public Object getObjectInstance(Object obj,
                                    Name name,
                                    Context nameCtx,
                                    Hashtable<?, ?> environment)
            throws Exception {

        Reference ref = (Reference) obj;
        HikariConfig config = new HikariConfig();

        // Mapear atributos del Resource XML a HikariConfig
        Enumeration<RefAddr> addrs = ref.getAll();
        while (addrs.hasMoreElements()) {
            RefAddr addr = addrs.nextElement();
            String addrName  = addr.getType();
            String addrValue = addr.getContent().toString();

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
                    // Propiedades específicas del DataSource (dataSource.*)
                    if (addrName.startsWith("dataSource.")) {
                        config.addDataSourceProperty(
                            addrName.substring("dataSource.".length()),
                            addrValue
                        );
                    }
                }
            }
        }

        return new HikariDataSource(config);
    }
}
```

### 7.5.2 Configuración programática con ServletContextListener

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

        // Obtener configuración desde parámetros del contexto o variables de entorno
        config.setJdbcUrl(getConfig(ctx, "db.url",
            "jdbc:postgresql://localhost:5432/appdb"));
        config.setUsername(getConfig(ctx, "db.username", "appuser"));
        config.setPassword(getConfig(ctx, "db.password", ""));
        config.setDriverClassName("org.postgresql.Driver");

        // Pool sizing
        config.setMaximumPoolSize(50);
        config.setMinimumIdle(10);
        config.setConnectionTimeout(30_000);
        config.setIdleTimeout(600_000);
        config.setMaxLifetime(1_800_000);
        config.setKeepaliveTime(60_000);
        config.setLeakDetectionThreshold(60_000);

        // Nombres y métricas
        config.setPoolName("AppHikariPool");
        config.setRegisterMbeans(true);
        config.setAutoCommit(true);
        config.setTransactionIsolation("TRANSACTION_READ_COMMITTED");

        // Propiedades del driver PostgreSQL
        config.addDataSourceProperty("ssl",             "true");
        config.addDataSourceProperty("sslmode",         "require");
        config.addDataSourceProperty("connectTimeout",  "10");
        config.addDataSourceProperty("socketTimeout",   "30");
        config.addDataSourceProperty("applicationName", "myapp-hikari");
        config.addDataSourceProperty("reWriteBatchedInserts", "true");

        // Statement cache PostgreSQL
        config.addDataSourceProperty("preparedStatementCacheQueries", "250");
        config.addDataSourceProperty("preparedStatementCacheSizeMiB", "5");

        dataSource = new HikariDataSource(config);

        // Publicar en el contexto de la aplicación
        ctx.setAttribute("dataSource", dataSource);

        ctx.log("HikariCP DataSource inicializado. Pool: "
            + config.getPoolName()
            + ", MaxPool: " + config.getMaximumPoolSize());
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            event.getServletContext().log("HikariCP DataSource cerrado");
        }
    }

    private String getConfig(ServletContext ctx, String key, String defaultValue) {
        // Prioridad: variable de entorno > parámetro de contexto > valor por defecto
        String envValue = System.getenv(key.replace(".", "_").toUpperCase());
        if (envValue != null && !envValue.isEmpty()) return envValue;

        String ctxValue = ctx.getInitParameter(key);
        if (ctxValue != null && !ctxValue.isEmpty()) return ctxValue;

        return defaultValue;
    }
}
```

---

## 7.6 Recursos JNDI Globales y ResourceLink

### 7.6.1 Definición de recursos globales

```xml
<!-- server.xml -->
<GlobalNamingResources>

  <!-- ===== DataSource Global Compartido ===== -->
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

  <!-- ===== UserDatabase para Manager ===== -->
  <Resource
    name="UserDatabase"
    auth="Container"
    type="org.apache.catalina.UserDatabase"
    factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
    pathname="conf/tomcat-users.xml"
    readonly="true"/>

  <!-- ===== JavaMail Session Global ===== -->
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

### 7.6.2 ResourceLink: conectar recursos globales con aplicaciones

```xml
<!-- conf/Catalina/localhost/app1.xml -->
<Context path="/app1" docBase="/opt/apps/app1">

  <!--
    ResourceLink: expone el recurso global bajo un nombre local.
    La aplicación hace lookup de "java:comp/env/jdbc/MyDB"
    y obtiene el DataSource global "jdbc/GlobalDB".
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

  <!-- Ambas apps comparten el MISMO pool de conexiones global -->
  <ResourceLink
    name="jdbc/MyDB"
    global="jdbc/GlobalDB"
    type="javax.sql.DataSource"/>

</Context>
```

```java
// Lookup del recurso en la aplicación — idéntico
// independientemente de si es local o vía ResourceLink
Context initCtx = new InitialContext();
DataSource ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/MyDB");
```

---

## 7.7 Monitorización del Pool de Conexiones

### 7.7.1 Monitorización via JMX

```java
package com.miempresa.monitoring;

import javax.management.*;
import java.lang.management.ManagementFactory;
import java.util.Set;
import java.util.logging.Logger;

/**
 * Monitor del pool de conexiones DBCP2 via JMX.
 * DBCP2 registra MBeans automáticamente en el MBeanServer de la JVM.
 */
public class ConnectionPoolMonitor {

    private static final Logger log =
        Logger.getLogger(ConnectionPoolMonitor.class.getName());

    public static void printPoolStats(String poolName) throws Exception {
        MBeanServer mbeanServer = ManagementFactory.getPlatformMBeanServer();

        // Buscar MBeans del pool DBCP2
        Set<ObjectName> names = mbeanServer.queryNames(
            new ObjectName("org.apache.commons.pool2:type=GenericObjectPool,name=*"),
            null
        );

        for (ObjectName name : names) {
            if (name.toString().contains(poolName)) {
                int numActive   = (int) mbeanServer.getAttribute(name, "NumActive");
                int numIdle     = (int) mbeanServer.getAttribute(name, "NumIdle");
                int maxTotal    = (int) mbeanServer.getAttribute(name, "MaxTotal");
                int maxIdle     = (int) mbeanServer.getAttribute(name, "MaxIdle");
                int minIdle     = (int) mbeanServer.getAttribute(name, "MinIdle");
                long waitCount  = (long) mbeanServer.getAttribute(name, "BorrowedCount");
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
            }
        }

        // Tomcat JDBC Pool MBeans
        Set<ObjectName> tomcatPoolNames = mbeanServer.queryNames(
            new ObjectName("Catalina:type=DataSource,*"),
            null
        );

        for (ObjectName name : tomcatPoolNames) {
            log.info("Tomcat JDBC Pool MBean: " + name);
        }
    }

    /**
     * Monitorización continua del pool en un hilo background.
     * Útil para detectar exhaustión del pool antes de que afecte usuarios.
     */
    public static void startContinuousMonitoring(String poolName,
                                                  int intervalSeconds) {
        Thread monitor = new Thread(() -> {
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    printPoolStats(poolName);
                    Thread.sleep(intervalSeconds * 1000L);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                } catch (Exception e) {
                    log.warning("Error monitorizando pool: " + e.getMessage());
                }
            }
        }, "pool-monitor-thread");

        monitor.setDaemon(true);
        monitor.start();
    }
}
```

### 7.7.2 Endpoint de health check del pool

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
 * Usado por load balancers y sistemas de monitorización.
 * GET /health/db → 200 OK si la BD está accesible, 503 si no.
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
            getServletContext().log("HealthCheck: DataSource no disponible", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String path = request.getServletPath();

        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("X-Health-Check", "tomcat-pool");

        switch (path) {
            case "/health/live"  -> checkLiveness(response);
            case "/health/ready" -> checkReadiness(response);
            default              -> checkFull(response);
        }
    }

    // Liveness: ¿Está el proceso vivo?
    private void checkLiveness(HttpServletResponse response)
            throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().println("{\"status\":\"UP\",\"check\":\"liveness\"}");
    }

    // Readiness: ¿Puede la aplicación aceptar tráfico?
    private void checkReadiness(HttpServletResponse response)
            throws IOException {
        long start = System.currentTimeMillis();

        if (dataSource == null) {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            response.getWriter().println("""
                {"status":"DOWN","check":"readiness",
                 "error":"DataSource no inicializado"}""");
            return;
        }

        try (Connection conn = dataSource.getConnection();
             Statement stmt  = conn.createStatement();
             ResultSet rs    = stmt.executeQuery("SELECT 1")) {

            long elapsed = System.currentTimeMillis() - start;
            rs.next();

            response.setStatus(HttpServletResponse.SC_OK);
            try (PrintWriter out = response.getWriter()) {
                out.printf("""
                    {"status":"UP","check":"readiness",
                     "database":"connected","responseMs":%d}%n""",
                    elapsed);
            }

        } catch (Exception e) {
            long elapsed = System.currentTimeMillis() - start;
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            try (PrintWriter out = response.getWriter()) {
                out.printf("""
                    {"status":"DOWN","check":"readiness",
                     "database":"unreachable",
                     "responseMs":%d,"error":"%s"}%n""",
                    elapsed, e.getMessage().replace("\"", "'"));
            }
        }
    }

    // Full check: estado completo de la aplicación
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

        long heapUsed  = Runtime.getRuntime().totalMemory()
                       - Runtime.getRuntime().freeMemory();
        long heapMax   = Runtime.getRuntime().maxMemory();
        double heapPct = (double) heapUsed / heapMax * 100;

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

---

## 7.8 Anti-Patrones y Problemas Comunes del Pool

### 7.8.1 Connection Leak — Conexión no devuelta al pool

```java
// ❌ MAL: Si se lanza excepción antes de conn.close(), la conexión
// nunca se devuelve al pool → connection leak → pool exhaustion
public void badExample() throws SQLException {
    Connection conn = dataSource.getConnection();
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users");
    ResultSet rs = stmt.executeQuery();
    // Si aquí lanza excepción... conn nunca se cierra
    processResults(rs);
    stmt.close();
    conn.close(); // ← NUNCA LLEGA SI HAY EXCEPCIÓN
}

// ✅ BIEN: try-with-resources garantiza el cierre siempre
public void goodExample() throws SQLException {
    try (Connection conn = dataSource.getConnection();
         PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users");
         ResultSet rs = stmt.executeQuery()) {
        processResults(rs);
    } // ← conn.close() llamado SIEMPRE (éxito o excepción)
}
```

### 7.8.2 Pool Exhaustion bajo carga

```java
// ❌ MAL: Guardar la conexión en ThreadLocal o como campo de instancia
public class BadServlet extends HttpServlet {
    private Connection conn; // ← NUNCA guardar en campo de instancia

    public void init() throws ServletException {
        try {
            conn = dataSource.getConnection(); // ← Una conexión para siempre
        } catch (SQLException e) { throw new ServletException(e); }
    }
}

// ❌ MAL: Obtener conexión fuera del scope mínimo necesario
public void badScope() throws SQLException {
    Connection conn = dataSource.getConnection(); // ← Obtener aquí
    doSomeBusinessLogic();    // Operaciones sin BD (tiempo desperdiciado)
    doMoreBusinessLogic();    // Más tiempo con la conexión bloqueada
    PreparedStatement stmt = conn.prepareStatement("SELECT 1");
    // ...
    conn.close();
}

// ✅ BIEN: Obtener la conexión lo más tarde posible y cerrarla inmediatamente
public void goodScope() throws SQLException {
    doSomeBusinessLogic();    // Sin conexión
    doMoreBusinessLogic();    // Sin conexión

    // Solo tener la conexión durante el tiempo estrictamente necesario
    try (Connection conn = dataSource.getConnection();
         PreparedStatement stmt = conn.prepareStatement("SELECT 1")) {
        // Uso mínimo
    }
}
```

### 7.8.3 Tabla de síntomas y diagnóstico

| Síntoma                                    | Causa probable                          | Solución                                      |
|--------------------------------------------|-----------------------------------------|-----------------------------------------------|
| `Cannot get connection, pool timeout`      | Pool exhausto (maxTotal alcanzado)      | Aumentar `maxTotal`, buscar connection leaks  |
| Queries muy lentas intermitentemente       | Conexiones obsoletas/rotas en el pool   | Habilitar `testOnBorrow=true`                 |
| `Connection is closed` en producción       | Conexión idle expirada por la BD        | Configurar `testWhileIdle` y `validationQuery`|
| Pool se queda con conexiones abandonadas   | Código no cierra conexiones             | Habilitar `removeAbandonedOnBorrow=true`      |
| OutOfMemory relacionado con JDBC           | Statement leak (no se cierran Statements)| Usar `StatementFinalizer` interceptor        |
| BD rechaza nuevas conexiones               | `maxTotal` demasiado alto vs límites BD | Reducir `maxTotal`, revisar `max_connections` |
| Deadlock en inicio de la app               | `initialSize` > límite BD en ese momento| Reducir `initialSize` o usar lazy init       |

---

## 7.9 Configuración de JNDI para Otros Recursos

### 7.9.1 JavaMail Session

```xml
<!-- context.xml / server.xml GlobalNamingResources -->
<Resource
  name="mail/AppMailSession"
  auth="Container"
  type="javax.mail.Session"
  mail.smtp.host="smtp.miempresa.com"
  mail.smtp.port="587"
  mail.smtp.auth="true"
  mail.smtp.starttls.enable="true"
  mail.smtp.starttls.required="true"
  mail.smtp.ssl.protocols="TLSv1.2 TLSv1.3"
  mail.smtp.connectiontimeout="10000"
  mail.smtp.timeout="30000"
  mail.smtp.writetimeout="30000"
  mail.from="noreply@miempresa.com"
  mail.debug="false"/>
```

```java
// Uso de JavaMail via JNDI
Context ctx     = new InitialContext();
Session session = (Session) ctx.lookup("java:comp/env/mail/AppMailSession");

Message message = new MimeMessage(session);
message.setFrom(new InternetAddress("noreply@miempresa.com"));
message.setRecipients(Message.RecipientType.TO,
    InternetAddress.parse("usuario@ejemplo.com"));
message.setSubject("Notificación del sistema");
message.setText("Contenido del mensaje");

// Autenticación dinámica si no está en el Resource
Transport transport = session.getTransport("smtp");
transport.connect("${mail.username}", "${mail.password}");
transport.sendMessage(message, message.getAllRecipients());
transport.close();
```

### 7.9.2 Variable de entorno JNDI

```xml
<!-- Publicar constantes de configuración via JNDI -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <Environment
    name="maxConcurrentUsers"
    value="5000"
    type="java.lang.Integer"
    override="false"
    description="Máximo de usuarios concurrentes permitidos"/>

  <Environment
    name="featureFlags/newDashboard"
    value="true"
    type="java.lang.Boolean"
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
Context ctx = new InitialContext();
Integer maxUsers = (Integer) ctx.lookup(
    "java:comp/env/maxConcurrentUsers");
Boolean newDashboard = (Boolean) ctx.lookup(
    "java:comp/env/featureFlags/newDashboard");
String apiUrl = (String) ctx.lookup(
    "java:comp/env/config/apiBaseUrl");
```

---

## 7.10 Diferencias de JNDI y Pools entre Versiones de Tomcat

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

*`javax.sql.DataSource` es parte de Java SE y no cambia de namespace.
 Las clases de la aplicación que usan `javax.servlet.*` sí cambian a `jakarta.servlet.*`.

---

## Puntos Clave del Módulo 07

- El árbol JNDI de Tomcat tiene dos espacios: `java:comp/env/` para recursos locales de la aplicación y `java:/global/` para recursos globales del servidor.
- **Siempre usar `try-with-resources`** con `Connection`, `Statement` y `ResultSet`. Es la única garantía de que la conexión se devuelve al pool en cualquier circunstancia.
- El **Tomcat JDBC Pool** es superior a DBCP2 en entornos de alta carga gracias a los **Interceptors** (SlowQueryReport, StatementFinalizer, StatementCache).
- **HikariCP** proporciona el mejor rendimiento bruto pero requiere una factory JNDI personalizada o inicialización programática en un Listener.
- Configurar siempre `testOnBorrow=true` y `validationQuery` para detectar conexiones rotas antes de entregarlas a la aplicación.
- Habilitar `removeAbandonedOnBorrow=true` con `logAbandoned=true` para detectar y reparar connection leaks en desarrollo y producción.
- Usar **`ResourceLink`** para compartir un pool de conexiones entre múltiples aplicaciones del mismo servidor, evitando la multiplicación de pools y el agotamiento de conexiones en la BD.
- El **health check endpoint** es imprescindible en entornos con load balancer para que el balanceador retire del pool un nodo con la BD caída.
- Obtener la conexión del pool **lo más tarde posible** y cerrarla **lo más pronto posible** para maximizar la disponibilidad de conexiones en el pool.
- El `maxTotal` del pool **nunca debe superar** el límite de conexiones simultáneas de la base de datos dividido entre el número de instancias de Tomcat.