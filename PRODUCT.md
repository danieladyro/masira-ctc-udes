# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

- **Frontend:** Angular 20 (SPA / SSR-ready web application, containerized in Docker)
- **Backend:** Rust REST API (Actix-web / Axum, JWT + OAuth2-style password setup & token authentication, PDF generation, containerized in Docker)
- **Database:** PostgreSQL
- **Infrastructure:** Docker & Docker Compose (separate containers for frontend, backend, and database)

## Users

1. **Investigador Principal (Principal Investigator):** Docentes e investigadores de la Universidad de Santander (UDES) adscritos o vinculados al Instituto MASIRA que formulan y someten propuestas de investigación para evaluación de viabilidad e interés. Solo pueden visualizar y gestionar los proyectos postulados a su nombre.
2. **Secretario del Comité Técnico Científico (CTC Secretary):** Responsable de crear cuentas de usuario (enviando enlace de creación de contraseña), revisar la completitud de los sometimientos iniciales, solicitar ajustes/mejoras en ciclos iterativos, otorgar el visto bueno para pasar a sesión del CTC, registrar el concepto y las observaciones punto a punto del pleno, gestionar la firma mediante tokens de un solo uso y exportar listados dinámicos de proyectos seleccionando campos a medida.
3. **Miembros del Comité Técnico Científico (CTC Members):** Evaluadores del comité que consultan la totalidad de propuestas y sus PDFs compilados, generan informes de consulta (sin permisos de edición directa ni calificación individual fuera del secretario) y aprueban/firman las actas y conceptos del pleno utilizando tokens de una sola utilización.
4. **Administrador del Sistema (System Administrator):** Gestiona usuarios, roles, parámetros del sistema, sesiones del comité y auditoría general de la plataforma.

## Product Purpose

Plataforma tecnológica en línea para la gestión integral, evaluación, revisión iterativa y emisión de conceptos de viabilidad de propuestas de investigación sometidas al Comité Técnico Científico del Instituto MASIRA de la Universidad de Santander (UDES), Facultad de Ciencias Médicas y de la Salud, previo a su formalización ante la Vicerrectoría de Investigaciones.

## Positioning

 Digitalización estructurada de extremo a extremo del formato oficial `CIM-FT-002-BUC (Versión 00)` de Sometimiento Inicial del Instituto MASIRA-UDES, integrando en un único flujo auditable: captura granular sección por sección con anexos probatorios, generación automática del documento oficial en PDF, ciclo de subsanación entre Investigador y Secretaría Técnica, evaluación punto a punto en sesión del Comité Técnico Científico y firma colegiada mediante tokens criptográficos de un solo uso.

## Operating Context

- **Sometimiento Inicial (`CIM-FT-002-BUC`):** El investigador diligencia todos los apartados reglamentarios:
  - **1. Identificación del Proyecto:** 1.1 Información general (Título, Programa/Unidad Académica, Campus, Grupo de respaldo, Líder del grupo, Línea de investigación, Investigador principal, Correo electrónico, Nombre Entidad Aliada, Lugar de Desarrollo, Nombre de la convocatoria, Tipo de convocatoria, Fecha límite) y 1.2 Equipo de trabajo (Nombre, Rol, Entidad, Responsabilidades).
  - **2. Resumen Ejecutivo:** 2.1 Planteamiento del problema y justificación, 2.1/2.2 Objetivo General y Objetivos Específicos, 2.3 Metodología (2.3.1 Diseño metodológico, 2.3.2 Ámbito del estudio, 2.3.3 Participantes y muestreo, 2.3.4 Criterios de elegibilidad, 2.3.5 Reclutamiento, 2.3.6 Técnicas de recolección de información, 2.3.7 Procedimientos, 2.3.8 Análisis de Datos, 2.3.9 Consideraciones éticas) y 2.4 Resultados y Productos Esperados.
  - **3. Posibles Alianzas y Trabajos en Red.**
  - **4. Análisis de Riesgos de Ejecución:** Matriz para riesgos Operacionales, Administrativos, Legales, Financieros, De costos y De calendario con Descripción, Probabilidad (`No probable`, `Poco probable`, `Probable`, `Muy probable`), Impacto (`Nulo`, `Leve`, `Moderado`, `Severo`) y Medidas de mitigación.
  - **5. Presupuesto (Resumen):** Tabla de 11 rubros (Talento humano, Equipos y software, Capacitación, Servicios tecnológicos y pruebas, Materiales/insumos/documentación, Protección de conocimiento y divulgación, Gastos de viaje, Infraestructura, Administrativos, Seguimiento, Otros) desglosados en Contrapartida UDES (Especie / Efectivo), Aliado (Especie / Efectivo), Entidad Convocatoria (Efectivo) y Total automático por fila y columna.
  - **6. Cronograma de actividades:** Matriz de Objetivos y Actividades a través de 12 trimestres (Año 1: T1-T4, Año 2: T5-T8, Año 3: T9-T12).
  - **Documentación adicional:** Carga de archivos anexos que sustenten el proyecto.
- **Ciclo de Revisión por Secretaría:** Envío con notificación por correo, revisión por parte del Secretario CTC, solicitud de modificaciones/mejoras (notificando al investigador para editar y reenviar actualizando versión e informe PDF) o Visto Bueno para agendar en el próximo Comité Técnico Científico.
- **Pleno del Comité Técnico Científico y Firma con Token Único:** Discusión sobre el PDF compilado, emisión del concepto (`Favorable`, `Favorable con observaciones`, `Rechazado`) con observaciones punto a punto. Si es `Favorable con observaciones/modificaciones`, se emite reporte preliminar sin firmas definitivas hasta que el investigador realice los ajustes o aclaraciones demandadas. Cuando procede la aprobación colegiada, cada miembro del CTC aprueba utilizando un token de una sola utilización, habilitando la descarga del concepto oficial firmado para el investigador.

## Capabilities and Constraints

- Autenticación mediante JWT / flujo OAuth2 password-setup: creación de cuentas desde el rol Secretario del CTC (y Administrador), envío de enlace único por correo electrónico para definición de contraseña inicial e inicio de sesión por rol.
- Bandeja de correo integrada/simulada en la plataforma (además de soporte SMTP configurable por variables de entorno) para permitir la verificación e inspección inmediata de enlaces de activación de contraseña, notificaciones de sometimiento/observaciones y tokens de firma de un solo uso dentro del entorno Docker.
- Generación de PDF oficial tanto para el documento de propuesta (`CIM-FT-002-BUC`) como para el reporte/acta de concepto del Comité Técnico Científico con registro de firmas por token de un solo uso.
- Generador dinámico de reportes y listados para el Secretario del CTC con selector de campos personalizables y exportación (CSV / PDF / vista tabular imprimible).
- Control estricto de permisos (RBAC) en el backend Rust y en las vistas de Angular 20.

## Brand Commitments

- Identidad institucional de la **Universidad de Santander (UDES)** ("Vigilada Mineducación | SNIES 2832") y del **Centro / Instituto de Investigación MASIRA** (Facultad de Ciencias Médicas y de la Salud, Bucaramanga).
- Fidelidad documental al encabezado y estructura de control del formato oficial **SOMETIMIENTO INICIAL CIM-FT-002-BUC Versión 00** (incluyendo tabla de Control de Cambios institucional en los documentos PDF generados).

## Evidence on Hand

- `especificaciones.pdf` / `especificaciones.md`: Documento de requerimientos funcionales y técnicos de la plataforma.
- `CIM-FT-002-BUC_SOMETIMIENTO INICIAL_V00_modificado.pdf` / `CIM-FT-002-BUC_SOMETIMIENTO INICIAL_V00_modificado.md`: Plantilla oficial del Centro de Investigación MASIRA - UDES con los campos, tablas de riesgos, presupuesto, cronograma trimestral y firmas de control de cambios.

## Product Principles

1. **Rigor normativo sin fricción:** Guiar al investigador a través de un formulario extenso (`CIM-FT-002-BUC`) con validación clara, autocalculado de totales presupuestales, guardado de progreso y compilación instantánea a PDF institucional.
2. **Trazabilidad transparente del ciclo de evaluación:** Cada cambio de estado, observación punto a punto, subsanación y firma con token de un solo uso queda registrado con marca de tiempo y actor responsable.
3. **Separación estricta de atribuciones por rol:** Garantizar que cada actor (Investigador, Secretario CTC, Miembro CTC, Administrador) opere en una estación de trabajo enfocada en sus responsabilidades exactas y límites de visibilidad.
4. **Autonomía operativa en contenedores:** Todo el flujo —desde la invitación por correo y activación de contraseña hasta la firma colegiada con token único y descarga de PDFs— debe funcionar de forma autónoma y verificable al levantar los contenedores Docker.
