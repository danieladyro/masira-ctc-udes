# Plataforma del Comité Técnico Científico — Instituto MASIRA · Universidad de Santander (UDES)

Plataforma tecnológica informática en línea para la radicación, revisión iterativa, evaluación colegiada y firma mediante tokens de una sola utilización de propuestas de investigación de acuerdo con el formato oficial **`CIM-FT-002-BUC_SOMETIMIENTO INICIAL_V00_modificado`**.

## Arquitectura Tecnológica

- **Backend:** REST API en **Rust** (`axum`, `sqlx`, `jsonwebtoken`, `bcrypt`, `printpdf`, `sha2`) en la carpeta [`backend/`](file:///P:/pcloud/2026_ai/2026_pruebaai05/backend).
- **Base de Datos:** **PostgreSQL 16** con esquema relacional y campos `JSONB` para matrices de equipo, riesgos, presupuesto y cronograma en [`database/init.sql`](file:///P:/pcloud/2026_ai/2026_pruebaai05/database/init.sql).
- **Frontend:** **Angular 20** (`@angular/core` ^20.0.0) diseñado bajo el sistema visual **Bitácora Analítica y Cadena de Custodia MASIRA** en [`frontend/`](file:///P:/pcloud/2026_ai/2026_pruebaai05/frontend).
- **Despliegue en Contenedores Docker:** Orquestado mediante [`docker-compose.yml`](file:///P:/pcloud/2026_ai/2026_pruebaai05/docker-compose.yml) con contenedores dedicados para `frontend` ([`frontend/Dockerfile`](file:///P:/pcloud/2026_ai/2026_pruebaai05/frontend/Dockerfile)), `backend` ([`backend/Dockerfile`](file:///P:/pcloud/2026_ai/2026_pruebaai05/backend/Dockerfile)) y `postgres`.

## Configuración de Variables de Entorno (`.env`)

Todas las credenciales de base de datos, secretos criptográficos JWT y la contraseña inicial de las cuentas semilla se encuentran centralizados en el archivo `.env` (excluido del control de versiones mediante [`.gitignore`](file:///P:/pcloud/2026_ai/2026_pruebaai05/.gitignore)). Para nuevos entornos, copie la plantilla [`.env.example`](file:///P:/pcloud/2026_ai/2026_pruebaai05/.env.example) como `.env`.

## Ejecución con Docker Compose

```bash
docker compose up --build -d
```

- **Frontend Angular 20:** `http://localhost:4200`
- **Backend Rust REST API:** `http://localhost:8080/api/health`

## Roles del Sistema (Contraseña Inicial Definida en `SEED_DEFAULT_PASSWORD` dentro de `.env`)

| Rol | Usuario / Correo Institucional | Atribuciones Principales |
|---|---|---|
| **Investigador Principal (1)** | `carlos.gomez@udes.edu.co` | Diligencia las 6 secciones de `CIM-FT-002-BUC`, adjunta soportes, envía/reenvía propuestas, descarga el PDF compilado y consulta únicamente sus proyectos postulados. |
| **Investigadora Principal (2)** | `natalia.serrano@udes.edu.co` | Gestiona propuestas con concepto *Favorable con modificaciones* (subsanación de ajustes previos a firma definitiva). |
| **Secretario del Comité Técnico Científico** | `secretario.ctc@udes.edu.co` | Crea usuarios con envío de enlace de creación de contraseña por correo, revisa todos los proyectos, solicita modificaciones o da Visto Bueno al CTC, registra el concepto del pleno punto a punto, emite tokens de un solo uso y genera listados con campos seleccionables. |
| **Miembro del Comité Técnico Científico** | `jose.lopez@udes.edu.co` / `patricio.lopez@udes.edu.co` | Consulta todos los proyectos y genera informes PDF (sin permisos para calificar ni modificar proyectos), y firma la aprobación del pleno utilizando tokens de una sola utilización. |
| **Administrador del Sistema** | `admin.masira@udes.edu.co` | Gestión integral del sistema, usuarios, roles y auditoría de tokens y notificaciones. |
