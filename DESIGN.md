---
name: "Plataforma CTC Instituto MASIRA - UDES"
description: "Bitácora analítica y cadena de custodia documental para evaluación de propuestas científicas CIM-FT-002-BUC"
colors:
  udes-navy: "#0B2545"
  udes-navy-deep: "#071930"
  masira-teal: "#0F766E"
  masira-teal-hover: "#0B5C56"
  masira-teal-soft: "#CCFBF1"
  masira-teal-ink: "#064E3B"
  audit-amber: "#B45309"
  audit-amber-soft: "#FEF3C7"
  audit-amber-ink: "#78350F"
  danger-red: "#991B1B"
  danger-red-soft: "#FEE2E2"
  clinical-paper: "#F6F8F7"
  clinical-subtle: "#EDF2F0"
  surface-sheet: "#FFFFFF"
  ink-secondary: "#1D3B5E"
  ink-muted: "#3A5675"
  border-hairline: "#C5D3DE"
typography:
  display:
    fontFamily: "'Source Sans 3', -apple-system, BlinkMacSystemFont, sans-serif"
    fontSize: "2rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.02em"
  headline:
    fontFamily: "'Source Sans 3', -apple-system, BlinkMacSystemFont, sans-serif"
    fontSize: "1.45rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.02em"
  title:
    fontFamily: "'Source Sans 3', -apple-system, BlinkMacSystemFont, sans-serif"
    fontSize: "1.15rem"
    fontWeight: 700
    lineHeight: 1.25
  body:
    fontFamily: "'Source Sans 3', -apple-system, BlinkMacSystemFont, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "'JetBrains Mono', 'Consolas', monospace"
    fontSize: "0.82rem"
    fontWeight: 600
    lineHeight: 1.35
rounded:
  sm: "4px"
  md: "5px"
  lg: "6px"
spacing:
  xs: "6px"
  sm: "10px"
  md: "16px"
  lg: "24px"
  xl: "32px"
components:
  button-primary:
    backgroundColor: "{colors.masira-teal}"
    textColor: "{colors.surface-sheet}"
    rounded: "{rounded.md}"
    padding: "11px 18px"
  button-primary-hover:
    backgroundColor: "{colors.masira-teal-hover}"
  button-navy:
    backgroundColor: "{colors.udes-navy}"
    textColor: "{colors.surface-sheet}"
    rounded: "{rounded.md}"
    padding: "10px 16px"
  button-outline:
    backgroundColor: "{colors.surface-sheet}"
    textColor: "{colors.udes-navy}"
    rounded: "{rounded.md}"
    padding: "10px 15px"
  input-field:
    backgroundColor: "{colors.surface-sheet}"
    textColor: "{colors.udes-navy}"
    rounded: "{rounded.md}"
    padding: "10px 13px"
  sheet-panel:
    backgroundColor: "{colors.surface-sheet}"
    textColor: "{colors.udes-navy}"
    rounded: "{rounded.lg}"
    padding: "26px 28px"
---

# Design System: Plataforma CTC Instituto MASIRA - UDES

## Overview

**Creative North Star: "Bitácora Analítica y Cadena de Custodia MASIRA"**

El sistema visual une la autoridad institucional de la Universidad de Santander (UDES) y del Instituto de Investigación MASIRA con la precisión documental de los cuadernos de laboratorio biomédico y los registros clínicos de cadena de custodia. En lugar de tratar la radicación y evaluación de proyectos como un panel genérico de tarjetas grises, cada propuesta `CIM-FT-002-BUC` se presenta como un expediente técnico auditable sobre papel clínico reticulado, acompañado de sellos tabulares de verificación para las firmas de un solo uso del Comité Técnico Científico.

La densidad informativa está calibrada para sesiones extensas de lectura metodológica, revisión de matrices de riesgo y verificación presupuestal de once rubros en oficinas y salas de comité bien iluminadas. El color cumple funciones estrictamente operativas: el azul Prusia UDES estructura la navegación y los encabezados de control documental, el verde clínico MASIRA confirma acciones de avance y firmas verificadas, y el ámbar de auditoría advierte sobre subsanaciones o conceptos favorables condicionados a modificaciones.

**Key Characteristics:**
- Riel de navegación institucional en azul Prusia UDES (`#0B2545`) frente a una mesa de trabajo en papel clínico (`#F6F8F7`) con retícula técnica de puntos.
- Banda superior permanente de Cadena de Custodia que declara el radicado activo, la versión del envío y la única acción siguiente que corresponde al rol autenticado.
- Contraste tipográfico entre prosa académica humanista (`Source Sans 3`) y lectura técnica/financiera en monoespaciada tabular (`JetBrains Mono`).
- Hojas documentales enmarcadas con borde continuo de `1px` en azul UDES (`#0B2545`) sin tarjetas decorativas anidadas ni franjas laterales gruesas.

## Colors

Paleta de alto contraste inspirada en la papelería normativa controlada de la UDES, la identidad biomédica del Instituto MASIRA y los sellos de auditoría clínica.

### Primary
- **Azul Prusia Institucional UDES** (`#0B2545`): Color estructural del riel de navegación lateral, encabezados de tablas de registro (`ledger-table`), marcos de control del formato `CIM-FT-002-BUC` y texto primario sobre superficies claras.
- **Azul Noche Profundo UDES** (`#071930`): Variante de profundidad para selectores e indicadores alojados dentro del riel institucional.

### Secondary
- **Verde Clínico MASIRA** (`#0F766E`): Color de acción primaria, botones de envío/descarga de PDF oficial, pestaña activa en el riel lateral y sellos de firma verificada con token de un solo uso (`#0B5C56` en estado hover).
- **Menta Clínica Suave** (`#CCFBF1`) y **Tinta Esmeralda Profunda** (`#064E3B`): Fondo y texto para pastillas de estado aprobadas (`Concepto Favorable`, `Visto Bueno CTC`).

### Tertiary
- **Ámbar de Auditoría y Subsanación** (`#B45309`), **Fondo Ámbar Clínico** (`#FEF3C7`) y **Tinta Ámbar Oscura** (`#78350F`): Reservados para solicitudes de modificación de Secretaría Técnica y advertencias reglamentarias de conceptos favorables con observaciones pendientes de ajuste.
- **Rojo Dictamen Rechazado** (`#991B1B`) y **Fondo Coral Pálido** (`#FEE2E2`): Estados de rechazo definitivo o errores de validación.

### Neutral
- **Papel Clínico MASIRA** (`#F6F8F7`): Superficie base de toda la aplicación, complementada con una retícula radial sutil.
- **Gris Laboratorio Sutil** (`#EDF2F0`): Fondo de cabeceras secundarias, pistas de scroll y filas de totales presupuestales.
- **Hoja Documental Blanca** (`#FFFFFF`): Superficie de lectura y edición de los paneles `CIM-FT-002-BUC`.
- **Tinta Secundaria Pizarra Azul** (`#1D3B5E`) y **Tinta Atenuada** (`#3A5675`): Subtítulos, notas metodológicas y metadatos secundarios teñidos desde el matiz azul institucional (nunca gris neutro puro).
- **Filete Técnico** (`#C5D3DE`): Bordes internos de celdas tabulares y controles de formulario.

### Named Rules
**The Functional State Color Rule.** Los colores semánticos (verde clínico MASIRA, ámbar de auditoría, rojo dictamen) se emplean únicamente donde comunican el estado real de una propuesta o la validez de un token criptográfico, nunca como adorno decorativo.

**The Tinted Secondary Ink Rule.** Todo texto secundario o deshabilitado conserva matiz azul petróleo (`#1D3B5E` / `#3A5675` sobre claro y `#B6D0E2` sobre azul UDES), prohibiendo el uso de grises acromáticos apagados.

## Typography

**Display & Body Font:** `'Source Sans 3'` (con respaldo `-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`)
**Label/Mono Font:** `'JetBrains Mono'` (con respaldo `'Consolas', monospace` y `font-variant-numeric: tabular-nums`)

**Character:** Emparejamiento entre una sans humanista de lectura académica clara para protocolos extensos de investigación y una monoespaciada técnica de ancho fijo para radicados, presupuestos en pesos colombianos y hashes SHA-256 de firma única.

### Hierarchy
- **Display** (`700`, `2rem`, `line-height: 1.2`, `letter-spacing: -0.02em`): Títulos principales en la portada de acceso institucional.
- **Headline** (`700`, `1.35rem–1.45rem`, `line-height: 1.2`, `letter-spacing: -0.02em`): Título del proyecto activo en la banda de Cadena de Custodia y encabezados de cada hoja de trabajo.
- **Title** (`700`, `1.05rem–1.2rem`, `line-height: 1.25`): Numerales reglamentarios (`1.1`, `1.2`, `2.1`–`2.4`, `3`, `4`, `5`, `6`) del formato `CIM-FT-002-BUC`.
- **Body** (`400`/`500`, `1rem`, `line-height: 1.5`, medida máxima `65–75ch`): Textos metodológicos, planteamiento del problema, síntesis de revisiones y correos del sistema.
- **Label / Mono** (`600`/`700`, `0.78rem–0.85rem`, `tabular-nums`): Códigos `CIM-2026-014`, versiones `V1`/`V2`, celdas de presupuesto y tokens `CTC-SIG-...`.

### Named Rules
**The No-Kicker Rule.** Ningún encabezado (`h1`–`h4`) lleva etiquetas pequeñas en mayúsculas (*eyebrows* o *kickers*) encima; los códigos de radicado y pastillas de estado se ubican al lado del título en la misma línea o debajo como metadato.

**The Tabular Ledger Rule.** Todo importe monetario, fecha, versión, conteo de firmas y token criptográfico aplica obligatoriamente `font-family: var(--font-mono)` y `font-variant-numeric: tabular-nums`.

## Layout

Arquitectura espacial de estación de trabajo con riel lateral izquierdo fijo de `280px` (`grid-template-columns: 280px minmax(0, 1fr)`) y área operativa principal con padding de `24px 32px 48px` y separación vertical de `20px` entre bloques.

- **Banda Superior de Cadena de Custodia (`.custody-strip`):** Encabeza siempre el área de trabajo mostrando el proyecto seleccionado, su estado actual, la siguiente acción requerida según el rol activo y los botones de compilación instantánea a PDF.
- **Mesa Dividida de Evaluación (`.split-evaluation-grid`):** Rejilla asimétrica `1.2fr 0.9fr` que empareja el contenido o revisión punto a punto del expediente a la izquierda con el registro de firmas de tokens de un solo uso a la derecha.
- **Comportamiento Responsivo:** Por debajo de `1200px`, las rejillas divididas pasan a columna única (`minmax(0, 1fr)`). Por debajo de `900px` (tableta y móvil `390px`), el riel lateral se transforma en una barra superior compacta con navegación horizontal deslizable de módulos, garantizando cero desbordamiento horizontal.

## Elevation & Depth

El sistema utiliza hojas documentales planas delimitadas por bordes estructurales nítidos (`1px solid #0B2545`) acompañadas de una sombra ambiental suave con desplazamiento vertical para separar el papel clínico activo de la mesa reticulada de fondo.

### Shadow Vocabulary
- **Hoja Documental (`.sheet-panel`, `.custody-strip`):** `box-shadow: 0 8px 24px rgba(11, 37, 69, 0.07)` para dar presencia física de expediente sobre la superficie reticulada.
- **Hoja Elevada de Acceso (`.auth-sheet`):** `box-shadow: 0 14px 36px rgba(11, 37, 69, 0.13)` para el contenedor principal de inicio de sesión y activación de contraseña.

### Named Rules
**The Structural Border First Rule.** La jerarquía entre regiones proviene del contraste entre el papel clínico (`#F6F8F7`), la hoja blanca (`#FFFFFF`) y el filete de `1px solid #0B2545`, nunca de sombras duras desplazadas (`4px 4px 0`) ni de efectos de vidrio esmerilado (`backdrop-filter`).

## Shapes

Geometría documental sobria con radios de esquina contenidos (`4px` en insignias y pastillas, `5px` en botones y campos de entrada, `6px` en paneles de hoja completa). Todos los contenedores utilizan bordes uniformes de `1px` en sus cuatro lados, evitando acentos gruesos en un solo borde lateral.

## Components

### Buttons
- **Shape:** Esquinas técnicas suavizadas (`5px` radius) con borde explícito de `1px`.
- **Primary (`.btn-primary-action`, `.btn-teal-solid`):** Fondo verde clínico MASIRA (`#0F766E`), texto blanco (`#FFFFFF`), padding `10px 16px` a `11px 18px`, transición de `180ms cubic-bezier(0.16, 1, 0.3, 1)` hacia `#0B5C56`.
- **Institutional Navy (`.btn-navy-solid`):** Fondo azul UDES (`#0B2545`), texto blanco (`#FFFFFF`), empleado para la descarga del reporte oficial de Concepto del Comité Técnico Científico.
- **Secondary Outline (`.btn-secondary-outline`):** Fondo blanco (`#FFFFFF`), borde `1px solid #0B2545`, texto `#0B2545`, hover hacia `#EDF2F0`.

### Chips / Status Pills (`.status-pill`)
- **Style:** Insignias rectangulares (`4px` radius, padding `4px 10px`, `font-size: 0.78rem`, `font-weight: 700`) con borde completo de `1px`.
- **State:** Variantes semánticas por atributo `data-status`: verde clínico suave (`#CCFBF1` / `#064E3B`) para `FAVORABLE` y `VISTO_BUENO_CTC`, ámbar (`#FEF3C7` / `#78350F`) para `SUBSANACION_SOLICITADA` y `FAVORABLE_CON_OBSERVACIONES`, y rojo (`#FEE2E2` / `#991B1B`) para `RECHAZADO`.

### Cards / Containers (`.sheet-panel`)
- **Corner Style:** `6px` radius.
- **Background:** Blanco puro (`#FFFFFF`) sobre fondo reticulado `#F6F8F7`.
- **Shadow Strategy:** `0 8px 24px rgba(11, 37, 69, 0.07)`.
- **Border:** `1px solid #0B2545`.
- **Internal Padding:** `26px 28px` en escritorio, `16px` en móvil.

### Inputs / Fields
- **Style:** Fondo blanco (`#FFFFFF`), borde `1px solid #C5D3DE`, radio `5px`, padding `10px 13px`.
- **Focus:** Cambio de borde a `#0F766E` con anillo suave `0 0 0 3px rgba(15, 118, 110, 0.14)`.
- **Disabled:** Fondo `#EDF2F0` y texto `#3A5675` cuando el rol activo (p. ej., Miembro del CTC) opera en modo de solo lectura.

### Navigation (`.nav-rail`)
- **Style:** Riel izquierdo fijo en `#0B2545` con emblema SVG de la UDES y MASIRA, ficha del usuario autenticado, lista de módulos con contadores en `JetBrains Mono` y selector rápido de rol para pruebas. En pantallas `<= 900px` se compacta en una barra superior con riel horizontal de pestañas.

### Banda de Cadena de Custodia y Bóveda de Tokens Únicos (Signature Components)
- **Custody Strip (`.custody-strip`):** Encabezado operativo que vincula el título y código del proyecto con la instrucción exacta de siguiente paso para el rol activo y los dos compiladores PDF (`CIM-FT-002-BUC` y `Concepto CTC`).
- **Token Ledger Item (`.token-ledger-item`):** Registro individual de firma para cada miembro del Comité Técnico Científico que muestra el token de una sola utilización (`CTC-SIG-...`), su estado (`FIRMADO · 1 USO CONSUMIDO` o disponible para firma) y el resumen criptográfico `SHA-256`.

## Do's and Don'ts

### Do:
- **Do** mantener el encabezado normativo `CIM-FT-002-BUC (Versión 00)` tanto en la vista de formulario como en los documentos PDF descargables.
- **Do** aplicar `font-variant-numeric: tabular-nums` y fuente monoespaciada en todos los códigos de proyecto, presupuestos de los 11 rubros y tokens de firma única.
- **Do** preservar la atenuación contextual (`opacity: 0.45`) en las filas de observaciones punto a punto no seleccionadas cuando el Secretario del CTC inspecciona un numeral.

### Don't:
- **Don't** colocar etiquetas tipo *kicker* o *eyebrow* encima de ningún encabezado (`h1`–`h4`).
- **Don't** utilizar bordes laterales gruesos (`border-left` o `border-right` mayores a `1px`) en alertas, filas o contenedores.
- **Don't** habilitar controles de edición o calificación para el rol `MIEMBRO_CTC`, respetando la restricción normativa de que solo el Secretario del Comité Técnico Científico modifica o registra observaciones.
