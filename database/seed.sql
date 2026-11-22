-- =============================================================================
-- INSTITUTO DE INVESTIGACIÓN MASIRA - UNIVERSIDAD DE SANTANDER (UDES)
-- Archivo Semilla SQL (seed.sql) — Plataforma Comité Técnico Científico (CTC)
-- Formato Oficial: CIM-FT-002-BUC (Versión 00)
-- Contiene:
--   * 3 Miembros del Comité Técnico Científico (1 Secretario CTC + 2 Miembros CTC)
--   * 8 Investigadores Principales
--   * 20 Propuestas de investigación completas (CIM-2026-001 a CIM-2026-020)
--     distribuidas en todas las etapas del proceso de evaluación del CTC
--   * Soportes adjuntos, revisiones punto a punto, tokens criptográficos de
--     un solo uso y bandeja de notificaciones de correo electrónico
-- Contraseña por defecto de las cuentas activas: Masira2026*
-- =============================================================================

BEGIN;

-- Limpieza previa en orden de dependencias para ejecución idempotente
DELETE FROM email_outbox;
DELETE FROM ctc_signature_tokens;
DELETE FROM proposal_reviews;
DELETE FROM proposal_attachments;
DELETE FROM proposals;
DELETE FROM users;

-- =============================================================================
-- 1. TRES MIEMBROS DEL COMITÉ TÉCNICO CIENTÍFICO (1 SECRETARIO + 2 MIEMBROS)
-- =============================================================================

-- Miembro CTC 1 (Secretaria del Comité Técnico Científico)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active
) VALUES (
    '10000000-0000-0000-0000-000000000001',
    'secretario.ctc@udes.edu.co',
    'Mabel Margoth Reyes',
    'SECRETARIO_CTC',
    'Secretaría Técnica — Comité Técnico Científico MASIRA',
    'Comité Técnico Científico MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE
);

-- Miembro CTC 2 (Miembro del Comité Técnico Científico)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active
) VALUES (
    '10000000-0000-0000-0000-000000000002',
    'patricio.lopez@udes.edu.co',
    'Patricio López Jaramillo',
    'MIEMBRO_CTC',
    'Dirección Científica — Instituto de Investigación MASIRA',
    'Comité Técnico Científico MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE
);

-- Miembro CTC 3 (Miembro del Comité Técnico Científico)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active
) VALUES (
    '10000000-0000-0000-0000-000000000003',
    'jose.lopez@udes.edu.co',
    'Dr. José Patricio López López',
    'MIEMBRO_CTC',
    'Dirección de Diseño y Desarrollo de Proyectos — Instituto MASIRA',
    'Comité Técnico Científico MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE
);

-- =============================================================================
-- 2. OCHO INVESTIGADORES PRINCIPALES
-- =============================================================================

-- Investigador 1 (Proyecto CIM-2026-001 en estado BORRADOR)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000001',
    'carlos.gomez@udes.edu.co',
    'Carlos Andrés Gómez Sarmiento',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina',
    'Grupo Cardiometabólico MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- Investigadora 2 (Proyecto CIM-2026-002 en estado SOMETIDO)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000002',
    'natalia.serrano@udes.edu.co',
    'Natalia Sofía Serrano Rojas',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Bacteriología y Laboratorio Clínico',
    'Grupo de Enfermedades Infecciosas y Genómica MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- Investigadora 3 (Proyecto CIM-2026-003 en estado SUBSANACION_SOLICITADA)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000003',
    'laura.mantilla@udes.edu.co',
    'Dra. Laura Juliana Mantilla Pinzón',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Enfermería',
    'Grupo de Cuidado Crítico y Salud Materno-Perinatal MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- Investigador 4 (Proyecto CIM-2026-004 en estado REENVIADO)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000004',
    'andres.villamizar@udes.edu.co',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Fisioterapia',
    'Grupo de Neurociencias y Rehabilitación Funcional MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- Investigadora 5 (Proyecto CIM-2026-005 en estado VISTO_BUENO_CTC)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000005',
    'claudia.jaimes@udes.edu.co',
    'Claudia Patricia Jaimes Calderón',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Instrumentación Quirúrgica',
    'Grupo de Bioingeniería y Seguridad del Paciente MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- Investigador 6 (Proyecto CIM-2026-006 en estado EN_PLENO_CTC)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000006',
    'mauricio.pineda@udes.edu.co',
    'Mauricio Alejandro Pineda Vargas',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina',
    'Grupo de Biología Molecular y Oncología Traslacional MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- Investigadora 7 (Proyecto CIM-2026-007 en estado FAVORABLE_CON_OBSERVACIONES)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000007',
    'diana.duarte@udes.edu.co',
    'Diana Carolina Duarte Meneses',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Terapia Ocupacional y Fonoaudiología',
    'Grupo de Salud Digital y Rehabilitación Comunitaria MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- Investigador 8 (Proyecto CIM-2026-008 en estado FAVORABLE con firmas completas)
INSERT INTO users (
    id, email, full_name, role, academic_unit, research_group, password_hash, is_active, created_by
) VALUES (
    '20000000-0000-0000-0000-000000000008',
    'jorge.castellanos@udes.edu.co',
    'Jorge Enrique Castellanos Rueda',
    'INVESTIGADOR',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina y Salud Pública',
    'Grupo de Epidemiología Clínica y Enfermedades Tropicales MASIRA',
    crypt('Masira2026*', gen_salt('bf', 10)),
    TRUE,
    '10000000-0000-0000-0000-000000000001'
);

-- =============================================================================
-- 3. VEINTE PROPUESTAS DE INVESTIGACIÓN EN DIFERENTES ETAPAS DEL PROCESO CTC
-- =============================================================================

-- -----------------------------------------------------------------------------
-- PROPUESTA 1: CIM-2026-001 | Etapa 1: BORRADOR (En formulación por el investigador)
-- Investigador: Dr. Carlos Andrés Gómez Sarmiento
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000001',
    'CIM-2026-001',
    '20000000-0000-0000-0000-000000000001',
    'BORRADOR',
    1,
    'Fenotipado hemodinámico no invasivo y rigidez arterial temprana en adultos jóvenes con prehipertensión en Bucaramanga',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina',
    'Bucaramanga',
    'Grupo Cardiometabólico MASIRA',
    'Patricio López Jaramillo',
    'Enfermedades Crónicas No Transmisibles y Salud Vascular',
    'Carlos Andrés Gómez Sarmiento',
    'carlos.gomez@udes.edu.co',
    'Fundación Cardiovascular de Colombia (FCV)',
    'Bucaramanga y Área Metropolitana, Santander',
    'Convocatoria Interna de Fomento a la Investigación CTeI en Salud UDES 2026',
    'Interna con Alianza Externa',
    '2026-12-20',
    '[
      {"nombre":"Carlos Andrés Gómez Sarmiento","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección científica del protocolo, evaluación hemodinámica y análisis estadístico"},
      {"nombre":"Silvia Fernanda Duarte","rol":"Coinvestigadora Clínica","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Tonometría de aplanamiento, velocidad de onda de pulso y control de calidad"}
    ]'::jsonb,
    'La elevación subClínica de la velocidad de onda de pulso carótido-femoral antecede el desarrollo de hipertensión arterial sostenida en población joven, pero no existen valores de referencia locales ajustados por composición corporal en Santander.',
    'Establecer la asociación entre parámetros de rigidez arterial central y marcadores inflamatorios séricos en adultos de 20 a 40 años con prehipertensión en Bucaramanga.',
    E'1. Determinar la velocidad de onda de pulso y el índice de aumentación aórtica en 240 participantes.\n2. Correlacionar la masa muscular apendicular y tejido adiposo visceral con la presión aórtica central.\n3. Proponer puntos de corte clínicos para tamizaje vascular temprano.',
    'Estudio observacional analítico de corte transversal con componente de validación diagnóstica.',
    'Laboratorio de Función Vascular del Instituto MASIRA - UDES, Campus Lagos del Cacique, Bucaramanga.',
    'Muestreo probabilístico estratificado por sexo y grupos quinquenales de edad de n = 240 adultos jóvenes.',
    'Inclusión: Adultos de 20 a 40 años con PA sistólica entre 120-139 mmHg o diastólica entre 80-89 mmHg. Exclusión: Tratamiento antihipertensivo previo o cardiopatía estructural.',
    'Convocatoria en servicios de salud universitaria y jornadas preventivas en empresas aliadas del área metropolitana.',
    'Oscilometría de pulso braquial-aórtica validada, bioimpedanciometría tetrapolar y perfil lipídico-inflamatorio en ayuno.',
    'Reposo supino estandarizado de 15 minutos, triple medición de presión central y toma de muestra venosa periférica.',
    'Modelos de regresión lineal múltiple, curvas ROC y análisis de concordancia de Bland-Altman en R v4.4.',
    'Investigación con riesgo mínimo según Resolución 8430 de 1993. Consentimiento informado escrito y custodia anonimizada en REDCap.',
    '1 artículo en revista indexada Q1/Q2, 1 guía operativa de tamizaje vascular y formación de 2 estudiantes de semillero UDES.',
    'Red Colombiana de Prevención Cardiovascular y Sociedad Colombiana de Cardiología.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Descalibración del tonómetro arterial durante jornadas intensivas","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Verificación diaria con fantoma de presión antes de iniciar mediciones."},
      {"tipoRiesgo":"Administrativos","descripcion":"Retraso en agendamiento de participantes en horario laboral","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Habilitación de horarios extendidos los sábados en la mañana en MASIRA."},
      {"tipoRiesgo":"Legales","descripcion":"Suscripción de acta de confidencialidad de datos clínicos","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Formato institucional preaprobado por Secretaría Jurídica UDES."},
      {"tipoRiesgo":"Financieros","descripcion":"Variación en precios de reactivos de proteína C reactiva ultrasensible","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Compra consolidada al inicio de la ejecución presupuestal."},
      {"tipoRiesgo":"De costos","descripcion":"Reprocesamiento de muestras hemolizadas","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Reserva del 8% de consumibles de venopunción y centrifugación inmediata."},
      {"tipoRiesgo":"De calendario","descripcion":"Menor afluencia durante periodos vacacionales universitarios","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Concentración del reclutamiento en los trimestres lectivos T2 a T6."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":24000000,"contrapartidaUdesEfectivo":8000000,"aliadoEspecie":6000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":12000000,"total":50000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":9000000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":8000000,"total":25000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":1500000,"total":3500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":7000000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":10000000,"total":24000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":6500000,"aliadoEspecie":0,"aliadoEfectivo":2500000,"entidadConvocatoriaEfectivo":7000000,"total":16000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3000000,"total":6000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2200000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2200000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":6000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000}
    ]'::jsonb,
    137200000,
    '[
      {"objetivo":"OE1. Alistamiento ético, calibración hemodinámica y reclutamiento basal","actividades":"Aprobación ética, estandarización de tonometría y vinculación de cohorte","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Evaluación vascular, bioimpedancia y procesamiento bioquímico","actividades":"Medición de VOP, cuantificación sérica y auditoría de base de datos","trimestres":[false,false,true,true,true,true,false,false,false,false,false,false]},
      {"objetivo":"OE3. Modelado estadístico y divulgación científica","actividades":"Construcción de curvas de referencia, manuscrito Q1 y socialización","trimestres":[false,false,false,false,false,false,true,true,true,false,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NULL
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 2: CIM-2026-002 | Etapa 2: SOMETIDO (Radicado ante Secretaría Técnica)
-- Investigadora: Dra. Natalia Sofía Serrano Rojas
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000002',
    'CIM-2026-002',
    '20000000-0000-0000-0000-000000000002',
    'SOMETIDO',
    1,
    'Vigilancia genómica de aislamientos clínicos de Klebsiella pneumoniae productora de carbapenemasas en unidades de cuidado intensivo de Santander',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Bacteriología y Laboratorio Clínico',
    'Bucaramanga',
    'Grupo de Enfermedades Infecciosas y Genómica MASIRA',
    'Natalia Sofía Serrano Rojas',
    'Resistencia Antimicrobiana, Genómica y Vigilancia Epidemiológica',
    'Natalia Sofía Serrano Rojas',
    'natalia.serrano@udes.edu.co',
    'Hospital Universitario de Santander (HUS)',
    'Bucaramanga, Santander',
    'Convocatoria Nacional de Investigación en Salud Pública y Resistencia Antimicrobiana 2026',
    'Externa — Minciencias / INS',
    '2026-12-22',
    '[
      {"nombre":"Dra. Natalia Sofía Serrano Rojas","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección microbiológica, curaduría genómica y coordinación interinstitucional"},
      {"nombre":"MSc. Camilo Ernesto Rueda","rol":"Coinvestigador Bioinformático","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Ensamblaje de genomas de novo, tipificación MLST y análisis filogenético"}
    ]'::jsonb,
    'La circulación simultánea de carbapenemasas KPC-2, KPC-3 y NDM-1 en unidades de cuidado intensivo de Santander limita las opciones terapéuticas y exige caracterización genómica de alta resolución para contener brotes nosocomiales.',
    'Caracterizar mediante secuenciación de genoma completo los linajes clonales, plásmidos conjugativos y determinantes de virulencia en aislamientos invasivos de K. pneumoniae resistentes a carbapenémicos.',
    E'1. Confirmar el fenotipo y genotipo de carbapenemasas en 150 aislamientos clínicos invasivos.\n2. Identificar secuencias tipo (ST), resistomas y plásmidos mediante secuenciación Illumina.\n3. Establecer corredores de transmisión intrahospitalaria mediante distancia de SNPs.',
    'Estudio observacional descriptivo y genómico molecular prospectivo multicéntrico.',
    'Tres unidades de cuidado intensivo de tercer nivel de Bucaramanga y Laboratorio de Genómica MASIRA - UDES.',
    'Muestreo consecutivo por conveniencia de 150 aislamientos clínicos no duplicados recuperados de hemocultivos y secreciones respiratorias.',
    'Inclusión: Aislamientos de K. pneumoniae con CIM elevada a meropenem o imipenem. Exclusión: Aislamientos de tamizaje rectal sin infección.',
    'Recolección semanal en los laboratorios de microbiología hospitalarios con transporte refrigerado certificado.',
    'Microdilución en caldo automatizada, prueba CarbaNP, PCR múltiple y secuenciación de genoma completo (WGS).',
    'Extracción de ADN por columnas de sílice, preparación de librerías Nextera XT, secuenciación paired-end 2x150 pb y análisis con Kleborate y ResFinder.',
    'Análisis filodinámico de máxima verosimilitud (IQ-TREE) y regresión multivariable de factores clínicos asociados a mortalidad a 30 días.',
    'Investigación sin riesgo directo sobre pacientes humanos, utilizando aislamientos bacterianos y metadatos clínicos disociados.',
    'Repositorio genómico en NCBI BioProject, boletín técnico para comités de infecciones y 2 artículos Q1.',
    'Red Latinoamericana de Vigilancia de la Resistencia a los Antimicrobianos (ReLAVRA) e Instituto Nacional de Salud (INS).',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Contaminación cruzada o degradación de ADN genómico antes de librerías","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Cuantificación fluorométrica Qubit y control de integridad en gel de agarosa."},
      {"tipoRiesgo":"Administrativos","descripcion":"Demora en firma de acta de transferencia de material biológico con hospitales","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Trámite simultáneo ante los comités de ética hospitalarios desde el mes 1."},
      {"tipoRiesgo":"Legales","descripcion":"Permisos de acceso a recursos genéticos o depósito internacional","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Aplicación de exención reglamentaria para microorganismos patógenos clínicos."},
      {"tipoRiesgo":"Financieros","descripcion":"Incremento en costo de cartuchos de secuenciación importados","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Contratación por lotes de 50 genomas con tarifa congelada en pesos."},
      {"tipoRiesgo":"De costos","descripcion":"Necesidad de resecuenciación por cobertura inferior a 40x","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Normalización equimolar estricta de librerías previo al cargue."},
      {"tipoRiesgo":"De calendario","descripcion":"Variación estacional en la incidencia de infecciones por K. pneumoniae","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Participación simultánea de tres centros hospitalarios de alta complejidad."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":22000000,"contrapartidaUdesEfectivo":9000000,"aliadoEspecie":8000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":14000000,"total":53000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":11000000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":9000000,"total":24000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":12500000,"aliadoEspecie":0,"aliadoEfectivo":5000000,"entidadConvocatoriaEfectivo":16000000,"total":36500000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":9800000,"aliadoEspecie":0,"aliadoEfectivo":3200000,"entidadConvocatoriaEfectivo":8500000,"total":21500000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2500000,"total":6000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2100000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2100000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":4000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":800000}
    ]'::jsonb,
    153400000,
    '[
      {"objetivo":"OE1. Recolección multicéntrica y confirmación fenotípica de aislamientos","actividades":"Criopreservación en biobanco, pruebas de sensibilidad y PCR de carbapenemasas","trimestres":[true,true,true,true,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Secuenciación de genoma completo y ensamblaje bioinformático","actividades":"Extracción de ADN, secuenciación Illumina y determinación de resistoma","trimestres":[false,false,false,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Análisis filodinámico y socialización epidemiológica","actividades":"Construcción de árboles de SNPs, informe hospitalario y publicación científica","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '6 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 3: CIM-2026-003 | Etapa 3: SUBSANACION_SOLICITADA (Secretaría pidió ajustes)
-- Investigadora: Dra. Laura Juliana Mantilla Pinzón
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000003',
    'CIM-2026-003',
    '20000000-0000-0000-0000-000000000003',
    'SUBSANACION_SOLICITADA',
    1,
    'Sistema de alerta temprana multiparamétrica guiado por enfermería para la detección precoz de sepsis materna en hospitales de segundo nivel',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Enfermería',
    'Bucaramanga',
    'Grupo de Cuidado Crítico y Salud Materno-Perinatal MASIRA',
    'Laura Juliana Mantilla Pinzón',
    'Cuidado Crítico, Seguridad Clínica y Salud Materno-Perinatal',
    'Dra. Laura Juliana Mantilla Pinzón',
    'laura.mantilla@udes.edu.co',
    'ESE Clínica de Maternidad Rafael Calvo / Hospital Regional del Magdalena Medio',
    'Bucaramanga y Barrancabermeja, Santander',
    'Convocatoria de Investigación Aplicada en Seguridad Materna y Neonatal 2026',
    'Interna con Impacto Regional',
    '2026-12-18',
    '[
      {"nombre":"Dra. Laura Juliana Mantilla Pinzón","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Coordinación general, validación clínica de la escala MEOWS modificada y capacitación"},
      {"nombre":"Enf. Esp. Diana Marcela Rojas","rol":"Coinvestigadora de Campo","entidad":"Universidad de Santander (UDES)","responsabilidades":"Supervisión de rondas de enfermería obstétrica y auditoría de adherencia"}
    ]'::jsonb,
    'La demora en el reconocimiento de signos hemodinámicos sutiles durante el puerperio inmediato incrementa el ingreso a cuidado intensivo obstétrico. Una escala de alerta obstétrica digitalizada por enfermería permite activar código sepsis en menos de 30 minutos.',
    'Evaluar el desempeño diagnóstico y el impacto en tiempos de respuesta clínica de un sistema de alerta temprana obstétrica (MEOWS-MASIRA) en servicios de hospitalización materna.',
    E'1. Validar la sensibilidad y especificidad del puntaje MEOWS-MASIRA en 420 gestantes y puérperas.\n2. Medir la reducción en el tiempo hasta la administración de antibiótico empírico.\n3. Evaluar la adherencia del personal de enfermería al protocolo estandarizado.',
    'Estudio cuasiexperimental antes-después con cohorte prospectiva de validación diagnóstica.',
    'Servicios de hospitalización obstétrica y urgencias ginecobstétricas en dos hospitales de Santander.',
    '420 pacientes obstétricas ingresadas con sospecha de infección o factores de riesgo infeccioso.',
    'Inclusión: Gestantes en tercer trimestre o puérperas hasta 42 días posparto. Exclusión: Remisión con choque séptico instaurado.',
    'Vigilancia activa en admisión obstétrica y pisos de hospitalización durante turnos diurnos y nocturnos.',
    'Registro electrónico en tableta clínica de frecuencia respiratoria, temperatura, PA, frecuencia cardíaca, estado de conciencia y lactato capilar.',
    'Monitorización cada 4 horas por enfermería, disparo automático de alerta amarilla/roja y activación del equipo de respuesta rápida.',
    'Curvas ROC, cálculo de sensibilidad, especificidad, valores predictivos y regresión de riesgos proporcionales de Cox.',
    'Riesgo mínimo según Resolución 8430 de 1993. Aval del comité de ética institucional y consentimiento informado.',
    '1 herramienta clínica validada, 1 artículo en revista indexada de enfermería de cuidado crítico y manual de práctica clínica.',
    'Red Colombiana de Enfermería en Cuidado Crítico y Secretaría de Salud de Santander.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Rotación de personal de enfermería en los servicios de hospitalización obstétrica","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Microtalleres mensuales de inducción y cápsulas de entrenamiento en turno."},
      {"tipoRiesgo":"Administrativos","descripcion":"Integración del formulario con el historial clínico hospitalario","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Captura paralela en plataforma REDCap institucional sin interferir en el HIS."},
      {"tipoRiesgo":"Legales","descripcion":"Reserva de identidad de pacientes menores de edad gestantes","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Asentimiento informado y consentimiento del representante legal."},
      {"tipoRiesgo":"Financieros","descripcion":"Variación en el costo de tirillas de lactato capilar junto a la cama","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Convenio de suministro directo con distribuidor nacional."},
      {"tipoRiesgo":"De costos","descripcion":"Reposición de tabletas de captura en servicios de urgencias","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Carcasas de grado hospitalario lavables y aseguradas."},
      {"tipoRiesgo":"De calendario","descripcion":"Retraso en la fase basal de observación pre-intervención","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Inicio simultáneo en las dos sedes hospitalarias."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":19000000,"contrapartidaUdesEfectivo":6500000,"aliadoEspecie":5000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":11000000,"total":41500000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":6000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":5000000,"total":13000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3200000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":2000000,"total":6700000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":4500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":6000000,"total":12500000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":7200000,"aliadoEspecie":0,"aliadoEfectivo":2800000,"entidadConvocatoriaEfectivo":8000000,"total":18000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2500000,"total":5000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3400000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":3400000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":5000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1800000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1200000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":900000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":900000}
    ]'::jsonb,
    109000000,
    '[
      {"objetivo":"OE1. Cohorte basal y entrenamiento en escala MEOWS-MASIRA","actividades":"Estandarización de enfermería y medición de línea base","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Implementación prospectiva y monitoreo de alertas","actividades":"Aplicación en sala de maternidad y auditoría de código sepsis","trimestres":[false,false,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Evaluación de exactitud diagnóstica y transferencia","actividades":"Análisis de curvas ROC y entrega de guía operativa","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '10 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 4: CIM-2026-004 | Etapa 4: REENVIADO (Subsanado por el investigador en V2)
-- Investigador: Dr. Andrés Felipe Villamizar Ortiz
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000004',
    'CIM-2026-004',
    '20000000-0000-0000-0000-000000000004',
    'REENVIADO',
    2,
    'Análisis cinemático tridimensional y electromiografía de superficie en la recuperación de la marcha posreconstrucción de ligamento cruzado anterior',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Fisioterapia',
    'Bucaramanga',
    'Grupo de Neurociencias y Rehabilitación Funcional MASIRA',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'Biomecánica Clínica, Movimiento Corporal Humano y Rehabilitación',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'andres.villamizar@udes.edu.co',
    'Instituto de Ortopedia y Traumatología de Santander',
    'Bucaramanga, Santander',
    'Convocatoria Interna de Investigación en Ciencias de la Rehabilitación UDES 2026',
    'Interna Fomento CTeI',
    '2026-12-15',
    '[
      {"nombre":"Dr. Andrés Felipe Villamizar Ortiz","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Diseño biomecánico, procesamiento de señales EMG y dirección del ensayo"},
      {"nombre":"Ft. MSc. Julián David Cáceres","rol":"Coinvestigador Biomecánico","entidad":"Universidad de Santander (UDES)","responsabilidades":"Captura optoelectrónica 3D y ejecución del protocolo de control neuromuscular"}
    ]'::jsonb,
    'Hasta el 35% de los pacientes intervenidos de reconstrucción de ligamento cruzado anterior presentan asimetrías persistentes en el momento extensor de rodilla al sexto mes, incrementando el riesgo de rerruptura al retorno deportivo.',
    'Evaluar el efecto de un programa de readaptación neuromuscular con biofeedback electromiográfico en tiempo real sobre la simetría cinemática y activación de isquiotibiales tras plastia de LCA.',
    E'1. Cuantificar el índice de simetría de extremidades en ángulos sagitales y frontales de rodilla en 64 pacientes.\n2. Comparar la coactivación vasto medial / bíceps femoral mediante EMG de superficie a las 8, 16 y 24 semanas.\n3. Determinar la tasa de retorno funcional seguro.',
    'Ensayo clínico controlado aleatorizado con evaluación biomecánica ciega.',
    'Laboratorio de Análisis de Movimiento del Programa de Fisioterapia UDES e Instituto MASIRA.',
    '64 adultos jóvenes operados de reconstrucción primaria de LCA asignados 1:1 a rehabilitación convencional vs. biofeedback EMG (potencia 80%, alfa 0.05, pérdida estimada ajustada al 15%).',
    'Inclusión: Adultos de 18 a 35 años en semana 6 posoperatoria de plastia primaria de LCA. Exclusión: Lesión multiligamentaria o meniscectomía total.',
    'Remisión directa desde consulta de ortopedia deportiva de las clínicas aliadas.',
    'Sistema optoelectrónico de 8 cámaras infrarrojas, plataformas de fuerza triaxiales y EMG inalámbrica de 16 canales (normas SENIAM).',
    'Colocación de 22 marcadores reflectivos según modelo Plug-in-Gait, normalización de contracción isométrica voluntaria máxima y 3 sesiones semanales durante 12 semanas.',
    'ANOVA de medidas repetidas de dos vías (grupo x tiempo) y tamaño del efecto d de Cohen.',
    'Riesgo mínimo con póliza de cobertura clínica y supervisión fisioterapéutica permanente.',
    'Protocolo de biofeedback transferido a la clínica universitaria y 1 artículo original Q1/Q2.',
    'Asociación Colombiana de Fisioterapia y Sociedad Latinoamericana de Artroscopia y Rodilla.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Artefactos de movimiento en electrodos de superficie durante saltos","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Fijación con vendaje adhesivo hipoalergénico y filtrado pasa-banda 20-450 Hz."},
      {"tipoRiesgo":"Administrativos","descripcion":"Inasistencia a sesiones presenciales por desplazamiento","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Auxilio de transporte estudiantil y recordatorios automatizados 24h antes."},
      {"tipoRiesgo":"Legales","descripcion":"Autorización de uso de registros de video biomecánico","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Cláusula específica de anonimización de rostro en el consentimiento informado."},
      {"tipoRiesgo":"Financieros","descripcion":"Alza en electrodos desechables de hidrogel de plata/cloruro de plata","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Adquisición del lote completo para las 192 evaluaciones al inicio."},
      {"tipoRiesgo":"De costos","descripcion":"Mantenimiento preventivo de cámaras infrarrojas","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Cubierto por el contrato anual de mantenimiento de laboratorios UDES."},
      {"tipoRiesgo":"De calendario","descripcion":"Demora en remisión posquirúrgica desde ortopedia","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Tamizaje semanal en junta médico-quirúrgica de rodilla."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":20000000,"contrapartidaUdesEfectivo":5000000,"aliadoEspecie":4000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":9000000,"total":38000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":6000000,"contrapartidaUdesEfectivo":4500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":6000000,"total":16500000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":1500000,"total":3000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2500000,"contrapartidaUdesEfectivo":3000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":4000000,"total":11500000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":4800000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":5200000,"total":11500000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2500000,"total":5000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":4500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1200000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":700000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":700000}
    ]'::jsonb,
    95200000,
    '[
      {"objetivo":"OE1. Calibración optoelectrónica y reclutamiento de pacientes pos-LCA","actividades":"Configuración de cámaras, aleatorización y evaluación basal semana 6","trimestres":[true,true,false,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Intervención con biofeedback EMG y seguimiento a 16 y 24 semanas","actividades":"Sesiones supervisadas y registros cinemáticos seriados","trimestres":[false,true,true,true,true,true,false,false,false,false,false,false]},
      {"objetivo":"OE3. Procesamiento de señales y publicación de resultados","actividades":"Cálculo de índices de simetría y redacción de manuscrito","trimestres":[false,false,false,false,false,false,true,true,true,false,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '4 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 5: CIM-2026-005 | Etapa 5: VISTO_BUENO_CTC (Avalada por Secretaría y agendada al CTC)
-- Investigadora: Dra. Claudia Patricia Jaimes Calderón
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000005',
    'CIM-2026-005',
    '20000000-0000-0000-0000-000000000005',
    'VISTO_BUENO_CTC',
    2,
    'Validación de un protocolo de bioluminiscencia de ATP e indicadores fluorescentes para la auditoría de esterilización y limpieza quirúrgica de alta complejidad',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Instrumentación Quirúrgica',
    'Bucaramanga',
    'Grupo de Bioingeniería y Seguridad del Paciente MASIRA',
    'Dra. Claudia Patricia Jaimes Calderón',
    'Seguridad del Paciente Quirúrgico, Bioingeniería y Control de Infecciones',
    'Dra. Claudia Patricia Jaimes Calderón',
    'claudia.jaimes@udes.edu.co',
    'Clínica Chicamocha S.A. — Central de Esterilización y Quirófanos',
    'Bucaramanga, Santander',
    'Convocatoria de Investigación en Calidad y Seguridad Hospitalaria UDES 2026',
    'Interna con Alianza Hospitalaria',
    '2026-12-12',
    '[
      {"nombre":"Dra. Claudia Patricia Jaimes Calderón","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección del protocolo en salas de cirugía y central de esterilización"},
      {"nombre":"Inst. MSc. Paola Andrea Tarazona","rol":"Coinvestigadora Quirúrgica","entidad":"Universidad de Santander (UDES)","responsabilidades":"Muestreo de lúmenes de cirugía mínimamente invasiva y lectura en luminómetro"}
    ]'::jsonb,
    'La inspección visual del instrumental laparoscópico y de artroscopia no detecta biopelículas residuales microscópicas dentro de las cánulas, lo que incrementa el riesgo de infección del sitio operatorio profundo.',
    'Evaluar la concordancia diagnóstica entre bioluminiscencia de trifosfato de adenosina (ATP), marcadores ultravioleta y cultivo microbiológico cuantitativo en instrumental quirúrgico de mínima invasión.',
    E'1. Determinar las unidades relativas de luz (URL) de ATP residual en 300 piezas de instrumental laparoscópico.\n2. Establecer el punto de corte óptimo de URL frente al recuento de unidades formadoras de colonia.\n3. Reducir en un 60% la tasa de reprocesamiento fallido en central de esterilización.',
    'Estudio analítico de evaluación de pruebas diagnósticas y mejora continua de procesos quirúrgicos.',
    'Central de Esterilización de la Clínica Aliada y Laboratorio de Microbiología MASIRA - UDES.',
    '300 ciclos de lavado ultrasónico y termodesinfección de instrumental laparoscópico seleccionados aleatoriamente.',
    'Inclusión: Instrumental canulado de cirugía laparoscópica, urológica y artroscópica tras lavado estandarizado. Exclusión: Instrumental nuevo sin uso clínico previo.',
    'Muestreo diario estratificado por turno quirúrgico en la zona gris de la central de esterilización.',
    'Hisopado de canal interno para bioluminiscencia de ATP, inspección boroscópica digital y cultivo en agar sangre/MacConkey.',
    'Toma de muestra antes y después del lavado enzimático ultrasónico, lectura inmediata en luminómetro calibrado e incubación por 48 horas.',
    'Coeficiente kappa de Fleiss, área bajo la curva ROC y gráficos de control estadístico de procesos (SPC).',
    'Investigación sin sujetos humanos; confidencialidad institucional de los indicadores internos de calidad quirúrgica.',
    'Protocolo estandarizado de liberación de instrumental canulado y 1 artículo en revista indexada.',
    'Asociación Colombiana de Instrumentación Quirúrgica y Red de Seguridad del Paciente de Santander.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Interferencia de detergentes enzimáticos residuales con la enzima luciferasa","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Enjuague final estandarizado con agua desionizada estéril antes del hisopado."},
      {"tipoRiesgo":"Administrativos","descripcion":"Alta demanda de quirófanos en horas pico que limite el tiempo de muestreo","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Ejecución del protocolo de lectura en menos de 3 minutos por bandeja."},
      {"tipoRiesgo":"Legales","descripcion":"Reserva de resultados por sala quirúrgica","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Codificación alfanumérica ciega de bandejas y quirófanos."},
      {"tipoRiesgo":"Financieros","descripcion":"Variación cambiaria en hisopos de ATP de canal largo","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Adquisición anticipada de las 600 unidades con cotización fija."},
      {"tipoRiesgo":"De costos","descripcion":"Desgaste de sonda boroscópica flexible de 1.9 mm","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Uso de funda protectora y garantía extendida del fabricante."},
      {"tipoRiesgo":"De calendario","descripcion":"Paradas programadas por mantenimiento de autoclaves hospitalarios","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Distribución del muestreo en tres líneas de lavado independientes."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":18000000,"contrapartidaUdesEfectivo":6000000,"aliadoEspecie":5000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":10000000,"total":39000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":0,"aliadoEfectivo":3500000,"entidadConvocatoriaEfectivo":7000000,"total":19000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":1500000,"total":4500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":5500000,"aliadoEspecie":0,"aliadoEfectivo":2500000,"entidadConvocatoriaEfectivo":6500000,"total":16500000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":7800000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":8200000,"total":19000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2200000,"total":5000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1200000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":6000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":600000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":600000}
    ]'::jsonb,
    113300000,
    '[
      {"objetivo":"OE1. Estandarización de luminometría y boroscopia en central de esterilización","actividades":"Calibración de equipos, curvas patrón de ATP y muestreo piloto","trimestres":[true,true,false,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Evaluación comparativa en 300 ciclos de instrumental canulado","actividades":"Medición de URL, cultivos microbiológicos e inspección óptica","trimestres":[false,true,true,true,true,true,false,false,false,false,false,false]},
      {"objetivo":"OE3. Definición de puntos de corte e implementación de protocolo","actividades":"Análisis ROC, capacitación a instrumentadores y publicación","trimestres":[false,false,false,false,false,false,true,true,true,false,false,false]}
    ]'::jsonb,
    '2026-11-28', NULL, '', FALSE, NOW() - INTERVAL '12 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 6: CIM-2026-006 | Etapa 6: EN_PLENO_CTC (En sesión plenaria con tokens activos)
-- Investigador: Dr. Mauricio Alejandro Pineda Vargas
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000006',
    'CIM-2026-006',
    '20000000-0000-0000-0000-000000000006',
    'EN_PLENO_CTC',
    2,
    'Biopsia líquida mediante ADN tumoral circulante (ctDNA) y metilación de SEPT9 para la vigilancia de enfermedad mínima residual en cáncer colorrectal',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina',
    'Bucaramanga',
    'Grupo de Biología Molecular y Oncología Traslacional MASIRA',
    'Dr. Mauricio Alejandro Pineda Vargas',
    'Biología Molecular, Oncología Traslacional y Medicina de Precisión',
    'Dr. Mauricio Alejandro Pineda Vargas',
    'mauricio.pineda@udes.edu.co',
    'Centro de Cáncer y Enfermedades Hematológicas de Santander',
    'Bucaramanga, Santander',
    'Convocatoria Nacional de Medicina de Precisión y Oncología Molecular 2026',
    'Externa — Minciencias Salud',
    '2026-12-15',
    '[
      {"nombre":"Dr. Mauricio Alejandro Pineda Vargas","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección científica, diseño de ensayos ddPCR y correlación clínico-oncológica"},
      {"nombre":"Bact. PhD. Carolina Méndez Gómez","rol":"Coinvestigadora Genética Molecular","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Extracción de ADN libre circulante (cfDNA), conversión con bisulfito y PCR digital"}
    ]'::jsonb,
    'El antígeno carcinoembrionario (CEA) presenta baja sensibilidad para detectar recaída micrometastásica temprana tras resección curativa de cáncer colorrectal estadio II-III. La cuantificación de ctDNA permite anticipar la recaída radiológica por 6 meses.',
    'Determinar el valor pronóstico de la detección seriada de mutaciones KRAS/BRAF en ctDNA y metilación del promotor SEPT9 para identificar enfermedad mínima residual posquirúrgica en cáncer colorrectal.',
    E'1. Cuantificar la fracción alélica mutante en plasma preoperatorio y a los días 30, 90 y 180 posresección en 90 pacientes.\n2. Comparar la anticipación diagnóstica del ctDNA frente a tomografía y CEA sérico.\n3. Estimar la supervivencia libre de recaída a 18 meses.',
    'Estudio analítico de cohorte prospectiva traslacional con muestreo biológico seriado.',
    'Unidad de Oncología Clínica Aliada y Laboratorio de Biología Molecular del Instituto MASIRA - UDES.',
    '90 pacientes adultos con adenocarcinoma colorrectal estadios II y III candidatos a cirugía con intención curativa.',
    'Inclusión: Adenocarcinoma confirmado histológicamente estadio II-III sin metástasis a distancia. Exclusión: Neoplasia sincrónica o quimioterapia previa.',
    'Captación en junta multidisciplinaria de tumores gastrointestinales previo a la intervención quirúrgica.',
    'Tubos de estabilización de ADN libre (Cell-Free DNA BCT), PCR digital en gotas (ddPCR) y seguimiento tomográfico.',
    'Doble centrifugación refrigerada a 1600g y 16000g, extracción de cfDNA a partir de 4 mL de plasma y cuantificación absoluta de copias mutantes/mL.',
    'Curvas de supervivencia de Kaplan-Meier, prueba de log-rank y modelos de riesgos proporcionales de Cox dependientes del tiempo.',
    'Riesgo mínimo con consentimiento informado específico para custodia en biobanco genético según lineamientos éticos nacionales.',
    '2 artículos originales en revistas Q1 de oncología, 1 protocolo de biopsia líquida validado en MASIRA y 1 tesis de maestría.',
    'Red Colombiana de Investigación en Cáncer y Grupo Cooperativo Latinoamericano de Oncología.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Lisis leucocitaria ex vivo que diluya la fracción de ADN tumoral circulante","probabilidad":"Poco probable","impacto":"Severo","medidasMitigacion":"Uso exclusivo de tubos Streck cfDNA y separación de plasma en menos de 4 horas."},
      {"tipoRiesgo":"Administrativos","descripcion":"Retraso en importación de sondas TaqMan LNA específicas para mutaciones raras","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Pedido anticipado en el primer mes con inventario de seguridad para 120 reacciones."},
      {"tipoRiesgo":"Legales","descripcion":"Protección de datos genómicos sensibles de los participantes","probabilidad":"No probable","impacto":"Moderado","medidasMitigacion":"Cifrado AES-256 y disociación mediante código único de biobanco."},
      {"tipoRiesgo":"Financieros","descripcion":"Incremento en aranceles o tasa de cambio de consumibles de PCR digital","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Cobertura mediante acuerdo comercial en moneda local con representante exclusivo."},
      {"tipoRiesgo":"De costos","descripcion":"Muestras con baja concentración de cfDNA que requieran reextracción","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Almacenamiento de dos alícuotas adicionales de 2 mL de plasma por punto temporal."},
      {"tipoRiesgo":"De calendario","descripcion":"Pérdida de seguimiento en controles posoperatorios del sexto mes","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Coordinación de la toma de muestra con el control oncológico trimestral obligatorio."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":28000000,"contrapartidaUdesEfectivo":12000000,"aliadoEspecie":10000000,"aliadoEfectivo":8000000,"entidadConvocatoriaEfectivo":18000000,"total":76000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":6000000,"contrapartidaUdesEfectivo":14000000,"aliadoEspecie":0,"aliadoEfectivo":5000000,"entidadConvocatoriaEfectivo":12000000,"total":37000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2500000,"total":6000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":9500000,"aliadoEspecie":0,"aliadoEfectivo":6000000,"entidadConvocatoriaEfectivo":15000000,"total":34500000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":0,"aliadoEfectivo":4500000,"entidadConvocatoriaEfectivo":11000000,"total":24000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":4200000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3800000,"total":8000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3200000,"aliadoEspecie":0,"aliadoEfectivo":1800000,"entidadConvocatoriaEfectivo":0,"total":5000000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":3000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":8000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1800000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1200000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000}
    ]'::jsonb,
    204000000,
    '[
      {"objetivo":"OE1. Estandarización de ddPCR y reclutamiento preoperatorio","actividades":"Validación de límite de detección (LoD 0.05%) y toma basal","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Seguimiento molecular longitudinal a 30, 90 y 180 días","actividades":"Extracción de cfDNA, cuantificación de ctDNA y SEPT9 metilado","trimestres":[false,false,true,true,true,true,true,true,false,false,false,false]},
      {"objetivo":"OE3. Análisis de supervivencia libre de recaída y transferencia","actividades":"Modelado de Cox, publicación Q1 y guía clínica de biopsia líquida","trimestres":[false,false,false,false,false,false,false,false,true,true,true,true]}
    ]'::jsonb,
    '2026-11-20', 'FAVORABLE', 'Propuesta en sesión plenaria del CTC MASIRA con tokens emitidos para firma colegiada de los tres miembros del comité.', TRUE, NOW() - INTERVAL '15 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 7: CIM-2026-007 | Etapa 7: FAVORABLE_CON_OBSERVACIONES (Reporte sin firmas hasta subsanar)
-- Investigadora: Dra. Diana Carolina Duarte Meneses
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000007',
    'CIM-2026-007',
    '20000000-0000-0000-0000-000000000007',
    'FAVORABLE_CON_OBSERVACIONES',
    2,
    'Efectividad de una plataforma de telerrehabilitación neurocognitiva y del lenguaje con modo offline en sobrevivientes de ACV isquémico en provincias rurales de Santander',
    'Facultad de Ciencias Médicas y de la Salud — Programas de Terapia Ocupacional y Fonoaudiología',
    'Bucaramanga',
    'Grupo de Salud Digital y Rehabilitación Comunitaria MASIRA',
    'Dra. Diana Carolina Duarte Meneses',
    'Salud Digital, Telesalud y Neurorehabilitación Comunitaria',
    'Dra. Diana Carolina Duarte Meneses',
    'diana.duarte@udes.edu.co',
    'Red Pública Hospitalaria de Soto Norte y García Rovira',
    'Provincias de Soto Norte, García Rovira y Bucaramanga, Santander',
    'Convocatoria de Innovación Social y Telesalud Regional 2026',
    'Externa — Sistema General de Regalías CTeI',
    '2026-12-28',
    '[
      {"nombre":"Dra. Diana Carolina Duarte Meneses","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Diseño del protocolo de intervención neurocognitiva y coordinación clínica regional"},
      {"nombre":"Fonoaud. MSc. Sergio Iván Bohórquez","rol":"Coinvestigador Rehabilitación del Lenguaje","entidad":"Universidad de Santander (UDES)","responsabilidades":"Adaptación de módulos de afasia y seguimiento telemétrico quincenal"}
    ]'::jsonb,
    'Los pacientes con secuelas cognitivas y comunicativas post-ACV isquémico residentes en zonas rurales dispersas carecen de acceso continuo a terapia especializada debido a costos de transporte y conectividad intermitente.',
    'Evaluar la efectividad clínica, adherencia y relación costo-efectividad de un programa domiciliario de telerrehabilitación neurocognitiva y comunicativa con sincronización asíncrona en adultos post-ACV.',
    E'1. Medir el cambio en el puntaje MoCA y en la batería de lenguaje Western Aphasia Battery a las 12 y 24 semanas.\n2. Determinar el nivel de independencia en actividades instrumentales de la vida diaria (escala Lawton-Brody).\n3. Estimar la razón incremental de costo-efectividad frente al cuidado usual.',
    'Ensayo clínico pragmático aleatorizado por conglomerados municipales.',
    'Ocho hospitales locales de primer nivel en Santander coordinados por el Centro de Telesalud MASIRA - UDES.',
    '96 adultos con secuelas cognitivas o comunicativas leves a moderadas dentro de los primeros 6 meses post-ACV isquémico.',
    'Inclusión: Adultos >= 40 años con diagnóstico confirmado de ACV isquémico y cuidador primario disponible. Exclusión: Demencia previa o deterioro visual severo no corregido.',
    'Identificación al egreso hospitalario y búsqueda activa mediante promotores de atención primaria en salud.',
    'Batería MoCA validada para Colombia, índice de Barthel, escala de sobrecarga del cuidador de Zarit y registros automáticos de uso en la aplicación.',
    'Entrega de tableta preconfigurada con ejercicios adaptativos, 5 sesiones semanales de 40 minutos y teleconsulta sincrónica cada 15 días.',
    'Análisis por intención de tratar mediante modelos lineales mixtos con efecto aleatorio por municipio.',
    'Riesgo mínimo con suministro garantizado de la intervención al grupo control al finalizar la semana 24.',
    'Software de telerrehabilitación registrado ante la DNDA, 2 artículos científicos y protocolo de atención primaria.',
    'Asociación Colombiana de Neurología y Red Iberoamericana de Neurorehabilitación.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Interrupción prolongada del servicio de internet veredal","probabilidad":"Muy probable","impacto":"Moderado","medidasMitigacion":"Arquitectura 100% funcional en modo offline con sincronización automática al detectar red móvil."},
      {"tipoRiesgo":"Administrativos","descripcion":"Cambio de gerentes en hospitales locales aliados","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Convenio marco respaldado por la Secretaría Departamental de Salud."},
      {"tipoRiesgo":"Legales","descripcion":"Habeas data en grabaciones de voz para análisis acústico del habla","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Autorización expresa en consentimiento informado y almacenamiento cifrado en servidor UDES."},
      {"tipoRiesgo":"Financieros","descripcion":"Variación en tarifas de planes de datos móviles M2M","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Plan corporativo prepagado por 18 meses."},
      {"tipoRiesgo":"De costos","descripcion":"Daño accidental de dispositivos en domicilio rural","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Estuches antichoque y fondo de reposición del 10% de equipos."},
      {"tipoRiesgo":"De calendario","descripcion":"Dificultad de acceso vial en temporada invernal","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Apoyo de auxiliares de enfermería locales previamente entrenados en cada municipio."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":25000000,"contrapartidaUdesEfectivo":9500000,"aliadoEspecie":7000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":16000000,"total":57500000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":13000000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":14000000,"total":34000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2800000,"aliadoEspecie":0,"aliadoEfectivo":1200000,"entidadConvocatoriaEfectivo":2000000,"total":6000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":6000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":8000000,"total":19000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":5400000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":6500000,"total":13900000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3500000,"total":7000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":4800000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":3200000,"total":9500000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":5500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000}
    ]'::jsonb,
    156900000,
    '[
      {"objetivo":"OE1. Parametrización del aplicativo offline y alistamiento en 8 municipios","actividades":"Pruebas de usabilidad, entrenamiento de cuidadores y línea base","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Intervención de telerrehabilitación durante 24 semanas","actividades":"Monitoreo de sesiones cognitivas y fonoaudiológicas y teleconsultas","trimestres":[false,false,true,true,true,true,true,true,false,false,false,false]},
      {"objetivo":"OE3. Evaluación de impacto clínico, costo-efectividad y transferencia","actividades":"Modelos lineales mixtos, registro de software y socialización comunitaria","trimestres":[false,false,false,false,false,false,false,false,true,true,true,false]}
    ]'::jsonb,
    '2026-11-16',
    'FAVORABLE_CON_OBSERVACIONES',
    'Concepto FAVORABLE CON OBSERVACIONES emitido por el Pleno del CTC. Conforme al reglamento, el reporte se genera sin la aprobación firmada de los miembros del comité hasta que la investigadora subsane las aclaraciones solicitadas.',
    FALSE,
    NOW() - INTERVAL '18 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 8: CIM-2026-008 | Etapa 8: FAVORABLE (Aprobado con las 3 firmas de token único)
-- Investigador: Dr. Jorge Enrique Castellanos Rueda
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000008',
    'CIM-2026-008',
    '20000000-0000-0000-0000-000000000008',
    'FAVORABLE',
    2,
    'Modelo predictivo ecoepidemiológico y serovigilancia molecular de arbovirosis emergentes (Dengue, Oropouche y Mayaro) en el Magdalena Medio santandereano',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina y Salud Pública',
    'Bucaramanga',
    'Grupo de Epidemiología Clínica y Enfermedades Tropicales MASIRA',
    'Dr. Jorge Enrique Castellanos Rueda',
    'Enfermedades Infecciosas Desatendidas, Virología y Epidemiología Espacial',
    'Dr. Jorge Enrique Castellanos Rueda',
    'jorge.castellanos@udes.edu.co',
    'Secretaría de Salud Departamental de Santander — Laboratorio de Salud Pública',
    'Barrancabermeja, Puerto Wilches y Sabana de Torres, Santander',
    'Convocatoria Nacional de Vigilancia Ecoepidemiológica y Cambio Climático 2026',
    'Externa — Minciencias / OMS-OPS',
    '2026-12-10',
    '[
      {"nombre":"Dr. Jorge Enrique Castellanos Rueda","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección epidemiológica, modelado espacial y coordinación con salud pública"},
      {"nombre":"Dra. Mónica Lucía Vera","rol":"Coinvestigadora Virología Molecular","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"RT-qPCR multiplex para arbovirus y secuenciación de serotipos DENV 1-4"}
    ]'::jsonb,
    'El síndrome febril agudo indiferenciado en el Magdalena Medio suele clasificarse exclusivamente como dengue, subregistrando la circulación activa de virus Oropouche y Mayaro en zonas periurbanas y ribereñas.',
    'Desarrollar un sistema de vigilancia sindrómica, entomovirológica y predicción climática espacial para la identificación temprana de brotes de DENV, OROV y MAYV en tres municipios del Magdalena Medio.',
    E'1. Determinar la prevalencia de infección aguda por DENV, OROV y MAYV mediante RT-qPCR multiplex en 500 pacientes febriles.\n2. Detectar la tasa de infección natural en vectores Culicoides y Aedes recolectados en focos de transmisión.\n3. Construir mapas predictivos de riesgo mensual integrando variables satelitales de precipitación y temperatura.',
    'Estudio ecoepidemiológico prospectivo de cohorte febril y vigilancia entomovirológica georreferenciada.',
    'Hospitales de Barrancabermeja, Puerto Wilches y Sabana de Torres, y Laboratorio de Virología del Instituto MASIRA - UDES.',
    '500 pacientes con síndrome febril agudo (< 5 días de evolución) y 120 conglomerados entomológicos barriales.',
    'Inclusión: Pacientes >= 5 años con fiebre >= 38.5°C sin foco bacteriano aparente. Exclusión: Infección urinaria, neumonía o malaria confirmada por gota gruesa.',
    'Captación continua en servicios de urgencias y consulta prioritaria de las ESE municipales participantes.',
    'Encuesta clínico-epidemiológica georreferenciada, toma de suero en fase aguda, aspiración entomológica Prokopack y telemetría satelital MODIS.',
    'Extracción de ARN viral de suero y pools de vectores, amplificación RT-qPCR en un paso y modelado geoestadístico bayesiano INLA.',
    'Series de tiempo interrumpidas, estadística espacial de Kulldorff (SaTScan) y modelos aditivos generalizados.',
    'Riesgo mínimo para seres humanos según Resolución 8430 de 1993 y permiso marco de recolección entomológica de la UDES.',
    'Tablero georreferenciado de alerta temprana para la Secretaría de Salud, 2 artículos Q1 y formación de 2 jóvenes investigadores.',
    'Instituto Nacional de Salud (INS), Organización Panamericana de la Salud (OPS) y Red Colombiana de Arbovirosis.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Degradación de ARN viral durante el traslado fluvial o terrestre desde Puerto Wilches","probabilidad":"Poco probable","impacto":"Severo","medidasMitigacion":"Uso de tanques secos de nitrógeno líquido (dry shippers) validados por 7 días."},
      {"tipoRiesgo":"Administrativos","descripcion":"Sobrecarga asistencial en urgencias durante picos epidémicos de dengue","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Asignación de auxiliar de investigación exclusivo de MASIRA en cada hospital."},
      {"tipoRiesgo":"Legales","descripcion":"Notificación obligatoria inmediata al SIVIGILA de casos confirmados","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Articulación directa y reporte diario al Laboratorio Departamental de Salud Pública."},
      {"tipoRiesgo":"Financieros","descripcion":"Fluctuación en el precio de enzimas retrotranscriptasas de alta fidelidad","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Compra total de kits liofilizados al inicio del año 1."},
      {"tipoRiesgo":"De costos","descripcion":"Incremento en costos de transporte intermunicipal para muestreos entomológicos","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Programación unificada de rutas de recolección clínica y entomológica."},
      {"tipoRiesgo":"De calendario","descripcion":"Inundaciones estacionales en riberas del río Magdalena","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Cronograma flexible con ventanas de muestreo quincenal."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":30000000,"contrapartidaUdesEfectivo":11000000,"aliadoEspecie":12000000,"aliadoEfectivo":6000000,"entidadConvocatoriaEfectivo":20000000,"total":79000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":10000000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":11000000,"total":30000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3000000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":2500000,"total":7000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":12000000,"aliadoEspecie":0,"aliadoEfectivo":5000000,"entidadConvocatoriaEfectivo":16000000,"total":37000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":10500000,"aliadoEspecie":0,"aliadoEfectivo":4500000,"entidadConvocatoriaEfectivo":13000000,"total":28000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":4000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":4000000,"total":8000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":5500000,"aliadoEspecie":0,"aliadoEfectivo":2500000,"entidadConvocatoriaEfectivo":4500000,"total":12500000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":3000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":8000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1800000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1200000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000}
    ]'::jsonb,
    215000000,
    '[
      {"objetivo":"OE1. Instalación de red de vigilancia febril y muestreo entomológico","actividades":"Alistamiento en 3 municipios, georreferenciación y captura inicial","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Diagnóstico molecular RT-qPCR multiplex de muestras humanas y vectores","actividades":"Extracción viral, tipificación DENV/OROV/MAYV y secuenciación","trimestres":[false,true,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Modelado ecoepidemiológico espacial y transferencia a Salud Pública","actividades":"Integración satelital INLA, tablero web y publicaciones científicas","trimestres":[false,false,false,false,false,false,true,true,true,true,false,false]}
    ]'::jsonb,
    '2026-11-12',
    'FAVORABLE',
    'Concepto FAVORABLE definitivo aprobado por unanimidad en sesión plenaria del Comité Técnico Científico MASIRA y respaldado con las tres firmas criptográficas de token único.',
    TRUE,
    NOW() - INTERVAL '25 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 9: CIM-2026-009 | Etapa 9: EN_REVISION_SECRETARIA (En evaluación formal por Secretaría Técnica)
-- Investigador: Carlos Andrés Gómez Sarmiento (2da propuesta del Investigador 1)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000009',
    'CIM-2026-009',
    '20000000-0000-0000-0000-000000000001',
    'EN_REVISION_SECRETARIA',
    1,
    'Biomarcadores proteómicos salivales y variabilidad de la frecuencia cardíaca para la estratificación temprana de riesgo cardiometabólico en trabajadores por turnos',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina',
    'Bucaramanga',
    'Grupo Cardiometabólico MASIRA',
    'Patricio López Jaramillo',
    'Cronobiología, Salud Ocupacional y Riesgo Cardiometabólico',
    'Carlos Andrés Gómez Sarmiento',
    'carlos.gomez@udes.edu.co',
    'Hospital Universitario de Santander (HUS) — Servicio de Salud Ocupacional',
    'Bucaramanga, Santander',
    'Convocatoria Interna de Investigación en Salud Laboral y Cronobiología UDES 2026',
    'Interna con Alianza Hospitalaria',
    '2026-12-24',
    '[
      {"nombre":"Carlos Andrés Gómez Sarmiento","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección clínica, monitoreo Holter de variabilidad autonómica y análisis multivariable"},
      {"nombre":"Silvia Fernanda Duarte","rol":"Coinvestigadora Bioquímica","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Cuantificación de cortisol, alfa-amilasa e interleucina-6 salival por ELISA"}
    ]'::jsonb,
    'La disrupción circadiana inducida por el trabajo nocturno rotativo altera el tono simpático-vagal y promueve resistencia a la insulina subclínica en personal sanitario, careciendo de protocolos no invasivos de tamizaje ocupacional.',
    'Evaluar la asociación entre el perfil circadiano de biomarcadores inflamatorios salivales y la variabilidad de la frecuencia cardíaca de 24 horas con el síndrome metabólico temprano en trabajadores hospitalarios por turnos.',
    E'1. Comparar la relación LF/HF y SDNN en registros Holter de 24 horas entre trabajadores de turno nocturno rotativo y turno diurno fijo en 180 participantes.\n2. Cuantificar la pendiente diurna de cortisol, alfa-amilasa e IL-6 en saliva en cuatro puntos horarios.\n3. Desarrollar un índice predictivo no invasivo de desregulación autonómica-metabólica.',
    'Estudio observacional analítico de cohorte ocupacional emparejada por edad y sexo.',
    'Servicios asistenciales del hospital aliado y Laboratorio Cardiometabólico del Instituto MASIRA - UDES.',
    '180 trabajadores de la salud (90 en turno rotativo nocturno y 90 en turno diurno administrativo/ambulatorio).',
    'Inclusión: Personal asistencial de 22 a 55 años con antigüedad >= 1 año en la modalidad de turno. Exclusión: Uso de betabloqueadores, corticoides sistémicos o arritmia cardíaca diagnosticada.',
    'Invitación mediante jornadas de bienestar laboral y medicina preventiva del trabajo.',
    'Monitor Holter ECG digital de 3 canales, dispositivos Salivette para recolección salival seriada y actigrafía de muñeca por 7 días.',
    'Colocación de sensor de variabilidad cardíaca al inicio del turno, autorrecolección supervisada de saliva al despertar, +30 min, 14:00 h y 22:00 h, y antropometría bioeléctrica.',
    'Modelos de ecuaciones de estimación generalizadas (GEE) para mediciones repetidas y regresión logística condicional.',
    'Investigación de riesgo mínimo según Resolución 8430 de 1993. Manejo confidencial de historias ocupacionales sin afectación laboral.',
    '1 artículo científico Q1/Q2, 1 protocolo institucional de vigilancia cronobiológica laboral y vinculación de 2 estudiantes de medicina.',
    'Sociedad Colombiana de Medicina del Trabajo y Red Iberoamericana de Cronobiología Clínica.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Incumplimiento de los tiempos exactos de toma de muestra salival en domicilio","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Tubos codificados con recordatorio por alarma móvil y registro fotográfico con marca de tiempo."},
      {"tipoRiesgo":"Administrativos","descripcion":"Cruces de programación con cambios imprevistos de turno asistencial","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Coordinación semanal con jefaturas de enfermería y talento humano."},
      {"tipoRiesgo":"Legales","descripcion":"Reserva de diagnósticos cardiometabólicos frente al empleador","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Entrega individual y confidencial de resultados clínicos directamente al trabajador."},
      {"tipoRiesgo":"Financieros","descripcion":"Incremento en costo de kits ELISA de alta sensibilidad salival","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Adquisición por lote completo al inicio del proyecto."},
      {"tipoRiesgo":"De costos","descripcion":"Volumen insuficiente de saliva en muestras matutinas","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Provisión de 15% adicional de tubos Salivette de polímero sintético."},
      {"tipoRiesgo":"De calendario","descripcion":"Baja disponibilidad del personal en picos de ocupación hospitalaria","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Ventana de reclutamiento escalonada por servicios clínicos durante 4 trimestres."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":21000000,"contrapartidaUdesEfectivo":7000000,"aliadoEspecie":5000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":11000000,"total":44000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":7500000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":6500000,"total":20000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":1200000,"total":3000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2500000,"contrapartidaUdesEfectivo":6500000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":9000000,"total":21000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":6000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":7500000,"total":15500000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2500000,"total":5000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":1500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":5000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1800000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1200000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":800000}
    ]'::jsonb,
    118800000,
    '[
      {"objetivo":"OE1. Reclutamiento ocupacional y monitoreo Holter / actigráfico","actividades":"Tamizaje por turnos, colocación de sensores de VFC y actigrafía semanal","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Procesamiento inmunoenzimático de curvas circadianas salivales","actividades":"Centrifugación de Salivettes, ensayos ELISA de cortisol/IL-6 y control de calidad","trimestres":[false,false,true,true,true,true,false,false,false,false,false,false]},
      {"objetivo":"OE3. Modelado del índice autonómico-metabólico y transferencia","actividades":"Análisis GEE, socialización con salud ocupacional y manuscrito Q1","trimestres":[false,false,false,false,false,false,true,true,true,false,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '3 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 10: CIM-2026-010 | Etapa 10: RECHAZADO (Concepto No Favorable en Pleno CTC)
-- Investigadora: Natalia Sofía Serrano Rojas (2da propuesta de la Investigadora 2)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000010',
    'CIM-2026-010',
    '20000000-0000-0000-0000-000000000002',
    'RECHAZADO',
    2,
    'Evaluación exploratoria de fagoterapia intranasal empírica sin tipificación lítica previa en modelos clínicos de rinosinusitis crónica refractaria',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Bacteriología y Laboratorio Clínico',
    'Bucaramanga',
    'Grupo de Enfermedades Infecciosas y Genómica MASIRA',
    'Natalia Sofía Serrano Rojas',
    'Terapias Biológicas Experimentales y Microbiología Clínica',
    'Natalia Sofía Serrano Rojas',
    'natalia.serrano@udes.edu.co',
    'Centro Ambulatorio Otorrinolaringológico del Oriente',
    'Bucaramanga, Santander',
    'Convocatoria Piloto de Terapias Antimicrobianas Alternativas 2026',
    'Interna Exploratoria',
    '2026-12-05',
    '[
      {"nombre":"Dra. Natalia Sofía Serrano Rojas","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Aislamiento de bacteriófagos ambientales y coordinación general"},
      {"nombre":"Dr. Héctor Julio Mendoza","rol":"Coinvestigador Clínico ORL","entidad":"Centro Ambulatorio Otorrinolaringológico","responsabilidades":"Administración intranasal y valoración endoscópica"}
    ]'::jsonb,
    'Las biopelículas de Staphylococcus aureus y Pseudomonas aeruginosa en rinosinusitis crónica recalcitrante presentan alta tasa de fracaso tras múltiples esquemas antibióticos tópicos y sistémicos.',
    'Evaluar la respuesta clínica sintomática de un preparado magistral de bacteriófagos ambientales administrado por vía intranasal en pacientes adultos con rinosinusitis crónica refractaria.',
    E'1. Aislar y propagar bacteriófagos líticos a partir de muestras ambientales locales.\n2. Administrar nebulizaciones intranasales durante 14 días en 30 pacientes con rinosinusitis refractaria.\n3. Comparar el puntaje endoscópico Lund-Kennedy antes y después de la intervención.',
    'Ensayo clínico abierto de un solo brazo sin fase preclínica de purificación de endotoxinas.',
    'Consulta externa de otorrinolaringología y Laboratorio de Microbiología MASIRA - UDES.',
    'Muestreo por conveniencia de 30 pacientes adultos con rinosinusitis crónica sin pólipos.',
    'Inclusión: Adultos > 18 años con persistencia de síntomas por más de 12 semanas. Exclusión: Inmunosupresión primaria o cirugía sinusal en el último mes.',
    'Captación en consulta externa especializada de otorrinolaringología.',
    'Cuestionario SNOT-22, endoscopia nasal rígida y cultivo microbiológico de meato medio.',
    'Propagación de lisados fágicos en caldo nutritivo, filtración por membrana de 0.22 micras y aplicación por atomizador nasal cada 12 horas.',
    'Prueba t de Student pareada o prueba de rangos con signo de Wilcoxon para puntajes SNOT-22.',
    'Investigación de riesgo mayor que el mínimo por administración mucosa de agentes biológicos vivos.',
    '1 informe técnico de eficacia preliminar y 1 manuscrito sometido a revista indexada.',
    'Red de Otorrinolaringología de Santander.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Presencia de restos de endotoxinas bacterianas (LPS) en el filtrado fágico","probabilidad":"Probable","impacto":"Severo","medidasMitigacion":"Ultrafiltración tangencial, aunque no se presupuestó cuantificación certificada de LAL."},
      {"tipoRiesgo":"Administrativos","descripcion":"Requisitos regulatorios del INVIMA para productos biológicos en fase clínica","probabilidad":"Muy probable","impacto":"Severo","medidasMitigacion":"Consulta preliminar ante sala especializada de medicamentos biológicos."},
      {"tipoRiesgo":"Legales","descripcion":"Cobertura de póliza de responsabilidad civil para ensayos clínicos fase I/II","probabilidad":"Probable","impacto":"Severo","medidasMitigacion":"Cotización de póliza clínica aún no incluida en los rubros financiables."},
      {"tipoRiesgo":"Financieros","descripcion":"Sobrecosto por pruebas de esterilidad y secuenciación de exclusión de genes de toxinas","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Reasignación interna de rubro de materiales."},
      {"tipoRiesgo":"De costos","descripcion":"Inestabilidad del título de unidades formadoras de placa (UFP/mL) en refrigeración","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Preparación quincenal de lotes frescos."},
      {"tipoRiesgo":"De calendario","descripcion":"Tiempos de evaluación regulatoria externa superiores a la vigencia de la convocatoria","probabilidad":"Muy probable","impacto":"Severo","medidasMitigacion":"Ajuste del cronograma a 12 trimestres."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":16000000,"contrapartidaUdesEfectivo":4000000,"aliadoEspecie":3000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":8000000,"total":31000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":4000000,"total":7500000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":4500000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":6000000,"total":14000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":5000000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":5500000,"total":12000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":1500000,"total":3500000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":2500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":1000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":3500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1200000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":500000}
    ]'::jsonb,
    76200000,
    '[
      {"objetivo":"OE1. Aislamiento y propagación de bacteriófagos ambientales","actividades":"Tamizaje en placa doble capa y filtración de lisados","trimestres":[true,true,false,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Administración intranasal abierta en 30 pacientes","actividades":"Aplicación por 14 días y seguimiento endoscópico","trimestres":[false,false,true,true,true,true,false,false,false,false,false,false]},
      {"objetivo":"OE3. Análisis de desenlaces SNOT-22 e informe final","actividades":"Comparación pre-post y redacción de informe","trimestres":[false,false,false,false,false,false,true,true,false,false,false,false]}
    ]'::jsonb,
    '2026-11-10',
    'RECHAZADO',
    'Concepto RECHAZADO (No Favorable) por el Pleno del Comité Técnico Científico MASIRA. No se autoriza la administración clínica intranasal en seres humanos de lisados de bacteriófagos sin validación preclínica previa de remoción de endotoxinas (ensayo LAL), secuenciación genómica completa que descarte genes de lisogenia o factores de virulencia, y certificación de Buenas Prácticas de Manufactura exigida por el INVIMA.',
    FALSE,
    NOW() - INTERVAL '28 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 11: CIM-2026-011 | Etapa: BORRADOR
-- Investigadora: Dra. Laura Juliana Mantilla Pinzón (Investigadora 3)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000011',
    'CIM-2026-011',
    '20000000-0000-0000-0000-000000000003',
    'BORRADOR',
    1,
    'Intervención educativa multimodal de enfermería para la prevención de delirio agudo en adultos mayores hospitalizados en unidades de cuidado intermedio',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Enfermería',
    'Bucaramanga',
    'Grupo de Cuidado Crítico y Salud Materno-Perinatal MASIRA',
    'Dra. Laura Juliana Mantilla Pinzón',
    'Cuidado Crítico, Envejecimiento y Seguridad del Paciente',
    'Dra. Laura Juliana Mantilla Pinzón',
    'laura.mantilla@udes.edu.co',
    'Clínica Foscal — Unidad de Cuidados Intermedios',
    'Bucaramanga y Floridablanca, Santander',
    'Convocatoria Interna de Fomento a la Investigación Clínica en Enfermería UDES 2026',
    'Interna con Alianza Hospitalaria',
    '2026-12-26',
    '[
      {"nombre":"Dra. Laura Juliana Mantilla Pinzón","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Diseño del paquete no farmacológico ABCDEF y dirección clínica del estudio"},
      {"nombre":"Enf. Esp. Diana Marcela Rojas","rol":"Coinvestigadora Clínica","entidad":"Universidad de Santander (UDES)","responsabilidades":"Evaluación diaria con escala CAM-ICU y entrenamiento a cuidadores familiares"}
    ]'::jsonb,
    'El delirio hiperactivo e hipoactivo afecta hasta al 40% de los adultos mayores en unidades de cuidado intermedio, prolongando la estancia hospitalaria y el deterioro cognitivo al egreso.',
    'Evaluar la eficacia de un protocolo de enfermería de reorientación sensorial temprana, higiene del sueño y acompañamiento familiar estructurado para reducir la incidencia de delirio en cuidado intermedio.',
    E'1. Determinar la incidencia acumulada de delirio mediante la escala CAM-ICU en 160 pacientes mayores de 65 años.\n2. Comparar la duración en días de los episodios de delirio entre el grupo intervenido y el cuidado estándar.\n3. Medir la satisfacción familiar y adherencia del equipo de enfermería.',
    'Ensayo clínico cuasiexperimental con grupo control histórico y fase prospectiva de intervención.',
    'Unidades de Cuidado Intermedio de la Clínica Aliada e Instituto MASIRA - UDES.',
    '160 pacientes adultos mayores (>= 65 años) hospitalizados por más de 48 horas en unidad de cuidado intermedio.',
    'Inclusión: Pacientes >= 65 años sin delirio al ingreso (CAM-ICU negativo). Exclusión: Demencia severa estadio GDS 6-7 o coma estructural.',
    'Tamizaje sistemático en las primeras 12 horas de admisión a la unidad de cuidado intermedio.',
    'Escala CAM-ICU validada en español, índice de calidad de sueño de Richards-Campbell y lista de chequeo de adherencia.',
    'Valoración CAM-ICU cada 12 horas, protocolo de reducción de ruido/luz nocturna, uso temprano de prótesis auditivas/visuales y orientación cognitiva con apoyo familiar.',
    'Regresión logística multivariable y análisis de supervivencia libre de delirio de Kaplan-Meier.',
    'Investigación con riesgo mínimo según Resolución 8430 de 1993. Consentimiento informado del paciente o familiar representante.',
    '1 guía de práctica clínica de prevención de delirio, 1 artículo en revista indexada Q2 y formación de 2 estudiantes de pregrado.',
    'Asociación Colombiana de Medicina Crítica y Cuidado Intensivo (AMCI).',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Subregistro del delirio hipoactivo durante los turnos nocturnos","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Recertificación práctica quincenal en escala CAM-ICU y auditoría cruzada."},
      {"tipoRiesgo":"Administrativos","descripcion":"Restricción temporal de visitas familiares por picos respiratorios","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Mensajes grabados de voz y videollamadas de orientación familiar en tableta."},
      {"tipoRiesgo":"Legales","descripcion":"Consentimiento en adultos mayores con fragilidad clínica","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Protocolo de consentimiento dual con acudiente responsable."},
      {"tipoRiesgo":"Financieros","descripcion":"Incremento en costo de kits de estimulación sensorial e higiene de sueño","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Adquisición consolidada de antifaces, tapones auditivos y relojes de alto contraste."},
      {"tipoRiesgo":"De costos","descripcion":"Reimpresión de material educativo para cuidadores","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Versión digital interactiva accesible por código QR en cabecera."},
      {"tipoRiesgo":"De calendario","descripcion":"Baja rotación de camas en cuidado intermedio","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Inclusión de dos pabellones médico-quirúrgicos adicionales."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":18500000,"contrapartidaUdesEfectivo":5500000,"aliadoEspecie":4500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":9500000,"total":38000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":4000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":4000000,"total":10000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":1500000,"total":5000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":3000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3500000,"total":8000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":5000000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":6000000,"total":12500000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2500000,"total":5000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":1500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":4500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":600000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":600000}
    ]'::jsonb,
    87600000,
    '[
      {"objetivo":"OE1. Entrenamiento CAM-ICU y medición de cohorte basal","actividades":"Estandarización de enfermería y línea base de incidencia de delirio","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Despliegue del protocolo multimodal no farmacológico","actividades":"Intervención sensorial, higiene de sueño y acompañamiento familiar","trimestres":[false,false,true,true,true,true,false,false,false,false,false,false]},
      {"objetivo":"OE3. Análisis de efectividad clínica y publicación","actividades":"Comparación de incidencia, guía hospitalaria y manuscrito","trimestres":[false,false,false,false,false,false,true,true,true,false,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NULL
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 12: CIM-2026-012 | Etapa: SOMETIDO
-- Investigador: Dr. Andrés Felipe Villamizar Ortiz (Investigador 4)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000012',
    'CIM-2026-012',
    '20000000-0000-0000-0000-000000000004',
    'SOMETIDO',
    1,
    'Entrenamiento de marcha asistido por realidad virtual inmersiva y sensores inerciales para la prevención de caídas en adultos con enfermedad de Parkinson estadio Hoehn & Yahr II-III',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Fisioterapia',
    'Bucaramanga',
    'Grupo de Neurociencias y Rehabilitación Funcional MASIRA',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'Neurorehabilitación, Control Motor y Tecnologías Asistivas',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'andres.villamizar@udes.edu.co',
    'Fundación Neurológica del Oriente — Unidad de Trastornos del Movimiento',
    'Bucaramanga, Santander',
    'Convocatoria Nacional de Neurociencias y Envejecimiento Saludable 2026',
    'Externa — Minciencias',
    '2026-12-23',
    '[
      {"nombre":"Dr. Andrés Felipe Villamizar Ortiz","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección científica, programación de pistas visuales-auditivas en RV y análisis cinemático"},
      {"nombre":"Ft. MSc. Julián David Cáceres","rol":"Coinvestigador Neurofisioterapia","entidad":"Universidad de Santander (UDES)","responsabilidades":"Aplicación del protocolo de rehabilitación de congelamiento de la marcha (FOG)"}
    ]'::jsonb,
    'El congelamiento de la marcha (freezing of gait) y la pérdida de automaticidad locomotora en la enfermedad de Parkinson causan caídas recurrentes fracturarias que responden parcialmente al ajuste dopaminérgico.',
    'Evaluar el efecto de un programa de entrenamiento locomotor con pistas sensoriales en realidad virtual inmersiva sobre la variabilidad del paso, episodios de congelamiento y riesgo de caída en pacientes con Parkinson.',
    E'1. Medir el cambio en la velocidad de marcha en tarea dual y longitud de zancada mediante sensores IMU triaxiales en 60 pacientes.\n2. Comparar el puntaje del cuestionario FOG-Q y escala Mini-BESTest a las 10 y 20 semanas.\n3. Registrar la incidencia prospectiva de caídas durante 6 meses.',
    'Ensayo clínico controlado aleatorizado simple ciego con dos brazos paralelos.',
    'Laboratorio de Análisis de Movimiento UDES - Instituto MASIRA.',
    '60 pacientes diagnosticados con enfermedad de Parkinson idiopática en estadios Hoehn & Yahr II a III.',
    'Inclusión: Marcha independiente por al menos 10 metros en estado ON farmacológico y Mini-Mental >= 24. Exclusión: Cinetosis severa o discinesias incapacitantes.',
    'Remisión desde consulta especializada de neurología y asociación regional de pacientes con Parkinson.',
    'Sensores magneto-inerciales (IMUs) en región lumbar y maléolos, cuestionario FOG-Q, escala MDS-UPDRS III y diario de caídas.',
    'Evaluación biomecánica en fase ON estable (1 hora post-levodopa) y 24 sesiones de entrenamiento en entorno virtual de obstáculos con arnés de seguridad.',
    'Modelos lineales generalizados mixtos y regresión binomial negativa para tasa de caídas.',
    'Riesgo mínimo con arnés de suspensión cenital anticaídas y supervisión permanente.',
    '1 protocolo clínico de rehabilitación inmersiva en Parkinson y 1 artículo en revista indexada Q1.',
    'Asociación Colombiana de Neurología — Comité de Trastornos del Movimiento.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Cinetosis o fatiga visual durante el uso del visor de realidad virtual","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Tasa de refresco de 120 Hz, progresión gradual de 15 a 30 minutos y pausas programadas."},
      {"tipoRiesgo":"Administrativos","descripcion":"Dificultad de traslado del paciente y su acompañante al laboratorio","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Subsidio de transporte puerta a puerta para las sesiones programadas."},
      {"tipoRiesgo":"Legales","descripcion":"Póliza de accidentes personales para participantes en rehabilitación física","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Cobertura institucional vigente en clínicas y laboratorios UDES."},
      {"tipoRiesgo":"Financieros","descripcion":"Variación en el costo de licencias de motor gráfico médico","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Desarrollo propio sobre licencia académica perpetua Unity Pro."},
      {"tipoRiesgo":"De costos","descripcion":"Recambio de baterías de sensores inerciales portátiles","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Kit de respaldo incluido en el rubro de equipos."},
      {"tipoRiesgo":"De calendario","descripcion":"Fluctuaciones motoras ON-OFF que obliguen a reprogramar sesiones","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Agenda flexible sincronizada con el horario individual de toma de levodopa."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":22000000,"contrapartidaUdesEfectivo":7000000,"aliadoEspecie":5000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":12000000,"total":46000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":8000000,"aliadoEspecie":0,"aliadoEfectivo":2500000,"entidadConvocatoriaEfectivo":9500000,"total":25000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":1200000,"total":3000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":4000000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":5000000,"total":12500000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":4500000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":5500000,"total":11000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3000000,"total":6000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":1500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":5500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1800000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1200000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":800000}
    ]'::jsonb,
    114800000,
    '[
      {"objetivo":"OE1. Parametrización de escenarios de RV y línea base cinemática con IMUs","actividades":"Calibración de sensores, reclutamiento y evaluación MDS-UPDRS III","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Ejecución de las 24 sesiones de entrenamiento locomotor inmersivo","actividades":"Intervención supervisada y evaluaciones a 10 y 20 semanas","trimestres":[false,false,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Seguimiento de caídas a 6 meses y divulgación científica","actividades":"Modelado estadístico, registro de software y artículo Q1","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '2 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 13: CIM-2026-013 | Etapa: EN_REVISION_SECRETARIA
-- Investigadora: Claudia Patricia Jaimes Calderón (Investigadora 5)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000013',
    'CIM-2026-013',
    '20000000-0000-0000-0000-000000000005',
    'EN_REVISION_SECRETARIA',
    1,
    'Sistema de trazabilidad por radiofrecuencia (RFID) pasiva de grado médico para la prevención de oblito quirúrgico y gestión de vida útil de instrumental de cirugía cardiovascular',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Instrumentación Quirúrgica',
    'Bucaramanga',
    'Grupo de Bioingeniería y Seguridad del Paciente MASIRA',
    'Claudia Patricia Jaimes Calderón',
    'Bioingeniería Quirúrgica, Trazabilidad y Seguridad del Paciente',
    'Claudia Patricia Jaimes Calderón',
    'claudia.jaimes@udes.edu.co',
    'Instituto del Corazón de Bucaramanga — Salas de Cirugía Cardiovascular',
    'Bucaramanga, Santander',
    'Convocatoria de Desarrollo Tecnológico e Innovación Hospitalaria UDES 2026',
    'Interna Desarrollo Tecnológico',
    '2026-12-19',
    '[
      {"nombre":"Dra. Claudia Patricia Jaimes Calderón","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Estandarización de recuento quirúrgico asistido por RFID y evaluación en quirófano"},
      {"nombre":"Ing. MSc. Ricardo Andrés Gómez","rol":"Coinvestigador Bioingeniería","entidad":"Universidad de Santander (UDES)","responsabilidades":"Pruebas de resistencia de tags UHF autoclavables a 134°C y antenas lectoras"}
    ]'::jsonb,
    'El recuento manual de compresas e instrumental microquirúrgico en cirugía cardiovascular prolongada está sujeto a error humano bajo fatiga, con riesgo de retención inadvertida de cuerpos extraños y desgaste no monitorizado de pinzas vasculares.',
    'Validar un sistema integrado de identificación por radiofrecuencia (RFID-UHF) resistente a esterilización por vapor para automatizar el recuento intraoperatorio y la trazabilidad de ciclos de uso del instrumental cardiovascular.',
    E'1. Evaluar la durabilidad física y legibilidad electromagnética de 400 etiquetas RFID sometidas a 150 ciclos de autoclave a 134°C.\n2. Medir la reducción en el tiempo de recuento de instrumental y compresas en 120 cirugías cardiovasculares.\n3. Determinar la concordancia del inventario automatizado frente al conteo manual doble.',
    'Estudio de validación tecnológica cuasiexperimental en entorno quirúrgico simulado y real.',
    'Quirófanos de cirugía cardiovascular de la entidad aliada y Laboratorio de Simulación Quirúrgica UDES.',
    '120 procedimientos de cirugía cardiovascular electiva y 400 piezas de instrumental microquirúrgico etiquetadas.',
    'Inclusión: Bandejas de cirugía coronaria y valvular electiva. Exclusión: Reintervenciones de emergencia extrema sin preparación de mesa estándar.',
    'Selección consecutiva de cirugías programadas en las salas 1 y 2 del centro cardiovascular aliado.',
    'Lectores RFID-UHF de campo cercano en mesa de Mayo, cronometría digital de recuento y pruebas de fatiga metalúrgica.',
    'Escaneo automático de bandeja antes de la incisión, previo al cierre de cavidad torácica y al finalizar el procedimiento, comparado con protocolo manual.',
    'Índice kappa de Cohen, curvas de Bland-Altman para tiempos de conteo y análisis de fallas de Weibull.',
    'Sin intervención directa sobre el tejido del paciente; cumplimiento de norma IEC 60601-1-2 de compatibilidad electromagnética en quirófano.',
    '1 prototipo funcional TRL-6 validado en entorno hospitalario, 1 solicitud de modelo de utilidad y 1 artículo Q2.',
    'Colegio Colombiano de Instrumentación Quirúrgica y Red de Ingeniería Clínica.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Atenuación de señal RFID por presencia de fluidos hemáticos en compresas","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Uso de antenas con polarización circular y barrido multifrecuencia."},
      {"tipoRiesgo":"Administrativos","descripcion":"Curva de aprendizaje de las instrumentadoras quirúrgicas de planta","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Entrenamiento previo en quirófano simulado UDES."},
      {"tipoRiesgo":"Legales","descripcion":"Certificación de no interferencia con equipos de circulación extracorpórea","probabilidad":"No probable","impacto":"Moderado","medidasMitigacion":"Pruebas previas de emisión electromagnética con ingeniería biomédica hospitalaria."},
      {"tipoRiesgo":"Financieros","descripcion":"Importación de microtags cerámicos biocompatibles grado médico","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Compra directa a fabricante certificado ISO 10993 en el mes 1."},
      {"tipoRiesgo":"De costos","descripcion":"Desprendimiento de adhesivo térmico tras múltiples ciclos de ultrasonido","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Encapsulado por soldadura láser médica sin adhesivos poliméricos."},
      {"tipoRiesgo":"De calendario","descripcion":"Reprogramación de cirugías electivas por disponibilidad de UCI","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Habilitación de dos salas quirúrgicas simultáneas para recolección."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":20000000,"contrapartidaUdesEfectivo":6500000,"aliadoEspecie":6000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":11000000,"total":43500000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":10500000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":9500000,"total":27000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":1200000,"total":3000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":5000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":6000000,"total":15000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":7000000,"aliadoEspecie":0,"aliadoEfectivo":2500000,"entidadConvocatoriaEfectivo":7500000,"total":17000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3500000,"total":7000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1200000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":5500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":700000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":700000}
    ]'::jsonb,
    122400000,
    '[
      {"objetivo":"OE1. Encapsulado láser de microtags RFID y pruebas de autoclave","actividades":"Ensayos de resistencia térmica, ultrasónica y compatibilidad electromagnética","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Validación en 120 cirugías cardiovasculares electivas","actividades":"Medición de tiempos de recuento y concordancia intraoperatoria","trimestres":[false,false,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Análisis de confiabilidad y protección de propiedad industrial","actividades":"Modelado de Weibull, solicitud de patente/modelo y publicación","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '5 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 14: CIM-2026-014 | Etapa: SUBSANACION_SOLICITADA
-- Investigador: Mauricio Alejandro Pineda Vargas (Investigador 6)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000014',
    'CIM-2026-014',
    '20000000-0000-0000-0000-000000000006',
    'SUBSANACION_SOLICITADA',
    1,
    'Perfil de expresión de microARN exosomales plasmáticos (miR-21, miR-155 y miR-10b) como predictores de respuesta a quimioterapia neoadyuvante en cáncer de mama triple negativo',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina',
    'Bucaramanga',
    'Grupo de Biología Molecular y Oncología Traslacional MASIRA',
    'Mauricio Alejandro Pineda Vargas',
    'Oncología Molecular, Biopsia Líquida y Farmacogenómica',
    'Mauricio Alejandro Pineda Vargas',
    'mauricio.pineda@udes.edu.co',
    'Unidad Oncológica de Santander — Clínica de Mama',
    'Bucaramanga, Santander',
    'Convocatoria Nacional de Investigación Traslacional en Cáncer de la Mujer 2026',
    'Externa — Minciencias / INC',
    '2026-12-21',
    '[
      {"nombre":"Dr. Mauricio Alejandro Pineda Vargas","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección traslacional, correlación con respuesta patológica completa (pCR) y bioestadística"},
      {"nombre":"Bact. PhD. Carolina Méndez Gómez","rol":"Coinvestigadora Biología Molecular","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Aislamiento de exosomas por ultracentrifugación/columnas y RT-qPCR de microARNs"}
    ]'::jsonb,
    'El cáncer de mama triple negativo carece de blancos hormonales o HER2, y cerca del 50% de las pacientes no alcanzan respuesta patológica completa tras quimioterapia neoadyuvante basada en antraciclinas y taxanos.',
    'Determinar la capacidad predictiva temprana de la variación en niveles circulantes de miR-21, miR-155 y miR-10b exosomales frente a la respuesta patológica completa (RCB 0) en pacientes con cáncer de mama triple negativo.',
    E'1. Aislar y caracterizar vesículas extracelulares pequeñas (exosomas CD63+/CD81+) en plasma basal y tras el segundo ciclo de neoadyuvancia en 75 pacientes.\n2. Cuantificar la expresión relativa de miR-21, miR-155 y miR-10b mediante RT-qPCR con sondas stem-loop.\n3. Correlacionar el cambio logarítmico de expresión con el puntaje de carga tumoral residual (Residual Cancer Burden) en la pieza quirúrgica.',
    'Estudio observacional analítico de cohorte prospectiva de biomarcadores pronósticos.',
    'Servicio de Mastología y Oncología Aliado y Laboratorio de Biología Molecular MASIRA - UDES.',
    '75 mujeres adultas con diagnóstico histológico e inmunohistoquímico de carcinoma mamario triple negativo estadios II-III.',
    'Inclusión: Carcinoma ductal infiltrante ER-, PR-, HER2- candidato a quimioterapia neoadyuvante seguida de cirugía. Exclusión: Enfermedad metastásica estadio IV de debut.',
    'Captación en consulta de primera vez de oncología clínica previo al inicio del primer ciclo citotóxico.',
    'Cromatografía de exclusión por tamaño (SEC), dispersión dinámica de luz (NTA), Western Blot de tetraspaninas y RT-qPCR.',
    'Toma de 10 mL de sangre periférica en EDTA antes del ciclo 1, antes del ciclo 3 y prequirúrgico; purificación exosomal y normalización contra cel-miR-39 spike-in.',
    'Regresión logística penalizada LASSO y curvas ROC con validación cruzada k-fold.',
    'Riesgo mínimo con consentimiento informado para uso de muestras remanentes de patología y plasma.',
    '1 firma molecular predictiva de quimiorresistencia y 1 artículo en revista internacional Q1.',
    'Instituto Nacional de Cancerología (INC) y Asociación Colombiana de Mastología.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Co-aislamiento de lipoproteínas plasmáticas que contaminen la fracción exosomal","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Toma en ayuno estricto de 8 horas y columnas SEC de doble purificación."},
      {"tipoRiesgo":"Administrativos","descripcion":"Suspensión temporal de ciclos de quimioterapia por neutropenia febril","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Ajuste de la ventana de segunda muestra al inicio efectivo del tercer ciclo."},
      {"tipoRiesgo":"Legales","descripcion":"Custodia de bloques de parafina para evaluación centralizada de RCB","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Lectura digital de láminas histológicas escaneadas sin retiro físico del bloque."},
      {"tipoRiesgo":"Financieros","descripcion":"Aumento de precio en columnas de cromatografía de exclusión por tamaño","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Importación consolidada de 250 columnas al inicio del proyecto."},
      {"tipoRiesgo":"De costos","descripcion":"Degradación de ARN exosomal durante extracción","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Adición de inhibidor de RNasas recombinante en el buffer de lisis."},
      {"tipoRiesgo":"De calendario","descripcion":"Tasa de reclutamiento inferior a 8 pacientes/mes","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Vinculación de un segundo centro mastológico del área metropolitana."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":26000000,"contrapartidaUdesEfectivo":10000000,"aliadoEspecie":8000000,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":16000000,"total":64000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":11000000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":10000000,"total":29000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2000000,"total":4500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":0,"aliadoEfectivo":4500000,"entidadConvocatoriaEfectivo":12500000,"total":29000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":9000000,"aliadoEspecie":0,"aliadoEfectivo":3500000,"entidadConvocatoriaEfectivo":10500000,"total":23000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3500000,"total":7000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2500000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":7000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000}
    ]'::jsonb,
    170500000,
    '[
      {"objetivo":"OE1. Estandarización de aislamiento exosomal SEC y reclutamiento de cohorte","actividades":"Caracterización de vesículas CD63+ y toma de muestras basales","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Cuantificación RT-qPCR de miR-21, miR-155 y miR-10b en seguimiento","actividades":"Extracción de ARN exosomal en ciclo 3 y prequirúrgico","trimestres":[false,false,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Correlación con respuesta patológica RCB y publicación","actividades":"Modelado LASSO, curvas ROC y manuscrito Q1","trimestres":[false,false,false,false,false,false,false,true,true,true,true,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '9 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 15: CIM-2026-015 | Etapa: REENVIADO
-- Investigadora: Diana Carolina Duarte Meneses (Investigadora 7)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000015',
    'CIM-2026-015',
    '20000000-0000-0000-0000-000000000007',
    'REENVIADO',
    2,
    'Tamizaje acústico automatizado de la voz mediante aprendizaje profundo para la detección temprana de disfagia orofaríngea neurogénica en adultos mayores institucionalizados',
    'Facultad de Ciencias Médicas y de la Salud — Programas de Terapia Ocupacional y Fonoaudiología',
    'Bucaramanga',
    'Grupo de Salud Digital y Rehabilitación Comunitaria MASIRA',
    'Diana Carolina Duarte Meneses',
    'Fonoaudiología Clínica, Procesamiento de Voz e Inteligencia Artificial',
    'Diana Carolina Duarte Meneses',
    'diana.duarte@udes.edu.co',
    'Red de Centros de Bienestar del Anciano del Área Metropolitana de Bucaramanga',
    'Bucaramanga, Floridablanca y Piedecuesta, Santander',
    'Convocatoria Interna de Salud Digital y Envejecimiento Activo UDES 2026',
    'Interna Interdisciplinaria',
    '2026-12-17',
    '[
      {"nombre":"Dra. Diana Carolina Duarte Meneses","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección clínica, validación con prueba MECV-V y coordinación geriátrica"},
      {"nombre":"Fonoaud. MSc. Sergio Iván Bohórquez","rol":"Coinvestigador Acústica Clínica","entidad":"Universidad de Santander (UDES)","responsabilidades":"Extracción de parámetros acústicos (Jitter, Shimmer, HNR, MFCC) y protocolo de deglución"}
    ]'::jsonb,
    'La broncoaspiración silente secundaria a disfagia orofaríngea es una de las principales causas de neumonía aspirativa mortal en hogares geriátricos, donde el acceso a videofluoroscopia es limitado.',
    'Desarrollar y validar un modelo de clasificación acústica de cambios vocales pre y post-deglución capturados en dispositivos móviles para el tamizaje de disfagia orofaríngea en adultos mayores.',
    E'1. Registrar espectrogramas vocales de vocales sostenidas /a/ e /i/ antes y después de la prueba de volumen-viscosidad (MECV-V) en 210 adultos mayores.\n2. Entrenar una red neuronal convolucional sobre espectrogramas Mel y parámetros cepstrales (MFCC) para detectar voz húmeda y penetración laríngea.\n3. Determinar la sensibilidad, especificidad y valor predictivo negativo frente a evaluación fibroendoscópica de la deglución (FEES) en una submuestra de 70 participantes.',
    'Estudio observacional analítico de desarrollo y validación de prueba diagnóstica basado en aprendizaje automático.',
    'Seis centros geriátricos aliados y Laboratorio de Voz y Deglución de Fonoaudiología UDES.',
    '210 adultos mayores institucionalizados (>= 65 años), con submuestra aleatoria estratificada de 70 participantes para confirmación por FEES.',
    'Inclusión: Adultos >= 65 años capaces de emitir fonación sostenida por 4 segundos. Exclusión: Laringectomía previa, traqueostomía activa o disfonía orgánica tumoral.',
    'Jornadas clínicas de valoración fonoaudiológica integral en los centros de bienestar del anciano aliados.',
    'Micrófono condensador direccional calibrado a 15 cm, método de exploración clínica volumen-viscosidad (MECV-V) con pulsioximetría y nasofibrolaringoscopia (FEES).',
    'Grabación acústica basal a 44.1 kHz, administración de bolos de néctar, líquido y pudín, grabación post-deglución inmediata y extracción de embeddings acústicos.',
    'Área bajo la curva ROC (AUC), sensibilidad, especificidad, curvas Precision-Recall y análisis de explicabilidad SHAP.',
    'Riesgo mínimo con monitoreo continuo de saturación de oxígeno durante la prueba MECV-V y protocolo de succión disponible.',
    '1 modelo de tamizaje vocal embebido en app clínica, 1 artículo en revista Q1/Q2 y capacitación a cuidadores geriátricos.',
    'Asociación Colombiana de Fonoaudiología y Asociación Colombiana de Gerontología y Geriatría.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Ruido ambiental de fondo en los hogares geriátricos durante la grabación vocal","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Cabina acústica portátil plegable y micrófono cardioide con cancelación activa."},
      {"tipoRiesgo":"Administrativos","descripcion":"Autorización de representantes legales de adultos mayores sin familia cercana","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Coordinación con dirección técnica y defensoría de familia del centro geriátrico."},
      {"tipoRiesgo":"Legales","descripcion":"Protección biométrica de muestras de voz de los participantes","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Transformación inmediata a espectrogramas numéricos MFCC sin almacenar audio identificable."},
      {"tipoRiesgo":"Financieros","descripcion":"Costo de procesamiento GPU en la nube para entrenamiento de redes profundas","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Uso de estación de trabajo con GPU RTX disponible en el Instituto MASIRA."},
      {"tipoRiesgo":"De costos","descripcion":"Insumos espesantes grado farmacéutico para prueba MECV-V","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Adquisición mayorista de goma xantana estandarizada al inicio."},
      {"tipoRiesgo":"De calendario","descripcion":"Cuarentenas preventivas en hogares geriátricos por brotes gripales","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Cronograma rotativo entre las seis instituciones participantes."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":19500000,"contrapartidaUdesEfectivo":6000000,"aliadoEspecie":4000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":10000000,"total":39500000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":6500000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":6000000,"total":17500000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":1500000,"total":4500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":5500000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":7000000,"total":16500000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":4500000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":5000000,"total":11000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2700000,"total":5500000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":1500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":4500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":700000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":700000}
    ]'::jsonb,
    104000000,
    '[
      {"objetivo":"OE1. Captura acústica pre/post MECV-V en 210 adultos mayores","actividades":"Estandarización de cabina acústica portátil y registro de corpus vocal","trimestres":[true,true,true,true,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Confirmación fibroendoscópica FEES y entrenamiento de red CNN","actividades":"Evaluación estándar de oro en submuestra y modelado de espectrogramas Mel","trimestres":[false,false,false,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Validación diagnóstica, empaquetado de app y divulgación","actividades":"Cálculo de AUC-ROC, registro de software y artículo científico","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    NULL, NULL, '', FALSE, NOW() - INTERVAL '4 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 16: CIM-2026-016 | Etapa: VISTO_BUENO_CTC
-- Investigador: Jorge Enrique Castellanos Rueda (Investigador 8)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000016',
    'CIM-2026-016',
    '20000000-0000-0000-0000-000000000008',
    'VISTO_BUENO_CTC',
    2,
    'Vigilancia bajo enfoque Una Salud (One Health) de leptospirosis y rickettsiosis zoonótica en la interfaz humano-canino-roedor de asentamientos periurbanos de Bucaramanga',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina y Salud Pública',
    'Bucaramanga',
    'Grupo de Epidemiología Clínica y Enfermedades Tropicales MASIRA',
    'Jorge Enrique Castellanos Rueda',
    'Zoonosis, Una Salud (One Health) y Epidemiología Molecular',
    'Jorge Enrique Castellanos Rueda',
    'jorge.castellanos@udes.edu.co',
    'Secretaría de Salud y Ambiente de Bucaramanga — Unidad de Zoonosis',
    'Bucaramanga y Girón, Santander',
    'Convocatoria Nacional de Salud Ambiental y Zoonosis Reemergentes 2026',
    'Externa — Minciencias / MinSalud',
    '2026-12-14',
    '[
      {"nombre":"Dr. Jorge Enrique Castellanos Rueda","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección epidemiológica One Health y coordinación con autoridades de salud ambiental"},
      {"nombre":"Dra. Mónica Lucía Vera","rol":"Coinvestigadora Microbiología Zoonótica","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Microaglutinación (MAT) para 24 serovares de Leptospira, IFI para Rickettsia y qPCR"}
    ]'::jsonb,
    'Las lluvias extremas y deficiencias de saneamiento en asentamientos periurbanos favorecen el contacto estrecho entre humanos, caninos domésticos y roedores sinantrópicos, manteniendo focos hiperendémicos de leptospirosis y fiebres manchadas subdiagnosticadas.',
    'Caracterizar la seroprevalencia, circulación molecular de especies patógenas de Leptospira spp. y Rickettsia spp. y determinantes socioambientales en la tríada humano-canino-vector en cuatro comunas periurbanas.',
    E'1. Determinar títulos de anticuerpos mediante MAT (Leptospira) e IFI (Rickettsia) en 320 residentes humanos y 160 caninos cohabitantes.\n2. Detectar ADN de los genes lipL32 y gltA mediante qPCR en muestras de agua peridomiciliaria, garrapatas Rhipicephalus sanguineus y tejido renal de roedores sinantrópicos.\n3. Construir un índice espacial de vulnerabilidad zoonótica intradomiciliaria.',
    'Estudio ecoepidemiológico transversal multinivel bajo el marco operativo One Health.',
    'Cuatro asentamientos periurbanos de Bucaramanga/Girón y Laboratorio de Enfermedades Tropicales MASIRA - UDES.',
    'Muestreo multietápico por conglomerados de 160 viviendas (320 residentes, 160 caninos y trampeo Sherman peridomiciliario).',
    'Inclusión: Viviendas ubicadas a menos de 150 metros de rondas hídricas o taludes con tenencia de al menos un canino. Exclusión: Caninos vacunados contra leptospirosis en los últimos 6 meses.',
    'Articulación con jornadas de vacunación antirrábica y líderes de juntas de acción comunal.',
    'Prueba de microaglutinación (MAT) con panel de 24 serovares vivos, inmunofluorescencia indirecta (IFI), qPCR TaqMan y encuesta ambiental georreferenciada.',
    'Toma de muestra sanguínea humana y canina, recolección de ectoparásitos por peinado estandarizado, filtración de 1 L de agua superficial por membrana de 0.22 um y extracción de ADN.',
    'Modelos jerárquicos bayesianos espaciales y análisis de correspondencias múltiples.',
    'Riesgo mínimo para participantes humanos (Resolución 8430/1993) y aval del Comité de Ética para Uso de Animales (CICUAL-UDES) según Ley 84 de 1989.',
    'Cartografía de riesgo zoonótico entregada a Secretaría de Salud, 2 artículos Q1 y 1 cartilla comunitaria de prevención.',
    'Red Colombiana de Investigación en Zoonosis e Instituto Nacional de Salud (INS).',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Riesgo biológico del personal de laboratorio al mantener cepas vivas de Leptospira para MAT","probabilidad":"Poco probable","impacto":"Severo","medidasMitigacion":"Ejecución exclusiva en cabina de bioseguridad nivel II con EPP completo y quimioprofilaxis disponible."},
      {"tipoRiesgo":"Administrativos","descripcion":"Desconfianza comunitaria en asentamientos informales durante visitas domiciliarias","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Acompañamiento de técnicos de saneamiento ambiental y gestores comunitarios locales."},
      {"tipoRiesgo":"Legales","descripcion":"Cumplimiento de protocolos de bienestar animal en muestreo canino y captura de sinantrópicos","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Supervisión por médico veterinario certificado bajo protocolo CICUAL-UDES aprobado."},
      {"tipoRiesgo":"Financieros","descripcion":"Costo de importación de medio EMJH y enriquecimiento de albúmina bovina","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Adquisición anticipada de medio liofilizado para todo el periodo del estudio."},
      {"tipoRiesgo":"De costos","descripcion":"Reposición de trampas tipo Sherman extraviadas en campo","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Fondo de contingencia del 15% de trampas plegables de aluminio."},
      {"tipoRiesgo":"De calendario","descripcion":"Deslizamientos o lluvias torrenciales que impidan el ingreso a laderas","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Reprogramación en semanas de transición climática y monitoreo IDEAM."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":24000000,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":9000000,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":15000000,"total":59500000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":7500000,"aliadoEspecie":0,"aliadoEfectivo":2500000,"entidadConvocatoriaEfectivo":8000000,"total":22000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":1500000,"total":5000000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":9000000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":12000000,"total":28000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":0,"aliadoEfectivo":3500000,"entidadConvocatoriaEfectivo":10000000,"total":22000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3000000,"total":6000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":2000000,"total":7000000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":6000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":900000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":900000}
    ]'::jsonb,
    159900000,
    '[
      {"objetivo":"OE1. Censo georreferenciado y muestreo One Health en 160 viviendas","actividades":"Toma de muestras humanas, caninas, ectoparásitos y aguas peridomiciliarias","trimestres":[true,true,true,true,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Procesamiento serológico MAT/IFI y amplificación qPCR lipL32/gltA","actividades":"Titulación de serovares de Leptospira y detección molecular de Rickettsia","trimestres":[false,false,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Modelado espacial bayesiano e intervención comunitaria","actividades":"Construcción de mapas de riesgo, socialización y artículos Q1","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    '2026-11-29', NULL, '', FALSE, NOW() - INTERVAL '11 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 17: CIM-2026-017 | Etapa: EN_PLENO_CTC
-- Investigadora: Dra. Laura Juliana Mantilla Pinzón (Investigadora 3)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000017',
    'CIM-2026-017',
    '20000000-0000-0000-0000-000000000003',
    'EN_PLENO_CTC',
    2,
    'Impacto del método madre canguro temprano acoplado a oximetría cerebral NIRS sobre la estabilidad autonómica y neurodesarrollo en prematuros tardíos de unidades neonatales',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Enfermería',
    'Bucaramanga',
    'Grupo de Cuidado Crítico y Salud Materno-Perinatal MASIRA',
    'Dra. Laura Juliana Mantilla Pinzón',
    'Cuidado Neonatal, Neuroprotección y Salud Materno-Perinatal',
    'Dra. Laura Juliana Mantilla Pinzón',
    'laura.mantilla@udes.edu.co',
    'Hospital Universitario de Santander (HUS) — Unidad de Cuidado Intensivo Neonatal',
    'Bucaramanga, Santander',
    'Convocatoria Nacional de Salud Infantil y Neuroprotección Perinatal 2026',
    'Externa — Minciencias',
    '2026-12-16',
    '[
      {"nombre":"Dra. Laura Juliana Mantilla Pinzón","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección neonatal, monitoreo de espectroscopia de infrarrojo cercano (NIRS) y seguimiento"},
      {"nombre":"Dra. Sofía Alejandra Pradilla","rol":"Coinvestigadora Neonatología","entidad":"Hospital Universitario de Santander","responsabilidades":"Evaluación neurológica Hammersmith (HINE) y supervisión de estabilidad cardiorrespiratoria"}
    ]'::jsonb,
    'Los recién nacidos prematuros tardíos (34 a 36.6 semanas) presentan inmadurez en la autorregulación del flujo sanguíneo cerebral y episodios de desaturación subclínica que pueden atenuarse mediante contacto piel a piel temprano monitorizado.',
    'Determinar el efecto del método madre canguro iniciado en las primeras 24 horas de vida sobre la saturación regional de oxígeno cerebral (rScO2 por NIRS), variabilidad autonómica y puntaje HINE a los 3 meses de edad corregida.',
    E'1. Registrar de forma continua la saturación tisular cerebral (rScO2) y extracción fraccional de oxígeno (FTOE) antes, durante y después de sesiones de 120 minutos de posición canguro en 84 prematuros.\n2. Comparar la incidencia de apneas, bradicardias e hipotermia neonatal frente al cuidado en incubadora convencional.\n3. Evaluar el desempeño motor y tono muscular mediante la escala Hammersmith Infant Neurological Examination (HINE) a las 40 semanas y 3 meses de edad corregida.',
    'Ensayo clínico controlado aleatorizado por bloques permutados en unidad neonatal.',
    'Unidad de Cuidado Intermedio e Intensivo Neonatal del HUS e Instituto MASIRA - UDES.',
    '84 neonatos prematuros (32 a 36 semanas de edad gestacional) hemodinámicamente estables sin ventilación mecánica invasiva.',
    'Inclusión: Prematuros de 32.0 a 36.6 semanas con peso >= 1500 g y estabilidad térmica inicial. Exclusión: Malformaciones congénitas mayores, hemorragia intraventricular grado III-IV o encefalopatía hipóxico-isquémica.',
    'Captación en sala de partos y admisión neonatal durante las primeras 12 horas posnatales.',
    'Monitor de espectroscopia de infrarrojo cercano (NIRS) con sensor neonatal frontal, electrocardiografía continua, termometría cutánea dual y escala HINE.',
    'Colocación de sensor optodo NIRS no adhesivo en región frontoparietal, registro basal de 30 min en incubadora, transferencia estandarizada a posición canguro por 120 min diarios durante 7 días y control ambulatorio en programa canguro.',
    'ANOVA mixto para series temporales fisiológicas y regresión lineal ajustada por edad gestacional y peso al nacer.',
    'Riesgo mínimo con sensores ópticos neonatales hipoalergénicos certificados FDA/INVIMA y consentimiento informado de ambos padres.',
    '1 protocolo clínico de neuroprotección neonatal guiado por NIRS, 2 artículos Q1/Q2 y fortalecimiento del programa Madre Canguro.',
    'Fundación Canguro Colombia y Asociación Colombiana de Neonatología (ASCON).',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Irritación epidérmica leve por fijación del sensor óptico frontal en piel prematura","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Uso de banda elástica de silicona suave sin adhesivo directo sobre la piel."},
      {"tipoRiesgo":"Administrativos","descripcion":"Alta hospitalaria temprana antes de completar los 7 días de registro NIRS","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Continuación de las sesiones de medición en la consulta externa diaria del Programa Madre Canguro."},
      {"tipoRiesgo":"Legales","descripcion":"Consentimiento informado en madres adolescentes puérperas","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Firma conjunta de asentimiento materno y consentimiento del representante legal."},
      {"tipoRiesgo":"Financieros","descripcion":"Incremento en precio de sensores NIRS neonatales desechables","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Compra por paquete hospitalario de 100 sensores con descuento institucional."},
      {"tipoRiesgo":"De costos","descripcion":"Deserción al control neurológico de los 3 meses de edad corregida","probabilidad":"Probable","impacto":"Moderado","medidasMitigacion":"Auxilio de transporte familiar y seguimiento telefónico quincenal por enfermería."},
      {"tipoRiesgo":"De calendario","descripcion":"Ocupación variable de cubículos neonatales por épocas del año","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Ventana de reclutamiento continua durante 5 trimestres."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":23000000,"contrapartidaUdesEfectivo":8000000,"aliadoEspecie":7000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":14000000,"total":52000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":9500000,"aliadoEspecie":0,"aliadoEfectivo":3500000,"entidadConvocatoriaEfectivo":9000000,"total":26000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":1500000,"total":4500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2500000,"contrapartidaUdesEfectivo":5000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":6500000,"total":16000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":9500000,"total":21000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3000000,"total":6000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":6000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1800000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1800000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1200000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1200000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":800000}
    ]'::jsonb,
    137300000,
    '[
      {"objetivo":"OE1. Estandarización de oximetría NIRS neonatal y reclutamiento","actividades":"Entrenamiento en unidad neonatal y aleatorización de díadas madre-hijo","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Monitoreo de rScO2 y FTOE durante posición canguro temprana","actividades":"Registros seriados de 120 minutos y control de estabilidad térmica/autonómica","trimestres":[false,false,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Seguimiento neurológico HINE a 3 meses y publicación","actividades":"Valoración motora a edad corregida, análisis estadístico y artículo Q1","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    '2026-11-20', 'FAVORABLE', 'Propuesta en deliberación del Pleno CTC con dos firmas registradas y pendiente la firma del tercer miembro del comité.', TRUE, NOW() - INTERVAL '14 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 18: CIM-2026-018 | Etapa: FAVORABLE_CON_OBSERVACIONES
-- Investigador: Dr. Andrés Felipe Villamizar Ortiz (Investigador 4)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000018',
    'CIM-2026-018',
    '20000000-0000-0000-0000-000000000004',
    'FAVORABLE_CON_OBSERVACIONES',
    2,
    'Entrenamiento de músculos inspiratorios de alta intensidad guiado por ecografía diafragmática en el destete ventilatorio difícil de pacientes críticos',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Fisioterapia',
    'Bucaramanga',
    'Grupo de Neurociencias y Rehabilitación Funcional MASIRA',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'Fisioterapia en Cuidado Crítico, Mecánica Ventilatoria y Rehabilitación Cardiopulmonar',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'andres.villamizar@udes.edu.co',
    'Clínica Médicos de Alta Complejidad — Unidad de Cuidado Intensivo Adultos',
    'Bucaramanga, Santander',
    'Convocatoria de Investigación Clínica en Medicina Crítica y Rehabilitación 2026',
    'Interna con Alianza Hospitalaria',
    '2026-12-19',
    '[
      {"nombre":"Dr. Andrés Felipe Villamizar Ortiz","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección metodológica, ecografía de fracción de engrosamiento diafragmático y análisis"},
      {"nombre":"Ft. Esp. Camilo Andrés Serrano","rol":"Coinvestigador Cuidado Intensivo","entidad":"Universidad de Santander (UDES)","responsabilidades":"Aplicación del protocolo de válvula electrónica de umbral inspiratorio IMT en UCI"}
    ]'::jsonb,
    'La disfunción diafragmática inducida por la ventilación mecánica ocurre en más del 60% de los pacientes intubados por más de 72 horas, siendo la causa principal de fracaso en la prueba de respiración espontánea y reintubación.',
    'Evaluar la eficacia de un protocolo de entrenamiento muscular inspiratorio electrónico ajustado al 50% de la presión inspiratoria máxima (PIM) sobre la fracción de engrosamiento diafragmático y el éxito de extubación.',
    E'1. Medir el cambio en la excursión y fracción de engrosamiento diafragmático (TFdi) por ultrasonografía en modo M en 76 pacientes con destete difícil.\n2. Comparar la tasa de éxito de destete ventilatorio a los 7 días y días libres de ventilador a los 28 días.\n3. Determinar la variación en el índice de respiración rápida y superficial (RSBI) y presión inspiratoria máxima.',
    'Ensayo clínico controlado aleatorizado con evaluación ecográfica ciega.',
    'Unidad de Cuidado Intensivo Polivalente de la Clínica Aliada e Instituto MASIRA - UDES.',
    '76 pacientes adultos con ventilación mecánica invasiva > 72 horas y al menos un fallo previo en prueba de respiración espontánea.',
    'Inclusión: Adultos >= 18 años en modo presión soporte con PEEP <= 8 cmH2O, FiO2 <= 0.4 y RASS entre -1 y +1. Exclusión: Parálisis frénica traumática, enfermedades neuromusculares primarias o traqueostomía previa.',
    'Tamizaje diario en revista multidisciplinaria de terapia respiratoria y medicina crítica.',
    'Ecógrafo portátil con transductor lineal de 10-12 MHz y convexo de 3.5 MHz, dispositivo electrónico de carga umbral inspiratoria (POWERbreathe KH2) y manovacuometría digital.',
    'Medición diaria de PIM mediante oclusión unidireccional de 20 segundos, 2 sesiones diarias de 30 respiraciones al 50% de la PIM conectadas al tubo endotraqueal y medición ecográfica en zona de aposición derecha.',
    'Análisis de tiempo hasta extubación exitosa con riesgos competitivos de Fine-Gray y t de Student/Mann-Whitney.',
    'Riesgo mayor que el mínimo controlado en UCI con criterios estrictos de detención ante desaturación < 90% o taquicardia > 130 lpm.',
    '1 protocolo de destete difícil guiado por ecografía, 1 artículo Q1/Q2 y entrenamiento a fisioterapeutas intensivistas.',
    'Asociación Colombiana de Medicina Crítica y Cuidado Intensivo (AMCI) y Colegio Colombiano de Fisioterapeutas.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Fatiga respiratoria transitoria durante las series de entrenamiento umbral","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Monitoreo continuo de presión arterial invasiva, SpO2 y suspensión inmediata si FR > 35 rpm."},
      {"tipoRiesgo":"Administrativos","descripcion":"Variabilidad interobservador en la medición ecográfica del grosor diafragmático","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Marcación cutánea en noveno espacio intercostal y coeficiente de correlación intraclase > 0.90 previo."},
      {"tipoRiesgo":"Legales","descripcion":"Obtención de consentimiento informado en paciente intubado sedado","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Consentimiento firmado por familiar de primer grado y ratificación por el paciente tras extubación."},
      {"tipoRiesgo":"Financieros","descripcion":"Costo de filtros antibacterianos/antivirales de alta eficiencia y válvulas desechables","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Compra por volumen de 200 adaptadores autoclavables y filtros HMEF."},
      {"tipoRiesgo":"De costos","descripcion":"Deterioro de cabezal electrónico de medición de presión inspiratoria","probabilidad":"No probable","impacto":"Moderado","medidasMitigacion":"Póliza de garantía de 2 años y sensor de respaldo."},
      {"tipoRiesgo":"De calendario","descripcion":"Traslado temprano de pacientes a otras unidades por gestión de camas","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Acuerdo con coordinación de UCI para mantener al participante hasta definición de destete."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":21000000,"contrapartidaUdesEfectivo":7000000,"aliadoEspecie":6000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":11000000,"total":45000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":7500000,"total":24000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":1500000,"total":4500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":4000000,"aliadoEspecie":0,"aliadoEfectivo":1500000,"entidadConvocatoriaEfectivo":4500000,"total":12000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":6000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":7000000,"total":15000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":2700000,"total":5500000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":5500000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1000000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":700000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":700000}
    ]'::jsonb,
    116200000,
    '[
      {"objetivo":"OE1. Estandarización de ecografía diafragmática y protocolo IMT en UCI","actividades":"Concordancia interobservador y alistamiento de válvulas electrónicas","trimestres":[true,true,false,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Intervención en 76 pacientes con destete ventilatorio difícil","actividades":"Entrenamiento inspiratorio diario, medición de TFdi y seguimiento de extubación","trimestres":[false,true,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Análisis de riesgos competitivos y transferencia clínica","actividades":"Modelado Fine-Gray, guía de práctica en UCI y publicación Q1","trimestres":[false,false,false,false,false,false,false,true,true,true,false,false]}
    ]'::jsonb,
    '2026-11-16',
    'FAVORABLE_CON_OBSERVACIONES',
    'Concepto FAVORABLE CON OBSERVACIONES emitido por el Pleno del CTC. Pendiente subsanar los umbrales hemodinámicos de suspensión de la sesión IMT en pacientes con soporte vasopresor mínimo.',
    FALSE,
    NOW() - INTERVAL '19 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 19: CIM-2026-019 | Etapa: FAVORABLE
-- Investigadora: Claudia Patricia Jaimes Calderón (Investigadora 5)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000019',
    'CIM-2026-019',
    '20000000-0000-0000-0000-000000000005',
    'FAVORABLE',
    2,
    'Evaluación clínica y microbiológica de suturas quirúrgicas recubiertas con nanopartículas de óxido de zinc-quitosano para la prevención de infección del sitio operatorio en cirugía abdominal limpia-contaminada',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Instrumentación Quirúrgica',
    'Bucaramanga',
    'Grupo de Bioingeniería y Seguridad del Paciente MASIRA',
    'Claudia Patricia Jaimes Calderón',
    'Biomateriales Quirúrgicos, Nanotecnología y Prevención de ISO',
    'Claudia Patricia Jaimes Calderón',
    'claudia.jaimes@udes.edu.co',
    'Hospital Internacional de Colombia (HIC) — Departamento de Cirugía General',
    'Bucaramanga y Piedecuesta, Santander',
    'Convocatoria Nacional de Bioingeniería y Dispositivos Médicos 2026',
    'Externa — Minciencias',
    '2026-12-11',
    '[
      {"nombre":"Dra. Claudia Patricia Jaimes Calderón","rol":"Investigadora Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección general, evaluación de desempeño mecánico de nudo quirúrgico y vigilancia de ISO a 30 días"},
      {"nombre":"PhD. Andrés Mauricio Blanco","rol":"Coinvestigador Biomateriales","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Funcionalización por electrospray de poliglactina 910 con ZnO-quitosano y ensayos de citotoxicidad MTT"}
    ]'::jsonb,
    'Las suturas trenzadas absorbibles convencionales facilitan la adherencia capilar bacteriana de E. coli y S. aureus en cirugía abdominal limpia-contaminada, mientras que el triclosán presenta resistencia cruzada emergente.',
    'Determinar la eficacia antibiopelícula in vitro, biocompatibilidad dérmica y desempeño mecánico de tensión de suturas de poliglactina 910 funcionalizadas con nanocompuestos de ZnO-quitosano frente a patógenos de infección del sitio operatorio.',
    E'1. Sintetizar y caracterizar por SEM-EDS y FTIR el recubrimiento uniforme de nanopartículas de ZnO-quitosano sobre suturas de poliglactina 910 calibres 2-0 y 0.\n2. Evaluar la reducción logarítmica de formación de biopelícula de S. aureus ATCC 25923, E. coli ATCC 25922 y E. faecalis en modelo dinámico de flujo.\n3. Verificar la resistencia tensil al nudo quirúrgico según norma USP <881> y la viabilidad celular > 85% en fibroblastos dérmicos humanos (ISO 10993-5).',
    'Estudio experimental preclínico in vitro de desarrollo y validación normativa de dispositivo médico clase IIb.',
    'Laboratorio de Biomateriales y Microbiología del Instituto MASIRA - UDES.',
    '450 segmentos estandarizados de sutura quirúrgica distribuidos en 3 grupos (control sin recubrir, recubrimiento triclosán comercial y recubrimiento ZnO-quitosano MASIRA).',
    'Inclusión: Hebras estériles de poliglactina 910 calibres 2-0 y 0 con lote trazable. Exclusión: Hebras con defectos de trenzado o empaque comprometido.',
    'Muestreo aleatorio por bloques de lotes industriales suministrados para funcionalización.',
    'Microscopía electrónica de barrido (SEM), máquina universal de ensayos mecánicos Instron, reactor de biopelícula CDC y ensayo colorimétrico MTT.',
    'Inmersión asistida por ultrasonido y electrospray de matriz de quitosano de bajo peso molecular con NPs-ZnO (30 nm), esterilización por óxido de etileno y pruebas de elución a 1, 7, 14 y 28 días.',
    'ANOVA de una y dos vías con pruebas post-hoc de Tukey y análisis de superficie de respuesta Box-Behnken.',
    'Investigación preclínica sin sujetos humanos ni animales; manejo de residuos nanotecnológicos bajo protocolo ambiental UDES.',
    '1 patente de invención de recubrimiento quirúrgico, 2 artículos Q1 en revistas de biomateriales y 1 trabajo de grado.',
    'Cámara de Dispositivos Médicos de la ANDI y Red Colombiana de Nanociencia y Nanotecnología.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Aglomeración de nanopartículas de ZnO durante el proceso de recubrimiento","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Sonicación de alta energía con control de potencial Zeta > +30 mV en matriz de quitosano."},
      {"tipoRiesgo":"Administrativos","descripcion":"Demora en turnos de microscopía electrónica de barrido (SEM-EDS)","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Reserva programada desde el trimestre 1 en convenio interuniversitario."},
      {"tipoRiesgo":"Legales","descripcion":"Acuerdo de cotitularidad de propiedad intelectual sobre la formulación","probabilidad":"No probable","impacto":"Leve","medidasMitigacion":"Minuta de propiedad intelectual avalada por la oficina de transferencia OTRI-UDES."},
      {"tipoRiesgo":"Financieros","descripcion":"Fluctuación en costo de líneas celulares primarias de fibroblastos dérmicos ATCC","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Uso de crioviales certificados ya disponibles en el banco celular del Instituto MASIRA."},
      {"tipoRiesgo":"De costos","descripcion":"Pérdida de resistencia tensil por exceso de humedad en esterilización","probabilidad":"No probable","impacto":"Moderado","medidasMitigacion":"Ciclo validado de óxido de etileno en seco con empaque de aluminio trilaminado."},
      {"tipoRiesgo":"De calendario","descripcion":"Tiempos de búsqueda de anterioridad para redacción de pliego de patente","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Vigilancia tecnológica iniciada en paralelo con el objetivo específico 2."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":24000000,"contrapartidaUdesEfectivo":9000000,"aliadoEspecie":6000000,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":14000000,"total":57000000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":4500000,"contrapartidaUdesEfectivo":9500000,"aliadoEspecie":0,"aliadoEfectivo":3000000,"entidadConvocatoriaEfectivo":8000000,"total":25000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":1500000,"total":3500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":3000000,"contrapartidaUdesEfectivo":10000000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":13000000,"total":30000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":8500000,"aliadoEspecie":0,"aliadoEfectivo":3500000,"entidadConvocatoriaEfectivo":10000000,"total":22000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":5000000,"aliadoEspecie":0,"aliadoEfectivo":2000000,"entidadConvocatoriaEfectivo":5000000,"total":12000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2000000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2000000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":6000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2000000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2000000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":800000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":800000}
    ]'::jsonb,
    161800000,
    '[
      {"objetivo":"OE1. Síntesis y caracterización fisicoquímica SEM-EDS/FTIR del recubrimiento","actividades":"Funcionalización de poliglactina 910 con ZnO-quitosano y control de espesor","trimestres":[true,true,true,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Ensayos microbiológicos antibiopelícula y pruebas mecánicas USP <881>","actividades":"Cinética de inhibición bacteriana y resistencia tensil al nudo quirúrgico","trimestres":[false,false,true,true,true,true,false,false,false,false,false,false]},
      {"objetivo":"OE3. Citotoxicidad ISO 10993-5, solicitud de patente y publicación Q1","actividades":"Ensayos MTT en fibroblastos, redacción de patente y manuscritos","trimestres":[false,false,false,false,false,false,true,true,true,true,false,false]}
    ]'::jsonb,
    '2026-11-12',
    'FAVORABLE',
    'Concepto FAVORABLE definitivo aprobado por unanimidad en sesión plenaria del Comité Técnico Científico MASIRA con las tres firmas criptográficas verificadas.',
    TRUE,
    NOW() - INTERVAL '24 days'
);

-- -----------------------------------------------------------------------------
-- PROPUESTA 20: CIM-2026-020 | Etapa: FAVORABLE
-- Investigador: Mauricio Alejandro Pineda Vargas (Investigador 6)
-- -----------------------------------------------------------------------------
INSERT INTO proposals (
    id, code, investigator_id, status, revision_count,
    title, academic_program, campus, backing_group, group_leader, research_line,
    principal_investigator_name, principal_investigator_email, allied_entity_name,
    development_location, call_name, call_type, call_deadline,
    work_team, problem_and_justification, general_objective, specific_objectives,
    methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
    recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
    ethical_considerations, expected_results, possible_alliances,
    risk_matrix, budget_items, budget_total, schedule_items,
    ctc_session_date, ctc_concept, ctc_general_concept_notes, ctc_modifications_cleared, submitted_at
) VALUES (
    '30000000-0000-0000-0000-000000000020',
    'CIM-2026-020',
    '20000000-0000-0000-0000-000000000006',
    'FAVORABLE',
    2,
    'Farmacogenómica de variantes DPYD, UGT1A1 y TYMS para la dosificación personalizada y prevención de toxicidad severa por fluoropirimidinas e irinotecán en pacientes oncológicos de Santander',
    'Facultad de Ciencias Médicas y de la Salud — Programa de Medicina',
    'Bucaramanga',
    'Grupo de Biología Molecular y Oncología Traslacional MASIRA',
    'Mauricio Alejandro Pineda Vargas',
    'Farmacogenómica Clínica, Medicina Personalizada y Seguridad Oncológica',
    'Mauricio Alejandro Pineda Vargas',
    'mauricio.pineda@udes.edu.co',
    'Centro de Cáncer y Enfermedades Hematológicas de Santander',
    'Bucaramanga y Área Metropolitana, Santander',
    'Convocatoria Nacional de Medicina Personalizada y Farmacoseguridad 2026',
    'Externa — Minciencias',
    '2026-12-09',
    '[
      {"nombre":"Dr. Mauricio Alejandro Pineda Vargas","rol":"Investigador Principal","entidad":"Universidad de Santander (UDES) - Instituto MASIRA","responsabilidades":"Dirección clínica, recomendación posológica según guías CPIC y evaluación de toxicidad CTCAE v5.0"},
      {"nombre":"Bact. PhD. Carolina Méndez Gómez","rol":"Coinvestigadora Genotipificación","entidad":"Instituto de Investigación MASIRA - UDES","responsabilidades":"Genotipificación de alelos DPYD*2A, *13, c.2846A>T, HapB3 y UGT1A1*28 por discriminación alélica TaqMan"}
    ]'::jsonb,
    'Hasta el 18% de los pacientes con tumores gastrointestinales tratados con 5-fluorouracilo, capecitabina o irinotecán desarrollan toxicidad grado 3-4 (neutropenia febril, mucositis y diarrea severa) asociada a deficiencia parcial de DPD o UGT1A1 no tamizada antes del primer ciclo.',
    'Evaluar el impacto clínico y económico de la implementación prospectiva de un panel farmacogenómico pre-tratamiento (DPYD/UGT1A1/TYMS) para guiar el ajuste posológico individualizado en pacientes con cáncer gastrointestinal.',
    E'1. Determinar la frecuencia alélica y genotípica de variantes de riesgo en DPYD, UGT1A1 y región promotora 5-UTR de TYMS en 200 pacientes oncológicos de Santander.\n2. Comparar la incidencia de eventos adversos severos (CTCAE grado >= 3) y hospitalizaciones no programadas durante los primeros 4 ciclos frente a una cohorte histórica no genotipificada.\n3. Estimar el ahorro neto por paciente derivado de la reducción de ingresos a cuidado intensivo y uso de factores estimulantes de colonias.',
    'Estudio clínico prospectivo de implementación farmacogenómica guiada por guías CPIC con evaluación de costo-efectividad.',
    'Servicios de Quimioterapia Ambulatoria del Centro Aliado y Laboratorio de Biología Molecular MASIRA - UDES.',
    '200 pacientes adultos con adenocarcinoma gástrico, pancreático o colorrectal candidatos a esquemas FOLFOX, FOLFIRI, XELOX o FOLFIRINOX.',
    'Inclusión: Pacientes >= 18 años vírgenes a fluoropirimidinas e irinotecán con ECOG 0-2. Exclusión: Insuficiencia hepática severa (bilirrubina > 3x LSN) o falla renal crónica estadio 4-5.',
    'Captación en consulta de oncología médica al momento de prescribir el esquema citotóxico, con entrega de resultado genético en < 72 horas.',
    'Discriminación alélica por qPCR con sondas TaqMan MGB, secuenciación Sanger confirmatoria de variantes raras y escala NCI-CTCAE v5.0.',
    'Toma de sangre periférica o hisopado bucal, extracción rápida de ADN genómico, emisión de reporte clínico con puntaje de actividad enzimática CPIC (0 a 2.0) y ajuste del 25-50% de dosis inicial en portadores heterocigotos.',
    'Equilibrio de Hardy-Weinberg, regresión de Poisson modificada para riesgo relativo de toxicidad severa y árbol de decisión de Markov.',
    'Riesgo mínimo con asesoría genética farmacológica y beneficio clínico directo para los portadores de variantes de metabolización lenta.',
    '1 servicio diagnóstico de farmacogenómica rápida habilitado en MASIRA, 2 artículos Q1 y guía institucional de dosificación CPIC.',
    'Consorcio Latinoamericano de Farmacogenómica y Red Colombiana de Medicina Personalizada.',
    '[
      {"tipoRiesgo":"Operacionales","descripcion":"Tiempo de respuesta de laboratorio superior a 72 horas que retrase el inicio de quimioterapia","probabilidad":"Poco probable","impacto":"Severo","medidasMitigacion":"Corridas de qPCR tres veces por semana con protocolo de extracción automatizada en 45 minutos."},
      {"tipoRiesgo":"Administrativos","descripcion":"Falta de adopción de la reducción de dosis recomendada por parte del oncólogo tratante","probabilidad":"Poco probable","impacto":"Moderado","medidasMitigacion":"Inclusión del reporte CPIC directamente en la junta médica previa a la orden de mezcla en central."},
      {"tipoRiesgo":"Legales","descripcion":"Manejo de hallazgos de homocigosis de deficiencia completa de DPD","probabilidad":"No probable","impacto":"Moderado","medidasMitigacion":"Notificación urgente inmediata en < 24 horas para cambio de esquema terapéutico no fluoropirimidínico."},
      {"tipoRiesgo":"Financieros","descripcion":"Variación en el costo de sondas TaqMan de genotipificación de SNPs","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Compra inicial de placas preconfiguradas de 384 pozos para las 200 muestras."},
      {"tipoRiesgo":"De costos","descripcion":"Repetición de genotipificación por amplificación tardía en muestras de hisopado bucal","probabilidad":"Poco probable","impacto":"Leve","medidasMitigacion":"Priorización de muestra de sangre total en EDTA con rendimiento > 30 ng/uL."},
      {"tipoRiesgo":"De calendario","descripcion":"Demoras en autorización de ciclos de quimioterapia por parte de las EPS","probabilidad":"Probable","impacto":"Leve","medidasMitigacion":"Toma de muestra farmacogenómica el mismo día de expedición de la orden médica."}
    ]'::jsonb,
    '[
      {"item":1,"rubro":"Talento humano","contrapartidaUdesEspecie":27000000,"contrapartidaUdesEfectivo":10500000,"aliadoEspecie":9000000,"aliadoEfectivo":5000000,"entidadConvocatoriaEfectivo":17000000,"total":68500000},
      {"item":2,"rubro":"Equipos y software","contrapartidaUdesEspecie":5000000,"contrapartidaUdesEfectivo":10000000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":9000000,"total":28000000},
      {"item":3,"rubro":"Capacitación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2500000,"aliadoEspecie":0,"aliadoEfectivo":1000000,"entidadConvocatoriaEfectivo":2000000,"total":5500000},
      {"item":4,"rubro":"Servicios tecnológicos y pruebas","contrapartidaUdesEspecie":3500000,"contrapartidaUdesEfectivo":9500000,"aliadoEspecie":0,"aliadoEfectivo":5000000,"entidadConvocatoriaEfectivo":14000000,"total":32000000},
      {"item":5,"rubro":"Materiales, insumos y documentación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":9500000,"aliadoEspecie":0,"aliadoEfectivo":4000000,"entidadConvocatoriaEfectivo":11500000,"total":25000000},
      {"item":6,"rubro":"Protección de conocimiento y divulgación","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":3500000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":3500000,"total":7000000},
      {"item":7,"rubro":"Gastos de viaje","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":2200000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2200000},
      {"item":8,"rubro":"Infraestructura","contrapartidaUdesEspecie":4500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":2500000,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":7000000},
      {"item":9,"rubro":"Administrativos","contrapartidaUdesEspecie":2200000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":2200000},
      {"item":10,"rubro":"Seguimiento","contrapartidaUdesEspecie":1500000,"contrapartidaUdesEfectivo":0,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1500000},
      {"item":11,"rubro":"Otros","contrapartidaUdesEspecie":0,"contrapartidaUdesEfectivo":1100000,"aliadoEspecie":0,"aliadoEfectivo":0,"entidadConvocatoriaEfectivo":0,"total":1100000}
    ]'::jsonb,
    180000000,
    '[
      {"objetivo":"OE1. Validación analítica del panel TaqMan DPYD/UGT1A1/TYMS","actividades":"Curvas de eficiencia con controles Coriell y flujo de reporte < 72 horas","trimestres":[true,true,false,false,false,false,false,false,false,false,false,false]},
      {"objetivo":"OE2. Genotipificación prospectiva y ajuste posológico CPIC en 200 pacientes","actividades":"Tamizaje pre-quimioterapia y vigilancia de toxicidad CTCAE v5.0 por 4 ciclos","trimestres":[false,true,true,true,true,true,true,false,false,false,false,false]},
      {"objetivo":"OE3. Evaluación farmacoeconómica de Markov y publicación científica","actividades":"Cálculo de costos evitados en hospitalización/UCI y redacción de 2 artículos Q1","trimestres":[false,false,false,false,false,false,false,true,true,true,true,false]}
    ]'::jsonb,
    '2026-11-12',
    'FAVORABLE',
    'Concepto FAVORABLE definitivo aprobado por unanimidad en sesión plenaria del Comité Técnico Científico MASIRA y respaldado con las tres firmas criptográficas de token único.',
    TRUE,
    NOW() - INTERVAL '26 days'
);

-- =============================================================================
-- 4. DOCUMENTACIÓN ADICIONAL ADJUNTA (proposal_attachments)
-- =============================================================================

INSERT INTO proposal_attachments (proposal_id, file_name, mime_type, file_size_bytes, category, uploaded_by) VALUES
('30000000-0000-0000-0000-000000000001', 'Borrador_Protocolo_Hemodinamico_CIM_001.pdf', 'application/pdf', 214500, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000001'),
('30000000-0000-0000-0000-000000000002', 'Aval_Grupo_Infecciosas_MASIRA_CIM_002.pdf', 'application/pdf', 284120, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000002'),
('30000000-0000-0000-0000-000000000002', 'Carta_Intencion_HUS_Microbiologia_CIM_002.pdf', 'application/pdf', 198400, 'Carta de Intención Entidad Aliada', '20000000-0000-0000-0000-000000000002'),
('30000000-0000-0000-0000-000000000003', 'Escala_MEOWS_Obstetrica_Anexo_CIM_003.pdf', 'application/pdf', 310200, 'Consentimiento Informado y Anexo Ético', '20000000-0000-0000-0000-000000000003'),
('30000000-0000-0000-0000-000000000004', 'Protocolo_Biomecanico_3D_Subsanado_V2_CIM_004.pdf', 'application/pdf', 342800, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000004'),
('30000000-0000-0000-0000-000000000005', 'Convenio_Central_Esterilizacion_CIM_005.pdf', 'application/pdf', 265900, 'Carta de Intención Entidad Aliada', '20000000-0000-0000-0000-000000000005'),
('30000000-0000-0000-0000-000000000006', 'Aval_Comite_Etica_Biopsia_Liquida_CIM_006.pdf', 'application/pdf', 389400, 'Consentimiento Informado y Anexo Ético', '20000000-0000-0000-0000-000000000006'),
('30000000-0000-0000-0000-000000000006', 'Cotizacion_Sondas_ddPCR_Oncologia_CIM_006.pdf', 'application/pdf', 176300, 'Cotización de Equipos o Reactivos', '20000000-0000-0000-0000-000000000006'),
('30000000-0000-0000-0000-000000000007', 'Cartas_Adhesion_Hospitales_Soto_Norte_CIM_007.pdf', 'application/pdf', 412000, 'Carta de Intención Entidad Aliada', '20000000-0000-0000-0000-000000000007'),
('30000000-0000-0000-0000-000000000008', 'Aval_Secretaria_Salud_Santander_Arbovirus_CIM_008.pdf', 'application/pdf', 356700, 'Carta de Intención Entidad Aliada', '20000000-0000-0000-0000-000000000008'),
('30000000-0000-0000-0000-000000000008', 'Permiso_Recoleccion_Entomologica_UDES_CIM_008.pdf', 'application/pdf', 295100, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000008'),
('30000000-0000-0000-0000-000000000009', 'Protocolo_Cronobiologia_Turnos_HUS_CIM_009.pdf', 'application/pdf', 274600, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000001'),
('30000000-0000-0000-0000-000000000010', 'Protocolo_Exploratorio_Fagoterapia_CIM_010.pdf', 'application/pdf', 248900, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000002'),
('30000000-0000-0000-0000-000000000011', 'Borrador_Prevencion_Delirio_UCIM_CIM_011.pdf', 'application/pdf', 228400, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000003'),
('30000000-0000-0000-0000-000000000012', 'Aval_Fundacion_Neurologica_Parkinson_RV_CIM_012.pdf', 'application/pdf', 315800, 'Carta de Intención Entidad Aliada', '20000000-0000-0000-0000-000000000004'),
('30000000-0000-0000-0000-000000000013', 'Especificaciones_RFID_Quirurgico_UHF_CIM_013.pdf', 'application/pdf', 294500, 'Cotización de Equipos o Reactivos', '20000000-0000-0000-0000-000000000005'),
('30000000-0000-0000-0000-000000000014', 'Protocolo_Exosomas_miRNA_Mama_TNBC_CIM_014.pdf', 'application/pdf', 361200, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000006'),
('30000000-0000-0000-0000-000000000015', 'Protocolo_Acustico_Disfagia_Subsanado_V2_CIM_015.pdf', 'application/pdf', 339100, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000007'),
('30000000-0000-0000-0000-000000000016', 'Aval_CICUAL_UDES_OneHealth_Zoonosis_CIM_016.pdf', 'application/pdf', 402300, 'Consentimiento Informado y Anexo Ético', '20000000-0000-0000-0000-000000000008'),
('30000000-0000-0000-0000-000000000017', 'Aval_Etica_HUS_NIRS_Madre_Canguro_CIM_017.pdf', 'application/pdf', 378900, 'Consentimiento Informado y Anexo Ético', '20000000-0000-0000-0000-000000000003'),
('30000000-0000-0000-0000-000000000018', 'Protocolo_Ecografia_Diafragmatica_IMT_UCI_CIM_018.pdf', 'application/pdf', 351400, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000004'),
('30000000-0000-0000-0000-000000000019', 'Ficha_Tecnica_Nanorecubrimiento_ZnO_Suturas_CIM_019.pdf', 'application/pdf', 387600, 'Aval de Grupo / Sustento Técnico', '20000000-0000-0000-0000-000000000005'),
('30000000-0000-0000-0000-000000000020', 'Aval_Comite_Etica_Farmacogenomica_DPYD_CIM_020.pdf', 'application/pdf', 418500, 'Consentimiento Informado y Anexo Ético', '20000000-0000-0000-0000-000000000006');

-- =============================================================================
-- 5. HISTORIAL DE REVISIONES Y OBSERVACIONES PUNTO A PUNTO (proposal_reviews)
-- =============================================================================

-- Revisión de CIM-2026-003 (SUBSANACION_SOLICITADA por Secretaría Técnica)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES (
    '30000000-0000-0000-0000-000000000003',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'SOLICITAR_MODIFICACIONES',
    'Se solicita a la Investigadora Principal precisar en el numeral 2.3.7 el umbral de lactato capilar para activación del código sepsis obstétrico y detallar en el numeral 5 la contrapartida en especie del hospital aliado.',
    '[
      {"item_code":"2.3.7","item_label":"Procedimientos","observation":"Definir explícitamente el punto de corte de lactato capilar (>= 2.0 mmol/L) que activa el llamado inmediato al médico intensivista.","resolved":false},
      {"item_code":"5","item_label":"Presupuesto","observation":"Desglosar las horas de dedicación del coordinador de enfermería de la entidad aliada en la columna de contrapartida en especie.","resolved":false}
    ]'::jsonb
);

-- Revisión previa de CIM-2026-004 (observaciones de V1 ya atendidas por el investigador en V2 REENVIADO)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES (
    '30000000-0000-0000-0000-000000000004',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'SOLICITAR_MODIFICACIONES',
    'Ajustar el cálculo de tamaño de muestra considerando un 15% de pérdidas en el seguimiento a 24 semanas antes de agendar al Comité Técnico Científico.',
    '[
      {"item_code":"2.3.3","item_label":"Participantes y muestreo","observation":"Incluir el ajuste por pérdidas del 15% en los 64 participantes del ensayo biomecánico.","resolved":true}
    ]'::jsonb
);

-- Revisión de CIM-2026-005 (VISTO_BUENO_CTC otorgado por Secretaría Técnica)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES (
    '30000000-0000-0000-0000-000000000005',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'La propuesta CIM-2026-005 cumple íntegramente los 6 numerales reglamentarios del formato CIM-FT-002-BUC. Se otorga VISTO BUENO de Secretaría Técnica y se agenda para evaluación del próximo Comité Técnico Científico.',
    '[
      {"item_code":"2.3.6","item_label":"Técnicas de recolección de información","observation":"Verificada la curva de calibración del luminómetro de ATP y el protocolo de hisopado de canales.","resolved":true}
    ]'::jsonb
);

-- Revisiones de CIM-2026-006 (EN_PLENO_CTC con Visto Bueno y deliberación plenaria activa)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000006',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Expediente completo con aval ético y soporte presupuestal de ddPCR. Se remite al Pleno del Comité Técnico Científico.',
    '[
      {"item_code":"2.3.3","item_label":"Participantes y muestreo","observation":"Cálculo de potencia estadística y cronograma de tomas seriadas verificados.","resolved":true}
    ]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000006',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'PLENO_CTC',
    'FAVORABLE',
    'El pleno del Comité Técnico Científico emite concepto FAVORABLE y habilita los tokens criptográficos de una sola utilización para la firma de los tres miembros del comité.',
    '[]'::jsonb
);

-- Revisiones de CIM-2026-007 (FAVORABLE_CON_OBSERVACIONES en Pleno CTC)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000007',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Se otorga Visto Bueno de Secretaría Técnica para presentación en sesión plenaria del CTC.',
    '[]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000007',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Pleno Comité Técnico Científico MASIRA',
    'PLENO_CTC',
    'FAVORABLE_CON_OBSERVACIONES',
    'El Pleno del CTC otorga concepto FAVORABLE CON OBSERVACIONES. El reporte PDF se expide sin las firmas definitivas de los miembros del comité hasta que la Investigadora Principal incorpore las dos aclaraciones metodológicas solicitadas.',
    '[
      {"item_code":"2.3.4","item_label":"Criterios de elegibilidad","observation":"Precisar el puntaje máximo en la escala NIHSS al ingreso y el protocolo de remisión urgente ante deterioro neurológico.","resolved":false},
      {"item_code":"2.3.9","item_label":"Consideraciones éticas","observation":"Explicitar el mecanismo de entrega del aplicativo al grupo control al finalizar la semana 24.","resolved":false}
    ]'::jsonb
);

-- Revisiones de CIM-2026-008 (FAVORABLE definitivo en Pleno CTC)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000008',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Revisión de Secretaría Técnica satisfactoria. Se agenda al Pleno del CTC.',
    '[]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000008',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Pleno Comité Técnico Científico MASIRA',
    'PLENO_CTC',
    'FAVORABLE',
    'Aprobado por unanimidad en sesión plenaria por su alta pertinencia en salud pública regional y solidez metodológica. Los tres miembros del Comité Técnico Científico han firmado con sus tokens de un solo uso.',
    '[
      {"item_code":"3","item_label":"Posibles Alianzas y Trabajos en Red","observation":"Articulación con el Laboratorio Departamental de Salud Pública verificada y avalada.","resolved":true}
    ]'::jsonb
);

-- Revisiones de CIM-2026-010 (RECHAZADO en Pleno CTC por requisitos regulatorios y de bioseguridad clínica)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000010',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Cumple requisitos documentales de forma para análisis técnico profundo por el Pleno del Comité Técnico Científico.',
    '[]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000010',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Pleno Comité Técnico Científico MASIRA',
    'PLENO_CTC',
    'RECHAZADO',
    'El Pleno del Comité Técnico Científico emite concepto RECHAZADO (No Favorable). El protocolo propone la administración intranasal directa en pacientes de lisados fágicos ambientales sin fase preclínica que certifique ausencia de genes de lisogenia/toxinas ni remoción validada de lipopolisacáridos (endotoxinas), además de carecer de autorización regulatoria del INVIMA y póliza de ensayo clínico.',
    '[
      {"item_code":"2.3.1","item_label":"Diseño del estudio","observation":"No es viable iniciar un ensayo clínico en humanos sin una fase preclínica in vitro e in vivo que certifique la seguridad, pureza y estabilidad del preparado de bacteriófagos.","resolved":false},
      {"item_code":"2.3.7","item_label":"Procedimientos","observation":"La filtración simple por 0.22 micras no elimina endotoxinas bacterianas (LPS), lo que representa un riesgo severo de reacción inflamatoria mucosa.","resolved":false},
      {"item_code":"2.3.9","item_label":"Consideraciones éticas","observation":"Requiere aprobación previa de la Sala Especializada del INVIMA para investigación clínica con biológicos y póliza de responsabilidad civil para ensayos clínicos.","resolved":false}
    ]'::jsonb
);

-- Revisión de CIM-2026-014 (SUBSANACION_SOLICITADA por Secretaría Técnica)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES (
    '30000000-0000-0000-0000-000000000014',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'SOLICITAR_MODIFICACIONES',
    'Se solicita al Investigador Principal detallar en el numeral 2.3.7 el control exógeno de normalización para RT-qPCR de microARNs exosomales y adjuntar el desglose de columnas SEC en el numeral 5.',
    '[
      {"item_code":"2.3.7","item_label":"Procedimientos","observation":"Especificar la concentración molar del control sintético cel-miR-39 añadido antes de la extracción de ARN exosomal.","resolved":false},
      {"item_code":"5","item_label":"Presupuesto","observation":"Separar en el rubro de Materiales e Insumos el costo unitario de las columnas de cromatografía de exclusión por tamaño (SEC).","resolved":false}
    ]'::jsonb
);

-- Revisión previa de CIM-2026-015 (observaciones de V1 ya atendidas por la investigadora en V2 REENVIADO)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES (
    '30000000-0000-0000-0000-000000000015',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'SOLICITAR_MODIFICACIONES',
    'Precisar el tamaño de la submuestra que será sometida a evaluación fibroendoscópica de la deglución (FEES) como estándar de referencia.',
    '[
      {"item_code":"2.3.3","item_label":"Participantes y muestreo","observation":"Definir explícitamente que 70 de los 210 participantes contarán con confirmación por nasofibrolaringoscopia FEES.","resolved":true}
    ]'::jsonb
);

-- Revisión de CIM-2026-016 (VISTO_BUENO_CTC otorgado por Secretaría Técnica)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES (
    '30000000-0000-0000-0000-000000000016',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'El protocolo One Health CIM-2026-016 cuenta con aval ético humano y certificado CICUAL-UDES. Se otorga VISTO BUENO de Secretaría Técnica y se agenda a sesión plenaria del CTC.',
    '[
      {"item_code":"2.3.9","item_label":"Consideraciones éticas","observation":"Verificado el aval CICUAL-UDES para toma de muestras en caninos y captura de sinantrópicos.","resolved":true}
    ]'::jsonb
);

-- Revisiones de CIM-2026-017 (EN_PLENO_CTC con Visto Bueno y deliberación plenaria activa)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000017',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Documentación completa y aval de la Unidad Neonatal del HUS verificado. Pasa a Pleno del CTC.',
    '[]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000017',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Pleno Comité Técnico Científico MASIRA',
    'PLENO_CTC',
    'FAVORABLE',
    'El Pleno del CTC emite concepto FAVORABLE para el estudio NIRS en método madre canguro y genera los tokens de firma única.',
    '[]'::jsonb
);

-- Revisiones de CIM-2026-018 (FAVORABLE_CON_OBSERVACIONES en Pleno CTC)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000018',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Cumple requisitos formales del formato CIM-FT-002-BUC. Se remite a evaluación del Pleno del CTC.',
    '[]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000018',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Pleno Comité Técnico Científico MASIRA',
    'PLENO_CTC',
    'FAVORABLE_CON_OBSERVACIONES',
    'El Pleno del CTC otorga concepto FAVORABLE CON OBSERVACIONES. El reporte se mantiene sin firmas definitivas hasta que el investigador incorpore la dosis máxima permitida de norepinefrina en los criterios de elegibilidad.',
    '[
      {"item_code":"2.3.4","item_label":"Criterios de elegibilidad","observation":"Definir la dosis umbral de soporte vasopresor (< 0.1 mcg/kg/min de norepinefrina) para autorizar el inicio de cada sesión de entrenamiento inspiratorio en UCI.","resolved":false}
    ]'::jsonb
);

-- Revisiones de CIM-2026-019 (FAVORABLE definitivo en Pleno CTC)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000019',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Verificación técnica completa. Se agenda a sesión plenaria del CTC.',
    '[]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000019',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Pleno Comité Técnico Científico MASIRA',
    'PLENO_CTC',
    'FAVORABLE',
    'Concepto FAVORABLE unánime del Pleno del CTC con las tres firmas criptográficas completadas. Destacado potencial de patente en biomateriales quirúrgicos.',
    '[]'::jsonb
);

-- Revisiones de CIM-2026-020 (FAVORABLE definitivo en Pleno CTC)
INSERT INTO proposal_reviews (
    proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations
) VALUES
(
    '30000000-0000-0000-0000-000000000020',
    1,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'SECRETARIA_TECNICA',
    'VISTO_BUENO_CTC',
    'Revisión documental y presupuestal satisfactoria. Se remite al Pleno del CTC.',
    '[]'::jsonb
),
(
    '30000000-0000-0000-0000-000000000020',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Pleno Comité Técnico Científico MASIRA',
    'PLENO_CTC',
    'FAVORABLE',
    'Aprobado por unanimidad en el Pleno del CTC con las tres firmas verificadas. Alto impacto clínico en seguridad farmacológica oncológica.',
    '[]'::jsonb
);

-- =============================================================================
-- 6. TOKENS DE UNA SOLA UTILIZACIÓN PARA FIRMA DE LOS 3 MIEMBROS DEL CTC
-- =============================================================================

-- Tokens para CIM-2026-006 (EN_PLENO_CTC: 1 firmado por Secretaría, 2 disponibles para firma en vivo)
INSERT INTO ctc_signature_tokens (
    proposal_id, revision_number, member_id, member_name, member_email, member_position,
    single_use_token, is_used, used_at, vote_decision, signature_hash
) VALUES
(
    '30000000-0000-0000-0000-000000000006',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes',
    'secretario.ctc@udes.edu.co',
    'Secretaria del Comité Técnico Científico MASIRA',
    'CTC-SIG-006MABEL01',
    TRUE,
    NOW() - INTERVAL '2 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000006:10000000-0000-0000-0000-000000000001:CTC-SIG-006MABEL01', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000006',
    2,
    '10000000-0000-0000-0000-000000000002',
    'Dr. Patricio López Jaramillo',
    'patricio.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director Científico MASIRA',
    'CTC-SIG-006PATRIC2',
    FALSE,
    NULL,
    'APROBADO',
    NULL
),
(
    '30000000-0000-0000-0000-000000000006',
    2,
    '10000000-0000-0000-0000-000000000003',
    'Dr. José Patricio López López',
    'jose.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director de Proyectos MASIRA',
    'CTC-SIG-006JOSELO3',
    FALSE,
    NULL,
    'APROBADO',
    NULL
);

-- Tokens para CIM-2026-007 (FAVORABLE_CON_OBSERVACIONES: emitidos y pendientes de subsanación)
INSERT INTO ctc_signature_tokens (
    proposal_id, revision_number, member_id, member_name, member_email, member_position,
    single_use_token, is_used, used_at, vote_decision, signature_hash
) VALUES
(
    '30000000-0000-0000-0000-000000000007',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes',
    'secretario.ctc@udes.edu.co',
    'Secretaria del Comité Técnico Científico MASIRA',
    'CTC-SIG-007MABEL01',
    FALSE,
    NULL,
    'APROBADO',
    NULL
),
(
    '30000000-0000-0000-0000-000000000007',
    2,
    '10000000-0000-0000-0000-000000000002',
    'Dr. Patricio López Jaramillo',
    'patricio.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director Científico MASIRA',
    'CTC-SIG-007PATRIC2',
    FALSE,
    NULL,
    'APROBADO',
    NULL
),
(
    '30000000-0000-0000-0000-000000000007',
    2,
    '10000000-0000-0000-0000-000000000003',
    'Dr. José Patricio López López',
    'jose.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director de Proyectos MASIRA',
    'CTC-SIG-007JOSELO3',
    FALSE,
    NULL,
    'APROBADO',
    NULL
);

-- Tokens para CIM-2026-008 (FAVORABLE: los 3 miembros del CTC ya consumieron su token único)
INSERT INTO ctc_signature_tokens (
    proposal_id, revision_number, member_id, member_name, member_email, member_position,
    single_use_token, is_used, used_at, vote_decision, signature_hash
) VALUES
(
    '30000000-0000-0000-0000-000000000008',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes',
    'secretario.ctc@udes.edu.co',
    'Secretaria del Comité Técnico Científico MASIRA',
    'CTC-SIG-008MABEL01',
    TRUE,
    NOW() - INTERVAL '5 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000008:10000000-0000-0000-0000-000000000001:CTC-SIG-008MABEL01', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000008',
    2,
    '10000000-0000-0000-0000-000000000002',
    'Dr. Patricio López Jaramillo',
    'patricio.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director Científico MASIRA',
    'CTC-SIG-008PATRIC2',
    TRUE,
    NOW() - INTERVAL '5 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000008:10000000-0000-0000-0000-000000000002:CTC-SIG-008PATRIC2', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000008',
    2,
    '10000000-0000-0000-0000-000000000003',
    'Dr. José Patricio López López',
    'jose.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director de Proyectos MASIRA',
    'CTC-SIG-008JOSELO3',
    TRUE,
    NOW() - INTERVAL '4 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000008:10000000-0000-0000-0000-000000000003:CTC-SIG-008JOSELO3', 'sha256'), 'hex')
);

-- Tokens para CIM-2026-017 (EN_PLENO_CTC: 2 firmados, 1 pendiente de firma)
INSERT INTO ctc_signature_tokens (
    proposal_id, revision_number, member_id, member_name, member_email, member_position,
    single_use_token, is_used, used_at, vote_decision, signature_hash
) VALUES
(
    '30000000-0000-0000-0000-000000000017',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes',
    'secretario.ctc@udes.edu.co',
    'Secretaria del Comité Técnico Científico MASIRA',
    'CTC-SIG-017MABEL01',
    TRUE,
    NOW() - INTERVAL '1 day',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000017:10000000-0000-0000-0000-000000000001:CTC-SIG-017MABEL01', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000017',
    2,
    '10000000-0000-0000-0000-000000000002',
    'Dr. Patricio López Jaramillo',
    'patricio.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director Científico MASIRA',
    'CTC-SIG-017PATRIC2',
    TRUE,
    NOW() - INTERVAL '1 day',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000017:10000000-0000-0000-0000-000000000002:CTC-SIG-017PATRIC2', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000017',
    2,
    '10000000-0000-0000-0000-000000000003',
    'Dr. José Patricio López López',
    'jose.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director de Proyectos MASIRA',
    'CTC-SIG-017JOSELO3',
    FALSE,
    NULL,
    'APROBADO',
    NULL
);

-- Tokens para CIM-2026-018 (FAVORABLE_CON_OBSERVACIONES: emitidos y pendientes de subsanación)
INSERT INTO ctc_signature_tokens (
    proposal_id, revision_number, member_id, member_name, member_email, member_position,
    single_use_token, is_used, used_at, vote_decision, signature_hash
) VALUES
(
    '30000000-0000-0000-0000-000000000018',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes',
    'secretario.ctc@udes.edu.co',
    'Secretaria del Comité Técnico Científico MASIRA',
    'CTC-SIG-018MABEL01',
    FALSE,
    NULL,
    'APROBADO',
    NULL
),
(
    '30000000-0000-0000-0000-000000000018',
    2,
    '10000000-0000-0000-0000-000000000002',
    'Dr. Patricio López Jaramillo',
    'patricio.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director Científico MASIRA',
    'CTC-SIG-018PATRIC2',
    FALSE,
    NULL,
    'APROBADO',
    NULL
),
(
    '30000000-0000-0000-0000-000000000018',
    2,
    '10000000-0000-0000-0000-000000000003',
    'Dr. José Patricio López López',
    'jose.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director de Proyectos MASIRA',
    'CTC-SIG-018JOSELO3',
    FALSE,
    NULL,
    'APROBADO',
    NULL
);

-- Tokens para CIM-2026-019 (FAVORABLE: los 3 miembros del CTC ya consumieron su token único)
INSERT INTO ctc_signature_tokens (
    proposal_id, revision_number, member_id, member_name, member_email, member_position,
    single_use_token, is_used, used_at, vote_decision, signature_hash
) VALUES
(
    '30000000-0000-0000-0000-000000000019',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes',
    'secretario.ctc@udes.edu.co',
    'Secretaria del Comité Técnico Científico MASIRA',
    'CTC-SIG-019MABEL01',
    TRUE,
    NOW() - INTERVAL '4 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000019:10000000-0000-0000-0000-000000000001:CTC-SIG-019MABEL01', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000019',
    2,
    '10000000-0000-0000-0000-000000000002',
    'Dr. Patricio López Jaramillo',
    'patricio.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director Científico MASIRA',
    'CTC-SIG-019PATRIC2',
    TRUE,
    NOW() - INTERVAL '4 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000019:10000000-0000-0000-0000-000000000002:CTC-SIG-019PATRIC2', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000019',
    2,
    '10000000-0000-0000-0000-000000000003',
    'Dr. José Patricio López López',
    'jose.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director de Proyectos MASIRA',
    'CTC-SIG-019JOSELO3',
    TRUE,
    NOW() - INTERVAL '3 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000019:10000000-0000-0000-0000-000000000003:CTC-SIG-019JOSELO3', 'sha256'), 'hex')
);

-- Tokens para CIM-2026-020 (FAVORABLE: los 3 miembros del CTC ya consumieron su token único)
INSERT INTO ctc_signature_tokens (
    proposal_id, revision_number, member_id, member_name, member_email, member_position,
    single_use_token, is_used, used_at, vote_decision, signature_hash
) VALUES
(
    '30000000-0000-0000-0000-000000000020',
    2,
    '10000000-0000-0000-0000-000000000001',
    'Dra. Mabel Margoth Reyes',
    'secretario.ctc@udes.edu.co',
    'Secretaria del Comité Técnico Científico MASIRA',
    'CTC-SIG-020MABEL01',
    TRUE,
    NOW() - INTERVAL '5 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000020:10000000-0000-0000-0000-000000000001:CTC-SIG-020MABEL01', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000020',
    2,
    '10000000-0000-0000-0000-000000000002',
    'Dr. Patricio López Jaramillo',
    'patricio.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director Científico MASIRA',
    'CTC-SIG-020PATRIC2',
    TRUE,
    NOW() - INTERVAL '5 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000020:10000000-0000-0000-0000-000000000002:CTC-SIG-020PATRIC2', 'sha256'), 'hex')
),
(
    '30000000-0000-0000-0000-000000000020',
    2,
    '10000000-0000-0000-0000-000000000003',
    'Dr. José Patricio López López',
    'jose.lopez@udes.edu.co',
    'Miembro del Comité Técnico Científico — Director de Proyectos MASIRA',
    'CTC-SIG-020JOSELO3',
    TRUE,
    NOW() - INTERVAL '4 days',
    'APROBADO',
    encode(digest('30000000-0000-0000-0000-000000000020:10000000-0000-0000-0000-000000000003:CTC-SIG-020JOSELO3', 'sha256'), 'hex')
);

-- =============================================================================
-- 7. BANDEJA DE NOTIFICACIONES POR CORREO ELECTRÓNICO (email_outbox)
-- =============================================================================

INSERT INTO email_outbox (
    recipient_email, recipient_name, subject, body_text, action_link, related_proposal_code, email_category
) VALUES
(
    'secretario.ctc@udes.edu.co',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'Nuevo Sometimiento Inicial Radicado: CIM-2026-002',
    'La investigadora principal Dra. Natalia Sofía Serrano Rojas ha radicado la propuesta CIM-2026-002 sobre vigilancia genómica de Klebsiella pneumoniae para revisión de Secretaría Técnica.',
    '/proyectos/30000000-0000-0000-0000-000000000002',
    'CIM-2026-002',
    'SOMETIMIENTO_INICIAL'
),
(
    'laura.mantilla@udes.edu.co',
    'Dra. Laura Juliana Mantilla Pinzón',
    'Solicitud de Modificaciones / Revisión — Propuesta CIM-2026-003',
    'La Secretaría del Comité Técnico Científico ha revisado su envío CIM-2026-003 y solicita precisiones en los numerales 2.3.7 (Procedimientos) y 5 (Presupuesto).',
    '/proyectos/30000000-0000-0000-0000-000000000003',
    'CIM-2026-003',
    'SOLICITUD_SUBSANACION'
),
(
    'secretario.ctc@udes.edu.co',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'Reenvío de Propuesta Subsanada CIM-2026-004 (Versión V2)',
    'El investigador principal Dr. Andrés Felipe Villamizar Ortiz ha atendido las observaciones de Secretaría y reenviado el proyecto CIM-2026-004 en su versión V2.',
    '/proyectos/30000000-0000-0000-0000-000000000004',
    'CIM-2026-004',
    'REENVIO_SUBSANACION'
),
(
    'claudia.jaimes@udes.edu.co',
    'Dra. Claudia Patricia Jaimes Calderón',
    'Visto Bueno Secretaría Técnica — Propuesta CIM-2026-005 agendada al próximo CTC',
    'La Secretaría del Comité Técnico Científico ha otorgado el VISTO BUENO a la propuesta CIM-2026-005 y la ha agendado para la sesión del próximo Comité Técnico Científico.',
    '/proyectos/30000000-0000-0000-0000-000000000005',
    'CIM-2026-005',
    'VISTO_BUENO_SECRETARIA'
),
(
    'patricio.lopez@udes.edu.co',
    'Dr. Patricio López Jaramillo (Miembro CTC)',
    'Token de Una Sola Utilización [CTC-SIG-006PATRIC2] para Firma de Concepto en Pleno CTC — CIM-2026-006',
    'Se ha emitido su token criptográfico de un solo uso [CTC-SIG-006PATRIC2] para registrar su firma de aprobación sobre el concepto de la propuesta CIM-2026-006.',
    'CTC-SIG-006PATRIC2',
    'CIM-2026-006',
    'TOKEN_FIRMA_CTC'
),
(
    'jose.lopez@udes.edu.co',
    'Dr. José Patricio López López (Miembro CTC)',
    'Token de Una Sola Utilización [CTC-SIG-006JOSELO3] para Firma de Concepto en Pleno CTC — CIM-2026-006',
    'Se ha emitido su token criptográfico de un solo uso [CTC-SIG-006JOSELO3] para registrar su firma de aprobación sobre el concepto de la propuesta CIM-2026-006.',
    'CTC-SIG-006JOSELO3',
    'CIM-2026-006',
    'TOKEN_FIRMA_CTC'
),
(
    'diana.duarte@udes.edu.co',
    'Dra. Diana Carolina Duarte Meneses',
    'Concepto del Comité Técnico Científico MASIRA: FAVORABLE_CON_OBSERVACIONES (CIM-2026-007)',
    'El pleno del Comité Técnico Científico ha emitido concepto FAVORABLE CON OBSERVACIONES para la propuesta CIM-2026-007. El reporte se genera sin firmas definitivas hasta subsanar los numerales 2.3.4 y 2.3.9.',
    '/proyectos/30000000-0000-0000-0000-000000000007',
    'CIM-2026-007',
    'CONCEPTO_PLENO_CTC'
),
(
    'jorge.castellanos@udes.edu.co',
    'Dr. Jorge Enrique Castellanos Rueda',
    'Concepto Definitivo FAVORABLE con Firmas Completas del CTC (CIM-2026-008)',
    'El pleno del Comité Técnico Científico ha emitido concepto FAVORABLE para la propuesta CIM-2026-008 con las tres firmas verificadas de los miembros del comité.',
    '/proyectos/30000000-0000-0000-0000-000000000008',
    'CIM-2026-008',
    'CONCEPTO_PLENO_CTC'
),
(
    'carlos.gomez@udes.edu.co',
    'Carlos Andrés Gómez Sarmiento',
    'Propuesta CIM-2026-009 en Revisión Formal por Secretaría Técnica del CTC',
    'La Secretaría Técnica del Comité Técnico Científico ha iniciado la verificación punto a punto de los 6 numerales reglamentarios de su propuesta CIM-2026-009.',
    '/proyectos/30000000-0000-0000-0000-000000000009',
    'CIM-2026-009',
    'REVISION_SECRETARIA'
),
(
    'natalia.serrano@udes.edu.co',
    'Natalia Sofía Serrano Rojas',
    'Concepto del Comité Técnico Científico MASIRA: RECHAZADO (CIM-2026-010)',
    'El pleno del Comité Técnico Científico ha emitido concepto RECHAZADO (No Favorable) para la propuesta CIM-2026-010 debido a requerimientos preclínicos de bioseguridad y regulación INVIMA.',
    '/proyectos/30000000-0000-0000-0000-000000000010',
    'CIM-2026-010',
    'CONCEPTO_PLENO_CTC'
),
(
    'secretario.ctc@udes.edu.co',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'Nuevo Sometimiento Inicial Radicado: CIM-2026-012',
    'El investigador principal Dr. Andrés Felipe Villamizar Ortiz ha radicado la propuesta CIM-2026-012 sobre entrenamiento de marcha con realidad virtual en enfermedad de Parkinson.',
    '/proyectos/30000000-0000-0000-0000-000000000012',
    'CIM-2026-012',
    'SOMETIMIENTO_INICIAL'
),
(
    'claudia.jaimes@udes.edu.co',
    'Claudia Patricia Jaimes Calderón',
    'Propuesta CIM-2026-013 en Revisión Formal por Secretaría Técnica del CTC',
    'La Secretaría Técnica del Comité Técnico Científico se encuentra verificando los 6 numerales reglamentarios de su propuesta CIM-2026-013 sobre trazabilidad quirúrgica RFID.',
    '/proyectos/30000000-0000-0000-0000-000000000013',
    'CIM-2026-013',
    'REVISION_SECRETARIA'
),
(
    'mauricio.pineda@udes.edu.co',
    'Mauricio Alejandro Pineda Vargas',
    'Solicitud de Modificaciones / Revisión — Propuesta CIM-2026-014',
    'La Secretaría del Comité Técnico Científico ha revisado su envío CIM-2026-014 y solicita precisiones en los numerales 2.3.7 (Procedimientos) y 5 (Presupuesto).',
    '/proyectos/30000000-0000-0000-0000-000000000014',
    'CIM-2026-014',
    'SOLICITUD_SUBSANACION'
),
(
    'secretario.ctc@udes.edu.co',
    'Dra. Mabel Margoth Reyes (Secretaria CTC)',
    'Reenvío de Propuesta Subsanada CIM-2026-015 (Versión V2)',
    'La investigadora principal Diana Carolina Duarte Meneses ha atendido las observaciones de Secretaría y reenviado el proyecto CIM-2026-015 en su versión V2.',
    '/proyectos/30000000-0000-0000-0000-000000000015',
    'CIM-2026-015',
    'REENVIO_SUBSANACION'
),
(
    'jorge.castellanos@udes.edu.co',
    'Jorge Enrique Castellanos Rueda',
    'Visto Bueno Secretaría Técnica — Propuesta CIM-2026-016 agendada al próximo CTC',
    'La Secretaría del Comité Técnico Científico ha otorgado el VISTO BUENO a la propuesta One Health CIM-2026-016 y la ha agendado para la próxima sesión plenaria.',
    '/proyectos/30000000-0000-0000-0000-000000000016',
    'CIM-2026-016',
    'VISTO_BUENO_SECRETARIA'
),
(
    'jose.lopez@udes.edu.co',
    'Dr. José Patricio López López (Miembro CTC)',
    'Token de Una Sola Utilización [CTC-SIG-017JOSELO3] para Firma de Concepto en Pleno CTC — CIM-2026-017',
    'Se ha emitido su token criptográfico de un solo uso [CTC-SIG-017JOSELO3] para registrar su firma de aprobación sobre el concepto de la propuesta CIM-2026-017.',
    'CTC-SIG-017JOSELO3',
    'CIM-2026-017',
    'TOKEN_FIRMA_CTC'
),
(
    'andres.villamizar@udes.edu.co',
    'Dr. Andrés Felipe Villamizar Ortiz',
    'Concepto del Comité Técnico Científico MASIRA: FAVORABLE_CON_OBSERVACIONES (CIM-2026-018)',
    'El pleno del Comité Técnico Científico ha emitido concepto FAVORABLE CON OBSERVACIONES para la propuesta CIM-2026-018. El reporte se genera sin firmas definitivas hasta subsanar el numeral 2.3.4.',
    '/proyectos/30000000-0000-0000-0000-000000000018',
    'CIM-2026-018',
    'CONCEPTO_PLENO_CTC'
),
(
    'claudia.jaimes@udes.edu.co',
    'Claudia Patricia Jaimes Calderón',
    'Concepto Definitivo FAVORABLE con Firmas Completas del CTC (CIM-2026-019)',
    'El pleno del Comité Técnico Científico ha emitido concepto FAVORABLE para la propuesta CIM-2026-019 con las tres firmas verificadas de los miembros del comité.',
    '/proyectos/30000000-0000-0000-0000-000000000019',
    'CIM-2026-019',
    'CONCEPTO_PLENO_CTC'
),
(
    'mauricio.pineda@udes.edu.co',
    'Mauricio Alejandro Pineda Vargas',
    'Concepto Definitivo FAVORABLE con Firmas Completas del CTC (CIM-2026-020)',
    'El pleno del Comité Técnico Científico ha emitido concepto FAVORABLE para la propuesta CIM-2026-020 con las tres firmas verificadas de los miembros del comité.',
    '/proyectos/30000000-0000-0000-0000-000000000020',
    'CIM-2026-020',
    'CONCEPTO_PLENO_CTC'
);

COMMIT;
