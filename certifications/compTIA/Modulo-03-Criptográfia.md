> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Algoritmos Criptográficos](#1-algoritmos-criptográficos)
  - [Conceptos Criptográficos](#conceptos-criptográficos)
    - [Terminología fundamental](#terminología-fundamental)
    - [Personajes estándar en criptografía](#personajes-estándar-en-criptografía)
    - [Tres tipos principales de algoritmos criptográficos](#tres-tipos-principales-de-algoritmos-criptográficos)
  - [Cifrado Simétrico (Symmetric Encryption)](#cifrado-simétrico-symmetric-encryption)
    - [Algoritmos base: Sustitución y Transposición](#algoritmos-base-sustitución-y-transposición)
    - [Cómo funciona el cifrado simétrico](#cómo-funciona-el-cifrado-simétrico)
    - [Ventajas y limitaciones](#ventajas-y-limitaciones)
  - [Longitud de la Clave](#longitud-de-la-clave)
    - [Conceptos clave](#conceptos-clave)
    - [Fórmula del espacio de claves](#fórmula-del-espacio-de-claves)
    - [Tabla comparativa de longitudes](#tabla-comparativa-de-longitudes)
  - [Cifrado Asimétrico (Asymmetric Encryption)](#cifrado-asimétrico-asymmetric-encryption)
    - [Flujo de cifrado asimétrico](#flujo-de-cifrado-asimétrico)
    - [Comparativa simétrico vs. asimétrico](#comparativa-simétrico-vs-asimétrico)
    - [Algoritmos asimétricos principales](#algoritmos-asimétricos-principales)
  - [Hashing](#hashing)
    - [Propiedades fundamentales del hash](#propiedades-fundamentales-del-hash)
    - [Uso 1: Verificación de contraseñas](#uso-1-verificación-de-contraseñas)
    - [Uso 2: Verificación de integridad de archivos](#uso-2-verificación-de-integridad-de-archivos)
    - [Algoritmos de hashing principales](#algoritmos-de-hashing-principales)
  - [Firmas Digitales](#firmas-digitales)
    - [Primitivo criptográfico vs. Conjunto de cifrado](#primitivo-criptográfico-vs-conjunto-de-cifrado)
    - [Cómo funciona una firma digital](#cómo-funciona-una-firma-digital)
    - [Propiedades garantizadas por la firma digital](#propiedades-garantizadas-por-la-firma-digital)
    - [Estándares de firma digital](#estándares-de-firma-digital)
- [2. Infraestructura de Clave Pública (PKI)](#2-infraestructura-de-clave-pública-pki)
  - [Autoridades Certificadoras](#autoridades-certificadoras)
    - [El problema que resuelve la PKI](#el-problema-que-resuelve-la-pki)
    - [CA privada vs. CA de terceros](#ca-privada-vs-ca-de-terceros)
    - [Flujo PKI completo](#flujo-pki-completo)
    - [Funciones de una CA pública de terceros](#funciones-de-una-ca-pública-de-terceros)
  - [Certificados Digitales](#certificados-digitales)
    - [Estándares de certificados](#estándares-de-certificados)
  - [Raíz de Confianza](#raíz-de-confianza)
    - [Certificado raíz](#certificado-raíz)
    - [Modelo 1: CA Única (Single CA)](#modelo-1-ca-única-single-ca)
    - [Modelo 2: CA Jerárquica (Terceros)](#modelo-2-ca-jerárquica-terceros)
    - [Modelo 3: Certificados Autofirmados](#modelo-3-certificados-autofirmados)
  - [Solicitudes de Firma de Certificados (CSR)](#solicitudes-de-firma-de-certificados-csr)
    - [Proceso de registro y emisión](#proceso-de-registro-y-emisión)
  - [Atributos del Nombre del Sujeto](#atributos-del-nombre-del-sujeto)
    - [Campo CN (Common Name / Nombre Común)](#campo-cn-common-name--nombre-común)
    - [Campo SAN (Subject Alternative Name / Nombre Alternativo del Sujeto)](#campo-san-subject-alternative-name--nombre-alternativo-del-sujeto)
    - [Tipos de SAN / Certificados especiales](#tipos-de-san--certificados-especiales)
    - [Campos del Nombre Distinguido (DN)](#campos-del-nombre-distinguido-dn)
  - [Revocación de Certificados](#revocación-de-certificados)
    - [Estados de un certificado](#estados-de-un-certificado)
    - [Razones de revocación (codificadas)](#razones-de-revocación-codificadas)
    - [CRL (Certificate Revocation List / Lista de Revocación de Certificados)](#crl-certificate-revocation-list--lista-de-revocación-de-certificados)
    - [OCSP (Online Certificate Status Protocol / Protocolo de Estado de Certificados en Línea)](#ocsp-online-certificate-status-protocol--protocolo-de-estado-de-certificados-en-línea)
  - [Gestión de Claves](#gestión-de-claves)
    - [Ciclo de vida de una clave](#ciclo-de-vida-de-una-clave)
    - [Modelos de gestión de claves](#modelos-de-gestión-de-claves)
    - [KMIP (Key Management Interoperability Protocol / Protocolo de Interoperabilidad de Gestión de Claves)](#kmip-key-management-interoperability-protocol--protocolo-de-interoperabilidad-de-gestión-de-claves)
  - [Criptoprocesadores y Enclaves Seguros](#criptoprocesadores-y-enclaves-seguros)
    - [Problemas del almacenamiento de claves en sistema de archivos ordinario](#problemas-del-almacenamiento-de-claves-en-sistema-de-archivos-ordinario)
    - [TPM (Trusted Platform Module / Módulo de Plataforma Confiable)](#tpm-trusted-platform-module--módulo-de-plataforma-confiable)
    - [HSM (Hardware Security Module / Módulo de Seguridad de Hardware)](#hsm-hardware-security-module--módulo-de-seguridad-de-hardware)
    - [Enclave Seguro (Secure Enclave / TEE)](#enclave-seguro-secure-enclave--tee)
    - [Resumen comparativo TPM vs. HSM](#resumen-comparativo-tpm-vs-hsm)
  - [Custodia de Claves](#custodia-de-claves)
    - [El problema de las copias de seguridad de claves](#el-problema-de-las-copias-de-seguridad-de-claves)
    - [Soluciones: Custodia y Control M de N](#soluciones-custodia-y-control-m-de-n)
    - [División de claves y KRA](#división-de-claves-y-kra)
- [3. Soluciones Criptográficas](#3-soluciones-criptográficas)
  - [Cifrado que Respalda la Confidencialidad](#cifrado-que-respalda-la-confidencialidad)
    - [Los tres estados de los datos](#los-tres-estados-de-los-datos)
    - [Cifrado masivo (Bulk Encryption)](#cifrado-masivo-bulk-encryption)
    - [Esquema híbrido KEK / DEK](#esquema-híbrido-kek--dek)
  - [Cifrado de Archivos y Discos](#cifrado-de-archivos-y-discos)
    - [FDE (Full Disk Encryption / Cifrado de Disco Completo)](#fde-full-disk-encryption--cifrado-de-disco-completo)
    - [Cifrado de particiones](#cifrado-de-particiones)
    - [Cifrado de volúmenes](#cifrado-de-volúmenes)
    - [Cifrado de archivos individuales](#cifrado-de-archivos-individuales)
    - [Integración con TPM/HSM](#integración-con-tpmhsm)
  - [Cifrado de Base de Datos](#cifrado-de-base-de-datos)
    - [Estructura de una base de datos](#estructura-de-una-base-de-datos)
    - [Nivel 1: Cifrado a Nivel de Base de Datos — TDE](#nivel-1-cifrado-a-nivel-de-base-de-datos--tde)
    - [Nivel 2: Cifrado a Nivel de Columna/Celda](#nivel-2-cifrado-a-nivel-de-columnacelda)
    - [Nivel 3: Cifrado a Nivel de Registro/Fila](#nivel-3-cifrado-a-nivel-de-registrofila)
    - [Comparativa niveles de cifrado en BD](#comparativa-niveles-de-cifrado-en-bd)
  - [Cifrado de Transporte e Intercambio de Claves](#cifrado-de-transporte-e-intercambio-de-claves)
    - [Protocolos de cifrado de transporte](#protocolos-de-cifrado-de-transporte)
    - [Sobre digital (Digital Envelope) — Flujo de intercambio de claves](#sobre-digital-digital-envelope--flujo-de-intercambio-de-claves)
    - [Integridad y autenticidad en el transporte](#integridad-y-autenticidad-en-el-transporte)
  - [Secreto de Reenvío Perfecto (PFS)](#secreto-de-reenvío-perfecto-pfs)
    - [El problema sin PFS](#el-problema-sin-pfs)
    - [PFS (Perfect Forward Secrecy / Secreto de Reenvío Perfecto)](#pfs-perfect-forward-secrecy--secreto-de-reenvío-perfecto)
    - [Protocolo Diffie-Hellman — Cómo funciona](#protocolo-diffie-hellman--cómo-funciona)
    - [Beneficios del PFS](#beneficios-del-pfs)
    - [Implementaciones de PFS](#implementaciones-de-pfs)
  - [Salting y Key Stretching](#salting-y-key-stretching)
    - [El problema de la baja entropía en contraseñas](#el-problema-de-la-baja-entropía-en-contraseñas)
    - [Salting](#salting)
    - [Key Stretching (Estiramiento de Claves)](#key-stretching-estiramiento-de-claves)
  - [Blockchain](#blockchain)
    - [Estructura técnica de la Blockchain](#estructura-técnica-de-la-blockchain)
    - [Características de la Blockchain](#características-de-la-blockchain)
    - [Aplicaciones potenciales de la Blockchain](#aplicaciones-potenciales-de-la-blockchain)
  - [Ofuscación](#ofuscación)
    - [Técnica 1: Esteganografía (Steganography)](#técnica-1-esteganografía-steganography)
    - [Técnica 2: Enmascaramiento de Datos (Data Masking)](#técnica-2-enmascaramiento-de-datos-data-masking)
    - [Técnica 3: Tokenización (Tokenization)](#técnica-3-tokenización-tokenization)
    - [Comparativa técnicas de ofuscación](#comparativa-técnicas-de-ofuscación)
    - [Desidentificación](#desidentificación)
- [4. Glosario](#4-glosario)

---

# 1. Algoritmos Criptográficos

Un **algoritmo criptográfico** comprende las operaciones específicas realizadas para codificar o decodificar datos. Los sistemas criptográficos modernos utilizan tipos de algoritmos **simétricos** y **asimétricos**, además de **funciones hash unidireccionales**.

## Conceptos Criptográficos

> **Analogía:** La criptografía es como una caja fuerte de cristal: todos saben que existe y dónde está, pero sin la combinación (clave) nadie puede abrirla. La "seguridad por oscuridad" sería esconder la caja fuerte debajo de una alfombra — eso sí puede descubrirse.

**Criptografía** = literalmente "escritura secreta" → arte de asegurar información **codificándola**.

- Es lo **opuesto** a la *Seguridad a través de la oscuridad* (mantener algo en secreto **ocultándolo**).
- Con criptografía: aunque todos conozcan la existencia y ubicación del dato, **sin la clave no pueden entenderlo**.

### Terminología fundamental

| Término | Definición |
|---|---|
| **Texto plano / Texto claro** | Mensaje sin cifrar |
| **Texto cifrado** | Mensaje encriptado |
| **Algoritmo** | Proceso utilizado para cifrar y descifrar |
| **Criptoanálisis** | Arte de descifrar sistemas criptográficos |

### Personajes estándar en criptografía

| Personaje | Rol |
|---|---|
| **Alicia (Alice)** | Remitente del mensaje genuino |
| **Bob** | Destinatario previsto |
| **Mallory** | Atacante malicioso que intenta subvertir el mensaje |

### Tres tipos principales de algoritmos criptográficos

```
1. Hash          → Integridad
2. Simétrico     → Confidencialidad
3. Asimétrico    → Confidencialidad + Autenticación + No repudio
```

Estos tipos garantizan las propiedades de seguridad: **confidencialidad, integridad, disponibilidad y no repudio**.

> **👉 Enfoque de Examen SY0-701:** CompTIA pregunta frecuentemente cuál propiedad de seguridad (CIA + no repudio) garantiza cada tipo de algoritmo. **Distractor común:** confundir el hash con cifrado — el hash es **unidireccional** y NO cifra, solo verifica integridad. El cifrado simétrico **NO puede proporcionar autenticación ni no repudio** por sí solo.

## Cifrado Simétrico (Symmetric Encryption)

> **Analogía:** Imagina una caja con llave donde Alice y Bob tienen **la misma llave copiada**. El problema: ¿cómo se pasan la copia sin que Mallory la intercepte?

Un **algoritmo de cifrado** es un proceso criptográfico que codifica datos para almacenarlos o transmitirlos de forma segura y que solo puede descifrar su propietario o destinatario previsto mediante una **clave**.

### Algoritmos base: Sustitución y Transposición

| Técnica | Descripción | Ejemplo |
|---|---|---|
| **Sustitución** | Reemplaza caracteres del texto plano por otros | `ROT13`: A→N, B→O… "Hello World" → "Uryyb Jbeyq" |
| **Transposición** | Las unidades permanecen iguales pero cambia su **orden** | "HELLOWORLD" escrito en columnas → "HLOOLELWRD" |

> Los algoritmos de cifrado modernos utilizan estas técnicas básicas de sustitución y transposición de formas **complejas** que pueden frustrar los intentos de criptoanálisis.

### Cómo funciona el cifrado simétrico

```
1. Alice y Bob acuerdan qué cifrado usar + valor de clave secreta (ambos la guardan)
2. Alice cifra el archivo con la clave
3. Alice envía SOLO el texto cifrado a Bob
4. Bob descifra usando la MISMA clave secreta
```

### Ventajas y limitaciones

| Ventaja | Limitación |
|---|---|
| Muy **rápido** | Problema de distribución de la clave |
| Ideal para **cifrado masivo** de grandes volúmenes | Si Mallory intercepta la clave → seguridad comprometida |
| — | **NO sirve para autenticación ni integridad** (ambas partes conocen la misma clave y pueden crear los mismos secretos) |

> **Enfoque de Examen SY0-701:** Pregunta clásica: "¿Puede el cifrado simétrico proporcionar autenticación?" → **NO**. Ambas partes comparten la misma clave. Distractor: velocidad (simétrico = rápido) no implica seguridad total.

## Longitud de la Clave

> **Analogía:** La longitud de clave es como el número de dígitos de una combinación. Una cerradura de 3 dígitos (1.000 combinaciones) es mucho más fácil de forzar que una de 10 dígitos (10.000.000.000 combinaciones).

### Conceptos clave

- **Clave:** Aumenta la seguridad del proceso de cifrado. Aunque se conozca el método, **sin la clave específica no se puede descifrar el mensaje**.
- **Espacio de claves:** Rango de todos los valores posibles de la clave.
  - Ejemplo ROT13: espacio de claves = 25 (ROT1 a ROT25).
  - `ROT0` y `ROT26+` = **claves débiles** (producen texto cifrado idéntico al texto plano).
- **Criptoanálisis de fuerza bruta:** Intentar descifrar el texto cifrado probando **cada valor de clave posible** y analizando si el resultado es texto plano legible.

### Fórmula del espacio de claves

```
Espacio de claves = 2^(longitud en bits)

AES-128 → 2^128 posibles claves
AES-256 → 2^256 posibles claves
```

> ⚠️ AES-256 **NO es el doble** de seguro que AES-128 — es **muchos billones de veces más resistente** a la fuerza bruta. La diferencia es exponencial, no lineal.

### Tabla comparativa de longitudes

| Algoritmo | Longitud de Clave | Equivalencia de seguridad |
|---|---|---|
| `AES-128` | 128 bits | 2¹²⁸ combinaciones |
| `AES-256` | 256 bits | 2²⁵⁶ combinaciones |
| `RSA` (mínimo aceptable) | **2048 bits** | — |
| `ECC` | **256 bits** | Equivale a RSA de **3072 bits** |

**Inconveniente de claves largas:** Mayor consumo de **memoria y ciclos de procesador** para cifrar y descifrar.

> **👉 Enfoque de Examen SY0-701:** Memoriza: **ECC-256 ≈ RSA-3072**. Pregunta trampa: "AES-256 es el doble de seguro que AES-128" → **FALSO**. Las claves para cifrados simétricos modernos utilizan **bits generados pseudoaleatoriamente**.

## Cifrado Asimétrico (Asymmetric Encryption)

> **Analogía:** Es como un buzón con ranura pública y llave privada. Cualquiera puede meter un sobre (cifrar con clave pública), pero solo el dueño del buzón puede sacarlo (descifrar con clave privada).

Con un **algoritmo asimétrico**, el cifrado y el descifrado se realizan mediante **dos claves diferentes pero matemáticamente relacionadas** que forman un **par de claves**:

- **Clave pública:** Distribuible libremente. Usada para **cifrar**.
- **Clave privada:** Solo la conoce el propietario. Usada para **descifrar**.
- Las claves se generan de manera que hace **imposible derivar la clave privada a partir de la pública**.

### Flujo de cifrado asimétrico

```
1. Bob genera par de claves → guarda privada en secreto
2. Bob publica la clave pública
3. Alice obtiene clave pública de Bob
4. Alice cifra mensaje con clave pública de Bob → envía texto cifrado
5. Bob descifra con su clave privada
6. Mallory intercepta texto cifrado + clave pública
7. Mallory NO puede usar la clave pública para descifrar → sistema seguro
```

### Comparativa simétrico vs. asimétrico

| Característica | Simétrico | Asimétrico |
|---|---|---|
| Número de claves | 1 (compartida) | 2 (pública + privada) |
| Velocidad | **Rápido** | **Lento** (sobrecarga computacional sustancial) |
| Uso principal | Cifrado masivo de datos | Intercambio de claves, autenticación |
| Distribución | Problemática | Fácil (clave pública es pública) |
| Autenticación | No | Sí |

> ⚠️ El cifrado asimétrico **no se usa para cifrar datos masivos directamente** — es ineficiente. Se usa para **cifrar una clave de sesión simétrica** (esquema híbrido).

### Algoritmos asimétricos principales

| Algoritmo | Significado | Longitud Mínima Recomendada |
|---|---|---|
| `RSA` | Rivest, Shamir, Adelman | **2048 bits** |
| `ECC` | Criptografía de Curva Elíptica | **256 bits** (≡ RSA-3072) |

> **👉 Enfoque de Examen SY0-701:** "¿Qué tipo de cifrado se usa para el intercambio de claves?" → **Asimétrico**. "¿Qué tipo se usa para cifrar grandes volúmenes?" → **Simétrico**. Distractor: pensar que asimétrico "también puede cifrar datos masivos" — técnicamente sí, pero es ineficiente.

## Hashing

> **Analogía:** El hash es como la huella dactilar de un archivo. No importa el tamaño — siempre produce una "huella" de tamaño fijo. Si cambias un solo píxel, la huella cambia completamente.

Un **algoritmo de hashing criptográfico** produce una cadena de bits de **longitud fija** desde cualquier texto plano de entrada de **cualquier longitud**.

El resultado se denomina: **hash** o **resumen de mensaje** (*message digest*).

### Propiedades fundamentales del hash

- **Unidireccional:** Imposible recuperar el texto plano desde el hash.
- **Sin colisiones:** Entradas diferentes → salidas diferentes. (Una colisión = fallo de seguridad).

### Uso 1: Verificación de contraseñas

```
1. Bob almacena el HASH de la contraseña de Alice (nunca el texto plano)
2. Alice escribe su contraseña → se convierte en hash → se envía el hash
3. Bob compara hashes → si coinciden → autenticación exitosa
4. Bob NUNCA conoce la contraseña en texto plano
```

### Uso 2: Verificación de integridad de archivos

```
1. Alice publica archivo + hash de referencia en su sitio
2. Bob descarga el archivo + anota el hash de referencia
3. Bob calcula el hash del archivo descargado y lo compara
   → Coincide: archivo íntegro ✅
   → No coincide: archivo manipulado ❌

ATAQUE DE MALLORY:
4. Mallory sustituye el archivo por uno malicioso
5. Mallory NO puede cambiar el hash de referencia publicado por Alice
6. Bob calcula hash → no coincide → sospecha manipulación ✅
```

### Algoritmos de hashing principales

| Algoritmo | Nombre completo | Tamaño del Resumen | Seguridad |
|---|---|---|---|
| `SHA` | Algoritmo de Hash Seguro (Secure Hash Algorithm) | Variable | **Más fuerte** |
| `SHA-256` | SHA variante 256 bits | **256 bits** | **Recomendado** actualmente |
| `MD5` | Algoritmo de Resumen de Mensajes #5 (Message Digest Algorithm #5) | **128 bits** | **Débil** — solo para compatibilidad |

> **👉 Enfoque de Examen SY0-701:** "¿Qué propiedad garantiza el hashing?" → **Integridad**. Distractor: "¿Puede un hash proporcionar confidencialidad?" → **NO**, es unidireccional pero no cifra. MD5 sigue siendo válido para *compatibilidad* pero **NO para seguridad**. SHA-256 es el estándar actual.

## Firmas Digitales

> ✍️ **Analogía:** Una firma digital es como una firma notarial: solo tú puedes hacerla con tu sello privado (autenticación), y cualquier cambio posterior en el documento la invalida (integridad).

### Primitivo criptográfico vs. Conjunto de cifrado

- **Primitivo criptográfico:** Una sola función usada de forma aislada (hash, simétrico o asimétrico).
- **Conjunto de cifrado:** Combinación de **múltiples primitivos** para formar un sistema completo.

> La criptografía de clave pública puede **autenticar** a un remitente porque controla una clave privada que produce mensajes de una manera que **nadie más puede replicar**. El hash demuestra la **integridad**. Combinados → **firma digital**.

### Cómo funciona una firma digital

```
FIRMA (Alice):
1. Alice calcula el hash del mensaje (ej. SHA-256)
2. Alice firma el hash con su CLAVE PRIVADA (operación de firma asimétrica)
3. Alice adjunta la firma digital al mensaje
4. Alice envía: mensaje + firma digital → a Bob

VERIFICACIÓN (Bob):
3. Bob verifica la firma con la CLAVE PÚBLICA de Alice → obtiene hash original
4. Bob calcula su propio hash del documento recibido (mismo algoritmo)
5. Compara los dos hashes:
   → Iguales: datos íntegros + identidad de Alice garantizada ✅
   → Diferentes: datos manipulados O Mallory usó clave privada diferente ❌
```

### Propiedades garantizadas por la firma digital

| Primitivo usado | Propiedad garantizada |
|---|---|
| Hash (SHA-256) | **Integridad** |
| Clave privada (firma asimétrica) | **Autenticación + No repudio** |
| Combinación hash + clave privada | **Integridad + Autenticación + No repudio** |

### Estándares de firma digital

| Estándar | Significado | Algoritmo base | Estado |
|---|---|---|---|
| `PKCS#1` | Estándar de Criptografía de Clave Pública #1 (Public Key Cryptography Standard #1) | RSA | Vigente |
| `DSA` | Algoritmo de Firma Digital (Digital Signature Algorithm) | ElGamal | Parte de FIPS |
| `ECDSA` | Curva Elíptica DSA (Elliptic Curve DSA) | Curva Elíptica | **Más ampliamente usado actualmente** |

> `DSA` y `ECDSA` se desarrollaron como parte de las **FIPS** (Normas Federales de Procesamiento de Información / Federal Information Processing Standards) del gobierno de EE.UU.

> **👉 Enfoque de Examen SY0-701:** "¿Qué combina hash + cifrado asimétrico?" → **Firma digital**. Distractor: la firma digital NO cifra el mensaje para confidencialidad — solo firma el **hash** para integridad/autenticación. El mensaje puede ir en claro. ECDSA es el más moderno y ampliamente usado.

# 2. Infraestructura de Clave Pública (PKI)

> **Analogía:** PKI es como el sistema de notarías del mundo digital. Un notario (CA) verifica tu identidad y te emite un documento oficial (certificado digital) que otros pueden consultar para confiar en ti.

**PKI** (Public Key Infrastructure / Infraestructura de Clave Pública): Framework que ayuda a establecer **confianza** en el uso de la criptografía de clave pública para firmar y cifrar mensajes, a través de **certificados digitales**.

- Un **certificado digital** = afirmación pública de identidad, validada por una **CA** (Autoridad Certificadora / *Certificate Authority*).

## Autoridades Certificadoras

### El problema que resuelve la PKI

La criptografía de clave pública resuelve el problema de la **distribución de claves**, pero crea uno nuevo: **no existe mecanismo para establecer la identidad del propietario de una clave**.

- Cuando quieres que otros te envíen mensajes confidenciales → les das tu **clave pública** para cifrar.
- Cuando quieres autenticarte → **firmas con tu clave privada**; otros verifican con tu clave pública.
- **Problema:** ¿Cómo saber que la clave pública que recibes pertenece realmente a quien dice ser? ¿Cómo verificar que no hay un actor de amenazas interceptando y modificando las comunicaciones?

> La **PKI** tiene como objetivo demostrar que los propietarios de las claves públicas son quienes dicen ser. En el marco de la PKI, cualquier persona que emita una clave pública debe publicarla en un **certificado digital**. La validez del certificado está garantizada por una **CA**.

### CA privada vs. CA de terceros

| Tipo | Uso | Confianza |
|---|---|---|
| **CA privada** | Redes internas de una organización | Solo dentro de la organización |
| **CA de terceros** | Comunicaciones públicas o B2B | Usuarios, gobiernos, reguladores, instituciones financieras |

**Ejemplos de CA de terceros:**
```
Comodo | DigiCert | GeoTrust | IdenTrust | Let's Encrypt
```

### Flujo PKI completo

```
1. CA genera certificado raíz → lo firma con su clave privada → publica clave pública
2. Cliente obtiene el certificado raíz → lo añade a su almacén de certificados de confianza
3. Servidor web crea CSR (contiene su clave pública) → lo envía a la CA
4. CA genera certificado firmado desde el CSR → lo devuelve al servidor web
5. Cliente verifica el certificado del servidor → valida firma de CA confiable
6. Cliente y servidor establecen conexión cifrada de confianza
```

### Funciones de una CA pública de terceros

- Proveer **servicios de certificados** útiles a la comunidad.
- **Validar la identidad** de quienes solicitan certificados (registro).
- Establecer **confianza** con usuarios, gobiernos, reguladores e instituciones.
- Administrar **repositorios** que almacenan y gestionan certificados.
- Gestión del **ciclo de vida** de claves y certificados, especialmente la **revocación** de los no válidos.

> **👉 Enfoque de Examen SY0-701:** "¿Qué valida la identidad en una PKI?" → **La CA**. Distractor: el certificado **contiene** la clave pública más la identidad validada por la CA — no son lo mismo.

---

## Certificados Digitales

> **Analogía:** Un certificado digital es como un pasaporte: contiene tu foto (clave pública), tus datos personales (información del sujeto), y el sello oficial del gobierno (firma de la CA).

Un **certificado digital** es básicamente un **contenedor de la clave pública del sujeto**, que además contiene:

- La **clave pública** del sujeto (elemento principal)
- Información sobre el **sujeto** (persona u organización)
- Información sobre el **emisor** (la CA)
- **Firma digital de la CA** (demuestra que fue emitido a ese sujeto por esa CA)

El sujeto puede ser:
- Un **usuario humano** (ej. para firmar mensajes de correo)
- Un **servidor informático** (ej. servidor web con transacciones confidenciales)

### Estándares de certificados

| Estándar | Organismo | Descripción |
|---|---|---|
| `X.509` | UIT + IETF (`RFC 5280`) | Estándar base internacional para certificados digitales |
| `PKCS` | RSA Security | Conjunto de estándares (Public Key Cryptography Standards) para promover el uso de PKI |

> **👉 Enfoque de Examen SY0-701:** Memoriza `X.509` como el estándar de certificados y `RFC 5280` como su referencia IETF. PKCS es el conjunto de estándares de RSA para PKI.

## Raíz de Confianza

> 🌳 **Analogía:** La raíz de confianza es como el registro de nacimiento del sistema. Todo parte de ahí. Si la raíz está comprometida, todo el árbol de confianza colapsa.

### Certificado raíz

- Cada CA **se emite un certificado a sí misma** → **certificado autofirmado** → **certificado raíz**.
- Tamaño de clave: `RSA 2048 o 4096 bits` o equivalente `ECC`.
- El sujeto del certificado raíz = nombre de la organización/CA (ej. `"CompTIA Root CA"`).
- Instalar el certificado raíz de una CA = **confiar automáticamente en todos los certificados que firme esa CA**.

### Modelo 1: CA Única (Single CA)

```
[CA Raíz] ──────────────────→ [Usuarios/Equipos]
```

- Usado en **redes privadas**.
- **Problema:** Si el servidor CA es comprometido → **toda la PKI colapsa**.

### Modelo 2: CA Jerárquica (Terceros)

```
[CA Raíz]
    ↓ emite certificados a
[CA Intermedia 1] → [Sujetos/Hojas/Entidades finales]
[CA Intermedia 2] → [Sujetos/Hojas/Entidades finales]
```

- La CA raíz emite a **CA intermedias**.
- Las CA intermedias emiten a los **sujetos** (hojas / entidades finales).
- **Ventaja:** Se pueden configurar diferentes CA intermedias con políticas de certificados distintas.
- Cada certificado de hoja se rastrea hasta la CA raíz → **encadenamiento de certificados** / **cadena de confianza** (ruta de certificación).

### Modelo 3: Certificados Autofirmados

- Cualquier equipo, servidor web o código de programa puede implementar un certificado autofirmado.
- Usos: routers domésticos, entornos de desarrollo y prueba.
- El SO o navegador los marca como **no confiables** (el usuario puede anularlo).
- **No deben usarse** para proteger hosts y aplicaciones críticas.
- Son **muy difíciles de validar** por su naturaleza.

> **👉 Enfoque de Examen SY0-701:** "¿Qué es la cadena de confianza?" → Ruta desde el certificado de hoja hasta la CA raíz. Distractor: confundir "certificado autofirmado" (cualquier entidad) con "certificado raíz" (CA oficial). La diferencia clave del modelo jerárquico es la **resiliencia**: si cae una CA intermedia, no colapsa toda la PKI.

## Solicitudes de Firma de Certificados (CSR)

> 📝 **Analogía:** Solicitar un certificado es como solicitar tu DNI: presentas tus datos, el organismo los verifica, y entonces te emiten el documento oficial sellado.

### Proceso de registro y emisión

**Registro:** Proceso mediante el que los usuarios finales crean una cuenta con la CA y obtienen autorización para solicitar certificados.

```
1. Usuario crea cuenta con la CA → obtiene autorización
   (Ej: en Windows Domain → auto-inscripción via Active Directory)
   (CA de terceros → serie de pruebas para verificar identidad)

2. Sujeto genera par de claves asimétricas:
   → Elige: RSA o ECC + longitud de clave
   → Clave privada: se guarda de forma segura (solo el sujeto la conoce)

3. Sujeto genera CSR (Certificate Signing Request):
   → Archivo que contiene: info del sujeto + clave pública

4. CSR se envía a la CA

5. CA verifica:
   → Para servidores web: nombre del sujeto = FQDN
   → Verifica que el solicitante es responsable del dominio (registros WHOIS)

6. CA acepta → firma el certificado → lo devuelve al sujeto
```

**CSR** (Certificate Signing Request / Solicitud de Firma de Certificado): Archivo que contiene la información que el sujeto desea utilizar en el certificado, **incluyendo su clave pública**.

**FQDN** (Fully Qualified Domain Name / Nombre de Dominio Completamente Calificado): Nombre completo de un host (ej. `www.ejemplo.com`).

> **👉 Enfoque de Examen SY0-701:** El sujeto **genera su propio par de claves** y envía la CSR con la **clave pública** — **nunca envía la clave privada** a la CA. La CA valida la identidad antes de firmar. En entornos Windows, la auto-inscripción se hace via Active Directory.

## Atributos del Nombre del Sujeto

### Campo CN (Common Name / Nombre Común)

- Uso original: identificar el **FQDN** del servidor (ej. `www.comptia.org`).
- Creció **por costumbre** más que por diseño.
- Puede contener diferentes tipos de información → difícil de interpretar correctamente por el navegador.
- Actualmente **en desuso** como método primario de validación de identidad de un sujeto (dirección de red).
- Aún así, es **más seguro incluir también el FQDN en el CN** ya que no todos los navegadores/implementaciones están actualizados.

### Campo SAN (Subject Alternative Name / Nombre Alternativo del Sujeto)

- **Estándar actual** para identificar el servidor.
- Estructurado para representar **diferentes tipos de identificadores**: FQDNs y direcciones IP.
- Si un certificado tiene SAN configurado, el **navegador debe validar el SAN e ignorar el CN**.

### Tipos de SAN / Certificados especiales

| Tipo | Descripción | Ejemplo |
|---|---|---|
| Subdominios específicos | Lista explícita y más segura | `www.comptia.org`, `members.comptia.org` |
| **Dominio comodín (Wildcard)** | Cubre todos los subdominios de **un solo nivel** | `*.comptia.org` → válido para `www.`, `members.`, etc. |
| Email (RFC 822) | Para certificados de correo electrónico | `usuario@empresa.com` |
| Firma de código | Para verificar editores/desarrolladores de software | No usa SAN; la CA valida datos de organización y ubicación |

> ⚠️ Un dominio comodín como `*.comptia.org` cubre un solo nivel. Si se agrega un subdominio nuevo en la lista específica, se debe emitir un nuevo certificado.

### Campos del Nombre Distinguido (DN)

Un certificado también contiene campos para:

```
CN=www.example.com, OU=Web Hosting, O=Example LLC, L=Chicago, ST=Illinois, C=US
```

| Campo | Significado |
|---|---|
| `CN` | Common Name (Nombre Común) |
| `OU` | Organizational Unit (Unidad Organizativa) |
| `O` | Organization (Organización) |
| `L` | Locality (Localidad) |
| `ST` | State (Estado) |
| `C` | Country (País) |

Todos estos campos concatenados forman el **DN** (Distinguished Name / Nombre Distinguido).

> **👉 Enfoque de Examen SY0-701:** "¿Qué campo usa un certificado para identificar múltiples subdominios?" → **SAN**. El CN está **en desuso** para validación. Certificado **comodín** (`*.dominio.com`) cubre un nivel (no recursivo). Diferencia SAN específico vs. comodín: el específico es **más seguro** pero requiere nuevo certificado por cada subdominio nuevo. El certificado de firma de código **no usa SAN**.

## Revocación de Certificados

> **Analogía:** La revocación es como cancelar una tarjeta de crédito robada. El banco (CA) avisa a todos los comercios (clientes) que esa tarjeta ya no es válida.

### Estados de un certificado

| Estado | Descripción |
|---|---|
| **Válido** | Certificado activo y confiable |
| **Revocado** | Inválido de forma **permanente** — no puede ratificarse ni restablecerse |
| **Suspendido** | Inválido **temporalmente** — puede reactivarse |

> Una clave suspendida recibe el código: **"Certificado retenido"**.

### Razones de revocación (codificadas)

- Clave privada comprometida
- Empresa cerrada
- Usuario dejó la empresa
- Nombre de dominio modificado
- Certificado mal utilizado
- Cese de operaciones

Opciones de código: *No especificado, Compromiso de clave, Compromiso de CA, Reemplazado, Cese de operaciones*.

### CRL (Certificate Revocation List / Lista de Revocación de Certificados)

- Lista que mantiene la CA con **todos los certificados revocados y suspendidos**.
- Debe ser accesible para cualquier persona que confíe en la CA.
- Cada certificado contiene info sobre **cómo verificar la CRL**.

**Atributos de una CRL:**

| Atributo | Descripción |
|---|---|
| **Período de publicación** | Fecha/hora de publicación (suele ser automática) |
| **Puntos de distribución** | Ubicaciones donde se publica la CRL |
| **Período de validez** | Tiempo en que la CRL es autoritativa (ligeramente mayor al período de publicación, ej: publica cada 24h → válida 25h) |
| **Firma** | La CRL está firmada por la CA para verificar su autenticidad |

**Riesgos de la CRL:**
- Un certificado puede haber sido revocado pero ser **aceptado** si no se publicó una CRL actualizada.
- El navegador puede **no estar configurado** para realizar verificación de CRL (más común en navegadores heredados).

### OCSP (Online Certificate Status Protocol / Protocolo de Estado de Certificados en Línea)

- Alternativa más actualizada a la CRL.
- Verifica el **estado individual** de un certificado (no toda la lista).
- Los detalles del servicio OCSP deben publicarse en el certificado.
- La mayoría consulta la base de datos directamente → **estado en tiempo real**.
- Algunos servidores OCSP dependen de las CRL → limitados por el intervalo de publicación.

| Mecanismo | Funciona con | Ventaja | Limitación |
|---|---|---|---|
| **CRL** | Lista descargada periódicamente | Compatible con todo | Puede quedar desactualizada |
| **OCSP** | Consulta individual en tiempo real | Más actualizado | Depende del servidor OCSP disponible |

> **👉 Enfoque de Examen SY0-701:** "¿Qué mecanismo proporciona estado más actualizado?" → **OCSP**. Trampa: un certificado revocado puede seguir aceptándose si la CRL no se ha actualizado. Diferencia revocado (permanente) vs. suspendido (temporal).

## Gestión de Claves

> **Analogía:** Gestionar claves es como gestionar las llaves físicas de una empresa: crearlas, guardarlas seguras, retirarlas cuando caducan o se pierden, y tener copias de seguridad en una caja fuerte separada.

La **gestión de claves** se refiere a consideraciones operativas para las diversas etapas del **ciclo de vida de una clave**:

### Ciclo de vida de una clave

| Etapa | Descripción |
|---|---|
| **Generación** | Crear par de claves asimétricas o clave secreta simétrica con la fuerza requerida |
| **Almacenamiento** | Prevenir acceso no autorizado + proteger contra pérdidas o daños |
| **Revocación** | Prevenir uso si la clave se compromete. **Los datos cifrados con ella deben re-cifrarse con una nueva clave** |
| **Caducidad y renovación** | Todos los certificados caducan tras un período. Pueden renovarse con el mismo o nuevo par de claves |

### Modelos de gestión de claves

| Modelo | Descripción | Ventaja | Desventaja |
|---|---|---|---|
| **Descentralizado** | Claves generadas/gestionadas en el propio equipo o cuenta de usuario | Fácil de implementar, sin configuración especial | Dificulta detección de compromisos |
| **Centralizado** | Servidor o dispositivo dedicado para generar/almacenar claves | Mejor control y auditoría | Mayor complejidad |

### KMIP (Key Management Interoperability Protocol / Protocolo de Interoperabilidad de Gestión de Claves)

- Protocolo que usan los dispositivos/aplicaciones para **comunicarse con el servidor de gestión de claves** centralizado.

> **👉 Enfoque de Examen SY0-701:** Si una clave privada se compromete → **revocar** la clave Y **re-cifrar** todos los datos cifrados con ella usando una nueva clave. KMIP = protocolo de comunicación en sistemas centralizados.

## Criptoprocesadores y Enclaves Seguros

> 🔒 **Analogía:** Un criptoprocesador es como una cámara acorazada dentro del banco. Las claves viven ahí, nunca salen, y todo el trabajo criptográfico se hace dentro de la bóveda.

### Problemas del almacenamiento de claves en sistema de archivos ordinario

1. **Baja entropía:**
   - Las computadoras procesan instrucciones de forma **determinista** → entropía extremadamente baja.
   - Se usa **PRNG** (Pseudo-Random Number Generator / Generador de Números Pseudoaleatorios): determinista, pero aproxima un alto nivel de desorden.
   - Mayor seguridad con **TRNG** (True Random Number Generator / Generador de Números Aleatorios Verdaderos): usa fuentes físicas de entropía (**ruido, movimiento del aire**) como semilla no determinista.

2. **Vulnerabilidad de almacenamiento:**
   - Una clave en el sistema de archivos es **tan segura como cualquier otro archivo**.
   - Puede comprometerse mediante credenciales robadas o robo físico del dispositivo.
   - Difícil garantizar auditoría completa del acceso.
   - **Ideal:** Almacenamiento criptográfico **inviolable (tamper-evident)** → se sabe de inmediato cuándo se comprometió y se puede revocar y re-cifrar.

> **Solución:** Usar un **criptoprocesador** → dedicado a una única función → menor superficie de ataque que un equipo de uso general. Puede realizar operaciones (descifrar, firmar) en nombre de las aplicaciones → **el material de la clave nunca sale del criptoprocesador**.

### TPM (Trusted Platform Module / Módulo de Plataforma Confiable)

Criptoprocesador implementado como **módulo para una plataforma informática específica** (PC, dispositivo móvil, sistema embebido).

**Versiones:**
- `TPM 1.2` → mayoría de proveedores deja de dar soporte.
- `TPM 2.0` → versión actual. **No compatible hacia atrás** con 1.2.

**Tipos de implementación TPM:**

| Tipo | Descripción | Resistencia a manipulación | Superficie de ataque |
|---|---|---|---|
| **Discreto** | Chip dedicado e independiente | ✅ Alta (tamper-resistant) | 🟢 Mínima |
| **Integrado** | Parte del chipset o CPU (realiza otras funciones) | ❌ No resistente | 🟡 Más amplia |
| **Firmware** | En código operativo de bajo nivel (BIOS/UEFI). Ej: `Intel PTT`, `AMD fTPM` | ❌ No resistente | 🔴 Más amplia (incluye código de enclave seguro) |
| **Virtual** | Implementado en hipervisor para VMs | Depende del hipervisor | Variable |

### HSM (Hardware Security Module / Módulo de Seguridad de Hardware)

Hardware de criptoprocesador en **factor de forma removible o dedicado**.

- Formatos: dispositivos montados en rack, tarjetas adaptadoras `PCIe`, llaves de seguridad `USB`, dispositivos virtuales.
- Diferencia clave con TPM:
  - **TPM:** Valida la seguridad de **una plataforma específica** (PC, laptop).
  - **HSM:** Proporciona **almacenamiento centralizado de claves** para hosts de red o **almacenamiento portátil** que personas usan en diferentes dispositivos.
- Certificación: **FIPS 140-2 Nivel 2** (Federal Information Processing Standard 140-2).

### Enclave Seguro (Secure Enclave / TEE)

**Problema residual con criptoprocesadores:**
- Los datos descifrados deben cargarse en **RAM** para que las aplicaciones puedan acceder a ellos → posible acceso por proceso malicioso.
- El criptoprocesador interactúa con las aplicaciones via **API** que implementa `PKCS#11`.

**Solución:**
- **TEE** (Trusted Execution Environment / Entorno de Ejecución Confiable): protege datos en memoria del sistema.
- Ejemplo: `Intel SGX` (Software Guard Extensions / Extensiones de Guardia de Software de Intel).
- **Ni procesos con privilegios root/sistema** pueden acceder sin autorización.
- El enclave está bloqueado a una lista de uno o más procesos **firmados digitalmente**.

### Resumen comparativo TPM vs. HSM

| Característica | TPM | HSM |
|---|---|---|
| Propósito | Validar **una plataforma específica** | Almacenamiento **centralizado/portátil** |
| Factor de forma | Chip en placa madre | Rack, PCIe, USB, virtual |
| Portabilidad | No | Sí |
| Alcance | Un dispositivo | Múltiples hosts |
| Certificación | Especificación TCG | FIPS 140-2 Nivel 2 |

> **👉 Enfoque de Examen SY0-701:** **TPM = atado a un dispositivo**, **HSM = centralizado/portátil**. TRNG > PRNG en entropía. FIPS 140-2 = certificación de HSMs. Intel SGX = TEE. TPM Discreto = más seguro (tamper-resistant); TPM Firmware = más vulnerable. PKCS#11 = API de comunicación con el criptoprocesador.

## Custodia de Claves

> **Analogía:** La custodia de claves es como una caja de seguridad bancaria que requiere dos llaves simultáneas — la del banco y la del cliente. Ninguno puede abrirla solo.

### El problema de las copias de seguridad de claves

- Sin copia → si se pierde la clave, los **textos cifrados no pueden recuperarse**.
- Con copias → mayor probabilidad de **compromiso** + más difícil detectar si ya ocurrió.

### Soluciones: Custodia y Control M de N

- **Custodia (Key Escrow):** La clave se archiva con un **tercero** de forma **independiente**.
- **M de N:** Una operación **no puede realizarla una sola persona**. Requiere que un **quórum (M)** de personas de las disponibles **(N)** acuerden autorizar la operación.

### División de claves y KRA

- La clave se puede dividir en **partes** → cada parte la custodia un proveedor diferente → reduce riesgo de compromiso.
- **KRA** (Key Recovery Agent / Agente de Recuperación de Claves): Cuenta con permiso para acceder a una clave mantenida en custodia.
- Una política puede requerir **dos o más KRA** para autorizar la recuperación → mitiga el riesgo de que un KRA intente suplantar al propietario.

> **👉 Enfoque de Examen SY0-701:** "¿Qué control previene que un solo administrador acceda a una clave en custodia?" → **M de N** (control de quórum). KRA = agente con acceso a claves en custodia. Distractor: custodia ≠ backup normal — la custodia implica terceros y controles adicionales.

# 3. Soluciones Criptográficas

Como profesional en seguridad, debes ser capaz de **seleccionar soluciones criptográficas adecuadas** para un problema de seguridad determinado. Una solución criptográfica utiliza cifrados y herramientas (certificados, firmas digitales) para implementar un **control de seguridad**.

## Cifrado que Respalda la Confidencialidad

> 🛡️ **Analogía:** El cifrado es como un sobre sellado: aunque el cartero (red) lo lleve, no puede leer su contenido. Da igual que te roben el disco si está cifrado — no puedes leerlo.

Si los datos están cifrados, aunque sean robados o interceptados, el actor de amenaza **no podrá comprenderlos ni cambiarlos** → objetivo de **confidencialidad**.

### Los tres estados de los datos

| Estado | Descripción | Protección típica |
|---|---|---|
| **Data at rest** (Datos en reposo) | Almacenados en medios persistentes (disco, SSD) | FDE, cifrado de volumen, cifrado de BD |
| **Data in transit / Data in motion** (Datos en tránsito / en movimiento) | Transmitidos a través de una red | TLS, IPsec/VPN, WPA |
| **Data in use / Data in processing** (Datos en uso / en procesamiento) | Presentes en memoria volátil (RAM, registros, caché CPU) | Enclaves seguros (TEE) |

### Cifrado masivo (Bulk Encryption)

- Cifrar megabytes o gigabytes de datos = **cifrado masivo**.
- El cifrado **asimétrico NO se usa** para cifrado masivo → **sobrecarga computacional demasiado alta**.
- Se usa **cifrado simétrico** (ej. `AES`) para datos masivos.
- **Problema del simétrico:** Distribuir la clave simétrica es un desafío (cuantas más personas la conozcan, más débil la confidencialidad).
- **Solución:** Las claves simétricas son cortas (128 o 256 bits) → pueden cifrarse fácilmente con una **clave pública** asimétrica.

### Esquema híbrido KEK / DEK

```
1. Usuario genera par de claves asimétricas (RSA o ECC)
   → Clave privada cifrada con credencial del usuario
   → Esta clave privada = KEK (Key Encryption Key / Clave de Cifrado de Clave)

2. Sistema genera clave secreta simétrica (AES-256 o AES-512)
   → Esta es la DEK (Data Encryption Key / Clave de Cifrado de Datos)
   → La DEK cifra los datos objetivo

3. La DEK se cifra usando la parte PÚBLICA de la KEK

4. Para acceder a los datos:
   → Usuario proporciona contraseña o inicia sesión autenticada
   → Clave privada (KEK) descifra la DEK
   → La DEK descifra los datos
```

> **👉 Enfoque de Examen SY0-701:** Memoriza: **KEK** cifra a la **DEK** que cifra los datos. "¿Se usa cifrado asimétrico para cifrar datos en disco?" → **NO directamente** — cifra la clave simétrica (DEK). La DEK cifra los datos reales.

## Cifrado de Archivos y Discos

> **Analogía:** FDE es blindar todo el maletero. Cifrado de volumen es poner candado a una maleta específica. Cifrado de archivos es poner candado individual a cada objeto dentro de la maleta.

Los datos en reposo abarcan muchos mecanismos de almacenamiento. Pueden pensarse en **niveles de cifrado**:

```
[Nivel más granular — mayor control de acceso]
  Cifrado de archivo individual (EFS)
  Cifrado de columna/celda en BD
  Cifrado de volumen (BitLocker, FileVault)
  Cifrado de disco completo (FDE)
[Nivel más simple]
```

### FDE (Full Disk Encryption / Cifrado de Disco Completo)

- Cifra **todo el contenido** del dispositivo:
  - Datos
  - **Metadatos** (lista de archivos, propietario, fechas de creación/modificación)
  - **Espacio libre** (puede contener restos de archivos "eliminados" — marcados como eliminados pero datos no borrados físicamente)
- Protege principalmente contra **robo físico del disco**.
  - Sin FDE: disco robado → montado en cualquier PC → acceso total.
  - Con FDE: el disco debe desbloquearse con credenciales para acceder a la clave de descifrado.

**SED (Self-Encrypting Drive / Unidad de Autocifrado):**
- HDD, SSD o USB flash con producto criptográfico integrado en **firmware**.
- El firmware implementa un criptoprocesador → **claves no expuestas directamente al SO**.

### Cifrado de particiones

- Un disco puede dividirse en **particiones** (áreas lógicas separadas, cada una con su sistema de archivos).
- Cifrado selectivo de particiones con **diferentes claves**:
  - Particiones de arranque/sistema: dejar sin cifrar (solo archivos estándar del SO).
  - **Partición de datos**: proteger con cifrado.

### Cifrado de volúmenes

- **Volumen:** Recurso de almacenamiento con un único sistema de archivos (puede ser partición, disco extraíble, matriz RAID).
- El cifrado de volumen se implementa como **software** (no firmware del disco).
- Puede o no cifrar espacio libre o metadatos de archivos.

**Ejemplos:**
- `BitLocker` (Microsoft) — cifrado de volumen.
- `FileVault` (Apple) — cifrado de volumen.

### Cifrado de archivos individuales

- Software que aplica cifrado a **archivos individuales** (o carpetas/directorios).
- Ejemplo: **EFS** (Encrypting File System / Sistema de Archivos de Cifrado de Microsoft).
  - Requiere que el volumen esté formateado con `NTFS`.

### Integración con TPM/HSM

- Si el dispositivo tiene un TPM o HSM compatible con el producto de cifrado, el sistema de discos/volúmenes/archivos puede **bloquearse mediante las claves almacenadas en el TPM/HSM**.

> **👉 Enfoque de Examen SY0-701:** "¿Qué cifra metadatos y espacio libre?" → **FDE**. SED = hardware (firmware del disco). BitLocker/FileVault = **software** (cifrado de volumen). EFS requiere **NTFS**. Distractor: "BitLocker es FDE" → técnicamente es cifrado de **volumen**, aunque en práctica se aplica al disco completo.

## Cifrado de Base de Datos

> **Analogía:** Cifrar una BD es como poner seguridad a distintos niveles de un edificio: puedes blindar toda la planta (TDE), una sala específica (columna), o incluso un cajón concreto (registro individual).

### Estructura de una base de datos

- **Tablas** → **Columnas** (campos con tipo de datos) + **Filas** (registros con valores por campo).
- Acceso mediado por **DBMS** (Database Management System / Sistema de Gestión de Base de Datos) usando **SQL** (Structured Query Language / Lenguaje de Consulta Estructurado).
- BD normalmente alojada en servidor → accedida por **aplicaciones cliente**.

> Los archivos subyacentes pueden estar protegidos por cifrado de disco/volumen en el servidor, pero **suele tener impacto adverso en el rendimiento**. Por ello, el cifrado se implementa más comúnmente a través del DBMS.

### Nivel 1: Cifrado a Nivel de Base de Datos — TDE

**TDE** (Transparent Data Encryption / Cifrado de Datos Transparente):
- Cifrado/descifrado a nivel de **base de datos o de página**.
- Opera cuando los datos se transfieren entre **disco y memoria**.
- Una **página** es el medio por el que el motor de BD devuelve los datos desde el almacenamiento subyacente.
- Cifra **todos los registros** mientras se almacenan en disco → protege contra robo de medios subyacentes.
- También cifra los registros generados por la base de datos.
- Implementado en: `Microsoft SQL Server`.

### Nivel 2: Cifrado a Nivel de Columna/Celda

- Se aplica a uno o más **campos específicos** dentro de una tabla.
- Menor impacto en rendimiento que TDE.
- El administrador debe identificar **qué campos necesitan protección**.
- Puede dificultar el acceso del cliente a los datos.

**Always Encrypted** (SQL Server):
- Los datos permanecen cifrados **incluso cuando se cargan en memoria**.
- Solo se descifran cuando la **aplicación cliente** suministra la clave.
- La **clave de texto plano NO está disponible para el DBMS** → el DBA (administrador de BD) no puede descifrar los datos.
- Permite **separación de funciones** entre el DBA y el propietario de los datos → importante para **privacidad**.

### Nivel 3: Cifrado a Nivel de Registro/Fila

- Cada cliente/registro puede identificarse con un **par de claves separado**.
- Los datos a nivel de fila/registro se cifran con claves distintas.
- La tabla contiene registros protegidos por separado por **diferentes claves**.
- Control granular sobre **quién puede acceder a qué datos**.
- Ejemplo: BD de aseguradora de salud → cada paciente protegido con claves distintas.
- Importante para cumplimiento de normativas de **seguridad y privacidad**.

### Comparativa niveles de cifrado en BD

| Nivel | Granularidad | Impacto rendimiento | Protege contra | Caso de uso |
|---|---|---|---|---|
| **TDE** | Toda la BD / página | Adverso (mayor) | Robo de medios | Protección básica del disco |
| **Columna/celda** | Campo específico | Menor | Acceso del DBA a datos sensibles | Separación de funciones, privacidad |
| **Registro/fila** | Registro individual | Variable | Acceso cruzado entre registros | Cumplimiento normativo, datos individualizados |

> **👉 Enfoque de Examen SY0-701:** "¿Qué mecanismo impide que el DBA vea datos cifrados?" → **Always Encrypted** (cifrado de columna con clave en cliente). TDE protege contra robo del disco, pero el DBA **sí puede ver** los datos en memoria. Distractor: TDE ≠ Always Encrypted — son niveles distintos.

## Cifrado de Transporte e Intercambio de Claves

> **Analogía:** El sobre digital es como enviar un mensaje en una caja de seguridad: cifras el mensaje con una llave de sesión (AES), luego metes esa llave dentro de la caja bloqueada con el candado del destinatario (su clave pública). Solo él puede sacar la llave y abrir el mensaje.

### Protocolos de cifrado de transporte

| Protocolo | Significado | Protege | Uso típico |
|---|---|---|---|
| `WPA` | Wi-Fi Protected Access / Acceso Wi-Fi Protegido | Tráfico inalámbrico | Redes WiFi |
| `IPsec` | Internet Protocol Security / Seguridad de Protocolo de Internet | Tráfico entre dos puntos en red pública no confiable | **VPN** (Virtual Private Network / Red Privada Virtual) |
| `TLS` | Transport Layer Security / Seguridad de la Capa de Transporte | Datos de aplicación (web, email) en red pública | HTTPS, correo seguro |

> ⚠️ Al igual que con datos en reposo, **no se usa cifrado asimétrico para cifrar directamente los datos de red** — demasiado ineficiente. Se usa un **sistema de intercambio de claves**.

### Sobre digital (Digital Envelope) — Flujo de intercambio de claves

```
1. Alice obtiene clave pública RSA o ECC de Bob
   (normalmente a través del certificado digital de Bob)

2. Alice cifra su mensaje con cifrado de clave secreta (AES)
   → La clave secreta = CLAVE DE SESIÓN

3. Alice cifra la clave de sesión con la clave pública de Bob

4. Alice adjunta la clave de sesión cifrada al mensaje cifrado
   → Esto forma el SOBRE DIGITAL → se envía a Bob

5. Bob usa su CLAVE PRIVADA para descifrar la clave de sesión

6. Bob usa la clave de sesión para descifrar el mensaje
```

### Integridad y autenticidad en el transporte

**HMAC** (Hash-based Message Authentication Code / Código de Autenticación de Mensajes Basado en Hash):
- Combina la **clave secreta** (derivada del intercambio de claves) + **hash del mensaje**.
- Garantiza que el mensaje **no fue modificado** por alguien que no sea el remitente.

**AE** (Authenticated Encryption / Cifrado Autenticado):
- Modo de operación del cifrado simétrico.
- Garantiza simultáneamente **confidencialidad** + **integridad/autenticidad**.

> **👉 Enfoque de Examen SY0-701:** "¿Qué garantiza el HMAC?" → **Integridad y autenticidad** (NO confidencialidad). IPsec → VPN. TLS → HTTPS. Distractor: en el sobre digital, lo que se cifra asimétricamente es la **clave de sesión**, no el mensaje en sí.

## Secreto de Reenvío Perfecto (PFS)

> **Analogía:** Sin PFS es como usar siempre la misma llave maestra para todas las sesiones. Si alguien la copia, puede abrir todas las cajas pasadas y futuras. Con PFS, cada sesión usa una llave diferente que se destruye al terminar.

### El problema sin PFS

En el modelo básico de sobre digital, el intercambio de claves usa el par de claves del servidor para proteger el intercambio.

**Riesgo:** Si se grabaron datos de una sesión pasada y **luego** se compromete la clave privada del servidor → se puede descifrar retroactivamente la clave de sesión → recuperar todos los datos confidenciales de esa sesión grabada.

### PFS (Perfect Forward Secrecy / Secreto de Reenvío Perfecto)

- Usa el **acuerdo de claves Diffie-Hellman (D-H)** para crear **claves de sesión efímeras** (temporales/desechables).
- **Sin usar la clave privada del servidor** para el intercambio de claves.
- La autenticidad del servidor se demuestra mediante **firma digital** (separada del proceso de generación de clave).

### Protocolo Diffie-Hellman — Cómo funciona

```
Valores públicos acordados: p=23, g=9

Alice:                              Bob:
→ Elige secreto a=5                 → Elige secreto b=3
→ Calcula A = g^a mod p             → Calcula B = g^b mod p
→ A = 9^5 mod 23 = 8                → B = 9^3 mod 23 = 16
→ Envía A=8 a Bob                   → Envía B=16 a Alice

Cálculo del secreto compartido:
Alice: s = B^a mod p = 16^5 mod 23 = 6
Bob:   s = A^b mod p = 8^3 mod 23  = 6
→ ¡Ambos obtienen el mismo valor s=6! ✅

Mallory conoce: p, g, A, B → PERO no puede calcular s sin conocer a o b ✅
```

### Beneficios del PFS

- Compromiso **futuro** del servidor **no** compromete sesiones pasadas grabadas.
- Si un atacante obtiene la clave de **una sesión**, las demás permanecen confidenciales.
- Aumenta masivamente el trabajo criptográfico para recuperar una "conversación" completa.

### Implementaciones de PFS

| Implementación | Descripción |
|---|---|
| `DHE` (Diffie-Hellman Ephemeral) | PFS con aritmética modular (como el ejemplo anterior) |
| `ECDHE` (Elliptic Curve DHE) | PFS con curva elíptica — **implementación más habitual actualmente** |

> **👉 Enfoque de Examen SY0-701:** "¿Qué previene que el compromiso de la clave privada del servidor exponga sesiones pasadas?" → **PFS**. "¿Qué protocolo usa PFS?" → **DHE / ECDHE**. Distractor: PFS protege el **historial grabado**, no solo las sesiones futuras. ECDHE es la implementación más moderna y usada.

---

## Salting y Key Stretching

> **Analogía:** El salting es como añadir una huella dactilar única a cada contraseña antes de hashearla — aunque dos personas tengan la misma contraseña, sus hashes serán completamente diferentes.

### El problema de la baja entropía en contraseñas

- Los usuarios eligen contraseñas **predecibles** (baja entropía) por ser más fáciles de recordar.
- Las funciones hash son unidireccionales pero vulnerables a:
  - **Ataque de fuerza bruta:** Prueba todas las combinaciones posibles de letras, números y símbolos.
  - **Ataque de diccionario:** Genera hashes de palabras y frases comunes → busca coincidencias.
  - **Rainbow tables:** Tablas de hashes precalculados para multitud de contraseñas conocidas.

### Salting

**Salt / Valor de sal:** Valor **aleatorio único** añadido a la contraseña antes de calcular el hash.

```
Fórmula: (sal + contraseña) * SHA = hash
```

- Se debe generar un **salt único para cada cuenta de usuario**.
- El salt **no es secreto** — cualquier sistema que verifique el hash debe conocerlo.
- **Mitiga rainbow tables:** Obliga al atacante a recalcular hashes con el salt específico de cada contraseña.
- **Mitiga contraseñas idénticas:** Aunque dos usuarios tengan la misma contraseña, sus hashes serán diferentes.

### Key Stretching (Estiramiento de Claves)

- Toma una clave (de contraseña + salt) y la pasa por **miles de rondas de hashing** → produce una clave más larga y desordenada.
- **No fortalece la clave** intrínsecamente, pero **ralentiza el ataque** (el atacante debe replicar todo ese procesamiento extra para cada posible clave candidata).

**Implementación principal:**
- **PBKDF2** (Password-Based Key Derivation Function 2 / Función de Derivación de Claves Basada en Contraseñas 2):
  - Usado ampliamente para hash y almacenamiento de contraseñas.
  - Parte del estándar **WPA** (Wi-Fi Protected Access).

> **👉 Enfoque de Examen SY0-701:** "¿Qué previene los ataques de rainbow table?" → **Salting**. "¿Qué ralentiza los ataques de fuerza bruta contra contraseñas?" → **Key stretching**. "¿Qué estándar usa PBKDF2?" → **WPA**. Distractor: el salt **NO es secreto** — su función es hacer únicos los hashes, no ocultarse.


## Blockchain

> **Analogía:** La blockchain es como un libro contable escrito con tinta permanente donde cada página incluye una referencia criptográfica a la anterior. Cambiar cualquier página pasada haría que toda la cadena dejara de cuadrar — y todos los participantes lo notarían.

**Blockchain:** Concepto en el que una lista en **expansión continua** de registros transaccionales se asegura mediante el uso de **criptografía**.

### Estructura técnica de la Blockchain

- Cada registro = **bloque** (block).
- Cada bloque se procesa con una **función hash**.
- El **hash del bloque anterior** se agrega al cálculo del hash del siguiente bloque → **encadenamiento criptográfico**.
- Cada bloque **valida el hash del anterior** hasta el principio de la cadena → garantiza que **ninguna transacción histórica ha sido manipulada**.
- Cada bloque incluye: **marca de tiempo** + datos de las propias transacciones.

### Características de la Blockchain

| Característica | Descripción |
|---|---|
| **Open Public Ledger** (Libro público abierto) | El registro es público y visible para todos |
| **Descentralizada** | No existe como archivo único en una sola computadora |
| **Red P2P** (Peer-to-Peer / Punto a Punto) | Distribuida para mitigar riesgos de punto único de falla o compromiso |
| **Apertura** | Todos tienen la misma capacidad de ver todas las transacciones |
| **Confianza igualitaria** | Los usuarios de blockchain pueden confiar entre sí por igual |

### Aplicaciones potenciales de la Blockchain

- Integridad y transparencia de **transacciones financieras**
- **Contratos legales**
- **Protección de derechos de autor** y propiedad intelectual (PI)
- **Sistemas de votación** en línea
- **Sistemas de gestión de identidad**
- **Almacenamiento de datos** seguro

> **👉 Enfoque de Examen SY0-701:** "¿Qué propiedad de seguridad garantiza principalmente la blockchain?" → **Integridad** (y no repudio de transacciones). "¿Qué característica mitiga el punto único de falla?" → **Descentralización / red P2P**. Distractor: la blockchain **NO proporciona confidencialidad** por sí misma — es un libro público. La inmutabilidad proviene del encadenamiento de hashes.

## Ofuscación

> 🎭 **Analogía:** La ofuscación es como esconder el dinero dentro de un libro en la estantería. No lo cifras, solo lo haces difícil de encontrar. Por sí sola no es suficiente, pero combinada con otras técnicas puede ser útil.

**Ofuscación:** El arte de hacer que un mensaje o dato sea **difícil de encontrar**. Es una forma de "seguridad por oscuridad" — **generalmente obsoleta** por sí sola, pero con usos legítimos específicos.

### Técnica 1: Esteganografía (Steganography)

- Literalmente: "escritura oculta".
- Consiste en **incrustar información** dentro de una fuente inesperada.
  - Ejemplo: un mensaje oculto en una imagen.
- El archivo/documento contenedor = **covertext**.
- El mensaje **puede cifrarse** antes de incrustarlo → proporciona **confidencialidad**.
- Puede proporcionar **integridad o no repudio**:
  - Ejemplo: demostrar que algo se imprimió en un dispositivo concreto en un momento determinado → auténtico o falso, según el contexto.

### Técnica 2: Enmascaramiento de Datos (Data Masking)

- Todo o parte del contenido de un campo de BD se **redacta** (ej. sustituyendo por "x").
- **Supresión parcial:** Se preservan algunos metadatos para análisis.
  - Ejemplo: número de teléfono → se conserva el **prefijo de marcación**, se suprime el número de abonado.
- Puede preservar el **formato original** del campo.
- **Irreversible** en su forma básica.

### Técnica 3: Tokenización (Tokenization)

- Reemplaza todo o parte del valor de un campo de BD por un **token generado aleatoriamente**.
- El token se almacena con el valor original en un **servidor de tokens / bóveda de tokens** → **separado de la BD de producción**.
- Es **reversible**: una consulta/aplicación autorizada puede recuperar el valor original de la bóveda.
- Se usa como **sustituto del cifrado** desde una perspectiva regulatoria:
  - Un campo **cifrado** tiene el mismo valor regulatorio que los datos originales.
  - Un campo **tokenizado** ≠ datos originales → regulatoriamente son distintos → ventaja de cumplimiento.

### Comparativa técnicas de ofuscación

| Técnica | Reversible | Almacenamiento del original | Caso de uso principal |
|---|---|---|---|
| **Esteganografía** | Sí (con conocimiento del método) | En el covertext | Canales encubiertos, marcas de agua digitales |
| **Data Masking** | No (o parcialmente) | No se guarda | Entornos de desarrollo/prueba, análisis anónimo |
| **Tokenización** | Sí (con bóveda de tokens) | En bóveda separada | PCI-DSS, datos de tarjetas de crédito, cumplimiento normativo |

### Desidentificación

- **Data masking** + **tokenización** se usan para la **desidentificación**.
- **Desidentificación:** Ofuscar datos personales en bases de datos para que puedan **compartirse sin comprometer la privacidad**.

> **👉 Enfoque de Examen SY0-701:** "¿Qué técnica es reversible y almacena el valor original en un servidor separado?" → **Tokenización**. "¿Qué incrusta un mensaje en una imagen?" → **Esteganografía** (covertext). Diferencia clave: tokenización vs. cifrado — regulatoriamente un campo **tokenizado ≠ datos originales**; un campo **cifrado sí** equivale a los datos originales. Distractor: confundir data masking (no/parcialmente reversible) con tokenización (reversible).

# 4. Glosario

| Acrónimo | Significado (EN) | Significado (ES) | Función |
|---|---|---|---|
| **AES** | Advanced Encryption Standard | Estándar de Cifrado Avanzado | Cifrado simétrico masivo |
| **RSA** | Rivest, Shamir, Adelman | Rivest, Shamir, Adelman | Cifrado asimétrico (mín. 2048 bits) |
| **ECC** | Elliptic Curve Cryptography | Criptografía de Curva Elíptica | Asimétrico eficiente (256 bits ≈ RSA-3072) |
| **SHA** | Secure Hash Algorithm | Algoritmo de Hash Seguro | Hash de integridad |
| **SHA-256** | SHA variant 256 bits | SHA variante 256 bits | Hash estándar actual (256 bits) |
| **MD5** | Message Digest Algorithm #5 | Algoritmo de Resumen de Mensajes #5 | Hash débil (128 bits, solo compatibilidad) |
| **DSA** | Digital Signature Algorithm | Algoritmo de Firma Digital | Firma digital (ElGamal, FIPS) |
| **ECDSA** | Elliptic Curve DSA | Curva Elíptica DSA | Firma digital moderna (más usada) |
| **FIPS** | Federal Information Processing Standards | Normas Federales de Procesamiento de Información | Estándares del gobierno EE.UU. |
| **PKI** | Public Key Infrastructure | Infraestructura de Clave Pública | Framework de confianza con certificados |
| **CA** | Certificate Authority | Autoridad Certificadora | Valida identidad y emite certificados |
| **CSR** | Certificate Signing Request | Solicitud de Firma de Certificado | Solicitud del sujeto a la CA |
| **FQDN** | Fully Qualified Domain Name | Nombre de Dominio Completamente Calificado | Identificador completo del host |
| **CN** | Common Name | Nombre Común | Campo de certificado (en desuso para FQDN) |
| **SAN** | Subject Alternative Name | Nombre Alternativo del Sujeto | Campo moderno para identificación de servidor |
| **DN** | Distinguished Name | Nombre Distinguido | Identificador completo del sujeto en el certificado |
| **O** | Organization | Organización | Campo DN |
| **OU** | Organizational Unit | Unidad Organizativa | Campo DN |
| **L** | Locality | Localidad | Campo DN |
| **ST** | State | Estado | Campo DN |
| **C** | Country | País | Campo DN |
| **CRL** | Certificate Revocation List | Lista de Revocación de Certificados | Lista de certificados revocados/suspendidos |
| **OCSP** | Online Certificate Status Protocol | Protocolo de Estado de Certificados en Línea | Estado en tiempo real de un certificado |
| **KMIP** | Key Management Interoperability Protocol | Protocolo de Interoperabilidad de Gestión de Claves | Comunicación con servidor de gestión de claves |
| **TPM** | Trusted Platform Module | Módulo de Plataforma Confiable | Criptoprocesador para plataforma específica |
| **HSM** | Hardware Security Module | Módulo de Seguridad de Hardware | Criptoprocesador centralizado/portátil |
| **PRNG** | Pseudo-Random Number Generator | Generador de Números Pseudoaleatorios | Generación de números "aleatorios" por software |
| **TRNG** | True Random Number Generator | Generador de Números Aleatorios Verdaderos | Entropía real (ruido físico) |
| **API** | Application Programming Interface | Interfaz de Programación de Aplicaciones | Comunicación con criptoprocesador (PKCS#11) |
| **TEE** | Trusted Execution Environment | Entorno de Ejecución Confiable | Enclave seguro en memoria |
| **SGX** | Software Guard Extensions | Extensiones de Guardia de Software (Intel) | Implementación TEE de Intel |
| **PTT** | Platform Trust Technology | Tecnología de Confianza de Plataforma | TPM firmware de Intel |
| **KRA** | Key Recovery Agent | Agente de Recuperación de Claves | Cuenta con acceso a claves en custodia |
| **PKCS** | Public Key Cryptography Standards | Estándares de Criptografía de Clave Pública | Conjunto de estándares de RSA para PKI |
| **PKCS#1** | Public Key Cryptography Standard #1 | Estándar de Criptografía de Clave Pública #1 | Uso de RSA en firmas digitales |
| **PKCS#11** | — | — | API de comunicación con criptoprocesadores |
| **KEK** | Key Encryption Key | Clave de Cifrado de Clave | Clave asimétrica que cifra la DEK |
| **DEK** | Data Encryption Key | Clave de Cifrado de Datos | Clave simétrica que cifra los datos reales |
| **FDE** | Full Disk Encryption | Cifrado de Disco Completo | Cifra todo el disco (datos + metadatos + espacio libre) |
| **SED** | Self-Encrypting Drive | Unidad de Autocifrado | Disco con cifrado en firmware |
| **EFS** | Encrypting File System | Sistema de Archivos de Cifrado | Cifrado de archivos en Windows (requiere NTFS) |
| **NTFS** | New Technology File System | Sistema de Archivos de Nueva Tecnología | Sistema de archivos de Windows requerido por EFS |
| **DBMS** | Database Management System | Sistema de Gestión de Base de Datos | Media el acceso a BD |
| **SQL** | Structured Query Language | Lenguaje de Consulta Estructurado | Lenguaje de base de datos |
| **TDE** | Transparent Data Encryption | Cifrado de Datos Transparente | Cifrado a nivel BD en SQL Server |
| **WPA** | Wi-Fi Protected Access | Acceso Wi-Fi Protegido | Cifrado de tráfico inalámbrico |
| **VPN** | Virtual Private Network | Red Privada Virtual | Red privada sobre infraestructura pública |
| **IPsec** | Internet Protocol Security | Seguridad de Protocolo de Internet | VPN / cifrado entre dos puntos |
| **TLS** | Transport Layer Security | Seguridad de la Capa de Transporte | HTTPS / cifrado de datos de aplicación |
| **HMAC** | Hash-based Message Authentication Code | Código de Autenticación de Mensajes Basado en Hash | Integridad + autenticidad de mensajes |
| **AE** | Authenticated Encryption | Cifrado Autenticado | Modo simétrico: confidencialidad + integridad |
| **PFS** | Perfect Forward Secrecy | Secreto de Reenvío Perfecto | Protege sesiones pasadas aunque se comprometa la clave |
| **D-H** | Diffie-Hellman | Diffie-Hellman | Acuerdo de claves sin compartir la clave directamente |
| **DHE** | Diffie-Hellman Ephemeral | Diffie-Hellman Efímero | PFS con aritmética modular |
| **ECDHE** | Elliptic Curve DHE | DHE de Curva Elíptica | PFS en curva elíptica (implementación actual) |
| **PBKDF2** | Password-Based Key Derivation Function 2 | Función de Derivación de Claves Basada en Contraseñas 2 | Key stretching, usado en WPA |
| **P2P** | Peer-to-Peer | Punto a Punto | Red distribuida (blockchain) |
| **PI** | Intellectual Property | Propiedad Intelectual | Aplicación blockchain |
| **FIPS 140-2** | Federal Information Processing Standard 140-2 | Norma Federal de Procesamiento de Información 140-2 | Certificación de seguridad para HSMs |