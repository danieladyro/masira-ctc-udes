# Plataforma del Comité Técnico Científico — Instituto MASIRA · Universidad de Santander (UDES)

Plataforma tecnológica informática en línea para la radicación, revisión iterativa, evaluación colegiada y firma mediante tokens de una sola utilización de propuestas de investigación de acuerdo con el formato oficial **`CIM-FT-002-BUC_SOMETIMIENTO INICIAL_V00_modificado`**.

## Arquitectura Tecnológica

- **Backend:** REST API en **Rust** (`axum`, `sqlx`, `jsonwebtoken`, `bcrypt`, `printpdf`, `sha2`, `lettre`) en la carpeta [`backend/`](file:///P:/pcloud/2026_ai/2026_pruebaai05/backend).
- **Base de Datos:** **PostgreSQL 16** con esquema relacional y campos `JSONB` para matrices de equipo, riesgos, presupuesto, cronograma e historial de versiones (`version_history`) en [`database/init.sql`](file:///P:/pcloud/2026_ai/2026_pruebaai05/database/init.sql) y datos semilla con 20 propuestas (`CIM-2026-001` a `CIM-2026-020`) en [`database/seed.sql`](file:///P:/pcloud/2026_ai/2026_pruebaai05/database/seed.sql).
- **Frontend:** **Angular 20** (`@angular/core` ^20.0.0) diseñado bajo el sistema visual **Bitácora Analítica y Cadena de Custodia MASIRA** en [`frontend/`](file:///P:/pcloud/2026_ai/2026_pruebaai05/frontend).
- **Servidor SMTP Integrado:** **Mailpit** (`axllent/mailpit`) para despacho y auditoría de notificaciones de correo electrónico en tiempo real (`http://localhost:8025`).
- **Despliegue en Contenedores Docker:** Orquestado mediante [`docker-compose.yml`](file:///P:/pcloud/2026_ai/2026_pruebaai05/docker-compose.yml) con contenedores dedicados para `frontend` ([`frontend/Dockerfile`](file:///P:/pcloud/2026_ai/2026_pruebaai05/frontend/Dockerfile)), `backend` ([`backend/Dockerfile`](file:///P:/pcloud/2026_ai/2026_pruebaai05/backend/Dockerfile)), `postgres` ([`database/Dockerfile`](file:///P:/pcloud/2026_ai/2026_pruebaai05/database/Dockerfile)) y `smtp`.

## Configuración de Variables de Entorno (`.env`)

Todas las credenciales de base de datos, secretos criptográficos JWT, parámetros SMTP y la contraseña inicial de las cuentas semilla se encuentran centralizados en el archivo `.env` (excluido del control de versiones mediante [`.gitignore`](file:///P:/pcloud/2026_ai/2026_pruebaai05/.gitignore)). Para nuevos entornos, copie la plantilla [`.env.example`](file:///P:/pcloud/2026_ai/2026_pruebaai05/.env.example) como `.env`.

## Ejecución con Docker Compose

Para levantar o actualizar los contenedores (incluyendo la recarga completa de las 20 propuestas semilla en PostgreSQL):

```bash
docker compose down -v
docker compose up --build -d
```

- **Frontend Angular 20:** `http://localhost:4200`
- **Backend Rust REST API:** `http://localhost:8080/api/health`
- **Consola Web SMTP (Mailpit):** `http://localhost:8025`

## Roles y Cuentas Semilla del Sistema (Contraseña por defecto: `Masira2026*`)

El archivo [`database/seed.sql`](file:///P:/pcloud/2026_ai/2026_pruebaai05/database/seed.sql) inicializa **3 miembros del Comité Técnico Científico** y **8 investigadores principales**, con **20 propuestas de investigación** (`CIM-2026-001` a `CIM-2026-020`) distribuidas en todas las instancias del proceso de evaluación:

| Rol | Usuario / Correo Institucional | Propuestas Asociadas / Atribuciones |
|---|---|---|
| **Secretaria del CTC (`SECRETARIO_CTC`)** | Dra. Mabel Margoth Reyes (`secretario.ctc@udes.edu.co`) | Crea usuarios con envío de enlace de creación de contraseña por correo, revisa todos los proyectos, solicita modificaciones o da Visto Bueno al CTC, registra el concepto del pleno punto a punto, emite tokens de un solo uso y genera listados con campos seleccionables. |
| **Miembros del CTC (`MIEMBRO_CTC`)** | Dr. Patricio López Jaramillo (`patricio.lopez@udes.edu.co`)<br>Dr. José Patricio López López (`jose.lopez@udes.edu.co`) | Consultan todos los proyectos y generan informes PDF (sin permisos para crear, calificar ni modificar proyectos), y firman la aprobación del pleno utilizando tokens personales de una sola utilización. |
| **Investigador Principal 1** | Carlos Andrés Gómez Sarmiento (`carlos.gomez@udes.edu.co`) | `CIM-2026-001` (`BORRADOR`), `CIM-2026-009` (`EN_REVISION_SECRETARIA`) |
| **Investigadora Principal 2** | Natalia Sofía Serrano Rojas (`natalia.serrano@udes.edu.co`) | `CIM-2026-002` (`SOMETIDO`), `CIM-2026-010` (`RECHAZADO`) |
| **Investigadora Principal 3** | Dra. Laura Juliana Mantilla Pinzón (`laura.mantilla@udes.edu.co`) | `CIM-2026-003` (`SUBSANACION_SOLICITADA`), `CIM-2026-011` (`BORRADOR`), `CIM-2026-017` (`EN_PLENO_CTC`) |
| **Investigador Principal 4** | Dr. Andrés Felipe Villamizar Ortiz (`andres.villamizar@udes.edu.co`) | `CIM-2026-004` (`REENVIADO`), `CIM-2026-012` (`SOMETIDO`), `CIM-2026-018` (`FAVORABLE_CON_OBSERVACIONES`) |
| **Investigadora Principal 5** | Claudia Patricia Jaimes Calderón (`claudia.jaimes@udes.edu.co`) | `CIM-2026-005` (`VISTO_BUENO_CTC`), `CIM-2026-013` (`EN_REVISION_SECRETARIA`), `CIM-2026-019` (`FAVORABLE`) |
| **Investigador Principal 6** | Mauricio Alejandro Pineda Vargas (`mauricio.pineda@udes.edu.co`) | `CIM-2026-006` (`EN_PLENO_CTC`), `CIM-2026-014` (`SUBSANACION_SOLICITADA`), `CIM-2026-020` (`FAVORABLE`) |
| **Investigadora Principal 7** | Diana Carolina Duarte Meneses (`diana.duarte@udes.edu.co`) | `CIM-2026-007` (`FAVORABLE_CON_OBSERVACIONES`), `CIM-2026-015` (`REENVIADO`) |
| **Investigador Principal 8** | Jorge Enrique Castellanos Rueda (`jorge.castellanos@udes.edu.co`) | `CIM-2026-008` (`FAVORABLE`), `CIM-2026-016` (`VISTO_BUENO_CTC`) |

## Historial de Mejoras y Cambios Recientes (Versión Inicial → Versión Actual)

1. **Ampliación de la Base de Datos Semilla a 20 Propuestas (`CIM-2026-001` a `CIM-2026-020`):**
   - Se mantuvieron los **3 miembros del CTC** (1 Secretario + 2 Miembros) y los **8 investigadores principales**, ampliando el portafolio semilla de 8 a **20 propuestas de investigación** completas en [`database/seed.sql`](file:///P:/pcloud/2026_ai/2026_pruebaai05/database/seed.sql).
   - Cobertura total de los 10 estados del ciclo de evaluación: `BORRADOR`, `SOMETIDO`, `EN_REVISION_SECRETARIA`, `SUBSANACION_SOLICITADA`, `REENVIADO`, `VISTO_BUENO_CTC`, `EN_PLENO_CTC`, `FAVORABLE_CON_OBSERVACIONES`, `FAVORABLE` y `RECHAZADO`, con sus respectivos soportes documentales, revisiones punto a punto, tokens criptográficos y correos en bandeja de salida.
2. **Navegación Compacta mediante Lista Desplegable en el Registro General de Propuestas:**
   - En el componente *"Registro General de Propuestas Sometidas al Comité Técnico Científico"*, se reemplazó el listado extenso de filas por un selector desplegable (`<select>`) sincronizado con los filtros de búsqueda y estado, mostrando en la tabla inferior únicamente el proyecto seleccionado para agilizar la navegación.
3. **Bloqueo Post-Envío e Historial Inmutable de Versiones (`version_history`):**
   - Una vez que el investigador envía un *Sometimiento Inicial* o un *Nuevo Envío*, el formulario queda bloqueado en modo lectura y solo se desbloquea con la información prediligenciada cuando el Secretario o el Pleno del CTC solicitan modificaciones.
   - Cada versión enviada se conserva como un apéndice inmutable (`Versión 1`, `Versión 2`, etc.) visible tanto en la interfaz web como en el PDF oficial `CIM-FT-002-BUC`.
4. **Control Estricto de Firma Personal por Token Único y Separación de Roles:**
   - Cada miembro del CTC visualiza y consume exclusivamente su propio token criptográfico asignado a su cuenta institucional; ni el Secretario ni los Miembros del CTC crean propuestas de investigación (atribución exclusiva del Investigador Principal).
5. **Activación de Cuenta por Enlace de Correo y Despacho SMTP Real:**
   - Integración de envío SMTP con `lettre` y contenedor `mailpit`, además de detección automática del parámetro `?token=...` en la URL del frontend para abrir directamente el formulario de creación de contraseña.
