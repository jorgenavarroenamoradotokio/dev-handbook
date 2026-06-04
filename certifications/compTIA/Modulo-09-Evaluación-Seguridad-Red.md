> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Líneas Base de Seguridad de la Red](#1-líneas-base-de-seguridad-de-la-red)
  - [¿Qué es una línea base de seguridad (*Secure Baseline*)?](#qué-es-una-línea-base-de-seguridad-secure-baseline)
- [2. Puntos de Referencia y Guías de Configuración de Seguridad](#2-puntos-de-referencia-y-guías-de-configuración-de-seguridad)
  - [Fuentes de Líneas Base Reconocidas](#fuentes-de-líneas-base-reconocidas)
  - [Marcos de Cumplimiento cubiertos por CIS Benchmarks](#marcos-de-cumplimiento-cubiertos-por-cis-benchmarks)
  - [Ejemplos de CIS Benchmarks por producto](#ejemplos-de-cis-benchmarks-por-producto)
  - [Conceptos de Endurecimiento (*Hardening*)](#conceptos-de-endurecimiento-hardening)
  - [Herramientas para Gestión de Líneas Base](#herramientas-para-gestión-de-líneas-base)
  - [Endurecimiento de Switches y Routers](#endurecimiento-de-switches-y-routers)
  - [Endurecimiento de Servidores y Sistemas Operativos](#endurecimiento-de-servidores-y-sistemas-operativos)
- [3. Consideraciones sobre la Instalación de Redes Inalámbricas](#3-consideraciones-sobre-la-instalación-de-redes-inalámbricas)
  - [Conceptos Clave de Infraestructura Inalámbrica](#conceptos-clave-de-infraestructura-inalámbrica)
  - [Bandas de Frecuencia](#bandas-de-frecuencia)
  - [Sondeo del Sitio (*Site Survey*) y Mapas de Calor (*Heat Maps*)](#sondeo-del-sitio-site-survey-y-mapas-de-calor-heat-maps)
- [4. Cifrado Inalámbrico](#4-cifrado-inalámbrico)
  - [Evolución de los Estándares de Seguridad Wi-Fi](#evolución-de-los-estándares-de-seguridad-wi-fi)
  - [Estándares 802.11 y Generaciones Wi-Fi](#estándares-80211-y-generaciones-wi-fi)
  - [WPS (*Wi-Fi Protected Setup*, Configuración Protegida Wi-Fi)](#wps-wi-fi-protected-setup-configuración-protegida-wi-fi)
  - [Easy Connect / DPP (*Device Provisioning Protocol*, Protocolo de Aprovisionamiento de Dispositivos)](#easy-connect--dpp-device-provisioning-protocol-protocolo-de-aprovisionamiento-de-dispositivos)
  - [Características Principales de WPA3](#características-principales-de-wpa3)
- [5. Métodos de Autenticación Wi-Fi](#5-métodos-de-autenticación-wi-fi)
  - [Los Tres Modos de Autenticación Wi-Fi](#los-tres-modos-de-autenticación-wi-fi)
  - [Autenticación Personal WPA2 — PSK](#autenticación-personal-wpa2--psk)
  - [Autenticación Personal WPA3 — SAE (*Dragonfly*)](#autenticación-personal-wpa3--sae-dragonfly)
  - [Autenticación Empresarial — 802.1x + EAP + RADIUS](#autenticación-empresarial--8021x--eap--radius)
  - [Flujo del Protocolo RADIUS](#flujo-del-protocolo-radius)
- [6. Control de Acceso a la Red (NAC)](#6-control-de-acceso-a-la-red-nac)
  - [¿Qué evalúa NAC?](#qué-evalúa-nac)
  - [Capacidades de NAC](#capacidades-de-nac)
  - [Ejemplo de Asignación Dinámica de VLAN](#ejemplo-de-asignación-dinámica-de-vlan)
  - [Configuraciones: Con Agente vs. Sin Agente](#configuraciones-con-agente-vs-sin-agente)
  - [Tipos de Agente](#tipos-de-agente)
  - [Herramienta: PacketFence (NAC de código abierto)](#herramienta-packetfence-nac-de-código-abierto)
- [7. Mejora de la Capacidad de Seguridad de la Red](#7-mejora-de-la-capacidad-de-seguridad-de-la-red)
- [8. Listas de Control de Acceso (ACL)](#8-listas-de-control-de-acceso-acl)
  - [ACL vs. Regla de Cortafuegos](#acl-vs-regla-de-cortafuegos)
  - [Principios de las ACL](#principios-de-las-acl)
  - [Tuplas de las Reglas de Firewall](#tuplas-de-las-reglas-de-firewall)
  - [Ejemplos Prácticos de Reglas ACL](#ejemplos-prácticos-de-reglas-acl)
  - [Principios de Buenas Prácticas para ACL](#principios-de-buenas-prácticas-para-acl)
  - [Subred Filtrada (*Filtered Subnet* / DMZ)](#subred-filtrada-filtered-subnet--dmz)
- [9. Sistemas de Detección y Prevención de Intrusión (IDS/IPS)](#9-sistemas-de-detección-y-prevención-de-intrusión-idsips)
  - [Tipos: Basados en Host vs. Basados en Red](#tipos-basados-en-host-vs-basados-en-red)
  - [Herramientas Principales de IDS/IPS](#herramientas-principales-de-idsips)
- [10. Métodos de Detección de IDS e IPS](#10-métodos-de-detección-de-ids-e-ips)
  - [Motor de Análisis](#motor-de-análisis)
  - [Método 1: Detección Basada en Firmas (*Signature-based*)](#método-1-detección-basada-en-firmas-signature-based)
  - [Método 2: Detección Basada en Comportamiento y Anomalías](#método-2-detección-basada-en-comportamiento-y-anomalías)
  - [Método 3: Análisis de Tendencias (*Trend Analysis*)](#método-3-análisis-de-tendencias-trend-analysis)
- [11. Filtrado Web](#11-filtrado-web)
  - [Función Principal del Filtrado Web](#función-principal-del-filtrado-web)
  - [Beneficios del Filtrado Web](#beneficios-del-filtrado-web)
  - [Tipos de Filtrado Web](#tipos-de-filtrado-web)
    - [A) Filtrado Basado en Agentes (*Agent-based*)](#a-filtrado-basado-en-agentes-agent-based)
    - [B) Filtrado Web Centralizado — Servidor Proxy](#b-filtrado-web-centralizado--servidor-proxy)
  - [Problemas del Filtrado Web](#problemas-del-filtrado-web)
- [12. Glosario](#12-glosario)

---

# 1. Líneas Base de Seguridad de la Red

> **Analogía:** Imagina que estás construyendo un edificio. La "línea base de seguridad" es como el código de construcción mínimo que todos los edificios deben cumplir: salidas de emergencia, extintores, etc. No es el máximo de seguridad, es el **mínimo garantizado**.

## ¿Qué es una línea base de seguridad (*Secure Baseline*)?

- **Definición:** Conjunto de configuraciones y controles de seguridad **mínimos y estandarizados** para dispositivos, software, redes y sistemas.
- **Objetivo:** Proporcionar un punto de partida para el **endurecimiento** (*hardening*).
- **Áreas cubiertas:**
  - Configuraciones de cortafuegos (*firewalls*)
  - Ajustes de seguridad en routers y switches
  - Configuraciones de puntos de acceso inalámbrico (WAP, *Wireless Access Point*)
  - Protocolos de seguridad para dispositivos de red
  - Políticas de contraseñas
  - Cifrado y protección de endpoints
  - Registro de eventos y monitoreo

# 2. Puntos de Referencia y Guías de Configuración de Seguridad

## Fuentes de Líneas Base Reconocidas

| Recurso | Organización | Descripción | Ámbito |
|---|---|---|---|
| **CIS Benchmarks** | CIS (*Center for Internet Security*, Centro para la Seguridad de Internet) | Guías de mejores prácticas de configuración | Múltiple: SO, redes, apps, navegadores |
| **STIG** (*Security Technical Implementation Guide*, Guías de Implementación de Seguridad Técnica) | DISA (*Defense Information Systems Agency*, Agencia de Sistemas de Información de Defensa) | Líneas base específicas para el DoD (*Department of Defense*, Departamento de Defensa de EE. UU.) | Infraestructura militar/gubernamental |

## Marcos de Cumplimiento cubiertos por CIS Benchmarks

- `PCI DSS` (Estándar de Seguridad de Datos de la Industria de Tarjetas de Pago)
- `NIST 800-53`
- `SOX` (Ley Sarbanes-Oxley)
- `ISO 27000`

## Ejemplos de CIS Benchmarks por producto

- Windows Desktop / Windows Server
- macOS / Linux
- Cisco (routers, switches)
- Navegadores web / Servidores web
- Servidores de bases de datos y correo electrónico
- VMware ESXi

## Conceptos de Endurecimiento (*Hardening*)

- **Problema:** Las configuraciones predeterminadas suelen incluir:
  - Credenciales bien documentadas (usuario `admin`, contraseña `admin`)
  - Protocolos inseguros habilitados por defecto (`Telnet`, `HTTP`)
  - Permisos excesivos

> **Analogía:** Una nueva casa tiene las puertas sin llave y las ventanas sin rejas (configuración predeterminada del fabricante). El endurecimiento es instalar cerraduras, rejas y alarmas: reducir los puntos de entrada para intrusos.

## Herramientas para Gestión de Líneas Base

| Herramienta | Tipo | Función |
|---|---|---|
| **Puppet, Chef, Ansible** | Gestión de configuración | Automatizar el despliegue de configuraciones de línea base |
| **Microsoft Group Policy** | Gestión de configuración | Aplicar políticas centralizadas en entornos Windows |
| **OpenSCAP** | Cumplimiento con `SCAP` | Evaluar y verificar conformidad del sistema |
| **CIS-CAT Pro** | Evaluación CIS | Comparar configuraciones contra benchmarks del CIS |
| **SCC** (*SCAP Compliance Checker*) | Cumplimiento DISA | Medir cumplimiento de líneas base STIG |

> **Dato clave:** Las herramientas compatibles con `SCAP` (Protocolo de Automatización de Contenido de Seguridad, *Security Content Automation Protocol*) automatizan la evaluación de configuraciones contra una línea base definida.

## Endurecimiento de Switches y Routers

| Acción de Endurecimiento | Justificación |
|---|---|
| Cambiar credenciales predeterminadas | Evitar acceso con creds documentadas públicamente |
| Deshabilitar servicios innecesarios (`HTTP`, `Telnet`) | Reducir la superficie de ataque |
| Usar `SSH` en vez de `Telnet`; `HTTPS` en vez de `HTTP` | Protocolos de administración seguros (cifrado) |
| Implementar **ACL** (*Access Control List*, Lista de Control de Acceso) | Restringir acceso solo a dispositivos/redes requeridos |
| Habilitar registro (*logging*) y monitoreo | Detectar intentos de login fallidos y cambios de config |
| Configurar **seguridad de puertos** (*port security*) | Limitar qué dispositivos se conectan a cada puerto del switch |
| Políticas de contraseñas fuertes | Mitigar ataques de fuerza bruta |
| Seguridad física (sala cerrada con llave) | Prevenir acceso físico no autorizado |

## Endurecimiento de Servidores y Sistemas Operativos

| Acción de Endurecimiento | Justificación |
|---|---|
| Cambiar credenciales predeterminadas | Igual que en dispositivos de red |
| Deshabilitar servicios innecesarios | Cada servicio activo = potencial punto de entrada |
| Aplicar parches y actualizaciones regularmente | Corregir vulnerabilidades conocidas |
| Principio del **mínimo privilegio** | Limitar impacto de cuentas comprometidas |
| Usar **IDS** (*Intrusion Detection System*, Sistema de Detección de Intrusión) y cortafuegos | Bloquear y alertar actividades maliciosas |
| Usar benchmarks CIS o STIG | Configuración segura estandarizada |
| Controles de acceso: **MFA** (*Multi-Factor Authentication*, Autenticación Multifactor) y **PAM** (*Privileged Access Management*, Gestión de Acceso con Privilegios) | Reducir riesgo de acceso no autorizado |
| Habilitar logging y monitoreo | Detectar problemas de acceso y cambios de configuración |
| Antivirus y antimalware | Detección y cuarentena automática de malware |
| Seguridad física de racks, salas y centros de datos | Prevenir acceso físico no autorizado |

> **👉 Enfoque de Examen SY0-701:**
> CompTIA suele presentar escenarios donde debes elegir qué acción de endurecimiento aplicar primero. El orden típico es: **cambiar credenciales predeterminadas > deshabilitar servicios innecesarios > aplicar parches**. Distractor común: confundir `SSH` con `Telnet` (Telnet es inseguro, texto plano). Recuerda que `SCAP` + `OpenSCAP` → automatización del cumplimiento; `STIG` → gobierno/militar (DISA); `CIS Benchmarks` → sector privado y múltiples plataformas. Vigila preguntas que combinen "herramienta + organización": CIS-CAT Pro es del CIS, SCC es de DISA.

# 3. Consideraciones sobre la Instalación de Redes Inalámbricas

> **Analogía:** Instalar puntos de acceso Wi-Fi es como distribuir altavoces en un estadio: si hay zonas sin cobertura (puntos ciegos), el público buscará alternativas. En redes, esas "alternativas" pueden ser puntos de acceso falsos (*rogue AP*).

## Conceptos Clave de Infraestructura Inalámbrica

- **WAP** (*Wireless Access Point*, Punto de Acceso Inalámbrico): Dispositivo que reenvía tráfico hacia/desde la red cableada.
- **BSSID** (*Basic Service Set Identifier*, Identificador de Conjunto de Servicios Básicos): La dirección MAC del WAP que lo identifica unívocamente.
- **SSID** (*Service Set Identifier*, Identificador de Conjunto de Servicios): El nombre de la red Wi-Fi visible para los usuarios.

## Bandas de Frecuencia

| Banda | Ventaja | Desventaja |
|---|---|---|
| `2.4 GHz` | Mayor alcance, atraviesa paredes | Más interferencia, menos canales no solapados |
| `5 GHz` | Más canales no solapados, mayor velocidad | Menor alcance |
| `6 GHz` | Espacio adicional para canales | Menor compatibilidad con dispositivos legacy |

> **Nota clave:** La banda de `5 GHz` tiene más espacio para configurar canales que **no se superponen**. Los canales enlazados (*bonded channels*) mejoran el ancho de banda pero **aumentan el riesgo de interferencia**.

## Sondeo del Sitio (*Site Survey*) y Mapas de Calor (*Heat Maps*)

**Proceso de sondeo del sitio:**

1. Crear un **mapa arquitectónico** del sitio
2. Marcar elementos que causan interferencia:
   - Paredes sólidas
   - Superficies reflectantes
   - Motores
   - Hornos de microondas
3. Usar laptop/dispositivo con software **analizador de Wi-Fi**
4. Recorrer el área registrando intensidad de señal en puntos regulares
5. Generar un **mapa de calor**

**Interpretación del mapa de calor:**

| Color | Significado |
|---|---|
| 🔵 Azul | Señal muy fuerte |
| 🟢 Verde | Buena señal |
| 🟡 Amarillo | Señal aceptable |
| 🔴 Rojo | Señal baja o inexistente |

**Acciones de optimización tras el análisis:**

- Ajustar la **potencia de transmisión** (reducir el rango de un WAP)
- Cambiar el **canal** en un WAP para evitar solapamiento
- Agregar un nuevo WAP en zonas de cobertura débil
- Mover físicamente un WAP a una nueva ubicación

> **Riesgo de cobertura irregular:** Una red con zonas sin cobertura es vulnerable a ataques de **puntos de acceso falsos** (*rogue AP*) y no autorizados.

> **👉 Enfoque de Examen SY0-701:**
> El examen puede presentar preguntas sobre qué herramienta/técnica se usa para optimizar la colocación de WAPs. La respuesta correcta involucra `site survey` + `heat map`. Distractor común: confundir SSID (nombre de red) con BSSID (dirección MAC del WAP). Recuerda que la banda de `5 GHz` es preferible para evitar interferencias de canal.

# 4. Cifrado Inalámbrico

> **Analogía:** Sin cifrado en Wi-Fi, es como hablar en voz alta en un café abarrotado: cualquiera puede escuchar tu conversación. El cifrado es como hablar en un idioma secreto que solo tú y tu interlocutor conocen.

## Evolución de los Estándares de Seguridad Wi-Fi

```
WEP → WPA (v1) → WPA2 → WPA3
(inseguro) (débil)  (actual)  (recomendado)
```

| Estándar | Cifrado | Protocolo de Integridad | Estado |
|---|---|---|---|
| **WEP** (*Wired Equivalent Privacy*, Privacidad Equivalente por Cable) | RC4 | Ninguno robusto | ❌ Obsoleto, inseguro |
| **WPA v1** (*Wi-Fi Protected Access*, Acceso Protegido Wi-Fi) | RC4 | **TKIP** (*Temporal Key Integrity Protocol*, Protocolo de Integridad de Clave Temporal) | ❌ No recomendado |
| **WPA2** | **AES** (*Advanced Encryption Standard*, Estándar de Cifrado Avanzado) | **CCMP** (*Counter Mode with Cipher Block Chaining Message Authentication Code Protocol*) | ⚠️ Aún en uso |
| **WPA3** | AES + **GCM** (*Galois Counter Mode*, Modo de Operación Galois Counter) | SAE, GCM | ✅ Recomendado |

## Estándares 802.11 y Generaciones Wi-Fi

| Estándar | Nombre Comercial |
|---|---|
| `802.11n` | Wi-Fi 4 |
| `802.11ac` | Wi-Fi 5 |
| `802.11ax` | Wi-Fi 6 |

## WPS (*Wi-Fi Protected Setup*, Configuración Protegida Wi-Fi)

**Propósito:** Simplificar la configuración de dispositivos en redes Wi-Fi para usuarios domésticos.

**Funcionamiento:**
1. Se presiona el botón en el WAP y en el adaptador simultáneamente
2. Los dispositivos se asocian mediante un **PIN**
3. Se genera automáticamente un SSID y PSK (*Pre-Shared Key*, Clave Precompartida) aleatorios

**⚠️ VULNERABILIDAD CRÍTICA de WPS:**
- El PIN tiene 8 caracteres, pero:
  - 1 dígito es suma de comprobación (*checksum*)
  - El resto se verifica como **dos PINs separados de 4 y 3 caracteres**
  - → Susceptible a **ataque de fuerza bruta** en pocas horas
- En algunos modelos, deshabilitar WPS por la interfaz NO lo deshabilita realmente

**Mitigación:**
- Aumentar el periodo de bloqueo tras intentos fallidos (riesgo de **DoS**, *Denial of Service*, Denegación de Servicio)
- Verificar implementación del fabricante
- Mantener firmware actualizado

## Easy Connect / DPP (*Device Provisioning Protocol*, Protocolo de Aprovisionamiento de Dispositivos)

- **Propósito:** Reemplazar WPS como método de configuración segura (anunciado con WPA3)
- **Mecanismo:** Usa **códigos QR** o etiquetas **NFC** (*Near Field Communication*, Comunicación de Campo Cercano) para comunicar claves públicas
- **Proceso:**
  1. Smartphone se registra como aplicación configuradora de Easy Connect
  2. Se escanea el código QR del WAP
  3. Cada dispositivo cliente se asocia escaneando su QR o NFC
- **Ventaja extra:** Ideal para dispositivos **IoT** (*Internet of Things*, Internet de las Cosas) sin interfaz local (*headless*)

## Características Principales de WPA3

| Característica | Descripción |
|---|---|
| **SAE** (*Simultaneous Authentication of Equals*, Autenticación Simultánea de Iguales) | Reemplaza PSK de WPA2; protege contra captura y cracking de la contraseña |
| **Enhanced Open** | Cifra el tráfico incluso en redes abiertas (sin contraseña) |
| **AES-GCM** | Reemplaza AES-CCM; mayor rendimiento criptográfico |
| **Wi-Fi Easy Connect** | Conexión segura vía código QR |

> **⚠️ Modo de Transición WPA3:** Cuando un AP se configura para soportar WPA2 heredado, se han identificado fallas que permiten **ataques de degradación** (*downgrade attacks*) hacia WPA2.

> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: "¿Cuál protocolo reemplaza PSK en WPA3?" → SAE (Dragonfly handshake). Distractor: confundir TKIP (WPA v1) con CCMP (WPA2). El examen también puede preguntar sobre WPS: recuerda que su vulnerabilidad es el PIN dividido en dos partes verificables por separado. Otro distractor: asumir que Enhanced Open es lo mismo que una red abierta sin cifrado (Enhanced Open SÍ cifra, aunque no tenga contraseña).

# 5. Métodos de Autenticación Wi-Fi

## Los Tres Modos de Autenticación Wi-Fi

```
┌─────────────────────────────────────────────┐
│              Autenticación Wi-Fi            │
├─────────────┬───────────────┬───────────────┤
│   Personal  │    Abierta    │  Empresarial  │
│ (PSK / SAE) │ (Enhanced     │ (802.1x +     │
│             │  Open)        │  RADIUS)      │
└─────────────┴───────────────┴───────────────┘
```

## Autenticación Personal WPA2 — PSK

- **PSK** (*Pre-Shared Key*, Clave Precompartida): Una frase de contraseña compartida por todos los usuarios del grupo.
- **Proceso:**
  1. Admin configura una frase de contraseña de 8–63 caracteres ASCII
  2. Se convierte en un **HMAC** de 256 bits mediante el algoritmo **PBKDF2** (*Password-Based Key Derivation Function 2*)
  3. Este HMAC se llama **PMK** (*Pairwise Master Key*, Clave Maestra por Pares)
  4. La PMK se usa en el **protocolo de enlace de 4 vías** (*4-Way Handshake*) para derivar claves de sesión
- **Vulnerabilidad:** Susceptible a ataques de diccionario y fuerza bruta
- **Mitigación mínima:** Frase de contraseña de al menos **14 caracteres**

## Autenticación Personal WPA3 — SAE (*Dragonfly*)

- **PAKE** (*Password-Authenticated Key Exchange*, Intercambio de Claves Autenticado por Contraseña): esquema mejorado para acordar claves de sesión.
- **SAE** usa el protocolo de enlace **Dragonfly**:
  - Acuerdo de claves **Diffie-Hellman** sobre curvas elípticas
  - Combinado con un hash derivado de la contraseña + dirección MAC
  - Implementa **claves de sesión efímeras** → proporciona **Forward Secrecy** (secreto de reenvío)
- **Ventaja:** Un atacante que capture el handshake **NO puede** recuperar la contraseña por fuerza bruta offline

> **Nota de interfaz:** Las interfaces de AP pueden mostrar estas equivalencias:
> - `WPA2-Personal` = `WPA2-PSK`
> - `WPA3-Personal` = `WPA3-SAE`

## Autenticación Empresarial — 802.1x + EAP + RADIUS

**Componentes del modo empresarial:**

| Componente | Función |
|---|---|
| **802.1x** | Marco de control de acceso basado en puertos |
| **EAP** (*Extensible Authentication Protocol*, Protocolo de Autenticación Extensible) | Define el método de autenticación específico |
| **RADIUS** (*Remote Authentication Dial-In User Service*, Servicio de Autenticación Remota de Usuario por Acceso Telefónico) | Servidor AAA que verifica credenciales |
| **NAS** (*Network Access Server*, Servidor de Acceso a la Red) | El WAP/switch/VPN gateway que actúa de cliente RADIUS |

**Tipos de EAP:**

| Tipo EAP | Autenticación | Certificados requeridos |
|---|---|---|
| **EAP-TLS** | Mutua (cliente y servidor) | Ambos lados |
| **EAP-TTLS** | Servidor + túnel para credenciales usuario | Solo servidor |
| **PEAP** (*Protected EAP*) | Servidor + túnel para credenciales usuario | Solo servidor |

**Ventaja del modo empresarial:**
- Cada usuario tiene credenciales **únicas** (no compartidas)
- Permite auditoría granular del uso de red
- Gestión **dinámica** de claves de cifrado (cambian automáticamente por sesión)

> **Analogía:** En modo personal, toda la oficina tiene la misma llave maestra. En modo empresarial, cada empleado tiene su propia llave personalizada, y hay un guardia de seguridad central (RADIUS) que verifica quién es cada uno.

## Flujo del Protocolo RADIUS

Solicitante                NAS (WAP)              Servidor AAA (RADIUS)
│                         │                           │
│──── Solicita conexión ─►│                           │
│◄─── Pide credenciales ──│                           │
│                         │                           │
│──── Envía datos EAPoL──►│                           │
│   (EAP over LAN)        │                           │
│                         │──── Access-Request ──────►│
│                         │    (UDP puerto 1812)      │
│                         │                           │
│                         │◄─── Challenge ────────────│
│◄─── Challenge ──────────│                           │
│──── Respuesta ─────────►│──── Access-Request ──────►│
│                         │                           │
│                         │◄─── Access-Accept/Reject ─│
│◄─── Acceso concedido ───│                           │

**Puertos RADIUS:**
- Autenticación: `UDP/1812`
- Contabilidad (*Accounting*): `UDP/1813`

> **Protocolos legacy en RADIUS:** RADIUS soporta `PAP` y `CHAP`, pero son inseguros. La mayoría de implementaciones actuales usan `EAP`. Si se requiere EAP, el NAS solo permite tráfico **EAPoL** (*EAP over LAN*) hasta que la autenticación se complete.

> **👉 Enfoque de Examen SY0-701:**
> Preguntas frecuentes: puertos de RADIUS (`1812` auth, `1813` accounting), diferencia entre EAP-TLS (certificado en ambos lados) vs PEAP/EAP-TTLS (solo servidor). Distractor: creer que el "cliente RADIUS" es la PC del usuario → el cliente RADIUS es el NAS (WAP, switch, VPN). También vigila preguntas sobre el 4-Way Handshake: se usa tanto en WPA2-PSK como en WPA3-SAE (tras establecer la PMK).

# 6. Control de Acceso a la Red (NAC)

**NAC** (*Network Access Control*, Control de Acceso a la Red): Solución de seguridad que verifica el cumplimiento de políticas **antes** y **durante** el acceso a la red.

> **Analogía:** NAC es como el control de seguridad del aeropuerto combinado con el médico de vuelo: no solo comprueba quién eres (autenticación), sino que verifica que tu "salud de dispositivo" (antivirus actualizado, SO parcheado) cumple los requisitos antes de dejarte pasar.

## ¿Qué evalúa NAC?

- Versión del sistema operativo
- Nivel de parches aplicados
- Estado del antivirus
- Presencia de software de seguridad específico

## Capacidades de NAC

| Capacidad | Descripción |
|---|---|
| **Verificación de postura** (*posture assessment*) | Comprueba el estado de seguridad del dispositivo |
| **Asignación dinámica de VLAN** | Asigna VLAN según identidad, tipo de dispositivo, ubicación o postura |
| **VLAN de cuarentena** | Aísla dispositivos no conformes del resto de la red |
| **Remediación automática** | El agente corrige problemas (actualiza SW, deshabilita configuraciones) |
| **BYOD** (*Bring Your Own Device*, Traiga su Propio Dispositivo) y gestión de IoT | Controla dispositivos personales y de IoT en la red corporativa |

## Ejemplo de Asignación Dinámica de VLAN

```
Usuario visitante (proveedor)  → VLAN solo con acceso a Internet
Usuario corporativo            → VLAN con acceso a recursos internos
Dispositivo no conforme        → VLAN de cuarentena (aislada)
```

## Configuraciones: Con Agente vs. Sin Agente

| Característica | Con Agente (*Agent-based*) | Sin Agente (*Agentless*) |
|---|---|---|
| **Instalación** | Software en el dispositivo | Sin instalación previa |
| **Información** | Detallada sobre el estado del dispositivo | Limitada (fingerprinting, escaneo de red) |
| **Remediación** | Automática posible | Manual o limitada |
| **Compatibilidad** | Dispositivos gestionados | Cualquier dispositivo (invitados, IoT) |
| **Técnicas** | Comunicación directa con plataforma NAC | Fingerprinting DHCP, escaneo de puertos, agentes de red |

## Tipos de Agente

- **Agente persistente:** Se instala como aplicación permanente en el cliente
- **Agente no persistente (soluble):** Se carga en memoria solo durante la evaluación de postura; no se instala

## Herramienta: PacketFence (NAC de código abierto)

- Soporta escáneres de vulnerabilidades: **Nessus**, **OpenVAS**
- Consultas mediante **WMI** (*Windows Management Instrumentation*, Instrumental de Administración de Windows)
- Analizadores de registros (*Syslog parsers*)
- Permite definir **violaciones de política** con acciones automáticas (cuarentena, notificación)

> **👉 Enfoque de Examen SY0-701:**
> Preguntas sobre NAC típicamente presentan un escenario BYOD o IoT y preguntan qué solución aplica. Recuerda: NAC + VLAN dinámica = segmentación automática basada en identidad/postura. Distractor: confundir agente persistente con no persistente (el no persistente = "soluble" = solo en memoria durante evaluación). El examen puede preguntar qué técnica usa NAC sin agente para identificar dispositivos → fingerprinting DHCP o escaneo de red.

# 7. Mejora de la Capacidad de Seguridad de la Red

Esta sección cubre los controles técnicos de red que conforman una **defensa en profundidad** (*defense in depth*):

```
Internet → [Firewall/ACL] → [IDS/IPS] → [Filtro Web] → Red Interna
```

# 8. Listas de Control de Acceso (ACL)

**ACL** (*Access Control List*, Lista de Control de Acceso): Lista de permisos en dispositivos de red que controla el tráfico a nivel de interfaz.

> **Analogía:** Una ACL es como la lista de invitados de una fiesta exclusiva. El portero (firewall) revisa cada persona (paquete de red) contra la lista: si tu nombre (IP/puerto/protocolo) está, pasas; si no, fuera.

## ACL vs. Regla de Cortafuegos

| Aspecto | ACL (Router/Switch) | Regla de Cortafuegos |
|---|---|---|
| **Nivel** | Red | Red y aplicación |
| **Uso principal** | Control de tráfico en interfaces | Protección del perímetro |
| **Factores de filtrado** | IP origen/destino, puerto, protocolo | IP, puerto, protocolo, patrones de aplicación |

## Principios de las ACL

- Las reglas se procesan **de arriba a abajo**
- Si el tráfico coincide con una regla, se aplica y se detiene la verificación
- Las reglas **más específicas** se colocan arriba
- Regla final: **denegación implícita** (*implicit deny*) — bloquea todo lo no permitido
- Si no hay denegación implícita, se puede añadir una **denegación explícita** (*explicit deny*) al final

## Tuplas de las Reglas de Firewall

Cada regla es una combinación (tupla) de:
- Protocolo (`TCP`, `UDP`, `ICMP`, etc.)
- IP/Rango de origen
- Puerto de origen
- IP/Rango de destino
- Puerto de destino
- Acción (ALLOW / DENY)

## Ejemplos Prácticos de Reglas ACL

- Permitir tráfico web entrante al servidor web:
ALLOW TCP any → 192.168.1.10:80    (HTTP)
ALLOW TCP any → 192.168.1.10:443   (HTTPS)
- Bloquear SMTP saliente (evitar spam desde máquinas comprometidas):
DENY TCP any:25 any
- Bloquear IPs privadas entrantes (anti-spoofing):
DENY any 10.0.0.0/8 → any
DENY any 172.16.0.0/12 → any
DENY any 192.168.0.0/16 → any

## Principios de Buenas Prácticas para ACL

- Bloquear solicitudes entrantes de **IPs internas/privadas** (son falsificadas — *spoofed*)
- Bloquear protocolos de red local entrantes: `ICMP`, `DHCP`, protocolos de enrutamiento
- Usar **pruebas de penetración** para confirmar que la configuración es segura
- **Documentar** todos los cambios en las ACL
- Registrar y monitorear intentos de acceso

## Subred Filtrada (*Filtered Subnet* / DMZ)

**También conocida como:** Red perimetral, **DMZ** (*Demilitarized Zone*, Zona Desmilitarizada)

**Propósito:** Crear una capa adicional de protección entre la red interna e Internet.

**Servicios típicos alojados en la DMZ:**
- Servidores web
- Servidores de correo electrónico
- DNS (*Domain Name System*)
- FTP (*File Transfer Protocol*)

**Arquitectura de dos cortafuegos:**

```
Internet
│
[Firewall 1] ← Permite tráfico a servicios en la DMZ
│
[DMZ: Web Server, Mail Server, DNS]
│
[Firewall 2] ← Bloquea casi todo el tráfico DMZ → Red Interna
│
Red Interna Corporativa
```

> La subred filtrada es un ejemplo fundamental de **segmentación de red** como control de seguridad.

> **Analogía:** La subred filtrada es como la sala de espera de un hospital. Los visitantes externos (Internet) acceden a ella, pero no pueden entrar directamente al quirófano (red interna). Es una zona neutral.

> **👉 Enfoque de Examen SY0-701:**
> Pregunta clásica: describe un escenario con servidores públicos y pregunta cómo proteger la red interna → respuesta: subred filtrada/DMZ con dos firewalls. Distractor: confundir "implicit deny" con "explicit deny" (la implícita es automática al final de la ACL, la explícita se añade manualmente). Recuerda el procesamiento top-down de las ACL y que las reglas más específicas van primero.

# 9. Sistemas de Detección y Prevención de Intrusión (IDS/IPS)

> **🧠 Analogía:**
> - **IDS** = Alarma de incendio: detecta el fuego y alerta, pero no apaga nada.
> - **IPS** = Rociadores automáticos: detecta el fuego y actúa automáticamente para extinguirlo.

| Característica | **IDS** (*Intrusion Detection System*) | **IPS** (*Intrusion Prevention System*) |
|---|---|---|
| **Postura** | Pasiva | Proactiva |
| **Acción** | Detecta y alerta | Detecta, alerta y **bloquea** |
| **Riesgo** | Falsos negativos (no alerta amenazas reales) | Falsos positivos (bloquea tráfico legítimo) |

## Tipos: Basados en Host vs. Basados en Red

| Tipo | Acrónimo | Ámbito | Efectivo para |
|---|---|---|---|
| **Host-based IDS/IPS** | HIDS / HIPS | Sistema/servidor individual | Amenazas internas, cambios en archivos del sistema, inicios de sesión locales |
| **Network-based IDS/IPS** | NIDS / NIPS | Tráfico de red | Ataques DDoS (*Distributed Denial of Service*), escaneos de red |

> **Limitación importante:** Ninguno sustituye al otro completamente. HIDS/HIPS no ve anomalías de red; NIDS/NIPS no tiene visibilidad detallada del host.

## Herramientas Principales de IDS/IPS

| Herramienta | Tipo | Características Clave |
|---|---|---|
| **Snort** | IDS/IPS (código abierto) | Lenguaje basado en reglas; combina firmas, protocolos y anomalías; gran comunidad |
| **Suricata** | IDS/IPS/NSM (código abierto) | Alto rendimiento, multihilo; compatible con reglas de Snort; mayor escalabilidad |
| **Security Onion** | Plataforma integrada (Linux) | Incluye Snort + Suricata + otras herramientas; visión holística de la red |
| **OSSEC** | HIDS (código abierto) | Análisis de logs, verificación de integridad, monitoreo del registro Windows, detección de rootkits |

> **NSM** = *Network Security Monitoring* (Monitoreo de Seguridad de Red)

> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: escenario donde el tráfico legítimo está siendo bloqueado → indica falso positivo en **IPS** (no en IDS, que es pasivo). Distractor: creer que Snort solo es IDS — puede funcionar como IDS o IPS. OSSEC es específicamente **HIDS**. Security Onion es una **plataforma** que integra múltiples herramientas. Recuerda: IDS = pasivo = alertas; IPS = activo = bloquea.

# 10. Métodos de Detección de IDS e IPS

## Motor de Análisis

El **motor de análisis** escanea e interpreta el tráfico capturado por el sensor. Determina la clasificación del evento:

```
Ignorar → Solo registrar → Alertar → Bloquear (IPS)
```

## Método 1: Detección Basada en Firmas (*Signature-based*)

- **Funcionamiento:** El motor tiene una base de datos de **patrones de ataque conocidos** (firmas/reglas)
- Si el tráfico coincide con un patrón → genera incidente
- **Herramienta ejemplo:** Snort (usa archivos de reglas)
- **Limitación:** No detecta **ataques de día cero** (*zero-day*) ni amenazas nuevas sin firma

**Mantenimiento de firmas:**
- Deben actualizarse **periódicamente** (feeds/plugins)
- Software comercial requiere suscripción
- Actualizaciones vía `HTTPS` (repositorios válidos y seguros)

> **Analogía:** Como el sistema inmune que reconoce virus que ya conoce (vacunas = base de datos de firmas).

## Método 2: Detección Basada en Comportamiento y Anomalías

**Detección basada en comportamiento:**
- El motor aprende el tráfico **normal de referencia** (*baseline*)
- Cualquier desviación fuera de la tolerancia definida → genera incidente
- Puede detectar: ataques de día cero, amenazas internas, actividades maliciosas sin firma

**NBAD** (*Network Behavior Anomaly Detection*, Detección de Anomalías de Comportamiento en la Red):
- Usa **heurísticas** (aprende de la experiencia)
- Genera un **modelo estadístico** del tráfico normal
- Puede desarrollar perfiles para distintos momentos del día
- **Genera falsos positivos y negativos** hasta que el modelo estadístico madura

**Conceptos de Machine Learning en detección de comportamiento (Gartner):**

| Categoría | Descripción |
|---|---|
| **UEBA** (*User and Entity Behavior Analytics*, Analítica del Comportamiento de Usuarios y Entidades) | Analiza múltiples fuentes (IDS, logs) para identificar anomalías; se integra con **SIEM** (*Security Information and Event Management*, Gestión de Información y Eventos de Seguridad) |
| **NTA** (*Network Traffic Analysis*, Análisis de Tráfico de Red) | Aplica análisis solo a flujos de red (similar a IDS + NBAD) |

**Detección basada en anomalías de protocolo:**
- Verifica que los encabezados y el intercambio de paquetes cumplan con los estándares **RFC**
- Genera alerta si hay desviación del cumplimiento RFC

**Terminología clave:**

| Término | Definición |
|---|---|
| **Falso positivo** | Comportamiento legítimo genera una alerta (falsamente detectado como amenaza) |
| **Falso negativo** | Actividad maliciosa no genera alerta (amenaza no detectada) |

> **Analogía:** Como un banco que detecta transacciones "inusuales" para tu perfil. No sabe exactamente qué tipo de fraude es, pero sabe que no es tu comportamiento normal.

## Método 3: Análisis de Tendencias (*Trend Analysis*)

- **Propósito:** Comprender el entorno de seguridad a lo largo del tiempo
- **Beneficios:**
  - Identificar patrones de amenazas **continuas o crecientes**
  - Detectar si una vulnerabilidad está siendo explotada activamente
  - **Afinar** reglas IDS/IPS (eliminar falsos positivos recurrentes)
  - Informar **estrategias de seguridad operativa**
  - Identificar sistemas frecuentemente atacados
  - Justificar inversiones en herramientas y capacitación

> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: "¿Qué tipo de detección identifica ataques de día cero?" → Basada en comportamiento/anomalías (NO en firmas). Distractor: creer que la detección basada en anomalías siempre produce menos falsos positivos que la de firmas — en realidad, puede generar más hasta que el modelo madura. Recuerda: UEBA → múltiples fuentes + integración SIEM; NTA → solo flujos de red.

# 11. Filtrado Web

> **Analogía:** El filtrado web es como el sistema de control parental de una televisión corporativa: bloquea canales (sitios web) inapropiados o peligrosos, y registra qué canales intentaron ver los empleados.

## Función Principal del Filtrado Web

- **Impedir** acceso a sitios maliciosos o inapropiados
- Analizar tráfico web en **tiempo real**
- Criterios de restricción: URL, dirección IP, categoría de contenido, palabras clave

## Beneficios del Filtrado Web

- **Prevención de malware:** Bloquea ransomware, phishing originado en sitios web maliciosos
- **Productividad:** Limita acceso a contenido no relacionado con el trabajo
- **DLP** (*Data Loss Prevention*, Prevención de Pérdida de Datos): Bloquea transferencia de datos a sitios de fuga
- **Cumplimiento legal:** Evita acceso a contenido inapropiado

## Tipos de Filtrado Web

### A) Filtrado Basado en Agentes (*Agent-based*)

- **Instalación:** Agente de software en PCs, laptops y dispositivos móviles
- **Funcionamiento:**
  - El agente aplica políticas localmente en el dispositivo
  - Se comunica con servidor de gestión centralizado para obtener reglas
  - Usa **plataformas en la nube** para garantizar conectividad independientemente de la red
- **Ventaja clave:** Las políticas aplican **fuera de la red corporativa** (teletrabajo, viajes)
- **Capacidades adicionales:**
  - Filtrado de tráfico `HTTPS`
  - Diferentes reglas por aplicación
  - Reportes y análisis detallados

### B) Filtrado Web Centralizado — Servidor Proxy

- **Funcionamiento:** Servidor proxy actúa como intermediario entre usuarios e Internet
- **Mecanismo:** Analiza solicitudes web y permite/deniega acceso según políticas

**Técnicas del Proxy Centralizado:**

| Técnica | Descripción |
|---|---|
| **Análisis de URL** | Bloquea URLs específicas conocidas como maliciosas o inapropiadas |
| **Categorización de contenido** | Clasifica sitios en categorías (redes sociales, juegos, adultos, etc.) y aplica reglas por categoría |
| **Reglas de bloqueo** | Basadas en URL, dominio, IP, categoría o palabras clave (ej. bloquear descargas de `.exe`) |
| **Filtrado basado en reputación** | Usa bases de datos que califican sitios según comportamiento e historial (bloqueo de sitios de malware/phishing/spam) |

**Beneficios adicionales del proxy:**
- Anonimato de solicitudes
- Caché de contenido web (mejor rendimiento)
- Registro y reporte de actividad web

## Problemas del Filtrado Web

| Problema | Descripción |
|---|---|
| **Bloqueo excesivo** (*Overblocking*) | Filtro demasiado restrictivo → bloquea sitios legítimos → impacta productividad |
| **Bloqueo insuficiente** (*Underblocking*) | Filtro permisivo → permite acceso a sitios dañinos |
| **Tráfico HTTPS cifrado** | Sin configuración adecuada, los filtros no pueden inspeccionar tráfico cifrado (mayoría del tráfico web moderno) |
| **Privacidad de empleados** | Descifrar e inspeccionar tráfico HTTPS genera preocupaciones de privacidad |
| **Cumplimiento legal** | El registro y monitoreo debe gestionarse respetando leyes y regulaciones aplicables |

> **👉 Enfoque de Examen SY0-701:**
> Pregunta típica: escenario donde empleados en teletrabajo no están sujetos al filtrado web → solución: filtrado basado en agentes (aplica fuera de la red corporativa). Distractor: creer que el proxy centralizado es suficiente para usuarios remotos (no lo es sin VPN o agente). Otro distractor: confundir DLP con filtrado web — el filtrado web es una *herramienta* que contribuye a DLP, pero DLP es el concepto más amplio. Recuerda que el filtrado basado en reputación usa bases de datos continuamente actualizadas (no reglas estáticas).

#  12. Glosario

| Acrónimo | Significado en Inglés | Traducción |
|---|---|---|
| **ACL** | Access Control List | Lista de Control de Acceso |
| **AES** | Advanced Encryption Standard | Estándar de Cifrado Avanzado |
| **BSSID** | Basic Service Set Identifier | Identificador de Conjunto de Servicios Básicos |
| **BYOD** | Bring Your Own Device | Traiga su Propio Dispositivo |
| **CCMP** | Counter Mode with Cipher Block Chaining Message Authentication Code Protocol | — |
| **CIS** | Center for Internet Security | Centro para la Seguridad de Internet |
| **DDoS** | Distributed Denial of Service | Denegación de Servicio Distribuida |
| **DISA** | Defense Information Systems Agency | Agencia de Sistemas de Información de Defensa |
| **DLP** | Data Loss Prevention | Prevención de Pérdida de Datos |
| **DMZ** | Demilitarized Zone | Zona Desmilitarizada |
| **DPP** | Device Provisioning Protocol | Protocolo de Aprovisionamiento de Dispositivos |
| **EAP** | Extensible Authentication Protocol | Protocolo de Autenticación Extensible |
| **GCM** | Galois Counter Mode | Modo de Operación Galois Counter |
| **HIDS/HIPS** | Host-based IDS/IPS | IDS/IPS Basado en Host |
| **HMAC** | Hash-based Message Authentication Code | — |
| **IDS** | Intrusion Detection System | Sistema de Detección de Intrusión |
| **IoT** | Internet of Things | Internet de las Cosas |
| **IPS** | Intrusion Prevention System | Sistema de Prevención de Intrusión |
| **MFA** | Multi-Factor Authentication | Autenticación Multifactor |
| **NAC** | Network Access Control | Control de Acceso a la Red |
| **NAS** | Network Access Server | Servidor de Acceso a la Red |
| **NBAD** | Network Behavior Anomaly Detection | Detección de Anomalías de Comportamiento en la Red |
| **NFC** | Near Field Communication | Comunicación de Campo Cercano |
| **NIDS/NIPS** | Network-based IDS/IPS | IDS/IPS Basado en Red |
| **NSM** | Network Security Monitoring | Monitoreo de Seguridad de Red |
| **NTA** | Network Traffic Analysis | Análisis de Tráfico de Red |
| **PAM** | Privileged Access Management | Gestión de Acceso con Privilegios |
| **PAKE** | Password-Authenticated Key Exchange | Intercambio de Claves Autenticado por Contraseña |
| **PBKDF2** | Password-Based Key Derivation Function 2 | — |
| **PMK** | Pairwise Master Key | Clave Maestra por Pares |
| **PSK** | Pre-Shared Key | Clave Precompartida |
| **RADIUS** | Remote Authentication Dial-In User Service | Servicio de Autenticación Remota de Usuario por Acceso Telefónico |
| **SAE** | Simultaneous Authentication of Equals | Autenticación Simultánea de Iguales |
| **SCAP** | Security Content Automation Protocol | Protocolo de Automatización de Contenido de Seguridad |
| **SIEM** | Security Information and Event Management | Gestión de Información y Eventos de Seguridad |
| **SSID** | Service Set Identifier | Identificador de Conjunto de Servicios |
| **STIG** | Security Technical Implementation Guide | Guías de Implementación de Seguridad Técnica |
| **TKIP** | Temporal Key Integrity Protocol | Protocolo de Integridad de Clave Temporal |
| **UEBA** | User and Entity Behavior Analytics | Analítica del Comportamiento de Usuarios y Entidades |
| **VLAN** | Virtual Local Area Network | Red de Área Local Virtual |
| **WAP** | Wireless Access Point | Punto de Acceso Inalámbrico |
| **WEP** | Wired Equivalent Privacy | Privacidad Equivalente por Cable |
| **WMI** | Windows Management Instrumentation | Instrumental de Administración de Windows |
| **WPA** | Wi-Fi Protected Access | Acceso Protegido Wi-Fi |
| **WPS** | Wi-Fi Protected Setup | Configuración Protegida Wi-Fi |