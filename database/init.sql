-- =============================================================================
-- INSTITUTO DE INVESTIGACIÓN MASIRA - UNIVERSIDAD DE SANTANDER (UDES)
-- Esquema de Base de Datos PostgreSQL para Plataforma CTC (CIM-FT-002-BUC V00)
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Tabla de Usuarios y Roles (JWT + OAuth2 Password Setup Flow)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('INVESTIGADOR', 'SECRETARIO_CTC', 'MIEMBRO_CTC', 'ADMIN')),
    academic_unit VARCHAR(255) DEFAULT '',
    research_group VARCHAR(255) DEFAULT '',
    password_hash TEXT,
    password_setup_token VARCHAR(128) UNIQUE,
    password_setup_expires_at TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Tabla de Propuestas de Investigación (Plantilla CIM-FT-002-BUC_SOMETIMIENTO INICIAL_V00)
CREATE TABLE IF NOT EXISTS proposals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(64) UNIQUE NOT NULL,
    investigator_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(64) NOT NULL DEFAULT 'BORRADOR' CHECK (status IN (
        'BORRADOR',
        'SOMETIDO',
        'EN_REVISION_SECRETARIA',
        'SUBSANACION_SOLICITADA',
        'REENVIADO',
        'VISTO_BUENO_CTC',
        'EN_PLENO_CTC',
        'FAVORABLE',
        'FAVORABLE_CON_OBSERVACIONES',
        'RECHAZADO'
    )),
    revision_count INTEGER NOT NULL DEFAULT 1,
    -- 1.1 Información General
    title TEXT NOT NULL,
    academic_program TEXT NOT NULL DEFAULT '',
    campus TEXT NOT NULL DEFAULT '',
    backing_group TEXT NOT NULL DEFAULT '',
    group_leader TEXT NOT NULL DEFAULT '',
    research_line TEXT NOT NULL DEFAULT '',
    principal_investigator_name TEXT NOT NULL DEFAULT '',
    principal_investigator_email TEXT NOT NULL DEFAULT '',
    allied_entity_name TEXT NOT NULL DEFAULT '',
    development_location TEXT NOT NULL DEFAULT '',
    call_name TEXT NOT NULL DEFAULT '',
    call_type TEXT NOT NULL DEFAULT '',
    call_deadline DATE,
    -- 1.2 Equipo de Trabajo (JSONB Array: [{nombre, rol, entidad, responsabilidades}])
    work_team JSONB NOT NULL DEFAULT '[]'::jsonb,
    -- 2. Resumen Ejecutivo
    problem_and_justification TEXT NOT NULL DEFAULT '',
    general_objective TEXT NOT NULL DEFAULT '',
    specific_objectives TEXT NOT NULL DEFAULT '',
    -- 2.3 Metodología (2.3.1 a 2.3.9)
    methodology_design TEXT NOT NULL DEFAULT '',
    study_setting TEXT NOT NULL DEFAULT '',
    participants_and_sampling TEXT NOT NULL DEFAULT '',
    eligibility_criteria TEXT NOT NULL DEFAULT '',
    recruitment_plan TEXT NOT NULL DEFAULT '',
    data_collection_techniques TEXT NOT NULL DEFAULT '',
    procedures_description TEXT NOT NULL DEFAULT '',
    data_analysis_plan TEXT NOT NULL DEFAULT '',
    ethical_considerations TEXT NOT NULL DEFAULT '',
    -- 2.4 Resultados y Productos Esperados
    expected_results TEXT NOT NULL DEFAULT '',
    -- 3. Posibles Alianzas y Trabajos en Red
    possible_alliances TEXT NOT NULL DEFAULT '',
    -- 4. Análisis de Riesgos de Ejecución (JSONB Array: 6 tipos de riesgo)
    risk_matrix JSONB NOT NULL DEFAULT '[]'::jsonb,
    -- 5. Presupuesto (JSONB Array: 11 rubros reglamentarios)
    budget_items JSONB NOT NULL DEFAULT '[]'::jsonb,
    budget_total BIGINT NOT NULL DEFAULT 0,
    -- 6. Cronograma de Actividades (JSONB Array: objetivos, actividades y trimestres T1..T12)
    schedule_items JSONB NOT NULL DEFAULT '[]'::jsonb,
    -- 7. Apéndices de Versiones Enviadas (JSONB Array: Versión 1, Versión 2, etc.)
    version_history JSONB NOT NULL DEFAULT '[]'::jsonb,
    -- Datos de evaluación en Comité Técnico Científico
    ctc_session_date DATE,
    ctc_concept VARCHAR(64) CHECK (ctc_concept IN ('FAVORABLE', 'FAVORABLE_CON_OBSERVACIONES', 'RECHAZADO')),
    ctc_general_concept_notes TEXT DEFAULT '',
    ctc_modifications_Cleared BOOLEAN NOT NULL DEFAULT FALSE,
    submitted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Tabla de Documentación Adicional Adjunta al Proyecto
CREATE TABLE IF NOT EXISTS proposal_attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id UUID NOT NULL REFERENCES proposals(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(128) NOT NULL DEFAULT 'application/pdf',
    file_size_bytes BIGINT NOT NULL DEFAULT 0,
    category VARCHAR(128) NOT NULL DEFAULT 'Sustento Técnico / Aval',
    content_base64 TEXT,
    uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Tabla de Revisiones y Observaciones Punto a Punto (Secretaría y Pleno CTC)
CREATE TABLE IF NOT EXISTS proposal_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id UUID NOT NULL REFERENCES proposals(id) ON DELETE CASCADE,
    revision_number INTEGER NOT NULL DEFAULT 1,
    reviewer_id UUID REFERENCES users(id) ON DELETE SET NULL,
    reviewer_name VARCHAR(255) NOT NULL,
    stage VARCHAR(64) NOT NULL CHECK (stage IN ('SECRETARIA_TECNICA', 'PLENO_CTC')),
    decision VARCHAR(64) NOT NULL CHECK (decision IN (
        'SOLICITAR_MODIFICACIONES',
        'VISTO_BUENO_CTC',
        'FAVORABLE',
        'FAVORABLE_CON_OBSERVACIONES',
        'RECHAZADO'
    )),
    general_summary TEXT NOT NULL DEFAULT '',
    -- JSONB Array: [{item_code, item_label, observation, resolved}]
    point_observations JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. Tabla de Tokens de Una Sola Utilización para Firma de Miembros del CTC
CREATE TABLE IF NOT EXISTS ctc_signature_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id UUID NOT NULL REFERENCES proposals(id) ON DELETE CASCADE,
    revision_number INTEGER NOT NULL DEFAULT 1,
    member_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    member_name VARCHAR(255) NOT NULL,
    member_email VARCHAR(255) NOT NULL,
    member_Position VARCHAR(255) NOT NULL DEFAULT 'Miembro Comité Técnico Científico',
    single_use_token VARCHAR(128) UNIQUE NOT NULL,
    is_used BOOLEAN NOT NULL DEFAULT FALSE,
    used_at TIMESTAMPTZ,
    vote_decision VARCHAR(64) DEFAULT 'APROBADO',
    signature_hash VARCHAR(128),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. Bandeja de Correo Electrónico del Sistema (Outbox / Auditoría SMTP)
CREATE TABLE IF NOT EXISTS email_outbox (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_email VARCHAR(255) NOT NULL,
    recipient_name VARCHAR(255) NOT NULL,
    subject TEXT NOT NULL,
    body_text TEXT NOT NULL,
    action_link TEXT,
    related_proposal_code VARCHAR(64),
    email_category VARCHAR(64) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_proposals_investigator ON proposals(investigator_id);
CREATE INDEX IF NOT EXISTS idx_proposals_status ON proposals(status);
CREATE INDEX IF NOT EXISTS idx_tokens_proposal ON ctc_signature_tokens(proposal_id);
CREATE INDEX IF NOT EXISTS idx_outbox_recipient ON email_outbox(recipient_email);
