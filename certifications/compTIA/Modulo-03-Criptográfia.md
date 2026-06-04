> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Conceptos Criptográficos](#1-conceptos-criptográficos)
  - [Terminología fundamental](#terminología-fundamental)
  - [Personajes estándar en criptografía (notación académica)](#personajes-estándar-en-criptografía-notación-académica)
  - [Tres tipos principales de algoritmos criptográficos](#tres-tipos-principales-de-algoritmos-criptográficos)
- [2. Cifrado Simétrico (Symmetric Encryption)](#2-cifrado-simétrico-symmetric-encryption)
  - [Algoritmos base: Sustitución y Transposición](#algoritmos-base-sustitución-y-transposición)
  - [Cómo funciona el cifrado simétrico](#cómo-funciona-el-cifrado-simétrico)
  - [Ventajas y limitaciones](#ventajas-y-limitaciones)
- [3. Longitud de la Clave](#3-longitud-de-la-clave)
  - [Fórmula del espacio de claves](#fórmula-del-espacio-de-claves)
  - [Tabla comparativa de longitudes](#tabla-comparativa-de-longitudes)
- [4. Cifrado Asimétrico (Asymmetric Encryption)](#4-cifrado-asimétrico-asymmetric-encryption)
  - [Funcionamiento del par de claves](#funcionamiento-del-par-de-claves)
  - [Flujo de cifrado asimétrico](#flujo-de-cifrado-asimétrico)
  - [Comparativa simétrico vs. asimétrico](#comparativa-simétrico-vs-asimétrico)
  - [Algoritmos asimétricos principales](#algoritmos-asimétricos-principales)
- [5. Hashing](#5-hashing)
  - [Características del hashing criptográfico](#características-del-hashing-criptográfico)
  - [Usos del hashing](#usos-del-hashing)
  - [Algoritmos de hashing principales](#algoritmos-de-hashing-principales)
- [6. Firmas Digitales](#6-firmas-digitales)
  - [Primitivo criptográfico vs. Conjunto de cifrado](#primitivo-criptográfico-vs-conjunto-de-cifrado)
  - [Cómo funciona una firma digital](#cómo-funciona-una-firma-digital)
    - [Propiedades garantizadas](#propiedades-garantizadas)
  - [Estándares de firma digital](#estándares-de-firma-digital)
- [7 Infraestructura de Clave Pública (PKI)](#7-infraestructura-de-clave-pública-pki)
  - [7.1. Autoridades Certificadoras (CA)](#71-autoridades-certificadoras-ca)
    - [El problema que resuelve la PKI](#el-problema-que-resuelve-la-pki)
    - [Funciones de una CA pública de terceros](#funciones-de-una-ca-pública-de-terceros)
    - [Ejemplos de CA de terceros](#ejemplos-de-ca-de-terceros)
    - [Flujo PKI completo](#flujo-pki-completo)
  - [7.2. Certificados Digitales](#72-certificados-digitales)
    - [Componentes de un certificado digital](#componentes-de-un-certificado-digital)
    - [Estándares de certificados](#estándares-de-certificados)
  - [7.3. Modelos de Confianza y Raíz de Confianza](#73-modelos-de-confianza-y-raíz-de-confianza)
    - [Certificado raíz](#certificado-raíz)
    - [Modelos de PKI](#modelos-de-pki)
      - [Modelo 1: CA Única (Single CA)](#modelo-1-ca-única-single-ca)
      - [Modelo 2: CA Jerárquica (Modelo de Terceros)](#modelo-2-ca-jerárquica-modelo-de-terceros)
      - [Modelo 3: Certificados Autofirmados (Self-Signed)](#modelo-3-certificados-autofirmados-self-signed)
  - [7.4. Solicitudes de Firma de Certificados (CSR)](#74-solicitudes-de-firma-de-certificados-csr)
    - [Proceso de registro y emisión](#proceso-de-registro-y-emisión)
  - [7.5. Atributos del Nombre del Sujeto](#75-atributos-del-nombre-del-sujeto)
    - [Campo CN (Common Name / Nombre Común)](#campo-cn-common-name--nombre-común)
    - [Campo SAN (Subject Alternative Name / Nombre Alternativo del Sujeto)](#campo-san-subject-alternative-name--nombre-alternativo-del-sujeto)
    - [Tipos de SAN](#tipos-de-san)
    - [Campos del nombre distinguido (DN)](#campos-del-nombre-distinguido-dn)
  - [7.6. Revocación de Certificados CRL y OCSP](#76-revocación-de-certificados-crl-y-ocsp)
    - [Estados de un certificado](#estados-de-un-certificado)
    - [Razones de revocación](#razones-de-revocación)
    - [CRL (Certificate Revocation List / Lista de Revocación de Certificados)](#crl-certificate-revocation-list--lista-de-revocación-de-certificados)
    - [OCSP (Online Certificate Status Protocol / Protocolo de Estado de Certificados en Línea)](#ocsp-online-certificate-status-protocol--protocolo-de-estado-de-certificados-en-línea)
  - [7.7. Gestión de Claves](#77-gestión-de-claves)
    - [Ciclo de vida de una clave](#ciclo-de-vida-de-una-clave)
    - [Modelos de gestión de claves](#modelos-de-gestión-de-claves)
    - [KMIP (Key Management Interoperability Protocol / Protocolo de Interoperabilidad de Gestión de Claves)](#kmip-key-management-interoperability-protocol--protocolo-de-interoperabilidad-de-gestión-de-claves)
  - [7.8. Criptoprocesadores y Enclaves Seguros](#78-criptoprocesadores-y-enclaves-seguros)
    - [Problemas del almacenamiento de claves en sistema de archivos](#problemas-del-almacenamiento-de-claves-en-sistema-de-archivos)
    - [TPM (Trusted Platform Module / Módulo de Plataforma Confiable)](#tpm-trusted-platform-module--módulo-de-plataforma-confiable)
    - [HSM (Hardware Security Module / Módulo de Seguridad de Hardware)](#hsm-hardware-security-module--módulo-de-seguridad-de-hardware)
    - [PKCS#11](#pkcs11)
    - [Enclave Seguro (Secure Enclave / TEE)](#enclave-seguro-secure-enclave--tee)
    - [Resumen comparativo TPM vs. HSM](#resumen-comparativo-tpm-vs-hsm)
  - [7.9. Custodia de Claves](#79-custodia-de-claves)
    - [El problema de las copias de seguridad de claves](#el-problema-de-las-copias-de-seguridad-de-claves)
    - [Soluciones: Custodia y Control M de N](#soluciones-custodia-y-control-m-de-n)
    - [División de claves](#división-de-claves)
- [8 Soluciones Criptográficas](#8-soluciones-criptográficas)
  - [8.1. Cifrado que Respalda la Confidencialidad](#81-cifrado-que-respalda-la-confidencialidad)
    - [Estados de los datos](#estados-de-los-datos)
    - [Cifrado masivo (Bulk Encryption)](#cifrado-masivo-bulk-encryption)
    - [Esquema híbrido para cifrado de datos](#esquema-híbrido-para-cifrado-de-datos)
  - [8.2. Cifrado de Archivos y Discos](#82-cifrado-de-archivos-y-discos)
    - [Niveles de cifrado de datos en reposo](#niveles-de-cifrado-de-datos-en-reposo)
    - [FDE (Full Disk Encryption / Cifrado de Disco Completo)](#fde-full-disk-encryption--cifrado-de-disco-completo)
    - [Cifrado de particiones](#cifrado-de-particiones)
    - [Cifrado de volúmenes](#cifrado-de-volúmenes)
    - [Cifrado de archivos individuales](#cifrado-de-archivos-individuales)
  - [8.3. Cifrado de Base de Datos](#83-cifrado-de-base-de-datos)
    - [Estructura de una base de datos](#estructura-de-una-base-de-datos)
    - [Niveles de cifrado en BD](#niveles-de-cifrado-en-bd)
      - [Nivel 1: Cifrado de Base de Datos (TDE)](#nivel-1-cifrado-de-base-de-datos-tde)
      - [Nivel 2: Cifrado de Celda/Columna](#nivel-2-cifrado-de-celdacolumna)
      - [Nivel 3: Cifrado a Nivel de Registro/Fila](#nivel-3-cifrado-a-nivel-de-registrofila)
    - [Comparativa de niveles de cifrado en BD](#comparativa-de-niveles-de-cifrado-en-bd)
  - [8.4. Cifrado de Transporte e Intercambio de Claves](#84-cifrado-de-transporte-e-intercambio-de-claves)
    - [Protocolos de cifrado de transporte](#protocolos-de-cifrado-de-transporte)
    - [Sobre digital (Digital Envelope) — Flujo de intercambio de claves](#sobre-digital-digital-envelope--flujo-de-intercambio-de-claves)
    - [Integridad y autenticidad en el transporte](#integridad-y-autenticidad-en-el-transporte)
  - [8.5. Secreto de Reenvío Perfecto (PFS)](#85-secreto-de-reenvío-perfecto-pfs)
    - [El problema sin PFS](#el-problema-sin-pfs)
    - [PFS (Perfect Forward Secrecy / Secreto de Reenvío Perfecto)](#pfs-perfect-forward-secrecy--secreto-de-reenvío-perfecto)
    - [Protocolo Diffie-Hellman — Cómo funciona](#protocolo-diffie-hellman--cómo-funciona)
    - [Ventajas del PFS](#ventajas-del-pfs)
    - [Implementaciones de PFS](#implementaciones-de-pfs)
  - [8.6. Salting y Key Stretching](#86-salting-y-key-stretching)
    - [El problema de la baja entropía en contraseñas](#el-problema-de-la-baja-entropía-en-contraseñas)
    - [Salting](#salting)
    - [Key Stretching (Estiramiento de Claves)](#key-stretching-estiramiento-de-claves)
  - [8.7. Blockchain](#87-blockchain)
    - [Conceptos clave de Blockchain](#conceptos-clave-de-blockchain)
    - [Características de la Blockchain](#características-de-la-blockchain)
    - [Aplicaciones potenciales](#aplicaciones-potenciales)
  - [8.8. Ofuscación](#88-ofuscación)
    - [Concepto](#concepto)
    - [Técnicas de ofuscación](#técnicas-de-ofuscación)
      - [1. Esteganografía (Steganography)](#1-esteganografía-steganography)
      - [2. Enmascaramiento de datos (Data Masking)](#2-enmascaramiento-de-datos-data-masking)
      - [3. Tokenización (Tokenization)](#3-tokenización-tokenization)
    - [Tabla comparativa de técnicas de ofuscación](#tabla-comparativa-de-técnicas-de-ofuscación)
    - [Desidentificación](#desidentificación)
- [9 Gestión de claves](#9-gestión-de-claves)
  - [10 Criptoprocesadores y enclaves seguros](#10-criptoprocesadores-y-enclaves-seguros)
    - [TPM vs. HSM](#tpm-vs-hsm)
    - [Custodia de Claves y Recuperación](#custodia-de-claves-y-recuperación)
    - [Enclaves Seguros](#enclaves-seguros)
- [11. Custodia de Claves (Key Escrow)](#11-custodia-de-claves-key-escrow)
- [12 Ofuscación](#12-ofuscación)
    - [Esteganografía](#esteganografía)
    - [Enmascaramiento de Datos (Data Masking)](#enmascaramiento-de-datos-data-masking)
    - [Tokenización](#tokenización)
- [13 Cifrado que Respalda la Confidencialidad](#13-cifrado-que-respalda-la-confidencialidad)
    - [Los Tres Estados de los Datos](#los-tres-estados-de-los-datos)
    - [El Esquema de Cifrado Estándar (Confidencialidad de Archivos)](#el-esquema-de-cifrado-estándar-confidencialidad-de-archivos)
    - [Cifrado de Archivos y Discos](#cifrado-de-archivos-y-discos)
    - [Cifrado de Bases de Datos](#cifrado-de-bases-de-datos)
    - [Cifrado de Transporte e Intercambio de Claves](#cifrado-de-transporte-e-intercambio-de-claves)
    - [Secreto de Reenvío Perfecto (Perfect Forward Secrecy - PFS)](#secreto-de-reenvío-perfecto-perfect-forward-secrecy---pfs)
    - [Protección de Contraseñas (Salting y Stretching)](#protección-de-contraseñas-salting-y-stretching)
- [14 Blockchain (Cadena de Bloques)](#14-blockchain-cadena-de-bloques)
    - [Componentes de Seguridad en Blockchain](#componentes-de-seguridad-en-blockchain)
- [15. Glosario](#15-glosario)

---

# 1. Conceptos Criptográficos

**Criptografía** = "escritura secreta" → arte de asegurar información **codificándola**.

- **Opuesto** a la *Seguridad a través de la oscuridad* (ocultar el secreto en lugar de cifrarlo).
- Con criptografía: aunque todos conozcan la existencia y ubicación del dato, **sin la clave no pueden entenderlo**.

> **Analogía:** La criptografía es como una caja fuerte de cristal: todos saben que existe y dónde está, pero sin la combinación (clave) nadie puede abrirla. La "seguridad por oscuridad" sería esconder la caja fuerte debajo de una alfombra — eso sí puede descubrirse.

## Terminología fundamental

| Término | Definición |
|---|---|
| **Texto plano / Texto claro** | Mensaje sin cifrar |
| **Texto cifrado** | Mensaje encriptado |
| **Algoritmo** | Proceso utilizado para cifrar y descifrar |
| **Criptoanálisis** | Arte de descifrar sistemas criptográficos |

## Personajes estándar en criptografía (notación académica)

| Personaje | Rol |
|---|---|
| **Alicia (Alice)** | Remitente del mensaje genuino |
| **Bob** | Destinatario previsto |
| **Mallory** | Atacante malicioso que intenta subvertir el mensaje |

## Tres tipos principales de algoritmos criptográficos

```
1. Hash          → Integridad
2. Simétrico     → Confidencialidad
3. Asimétrico    → Confidencialidad + Autenticación + No repudio
```

**Las tres familias de algoritmos criptográficos:**

Existen tres familias o tipos principales de algoritmos criptográficos

```
              ┌───────────────────────────────┐
              │   Algoritmos Criptográficos   │
              └───────────────┬───────────────┘
     ┌────────────────────────┼───────────────────────┐
┌────┴────────┐      ┌────────┴───────┐      ┌────────┴────────┐
│  Simétrico  │      │   Asimétrico   │      │    Hashing      │
│(misma clave)│      │(clave pública/ │      │  (integridad)   │
│             │      │   privada)     │      │                 │
└─────────────┘      └────────────────┘      └─────────────────┘
```


> **👉 Enfoque de Examen SY0-701:** CompTIA pregunta frecuentemente cuál propiedad de seguridad (CIA + no repudio) garantiza cada tipo de algoritmo. **Distractor común:** confundir el hash con cifrado — el hash es **unidireccional** y no cifra, solo verifica integridad. Recuerda que el cifrado **simétrico solo no puede proporcionar autenticación ni no repudio**.

# 2. Cifrado Simétrico (Symmetric Encryption)

> 🔑 **Analogía:** Imagina una caja con llave donde Alice y Bob tienen la misma llave copiada. El problema: ¿cómo se pasan la copia de la llave sin que Mallory la intercepte?

## Algoritmos base: Sustitución y Transposición

| Técnica | Descripción | Ejemplo |
|---|---|---|
| **Sustitución** | Reemplaza caracteres del texto plano por otros | `ROT13`: A→N, B→O… "Hello World" → "Uryyb Jbeyq" |
| **Transposición** | Las unidades permanecen iguales pero cambia su **orden** | "HELLOWORLD" → columnas → "HLOOLELWRD" |

> Los algoritmos modernos combinan sustitución + transposición en formas complejas para frustrar el criptoanálisis.

## Cómo funciona el cifrado simétrico

```
1. Alice y Bob acuerdan cifrado + valor de clave secreta (compartida)
2. Alice cifra el archivo con la clave
3. Alice envía SOLO el texto cifrado
4. Bob descifra usando la MISMA clave secreta
```

## Ventajas y limitaciones

| Ventaja | Limitación |
|---|---|
| Muy **rápido** | Problema de distribución de la clave |
| Ideal para **cifrado masivo** de grandes volúmenes | Si Mallory intercepta la clave → seguridad comprometida |
| — | **No sirve para autenticación ni integridad** (ambas partes conocen la misma clave) |

> **👉 Enfoque de Examen SY0-701:** Pregunta clásica: "¿Puede el cifrado simétrico proporcionar autenticación?" → **NO**. Ambas partes comparten la misma clave, por lo que cualquiera puede generar el mismo texto cifrado. Distractor: confundir velocidad (simétrico = rápido) con seguridad total.

# 3. Longitud de la Clave

- **Espacio de claves:** Rango de todos los valores posibles de la clave.
  - Ejemplo ROT13: espacio de claves = 25 (ROT1 a ROT25). ROT0 y ROT26+ = **claves débiles**.
- **Criptoanálisis de fuerza bruta:** Probar cada valor de clave posible hasta encontrar el texto plano.
- La **longitud de la clave** se expresa en bits y determina el tamaño del espacio de claves.

> **Analogía:** La longitud de clave es como el número de dígitos de una combinación. Una cerradura de 3 dígitos (1000 combinaciones) es mucho más fácil de forzar que una de 10 dígitos (10.000.000.000 combinaciones).

## Fórmula del espacio de claves

```
Espacio de claves = 2^(longitud en bits)

AES-128 → 2^128 posibles claves
AES-256 → 2^256 posibles claves
```

> ⚠️ AES-256 NO es el doble de seguro que AES-128 — es **muchos billones de veces más resistente** a fuerza bruta.

## Tabla comparativa de longitudes

| Algoritmo | Longitud de Clave | Espacio de Claves |
|---|---|---|
| `AES-128` | 128 bits | 2¹²⁸ |
| `AES-256` | 256 bits | 2²⁵⁶ |
| `RSA` (aceptable) | 2048 bits | — |
| `ECC` (equivalente a RSA-3072) | 256 bits | — |

**Inconveniente de claves largas:** Mayor consumo de memoria y ciclos de procesador.

> **👉 Enfoque de Examen SY0-701:** CompTIA suele preguntar cuál clave es equivalente en seguridad. Memoriza: **ECC-256 ≈ RSA-3072**. Pregunta trampa: "AES-256 es el doble de seguro que AES-128" → **FALSO**, la diferencia es exponencial, no lineal.

# 4. Cifrado Asimétrico (Asymmetric Encryption)

> **Analogía:** Es como un buzón con ranura pública y llave privada. Cualquiera puede meter un sobre (cifrar con clave pública), pero solo el dueño del buzón puede sacarlo (descifrar con clave privada).

## Funcionamiento del par de claves

- **Clave pública:** Distribuible libremente. Usada para **cifrar**.
- **Clave privada:** Solo la conoce el propietario. Usada para **descifrar**.
- Las claves son **matemáticamente relacionadas** pero es **computacionalmente imposible** derivar la privada desde la pública.

## Flujo de cifrado asimétrico

```
1. Bob genera par de claves → guarda privada, publica la pública
2. Alice obtiene clave pública de Bob
3. Alice cifra mensaje con clave pública de Bob
4. Alice envía texto cifrado
5. Bob descifra con su clave privada
6. Mallory puede interceptar texto cifrado + clave pública → PERO NO puede descifrar
```

## Comparativa simétrico vs. asimétrico

| Característica | Simétrico | Asimétrico |
|---|---|---|
| Número de claves | 1 (compartida) | 2 (pública + privada) |
| Velocidad | **Rápido** | **Lento** (sobrecarga computacional) |
| Uso principal | Cifrado masivo de datos | Intercambio de claves, autenticación |
| Distribución | Problemática | Fácil (clave pública es pública) |
| Autenticación | No | Sí |

## Algoritmos asimétricos principales

| Algoritmo | Longitud de Clave Mínima Recomendada |
|---|---|
| `RSA` (Rivest, Shamir, Adelman) | **2048 bits** |
| `ECC` (Criptografía de Curva Elíptica) | **256 bits** (equivale a RSA-3072) |

> **Uso híbrido:** El cifrado asimétrico cifra una **clave de sesión simétrica**. La clave simétrica cifra los datos masivos. Esto combina lo mejor de ambos mundos.

> **👉 Enfoque de Examen SY0-701:** Pregunta frecuente: "¿Qué tipo de cifrado se usa para el intercambio de claves?" → **Asimétrico**. "¿Qué tipo se usa para cifrar grandes volúmenes?" → **Simétrico**. Distractor: pensar que el asimétrico "también puede cifrar datos masivos" — técnicamente sí, pero es **ineficiente** y no se usa así en la práctica.

# 5. Hashing

> **Analogía:** El hash es como la huella dactilar de un archivo. No importa el tamaño del archivo — siempre produce una "huella" de tamaño fijo. Si cambias un solo píxel de una imagen, la huella cambia completamente.

## Características del hashing criptográfico

- Produce una cadena de bits de **longitud fija** desde cualquier entrada de longitud variable.
- También llamado: **hash**, **resumen de mensaje** o **message digest**.
- **Propiedades fundamentales:**
  - **Unidireccional:** Imposible recuperar el texto plano desde el hash.
  - **Sin colisiones:** Entradas diferentes producen salidas diferentes (una colisión = fallo de seguridad).

## Usos del hashing

**Verificación de contraseñas:**
```
1. Bob almacena el hash de la contraseña de Alice
2. Alice escribe contraseña → se convierte en hash → se envía el hash
3. Bob compara hashes → si coinciden, autenticación exitosa
4. Bob NUNCA conoce la contraseña en texto plano
```

**Verificación de integridad de archivos:**
```
1. Alice publica archivo + hash de referencia en su sitio
2. Bob descarga el archivo
3. Bob calcula el hash del archivo descargado
4. Bob compara con el hash de referencia
   → Coincide: archivo íntegro ✅
   → No coincide: archivo manipulado ❌ (Mallory sustituyó el archivo)
```

## Algoritmos de hashing principales

| Algoritmo | Tamaño del Resumen | Seguridad |
|---|---|---|
| `SHA` (Secure Hash Algorithm) | Variable | **Más fuerte** |
| `SHA-256` | 256 bits | **Recomendado** |
| `MD5` (Message Digest Algorithm 5) | 128 bits | **Débil** — solo para compatibilidad |

> **👉 Enfoque de Examen SY0-701:** Pregunta clásica: "¿Qué propiedad garantiza el hashing?" → **Integridad**. Distractor: "¿Puede un hash proporcionar confidencialidad?" → **NO**, es unidireccional pero no cifra. Otra trampa: MD5 sigue siendo válido para *compatibilidad* pero NO para seguridad. SHA-256 es el estándar actual.

# 6. Firmas Digitales

> **Analogía:** Una firma digital es como una firma notarial que: (1) solo tú puedes hacer con tu propio sello (autenticación), y (2) cualquier cambio en el documento después de firmar lo invalida (integridad).

## Primitivo criptográfico vs. Conjunto de cifrado

- **Primitivo criptográfico:** Una sola función (hash, simétrico o asimétrico) usada de forma aislada.
- **Conjunto de cifrado:** Combinación de múltiples primitivos para formar un sistema completo.

## Cómo funciona una firma digital

```
FIRMA (Alice):
1. Alice calcula el hash del mensaje (ej. SHA-256)
2. Alice firma el hash con su CLAVE PRIVADA (cifrado asimétrico)
3. Alice adjunta la firma digital al mensaje y lo envía a Bob

VERIFICACIÓN (Bob):
3. Bob verifica la firma con la CLAVE PÚBLICA de Alice → obtiene hash original
4. Bob calcula su propio hash del documento recibido
5. Compara los dos hashes:
   → Iguales: datos íntegros + Alice autenticada ✅
   → Diferentes: datos manipulados o firma falsa ❌
```

### Propiedades garantizadas

| Primitivo usado | Propiedad garantizada |
|---|---|
| Hash | **Integridad** |
| Clave privada (firma) | **Autenticación + No repudio** |
| Combinación | **Integridad + Autenticación + No repudio** |

## Estándares de firma digital

| Estándar | Algoritmo base | Notas |
|---|---|---|
| `PKCS#1` | RSA | Estándar de Criptografía de Clave Pública #1 |
| `DSA` (Digital Signature Algorithm) | ElGamal | Parte de FIPS (Normas Federales de EE.UU.) |
| `ECDSA` (Elliptic Curve DSA) | Curva Elíptica | **Más ampliamente usado actualmente** |

> **FIPS:** Normas Federales de Procesamiento de Información del gobierno de EE.UU.

> **👉 Enfoque de Examen SY0-701:** Pregunta frecuente: "¿Qué combina hash + cifrado asimétrico?" → **Firma digital**. Distractor: pensar que la firma digital cifra el mensaje para confidencialidad — **NO**, solo firma el hash para integridad/autenticación. El mensaje en sí puede ir en claro. ECDSA es el más moderno, recuérdalo sobre DSA.

# 7 Infraestructura de Clave Pública (PKI)

> **Analogía:** PKI es como el sistema de notarías del mundo digital. Un notario (CA) verifica tu identidad y te emite un documento oficial (certificado digital) que otros pueden consultar para confiar en ti.

**PKI** (Public Key Infrastructure / Infraestructura de Clave Pública): Framework que establece confianza en el uso de criptografía de clave pública mediante **certificados digitales**.

- Un **certificado digital** = afirmación pública de identidad, validada por una **CA** (Autoridad Certificadora / Certificate Authority).

## 7.1. Autoridades Certificadoras (CA)

### El problema que resuelve la PKI

> Sin PKI, cualquiera podría publicar una clave pública haciéndose pasar por tu banco. ¿Cómo sabes que la clave pública que recibes es genuina?

- **Clave pública para cifrado:** Cualquiera te envía mensajes que solo tú (con tu clave privada) puedes leer.
- **Clave privada para firma:** Firmas mensajes; otros verifican con tu clave pública.
- **Problema:** No hay mecanismo para probar que el dueño de la clave es quien dice ser → **PKI lo resuelve**.

### Funciones de una CA pública de terceros

- Proveer servicios de certificados útiles a la comunidad.
- **Validar la identidad** de quienes solicitan certificados (registro).
- Establecer confianza con usuarios, gobiernos, reguladores e instituciones.
- Administrar **repositorios** que almacenan y gestionan certificados.
- **Gestión del ciclo de vida**: especialmente la revocación de certificados no válidos.

### Ejemplos de CA de terceros

```
Comodo | DigiCert | GeoTrust | IdenTrust | Let's Encrypt
```

### Flujo PKI completo

```
1. CA genera certificado raíz → lo firma con su clave privada → publica clave pública
2. Cliente obtiene certificado raíz → lo añade a su almacén de certificados de confianza
3. Servidor web crea CSR (Certificate Signing Request) → lo envía a la CA
4. CA genera certificado firmado → lo devuelve al servidor
5. Cliente verifica certificado del servidor → valida firma de CA confiable
6. Se establece conexión cifrada de confianza
```

> **👉 Enfoque de Examen SY0-701:** Pregunta clásica: "¿Qué valida la identidad en una PKI?" → **La CA**. Distractor: confundir el certificado con la clave pública — el certificado **contiene** la clave pública más la identidad validada por la CA.

## 7.2. Certificados Digitales

> **Analogía:** Un certificado digital es como un pasaporte: contiene tu foto (clave pública), tus datos personales (información del sujeto), y el sello oficial del gobierno (firma de la CA).

### Componentes de un certificado digital

- **Clave pública del sujeto** (elemento principal)
- Información sobre el **sujeto** (persona u organización)
- Información sobre el **emisor** (la CA)
- **Firma digital** de la CA (prueba de autenticidad)

El sujeto puede ser:
- Un usuario humano (ej. para firmar mensajes de correo)
- Un servidor informático (ej. servidor web con transacciones)

### Estándares de certificados

| Estándar | Organismo | Descripción |
|---|---|---|
| `X.509` | UIT + IETF (RFC 5280) | Estándar base para certificados digitales |
| `PKCS` (Public Key Cryptography Standards) | RSA | Conjunto de estándares para promover el uso de PKI |

> **👉 Enfoque de Examen SY0-701:** Memoriza `X.509` como el estándar de certificados y `RFC 5280` como su referencia IETF. PKCS es el conjunto de estándares de RSA para PKI.

## 7.3. Modelos de Confianza y Raíz de Confianza

> **Analogía:** La raíz de confianza es como el registro de nacimiento del sistema. Todo parte de ahí. Si la raíz está comprometida, todo el árbol de confianza colapsa.

### Certificado raíz

- Cada CA **se emite un certificado a sí misma** → **certificado autofirmado** → **certificado raíz**.
- Tamaño de clave: `RSA 2048 o 4096 bits` o equivalente `ECC`.
- Sujeto: nombre de la organización/CA (ej. `"CompTIA Root CA"`).
- Instalar el certificado raíz de una CA = **confiar automáticamente en todos los certificados que firme esa CA**.

### Modelos de PKI

#### Modelo 1: CA Única (Single CA)

```
[CA Raíz] ──────────────────→ [Usuarios/Equipos]
```

- Usado en **redes privadas**.
- **Problema:** Si el servidor CA es comprometido → **toda la PKI colapsa**.

#### Modelo 2: CA Jerárquica (Modelo de Terceros)

```
[CA Raíz]
    ↓
[CA Intermedia 1] → [Certificados de hoja/entidad final]
[CA Intermedia 2] → [Certificados de hoja/entidad final]
```

- La CA raíz emite a **CA intermedias**.
- Las CA intermedias emiten a los **sujetos** (hojas / entidades finales).
- **Ventaja:** Diferentes políticas de certificados por CA intermedia.
- Cada certificado de hoja se rastrea hasta la raíz → **encadenamiento de certificados** o **cadena de confianza**.

#### Modelo 3: Certificados Autofirmados (Self-Signed)

- Cualquier equipo, servidor o programa puede implementar un certificado autofirmado.
- Ejemplos de uso: routers domésticos, entornos de desarrollo/prueba.
- El SO o navegador los marca como **no confiables** (el usuario puede anularlo).
- **No deben usarse** para proteger hosts y aplicaciones críticas.

> **👉 Enfoque de Examen SY0-701:** Pregunta frecuente: "¿Qué es la cadena de confianza?" → Ruta de certificación desde el certificado de hoja hasta la CA raíz. Distractor: confundir "certificado autofirmado" con "certificado raíz" — ambos son autofirmados, pero el raíz lo emite una CA oficial mientras que el autofirmado lo emite cualquier entidad sin validación.

## 7.4. Solicitudes de Firma de Certificados (CSR)

> **Analogía:** Solicitar un certificado es como solicitar tu DNI: debes presentar tus datos, que el organismo los verifique, y entonces te emiten el documento oficial sellado.

### Proceso de registro y emisión

```
1. Usuario crea cuenta con la CA → obtiene autorización
2. Sujeto genera par de claves (RSA o ECC + longitud elegida)
   → Clave privada: se guarda de forma segura (solo el sujeto la conoce)
3. Sujeto genera CSR (Certificate Signing Request) → contiene su clave pública + info del sujeto
4. CSR se envía a la CA
5. CA verifica:
   → Para servidores web: nombre del sujeto = FQDN (Fully Qualified Domain Name)
   → Verifica que el solicitante es el responsable del dominio (registros WHOIS)
6. CA acepta → firma el certificado → lo devuelve al sujeto
```

**CSR (Certificate Signing Request / Solicitud de Firma de Certificado):** Archivo que contiene la información que el sujeto quiere en el certificado, incluyendo su clave pública.

**FQDN (Fully Qualified Domain Name / Nombre de Dominio Completamente Calificado):** Nombre completo de un host en internet (ej. `www.ejemplo.com`).

> **👉 Enfoque de Examen SY0-701:** Pregunta sobre el proceso: el sujeto **genera su propio par de claves** y envía la CSR con la **clave pública** — nunca envía la privada a la CA. La CA valida la identidad antes de firmar.

## 7.5. Atributos del Nombre del Sujeto

### Campo CN (Common Name / Nombre Común)

- Uso original: identificar el **FQDN** del servidor (ej. `www.comptia.org`).
- Actualmente **en desuso** como método primario de validación de identidad.
- Un navegador moderno ignora el CN si existe un campo SAN.

### Campo SAN (Subject Alternative Name / Nombre Alternativo del Sujeto)

- **Estándar actual** para identificar el servidor.
- Puede contener: **FQDN**, **direcciones IP**, **emails**.
- El navegador debe validar el SAN e ignorar el CN.
- Permite que un certificado represente **varios subdominios**.

### Tipos de SAN

| Tipo | Descripción | Ejemplo |
|---|---|---|
| Subdominios específicos | Lista explícita de subdominios | `www.comptia.org`, `members.comptia.org` |
| **Dominio comodín (Wildcard)** | Cubre todos los subdominios de un nivel | `*.comptia.org` → válido para `www.`, `members.`, etc. |
| Email (RFC 822) | Para certificados de correo electrónico | `usuario@empresa.com` |
| Firma de código | Para verificar editores/desarrolladores de software | No usa SAN; la CA valida datos org. |

### Campos del nombre distinguido (DN)

```
CN=www.example.com, OU=Web Hosting, O=Example LLC, L=Chicago, ST=Illinois, C=US
```

| Campo | Significado |
|---|---|
| `CN` | Common Name (Nombre común) |
| `OU` | Organizational Unit (Unidad Organizativa) |
| `O` | Organization (Organización) |
| `L` | Locality (Localidad) |
| `ST` | State (Estado) |
| `C` | Country (País) |

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué campo usa un certificado para identificar múltiples subdominios?" → **SAN**. Trampa: el CN está **en desuso** para validación. Diferencia clave: certificado **comodín** (`*.dominio.com`) vs. certificados de **subdominio específico** — el comodín cubre un nivel, no recursivo.

## 7.6. Revocación de Certificados CRL y OCSP

> **Analogía:** La revocación de un certificado es como cancelar una tarjeta de crédito robada. El banco (CA) avisa a todos los comercios (clientes) que esa tarjeta ya no es válida.

### Estados de un certificado

| Estado | Descripción |
|---|---|
| **Válido** | Certificado activo y confiable |
| **Revocado** | Inválido de forma **permanente** — no puede restaurarse |
| **Suspendido** | Inválido **temporalmente** — puede reactivarse |

### Razones de revocación

- Clave privada comprometida
- Empresa cerrada
- Usuario dejó la empresa
- Nombre de dominio modificado
- Certificado mal utilizado
- Cese de operaciones

### CRL (Certificate Revocation List / Lista de Revocación de Certificados)

- Lista que mantiene la CA con **todos los certificados revocados/suspendidos**.
- Debe ser accesible para cualquier usuario que confíe en la CA.
- Cada certificado contiene info sobre **cómo verificar la CRL**.

**Atributos de una CRL:**

| Atributo | Descripción |
|---|---|
| **Período de publicación** | Fecha/hora de publicación (suele ser automática) |
| **Puntos de distribución** | Ubicaciones donde se publica la CRL |
| **Período de validez** | Tiempo durante el que la CRL es autoritativa (ligeramente mayor al período de publicación) |
| **Firma** | La CRL está firmada por la CA para verificar autenticidad |

**Riesgo de la CRL:** Un certificado puede haber sido revocado pero ser aceptado si no se publicó una CRL actualizada.

### OCSP (Online Certificate Status Protocol / Protocolo de Estado de Certificados en Línea)

- Alternativa más actualizada a la CRL.
- Verifica el **estado individual** de un certificado (no toda la lista).
- Puede consultar la base de datos en **tiempo real** o depender de la CRL.
- Los detalles del servicio OCSP deben publicarse en el certificado.

| Mecanismo | Funciona con | Ventaja | Limitación |
|---|---|---|---|
| **CRL** | Lista descargada | Compatible con todo | Puede quedar desactualizada |
| **OCSP** | Consulta en tiempo real | Más actualizado | Depende del servidor OCSP |

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué mecanismo proporciona el estado más actualizado de un certificado?" → **OCSP**. Trampa: un certificado revocado puede seguir siendo aceptado si la CRL no se ha actualizado → riesgo de seguridad real. Recuerda que la CRL es descargada periódicamente, no en tiempo real.

## 7.7. Gestión de Claves

> **Analogía:** Gestionar claves es como gestionar las llaves físicas de una empresa: hay que crearlas, guardarlas seguras, retirarlas cuando caducan o se pierden, y a veces tener copias de seguridad en una caja fuerte separada.

### Ciclo de vida de una clave

| Etapa | Descripción |
|---|---|
| **Generación** | Crear par de claves asimétricas o clave secreta simétrica con la fuerza requerida |
| **Almacenamiento** | Prevenir acceso no autorizado + proteger contra pérdidas/daños |
| **Revocación** | Prevenir uso si la clave se compromete; datos cifrados deben re-cifrarse con nueva clave |
| **Caducidad y renovación** | Período de validez determinado; renovación con mismo o nuevo par de claves |

### Modelos de gestión de claves

| Modelo | Descripción | Ventaja | Desventaja |
|---|---|---|---|
| **Descentralizado** | Claves generadas/administradas en el propio equipo/cuenta | Fácil de implementar, sin configuración especial | Dificulta detección de compromisos |
| **Centralizado** | Servidor o dispositivo dedicado para generar/almacenar claves | Mejor control y auditoría | Mayor complejidad |

### KMIP (Key Management Interoperability Protocol / Protocolo de Interoperabilidad de Gestión de Claves)

- Protocolo usado para que dispositivos/aplicaciones se comuniquen con el servidor de gestión de claves.

> **👉 Enfoque de Examen SY0-701:** Pregunta: si una clave privada se ve comprometida durante su ciclo de vida, ¿qué debe hacerse? → **Revocar** la clave **Y** re-cifrar todos los datos cifrados con ella usando una nueva clave. KMIP es el protocolo de comunicación en sistemas centralizados.

## 7.8. Criptoprocesadores y Enclaves Seguros

> 🔒 **Analogía:** Un criptoprocesador es como una cámara acorazada dentro del banco. Las claves viven ahí, nunca salen, y todo el trabajo criptográfico se hace dentro de la bóveda.

### Problemas del almacenamiento de claves en sistema de archivos

- **Baja entropía:** Los ordenadores son deterministas. Necesitan un PRNG (Pseudo-Random Number Generator / Generador de Números Pseudoaleatorios) para aproximarse a valores aleatorios.
- **Mayor seguridad:** TRNG (True Random Number Generator / Generador de Números Aleatorios Verdaderos) usa fuentes físicas de entropía (ruido, movimiento de aire) como semilla.
- **Vulnerabilidad de almacenamiento:** Una clave en el sistema de archivos es tan segura como cualquier otro archivo → robo físico, credenciales comprometidas.
- **Ideal:** Almacenamiento criptográfico **inviolable (tamper-evident)**.

### TPM (Trusted Platform Module / Módulo de Plataforma Confiable)

Criptoprocesador implementado como **módulo para una plataforma informática específica**.

**Versiones:**
- `TPM 1.2` — Versión antigua, la mayoría de proveedores deja de dar soporte.
- `TPM 2.0` — Versión actual. **No compatible hacia atrás** con 1.2.

**Tipos de implementación TPM:**

| Tipo | Descripción | Resistencia a manipulación | Superficie de ataque |
|---|---|---|---|
| **Discreto (Discrete)** | Chip dedicado independiente | ✅ Alta | 🟢 Mínima |
| **Integrado (Integrated)** | Parte del chipset o CPU | ❌ No resistente | 🟡 Más amplia |
| **Firmware** | En código de bajo nivel (BIOS/UEFI). Ej: Intel PTT, AMD fTPM | ❌ No resistente | 🔴 Más amplia |
| **Virtual** | Implementado en hipervisor para VMs | Depende del hipervisor | Variable |

### HSM (Hardware Security Module / Módulo de Seguridad de Hardware)

Criptoprocesador en **factor de forma removible o dedicado**.

- Formatos: rack, tarjetas `PCIe`, llaves `USB`, dispositivos virtuales.
- **Diferencia con TPM:** El TPM valida una plataforma específica; el **HSM provee almacenamiento centralizado** de claves para hosts de red o almacenamiento portátil.
- Certificación: **FIPS 140-2 Nivel 2** (Federal Information Processing Standard).

### PKCS#11

- **API** (Application Programming Interface / Interfaz de Programación de Aplicaciones) que implementa la comunicación con el criptoprocesador.
- Las aplicaciones acceden a las claves a través de esta interfaz, sin acceso directo al material de clave.

### Enclave Seguro (Secure Enclave / TEE)

**TEE** (Trusted Execution Environment / Entorno de Ejecución Confiable):

- **Problema:** Los datos descifrados deben cargarse en **RAM** para ser procesados → posible acceso por procesos maliciosos.
- **Solución:** Enclave seguro que protege datos en memoria del sistema.
- Ejemplo: `Intel SGX` (Software Guard Extensions / Extensiones de Guardia de Software de Intel).
- **Ni procesos con privilegios root/sistema** pueden acceder sin autorización.
- El enclave está bloqueado a procesos **firmados digitalmente**.

### Resumen comparativo TPM vs. HSM

| Característica | TPM | HSM |
|---|---|---|
| Propósito | Validar plataforma específica | Almacenamiento centralizado/portátil |
| Factor de forma | Chip en placa madre | Rack, PCIe, USB, virtual |
| Portabilidad | No | Sí |
| Alcance | Un dispositivo | Múltiples hosts |

> **👉 Enfoque de Examen SY0-701:** Diferencia clave: **TPM = atado a un dispositivo**, **HSM = centralizado/portátil**. TRNG > PRNG en entropía. FIPS 140-2 es la certificación de seguridad de HSMs. Intel SGX = ejemplo de TEE. Distractor: el TPM Discreto es el más seguro (tamper-resistant); el de Firmware es el más vulnerable.

## 7.9. Custodia de Claves

> 🗝️ **Analogía:** La custodia de claves es como la caja de seguridad bancaria que requiere dos llaves simultáneas — la del banco y la del cliente — para abrirse. Ninguno puede acceder solo.

### El problema de las copias de seguridad de claves

- Sin copia de seguridad → si se pierde la clave, los datos **no pueden recuperarse**.
- Con copias → mayor probabilidad de compromiso + dificulta detectar si ya ocurrió.

### Soluciones: Custodia y Control M de N

- **Custodia (Key Escrow):** La clave se archiva con un **tercero** de forma independiente.
- **M de N:** Una operación **no puede realizarla una sola persona**. Requiere que un **quórum (M)** de personas disponibles **(N)** autoricen la operación.

### División de claves

- La clave se divide en partes → cada parte la custodia un proveedor diferente.
- **KRA** (Key Recovery Agent / Agente de Recuperación de Claves): Cuenta con permiso para acceder a una clave en custodia.
- Una política puede requerir **dos o más KRA** para autorizar la recuperación → mitiga el riesgo de suplantación.

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué control previene que un solo administrador pueda acceder a una clave en custodia?" → **M de N** (también llamado control de quórum). KRA es el agente con acceso a claves en custodia. Distractor: confundir custodia con backup normal — la custodia implica terceros y controles adicionales.

# 8 Soluciones Criptográficas

## 8.1. Cifrado que Respalda la Confidencialidad

> 🛡️ **Analogía:** El cifrado es como un sobre sellado: aunque el cartero (red) lo lleve, no puede leer su contenido.

### Estados de los datos

| Estado | Descripción | Mecanismo típico |
|---|---|---|
| **Data at rest** (Datos en reposo) | Almacenados en medios persistentes (disco, SSD) | FDE, cifrado de volumen |
| **Data in transit** (Datos en tránsito / en movimiento) | Transmitidos a través de una red | TLS, IPsec, WPA |
| **Data in use** (Datos en uso / en procesamiento) | Presentes en memoria volátil (RAM, caché, registros) | Enclaves seguros (TEE) |

### Cifrado masivo (Bulk Encryption)

- Cifrar megabytes o gigabytes de datos = **cifrado masivo**.
- El cifrado **asimétrico** no se usa para cifrado masivo → **demasiado lento**.
- Se usa **cifrado simétrico** (ej. `AES`) para datos masivos.

### Esquema híbrido para cifrado de datos

```
1. Usuario genera par de claves asimétricas (RSA o ECC)
   → Clave privada cifrada: requiere credencial del usuario para usarla
   → Esta clave privada = KEK (Key Encryption Key / Clave de Cifrado de Clave)

2. Sistema genera clave simétrica (AES-256 o AES-512)
   → Esta es la DEK (Data Encryption Key / Clave de Cifrado de Datos)
   → La DEK cifra los datos objetivo

3. La DEK se cifra usando la parte PÚBLICA de la KEK

4. Para acceder a los datos:
   → Usuario proporciona contraseña/sesión autenticada
   → Clave privada (KEK) descifra la DEK
   → La DEK descifra los datos
```

> **👉 Enfoque de Examen SY0-701:** Memoriza: **KEK** (Key Encryption Key) cifra a la **DEK** (Data Encryption Key) que cifra los datos. Pregunta trampa: "¿Se usa cifrado asimétrico para cifrar datos en disco?" → **NO directamente** — cifra la clave simétrica (DEK) que a su vez cifra los datos.

## 8.2. Cifrado de Archivos y Discos

> **Analogía:** El cifrado de disco completo es como blindar todo el maletero de un coche — aunque te roben el coche (disco), no pueden acceder al contenido sin la llave. El cifrado de archivos es como poner un candado individual en cada maleta dentro del maletero.

### Niveles de cifrado de datos en reposo

```
[Nivel más alto — más granular]
  Cifrado de archivo individual (EFS)
  Cifrado de columna/celda en BD
  Cifrado de volumen (BitLocker, FileVault)
  Cifrado de disco completo (FDE)
[Nivel más bajo — más simple]
```

### FDE (Full Disk Encryption / Cifrado de Disco Completo)

- Cifra **todo el contenido** del dispositivo: datos, metadatos, espacio libre.
- Protege principalmente contra **robo físico del disco**.
- Sin FDE: un disco robado puede montarse en cualquier PC → acceso total.
- Con FDE: el disco debe desbloquearse con credenciales antes de acceder a la clave de descifrado.

**SED (Self-Encrypting Drive / Unidad de Autocifrado):**
- HDD, SSD o USB flash con producto criptográfico integrado en **firmware**.
- El firmware implementa un criptoprocesador → claves no expuestas al SO.

### Cifrado de particiones

- Un disco puede dividirse en **particiones** (áreas lógicas separadas).
- Posible cifrar selectivamente:
  - Particiones de arranque/sistema: dejar sin cifrar (solo archivos estándar del SO).
  - **Partición de datos**: proteger con cifrado.

### Cifrado de volúmenes

- **Volumen:** Recurso de almacenamiento con un único sistema de archivos (puede ser partición, RAID, disco extraíble).
- Productos de cifrado de volumen: implementados como **software** (no firmware).
- Ejemplos:
  - `BitLocker` (Microsoft) — cifrado de volumen.
  - `FileVault` (Apple) — cifrado de volumen.
- Puede o no cifrar espacio libre o metadatos.

### Cifrado de archivos individuales

- Software que aplica cifrado a **archivos individuales** (o carpetas/directorios).
- Ejemplo: **EFS** (Encrypting File System / Sistema de Archivos de Cifrado de Microsoft).
  - Requiere volumen formateado con `NTFS`.

**Metadatos y espacio libre:**
- **Metadatos:** Lista de archivos, propietario, fechas de creación/modificación.
- **Espacio libre/no asignado:** Puede contener restos de datos (archivos "eliminados" pero no borrados físicamente).

> Si el dispositivo tiene TPM o HSM compatible, el sistema puede bloquearse mediante claves almacenadas en el TPM/HSM.

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué cifra los metadatos y el espacio libre?" → **FDE**. Diferencia clave: SED = hardware (firmware del disco), BitLocker/FileVault = software (cifrado de volumen). EFS requiere NTFS. Distractor: "BitLocker es FDE" — técnicamente es **cifrado de volumen**, aunque en la práctica suele aplicarse al disco completo.

## 8.3. Cifrado de Base de Datos

> **Analogía:** Cifrar una base de datos es como poner diferentes niveles de seguridad en un edificio: puedes cifrar toda la planta (base de datos), una sala específica (tabla), o incluso un cajón concreto (celda/columna).

### Estructura de una base de datos

- **Tablas** → **Columnas** (campos con tipo de datos) + **Filas** (registros).
- Acceso mediado por **DBMS** (Database Management System / Sistema de Gestión de Base de Datos) usando **SQL** (Structured Query Language / Lenguaje de Consulta Estructurado).

### Niveles de cifrado en BD

#### Nivel 1: Cifrado de Base de Datos (TDE)

- **TDE** (Transparent Data Encryption / Cifrado de Datos Transparente): cifrado a nivel de base de datos o página.
- Opera cuando los datos se transfieren entre **disco y memoria**.
- Cifra todos los registros en disco + los registros generados por la BD.
- Protege contra robo de los medios subyacentes.
- Implementado en: `Microsoft SQL Server`.

#### Nivel 2: Cifrado de Celda/Columna

- Se aplica a uno o más **campos** dentro de una tabla.
- Menor impacto en rendimiento vs. TDE.
- El administrador debe identificar qué campos necesitan protección.
- **Always Encrypted** (SQL Server): los datos permanecen cifrados incluso en memoria.
  - Solo se descifran cuando la aplicación cliente suministra la clave.
  - La clave de texto plano **no está disponible para el DBMS**.
  - Permite **separación de funciones**: el admin de BD no puede ver los datos → importante para privacidad.

#### Nivel 3: Cifrado a Nivel de Registro/Fila

- Cada cliente/registro puede tener un **par de claves separado**.
- Control granular sobre quién puede acceder a qué datos.
- Ejemplo: aseguradora de salud → cada paciente tiene sus registros protegidos por claves distintas.
- Importante para cumplimiento de normativas de privacidad.

### Comparativa de niveles de cifrado en BD

| Nivel | Granularidad | Rendimiento | Casos de uso |
|---|---|---|---|
| **TDE** (base de datos/página) | Toda la BD | Impacto adverso | Protección contra robo de medios |
| **Columna/celda** | Campo específico | Menor impacto | Datos sensibles concretos, separación de funciones |
| **Registro/fila** | Registro individual | Variable | Cumplimiento normativo, acceso individualizado |

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué mecanismo permite que el DBA (administrador de BD) no pueda ver datos cifrados?" → **Always Encrypted** / cifrado a nivel de columna con clave en cliente. TDE protege contra robo del disco, pero el DBA SÍ puede ver los datos en memoria. Distractor: confundir TDE con "Always Encrypted" — son diferentes niveles de protección.

## 8.4. Cifrado de Transporte e Intercambio de Claves

> **Analogía:** El sobre digital es como enviar un mensaje en una caja de seguridad: cifras el mensaje con el candado del destinatario (clave pública), y dentro de la caja metes también tu llave (clave de sesión) bloqueada con otro candado del destinatario.

### Protocolos de cifrado de transporte

| Protocolo | Protege | Uso típico |
|---|---|---|
| `WPA` (Wi-Fi Protected Access / Acceso Wi-Fi Protegido) | Tráfico inalámbrico | Redes WiFi |
| `IPsec` (Internet Protocol Security) | Tráfico entre dos puntos en red pública | **VPN** (Virtual Private Network) |
| `TLS` (Transport Layer Security / Seguridad de la Capa de Transporte) | Datos de aplicación (web, email) | HTTPS, correo seguro |

### Sobre digital (Digital Envelope) — Flujo de intercambio de claves

```
1. Alice obtiene clave pública RSA/ECC de Bob (vía certificado digital)
2. Alice cifra su mensaje con un cifrado simétrico (AES)
   → La clave simétrica = CLAVE DE SESIÓN
3. Alice cifra la clave de sesión con la clave pública de Bob
4. Alice adjunta la clave de sesión cifrada al mensaje (= sobre digital)
5. Alice envía el sobre a Bob
6. Bob descifra la clave de sesión con su CLAVE PRIVADA
7. Bob descifra el mensaje con la clave de sesión
```

### Integridad y autenticidad en el transporte

**HMAC** (Hash-based Message Authentication Code / Código de Autenticación de Mensajes Basado en Hash):
- Combina la **clave secreta** (derivada del intercambio) + **hash del mensaje**.
- Garantiza que el mensaje no fue modificado por alguien que no sea el remitente.

**AE** (Authenticated Encryption / Cifrado Autenticado):
- Modo de operación del cifrado simétrico que garantiza **confidencialidad + integridad/autenticidad** simultáneamente.

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué garantiza el HMAC?" → **Integridad y autenticidad** (no confidencialidad). IPsec → VPN. TLS → HTTPS. Distractor: pensar que el sobre digital cifra directamente con clave asimétrica — lo que cifra asimétricamente es la **clave de sesión**, no el mensaje.

## 8.5. Secreto de Reenvío Perfecto (PFS)

> ⏳ **Analogía:** Sin PFS es como usar siempre la misma llave maestra para todas las sesiones — si alguien copia esa llave, puede abrir todas las cajas pasadas y futuras. Con PFS, cada sesión usa una llave diferente que se destruye al terminar.

### El problema sin PFS

- En el modelo básico de sobre digital, si se registra una sesión y **luego** se compromete la clave privada del servidor → se puede descifrar **retroactivamente** la clave de sesión y recuperar todos los datos de la sesión grabada.

### PFS (Perfect Forward Secrecy / Secreto de Reenvío Perfecto)

- Usa el **acuerdo de claves Diffie-Hellman (D-H)** para crear **claves de sesión efímeras** **sin usar la clave privada del servidor**.
- La autenticidad del servidor se demuestra mediante **firma digital** (separada del proceso de generación de clave).

### Protocolo Diffie-Hellman — Cómo funciona

```
Valores públicos acordados: p=23, g=9

Alice:
→ Elige número secreto a=5
→ Calcula A = g^a mod p = 9^5 mod 23 = 8
→ Envía A=8 a Bob

Bob:
→ Elige número secreto b=3
→ Calcula B = g^b mod p = 9^3 mod 23 = 16
→ Envía B=16 a Alice

Cálculo del secreto compartido:
Alice: s = B^a mod p = 16^5 mod 23 = 6
Bob:   s = A^b mod p = 8^3 mod 23 = 6
→ ¡Ambos obtienen el mismo valor s=6!

Mallory conoce: p, g, A, B → PERO no puede calcular s sin conocer a o b
```

### Ventajas del PFS

- Compromiso **futuro** del servidor **no** compromete sesiones pasadas.
- Si un atacante obtiene la clave de **una sesión**, las demás permanecen confidenciales.
- Aumenta masivamente el trabajo criptográfico para recuperar una "conversación" completa.

### Implementaciones de PFS

| Implementación | Descripción |
|---|---|
| `DHE` (Diffie-Hellman Ephemeral) | PFS con aritmética modular |
| `ECDHE` (Elliptic Curve DHE) | **Implementación más habitual actualmente** — D-H en curva elíptica |

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué previene que el compromiso de la clave privada del servidor exponga sesiones pasadas?" → **PFS**. "¿Qué protocolo usa PFS?" → **DHE / ECDHE**. Distractor: confundir PFS con confidencialidad en tiempo real — PFS protege el **historial grabado** de sesiones pasadas, no solo las futuras. ECDHE es la implementación más moderna.

## 8.6. Salting y Key Stretching

> 🧂 **Analogía:** El salting es como añadir una huella dactilar única a cada contraseña antes de cifrarla — aunque dos personas tengan la misma contraseña, sus hashes serán completamente diferentes.

### El problema de la baja entropía en contraseñas

- Los usuarios eligen contraseñas predecibles (baja entropía).
- Las funciones hash son **unidireccionales** pero vulnerables a:
  - **Ataque de fuerza bruta:** Prueba todas las combinaciones posibles.
  - **Ataque de diccionario:** Genera hashes de palabras/frases comunes y busca coincidencias.
  - **Rainbow tables:** Tablas de hashes precalculados.

### Salting

**Salt / Valor de sal:** Valor aleatorio único añadido a la contraseña antes de calcular el hash.

```
Fórmula: (sal + contraseña) * SHA = hash
```

- Un **salt único por cada cuenta de usuario**.
- El salt **no es secreto** — cualquier sistema que verifique el hash debe conocerlo.
- Mitiga rainbow tables: obliga al atacante a **recalcular hashes** con el salt específico de cada contraseña.
- Mitiga que contraseñas idénticas produzcan hashes idénticos en el archivo de contraseñas.

### Key Stretching (Estiramiento de Claves)

- Toma una clave (de contraseña + salt) y la pasa por **miles de rondas de hashing** → produce una clave más larga y desordenada.
- **No fortalece la clave** en sí, pero **ralentiza el ataque** (el atacante debe replicar todo ese procesamiento para cada posible clave).

**Implementación:**
- **PBKDF2** (Password-Based Key Derivation Function 2 / Función de Derivación de Claves Basada en Contraseñas 2):
  - Ampliamente usado para hash y almacenamiento de contraseñas.
  - Utilizado como parte del estándar `WPA` (Wi-Fi Protected Access).

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué previene los ataques de rainbow table?" → **Salting**. "¿Qué ralentiza los ataques de fuerza bruta contra contraseñas?" → **Key stretching**. "¿Qué estándar usa PBKDF2?" → **WPA**. Distractor: el salt no es secreto — su función es hacer únicos los hashes, no ocultarse.

## 8.7. Blockchain

> **Analogía:** La blockchain es como un libro contable que se escribe con tinta permanente y cada página nueva incluye una referencia criptográfica a la anterior. Cambiar cualquier página pasada haría que toda la cadena dejara de cuadrar — y todos los participantes lo notarían.

### Conceptos clave de Blockchain

- **Bloque (Block):** Registro transaccional individual.
- Cada bloque se procesa con una **función hash**.
- El **hash del bloque anterior** se incorpora al cálculo del hash del siguiente bloque → **encadenamiento criptográfico**.
- Cada bloque valida el hash del anterior hasta el principio de la cadena → garantiza que **ninguna transacción histórica ha sido manipulada**.
- Cada bloque incluye: **marca de tiempo** + datos de las transacciones.

### Características de la Blockchain

| Característica | Descripción |
|---|---|
| **Open Public Ledger** (Libro público abierto) | El registro es público y visible para todos |
| **Descentralizada** | No existe como archivo único en una sola computadora |
| **Red P2P** (Peer-to-Peer) | Distribuida para mitigar riesgos de punto único de falla/compromiso |
| **Apertura** | Todos tienen la misma capacidad de ver todas las transacciones |
| **Confianza igualitaria** | Los usuarios de blockchain pueden confiar entre sí por igual |

### Aplicaciones potenciales

- Integridad y transparencia de **transacciones financieras**
- **Contratos legales**
- **Protección de derechos de autor** y propiedad intelectual (PI)
- **Sistemas de votación** en línea
- **Gestión de identidad**
- **Almacenamiento de datos** seguro

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué propiedad de seguridad garantiza principalmente la blockchain?" → **Integridad** (y no repudio de transacciones). "¿Qué característica de la blockchain mitiga el punto único de falla?" → **Descentralización / red P2P**. Distractor: la blockchain NO proporciona confidencialidad por sí misma — es pública. La inmutabilidad proviene del encadenamiento de hashes, no del cifrado.

## 8.8. Ofuscación

> **Analogía:** La ofuscación es como esconder el dinero dentro de un libro en la estantería. No lo cifras, solo lo haces difícil de encontrar. Por sí sola no es suficiente, pero combinada con otras técnicas puede ser útil.

### Concepto

La ofuscación hace que un mensaje o dato sea **difícil de encontrar**. Es una forma de "seguridad por oscuridad" — generalmente considerada obsoleta por sí sola, pero tiene usos legítimos específicos.

### Técnicas de ofuscación

#### 1. Esteganografía (Steganography)

- Literalmente: "escritura oculta".
- **Incrustar información** dentro de una fuente inesperada (ej. mensaje oculto en una imagen).
- El archivo/documento contenedor = **covertext**.
- Puede combinarse con cifrado para proporcionar **confidencialidad**.
- Puede proporcionar **integridad o no repudio** (ej. probar que algo se imprimió en un dispositivo concreto en un momento determinado → auténtico o falso).

#### 2. Enmascaramiento de datos (Data Masking)

- Todo o parte del contenido de un campo de BD se **redacta** (ej. sustituyendo por "x").
- **Supresión parcial:** Se preservan metadatos para análisis (ej. conservar prefijo telefónico, suprimir número de abonado).
- Puede preservar el **formato original** del campo.

#### 3. Tokenización (Tokenization)

- Reemplaza todo o parte del valor de un campo por un **token generado aleatoriamente**.
- El token se almacena con el valor original en un **servidor de tokens / bóveda de tokens** → **separado de la BD de producción**.
- Es **reversible**: una consulta/aplicación autorizada puede recuperar el valor original.
- Se usa como **sustituto del cifrado** desde una perspectiva regulatoria (un campo tokenizado ≠ datos originales en términos regulatorios).

### Tabla comparativa de técnicas de ofuscación

| Técnica | Reversible | Protege | Caso de uso principal |
|---|---|---|---|
| **Esteganografía** | Sí (con conocimiento del método) | Existencia del mensaje | Canales encubiertos, marcas de agua digitales |
| **Data Masking** | Parcialmente | Datos personales en análisis | Entornos de desarrollo/prueba, cumplimiento |
| **Tokenización** | Sí (con bóveda de tokens) | Datos sensibles en BD de producción | PCI-DSS, datos de tarjetas de crédito |

### Desidentificación

- **Data masking** + **tokenización** se usan para la **desidentificación**.
- **Desidentificación:** Ofuscar datos personales en bases de datos para que puedan **compartirse sin comprometer la privacidad**.

> **👉 Enfoque de Examen SY0-701:** Pregunta: "¿Qué técnica de ofuscación es reversible y almacena el valor original en un servidor separado?" → **Tokenización**. "¿Qué incrustar un mensaje en una imagen?" → **Esteganografía** (covertext). Diferencia clave: **tokenización vs. cifrado** — desde una perspectiva regulatoria, un campo cifrado tiene el mismo valor que los datos originales; un campo tokenizado no. Distractor: confundir data masking (irreversible) con tokenización (reversible).

# 9 Gestión de claves

El ciclo de vida de una clave criptográfica comprende las siguientes etapas:

1. **Generación:** Creación matemática del par de claves o de la clave secreta mediante generadores pseudoaleatorios robustos.
2. **Almacenamiento:** Protección de las claves privadas o secretas contra accesos no autorizados, garantizando además su disponibilidad mediante copias de respaldo.
3. **Revocación:** Anulación del uso de la clave en caso de compromiso. Los datos previamente cifrados deben volver a cifrarse con una nueva clave.
4. **Caducidad y Renovación:** Definición de un período de validez para mitigar ataques prolongados. Al expirar, se puede renovar con el mismo par o generar uno nuevo.

## 10 Criptoprocesadores y enclaves seguros

La seguridad de un sistema criptográfico completo depende en última instancia de cómo se protejan y manipulen sus claves.

### TPM vs. HSM

| Característica | TPM (Trusted Platform Module) | HSM (Hardware Security Module) |
|---------------|------------------------------|-------------------------------|
| **Formato** | Chip soldado a la placa base. | Dispositivo externo o tarjeta PCI de grado industrial. |
| **Escala** | Uso individual en portátiles y servidores. | Uso masivo en centros de datos. |
| **Funciones principales** | Arranque seguro (Secure Boot), almacenamiento de claves, asistencia a BitLocker. | Generación y procesamiento de claves a gran escala, firmas digitales corporativas, protección de la CA raíz. |
| **Protección física** | Básica (integrada en el hardware del equipo). | Avanzada: autodestrucción de claves ante intrusión, sensores de calor y voltaje. |

### Custodia de Claves y Recuperación

- **Key Escrow:** Entrega de una copia de las claves a un tercero de confianza o entidad gubernamental, garantizando el acceso a los datos si el propietario los pierde o en el marco de una orden judicial.
- **M de N (Quórum):** Requiere que un número mínimo **M** de custodios autorizados de un grupo total de **N** estén presentes simultáneamente para ejecutar operaciones críticas. Previene el abuso de poder de un único administrador.

### Enclaves Seguros

La debilidad crítica de cualquier criptoprocesador es que **los datos descifrados deben cargarse en la RAM en texto plano** para ser procesados, lo que los expone a malware o exploits de lectura de memoria. Un **Enclave Seguro** (como Intel SGX) mitiga esto aislando a nivel de hardware áreas de memoria exclusivas, accesibles únicamente por procesos firmados digitalmente y autorizados.

# 11. Custodia de Claves (Key Escrow)

Si una clave privada o simétrica se pierde, toda la información cifrada con ella quedará permanentemente inaccesible. Para mitigar este riesgo se utilizan dos controles:

1. **Key Escrow:** Almacenar una copia de la clave con un tercero independiente de confianza (o entidad gubernamental bajo orden judicial).
2. **Esquema M de N (Quórum):** Una operación crítica no puede ser ejecutada por una única persona. Se requiere el consenso de un mínimo **M** de custodios de un grupo de **N**. Ejemplo: 3 de 5 custodios deben aprobar la recuperación de la clave maestra. Previene el abuso de poder de un único administrador.
- **KRA (Key Recovery Agent):** Rol o cuenta con permisos explícitos para acceder e importar claves mantenidas en custodia.

# 12 Ofuscación

La ofuscación consiste en alterar datos, código o mensajes para hacerlos difíciles de identificar o comprender por parte de personas no autorizadas. Se fundamenta en la «seguridad por oscuridad», obsoleta por sí sola pero útil como capa complementaria.

### Esteganografía

Técnica que **oculta la existencia misma** de la información dentro de un archivo contenedor aparentemente inofensivo (*covertext*), como una imagen digital, un archivo de audio o un vídeo.

- **Mecanismo técnico:** Modificar los **bits menos significativos (LSB)** de los píxeles de una imagen para insertar datos ocultos. Los cambios de color resultantes son imperceptibles para el ojo humano.
- **Uso malicioso:** Evadir sistemas de inspección profunda de paquetes (DPI) o herramientas de prevención de fuga de datos (DLP).
- **Uso legítimo:** Marcas de agua digitales imperceptibles para rastrear la procedencia o detectar la alteración de documentos.

### Enmascaramiento de Datos (Data Masking)

Técnica que protege la confidencialidad de datos sensibles mediante su modificación o sustitución, especialmente en bases de datos de desarrollo o pruebas.

- **Enmascaramiento Estático:** Modifica permanentemente los datos en una copia de la base de producción antes de trasladarla a entornos de prueba.
- **Enmascaramiento Dinámico:** Intercepta la consulta en tiempo real y sustituye los datos según el rol del usuario (ej. mostrar solo los últimos 4 dígitos de una tarjeta: `************1234`).

### Tokenización

Reemplaza un dato sensible (como el número de tarjeta de crédito) por un sustituto aleatorio no sensible llamado **token**.

- **Diferencia con el cifrado:** El token no es el resultado de una fórmula matemática reversible; es una referencia que requiere consultar una base de datos segura (*token vault*), compatible con estándares como PCI-DSS.

# 13 Cifrado que Respalda la Confidencialidad

Si los datos se cifran correctamente, incluso si los discos son robados físicamente o los paquetes de red son interceptados, la información permanece protegida.

### Los Tres Estados de los Datos

| Estado | Descripción | Control de seguridad típico |
|--------|-------------|----------------------------|
| **Datos en Reposo** *(Data at Rest)* | Información almacenada en medios no volátiles (HDD, SSD, cintas, NAS). | FDE, cifrado de volúmenes o archivos. |
| **Datos en Tránsito** *(Data in Transit)* | Información viajando por una red pública o privada. | TLS, IPsec, WPA. |
| **Datos en Uso** *(Data in Use)* | Información activa cargada en la RAM o caché de la CPU. | Enclaves seguros (Intel SGX). |

### El Esquema de Cifrado Estándar (Confidencialidad de Archivos)

La mayoría de los sistemas criptográficos combinan cifrado simétrico y asimétrico de forma complementaria:

1. El sistema genera una clave simétrica temporal (**DEK - Data Encryption Key**) que cifra los datos de forma masiva y rápida.
2. La DEK se protege cifrándola con la clave pública asimétrica del usuario (**KEK - Key Encryption Key**).
3. Para descifrar, el usuario autenticado usa su clave privada (KEK) para recuperar la DEK, y esta para descifrar los datos.

### Cifrado de Archivos y Discos

- **FDE (Full Disk Encryption):** Cifra absolutamente todo el contenido de un dispositivo: particiones, espacio libre y metadatos del sistema. Protege principalmente contra el **robo físico** del dispositivo.
- **Cifrado de Volúmenes:** Cifra particiones o unidades lógicas específicas mediante software del sistema operativo. Ejemplos: **BitLocker** (Microsoft) y **FileVault** (Apple).

### Cifrado de Bases de Datos

El cifrado a nivel de base de datos permite una protección más granular que el FDE:

- **Cifrado de Celda o Columna:** Se cifran únicamente los campos más sensibles (ej. solo la columna «Número de Tarjeta»), reduciendo el impacto en el rendimiento de las consultas.
- **Always Encrypted (SQL Server):** Los datos permanecen cifrados incluso cuando se cargan en la memoria RAM del servidor. Solo se descifran en el lado de la aplicación cliente cuando esta suministra la clave legítima. El administrador de la base de datos (DBA) nunca tiene acceso al texto plano.

### Cifrado de Transporte e Intercambio de Claves

| Protocolo | Uso principal |
|-----------|--------------|
| **WPA / WPA3** | Cifrado de redes inalámbricas locales (Wi-Fi). |
| **IPsec** | Cifrado de tráfico IP entre dos extremos; base de las VPNs. |
| **TLS** | Cifrado de datos de aplicaciones a través de Internet (HTTPS, SMTPS, IMAPS). |

### Secreto de Reenvío Perfecto (Perfect Forward Secrecy - PFS)

En los esquemas clásicos, la clave de sesión simétrica se intercambia usando la clave privada de largo plazo del servidor. Si esa clave privada se ve comprometida en el futuro, un atacante que haya grabado el tráfico pasado podría descifrarlo todo retroactivamente.

El **PFS** elimina este riesgo utilizando el protocolo de acuerdo de claves **Diffie-Hellman efímero (DHE o ECDHE)**: Diffie-Hellman permite que dos partes generen el mismo secreto compartido a través de un canal inseguro sin necesidad de transferirlo directamente. Las claves de sesión generadas son únicas, temporales y se descartan de la memoria al cerrar la sesión, sin depender jamás de la clave privada de largo plazo para el descifrado.

> 🔑 **Clave de examen:** PFS garantiza que el compromiso futuro de la clave privada del servidor **no compromete** la confidencialidad de las sesiones pasadas.

### Protección de Contraseñas (Salting y Stretching)

Las contraseñas no se almacenan como texto plano, sino como hashes. Para protegerlos contra ataques de tablas arcoíris (diccionarios de hashes precalculados):

- **Salting:** Se añade un valor aleatorio único a cada contraseña antes de calcular su hash. Dos usuarios con la misma contraseña tendrán hashes completamente diferentes.
- **Key Stretching:** El proceso de hashing se repite miles de veces (ej. mediante PBKDF2 o bcrypt) para ralentizar significativamente los ataques de fuerza bruta.

# 14 Blockchain (Cadena de Bloques)

Un registro o libro contable digital, distribuido, descentralizado e inmutable diseñado para registrar transacciones de forma segura y verificable.

### Componentes de Seguridad en Blockchain

- **Libro Mayor Distribuido:** Los datos no se almacenan en un servidor central, sino que se replican en múltiples nodos de una red P2P, eliminando el punto único de fallo.
- **Encadenamiento Criptográfico por Hash:** Cada bloque contiene el hash del bloque anterior. Si un atacante modifica un dato en el bloque 3, su hash cambia, rompiendo el enlace con el bloque 4 e invalidando toda la cadena subsiguiente. Para manipular el registro, el atacante debería recalcular toda la cadena en la mayoría de los nodos simultáneamente.
- **Consenso:** Mecanismos que garantizan que todos los nodos coincidan en el estado del libro mayor. Los más comunes son *Proof of Work* y *Proof of Stake*.

# 15. Glosario

| Concepto | Sigla / Acrónimo | Función principal |
|---|---|---|
| Criptografía | — | Asegurar información codificándola |
| Cifrado simétrico | — | Confidencialidad (misma clave) |
| Cifrado asimétrico | — | Autenticación + confidencialidad (par de claves) |
| Hashing | — | Integridad (unidireccional) |
| Firma digital | — | Integridad + autenticación + no repudio |
| Estándar de Cifrado Avanzado | **AES** | Cifrado simétrico masivo |
| Rivest, Shamir, Adelman | **RSA** | Cifrado asimétrico (mín. 2048 bits) |
| Criptografía de Curva Elíptica | **ECC** | Asimétrico eficiente (256 bits ≈ RSA-3072) |
| Algoritmo de Hash Seguro 256 | **SHA-256** | Hash estándar (256 bits) |
| Algoritmo de Resumen de Mensajes 5 | **MD5** | Hash débil (128 bits, solo compatibilidad) |
| Algoritmo de Firma Digital | **DSA** | Firma digital (base: ElGamal) |
| ECDSA | **ECDSA** | Firma digital en curva elíptica (actual) |
| Infraestructura de Clave Pública | **PKI** | Framework de confianza con certificados |
| Autoridad Certificadora | **CA** | Valida identidad y emite certificados |
| Solicitud de Firma de Certificado | **CSR** | Solicitud del sujeto a la CA |
| Nombre de Dominio Completamente Calificado | **FQDN** | Identificador completo del host |
| Nombre Común | **CN** | Campo de certificado (en desuso para FQDN) |
| Nombre Alternativo del Sujeto | **SAN** | Campo moderno para identificación del servidor |
| Nombre Distinguido | **DN** | Identificador completo del sujeto en el certificado |
| Lista de Revocación de Certificados | **CRL** | Lista de certificados revocados/suspendidos |
| Protocolo de Estado de Certificados en Línea | **OCSP** | Estado en tiempo real de un certificado |
| Protocolo de Interoperabilidad de Gestión de Claves | **KMIP** | Comunicación con servidor de gestión de claves |
| Módulo de Plataforma Confiable | **TPM** | Criptoprocesador para plataforma específica |
| Módulo de Seguridad de Hardware | **HSM** | Criptoprocesador centralizado/portátil |
| Generador de Números Pseudoaleatorios | **PRNG** | Generación de números "aleatorios" por software |
| Generador de Números Aleatorios Verdaderos | **TRNG** | Entropía real (ruido físico) |
| Interfaz de Programación de Aplicaciones | **API** | Comunicación con criptoprocesador (PKCS#11) |
| Entorno de Ejecución Confiable | **TEE** | Enclave seguro en memoria (ej. Intel SGX) |
| Extensiones de Guardia de Software de Intel | **SGX** | Implementación TEE de Intel |
| Agente de Recuperación de Claves | **KRA** | Cuenta con acceso a claves en custodia |
| Datos en reposo | **Data at rest** | Almacenados en medios persistentes |
| Datos en tránsito | **Data in transit** | Transmitidos por red |
| Datos en uso | **Data in use** | En memoria volátil |
| Clave de Cifrado de Clave | **KEK** | Clave asimétrica que cifra la DEK |
| Clave de Cifrado de Datos | **DEK** | Clave simétrica que cifra los datos |
| Cifrado de Disco Completo | **FDE** | Cifra todo el disco |
| Unidad de Autocifrado | **SED** | Disco con cifrado en firmware |
| Sistema de Archivos de Cifrado | **EFS** | Cifrado de archivos en Windows (requiere NTFS) |
| Cifrado de Datos Transparente | **TDE** | Cifrado a nivel de base de datos (SQL Server) |
| Acceso Wi-Fi Protegido | **WPA** | Cifrado de tráfico inalámbrico |
| Seguridad de Protocolo de Internet | **IPsec** | VPN / cifrado entre dos puntos |
| Seguridad de la Capa de Transporte | **TLS** | Cifrado de datos de aplicación (HTTPS) |
| Red Privada Virtual | **VPN** | Red privada sobre infraestructura pública (vía IPsec) |
| Código de Autenticación de Mensajes Basado en Hash | **HMAC** | Integridad + autenticidad de mensajes |
| Cifrado Autenticado | **AE** | Modo simétrico: confidencialidad + integridad |
| Secreto de Reenvío Perfecto | **PFS** | Claves de sesión efímeras, protege historial |
| Diffie-Hellman Efímero | **DHE** | Implementación de PFS con aritmética modular |
| ECDHE | **ECDHE** | PFS en curva elíptica (implementación actual) |
| Función de Derivación de Claves Basada en Contraseñas 2 | **PBKDF2** | Key stretching, usado en WPA |
| Blockchain | — | Registro distribuido con integridad criptográfica |
| Esteganografía | — | Mensaje oculto en covertext |
| Enmascaramiento de datos | **Data Masking** | Redacción de campos de BD |
| Tokenización | — | Sustitución por token aleatorio (reversible) |
| Normas Federales de Procesamiento de Información | **FIPS** | Estándar EE.UU. (FIPS 140-2 para HSMs) |
| Estándares de Criptografía de Clave Pública | **PKCS** | Conjunto de estándares de RSA para PKI |
