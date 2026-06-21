> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Conceptos de Arquitectura e Infraestructura](#1-conceptos-de-arquitectura-e-infraestructura)
    - [Ejemplo práctico: Flujo de trabajo del correo electrónico](#ejemplo-práctico-flujo-de-trabajo-del-correo-electrónico)
  - [Infraestructura de Red](#infraestructura-de-red)
    - [Tipos de nodos](#tipos-de-nodos)
    - [Alcances de red](#alcances-de-red)
    - [Protocolo de Resolución de Direcciones](#protocolo-de-resolución-de-direcciones)
    - [FQDN (Fully Qualified Domain Name — Nombre de Dominio Completamente Calificado)](#fqdn-fully-qualified-domain-name--nombre-de-dominio-completamente-calificado)
  - [Consideraciones de Infraestructura de Conmutación](#consideraciones-de-infraestructura-de-conmutación)
    - [Cableado Estructurado (topología en estrella)](#cableado-estructurado-topología-en-estrella)
    - [Problemas de la topología plana (estrella básica)](#problemas-de-la-topología-plana-estrella-básica)
    - [Solución: Diseño jerárquico](#solución-diseño-jerárquico)
  - [Consideraciones sobre la Infraestructura de Enrutamiento](#consideraciones-sobre-la-infraestructura-de-enrutamiento)
    - [Protocolo de Internet (IP)](#protocolo-de-internet-ip)
    - [VLAN (Virtual LAN — Red de Área Local Virtual)](#vlan-virtual-lan--red-de-área-local-virtual)
    - [Ejemplo VoIP vs. Estaciones de trabajo](#ejemplo-voip-vs-estaciones-de-trabajo)
  - [Zonas de Seguridad](#zonas-de-seguridad)
    - [Análisis de requisitos por tipo de sistema](#análisis-de-requisitos-por-tipo-de-sistema)
    - [Ejemplo de zonas en diagrama](#ejemplo-de-zonas-en-diagrama)
    - [Reglas clave de control de tráfico entre zonas](#reglas-clave-de-control-de-tráfico-entre-zonas)
  - [Superficie de Ataque](#superficie-de-ataque)
    - [Análisis por capa OSI](#análisis-por-capa-osi)
    - [Debilidades típicas de arquitectura](#debilidades-típicas-de-arquitectura)
    - [Defensa en profundidad (Defense in Depth)](#defensa-en-profundidad-defense-in-depth)
  - [Seguridad del Puerto](#seguridad-del-puerto)
    - [Medidas básicas](#medidas-básicas)
    - [Filtrado MAC y Limitación MAC](#filtrado-mac-y-limitación-mac)
    - [802.1X y EAP (Extensible Authentication Protocol — Protocolo de Autenticación Extensible)](#8021x-y-eap-extensible-authentication-protocol--protocolo-de-autenticación-extensible)
    - [Protocolos de 802.1X](#protocolos-de-8021x)
    - [Flujo de autenticación 802.1X](#flujo-de-autenticación-8021x)
  - [Aislamiento Físico (Air Gap)](#aislamiento-físico-air-gap)
    - [Casos de uso típicos](#casos-de-uso-típicos)
    - [Desafíos del air gap](#desafíos-del-air-gap)
  - [Consideraciones Arquitectónicas](#consideraciones-arquitectónicas)
    - [Limitaciones de las redes locales (on-premises)](#limitaciones-de-las-redes-locales-on-premises)
- [2. Dispositivos de Seguridad de la Red](#2-dispositivos-de-seguridad-de-la-red)
  - [Ubicación del Dispositivo](#ubicación-del-dispositivo)
    - [Tres opciones de ubicación y tipo de control](#tres-opciones-de-ubicación-y-tipo-de-control)
    - [Ejemplo de colocación en la red (de afuera hacia adentro)](#ejemplo-de-colocación-en-la-red-de-afuera-hacia-adentro)
  - [Atributos del Dispositivo](#atributos-del-dispositivo)
    - [Activo vs. Pasivo](#activo-vs-pasivo)
    - [Dispositivos Inline y Métodos de Monitoreo](#dispositivos-inline-y-métodos-de-monitoreo)
    - [Apertura ante Fallas vs. Cierre ante Fallas](#apertura-ante-fallas-vs-cierre-ante-fallas)
  - [Cortafuegos (Firewalls)](#cortafuegos-firewalls)
    - [Filtrado de Paquetes con ACL](#filtrado-de-paquetes-con-acl)
    - [Acciones del cortafuegos](#acciones-del-cortafuegos)
    - [Tipos de Cortafuegos según Modo de Despliegue](#tipos-de-cortafuegos-según-modo-de-despliegue)
    - [Cortafuego de Router vs. Dispositivo de Cortafuego](#cortafuego-de-router-vs-dispositivo-de-cortafuego)
  - [Cortafuegos de Capa 4 y 7](#cortafuegos-de-capa-4-y-7)
    - [Cortafuego Sin Estado (Stateless)](#cortafuego-sin-estado-stateless)
    - [Cortafuego de Inspección de Estado (Stateful) — Capa 4](#cortafuego-de-inspección-de-estado-stateful--capa-4)
    - [Cortafuego de Capa 7 (Application Layer Firewall)](#cortafuego-de-capa-7-application-layer-firewall)
    - [Nombres equivalentes del cortafuego de capa 7](#nombres-equivalentes-del-cortafuego-de-capa-7)
  - [Servidores Proxy](#servidores-proxy)
    - [Proxies Directos (Forward Proxies)](#proxies-directos-forward-proxies)
    - [Proxies Inversos (Reverse Proxies)](#proxies-inversos-reverse-proxies)
  - [Sistemas de Detección de Intrusiones](#sistemas-de-detección-de-intrusiones)
    - [Sensores](#sensores)
    - [IDS (Intrusion Detection System — Sistema de Detección de Intrusiones)](#ids-intrusion-detection-system--sistema-de-detección-de-intrusiones)
    - [IPS (Intrusion Prevention System — Sistema de Prevención de Intrusiones)](#ips-intrusion-prevention-system--sistema-de-prevención-de-intrusiones)
  - [Cortafuegos de Próxima Generación (NGFW) y Administración de Amenazas Unificadas (UTM)](#cortafuegos-de-próxima-generación-ngfw-y-administración-de-amenazas-unificadas-utm)
    - [NGFW (Next-Generation Firewall — Cortafuego de Próxima Generación)](#ngfw-next-generation-firewall--cortafuego-de-próxima-generación)
    - [UTM (Unified Threat Management — Administración de Amenazas Unificadas)](#utm-unified-threat-management--administración-de-amenazas-unificadas)
    - [Comparación NGFW vs. UTM](#comparación-ngfw-vs-utm)
  - [Balanceadores de Carga](#balanceadores-de-carga)
    - [Tipos de Balanceador de Carga](#tipos-de-balanceador-de-carga)
    - [Algoritmos de Programación (Scheduling)](#algoritmos-de-programación-scheduling)
    - [Health Checks (Verificación de Estado)](#health-checks-verificación-de-estado)
    - [Afinidad por IP de Origen y Persistencia de Sesión](#afinidad-por-ip-de-origen-y-persistencia-de-sesión)
  - [Cortafuegos de Aplicaciones Web (WAF)](#cortafuegos-de-aplicaciones-web-waf)
    - [Funcionamiento del WAF](#funcionamiento-del-waf)
    - [Implementación del WAF](#implementación-del-waf)
- [3. Comunicaciones Seguras](#3-comunicaciones-seguras)
  - [Arquitectura de Acceso Remoto](#arquitectura-de-acceso-remoto)
    - [Topologías de VPN (Virtual Private Network — Red Privada Virtual)](#topologías-de-vpn-virtual-private-network--red-privada-virtual)
    - [Protocolos VPN](#protocolos-vpn)
    - [VPN Sitio a Sitio: Comportamiento](#vpn-sitio-a-sitio-comportamiento)
  - [Túnel de Seguridad de la Capa de Transporte (TLS)](#túnel-de-seguridad-de-la-capa-de-transporte-tls)
    - [Cómo funciona una VPN TLS](#cómo-funciona-una-vpn-tls)
    - [Protocolo de transporte para VPN TLS](#protocolo-de-transporte-para-vpn-tls)
    - [Versiones de TLS](#versiones-de-tls)
  - [Túnel de Seguridad del Protocolo de Internet (IPsec)](#túnel-de-seguridad-del-protocolo-de-internet-ipsec)
    - [Los Dos Protocolos Principales de IPsec](#los-dos-protocolos-principales-de-ipsec)
    - [Los Dos Modos de IPsec](#los-dos-modos-de-ipsec)
    - [Resumen de combinaciones](#resumen-de-combinaciones)
  - [Intercambio de Claves de Internet (IKE)](#intercambio-de-claves-de-internet-ike)
    - [Fases de la negociación IKE](#fases-de-la-negociación-ike)
    - [Versiones de IKE](#versiones-de-ike)
  - [Escritorio Remoto](#escritorio-remoto)
    - [RDP (Remote Desktop Protocol — Protocolo de Escritorio Remoto)](#rdp-remote-desktop-protocol--protocolo-de-escritorio-remoto)
    - [Alternativas y soluciones complementarias](#alternativas-y-soluciones-complementarias)
    - [VPN HTML5 / Puerta de enlace sin cliente](#vpn-html5--puerta-de-enlace-sin-cliente)
  - [Shell Seguro (SSH)](#shell-seguro-ssh)
    - [Identificación de Servidores SSH](#identificación-de-servidores-ssh)
    - [Métodos de Autenticación del Cliente SSH](#métodos-de-autenticación-del-cliente-ssh)
    - [Comandos SSH Clave](#comandos-ssh-clave)
    - [Gestión de Claves Públicas — Consideraciones de Seguridad](#gestión-de-claves-públicas--consideraciones-de-seguridad)
  - [Gestión Fuera de Banda y Servidores de Salto](#gestión-fuera-de-banda-y-servidores-de-salto)
    - [SAW (Secure Administrative Workstation — Estación de Trabajo Administrativa Segura)](#saw-secure-administrative-workstation--estación-de-trabajo-administrativa-segura)
    - [Gestión en Banda vs. Fuera de Banda](#gestión-en-banda-vs-fuera-de-banda)
    - [Jump Server / Bastion Host (Servidor de Salto / Bastión)](#jump-server--bastion-host-servidor-de-salto--bastión)
- [4. Puertos Clave](#4-puertos-clave)
  - [Dispositivos por Capa OSI](#dispositivos-por-capa-osi)
  - [Resumen de Controles de Seguridad](#resumen-de-controles-de-seguridad)
- [5. Glosario](#5-glosario)

---

# 1. Conceptos de Arquitectura e Infraestructura

La **arquitectura de red** es la selección y colocación de:

- **Infraestructura de red:** Medios físicos, dispositivos y protocolos de direccionamiento/reenvío que soportan la conectividad básica.
- **Aplicaciones de red:** Servicios sobre la infraestructura (correo electrónico, facturación, web).
- **Activos de datos:** Información creada, almacenada y transferida por la actividad comercial.

> **Analogía:** Piensa en una ciudad. Las calles y semáforos son la *infraestructura*; los negocios que operan en esas calles son las *aplicaciones*; y los bienes que transportan los camiones son los *activos de datos*.

### Ejemplo práctico: Flujo de trabajo del correo electrónico

| Componente | Función | Requisito de seguridad |
|---|---|---|
| **Dispositivo cliente** | Accede a la red y al buzón | Autenticación/autorización |
| **Servidor de buzón** | Almacena activos de datos | Confidencialidad + disponibilidad |
| **Servidor de transferencia de correo (MTA)** | Se conecta a Internet (no confiable) | Control estricto del perímetro |

> ⚠️ Colocar cliente, buzón y MTA en el **mismo segmento** introduce múltiples vulnerabilidades. La separación es clave.

## Infraestructura de Red

El modelo **OSI (Open Systems Interconnection — Interconexión de Sistema Abierto)** de 7 capas es el marco de referencia fundamental:

| Capa OSI | Número | Dispositivos/Protocolos clave | Ejemplo |
|---|---|---|---|
| **Física (PHY)** | 1 | Cables UTP, fibra óptica, ondas radio | Par trenzado |
| **Enlace de datos** | 2 | Switch, Access Point (AP), `MAC` | `00-15-5D-01-CA-4A` |
| **Red** | 3 | Router, `IP`, `ARP`, `ND` | `10.1.0.192/24` |
| **Transporte** | 4 | `TCP`, `UDP` | Puertos, handshake |
| **Aplicación** | 7 | Servidores, `HTTP`, `SMTP`, `DNS`, `FTP`, `SMB` | `www.ejemplo.com` |

### Tipos de nodos

- **Nodo host:** Inicia transferencias de datos (clientes, servidores).
- **Nodo intermediario:** Reenvía tráfico (switches, routers).

### Alcances de red

- **LAN (Local Area Network — Red de Área Local):** Un solo sitio.
- **WAN (Wide Area Network — Red de Área Amplia):** Metropolitano, nacional o global.

### Protocolo de Resolución de Direcciones

- **ARP (Address Resolution Protocol — Protocolo de Resolución de Direcciones):** Mapea una IP a una dirección MAC en IPv4.
- **ND (Neighbor Discovery — Protocolo de Descubrimiento Cercano):** Equivalente de ARP para IPv6.

### FQDN (Fully Qualified Domain Name — Nombre de Dominio Completamente Calificado)

El **DNS (Domain Name System — Sistema de Nombres de Dominio)** resuelve FQDNs (ej. `www.empresa.com`) a direcciones IP. Opera en capa 7 pero es un servicio de infraestructura.

> **👉 Enfoque de Examen SY0-701:** CompTIA suele preguntar qué capa OSI opera cada dispositivo. Memoriza: Switch = Capa 2 (MAC), Router = Capa 3 (IP), TCP/UDP = Capa 4, Apps = Capa 7. Un distractor común es confundir ARP con DNS — ARP resuelve IP→MAC (capa 2/3), DNS resuelve nombre→IP (capa 7). También vigila preguntas sobre IPv6: usa ND en lugar de ARP.

## Consideraciones de Infraestructura de Conmutación

### Cableado Estructurado (topología en estrella)

Componentes del sistema:
1. **Cable de conexión (patch cable):** De la NIC del PC al puerto de pared.
2. **Cable estructurado:** Del puerto de pared al patch panel (por conductos).
3. **Cable de patch panel:** Del patch panel al puerto del switch.

> **Analogía:** El cableado estructurado es como el sistema eléctrico de un edificio: cada enchufe (puerto de pared) se conecta al cuadro eléctrico central (patch panel → switch).

### Problemas de la topología plana (estrella básica)

- **Dominio de difusión (broadcast domain)** único: todos los hosts reciben todos los broadcasts.
- Con cientos de hosts: **penalizaciones de rendimiento**.
- Sin segmentación: **cualquier host puede comunicarse con cualquier otro** (red "plana").

### Solución: Diseño jerárquico

```
[Internet]
    |
[Router Perimetral / Firewall]
    |
[Router/Switch Capa 3 — NÚCLEO]
    |        |         |
[Switch   [Switch   [Switch
 Acceso]   Acceso]   Acceso]
    |          |         |
[Impresoras] [WS+VoIP] [Servidores]
```

- **Switch de acceso:** Conecta hosts en un bloque (topología en estrella).
- **Switch de Capa 3:** Combina enrutamiento y conmutación en el núcleo.
- Los **routers** entre bloques crean **dominios de difusión separados** y permiten controlar el flujo entre zonas.

> **👉 Enfoque de Examen SY0-701:** El concepto de red "plana" vs. diseño jerárquico es frecuente. Una red plana significa que si un atacante penetra el perímetro, tiene libertad de movimiento total. El diseño jerárquico crea zonas con políticas de acceso diferenciadas. Vigilar distractores que confunden switch de acceso con switch de núcleo (capa 3).

## Consideraciones sobre la Infraestructura de Enrutamiento

### Protocolo de Internet (IP)

- **IPv4:** Dirección de 32 bits en notación decimal con puntos + prefijo de red.
  - Ejemplo: `10.1.1.0/24` → Red `10.1.1.x`, máscara `255.255.255.0`.
- **IPv6:** Dirección de 128 bits en notación hexadecimal.
  - Ejemplo: `2001:db8::abc:0:def0:1234`
  - Últimos 64 bits = ID de interfaz del host.
  - Primeros 64 bits = información de red jerarquizada.

### VLAN (Virtual LAN — Red de Área Local Virtual)

- Valor de ID de VLAN: entre **2 y 4094**.
- Cada VLAN es un **dominio de difusión independiente de capa 2**.
- El tráfico entre VLANs **debe pasar por un dispositivo de capa 3** (router o switch L3).
- Se pueden asignar diferentes puertos del **mismo switch físico** a diferentes VLANs.
- La topología de VLAN puede extenderse a través de **múltiples switches**.

> **Analogía:** Las VLANs son como plantas de un edificio de oficinas compartidas. Aunque todos están en el mismo edificio físico (mismo switch), los equipos de marketing y finanzas tienen acceso solo a sus propias áreas. Para pasar de una planta a otra, debes usar el ascensor (el router).

### Ejemplo VoIP vs. Estaciones de trabajo

| VLAN | Subred | Hosts |
|---|---|---|
| VLAN 32 | `10.1.32.0/24` | Estaciones de trabajo |
| VLAN 40 | `10.1.40.0/24` | Teléfonos VoIP |

Un teléfono VoIP en `10.1.40.100` que quiere contactar a `10.1.32.100` **debe pasar por el router**, aunque estén en el mismo switch físico.

> **👉 Enfoque de Examen SY0-701:** Las VLANs son un tema frecuente en escenarios de segmentación. CompTIA pregunta por qué las VLANs mejoran la seguridad (dominios de difusión separados) y cómo el tráfico inter-VLAN requiere un dispositivo L3. Distractor común: confundir VLAN con VPN. También vigila: el "hopping de VLAN" (VLAN hopping) es un ataque que explota configuraciones incorrectas de VLANs.

## Zonas de Seguridad

Una **topología de seguridad basada en zonas** clasifica segmentos según sus requisitos de seguridad.

> **Analogía:** Las zonas de seguridad son como las áreas de un aeropuerto: zona pública (check-in), zona de seguridad media (salas de espera), zona restringida (pistas), y zona ultra-restringida (torre de control). Para pasar de una a otra, hay controles obligatorios.

### Análisis de requisitos por tipo de sistema

| Tipo de sistema | Prioridad CIA | Notas |
|---|---|---|
| Bases de datos / archivos | Confidencialidad + Integridad | Separar tipos de datos reduce impacto de brechas |
| Dispositivos cliente | Integridad + Disponibilidad | No deben almacenar datos confidenciales |
| Servidores públicos (web, email, acceso remoto) | Integridad + Disponibilidad | No almacenar credenciales; no son de plena confianza |
| Servidores de infraestructura (auth, directorio, monitoring) | CIA completo | Compromiso = impacto catastrófico |

### Ejemplo de zonas en diagrama

| Zona | Privilegio | Contenido |
|---|---|---|
| Zona 1 | Bajo | Impresoras |
| Zona 2 | Medio | Estaciones de trabajo, teléfonos VoIP |
| Zona 3 | No confiable | Red de invitados, servidores públicos |
| Zona 4 | — | Internet |
| Zona 5 | Alto | Servidores privados, bases de datos |

### Reglas clave de control de tráfico entre zonas

- El tráfico entre zonas **debe controlarse mediante un cortafuegos**.
- Las políticas deben aplicar el **principio del mínimo privilegio**.
- Cada zona debe tener un **punto de entrada/salida conocido**.
  - Ejemplo de violación: colocar un AP inalámbrico dentro de una zona cuyo único acceso autorizado es un router.
- Los servidores de aplicaciones pueden solicitar a bases de datos; **nunca al revés**.
- Los hosts de la zona de invitados pueden acceder a Internet, **no a la LAN corporativa**.
- Los servidores públicos aceptan solicitudes de Internet, pero **no pueden iniciar solicitudes a la LAN corporativa**.

> **👉 Enfoque de Examen SY0-701:** CompTIA suele dar escenarios donde hay que identificar qué zona tiene una configuración incorrecta. Clave: los servidores expuestos públicamente NO deben estar en la misma zona que los servidores internos. También verifica: una zona sin punto de acceso único es una debilidad arquitectónica. El principio de mínimo privilegio se aplica a los flujos de tráfico entre zonas.

## Superficie de Ataque

La **superficie de ataque** es el conjunto de todos los puntos por los que un actor de amenazas podría obtener acceso.

### Análisis por capa OSI

| Capa | Vector de ataque potencial |
|---|---|
| **L1/L2** | Host no autorizado conectado a puerto de pared o red inalámbrica → comunicación en el mismo dominio de broadcast |
| **L3** | Host no autorizado obtiene dirección IP válida (posiblemente por suplantación/spoofing) → comunica con otras zonas |
| **L4/L7** | Host no autorizado establece conexiones a puertos `TCP`/`UDP` y se comunica con protocolos/servicios de aplicación |

### Debilidades típicas de arquitectura

| Debilidad | Descripción | Riesgo |
|---|---|---|
| **Puntos únicos de falla (SPOF)** | Un solo servidor/dispositivo/canal crítico | Alta disponibilidad comprometida |
| **Dependencias complejas** | Muchos sistemas necesarios para un servicio | La falla de uno afecta todo |
| **Disponibilidad sobre CIA** | "Atajos" para poner servicios en marcha rápido | Riesgos de seguridad a largo plazo |
| **Falta de documentación** | Segmentos/aparatos añadidos sin control de cambios | Falta de visibilidad de la red |
| **Dependencia excesiva del perímetro** | Red interna "plana" | Si el borde cae, el atacante tiene libertad total |

### Defensa en profundidad (Defense in Depth)

Múltiples capas de controles **preventivos, detectivos y correctivos** en cada capa del modelo OSI. No dependas de un solo control.

> **👉 Enfoque de Examen SY0-701:** "Defensa en profundidad" es un término que CompTIA usa frecuentemente. Los distractores intentan confundirlo con "redundancia" (que es sobre disponibilidad). La superficie de ataque se *reduce*, no se elimina. Vigilar preguntas sobre la red "plana" — la respuesta correcta siempre apunta a la segmentación y a la limitación del movimiento lateral.

## Seguridad del Puerto

Cada puerto de pared y puerto de switch es un vector de ataque físico potencial.

### Medidas básicas

- Restringir el **acceso físico** a switches (salas de servidores con llave).
- **Desactivar administrativamente** puertos de pared no utilizados.
- Retirar el cable de conexión del puerto de switch.

### Filtrado MAC y Limitación MAC

- Configurar que un puerto de switch solo permita **ciertas direcciones MAC**.
- Puede especificarse un **límite de número de MACs** permitidas.
  - Ejemplo: máx. 2 MACs → el switch registra las 2 primeras y descarta el resto.
- **Limitación:** Las MACs pueden ser **suplantadas (spoofed)**, por lo que este método no es completamente seguro.

### 802.1X y EAP (Extensible Authentication Protocol — Protocolo de Autenticación Extensible)

> **Analogía:** 802.1X es como un torniquete en el metro: hasta que no pases tu tarjeta (autenticación), el torniquete no se abre. El validador (autenticador) no lee la tarjeta directamente; la envía al sistema central (servidor RADIUS) para verificarla.

El estándar **IEEE 802.1X PNAC (Port-based Network Access Control — Control de Acceso a Red Basado en Puertos)** implementa la arquitectura **AAA (Authentication, Authorization, Accounting — Autenticación, Autorización y Contabilidad):**

| Rol | Descripción | Ejemplo |
|---|---|---|
| **Supplicant (Suplicante)** | Dispositivo que solicita acceso | PC o laptop del usuario |
| **Authenticator (Autenticador)** | Dispositivo de conmutación; NO valida directamente | Switch de red |
| **Authentication Server (Servidor de autenticación)** | Valida credenciales y emite autorización | Servidor RADIUS |

### Protocolos de 802.1X

- **EAP (Extensible Authentication Protocol — Protocolo de Autenticación Extensible):** Framework para diferentes métodos de autenticación. Puede usar certificados digitales, tarjetas inteligentes, etc.
- **RADIUS (Remote Authentication Dial-In User Service — Servicio de Autenticación Remota de Usuario por Acceso Telefónico):** Protocolo de comunicación entre autenticador (cliente RADIUS) y servidor de autenticación (servidor RADIUS).
- **EAPoL (EAP over LAN):** El switch abre solo este protocolo hasta que el host se autentica.

### Flujo de autenticación 802.1X

```
[Supplicant] ---(EAPoL)---> [Switch/Autenticador] ---(RADIUS)---> [Servidor RADIUS]
                                                   <---(Acceso aceptado/denegado)---
         <---(Acceso completo o denegado)---
```

1. Servidor RADIUS y cliente preconfigurados con el mismo **secreto compartido**.
2. Supplicant se conecta → switch habilita solo EAPoL.
3. Supplicant transmite datos EAP (cifrados).
4. Switch descifra con secreto compartido y reenvía al servidor RADIUS.
5. RADIUS valida la credencial.
6. RADIUS emite "acceso aceptado".
7. Switch habilita el canal de red para tráfico regular.

> **👉 Enfoque de Examen SY0-701:** 802.1X es un tema muy frecuente. Los tres roles (Supplicant/Authenticator/Authentication Server) suelen aparecer en preguntas de escenario. Distractor común: confundir el autenticador (switch) con el servidor de autenticación (RADIUS). El switch es el "bouncer" del club, no quien tiene la lista de invitados — eso es RADIUS. También: EAP es el *método*, RADIUS es el *protocolo de transporte* entre switch y servidor.

## Aislamiento Físico (Air Gap)

> **Analogía:** Un sistema con air gap es como una caja fuerte dentro de una cámara acorazada sin conexión a ningún sistema externo. La única forma de introducir o extraer información es físicamente.

Un host **air-gapped (aislado por segmento de aire)** no está conectado físicamente a ninguna red.

### Casos de uso típicos

- **Autoridad de certificación raíz (Root CA)** en PKI (Public Key Infrastructure — Infraestructura de Clave Pública).
- Hosts para **análisis de ejecución de malware**.
- **Bases militares, sitios gubernamentales e instalaciones industriales.**

### Desafíos del air gap

- Gestión del dispositivo: **solo en terminal local**.
- Actualizaciones: **USB o medios ópticos** (que son vectores de ataque potenciales y deben analizarse antes de su uso).

> **👉 Enfoque de Examen SY0-701:** El air gap es la solución más extrema de segmentación. CompTIA puede preguntar por qué el USB es un vector de riesgo en sistemas air-gapped. La respuesta correcta: el malware puede propagarse via medios físicos (ej. el famoso caso de Stuxnet). Distractor: pensar que el air gap es invulnerable — no lo es si los medios físicos no se analizan.

## Consideraciones Arquitectónicas

Al seleccionar una arquitectura, evalúa múltiples factores de forma equilibrada:

| Factor | Descripción | Consideración clave |
|---|---|---|
| **Costos** | Desembolso de capital inicial + mantenimiento continuo | Calcular según reducción de pérdidas por incidentes |
| **Cómputo y capacidad de respuesta** | CPU, RAM, almacenamiento, ancho de banda | Mayores recursos = mayores costos |
| **Escalabilidad y facilidad de implementación** | Agregar/quitar recursos rápidamente | Un sistema escalable evita costos excesivos por crecimiento |
| **Disponibilidad** | Minimizar tiempo de inactividad (downtime) | Downtime = pérdida de ingresos + daño reputacional |
| **Resiliencia y facilidad de recuperación** | Reducir tiempo de recuperación ante fallos | Recuperación automática > manual |
| **Potencia** | Demandas energéticas de la instalación | Infraestructura eléctrica minimiza fallos de disponibilidad |
| **Disponibilidad de actualizaciones de seguridad** | Firmware y software protegidos contra vulnerabilidades conocidas | Si un tercero gestiona la infra, el control es limitado |
| **Transferencia de riesgos** | Contrato con tercero; SLA con penalizaciones | SLA (Service Level Agreement — Acuerdo de Nivel de Servicio) |

### Limitaciones de las redes locales (on-premises)

- **Altos costos de capital** y **baja escalabilidad**.
- Aumentar ancho de banda (ej. 1 Gbps → 10 Gbps) puede requerir instalar cableado nuevo en todo el edificio.
- **Disponibilidad y resiliencia más bajas** que soluciones en la nube si el sitio se ve afectado por un desastre.

> **👉 Enfoque de Examen SY0-701:** CompTIA puede preguntar sobre trade-offs entre arquitecturas on-premises vs. nube. La nube generalmente ofrece mayor escalabilidad y resiliencia, mientras que on-premises ofrece mayor control. El SLA es la herramienta de transferencia de riesgos cuando se usa un tercero.

# 2. Dispositivos de Seguridad de la Red

## Ubicación del Dispositivo

La **defensa en profundidad** se garantiza con una selección cuidadosa de la **ubicación del dispositivo** en la topología.

### Tres opciones de ubicación y tipo de control

| Tipo de control | Ubicación típica | Función | Ejemplo |
|---|---|---|---|
| **Preventivo** | Borde del segmento/zona | Hacer cumplir políticas; garantizar CIA | Cortafuegos |
| **Detectivo** | Dentro del perímetro | Monitorear tráfico entre hosts; detectar lo que evadió el perímetro | IDS (sensor pasivo) |
| **Correctivo** | Dentro del tráfico | Corregir errores o irregularidades detectadas | Balanceador de carga (para DoS) |

### Ejemplo de colocación en la red (de afuera hacia adentro)

1. **Cortafuegos en el borde** (control preventivo) → hace cumplir reglas de entrada/salida.
2. **Sensor IDS detrás del cortafuegos** (control detectivo) → identifica tráfico malicioso que evadió el firewall.
3. **ACLs en routers internos** (control preventivo) → controla tráfico entre zonas internas.
4. **Balanceador de carga** frente a servidores públicos (control correctivo) → mitiga DoS.
5. **Sensores en puertos espejados** (control detectivo) → detección de intrusiones en zonas sensibles.
6. **Software de protección de endpoints** en cada host → múltiples controles (antivirus, firewall de host, IDS, DLP).

> **👉 Enfoque de Examen SY0-701:** En preguntas de escenario, CompTIA pide identificar el tipo de control y su ubicación óptima. Preventivo = bloquea antes; Detectivo = alerta después; Correctivo = remedia. El balanceador de carga puede aparecer como "correctivo" por su función contra DoS — esto es un distractor frecuente ya que normalmente se asocia con disponibilidad.

## Atributos del Dispositivo

### Activo vs. Pasivo

| Atributo | Descripción | Características |
|---|---|---|
| **Pasivo** | No requiere configuración de cliente/agente ni transferencia de datos | El tráfico se dirige o copia al sensor; los hosts no saben que está funcionando; sin interfaz direccionable |
| **Activo** | Requiere configuración con credenciales y permisos; intercambia datos con hosts destino | Para filtrado: los hosts deben estar configurados para usarlo como puerta de enlace |

### Dispositivos Inline y Métodos de Monitoreo

Un dispositivo **inline** se convierte en parte del cableado. Sus interfaces **no tienen direcciones MAC ni IP**. Puede copiar tráfico a un monitor.

| Método | Tipo | Descripción | Ventajas | Limitaciones |
|---|---|---|---|---|
| **TAP (Test Access Point — Punto de Acceso de Prueba)** | Hardware inline (L1) | Inductor/divisor óptico que copia físicamente la señal al puerto de monitoreo | Recibe TODAS las tramas (corruptas, malformadas); no afectado por carga | Requiere hardware adicional |
| **SPAN (Switched Port Analyzer — Analizador de Puerto Conmutado) / Port Mirror** | Software del switch | El switch copia tramas de puertos nominados a un puerto especial | Más fácil de implementar | No es completamente fiable; no refleja tramas con errores; puede perder tramas bajo alta carga |

### Apertura ante Fallas vs. Cierre ante Fallas

| Modo | Descripción | Prioridad | Riesgo |
|---|---|---|---|
| **Fail-open (Apertura ante fallas)** | El acceso se conserva si hay fallo | **Disponibilidad** sobre CIA | Un atacante podría forzar el estado de falla para evadir el control |
| **Fail-closed (Cierre ante fallas)** | El acceso se bloquea; el sistema entra en el estado más seguro disponible | **CIA** sobre Disponibilidad | Tiempo de inactividad del sistema |

> Causas de fallos en dispositivos: fallo de energía/hardware (sobrecargas, sobrecalentamiento, daños físicos), errores de software (bugs, vulnerabilidades), problemas de configuración (error humano), desastres naturales.

> **👉 Enfoque de Examen SY0-701:** TAP vs. SPAN es un tema clásico. TAP = hardware, más confiable, captura todo incluyendo tramas corruptas. SPAN = software, puede perder tramas bajo carga. Para entornos de alta seguridad, TAP es preferido. Fail-open vs. fail-closed: recuerda que fail-open prioriza disponibilidad y fail-closed prioriza seguridad. CompTIA puede preguntar cuál elegir según el contexto.

## Cortafuegos (Firewalls)

Un **cortafuego** es un control preventivo que hace cumplir políticas sobre el tráfico que entra y sale de una zona de red.

### Filtrado de Paquetes con ACL

Un cortafuego de filtrado de paquetes usa una **ACL (Access Control List — Lista de Control de Acceso)** con reglas basadas en:

- **Filtrado de IP:** Dirección IP de origen o destino (también puede filtrar por MAC).
- **Tipo/ID de protocolo:** TCP, UDP, ICMP, etc.
- **Filtrado de puerto:** Puertos `TCP`/`UDP` de origen y destino.

### Acciones del cortafuegos

| Acción | Resultado |
|---|---|
| **Accept / Allow (Aceptar/Permitir)** | El paquete pasa |
| **Drop / Deny (Caída/Denegación)** | Descarta silenciosamente el paquete |
| **Reject (Rechazo)** | Bloquea el paquete + responde al remitente con ICMP "puerto inalcanzable" |

> Las ACLs separadas filtran tráfico **entrante** y **saliente**. El control del tráfico saliente bloquea aplicaciones no autorizadas y malware como backdoors.

### Tipos de Cortafuegos según Modo de Despliegue

| Modo | Capa OSI | Descripción | Interfaces |
|---|---|---|---|
| **Enrutado (Routed)** | L3 | Realiza reenvío entre subredes; cada interfaz = zona diferente | Dirección IP y MAC en cada interfaz |
| **Puente (Bridge)** | L2 | Inspecciona tráfico entre dos nodos; funciona como switch | Solo dirección MAC (no IP) |
| **Inline** | L1 | Actúa como segmento de cable ("bump-in-the-wire" o "cable virtual") | Sin MAC ni IP |

> Los modos inline y puente se denominan **"modos transparentes"** — no requieren reconfigurar subredes ni reasignar IPs. Ejemplo: colocar un cortafuego transparente frente a un servidor web sin cambiar su IP.

> **Nota:** Un cortafuego transparente necesita una **interfaz adicional de gestión** con dirección IP.

### Cortafuego de Router vs. Dispositivo de Cortafuego

- **Cortafuego de dispositivo:** Hardware autónomo; cortafuego es la función principal.
- **Cortafuego de enrutador:** El enrutamiento es la función principal; el cortafuego es secundario (ej. routers SOHO domésticos).

> **👉 Enfoque de Examen SY0-701:** Los modos de despliegue del cortafuego (enrutado/puente/inline) son frecuentes en preguntas de escenario. Recuerda: modo transparente = inline o puente = sin IPs en las interfaces de datos. Las ACLs son la herramienta de configuración del filtrado. Vigilar preguntas sobre la diferencia entre "drop" (silencioso) y "reject" (responde con ICMP).

## Cortafuegos de Capa 4 y 7

### Cortafuego Sin Estado (Stateless)

- **No conserva información sobre las sesiones** de red.
- Cada paquete se analiza de forma **independiente**.
- Requiere menos esfuerzo de procesamiento.
- Vulnerable a ataques que se extienden en una **secuencia de paquetes**.
- Puede causar problemas con balance de cargas y puertos asignados dinámicamente.

### Cortafuego de Inspección de Estado (Stateful) — Capa 4

> **Analogía:** Un cortafuego sin estado es un guardia de seguridad que revisa cada persona individualmente sin recordar quién entró antes. Un cortafuego con estado es un guardia que tiene una lista de todas las personas que ya pasaron y solo deja entrar respuestas de conversaciones ya iniciadas.

- Rastrea la información de la **sesión establecida** entre dos hosts.
- Los datos de la sesión se almacenan en una **tabla de estado**.
- Examina el **handshake de tres vías TCP**: `SYN` → `SYN/ACK` → `ACK`.
- Detecta anomalías: `SYN` sin `ACK`, anomalías en números de secuencia → indica inundaciones maliciosas o intentos de secuestro de sesión.
- Puede rastrear tráfico `UDP` (más difícil por ser sin conexión).
- También detecta anomalías en encabezados IP e ICMP.

### Cortafuego de Capa 7 (Application Layer Firewall)

- Inspecciona **encabezados Y carga útil** de los paquetes de la capa de aplicación.
- Función clave: **verificar que el protocolo de aplicación coincida con el puerto**.
  - Ejemplo: el malware puede enviar datos TCP a través del puerto `80` — un cortafuego L7 lo detecta porque no es tráfico HTTP real.
- Ejemplo: WAF analiza encabezados HTTP y código de páginas web buscando cadenas de ataque.

### Nombres equivalentes del cortafuego de capa 7

- Puerta de enlace de la capa de aplicación
- Inspección multicapa con estado
- Inspección profunda de paquetes (DPI — Deep Packet Inspection)

> **👉 Enfoque de Examen SY0-701:** La diferencia entre stateless, stateful y application-layer firewall es crítica. Stateless = no recuerda; Stateful = recuerda sesiones TCP; L7/DPI = inspecciona el contenido. Una pregunta clásica: ¿qué tipo de cortafuego puede detectar que un malware usa el puerto 80 para tráfico no-HTTP? Respuesta: cortafuego de capa 7. Vigilar DPI como sinónimo de inspección de capa de aplicación.

## Servidores Proxy

> **Analogía:** Un servidor proxy es como un intermediario en una transacción inmobiliaria. El comprador no habla directamente con el vendedor; todo pasa a través del agente, que puede revisar, modificar o bloquear la comunicación.

Un **servidor proxy** usa un modelo de **almacenamiento y reenvío**: deconstruye cada paquete, lo analiza, lo reconstruye y lo reenvía si cumple las normas. Esto lo diferencia de un cortafuego que solo acepta o bloquea.

### Proxies Directos (Forward Proxies)

- Gestionan tráfico **saliente** específico del protocolo.
- Ejemplo: Proxy web para puertos `TCP/80` (HTTP) y `TCP/443` (HTTPS).
- **Ventajas:** Control centralizado, motor de **caché** (almacena páginas frecuentes → ahorra ancho de banda).

| Tipo | Configuración del cliente | Uso típico |
|---|---|---|
| **No transparente** | Cliente configurado explícitamente con IP y puerto del proxy (generalmente `TCP/8080`) | Entornos corporativos controlados |
| **Transparente (forzado/interceptor)** | Sin configuración del cliente; el proxy intercepta el tráfico automáticamente | Debe implementarse como router o dispositivo inline |

- **PAC (Proxy Auto-Configuration script — Script de Configuración Automática de Proxy):** Permite al cliente configurar ajustes de proxy sin intervención del usuario.
- **WPAD (Web Proxy Auto-Discovery Protocol — Protocolo de Descubrimiento Automático del Proxy Web):** Permite a los navegadores localizar el archivo PAC.
- Ambos tipos pueden requerir **autenticación** de usuarios (posiblemente con SSO — Single Sign-On — Inicio de Sesión Único).

### Proxies Inversos (Reverse Proxies)

- Gestionan tráfico **entrante** específico del protocolo.
- Se despliegan en el **borde de la red**.
- Escuchan solicitudes de clientes de redes públicas (Internet).
- Aplican reglas de filtrado y reenvían solicitudes aceptadas a servidores internos.

> **👉 Enfoque de Examen SY0-701:** Forward proxy vs. reverse proxy es un clásico. Forward = protege a los clientes internos al acceder a Internet. Reverse = protege a los servidores internos de las solicitudes de Internet. Distractor: el proxy transparente puede confundirse con el "modo transparente" del cortafuego — son conceptos distintos. El puerto estándar del proxy no transparente es `TCP/8080`.

## Sistemas de Detección de Intrusiones

### Sensores

- Un **NIDS (Network Intrusion Detection System — Sistema de Detección de Intrusiones en la Red)** captura tráfico a través de un **rastreador de paquetes (sniffer)** denominado **sensor**.
- El sensor puede usar un puerto **SPAN/espejo** o un **TAP** insertado.
- Se coloca habitualmente **detrás de un cortafuego** o cerca de un servidor importante.
- La cantidad de sensores depende de los recursos de la red.

### IDS (Intrusion Detection System — Sistema de Detección de Intrusiones)

> **Analogía:** Un IDS es como una cámara de seguridad: registra y alerta, pero no interviene directamente. Observa todo el tráfico en busca de comportamientos sospechosos.

Software/dispositivos conocidos: **Snort** (`snort.org`), **Suricata** (`suricata-ids.org`), **Zeek/Bro** (`zeek.org`).

- Cuando el tráfico coincide con una **firma de detección** o **patrón heurístico**, el IDS emite una **alerta** o genera un **registro**.
- **No bloquea** el host de origen.
- El sensor pasivo **no ralentiza el tráfico** y es **indetectable** por el atacante.

**Detecciones típicas:**
- Intentos de adivinar contraseñas (brute force)
- Escaneos de puertos
- Gusanos (worms)
- Aplicaciones backdoor (puertas traseras)
- Paquetes o sesiones mal formados
- Otras violaciones de política

### IPS (Intrusion Prevention System — Sistema de Prevención de Intrusiones)

> **Analogía:** Si el IDS es la cámara de seguridad, el IPS es el guardia de seguridad con capacidad de intervenir: puede bloquear, redirigir o expulsar a los intrusos.

- Capacidad de **respuesta activa**.
- Implementable como dispositivo **inline** con cortafuego integrado.

**Respuestas típicas del IPS:**

| Respuesta | Descripción |
|---|---|
| **Bloqueo (Shunning)** | Bloquea temporal o permanentemente el origen del tráfico no conforme |
| **Restablecimiento de conexión** | Reinicia la conexión sin bloquear la IP origen |
| **Redirección a honeypot/honeynet** | Para análisis adicional de amenazas |

> **Nota:** Tanto **Snort** como **Suricata** pueden configurarse como IPS además de IDS.

> **👉 Enfoque de Examen SY0-701:** IDS vs. IPS es uno de los temas más examinados. IDS = detecta y alerta (pasivo). IPS = detecta y responde activamente (puede estar inline). Un IPS puede reconfigurar otro dispositivo (ej. cortafuego/router) vía API o scripting para bloquear. Distractor: un IDS inline suena contradictorio — un IDS puede estar físicamente inline pero sin capacidad de bloqueo sigue siendo IDS. El honeypot como respuesta de IPS es un concepto que también aparece.

## Cortafuegos de Próxima Generación (NGFW) y Administración de Amenazas Unificadas (UTM)

### NGFW (Next-Generation Firewall — Cortafuego de Próxima Generación)

Lanzado en **2010 por Palo Alto Networks**. Sin especificación oficial, pero características típicas:

- **Filtrado de capa 7** sensible a las aplicaciones.
- **Inspección de tráfico TLS cifrado** (TLS — Transport Layer Security).
- **Integración con directorios de red** (control por usuario/rol y basado en tiempo).
- **Funcionalidad IPS integrada** (prevención de intrusiones).
- **Inspección profunda de paquetes (DPI)** y conocimiento de aplicaciones.
- **Integración con redes en la nube**.

### UTM (Unified Threat Management — Administración de Amenazas Unificadas)

> **Analogía:** El UTM es como una navaja suiza de seguridad: tiene todas las herramientas en un solo dispositivo. El NGFW es como un bisturí quirúrgico: hace menos cosas, pero con más precisión y rendimiento.

Centraliza múltiples controles en **un solo dispositivo**:

- Cortafuego + Antimalware + IPS de red
- Filtrado de spam + Filtrado de contenido
- **DLP (Data Loss Prevention — Prevención de Pérdida de Datos)**
- **VPN (Virtual Private Network — Red Privada Virtual)**
- **CASB (Cloud Access Security Broker — Agente de Seguridad de Acceso a la Nube)**
- Protección de endpoints / escaneo de malware

### Comparación NGFW vs. UTM

| Característica | NGFW | UTM |
|---|---|---|
| **Funciones** | Enfocado: menos funciones | Integral: todas las funciones |
| **Rendimiento** | Mejor rendimiento | Puede tener problemas de latencia bajo alta carga |
| **Mercado** | Empresas (enterprise) | PYMEs con recursos/experiencia TI limitados |
| **Riesgo** | Menor SPOF | Único punto de falla para múltiples controles |
| **Gestión** | Consolas separadas | Monitoreo y administración consolidados en una consola |

**Desventajas del UTM:**
- **Punto único de falla (SPOF):** Si cae el UTM, todos los controles fallan.
- **Latencia** bajo alta actividad de red.
- Puede no rendir tan bien como software o dispositivos especializados.

> **👉 Enfoque de Examen SY0-701:** UTM = todo en uno = riesgo de SPOF. NGFW = producto empresarial con mejor rendimiento. CompTIA puede presentar un escenario de PYME con presupuesto limitado → UTM es la respuesta correcta. Distractor: ambos pueden tener IPS, DPI y filtrado de aplicaciones — la diferencia está en el mercado objetivo y el enfoque. "UTM" y "NGFW" son parcialmente términos de marketing.

## Balanceadores de Carga

> **Analogía:** Un balanceador de carga es como varios cajeros en un banco: los clientes son dirigidos al cajero disponible, por lo que si uno está ocupado o ausente, el servicio continúa.

Un **balanceador de carga** distribuye solicitudes de clientes entre nodos disponibles en una **granja o clúster de servidores**.

**Usos:** Servidores web, correo electrónico front-end, conferencias web, videoconferencias, streaming multimedia.

### Tipos de Balanceador de Carga

| Tipo | Capa OSI | Criterio de decisión de reenvío |
|---|---|---|
| **L4 (Capa de transporte)** | 4 | Dirección IP + encabezados TCP/UDP |
| **L7 (Capa de aplicación / Content Switch)** | 7 | URL, tipo de datos (video/audio), cookies |

### Algoritmos de Programación (Scheduling)

| Algoritmo | Descripción |
|---|---|
| **Round Robin** | Elige el próximo nodo en orden rotativo |
| **Menos conexiones** | Elige el nodo con menos conexiones activas |
| **Mejor tiempo de respuesta** | Elige el nodo más rápido |
| **Ponderado** | Aplica preferencias del administrador o datos dinámicos de carga |

### Health Checks (Verificación de Estado)

El balanceador usa **latidos (heartbeats) o sondas** para verificar disponibilidad y carga:
- L4: solo pruebas de **conectividad básica**.
- L7: puede probar el **estado de la aplicación** y verificar disponibilidad del host.

### Afinidad por IP de Origen y Persistencia de Sesión

- **Afinidad por IP de origen (L4):** El cliente se "pega" al nodo que primero aceptó su solicitud.
- **Persistencia de sesión (L7):** Se configura una **cookie** en el nodo o inyectada por el balanceador para mantener al cliente en la misma sesión. Más confiable que la afinidad IP, pero requiere que el navegador acepte la cookie.

> **Beneficios adicionales:** Tolerancia a fallos (si un nodo cae, el tráfico se redirige) y mitigación de ataques DoS (Denial of Service — Denegación de Servicio).

> **👉 Enfoque de Examen SY0-701:** El balanceador de carga aparece en preguntas sobre disponibilidad y mitigación de DoS. Distingue L4 (IP/puerto) de L7 (contenido/URL). La persistencia de sesión vía cookie es un concepto de capa de aplicación. Distractor: el balanceador de carga no es un dispositivo de seguridad primario, pero contribuye a disponibilidad (CIA) y puede mitigar DoS.

## Cortafuegos de Aplicaciones Web (WAF)

Un **WAF (Web Application Firewall — Cortafuego de Aplicaciones Web)** protege el software en servidores web y sus bases de datos contra:
- **Ataques de inyección de código** (SQL Injection, XSS, etc.)
- **Ataques de denegación de servicio (DoS)**

### Funcionamiento del WAF

- Usa **reglas conscientes de la aplicación** para filtrar tráfico.
- Realiza **detección de intrusiones específica** de la aplicación.
- Se programa con **firmas de ataques conocidos** y **coincidencia de patrones**.
- Bloquea solicitudes con código sospechoso.
- La salida se escribe en un **registro** que revela amenazas potenciales.

### Implementación del WAF

- Como **dispositivo** protegiendo la zona del servidor web.
- Como **software de complemento** para la plataforma del servidor web (ej. ModSecurity para IIS/Apache/Nginx).

> **👉 Enfoque de Examen SY0-701:** El WAF es específico para proteger aplicaciones web. Si el escenario menciona SQL Injection, XSS o ataques a APIs web, la respuesta es WAF — no un cortafuego genérico. Distractor: un NGFW con DPI puede detectar algunos ataques web, pero no con la misma especificidad que un WAF dedicado. ModSecurity es el WAF de código abierto más conocido.

# 3. Comunicaciones Seguras

## Arquitectura de Acceso Remoto

La **red de acceso remoto** significa que el dispositivo del usuario se conecta a través de una red **intermediaria** (no directamente por cable/inalámbrico a la red corporativa).

### Topologías de VPN (Virtual Private Network — Red Privada Virtual)

| Topología | Descripción | Caso de uso | Iniciador |
|---|---|---|---|
| **Cliente a sitio (acceso remoto)** | Trabajador remoto → Gateway VPN corporativo | Teletrabajo; empleados de campo | Cliente |
| **Sitio a sitio** | Gateway VPN ↔ Gateway VPN entre dos sedes | Conectar oficinas remotas | Configuración automática |
| **Host a host** | Asegura el tráfico entre dos equipos cuando la red privada no es de confianza | Escenarios de alta seguridad punto a punto | — |

### Protocolos VPN

- **PPTP (Point-to-Point Tunneling Protocol — Protocolo de Túnel Punto a Punto):** Obsoleto; **no ofrece seguridad adecuada**.
- **TLS (Transport Layer Security — Seguridad de la Capa de Transporte):** Actualmente preferido.
- **IPsec (Internet Protocol Security — Seguridad del Protocolo de Internet):** Actualmente preferido.

### VPN Sitio a Sitio: Comportamiento

- Funciona **automáticamente** sin configuración en los hosts.
- Las **puertas de enlace** intercambian información de seguridad.
- La infraestructura de enrutamiento determina si el tráfico es local o va al túnel VPN.

> **👉 Enfoque de Examen SY0-701:** PPTP está obsoleto y es incorrecto como respuesta si el escenario pide seguridad. TLS e IPsec son las respuestas correctas. En VPN sitio a sitio, los hosts individuales no necesitan configuración de VPN. Distractor: "cliente a sitio" puede confundirse con la VPN del tipo "host a host" — en cliente a sitio, el cliente accede a la red corporativa; en host a host, es comunicación privada entre dos máquinas específicas.

## Túnel de Seguridad de la Capa de Transporte (TLS)

### Cómo funciona una VPN TLS

1. El cliente se conecta al servidor de acceso remoto mediante **certificados digitales**.
2. El certificado del servidor **identifica la gateway VPN** ante el cliente.
3. Opcionalmente: el cliente también tiene su propio certificado → **autenticación mutua**.
4. TLS crea un **túnel cifrado** para enviar credenciales de autenticación (procesadas por un servidor RADIUS).
5. Una vez autenticado, la gateway VPN **tuneliza todas las comunicaciones** de la LAN a través del socket seguro.

### Protocolo de transporte para VPN TLS

| Protocolo | Ventaja |
|---|---|
| `UDP` | Mejor rendimiento; preferido para tráfico sensible a latencia (voz/video) |
| `TCP` | Más fácil de usar con políticas de cortafuego por defecto |

> **DTLS (Datagram Transport Layer Security):** TLS sobre UDP.

### Versiones de TLS

| Versión | Estado |
|---|---|
| **TLS 1.3** | Versión más reciente; **preferida** |
| **TLS 1.2** | Compatible |
| TLS 1.1, 1.0, SSL | **Obsoletas** (deprecated) |

> **Nota:** OpenVPN (`openvpn.net`) es la implementación de VPN TLS más conocida. Puerto estándar: `UDP/1194`.

> **👉 Enfoque de Examen SY0-701:** TLS 1.3 es la versión correcta; TLS 1.0/SSL son vulnerables. Si el escenario menciona POODLE, BEAST o HEARTBLEED, están relacionados con versiones antiguas de SSL/TLS. La autenticación mutua con certificados tanto del cliente como del servidor es más segura que solo el certificado del servidor. DTLS = TLS sobre UDP.

## Túnel de Seguridad del Protocolo de Internet (IPsec)

**IPsec** opera en la **capa 3 (red)** del modelo OSI → se implementa sin configurar soporte de aplicación específico e incurre en **menos sobrecarga de paquetes**.

### Los Dos Protocolos Principales de IPsec

| Protocolo | Sigla | Función | Confidencialidad | Integridad |
|---|---|---|---|---|
| **Encabezado de Autenticación** | AH (Authentication Header) | Hash criptográfico de todo el paquete + clave secreta → genera ICV | ❌ No (carga útil no cifrada) | ✅ Sí |
| **Carga de Seguridad Encapsuladora** | ESP (Encapsulating Security Payload) | Cifra el paquete + agrega encabezado, finalizador e ICV | ✅ Sí | ✅ Sí |

> **ICV (Integrity Check Value — Valor de Verificación de Integridad):** Valor calculado para confirmar que el paquete no ha sido modificado.

> **Diferencia clave AH vs. ESP:** AH incluye el encabezado IP en el hash; ESP excluye el encabezado IP al calcular el ICV.

### Los Dos Modos de IPsec

| Modo | Uso | Qué se cifra con ESP | AH en este modo |
|---|---|---|---|
| **Modo Transporte** | Comunicaciones entre hosts en una red privada | Solo los datos de carga útil; el encabezado IP no se cifra | Puede proporcionar integridad para el encabezado IP |
| **Modo Túnel** | VPN sitio a sitio a través de una red no segura | Todo el paquete IP original (encabezado + carga útil) encapsulado con un nuevo encabezado IP | No tiene caso de uso en modo túnel (generalmente se requiere confidencialidad) |

### Resumen de combinaciones

```
Modo Transporte + AH  → Integridad sin cifrado (entre hosts, red confiable)
Modo Transporte + ESP → Cifrado de carga útil (entre hosts)
Modo Túnel + ESP      → Cifrado completo del paquete (VPN sitio a sitio) ← MÁS COMÚN
Modo Túnel + AH       → No tiene uso práctico (sin confidencialidad)
```

> **👉 Enfoque de Examen SY0-701:** IPsec en modo túnel con ESP es la configuración estándar para VPNs sitio a sitio. AH no cifra, solo autentica e integra. CompTIA puede presentar escenarios donde se pide elegir entre AH y ESP: si se necesita confidencialidad → ESP; si solo se necesita integridad → AH. Recuerda: AH incluye el encabezado IP en el hash; ESP no. El modo transporte es para host a host en red privada; el modo túnel es para VPN entre sitios.

## Intercambio de Claves de Internet (IKE)

El protocolo **IKE (Internet Key Exchange — Intercambio de Claves de Internet)** gestiona:
- Método de **autenticación** entre pares.
- Selección de **cifrados criptográficos** compatibles.
- **Intercambio de claves**.

El conjunto de propiedades acordadas se denomina **SA (Security Association — Asociación de Seguridad)**.

### Fases de la negociación IKE

**Fase 1:** Establece la identidad de ambos pares mediante el algoritmo **Diffie-Hellman** para crear un canal seguro.

Métodos de autenticación de pares:

| Método | Descripción |
|---|---|
| **Certificados digitales** | Emitidos por una CA (Certificate Authority — Autoridad de Certificación) de confianza mutua |
| **Clave Pre-compartida (PSK — Pre-Shared Key)** | La misma frase de contraseña configurada en ambos pares (autenticación de grupo) |

**Fase 2:** Usa el canal seguro creado en Fase 1 para establecer qué cifrados y tamaños de clave se usarán con AH o ESP en la sesión IPsec.

### Versiones de IKE

| Versión | Características | Topología principal |
|---|---|---|
| **IKEv1** | Original; requiere protocolo de soporte para VPN de acceso remoto | Sitio a sitio, host a host |
| **IKEv2** | Soporta métodos de autenticación **EAP** (contra servidor RADIUS); modo de configuración simple; recorrido **NAT (NAT traversal)**; **MOBIKE** (multiconexión para smartphones) | Acceso remoto cliente a sitio |

> **MOBIKE:** Permite que un smartphone mantenga la conexión IPsec activa al cambiar entre interfaces Wi-Fi y celular.

> **👉 Enfoque de Examen SY0-701:** IKEv2 es preferible para VPN de acceso remoto porque soporta EAP/RADIUS para autenticación de usuarios. La PSK es más fácil de configurar pero menos segura que los certificados. Diffie-Hellman aparece en la Fase 1 de IKE — es el algoritmo que establece el canal seguro inicial. Vigilar: la SA es el resultado del proceso IKE, no el proceso en sí.

## Escritorio Remoto

### RDP (Remote Desktop Protocol — Protocolo de Escritorio Remoto)

- Protocolo de **Microsoft** para acceso gráfico remoto a máquinas físicas individuales.
- Envía **datos de pantalla y audio** desde el host remoto al cliente.
- Transfiere **entrada de mouse y teclado** del cliente al host remoto.
- Las conexiones RDP están **cifradas por defecto**.
- **Puerto estándar:** `TCP/3389`.

### Alternativas y soluciones complementarias

| Solución | Descripción |
|---|---|
| **VNC (Virtual Network Computing)** | Múltiples proveedores (ej. RealVNC) |
| **TeamViewer** | Solución comercial multiplataforma |
| **Puerta de enlace de escritorio remoto** | Facilita acceso a escritorios virtuales o aplicaciones individuales en servidores de la red |

**Plataformas soportadas generalmente:** Windows, macOS, iOS, Linux, Chrome OS, Android.

### VPN HTML5 / Puerta de enlace sin cliente

> **Tecnología:** El elemento `canvas` de **HTML5** permite a un navegador dibujar y actualizar un escritorio con bajo retraso. También maneja audio.
> **Protocolo:** **WebSockets** → mensajes bidireccionales sin la sobrecarga de peticiones HTTP separadas.
> **Ejemplo:** Apache Guacamole (`guacamole.apache.org`).

- No requiere aplicación cliente dedicada.
- Acceso remoto solo con un navegador web.

> **👉 Enfoque de Examen SY0-701:** RDP = puerto `TCP/3389` = cifrado por defecto. La puerta de enlace HTML5/sin cliente es la solución cuando no se puede instalar software en el cliente. WebSockets es el protocolo que habilita la comunicación bidireccional en tiempo real en HTML5. Distractor: VNC no está cifrado por defecto en todas las implementaciones — RDP sí.

## Shell Seguro (SSH)

**SSH (Secure Shell — Shell Seguro)** es el principal medio para acceso remoto seguro a un **terminal de línea de comandos**.

**Puerto estándar:** `TCP/22`.
**Usos principales:** Administración remota, **SFTP (Secure File Transfer Protocol — Protocolo de Transferencia Segura de Archivos)**.
**Implementación más usada:** OpenSSH (`openssh.com`).

### Identificación de Servidores SSH

- Los servidores SSH se identifican mediante **pares de claves públicas/privadas** denominadas **claves del host**.
- El cliente puede asignar manualmente nombres de host a claves de host.
- Si la clave privada del servidor está comprometida → el atacante puede **suplantar el servidor** (ataque MITM — Man-In-The-Middle).
- **La clave del host debe cambiarse** si se sospecha compromiso.

### Métodos de Autenticación del Cliente SSH

(Configurados en `/etc/ssh/sshd_config` en el servidor):

| Método | Descripción |
|---|---|
| **Usuario/Contraseña** | El servidor SSH verifica contra base de datos local o servidor RADIUS |
| **Autenticación de clave pública** | La clave pública del usuario remoto se agrega a la lista de claves autorizadas de la cuenta local en el servidor |
| **Kerberos** | El cliente envía credenciales Kerberos (TGT — Ticket Granting Ticket) obtenidas al conectarse; el servidor SSH valida con el servicio de concesión de tickets (KDC/controlador de dominio Windows) vía **GSSAPI (Generic Security Services Application Programming Interface)** |

### Comandos SSH Clave

```bash
# Conectarse a 10.1.0.10 como usuario "bobby" (autenticación con contraseña)
ssh bobby@10.1.0.10

# Generar un nuevo par de claves RSA
ssh-keygen -t rsa

# Copiar la clave pública al servidor remoto
ssh-copy-id bobby@10.1.0.10

# Copiar un archivo desde el servidor remoto al host local
scp bobby@10.1.0.10:/logs/audit.log audit.log

# Copiar un directorio recursivamente
scp -r bobby@10.1.0.10:/logs/ ./logs_backup/
```

### Gestión de Claves Públicas — Consideraciones de Seguridad

- **Tarea crítica:** Administrar las claves públicas válidas de los clientes.
- Si una clave privada de usuario se ve comprometida:
  1. **Eliminar** la clave pública del servidor SSH.
  2. **Re-generar** el par de claves en el dispositivo cliente.
  3. **Copiar** la nueva clave pública al servidor SSH.
- **Siempre eliminar** las claves públicas cuando se revocan permisos de acceso del usuario.

> **👉 Enfoque de Examen SY0-701:** SSH es fundamental. Puerto `TCP/22`. La autenticación de clave pública es más segura que usuario/contraseña. Un ataque MITM en SSH se mitiga verificando la huella digital (fingerprint) de la clave del host. `scp` usa SSH para transferencia segura de archivos — a diferencia de `FTP` (inseguro) o `SFTP` que también usa SSH. Vigilar: si una clave privada se compromete, la clave pública en el servidor debe eliminarse inmediatamente.

## Gestión Fuera de Banda y Servidores de Salto

### SAW (Secure Administrative Workstation — Estación de Trabajo Administrativa Segura)

- Estaciones de trabajo dedicadas para administración remota.
- Solo con software necesario: navegador mínimo, cliente SSH, cliente RDP.
- **Acceso a Internet denegado** o restringido a sitios de proveedores aprobados (parches/soporte).
- Sujetas a **control de acceso riguroso** y **auditorías**.

### Gestión en Banda vs. Fuera de Banda

| Tipo | Descripción | Cifrado requerido | Costo/Complejidad |
|---|---|---|---|
| **In-band (En banda)** | El canal de gestión comparte el tráfico de red de producción | Sí: TLS, IPsec, RDP o SSH | Menor |
| **OOB (Out-of-Band — Fuera de Banda)** | Canal físicamente separado de la red de producción | Inherente (separación física) | Mayor, pero más seguro |

**Métodos OOB:**
- Puerto de **módem o consola serie** en un router (físicamente fuera de banda).
- Interfaz de gestión en una **VLAN de gestión dedicada** o **infraestructura de red físicamente separada**.

> **Ventaja OOB:** El acceso al dispositivo se mantiene incluso cuando hay problemas en la red de producción.

### Jump Server / Bastion Host (Servidor de Salto / Bastión)

> **Analogía:** El servidor de salto es como la puerta trasera de un edificio seguro. Para acceder a los servidores internos, primero debes entrar al servidor de salto (el guardia), que luego te escolta hasta donde necesitas ir.

**Problema:** Cuando hay muchos servidores en una zona segura, gestionar qué hosts pueden acceder a las interfaces administrativas es complejo.

**Solución — Servidor de Salto:**
- Único servidor de administración en la zona segura.
- Solo ejecuta el protocolo y puerto administrativo necesario (SSH o RDP).
- Los administradores se conectan **al servidor de salto** → desde allí se conectan a los servidores de aplicaciones.
- La interfaz de administración de cada servidor de aplicaciones solo tiene **una entrada en su ACL: el servidor de salto**.
- Cualquier intento de conexión directa desde otros hosts es **denegado**.

**Flujo de acceso:**

```
[Administrador] ---(VPN/SSH)---> [Servidor de Salto] ---(SSH/RDP)---> [Servidor de Aplicaciones]
                                                                              ↑
                                              Solo acepta conexiones desde el Servidor de Salto
```

**Reglas del servidor de salto:**

1. VPN puede usarse para acceder al servidor de salto, que luego reenvía tráfico de administración.
2. Tráfico de hosts autorizados en la red también puede ir por el servidor de salto.
3. No se permite tráfico de administración de hosts no autorizados.
4. Los servidores de aplicaciones solo aceptan conexiones administrativas desde el servidor de salto.
5. El tráfico de aplicación normal usa una red diferente.

> **👉 Enfoque de Examen SY0-701:** El servidor de salto (jump server/bastion host) es una pregunta frecuente en escenarios de gestión segura. La clave: es el único punto de acceso administrativo a servidores en una zona protegida. OOB vs. in-band: OOB es más seguro porque está separado de la red de producción — el tráfico de gestión no comparte el mismo canal. SAW es la estación cliente del administrador; el jump server es el intermediario en la red objetivo.

# 4. Puertos Clave

| Puerto | Protocolo | Uso |
|---|---|---|
| `TCP/22` | SSH, SFTP, SCP | Shell seguro y transferencia segura de archivos |
| `TCP/80` | HTTP | Web no cifrada |
| `TCP/443` | HTTPS (TLS) | Web cifrada |
| `TCP/3389` | RDP | Escritorio remoto de Microsoft |
| `TCP/8080` | HTTP Proxy | Puerto estándar de proxy no transparente |
| `UDP/1194` | OpenVPN | VPN TLS con UDP |
| `TCP/UDP/1812-1813` | RADIUS | Autenticación (1812), Accounting (1813) |

## Dispositivos por Capa OSI

| Capa | Dispositivo | Función |
|---|---|---|
| 1 | TAP | Copia física de señal para monitoreo |
| 2 | Switch, AP, WAP | Conmutación por MAC, VLAN |
| 3 | Router, Switch L3 | Enrutamiento por IP, separación de subredes |
| 4 | Balanceador de carga L4, Firewall stateful | TCP/UDP, sesiones |
| 7 | Proxy, WAF, NGFW, Balanceador L7 | Aplicaciones, contenido |

## Resumen de Controles de Seguridad

| Control | Tipo | Descripción |
|---|---|---|
| Cortafuego (Firewall) | Preventivo | Filtra tráfico por ACL |
| IDS | Detectivo | Alerta sin bloquear |
| IPS | Correctivo/Preventivo | Alerta y bloquea activamente |
| WAF | Preventivo/Detectivo | Protección específica de aplicaciones web |
| Balanceador de carga | Correctivo | Alta disponibilidad, mitiga DoS |
| Proxy directo | Preventivo | Controla acceso saliente de clientes |
| Proxy inverso | Preventivo | Protege servidores de solicitudes externas |
| 802.1X/EAP | Preventivo | Autenticación de acceso a la red por puerto |
| Air gap | Preventivo | Aislamiento físico total |
| Jump server | Preventivo | Punto único de acceso administrativo |
| OOB Management | Preventivo/Detectivo | Canal de gestión separado de producción |

# 5. Glosario

| Acrónimo | Significado completo |
|---|---|
| **AAA** | Authentication, Authorization, Accounting (Autenticación, Autorización y Contabilidad) |
| **ACL** | Access Control List (Lista de Control de Acceso) |
| **AH** | Authentication Header (Encabezado de Autenticación) |
| **AP / WAP** | Access Point / Wireless Access Point (Punto de Acceso Inalámbrico) |
| **ARP** | Address Resolution Protocol (Protocolo de Resolución de Direcciones) |
| **CASB** | Cloud Access Security Broker (Agente de Seguridad de Acceso a la Nube) |
| **DLP** | Data Loss Prevention (Prevención de Pérdida de Datos) |
| **DNS** | Domain Name System (Sistema de Nombres de Dominio) |
| **DoS** | Denial of Service (Denegación de Servicio) |
| **DPI** | Deep Packet Inspection (Inspección Profunda de Paquetes) |
| **DTLS** | Datagram Transport Layer Security |
| **EAP** | Extensible Authentication Protocol (Protocolo de Autenticación Extensible) |
| **EAPoL** | EAP over LAN |
| **ESP** | Encapsulating Security Payload (Carga de Seguridad Encapsuladora) |
| **FQDN** | Fully Qualified Domain Name (Nombre de Dominio Completamente Calificado) |
| **GSSAPI** | Generic Security Services Application Programming Interface |
| **ICV** | Integrity Check Value (Valor de Verificación de Integridad) |
| **IDS** | Intrusion Detection System (Sistema de Detección de Intrusiones) |
| **IKE** | Internet Key Exchange (Intercambio de Claves de Internet) |
| **IPS** | Intrusion Prevention System (Sistema de Prevención de Intrusiones) |
| **IPsec** | Internet Protocol Security (Seguridad del Protocolo de Internet) |
| **ISP** | Internet Service Provider (Proveedor de Servicios de Internet) |
| **LAN** | Local Area Network (Red de Área Local) |
| **MAC** | Media Access Control |
| **MOBIKE** | IKEv2 Mobility and Multihoming Protocol |
| **ND** | Neighbor Discovery (Protocolo de Descubrimiento Cercano) — IPv6 |
| **NGFW** | Next-Generation Firewall (Cortafuego de Próxima Generación) |
| **NIDS** | Network Intrusion Detection System |
| **OOB** | Out-of-Band (Fuera de Banda) |
| **OSI** | Open Systems Interconnection (Interconexión de Sistema Abierto) |
| **PAC** | Proxy Auto-Configuration script |
| **PKI** | Public Key Infrastructure (Infraestructura de Clave Pública) |
| **PNAC** | Port-based Network Access Control (Control de Acceso a Red Basado en Puertos) |
| **PPTP** | Point-to-Point Tunneling Protocol (Protocolo de Túnel Punto a Punto) — OBSOLETO |
| **PSK** | Pre-Shared Key (Clave Pre-compartida) |
| **RADIUS** | Remote Authentication Dial-In User Service (Servicio de Autenticación Remota de Usuario por Acceso Telefónico) |
| **RDP** | Remote Desktop Protocol (Protocolo de Escritorio Remoto) |
| **SA** | Security Association (Asociación de Seguridad) |
| **SAW** | Secure Administrative Workstation (Estación de Trabajo Administrativa Segura) |
| **SCP** | Secure Copy Protocol |
| **SFTP** | Secure File Transfer Protocol |
| **SLA** | Service Level Agreement (Acuerdo de Nivel de Servicio) |
| **SPAN** | Switched Port Analyzer (Analizador de Puerto Conmutado) |
| **SPOF** | Single Point of Failure (Punto Único de Falla) |
| **SSH** | Secure Shell (Shell Seguro) |
| **SSO** | Single Sign-On (Inicio de Sesión Único) |
| **TAP** | Test Access Point (Punto de Acceso de Prueba) |
| **TCP** | Transmission Control Protocol (Protocolo de Control de Transmisión) |
| **TLS** | Transport Layer Security (Seguridad de la Capa de Transporte) |
| **UDP** | User Datagram Protocol (Protocolo de Datagrama de Usuario) |
| **UTM** | Unified Threat Management (Administración de Amenazas Unificadas) |
| **VLAN** | Virtual LAN (Red de Área Local Virtual) |
| **VNC** | Virtual Network Computing |
| **VoIP** | Voice over IP (Voz sobre Protocolo de Internet) |
| **VPN** | Virtual Private Network (Red Privada Virtual) |
| **WAF** | Web Application Firewall (Cortafuego de Aplicaciones Web) |
| **WAN** | Wide Area Network (Red de Área Amplia) |
| **WPAD** | Web Proxy Auto-Discovery Protocol |