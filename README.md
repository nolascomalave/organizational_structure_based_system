# 🏢 Entity Based Structure - Sistema de Gestión Organizacional Multitenencia

Este repositorio contiene el modelo de base de datos y la estructura fundamental para un **Sistema de Gestión de Estructura Organizacional** con capacidades **multitenencia** (múltiples inquilinos). Sirve como base de datos para una aplicación empresarial SaaS (Software as a Service) que permite a diferentes organizaciones (clientes) gestionar su propia estructura interna de forma aislada y segura.

## 🎯 Objetivo del Proyecto

El proyecto tiene como propósito proporcionar un backend de datos robusto y estandarizado para:

1. **Registrar y gestionar la estructura geográfica y organizacional de una empresa.**  
   Incluye desde la ubicación de oficinas (basada en países, estados y ciudades) hasta la definición de su jerarquía interna (departamentos, familias de puestos, puestos de trabajo y la relación entre empleados y puestos).

2. **Operar bajo un modelo de negocio por suscripciones.**  
   Cada organización actúa como un "inquilino" (`system_subscription`), y su acceso se controla mediante períodos de validez (`system_subscription_validity`), lo que es típico de una aplicación SaaS donde los clientes pagan por acceso limitado en el tiempo.

3. **Gestionar la identidad y el acceso de los usuarios.**  
   A través de tablas como `user_access`, `session` y `recovery_password` se controla quién puede ingresar al sistema y cómo se autentica.

4. **Mantener un registro auditable de todos los cambios.**  
   La tabla `audit_log` está diseñada para registrar cada operación importante (creación, modificación, eliminación) sobre los datos críticos, permitiendo una trazabilidad completa.

## 🏛️ Estructura de la Base de Datos

La base de datos está organizada en dos esquemas principales dentro de un mismo motor de base de datos (PostgreSQL), reflejando el patrón de **multitenencia**:

- **`osbs` (Esquema maestro o del sistema):** Contiene las tablas "comunes" o "maestras" que definen el negocio en sí y son compartidas conceptualmente por todos los inquilinos.
- **`tenants` (Esquema de los inquilinos):** Contiene las tablas que almacenan la información _privada_ y específica de cada organización-cliente.

### 📁 Esquema `osbs` – El contexto del sistema

- **🌍 Datos geográficos y de localización:**  
  Tablas jerárquicas (`region`, `subregion`, `country`, `state`, `city`) que permiten georreferenciar oficinas, sucursales o empleados.

- **💳 Gestión de suscripciones:**
  - `system_subscription`: Representa a cada organización-cliente (el inquilino).
  - `system_subscription_validity`: Controla los períodos activos de la suscripción.

- **👤 Gestión de contacto y comunicación:**
  - `phone` y `email`: Almacenan de forma centralizada números de teléfono y direcciones de correo, siendo la fuente de verdad para cualquier entidad (persona, empresa, departamento).

- **🔒 Auditoría global:**
  - `audit_log`: Registra todos los cambios relevantes en las tablas de negocio, guardando los valores anteriores y posteriores en formato JSONB.

### 🏢 Esquema `tenants` – Los datos de cada cliente

Todas las tablas de este esquema están vinculadas a `system_subscription` (el inquilino).

- **🏛️ Gestión de la entidad central (`entity`):**  
  Representa a cualquier "cosa" con identidad dentro de la organización de un cliente: una **persona** (`is_natural = true`) o una **empresa** (`is_natural = false`). Incluye un mecanismo de fusión (`fusion_master_entity_id`) para unificar entidades duplicadas.

- **🧑‍💼 Gestión de recursos humanos y estructura organizacional:**
  - `department`, `job_family`, `position`: Construyen la jerarquía organizacional (departamentos, familias de puestos, puestos específicos).
  - `employee`: Almacena información de los empleados, asociada a una `entity`.
  - `employee_per_position`: Relación que define qué empleado ocupó qué puesto en un período de tiempo (`employee_per_position_validity`), permitiendo un seguimiento histórico de rotaciones.

- **📋 Gestión de documentos e identidad:**
  - `identity_document_category`: Clasifica tipos de documentos (Pasaporte, Cédula, NIT, etc.).
  - `identity_document`: Almacena los documentos oficiales (números, fechas de expedición).
  - `identity_document_by_entity`: Tabla puente que asigna un documento a una entidad, pudiendo incluso geolocalizarlo por país, estado o ciudad.

- **👥 Control de acceso y seguridad:**
  - `user_access`: Credenciales de acceso para que una `entity` inicie sesión.
  - `session`: Gestiona las sesiones activas.
  - `recovery_password`: Controla el flujo de recuperación de contraseñas con códigos de tiempo limitado.

## 🔗 Relaciones clave y lógica de negocio

- **Multitenencia a nivel de fila:**  
  Cada tabla crítica en el esquema `tenants` incluye la columna `system_subscription_id` y aplica políticas de seguridad (Row Level Security) para aislar automáticamente los datos por inquilino.

- **Rastreo temporal (`validity`):**  
  Varias tablas (`system_subscription_validity`, `employee_per_position_validity`, `user_access_validity`) utilizan fechas de inicio y fin, modelando hechos que son ciertos solo durante un intervalo específico – esencial para gestión de personal, roles y suscripciones.

- **Centralización de contacto:**  
  `phone` y `email` están desacopladas de las entidades. Se relacionan a través de tablas puente (`phone_by_entity`, `email_by_entity`), permitiendo que una misma entidad tenga múltiples números y correos (personal, trabajo, casa) sin modificar la estructura principal.

- **Auditoría detallada:**  
  La tabla `audit_log` captura no solo qué tabla y registro se modificó, sino los valores **antes** (`old_data`) y **después** (`new_data`) en formato JSONB, proporcionando una capacidad forense muy potente.

## 💡 ¿Para qué tipo de aplicaciones sirve?

Esta estructura de base de datos es el punto de partida ideal para construir aplicaciones empresariales complejas como:

- Sistemas de Planificación de Recursos Empresariales (ERP)
- Sistemas de Gestión de Relaciones con el Cliente (CRM)
- Plataformas de Recursos Humanos (HRM/HRIS)
- Software de Gestión de Proyectos y Equipos
- Cualquier aplicación SaaS que requiera aislar datos por cliente y gestionar una estructura organizativa jerárquica

## 🛠️ Tecnologías detectadas

- **Base de datos:** PostgreSQL (con soporte para extensiones como `uuidv7()` y `btree_gist` para exclusiones de rangos).
- **Interacción con la BD:** Drizzle ORM en TypeScript (lo que indica que el backend de la aplicación está escrito en este lenguaje).
- **Seguridad:** Políticas de Seguridad a Nivel de Fila (RLS) implementadas directamente en la base de datos.

---

**Resumen:** Este repositorio no es una aplicación funcional, sino la **base y cimiento de datos** sobre la cual se construirá una aplicación empresarial SaaS, con un fuerte enfoque en el aislamiento de datos por cliente, la gestión de estructuras organizacionales jerárquicas y la auditoría completa de la información.
