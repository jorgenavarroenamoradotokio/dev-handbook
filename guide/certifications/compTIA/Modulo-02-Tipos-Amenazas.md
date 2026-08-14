> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Actores de Amenazas](#1-actores-de-amenazas)
  - [Vulnerabilidad, Amenaza y Riesgo](#vulnerabilidad-amenaza-y-riesgo)
    - [Fórmula del Riesgo](#fórmula-del-riesgo)
  - [Atributos de los Actores de Amenazas](#atributos-de-los-actores-de-amenazas)
    - [Los 4 Atributos de Clasificación](#los-4-atributos-de-clasificación)
  - [Motivaciones de los Actores de Amenazas](#motivaciones-de-los-actores-de-amenazas)
    - [Clasificación por Estructuración del Ataque](#clasificación-por-estructuración-del-ataque)
    - [Las 3 Estrategias Generales de Ataque (Relación con Tríada CIA)](#las-3-estrategias-generales-de-ataque-relación-con-tríada-cia)
    - [Tipos de Motivaciones](#tipos-de-motivaciones)
  - [Hackers y Hacktivistas](#hackers-y-hacktivistas)
    - [Tipos de Hackers](#tipos-de-hackers)
  - [Actores de Estados Nación](#actores-de-estados-nación)
  - [Crimen Organizado y Competidores](#crimen-organizado-y-competidores)
    - [Crimen Organizado](#crimen-organizado)
    - [Espionaje Comercial (Competidores)](#espionaje-comercial-competidores)
  - [Actores de Amenazas Internos](#actores-de-amenazas-internos)
    - [Clasificación de Amenazas Internas](#clasificación-de-amenazas-internas)
    - [Por Intencionalidad](#por-intencionalidad)
    - [Conceptos Importantes](#conceptos-importantes)
- [2. Superficies de Ataque](#2-superficies-de-ataque)
  - [Superficie de Ataque y Vectores de Amenaza](#superficie-de-ataque-y-vectores-de-amenaza)
    - [Tipos de Superficies de Ataque](#tipos-de-superficies-de-ataque)
    - [Características de los Ataques Sofisticados](#características-de-los-ataques-sofisticados)
  - [Vectores de Software Vulnerable](#vectores-de-software-vulnerable)
    - [Sistemas y Aplicaciones No Compatibles (End-of-Life / EOL)](#sistemas-y-aplicaciones-no-compatibles-end-of-life--eol)
    - [Escaneo de Vulnerabilidades: Basado en Cliente vs. Sin Agente](#escaneo-de-vulnerabilidades-basado-en-cliente-vs-sin-agente)
  - [Vectores de Red](#vectores-de-red)
    - [Clasificación de Exploits: Remoto vs. Local](#clasificación-de-exploits-remoto-vs-local)
    - [Redes No Seguras: Impacto en la Tríada CIA](#redes-no-seguras-impacto-en-la-tríada-cia)
    - [Vectores de Red Específicos](#vectores-de-red-específicos)
    - [Principio de Reducción de la Superficie de Red](#principio-de-reducción-de-la-superficie-de-red)
  - [Vectores Basados en Señuelos](#vectores-basados-en-señuelos)
    - [Tipos de Señuelos](#tipos-de-señuelos)
    - [Reducción de la Superficie de Ataque por Señuelos](#reducción-de-la-superficie-de-ataque-por-señuelos)
  - [Vectores Basados en Mensajes](#vectores-basados-en-mensajes)
    - [Canales de Mensajería como Vectores de Amenaza](#canales-de-mensajería-como-vectores-de-amenaza)
    - [Conceptos Críticos](#conceptos-críticos)
  - [Superficie de Ataque de la Cadena de Suministro](#superficie-de-ataque-de-la-cadena-de-suministro)
    - [Gestión de Adquisiciones (Acquisition Management)](#gestión-de-adquisiciones-acquisition-management)
    - [La Amplitud de la Cadena de Suministro](#la-amplitud-de-la-cadena-de-suministro)
    - [MSP (Managed Service Provider — Proveedor de Servicios Administrados)](#msp-managed-service-provider--proveedor-de-servicios-administrados)
    - [Mejores Prácticas](#mejores-prácticas)
- [3. Ingeniería Social](#3-ingeniería-social)
  - [Vectores Humanos](#vectores-humanos)
    - [Usos de la Ingeniería Social](#usos-de-la-ingeniería-social)
    - [Escenarios de Ejemplo del PDF](#escenarios-de-ejemplo-del-pdf)
  - [Suplantación y Pretexting](#suplantación-y-pretexting)
    - [Suplantación (Impersonation)](#suplantación-impersonation)
    - [Pretexting](#pretexting)
  - [Phishing y Pharming](#phishing-y-pharming)
    - [Phishing (Suplantación de Identidad)](#phishing-suplantación-de-identidad)
    - [Variantes de Phishing por Canal](#variantes-de-phishing-por-canal)
    - [Pharming (Redireccionamiento)](#pharming-redireccionamiento)
  - [Typosquatting](#typosquatting)
    - [Definición y Técnicas](#definición-y-técnicas)
    - [Técnicas Relacionadas de Suplantación de Origen](#técnicas-relacionadas-de-suplantación-de-origen)
  - [Compromiso de Correo Electrónico Empresarial (BEC)](#compromiso-de-correo-electrónico-empresarial-bec)
    - [BEC (Business Email Compromise — Compromiso de Correo Electrónico Empresarial)](#bec-business-email-compromise--compromiso-de-correo-electrónico-empresarial)
    - [Terminología de Ataques Altamente Dirigidos](#terminología-de-ataques-altamente-dirigidos)
    - [Suplantación de Marca (Brand Impersonation)](#suplantación-de-marca-brand-impersonation)
    - [Desinformación vs. Malinformación](#desinformación-vs-malinformación)
    - [Watering Hole Attack (Ataque de Abrevadero)](#watering-hole-attack-ataque-de-abrevadero)
- [4. Tabla Resumen: Tipos de Actores de Amenaza](#4-tabla-resumen-tipos-de-actores-de-amenaza)
  - [Actores de Amenaza](#actores-de-amenaza)
  - [Vectores de Amenaza](#vectores-de-amenaza)
- [5. Glosario](#5-glosario)

---

# 1. Actores de Amenazas

## Vulnerabilidad, Amenaza y Riesgo

| Concepto | Definición | Ejemplos |
|---|---|---|
| **Vulnerabilidad** | Debilidad que puede activarse accidentalmente o explotarse intencionalmente | Hardware/software mal configurado, parches sin aplicar, arquitectura de red mal diseñada, contraseñas débiles, fallas de diseño en SO |
| **Amenaza** | Posibilidad de que alguien/algo explote una vulnerabilidad y viole la seguridad | Puede ser intencional o no intencional |
| **Actor de amenaza** | La persona o cosa que representa la amenaza | También llamado **agente de amenaza** |
| **Vector de amenaza** | La ruta o herramienta usada por el actor de amenaza | Correo electrónico, USB, red, etc. |
| **Riesgo** | Nivel de peligro representado por vulnerabilidades + amenazas | Se calcula como: **Probabilidad × Impacto** |

> **Analogía del mundo real:** Imagina tu casa: una **vulnerabilidad** es que la cerradura de la puerta trasera está rota. La **amenaza** es que un ladrón conoce el barrio y sabe que tu cerradura falla. El **riesgo** es la probabilidad de que ese ladrón entre y el daño que causaría.

### Fórmula del Riesgo

```
RIESGO = Probabilidad de explotación × Impacto del exploit exitoso
```

```
Vulnerabilidad + Amenaza = ALTO RIESGO (Impacto × Posibilidad)
```

> **👉 Enfoque de Examen SY0-701:**
> CompTIA distingue claramente estos tres términos. Una pregunta típica presentará un escenario y pedirá que identifiques si se describe una vulnerabilidad, una amenaza o un riesgo. **Distractor común:** confundir "actor de amenaza" con "vector de amenaza". Recuerda: el actor ES la persona/entidad; el vector ES el camino/método. También vigila preguntas que pregunten cuándo una vulnerabilidad SE CONVIERTE en riesgo (respuesta: cuando existe una amenaza que puede explotarla).


## Atributos de los Actores de Amenazas

Las técnicas antiguas se basaban en **firmas conocidas** (como reconocer al ladrón por su foto en el fichero). Las amenazas modernas son sofisticadas y evolucionan, por lo que se requiere crear **perfiles de comportamiento**.

> **Analogía del mundo real:** Así como la policía crea perfiles de delincuentes (¿actúa solo o en banda?, ¿tiene recursos?, ¿está dentro o fuera del sistema?), los equipos de seguridad crean perfiles de actores de amenaza.

### Los 4 Atributos de Clasificación

**1. Interno / Externo**

| Tipo | Descripción |
|---|---|
| **Externo** | No tiene cuenta ni acceso autorizado al sistema objetivo. Debe infiltrarse (intrusión física o piratería de red). Puede ser remoto o local en su método, pero SIEMPRE se clasifica como externo. |
| **Interno (Insider)** | Se le concedieron permisos en el sistema. Incluye empleados, contratistas y socios comerciales. |

**2. Nivel de Sofisticación / Capacidad**

```
BAJO ──────────────────────────────────────► ALTO
Herramientas básicas    Nuevos exploits    Herramientas no-cibernéticas
disponibles           en SO/apps          (activos políticos/militares)
```

**3. Recursos / Financiamiento**

- **Bajo:** Hacker solitario con herramientas gratuitas
- **Medio:** Grupos con financiamiento propio o criminal
- **Alto:** Patrocinados por **Estados nación** o **crimen organizado** → acceso a herramientas personalizadas, estrategas, diseñadores, codificadores, hackers e ingenieros sociales calificados

**4. Motivación**

*(Se desarrolla en detalle en la sección 2.1.3)*

> **👉 Enfoque de Examen SY0-701:**
> Pregunta frecuente: "¿Un contratista que filtra datos es una amenaza interna o externa?" → **INTERNA** (tiene acceso concedido). Otro distractor clásico: un actor externo que ataca físicamente en el sitio sigue siendo **externo** (el término se refiere al acceso, no al método). CompTIA también puede presentar escenarios sobre ex-empleados: clasificarlos como amenaza interna con conocimiento privilegiado o externa sin acceso vigente, según si se revocaron sus credenciales.

## Motivaciones de los Actores de Amenazas

> **Analogía del mundo real:** Un ladrón puede robar por necesidad económica, por desafío personal, para vengarse del dueño de la tienda, o por encargo político. La motivación cambia completamente el perfil de riesgo y el tipo de ataque.

### Clasificación por Estructuración del Ataque

| Tipo | Descripción | Ejemplo |
|---|---|---|
| **Estructurado / Dirigido** | Objetivo específico, planificación deliberada | Banda criminal robando datos financieros de una BD específica |
| **No estructurado / Oportunista** | Sin objetivo específico, aprovecha lo que encuentra | Hacker novato lanzando un gusano de correo masivo |
| **Accidental / No intencional** | Errores, descuidos, sin malicia | Empleado que borra datos por error |

### Las 3 Estrategias Generales de Ataque (Relación con Tríada CIA)

| Estrategia | Definición | Afecta a... |
|---|---|---|
| **Interrupción del servicio** | Impide que la organización opere con normalidad (sitio web caído, malware que bloquea servidores) | **Disponibilidad** |
| **Exfiltración de datos** | Transfiere una copia de información valiosa sin autorización | **Confidencialidad** |
| **Desinformación** | Falsifica recursos de confianza (sitios web alterados, bots en redes sociales, motores de búsqueda manipulados) | **Integridad** |

### Tipos de Motivaciones

**Motivaciones Caóticas**

- Objetivo: causar caos, obtener crédito/notoriedad, vandalismo digital
- Ejemplos: desfigurar sitios web, liberar gusanos sin objetivo económico
- También: **ataques de venganza** por parte de empleados/ex-empleados con agravios

**Motivaciones Financieras**

| Táctica | Definición |
|---|---|
| **Chantaje / Blackmail** | Exigir dinero para evitar divulgar información (real o fabricada) |
| **Extorsión** | Exigir pago para detener un ataque activo (ej. ransomware: paga o no recuperas tus datos) |
| **Fraude** | Falsificación de documentos/registros: malversación de fondos, lavado de dinero, noticias falsas para manipular precios de acciones |

**Motivaciones Políticas**

- **Denunciante (Whistleblower):** Motivación ética para divulgar información confidencial sobre malas prácticas
- **Hacktivismo:** Grupos que interrumpen servicios de organizaciones que consideran contrarias a sus valores
- **Estado nación:** Usa interrupción de servicio, exfiltración de datos o desinformación como arma de guerra (sin necesidad de estado bélico oficial)
- **Espionaje:** Exfiltración de datos para conocer secretos (no para venderlos, sino para obtener ventaja estratégica)
- **Espionaje comercial:** Una empresa roba secretos de un competidor

> **👉 Enfoque de Examen SY0-701:**
> Distingue **chantaje** (amenaza de revelar algo) vs **extorsión** (amenaza de continuar un ataque). El ransomware es **extorsión**, no chantaje. Otra combinación vigilar: el espionaje siempre es **exfiltración de datos + motivación política/estratégica**. CompTIA pregunta con frecuencia sobre la relación motivación → estrategia → tríada CIA. Memoriza: Desinformación = Integridad; Exfiltración = Confidencialidad; DoS = Disponibilidad.

## Hackers y Hacktivistas

> **Analogía del mundo real:** "Hacker" es como "cirujano": originalmente un término neutral de habilidad. Un cirujano puede operar para salvar vidas (sombrero blanco) o para dañar (sombrero negro). La habilidad es la misma; la autorización y la intención cambian todo.

### Tipos de Hackers

| Tipo | Terminología Antigua | Terminología Actual | Descripción |
|---|---|---|---|
| **Hacker ético / Autorizado** | White hat | **Autorizado** | Siempre busca autorización para hacer pentests. Opera dentro de límites legales. |
| **Hacker malicioso** | Black hat | **No autorizado** | Intrusiones ilegales o maliciosas |
| **Hacker oportunista** | Grey hat | — | Entre ambos extremos |

**Atacante sin formación (Script Kiddie)**

- Usa herramientas de hackers **sin comprender** cómo funcionan
- No puede crear nuevos ataques
- Motivación: llamar la atención, demostrar habilidades técnicas básicas
- **Sin objetivo específico ni propósito fundado**

**Equipos de hackers**

- El "hacker solitario" sigue siendo una amenaza, pero los ataques modernos son más frecuentemente **grupales**
- El esfuerzo colaborativo permite desarrollar herramientas sofisticadas y estrategias novedosas

**Hacktivistas**

- Grupos que usan herramientas cibernéticas para promover **una agenda política**
- Tácticas: exfiltración de datos para divulgación pública, ataques DoS, defacement de sitios web
- Objetivos frecuentes: organizaciones políticas, financieras, medios de comunicación
- También atacan empresas de diversos sectores (defensa del medio ambiente, derechos animales)

> **👉 Enfoque de Examen SY0-701:**
> CompTIA ya no usa los términos "white hat / black hat" en el examen SY0-701; usa **"autorizado / no autorizado"**. Un distractor común: presentar a un hacktivista como motivado financieramente (incorrecto, su motivación es política/ideológica). Los script kiddies tienen **baja sofisticación y bajos recursos** pero pueden causar daño real usando herramientas de terceros.

## Actores de Estados Nación

**APT (Advanced Persistent Threat — Amenaza Persistente Avanzada)**
- **Acuñado** para describir adversarios cibernéticos modernos patrocinados por Estados
- No se trata de un virus puntual: se refiere a la **capacidad de comprometer continuamente la seguridad de una red** (obtener Y mantener acceso)
- Utiliza una **variedad de herramientas y técnicas**, no una sola
- El informe **APT1 de Mandiant** (sobre unidades chinas de espionaje cibernético) fue fundamental para configurar el lenguaje moderno sobre APTs

**Características de los Actores de Estados Nación**

- Objetivos principales: **sistemas de energía, salud y electorales**
- Motivaciones: **desinformación y espionaje** para obtener ventajas estratégicas
- Algunos países (ej. **Corea del Norte**) también atacan para obtener **beneficios financieros**
- Operan con **"negación plausible"**: trabajan a distancia del gobierno que los patrocina
- Pueden hacerse pasar por grupos independientes o **hacktivistas**
- Pueden perpetrar **campañas de desinformación de bandera falsa** para implicar a otros estados

**Recursos de Investigación**

- **The MITRE Corporation** reporta sobre actividades de crimen organizado y actores de tipo Estado nación
- Framework **ATT&CK** de MITRE: catálogo de TTPs (Tácticas, Técnicas y Procedimientos) de adversarios reales

> **Analogía del mundo real:** Imagina que un gobierno entrena a sus mejores espías, les da acceso ilimitado a recursos y tecnología, y les dice que operen en secreto sin que nadie pueda probar su origen. Eso es un actor de Estado nación en el ciberespacio.

> **👉 Enfoque de Examen SY0-701:**
> APT es un concepto muy preguntado. Recuerda: APT no es un malware específico, es un **estilo de ataque persistente y continuo**. La "negación plausible" significa que los actores estatales operan de manera que el gobierno patrocinador pueda negar su involucración. Distractor: confundir APT con ransomware (el ransomware puede ser parte de un ataque APT, pero no lo define). MITRE ATT&CK puede aparecer en preguntas sobre inteligencia de amenazas (threat intelligence).

## Crimen Organizado y Competidores

### Crimen Organizado

- En muchos países, la **delincuencia cibernética superó a la física** en número de incidentes y pérdidas
- Ventaja del cibercrimen: opera desde una **jurisdicción diferente** a la de su víctima → aumenta la complejidad judicial
- Actividades típicas:
  - **Fraude financiero** (a particulares y empresas)
  - **Chantaje / Extorsión**
- Aprovechan cualquier oportunidad de beneficio económico

### Espionaje Comercial (Competidores)

- Aunque la mayoría del espionaje lo llevan a cabo actores estatales, una **empresa deshonesta** puede usar ciberespionaje contra competidores
- Objetivos: robo de propiedad intelectual, interrupción de la actividad del competidor, daño a su reputación
- **Vector facilitador:** empleados que cambian recientemente de empresa y aportan información privilegiada

> **👉 Enfoque de Examen SY0-701:**
> En escenarios sobre crimen organizado, las respuestas correctas casi siempre involucran motivación **financiera** (fraude, extorsión, chantaje). El espionaje comercial combina motivación **financiera + estratégica**. Diferencia clave: el crimen organizado es oportunista EN SU SELECCIÓN de víctimas, pero muy sofisticado en sus MÉTODOS.

## Actores de Amenazas Internos

> **Analogía del mundo real:** El guardia de seguridad de un banco ya tiene acceso a la bóveda. No necesita "robarle" el acceso a nadie. Un insider es igual: ya está dentro del castillo y conoce los pasillos.

### Clasificación de Amenazas Internas

| Tipo | Descripción |
|---|---|
| **Empleados (privilegios permanentes)** | Acceso continuo y legítimo al sistema |
| **Contratistas / Invitados (privilegios temporales)** | Acceso limitado en tiempo y alcance |
| **Ex-empleados** | Caso difuso: pueden tener **permisos residuales** si no se aplican controles de salida efectivos |

### Por Intencionalidad

| Tipo | Características |
|---|---|
| **Malicioso** | Motivaciones: **venganza** y **ganancia financiera**. Puede ser dirigido (planificado) u oportunista |
| **No intencional / Inadvertido** | Falta de conciencia o negligencia (ej. mala gestión de contraseñas) |

### Conceptos Importantes

**Denunciante (Whistleblower)**

- Persona con motivación **ética** para divulgar información confidencial
- Las revelaciones protegidas (ej. denunciar fraude financiero por canal autorizado) **NO pueden ser amenazadas ni punidas**

**TI en la sombra (Shadow IT)**

- Usuarios que adquieren o introducen hardware/software **sin autorización del departamento de TI**
- Agravado por: proliferación de servicios cloud y dispositivos móviles
- Consecuencia: **nueva superficie de ataque no monitoreada** que explotan adversarios maliciosos

**Colaboración Insider-Externo**

- Evalúa siempre si una amenaza interna puede estar **trabajando en colaboración con un actor externo**

> **👉 Enfoque de Examen SY0-701:**
> CompTIA distingue entre amenaza interna **maliciosa** vs **inadvertida**. La Shadow IT es un ejemplo clave de amenaza interna NO maliciosa. Pregunta trampa: "¿Un ex-empleado despedido con acceso residual es amenaza interna o externa?" → Depende del contexto, pero en el examen suele ser **interna con conocimiento interno** si mantiene acceso activo. Los denunciantes aparecen en preguntas de ética y política de seguridad, no como amenazas que deban bloquearse cuando actúan por canales protegidos.

# 2. Superficies de Ataque

> **Objetivo:** Comprender los métodos por los que los actores de amenazas se infiltran en redes y sistemas, para implementar controles que bloqueen los vectores de ataque.

## Superficie de Ataque y Vectores de Amenaza

**Superficie de Ataque (Attack Surface)**
- Todos los puntos donde un actor de amenaza malicioso **podría intentar explotar una vulnerabilidad**
- Incluye: puertos de red, aplicaciones, computadoras, usuarios
- **Minimizar la superficie de ataque** = restringir el acceso a solo los puntos de conexión, protocolos/puertos y servicios necesarios

**Vectores de Amenaza y Ataque**
- **Vector de amenaza / Vector de ataque:** La ruta que usa un actor de amenaza para ejecutar un ataque
- Se consideran sinónimos; algunas fuentes distinguen:
  - **Vector de amenaza:** análisis de la superficie de ataque *potencial*
  - **Vector de ataque:** análisis de un exploit que se ejecutó *con éxito*

> **Analogía del mundo real:** La superficie de ataque es como todos los puntos de entrada de una fortaleza: puertas, ventanas, túneles, murallas. Minimizar la superficie de ataque equivale a tapiar las ventanas que no se usan y reducir las puertas a solo las imprescindibles, con guardias en cada una.

### Tipos de Superficies de Ataque

| Alcance | Ejemplos |
|---|---|
| **Global (toda la organización)** | Red pública, servidores expuestos, empleados, cadena de suministro |
| **Específico (un sistema)** | Un servidor individual, una aplicación web, las cuentas de empleados |

### Características de los Ataques Sofisticados

- Los actores sofisticados utilizan **múltiples vectores simultáneos o secuenciales**
- Planifican **campañas en varias etapas** (no ataques únicos de "destrozar y agarrar")
- Los actores altamente capacitados pueden **desarrollar vectores novedosos** (desconocidos para el defensor)
- El conocimiento del actor sobre la superficie de ataque de tu organización puede ser **mejor que el tuyo propio**

```
Actor Externo: superficie de ataque MENOR (sin acceso legítimo)
Actor Interno: superficie de ataque MAYOR (acceso concedido)
```

> **👉 Enfoque de Examen SY0-701:**
> La superficie de ataque se puede evaluar a distintos niveles (organizacional, de sistema, de aplicación). CompTIA pregunta qué acción REDUCE la superficie de ataque: deshabilitar servicios innecesarios, cerrar puertos no usados, aplicar el principio de mínimo privilegio. Distinción clave: vector de amenaza vs vector de ataque (potencial vs ejecutado).

## Vectores de Software Vulnerable

**Software Vulnerable**

- Contiene una falla en su **código o diseño** que puede aprovecharse para:
  - Eludir el control de acceso
  - Bloquear el proceso (DoS)
- Las vulnerabilidades generalmente solo se explotan en **circunstancias bastante específicas**
- Los proveedores suelen corregirlas rápidamente con parches, pero la complejidad del software moderno garantiza que casi ningún software esté libre de ellas

**Impacto del Software Vulnerable**

| Ejemplo | Vector de Acceso | Impacto Potencial |
|---|---|---|
| Vulnerabilidad en Adobe PDF Reader | Estación de trabajo del usuario | Punto de apoyo en red corporativa |
| Vulnerabilidad en software de servidor TLS | Servidor web | Compromiso de claves criptográficas para servicios HTTPS |

**Reducción de la Superficie de Ataque por Software**
- **Consolidar** productos → menos software = menos vulnerabilidades
- Asegurar la **misma versión** de un producto en toda la organización

> **Analogía del mundo real:** Un software vulnerable es como un edificio con una ventana rota. No todos los ladrones saben que está rota (requiere reconocimiento), y no todos pueden alcanzarla (requiere condiciones específicas), pero quien sí lo sabe y puede llegar, tiene entrada libre.

### Sistemas y Aplicaciones No Compatibles (End-of-Life / EOL)

- Sistema **no compatible (EOL):** el proveedor ya NO desarrolla actualizaciones ni parches
- Son **extremadamente vulnerables** a exploits porque no recibirán corrección
- Estrategia de mitigación: **aislar** la aplicación no compatible de otros sistemas
  - Esto reduce las oportunidades de acceso del actor de amenaza
  - Es un ejemplo de **control compensatorio** (sustituto del parcheo)

### Escaneo de Vulnerabilidades: Basado en Cliente vs. Sin Agente

| Tipo | Descripción | Quién lo usa |
|---|---|---|
| **Basado en cliente (Agent-based)** | Agente instalado en cada host; reporta a servidor de gestión | Equipos de seguridad internos |
| **Sin agente (Agentless)** | Escanea el host sin instalación; técnicas de red | Actores de amenazas en reconocimiento Y equipos de seguridad |

> ⚠️ Los actores de amenazas también utilizan herramientas de escaneo para el **reconocimiento** del objetivo.

> **👉 Enfoque de Examen SY0-701:**
> EOL/EOS (End of Life / End of Support) es un tema muy frecuente. CompTIA pregunta cuál es la MEJOR respuesta cuando no puedes parchear un sistema EOL: la respuesta es **aislarlo** (control compensatorio), NO simplemente documentarlo ni ignorarlo. El escaneo sin agente aparece en preguntas sobre reconocimiento de actores de amenazas. Diferencia entre "sin parche" (patch disponible pero no aplicado) vs "sin soporte" (no existe parche).

## Vectores de Red

> **Analogía del mundo real:** Una red insegura es como una ciudad sin puertas ni muros. Cualquiera puede caminar por las calles (espionaje), poner un policía falso que redirija el tráfico (ataque en ruta) o cortar el suministro de agua (DoS).

### Clasificación de Exploits: Remoto vs. Local

| Tipo | Definición | Requisito |
|---|---|---|
| **Remoto** | Se explota enviando código a través de una red | **No** requiere sesión autenticada |
| **Local** | El código debe ejecutarse desde una sesión autenticada | Requiere credenciales válidas o secuestro de sesión |

### Redes No Seguras: Impacto en la Tríada CIA

| Falla | Tipo de Ataque | También Conocido Como |
|---|---|---|
| **Falta de Confidencialidad** | Espionaje del tráfico de red; recuperación de contraseñas e info confidencial | **Ataques de espionaje (Eavesdropping)** |
| **Falta de Integridad** | Conexión de dispositivos no autorizados; interceptación y modificación del tráfico; servicios falsificados | **Ataques en ruta (On-path attacks)** |
| **Falta de Disponibilidad** | Interrupción del servicio | **Ataques DoS (Denial of Service — Denegación de Servicio)** |

**Red Segura:** usa un marco de **control de acceso** + **soluciones criptográficas** para identificar, autenticar, autorizar y auditar usuarios, hosts y tráfico.

### Vectores de Red Específicos

| Vector | Descripción |
|---|---|
| **Acceso directo (físico)** | Actor accede físicamente al sitio: estación de trabajo desbloqueada, disco de arranque, robo de hardware |
| **Red cableada** | Actor conecta dispositivo no autorizado a puerto de red física → permite espionaje, ataques en ruta y DoS |
| **Red remota / inalámbrica** | Obtiene credenciales de acceso remoto/WiFi, rompe protocolos de autenticación, o falsifica punto de acceso para recolección de credenciales |
| **Acceso a la nube** | Busca cuenta/servicio/host con credenciales débiles; ataca cuentas de desarrollo/administración cloud; puede atacar al **CSP (Cloud Service Provider — Proveedor de Servicios en la Nube)** |
| **Red Bluetooth** | Explota vulnerabilidad o mala configuración para transmitir archivo malicioso vía Bluetooth (protocolo WPAN) |
| **Credenciales predeterminadas** | El dispositivo/aplicación usa la contraseña de fábrica; fácil de descubrir en documentación del producto |
| **Puerto de servicio abierto** | Conexión no autenticada a puerto `TCP` o `UDP`; el software que escucha puede ser vulnerable a exploit o DoS |

### Principio de Reducción de la Superficie de Red

```
❌ NO: Permitir tráfico en TODOS los puertos
✅ SÍ: Solo los puertos NECESARIOS para servicios autorizados
+ Diseño seguro + Cortafuegos + Detección de intrusiones + Control de acceso
```

> **👉 Enfoque de Examen SY0-701:**
> La distinción **remoto vs. local** es crítica para preguntas sobre gestión de vulnerabilidades (una vulnerabilidad remota es más severa que una local porque no requiere autenticación previa). On-path attack (antiguamente "man-in-the-middle") afecta a la **Integridad**. Los puertos abiertos innecesarios son el ejemplo clásico de superficie de ataque que debe reducirse. Distractor: "ataque de espionaje" → falla de **confidencialidad**, NO de integridad.

## Vectores Basados en Señuelos

Un **señuelo** es algo superficialmente atractivo que, cuando el objetivo lo abre o interactúa con él, ejecuta una **carga maliciosa** que da al actor de amenaza control sobre el sistema o realiza una interrupción del servicio.

Los señuelos se usan cuando el actor de amenaza **no puede ejecutar un exploit directamente** de forma remota o local.

> **Analogía del mundo real:** Un señuelo es como un anzuelo con cebo: parece comida deliciosa para el pez, pero tiene un gancho oculto. El archivo adjunto parece útil o divertido, pero al abrirlo, ejecutas código malicioso.

### Tipos de Señuelos

| Tipo | Descripción | Detalle |
|---|---|---|
| **Dispositivo extraíble (USB)** | Malware oculto en unidad USB o tarjeta de memoria | Solo conectar puede ejecutar el malware en algunos exploits |
| **Ataque de caída (Drop attack)** | Actor deja USB infectadas en oficinas, recepción o estacionamientos | Espera que al menos un empleado las conecte |
| **Archivo ejecutable** | Código de exploit oculto en programa (ej. **Trojan Horse — Troyano**) | Parece software gratuito, útil o divertido; crea backdoor para el actor |
| **Archivos de documento** | Código malicioso incrustado en Word, PDF | Aprovecha funciones de scripting o vulnerabilidades del visor |
| **Archivos de imagen** | Código de exploit dentro de imagen | Ataca vulnerabilidad en navegador o software de edición |

### Reducción de la Superficie de Ataque por Señuelos

Requiere **gestión efectiva de seguridad de endpoints**, incluyendo:
- Gestión de vulnerabilidades
- Antivirus / Antimalware
- Control de ejecución de programas (whitelisting)
- Detección de intrusiones en endpoints

> **👉 Enfoque de Examen SY0-701:**
> El "drop attack" (ataque de caída de USB) es un escenario clásico de ingeniería social física que aparece frecuentemente. El Troyano (Trojan Horse) es el ejemplo paradigmático de señuelo de archivo ejecutable: parece legítimo pero crea un backdoor. Distractor: confundir troyano con virus (un virus se replica; un troyano no se replica, simplemente se disfraza). La superfice de ataque de señuelos es amplia porque incluye TODOS los dispositivos USB y TODO el software de visualización de documentos.

## Vectores Basados en Mensajes

> **Analogía del mundo real:** Imagina que alguien te envía una carta que parece de tu banco, pidiendo que llames a un número de teléfono. La carta (mensaje) es el vector; el número falso es el señuelo. Los vectores de mensajes son los "carteros" que entregan los ataques.

### Canales de Mensajería como Vectores de Amenaza

| Canal | Descripción | Vulnerabilidades específicas |
|---|---|---|
| **Correo electrónico** | Archivo adjunto malicioso + ingeniería social para que el usuario lo abra | El vector más clásico |
| **SMS (Servicio de Mensajes Cortos)** | Archivo o enlace enviado a dispositivo móvil vía protocolo **SS7 (Sistema de Señalización 7)** | SS7 tiene numerosas vulnerabilidades; la organización raramente tiene capacidad de monitoreo sobre SMS |
| **IM (Mensajería Instantánea)** | Reemplazos de SMS (WhatsApp, Telegram, etc.) en Windows/Android/iOS; admite adjuntos, voz, video | Cifrado puede dificultar análisis de amenazas por la organización |
| **Web y redes sociales** | Malware en adjuntos de publicaciones; descargas ocultas (drive-by downloads); apps troyano "imprescindibles" | El atacante compromete un sitio para infectar automáticamente navegadores vulnerables |

### Conceptos Críticos

**Exploit de clic cero (Zero-click)**
- La mayoría de exploits requieren que el usuario **abra deliberadamente** el archivo
- **Clic cero:** simplemente **recibir** un archivo adjunto o **ver** una imagen en una página web activa el exploit automáticamente → máxima peligrosidad

**Vector de voz como ingeniería social**
- Un actor de amenaza puede usar vectores de mensajes para persuadir a un usuario a:
  - **Revelar una contraseña**
  - **Debilitar la configuración de seguridad**
- Puede perpetrarse simplemente con **una llamada de voz** (sin necesidad de malware)

> **👉 Enfoque de Examen SY0-701:**
> El protocolo SS7 aparece en preguntas sobre vulnerabilidades de SMS/móvil. Los exploits de "clic cero" son el escenario de mayor severidad: no requieren acción del usuario. Diferencia clave: el canal (SMS, email, IM) es el **vector**; el archivo adjunto malicioso es el **señuelo**. Pregunta trampa: "¿Qué hace que los ataques de IM sean difíciles de detectar?" → El **cifrado** de extremo a extremo impide que la organización analice el contenido.

## Superficie de Ataque de la Cadena de Suministro

Un **ataque de cadena de suministro** consiste en infiltrarse en el objetivo a través de empresas en su cadena de suministro, en lugar de atacar directamente al objetivo.

**Ejemplo célebre:** La filtración de datos de **Target** se realizó a través de credenciales del **proveedor de sistemas de construcción** de la empresa.

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│    FABRICANTE   ├──────►│   DISTRIBUIDOR  ├──────►│ EMPRESA CLIENTE │
│ (Código/Chips)  │       │(Logística/Venta)│       │ (Objetivo Real) │
└────────┬────────┘       └─────────────────┘       └────────▲────────┘
         │                                                   │
         └───────── Infiltración y código troyanizado ───────┘
```

> **Analogía del mundo real:** Para envenenar a toda una ciudad, no necesitas ir casa por casa. Envenas el suministro de agua en la fuente. La cadena de suministro es ese suministro de agua: comprometer a UN proveedor puede dar acceso a MILES de organizaciones objetivo.

### Gestión de Adquisiciones (Acquisition Management)

El proceso de garantizar fuentes confiables de equipos y software.

| Tipo de Relación | Descripción |
|---|---|
| **Proveedor mayorista** | Obtiene productos del fabricante para venderlos a empresas (**B2B — Business to Business**) |
| **Proveedor minorista** | Obtiene de mayoristas; vende a empresas (B2B) o clientes finales (**B2C — Business to Consumer**); puede agregar personalización y soporte |
| **Socio comercial** | Relación estrecha con objetivos y marketing alineados; ej. **OEM (Original Equipment Manufacturer — Fabricante de Equipos Originales)** |

### La Amplitud de la Cadena de Suministro

Para que una placa madre sea confiable, TODOS estos eslabones deben ser confiables:

```
Fabricante del chip
      ↓
Desarrollador del firmware
      ↓
Revendedor OEM
      ↓
Empresa de reparto
      ↓
Personal administrativo que entrega el equipo al usuario final
```

Cualquier persona con tiempo y recursos para **modificar el firmware** podría crear un **backdoor**. Aplica a hardware, software y servicios de red.

### MSP (Managed Service Provider — Proveedor de Servicios Administrados)

- Proporciona y admite recursos de TI (redes, seguridad, infraestructura web) de forma subcontratada
- **Ventaja:** Más barato o más confiable que gestionar TI internamente
- **Riesgo de seguridad:**
  - Difícil de monitorear
  - Los empleados del MSP son **fuentes potenciales de amenazas internas**

### Mejores Prácticas

- Para la mayoría de empresas: usar **proveedores de renombre** es el mejor esfuerzo práctico
- Gobierno, servicios militares y grandes empresas: mayor escrutinio sobre la cadena
- **Especial cuidado con máquinas de segunda mano** (pueden contener firmware modificado)
- Establecer cadena confiable = **negar a actores maliciosos tiempo y recursos para modificar activos suministrados**

> **👉 Enfoque de Examen SY0-701:**
> El ataque a Target a través del proveedor HVAC es el caso de estudio paradigmático de Supply Chain Attack. CompTIA puede presentar escenarios donde la amenaza no viene del objetivo directo sino de un tercero de confianza. MSP como amenaza interna es una combinación frecuente. Términos a recordar: B2B, B2C, OEM, MSP. La gestión de adquisiciones es la defensa principal contra ataques de cadena de suministro.

# 3. Ingeniería Social

La **ingeniería social** se refiere a los medios para:
- Obtener **información** de alguien
- Lograr que alguien **realice alguna acción** para el actor de amenaza

También conocida como: **"hackear al ser humano"**

```
┌────────────────────────────────────────────────────────┐
│        PRINCIPIOS PSICOLÓGICOS DE INGENIERÍA SOCIAL    │
└───────────────────────────┬────────────────────────────┘
                            │
      ┌───────────┬─────────┼───────────┬───────────┐
      ▼           ▼         ▼           ▼           ▼
┌───────────┐┌─────────┐┌───────┐┌─────────────┐┌───────┐
│ AUTORIDAD ││URGENCIA ││ESCASEZ││CONSENSOS/PR.││FAMIL. │
│           ││         ││       ││   SOCIAL    ││ /LIK. │
└───────────┘└─────────┘└───────┘└─────────────┘└───────┘
```

1. **Autoridad:** El atacante se presenta como una figura de poder (CEO, auditor, soporte técnico). Las personas tienden a seguir instrucciones de autoridades sin cuestionarlas.
2. **Urgencia:** Se induce estrés exigiendo una acción inmediata bajo amenaza de consecuencias graves. El estrés reduce el pensamiento analítico y fuerza decisiones apresuradas.
3. **Escasez:** Se ofrece un beneficio supuestamente exclusivo a punto de agotarse, forzando al usuario a saltarse los procesos de verificación por miedo a perder la oportunidad.
4. **Consenso / Prueba Social:** El atacante simula que otros compañeros ya han realizado la acción solicitada, validando el comportamiento como normal.
5. **Familiaridad / Simpatía:** Las personas cooperan más con quienes les caen bien. Los atacantes establecen relaciones previas para ganarse la confianza antes del ataque.
6. **Confianza:** El atacante construye credibilidad demostrando conocer información interna obtenida mediante reconocimiento OSINT.
7. **Intimidación:** Uso de amenazas o asertividad extrema para forzar a la víctima a saltarse los protocolos de seguridad.

> Las personas (empleados, contratistas, proveedores, clientes) son el **vector humano**: la superficie de ataque más difícil de parchear.

## Vectores Humanos

> **Analogía del mundo real:** Un castillo puede tener las mejores murallas y fosos del mundo, pero si alguien convence al guardia de abrir la puerta de atrás, todas esas defensas no sirven de nada. La ingeniería social no ataca los sistemas, ataca a las personas que los operan.

### Usos de la Ingeniería Social

| Fase | Objetivo | Ejemplo |
|---|---|---|
| **Reconocimiento** | Recopilar inteligencia previa a la intrusión | Obtener nombres de empleados, teléfonos, estructura organizacional |
| **Intrusión** | Efectuar el ataque directamente | Obtener credenciales, persuadir al usuario para ejecutar malware |

### Escenarios de Ejemplo del PDF

**Escenario 1 — Engaño por correo:**
Actor envía archivo ejecutable que solicita contraseña → pretexto: "hay problemas de inicio de sesión esta mañana" → usuario ingresa credenciales → actor las captura.

**Escenario 2 — Suplantación telefónica:**
Actor llama al soporte técnico haciéndose pasar por representante de ventas remoto → obtiene dirección del servidor de acceso remoto, credenciales, números de teléfono del sistema privado de voz.

**Escenario 3 — Ingeniería social física:**
Actor activa alarma de incendio → aprovecha la confusión de la evacuación → entra al edificio y conecta dispositivo de monitoreo a un puerto de red.

> **👉 Enfoque de Examen SY0-701:**
> La ingeniería social explota debilidades **humanas**, no técnicas. CompTIA presenta escenarios y pide identificar el tipo de ataque. Los vectores humanos NO son solo digitales: incluyen ataques físicos como el del escenario 3. La ingeniería social puede preceder a un ataque técnico (reconocimiento) o SER el ataque en sí mismo (obtención de credenciales sin ningún exploit técnico).

## Suplantación y Pretexting

### Suplantación (Impersonation)

- **Definición:** Pretender ser otra persona
- Es posible cuando el objetivo **no puede verificar la identidad** del atacante (por teléfono, email)

**Dos enfoques del atacante:**

| Enfoque | Descripción |
|---|---|
| **Persuasivo / Consenso / Agrado** | Convence al objetivo de que rechazar sería descortés o "extraño" |
| **Coercitivo / Amenaza / Urgencia** | Intimida con apelación falsa a la autoridad o penalización (ej. "serás despedido si no actúas ahora") |

**Ejemplo clásico:** El ingeniero social llama a un departamento, afirma que necesita ajustar algo de forma remota, y logra que el usuario revele su contraseña.

### Pretexting

- **Definición:** Uso de una **historia cuidadosamente elaborada** con detalles convincentes o intimidantes para hacer la suplantación más creíble
- Para ser convincente, el atacante necesita **información privilegiada** sobre la organización (nombres, puestos, teléfonos, facturas, órdenes de compra)
- Esta información parece **inocua** pero permite penetrar mediante suplantación
- La mayoría de empresas están más orientadas al **servicio al cliente** que a la seguridad → esta información suele ser fácil de conseguir

```
Reconocimiento → Recopilación de info → Construcción del pretexto → Suplantación convincente
```

> **👉 Enfoque de Examen SY0-701:**
> Suplantación e impersonation son lo mismo. **Pretexting** es la historia que hace creíble la suplantación. La urgencia y la autoridad son los dos disparadores psicológicos más usados en ingeniería social (aparecen en muchas preguntas). Distractor: confundir pretexting con phishing. El pretexting es la HISTORIA elaborada; el phishing es el VECTOR (normalmente email) que usa esa historia.

## Phishing y Pharming

> **Analogía del mundo real:** 
> **Phishing:** Como pescar con caña: lanzas el anzuelo (email falso) a muchos peces y esperas que alguno pique.
> **Pharming:** Como envenenar el río para que todos los peces naden hacia donde tú quieres: manipulas el "mapa de Internet" para redirigir a las víctimas sin que lo noten.

### Phishing (Suplantación de Identidad)

- **Combinación:** Ingeniería social + suplantación de identidad
- **Vector tradicional:** Correo electrónico
- **Objetivo:** Persuadir o engañar al usuario para que interactúe con un recurso malicioso disfrazado de confiable

**Dos modalidades principales:**
1. Convencer al usuario de **instalar malware** o permitir **acceso remoto**
2. Redirigir a un **sitio web falsificado** que imita banco o e-commerce → capturar credenciales cuando el usuario se autentica

### Variantes de Phishing por Canal

| Variante | Canal | Descripción |
|---|---|---|
| **Phishing** | Email / SMS | Base estándar |
| **Vishing** | Voz (teléfono / VoIP) | Actor llama fingiendo ser el banco; solicita verificación de transacción; más difícil de rechazar que un email |
| **Smishing** | SMS (Short Message Service) | Phishing por mensajes de texto |
| **Angler Phishing** | Redes sociales | Vector de ingeniería social en plataformas sociales |

> ⚠️ La tecnología **deep fake** (voz e imagen sintética) hará más frecuentes los intentos de vishing con mensajes de voz e incluso video en el futuro.

### Pharming (Redireccionamiento)

- **Definición:** Redirige a los usuarios de un sitio web **legítimo** a uno **malicioso**
- **Diferencia clave con phishing:** No usa ingeniería social; en cambio, **daña la resolución de nombres de Internet** de la víctima
- Resultado: el usuario escribe la URL correcta pero es redirigido al sitio malicioso

```
NORMAL:    mybank.foo → IP 2.2.2.2 (legítimo)
PHARMING:  mybank.foo → IP 6.6.6.6 (malicioso) ← DNS envenenado
```

> **👉 Enfoque de Examen SY0-701:**
> El examen distingue claramente phishing (engaño activo al usuario) vs pharming (manipulación del sistema de resolución DNS/nombres). El pharming no requiere que el usuario "muerda el anzuelo" de un correo; es transparente para él. Memoriza las variantes: Vishing (Voz), Smishing (SMS), Angler (redes sociales), Spear (dirigido). Las mejoras en deep fake como vector de vishing son un tema emergente en SY0-701.

## Typosquatting

> **Analogía del mundo real:** Imagina que alguien abre una tienda llamada "McDonáld's" (con tilde) justo al lado de un McDonald's real, apostando a que algunos clientes distraídos entren al lugar equivocado.

### Definición y Técnicas

**Typosquatting (Allanamiento de Error Tipográfico)**
- El actor de amenaza registra un **nombre de dominio muy similar** a uno real
- Espera que los usuarios no noten la diferencia y asuman que están en un sitio de confianza
- También conocidos como: **dominios primos**, **parecidos** o **doppelganger**

**Ejemplo:** `ejenplo.com` en lugar de `ejemplo.com`

### Técnicas Relacionadas de Suplantación de Origen

| Técnica | Descripción |
|---|---|
| **Campo "De" falso en email** | El software de email puede mostrar un nombre diferente al remitente real. Menos efectivo hoy porque los filtros alertan sobre discrepancias. |
| **Typosquatting de dominio** | Registro de dominio con error ortográfico mínimo |
| **Subdominio secuestrado en nube** | Registro de subdominio usando dominio de proveedor cloud confiable, ej. `ejemplo.en`**`microsoft.com`** → muchos usuarios confiarán en él por ver "microsoft.com" |

> **👉 Enfoque de Examen SY0-701:**
> El typosquatting es una técnica de suplantación de **origen del mensaje**, no del mensaje en sí. CompTIA puede presentar un URL falsificado y preguntar qué técnica se está usando. El subdominio en un proveedor de nube confiable es el distractor más sofisticado: el dominio base (microsoft.com) es legítimo, pero el subdominio (ejemplo.en.microsoft.com) no lo es.

## Compromiso de Correo Electrónico Empresarial (BEC)

> **Analogía del mundo real:** El phishing masivo es como pescar con red de arrastre: capturas lo que puedas. El BEC es como un francotirador: investiga, planifica, y apunta a UN objetivo específico de alto valor con munición personalizada.

### BEC (Business Email Compromise — Compromiso de Correo Electrónico Empresarial)

- **Definición:** Campaña sofisticada dirigida a **una persona específica** dentro de una empresa (generalmente ejecutivo o alto directivo)
- El actor de amenaza se hace pasar por un **colega, socio comercial o proveedor**
- Realiza **reconocimiento extenso** para conocer el objetivo: enfoque psicológico óptimo y pretextos convincentes
- **No usa** características obvias de phishing masivo (links falsificados obvios, adjuntos de malware)
- Puede intentar primero **comprometer una cuenta de correo legítima** para enviar los mensajes de phishing desde ella

**Motivación típica:** Persuadir a un titular del presupuesto para que **autorice un pago fraudulento o transferencia bancaria**

### Terminología de Ataques Altamente Dirigidos

| Término | Descripción |
|---|---|
| **Spear Phishing** | Phishing dirigido a **personas específicas** (no masivo) |
| **Whaling** | Phishing dirigido a **oficiales corporativos de alto nivel** (C-suite) |
| **CEO Fraud** | Suplantación del CEO para engañar a empleados |
| **Angler Phishing** | Uso de **redes sociales** como vector de phishing |
| **BEC** | Término amplio para campañas de email sofisticadas y dirigidas, frecuentemente con motivación financiera |

### Suplantación de Marca (Brand Impersonation)

- El actor de amenaza duplica con precisión: **logotipos, fuentes, colores, estilos de encabezado** de una empresa
- Imita el **estilo o tono** de las comunicaciones por email o el contenido del sitio web
- Puede intentar que el sitio de phishing **aparezca en los primeros resultados de búsqueda** con contenido realista

### Desinformación vs. Malinformación

| Término | Definición |
|---|---|
| **Desinformación (Disinformation)** | Motivación **intencional** de engañar; crear y difundir información falsa deliberadamente |
| **Malinformación (Misinformation)** | **Repetir** afirmaciones o rumores falsos **sin intención de engañar** |

**Estrategia:** Una campaña de desinformación puede intentar que otros repitan y amplíen los hechos falsos como malinformación (efecto multiplicador).

**Táctica SEO:** Publicaciones y referencias falsas en redes sociales para aumentar el ranking de búsqueda del sitio falso.

### Watering Hole Attack (Ataque de Abrevadero)

- **Definición:** El atacante NO va directamente al objetivo; compromete un **sitio de terceros** que el grupo objetivo visita habitualmente
- Proceso:
  1. Actor identifica (por reconocimiento) qué sitio no seguro usan los empleados del objetivo
  2. Compromete ese sitio para ejecutar **código de exploit** en sus visitantes
  3. Infecta las computadoras de los empleados del objetivo
  4. Penetra en los sistemas de la empresa objetivo

**Ejemplo:** Los empleados de una empresa de e-commerce usan una pizzería local online → El actor compromete el sitio de la pizzería → Infecta las computadoras de esos empleados.

> **👉 Enfoque de Examen SY0-701:**
> BEC vs Phishing masivo: la diferencia es el **nivel de personalización y reconocimiento previo**. El BEC es dirigido; el phishing es masivo. Memoriza la jerarquía: Phishing (masivo) → Spear Phishing (dirigido a persona) → Whaling (dirigido a ejecutivo). El Watering Hole es especialmente peligroso porque el objetivo visita un sitio que CONSIDERA seguro. Desinformación = intencional; malinformación = no intencional (el propagador no sabe que es falso). CompTIA distingue estos conceptos en preguntas de escenario.

# 4. Tabla Resumen: Tipos de Actores de Amenaza

## Actores de Amenaza

| Actor | Sofisticación | Recursos | Motivación Principal | Acceso |
|---|---|---|---|---|
| **Script Kiddie** | Baja | Bajos | Notoriedad, curiosidad | Externo |
| **Hacker autorizado** | Alta | Variables | Ético/profesional | Concedido |
| **Hacktivista** | Media | Medios | Política/ideología | Externo |
| **Crimen organizado** | Alta | Altos | Financiera (fraude, extorsión) | Externo |
| **Estado nación / APT** | Muy alta | Muy altos | Espionaje, ventaja estratégica, desinformación | Externo |
| **Insider malicioso** | Variable | Variables | Venganza, financiera | Interno |
| **Insider inadvertido** | N/A | N/A | Accidental (Shadow IT, negligencia) | Interno |
| **Competidor** | Media-Alta | Medios-Altos | Espionaje comercial | Externo |

## Vectores de Amenaza

| Vector | Tipo | Ejemplo | Contra-medida |
|---|---|---|---|
| Software EOL vulnerable | Técnico | Windows XP sin parches | Aislamiento (control compensatorio) |
| Puerto de red abierto | Red | Puerto `TCP/23` Telnet abierto | Cerrar puertos no necesarios, firewall |
| USB / señuelo físico | Señuelo | Drop attack de USB infectado | Control de ejecución, deshabilitar USB autorun |
| Correo electrónico con adjunto | Mensajes | Adjunto malicioso con factura falsa | Filtrado de email, antivirus, concienciación |
| Phishing / pharming | Humano+Red | Sitio bancario falso | Filtros DNS, MFA, formación de usuarios |
| Cadena de suministro | Organizacional | Ataque tipo SolarWinds | Gestión de adquisiciones, auditoría de proveedores |
| Ingeniería social / BEC | Humano | CEO fraud por email | Formación, verificación por canal alternativo |

# 5. Glosario

| Acrónimo / Término | Significado |
|---|---|
| **TTP** | Tactics, Techniques and Procedures — Tácticas, Técnicas y Procedimientos |
| **APT** | Advanced Persistent Threat — Amenaza Persistente Avanzada |
| **DoS** | Denial of Service — Denegación de Servicio |
| **CIA** (tríada) | Confidentiality, Integrity, Availability — Confidencialidad, Integridad, Disponibilidad |
| **EOL / EOS** | End of Life / End of Support — Fin de Vida / Fin de Soporte |
| **MSP** | Managed Service Provider — Proveedor de Servicios Administrados |
| **OEM** | Original Equipment Manufacturer — Fabricante de Equipos Originales |
| **B2B** | Business to Business — De Empresa a Empresa |
| **B2C** | Business to Consumer — De Empresa a Consumidor |
| **BEC** | Business Email Compromise — Compromiso de Correo Electrónico Empresarial |
| **SMS** | Short Message Service — Servicio de Mensajes Cortos |
| **SS7** | Signaling System 7 — Sistema de Señalización 7 |
| **SIM** | Subscriber Identity Module — Módulo de Identidad del Suscriptor |
| **IM** | Instant Messaging — Mensajería Instantánea |
| **VoIP** | Voice over IP — Voz sobre Protocolo de Internet |
| **CSP** | Cloud Service Provider — Proveedor de Servicios en la Nube |
| **Shadow IT** | TI en la sombra — Hardware/software no autorizado por el departamento de TI |
| **Typosquatting** | Allanamiento de error tipográfico — registro de dominios similares a los reales |
| **Pretexting** | Historia elaborada para hacer creíble una suplantación |
| **Pharming** | Redireccionamiento — manipulación de la resolución de nombres DNS |
| **Vishing** | Voice Phishing — Phishing por voz |
| **Smishing** | SMS Phishing — Phishing por SMS |
| **WPAN** | Wireless Personal Area Network — Red inalámbrica de área personal (Bluetooth) |
| **MITRE ATT&CK** | Framework de tácticas y técnicas de adversarios reales |