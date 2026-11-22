use crate::{
    auth::{compute_signature_hash, create_jwt, generate_single_use_token, Claims},
    models::*,
    pdf::{generate_ctc_concept_pdf, generate_proposal_pdf},
};
use axum::{
    extract::{Path, State},
    http::{header, StatusCode},
    response::IntoResponse,
    Json,
};
use bcrypt::{hash, verify, DEFAULT_COST};
use chrono::{Duration, NaiveDate, Utc};
use lettre::{
    message::{header::ContentType, Mailbox},
    transport::smtp::authentication::Credentials,
    AsyncSmtpTransport, AsyncTransport, Message, Tokio1Executor,
};
use serde_json::json;
use sqlx::PgPool;
use uuid::Uuid;

pub fn snapshot_from_proposal(p: &Proposal, version_num: i32) -> ProposalVersionSnapshot {
    ProposalVersionSnapshot {
        version_number: version_num,
        version_label: format!("Versión {}", version_num),
        submitted_at: p
            .submitted_at
            .unwrap_or(p.updated_at)
            .format("%Y-%m-%d %H:%M UTC")
            .to_string(),
        title: p.title.clone(),
        academic_program: p.academic_program.clone(),
        campus: p.campus.clone(),
        backing_group: p.backing_group.clone(),
        group_leader: p.group_leader.clone(),
        research_line: p.research_line.clone(),
        principal_investigator_name: p.principal_investigator_name.clone(),
        principal_investigator_email: p.principal_investigator_email.clone(),
        allied_entity_name: p.allied_entity_name.clone(),
        development_location: p.development_location.clone(),
        call_name: p.call_name.clone(),
        call_type: p.call_type.clone(),
        call_deadline: p.call_deadline.map(|d| d.to_string()),
        work_team: p.work_team.0.clone(),
        problem_and_justification: p.problem_and_justification.clone(),
        general_objective: p.general_objective.clone(),
        specific_objectives: p.specific_objectives.clone(),
        methodology_design: p.methodology_design.clone(),
        study_setting: p.study_setting.clone(),
        participants_and_sampling: p.participants_and_sampling.clone(),
        eligibility_criteria: p.eligibility_criteria.clone(),
        recruitment_plan: p.recruitment_plan.clone(),
        data_collection_techniques: p.data_collection_techniques.clone(),
        procedures_description: p.procedures_description.clone(),
        data_analysis_plan: p.data_analysis_plan.clone(),
        ethical_considerations: p.ethical_considerations.clone(),
        expected_results: p.expected_results.clone(),
        possible_alliances: p.possible_alliances.clone(),
        risk_matrix: p.risk_matrix.0.clone(),
        budget_items: p.budget_items.0.clone(),
        budget_total: p.budget_total,
        schedule_items: p.schedule_items.0.clone(),
    }
}

pub fn snapshot_from_payload(
    payload: &UpsertProposalRequest,
    budget_total: i64,
    version_num: i32,
) -> ProposalVersionSnapshot {
    ProposalVersionSnapshot {
        version_number: version_num,
        version_label: format!("Versión {}", version_num),
        submitted_at: Utc::now().format("%Y-%m-%d %H:%M UTC").to_string(),
        title: payload.title.clone(),
        academic_program: payload.academic_program.clone(),
        campus: payload.campus.clone(),
        backing_group: payload.backing_group.clone(),
        group_leader: payload.group_leader.clone(),
        research_line: payload.research_line.clone(),
        principal_investigator_name: payload.principal_investigator_name.clone(),
        principal_investigator_email: payload.principal_investigator_email.clone(),
        allied_entity_name: payload.allied_entity_name.clone(),
        development_location: payload.development_location.clone(),
        call_name: payload.call_name.clone(),
        call_type: payload.call_type.clone(),
        call_deadline: payload.call_deadline.clone(),
        work_team: payload.work_team.clone(),
        problem_and_justification: payload.problem_and_justification.clone(),
        general_objective: payload.general_objective.clone(),
        specific_objectives: payload.specific_objectives.clone(),
        methodology_design: payload.methodology_design.clone(),
        study_setting: payload.study_setting.clone(),
        participants_and_sampling: payload.participants_and_sampling.clone(),
        eligibility_criteria: payload.eligibility_criteria.clone(),
        recruitment_plan: payload.recruitment_plan.clone(),
        data_collection_techniques: payload.data_collection_techniques.clone(),
        procedures_description: payload.procedures_description.clone(),
        data_analysis_plan: payload.data_analysis_plan.clone(),
        ethical_considerations: payload.ethical_considerations.clone(),
        expected_results: payload.expected_results.clone(),
        possible_alliances: payload.possible_alliances.clone(),
        risk_matrix: payload.risk_matrix.clone(),
        budget_items: payload.budget_items.clone(),
        budget_total,
        schedule_items: payload.schedule_items.clone(),
    }
}

pub async fn hydrate_proposal(pool: &PgPool, mut proposal: Proposal) -> ProposalFullDto {
    if proposal.version_history.0.is_empty() && proposal.status != "BORRADOR" {
        let mut fallback = Vec::new();
        for v in 1..=proposal.revision_count {
            fallback.push(snapshot_from_proposal(&proposal, v));
        }
        proposal.version_history = sqlx::types::Json(fallback);
    }
    let attachments = sqlx::query_as::<_, ProposalAttachment>(
        "SELECT * FROM proposal_attachments WHERE proposal_id = $1 ORDER BY created_at DESC",
    )
    .bind(proposal.id)
    .fetch_all(pool)
    .await
    .unwrap_or_default();

    let reviews = sqlx::query_as::<_, ProposalReview>(
        "SELECT * FROM proposal_reviews WHERE proposal_id = $1 ORDER BY created_at DESC",
    )
    .bind(proposal.id)
    .fetch_all(pool)
    .await
    .unwrap_or_default();

    let signature_tokens = sqlx::query_as::<_, CtcSignatureToken>(
        "SELECT * FROM ctc_signature_tokens WHERE proposal_id = $1 ORDER BY created_at ASC",
    )
    .bind(proposal.id)
    .fetch_all(pool)
    .await
    .unwrap_or_default();

    ProposalFullDto {
        proposal,
        attachments,
        reviews,
        signature_tokens,
    }
}

pub async fn send_smtp_email(
    recipient_email: &str,
    recipient_name: &str,
    subject: &str,
    body_text: &str,
    action_link: Option<&str>,
) -> bool {
    let smtp_host = match std::env::var("SMTP_HOST") {
        Ok(h) if !h.trim().is_empty() => h,
        _ => return false,
    };
    let smtp_port: u16 = std::env::var("SMTP_PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(1025);
    let smtp_from = std::env::var("SMTP_FROM")
        .unwrap_or_else(|_| "Comite Tecnico Cientifico MASIRA <no-reply.ctc@udes.edu.co>".to_string());
    let smtp_user = std::env::var("SMTP_USERNAME").unwrap_or_default();
    let smtp_pass = std::env::var("SMTP_PASSWORD").unwrap_or_default();
    let smtp_tls = std::env::var("SMTP_TLS")
        .map(|v| v.eq_ignore_ascii_case("true") || v == "1")
        .unwrap_or(false);
    let public_url = std::env::var("PUBLIC_APP_URL")
        .unwrap_or_else(|_| "http://localhost:4200".to_string());

    let full_body = if let Some(link) = action_link {
        let resolved_url = if link.starts_with('/') {
            format!("{}{}", public_url, link)
        } else {
            format!("{} (Token / Enlace: {})", public_url, link)
        };
        format!(
            "{}\n\nEnlace / Token de acceso en plataforma:\n{}\n\n--\nComité Técnico Científico · Instituto de Investigación MASIRA\nUniversidad de Santander (UDES)",
            body_text, resolved_url
        )
    } else {
        format!(
            "{}\n\n--\nComité Técnico Científico · Instituto de Investigación MASIRA\nUniversidad de Santander (UDES)",
            body_text
        )
    };

    let from_mailbox: Mailbox = match smtp_from.parse() {
        Ok(m) => m,
        Err(_) => "no-reply.ctc@udes.edu.co".parse().unwrap(),
    };
    let to_formatted = format!("{} <{}>", recipient_name, recipient_email);
    let to_mailbox: Mailbox = match to_formatted.parse() {
        Ok(m) => m,
        Err(_) => match recipient_email.parse() {
            Ok(m2) => m2,
            Err(_) => return false,
        },
    };

    let email_msg = match Message::builder()
        .from(from_mailbox)
        .to(to_mailbox)
        .subject(subject)
        .header(ContentType::TEXT_PLAIN)
        .body(full_body)
    {
        Ok(m) => m,
        Err(e) => {
            tracing::warn!("Error construyendo mensaje MIME SMTP: {}", e);
            return false;
        }
    };

    let mailer: AsyncSmtpTransport<Tokio1Executor> = if smtp_tls {
        let mut builder = match AsyncSmtpTransport::<Tokio1Executor>::starttls_relay(&smtp_host) {
            Ok(b) => b.port(smtp_port),
            Err(e) => {
                tracing::warn!("Error configurando relay TLS SMTP {}: {}", smtp_host, e);
                return false;
            }
        };
        if !smtp_user.is_empty() {
            builder = builder.credentials(Credentials::new(smtp_user, smtp_pass));
        }
        builder.build()
    } else {
        let mut builder = AsyncSmtpTransport::<Tokio1Executor>::builder_dangerous(&smtp_host).port(smtp_port);
        if !smtp_user.is_empty() {
            builder = builder.credentials(Credentials::new(smtp_user, smtp_pass));
        }
        builder.build()
    };

    match mailer.send(email_msg).await {
        Ok(_) => {
            tracing::info!("Correo SMTP enviado exitosamente a {} via {}:{}", recipient_email, smtp_host, smtp_port);
            true
        }
        Err(e) => {
            tracing::warn!("No se pudo entregar correo SMTP a {} via {}:{}: {}", recipient_email, smtp_host, smtp_port, e);
            false
        }
    }
}

pub async fn record_email(
    pool: &PgPool,
    recipient_email: &str,
    recipient_name: &str,
    subject: &str,
    body_text: &str,
    action_link: Option<&str>,
    related_proposal_code: Option<&str>,
    email_category: &str,
) {
    // 1. Enviar mensaje real a través del servidor SMTP configurado en .env
    let _sent_smtp = send_smtp_email(
        recipient_email,
        recipient_name,
        subject,
        body_text,
        action_link,
    )
    .await;

    // 2. Registrar trazabilidad en la tabla email_outbox de PostgreSQL
    let _ = sqlx::query(
        r#"
        INSERT INTO email_outbox
        (recipient_email, recipient_name, subject, body_text, action_link, related_proposal_code, email_category)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        "#,
    )
    .bind(recipient_email)
    .bind(recipient_name)
    .bind(subject)
    .bind(body_text)
    .bind(action_link)
    .bind(related_proposal_code)
    .bind(email_category)
    .execute(pool)
    .await;
}

pub async fn login_handler(
    State(pool): State<PgPool>,
    Json(payload): Json<LoginRequest>,
) -> Result<Json<OAuthTokenResponse>, (StatusCode, Json<serde_json::Value>)> {
    let user = sqlx::query_as::<_, User>("SELECT * FROM users WHERE LOWER(email) = LOWER($1)")
        .bind(payload.email.trim())
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
        .ok_or((
            StatusCode::UNAUTHORIZED,
            Json(json!({ "error": "Credenciales inválidas o usuario no registrado en PostgreSQL." })),
        ))?;

    if !user.is_active {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "El usuario aún no ha creado su contraseña desde el enlace enviado al correo electrónico." })),
        ));
    }

    let hash_str = user.password_hash.as_deref().unwrap_or("");
    let valid = verify(&payload.password, hash_str).unwrap_or(false);
    if !valid {
        return Err((
            StatusCode::UNAUTHORIZED,
            Json(json!({ "error": "Contraseña incorrecta." })),
        ));
    }

    let token = create_jwt(user.id, &user.email, &user.full_name, &user.role)
        .map_err(|_| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": "Error al firmar JWT" }))))?;

    Ok(Json(OAuthTokenResponse {
        access_token: token,
        token_type: "Bearer".to_string(),
        expires_in: 43200,
        user,
    }))
}

pub async fn pending_users_handler(
    State(pool): State<PgPool>,
) -> Result<Json<Vec<User>>, (StatusCode, Json<serde_json::Value>)> {
    let users = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE is_active = FALSE AND password_setup_token IS NOT NULL ORDER BY created_at DESC",
    )
    .fetch_all(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;
    Ok(Json(users))
}

pub async fn create_user_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(payload): Json<CreateUserRequest>,
) -> Result<Json<serde_json::Value>, (StatusCode, Json<serde_json::Value>)> {
    if claims.role != "SECRETARIO_CTC" && claims.role != "ADMIN" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Solo el Secretario del Comité Técnico Científico o el Administrador pueden crear usuarios." })),
        ));
    }

    let setup_token = generate_single_use_token("ACTIVATE");
    let expires_at = Utc::now() + Duration::days(3);
    let creator_id = Uuid::parse_str(&claims.sub).ok();

    let created = sqlx::query_as::<_, User>(
        r#"
        INSERT INTO users (email, full_name, role, academic_unit, research_group, password_setup_token, password_setup_expires_at, is_active, created_by)
        VALUES ($1, $2, $3, $4, $5, $6, $7, FALSE, $8)
        RETURNING *
        "#,
    )
    .bind(payload.email.trim())
    .bind(payload.full_name.trim())
    .bind(&payload.role)
    .bind(payload.academic_unit.as_deref().unwrap_or("Facultad de Ciencias Médicas y de la Salud"))
    .bind(payload.research_group.as_deref().unwrap_or("Instituto MASIRA"))
    .bind(&setup_token)
    .bind(expires_at)
    .bind(creator_id)
    .fetch_one(&pool)
    .await
    .map_err(|e| (StatusCode::BAD_REQUEST, Json(json!({ "error": format!("No se pudo crear el usuario en PostgreSQL: {}", e) }))))?;

    let activation_link = format!("/activar-cuenta?token={}", setup_token);
    let email_body = format!(
        "Estimado(a) {}, la Secretaría del Comité Técnico Científico del Instituto MASIRA - UDES ha creado su cuenta con el rol [{}]. Utilice el token [{}] en la pantalla de activación para definir su contraseña personal e ingresar a la plataforma.",
        created.full_name, created.role, setup_token
    );

    record_email(
        &pool,
        &created.email,
        &created.full_name,
        "Activación de cuenta y creación de contraseña - Plataforma CTC Instituto MASIRA UDES",
        &email_body,
        Some(&activation_link),
        None,
        "CREACION_USUARIO",
    )
    .await;

    Ok(Json(json!({
        "user": created,
        "activationLink": activation_link,
        "passwordSetupToken": setup_token,
        "message": format!("Usuario {} guardado en PostgreSQL. Se envió correo con token de creación de contraseña ({}).", created.full_name, setup_token)
    })))
}

pub async fn set_password_handler(
    State(pool): State<PgPool>,
    Json(payload): Json<SetPasswordRequest>,
) -> Result<Json<serde_json::Value>, (StatusCode, Json<serde_json::Value>)> {
    if payload.new_password.trim().len() < 6 {
        return Err((
            StatusCode::BAD_REQUEST,
            Json(json!({ "error": "La contraseña debe tener al menos 6 caracteres." })),
        ));
    }

    let password_hash = hash(payload.new_password.trim(), DEFAULT_COST)
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    let updated = sqlx::query_as::<_, User>(
        r#"
        UPDATE users
        SET password_hash = $1,
            password_setup_token = NULL,
            password_setup_expires_at = NULL,
            is_active = TRUE,
            updated_at = NOW()
        WHERE password_setup_token = $2
          AND (password_setup_expires_at IS NULL OR password_setup_expires_at > NOW())
        RETURNING *
        "#,
    )
    .bind(password_hash)
    .bind(payload.token.trim())
    .fetch_optional(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
    .ok_or((
        StatusCode::BAD_REQUEST,
        Json(json!({ "error": "El enlace/token de creación de contraseña ya fue utilizado, expiró o no existe en PostgreSQL." })),
    ))?;

    Ok(Json(json!({
        "user": updated,
        "message": format!("Contraseña creada y guardada en PostgreSQL para {}. Ahora puede iniciar sesión.", updated.email)
    })))
}

pub async fn list_users_handler(
    State(pool): State<PgPool>,
    claims: Claims,
) -> Result<Json<Vec<User>>, (StatusCode, Json<serde_json::Value>)> {
    if claims.role == "INVESTIGADOR" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Acceso restringido a Secretaría CTC, Comité y Administración." })),
        ));
    }
    let users = sqlx::query_as::<_, User>("SELECT * FROM users ORDER BY created_at DESC")
        .fetch_all(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;
    Ok(Json(users))
}

pub async fn list_proposals_handler(
    State(pool): State<PgPool>,
    claims: Claims,
) -> Result<Json<Vec<ProposalFullDto>>, (StatusCode, Json<serde_json::Value>)> {
    let user_id = Uuid::parse_str(&claims.sub)
        .map_err(|_| (StatusCode::UNAUTHORIZED, Json(json!({ "error": "ID de usuario inválido" }))))?;

    let proposals = if claims.role == "INVESTIGADOR" {
        sqlx::query_as::<_, Proposal>(
            "SELECT * FROM proposals WHERE investigator_id = $1 OR LOWER(principal_investigator_email) = LOWER($2) ORDER BY updated_at DESC",
        )
        .bind(user_id)
        .bind(&claims.email)
        .fetch_all(&pool)
        .await
    } else {
        sqlx::query_as::<_, Proposal>("SELECT * FROM proposals ORDER BY updated_at DESC")
            .fetch_all(&pool)
            .await
    }
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    let mut full_list = Vec::with_capacity(proposals.len());
    for p in proposals {
        full_list.push(hydrate_proposal(&pool, p).await);
    }

    Ok(Json(full_list))
}

pub async fn create_proposal_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Json(payload): Json<UpsertProposalRequest>,
) -> Result<Json<ProposalFullDto>, (StatusCode, Json<serde_json::Value>)> {
    if claims.role != "INVESTIGADOR" && claims.role != "ADMIN" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Los miembros y el Secretario del Comité Técnico Científico solo evalúan propuestas; la creación de sometimientos iniciales requiere un perfil con rol de Investigador Principal." })),
        ));
    }

    let investigator_id = Uuid::parse_str(&claims.sub)
        .map_err(|_| (StatusCode::UNAUTHORIZED, Json(json!({ "error": "ID inválido" }))))?;

    let count: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM proposals")
        .fetch_one(&pool)
        .await
        .unwrap_or((0,));
    let code = format!("CIM-2026-{:03}", count.0 + 1);

    let budget_total: i64 = payload.budget_items.iter().map(|b| b.total).sum();
    let status = if payload.submit_now { "SOMETIDO" } else { "BORRADOR" };
    let submitted_at = if payload.submit_now { Some(Utc::now()) } else { None };
    let parsed_deadline = payload
        .call_deadline
        .as_deref()
        .and_then(|s| NaiveDate::parse_from_str(s, "%Y-%m-%d").ok());

    let initial_history: Vec<ProposalVersionSnapshot> = if payload.submit_now {
        vec![snapshot_from_payload(&payload, budget_total, 1)]
    } else {
        Vec::new()
    };

    let proposal = sqlx::query_as::<_, Proposal>(
        r#"
        INSERT INTO proposals (
            code, investigator_id, status, revision_count,
            title, academic_program, campus, backing_group, group_leader, research_line,
            principal_investigator_name, principal_investigator_email, allied_entity_name,
            development_location, call_name, call_type, call_deadline,
            work_team, problem_and_justification, general_objective, specific_objectives,
            methodology_design, study_setting, participants_and_sampling, eligibility_criteria,
            recruitment_plan, data_collection_techniques, procedures_description, data_analysis_plan,
            ethical_considerations, expected_results, possible_alliances,
            risk_matrix, budget_items, budget_total, schedule_items, version_history, submitted_at
        ) VALUES (
            $1, $2, $3, 1,
            $4, $5, $6, $7, $8, $9,
            $10, $11, $12,
            $13, $14, $15, $16,
            $17, $18, $19, $20,
            $21, $22, $23, $24,
            $25, $26, $27, $28,
            $29, $30, $31,
            $32, $33, $34, $35, $36, $37
        ) RETURNING *
        "#,
    )
    .bind(&code)
    .bind(investigator_id)
    .bind(status)
    .bind(&payload.title)
    .bind(&payload.academic_program)
    .bind(&payload.campus)
    .bind(&payload.backing_group)
    .bind(&payload.group_leader)
    .bind(&payload.research_line)
    .bind(&payload.principal_investigator_name)
    .bind(&payload.principal_investigator_email)
    .bind(&payload.allied_entity_name)
    .bind(&payload.development_location)
    .bind(&payload.call_name)
    .bind(&payload.call_type)
    .bind(parsed_deadline)
    .bind(sqlx::types::Json(&payload.work_team))
    .bind(&payload.problem_and_justification)
    .bind(&payload.general_objective)
    .bind(&payload.specific_objectives)
    .bind(&payload.methodology_design)
    .bind(&payload.study_setting)
    .bind(&payload.participants_and_sampling)
    .bind(&payload.eligibility_criteria)
    .bind(&payload.recruitment_plan)
    .bind(&payload.data_collection_techniques)
    .bind(&payload.procedures_description)
    .bind(&payload.data_analysis_plan)
    .bind(&payload.ethical_considerations)
    .bind(&payload.expected_results)
    .bind(&payload.possible_alliances)
    .bind(sqlx::types::Json(&payload.risk_matrix))
    .bind(sqlx::types::Json(&payload.budget_items))
    .bind(budget_total)
    .bind(sqlx::types::Json(&payload.schedule_items))
    .bind(sqlx::types::Json(&initial_history))
    .bind(submitted_at)
    .fetch_one(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    if payload.submit_now {
        if let Ok(Some((sec_email, sec_name))) = sqlx::query_as::<_, (String, String)>(
            "SELECT email, full_name FROM users WHERE role = 'SECRETARIO_CTC' ORDER BY created_at ASC LIMIT 1",
        )
        .fetch_optional(&pool)
        .await
        {
            record_email(
                &pool,
                &sec_email,
                &sec_name,
                &format!("Nuevo Sometimiento Inicial Radicado: {} - {}", proposal.code, proposal.title),
                &format!(
                    "El investigador principal {} ha sometido la propuesta '{}' ({}) conforme a la plantilla CIM-FT-002-BUC.",
                    proposal.principal_investigator_name, proposal.title, proposal.code
                ),
                Some(&format!("/proyectos/{}", proposal.id)),
                Some(&proposal.code),
                "SOMETIMIENTO_INICIAL",
            )
            .await;
        }
    }

    Ok(Json(hydrate_proposal(&pool, proposal).await))
}

pub async fn update_proposal_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Path(proposal_id): Path<Uuid>,
    Json(payload): Json<UpsertProposalRequest>,
) -> Result<Json<ProposalFullDto>, (StatusCode, Json<serde_json::Value>)> {
    let existing = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
        .ok_or((StatusCode::NOT_FOUND, Json(json!({ "error": "Propuesta no encontrada" }))))?;

    if claims.role == "MIEMBRO_CTC" || claims.role == "SECRETARIO_CTC" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Los miembros y el Secretario del Comité Técnico Científico solo evalúan propuestas y no pueden modificar el formulario de sometimiento inicial." })),
        ));
    }

    let can_investigator_edit = existing.status == "BORRADOR"
        || existing.status == "SUBSANACION_SOLICITADA"
        || (existing.status == "FAVORABLE_CON_OBSERVACIONES" && !existing.ctc_modifications_cleared);
    if !can_investigator_edit {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "El envío ya fue radicado ante el Secretario del CTC y el formulario se encuentra bloqueado. Solo podrá realizar modificaciones y un Nuevo Envío si el Secretario del CTC solicita subsanaciones." })),
        ));
    }

    let budget_total: i64 = payload.budget_items.iter().map(|b| b.total).sum();
    let (new_status, new_revision, ctc_cleared) = if payload.submit_now {
        if existing.status == "SUBSANACION_SOLICITADA" {
            ("REENVIADO".to_string(), existing.revision_count + 1, existing.ctc_modifications_cleared)
        } else if existing.status == "FAVORABLE_CON_OBSERVACIONES" {
            ("FAVORABLE_CON_OBSERVACIONES".to_string(), existing.revision_count + 1, true)
        } else {
            ("SOMETIDO".to_string(), existing.revision_count, existing.ctc_modifications_cleared)
        }
    } else {
        (existing.status.clone(), existing.revision_count, existing.ctc_modifications_cleared)
    };

    let mut updated_history = existing.version_history.0.clone();
    if updated_history.is_empty() && existing.status != "BORRADOR" {
        for v in 1..=existing.revision_count {
            updated_history.push(snapshot_from_proposal(&existing, v));
        }
    }
    if payload.submit_now {
        updated_history.push(snapshot_from_payload(&payload, budget_total, new_revision));
    }

    let parsed_deadline = payload
        .call_deadline
        .as_deref()
        .and_then(|s| NaiveDate::parse_from_str(s, "%Y-%m-%d").ok());

    let updated = sqlx::query_as::<_, Proposal>(
        r#"
        UPDATE proposals SET
            status = $1,
            revision_count = $2,
            title = $3,
            academic_program = $4,
            campus = $5,
            backing_group = $6,
            group_leader = $7,
            research_line = $8,
            principal_investigator_name = $9,
            principal_investigator_email = $10,
            allied_entity_name = $11,
            development_location = $12,
            call_name = $13,
            call_type = $14,
            call_deadline = $15,
            work_team = $16,
            problem_and_justification = $17,
            general_objective = $18,
            specific_objectives = $19,
            methodology_design = $20,
            study_setting = $21,
            participants_and_sampling = $22,
            eligibility_criteria = $23,
            recruitment_plan = $24,
            data_collection_techniques = $25,
            procedures_description = $26,
            data_analysis_plan = $27,
            ethical_considerations = $28,
            expected_results = $29,
            possible_alliances = $30,
            risk_matrix = $31,
            budget_items = $32,
            budget_total = $33,
            schedule_items = $34,
            ctc_modifications_cleared = $35,
            version_history = $36,
            submitted_at = COALESCE(submitted_at, NOW()),
            updated_at = NOW()
        WHERE id = $37
        RETURNING *
        "#,
    )
    .bind(&new_status)
    .bind(new_revision)
    .bind(&payload.title)
    .bind(&payload.academic_program)
    .bind(&payload.campus)
    .bind(&payload.backing_group)
    .bind(&payload.group_leader)
    .bind(&payload.research_line)
    .bind(&payload.principal_investigator_name)
    .bind(&payload.principal_investigator_email)
    .bind(&payload.allied_entity_name)
    .bind(&payload.development_location)
    .bind(&payload.call_name)
    .bind(&payload.call_type)
    .bind(parsed_deadline)
    .bind(sqlx::types::Json(&payload.work_team))
    .bind(&payload.problem_and_justification)
    .bind(&payload.general_objective)
    .bind(&payload.specific_objectives)
    .bind(&payload.methodology_design)
    .bind(&payload.study_setting)
    .bind(&payload.participants_and_sampling)
    .bind(&payload.eligibility_criteria)
    .bind(&payload.recruitment_plan)
    .bind(&payload.data_collection_techniques)
    .bind(&payload.procedures_description)
    .bind(&payload.data_analysis_plan)
    .bind(&payload.ethical_considerations)
    .bind(&payload.expected_results)
    .bind(&payload.possible_alliances)
    .bind(sqlx::types::Json(&payload.risk_matrix))
    .bind(sqlx::types::Json(&payload.budget_items))
    .bind(budget_total)
    .bind(sqlx::types::Json(&payload.schedule_items))
    .bind(ctc_cleared)
    .bind(sqlx::types::Json(&updated_history))
    .bind(proposal_id)
    .fetch_one(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    if payload.submit_now {
        if let Ok(Some((sec_email, sec_name))) = sqlx::query_as::<_, (String, String)>(
            "SELECT email, full_name FROM users WHERE role = 'SECRETARIO_CTC' ORDER BY created_at ASC LIMIT 1",
        )
        .fetch_optional(&pool)
        .await
        {
            record_email(
                &pool,
                &sec_email,
                &sec_name,
                &format!("Reenvío / Actualización de Propuesta {} (Versión V{})", updated.code, updated.revision_count),
                &format!(
                    "El investigador principal {} ha cargado modificaciones y reenviado el proyecto '{}' ({}) en su versión V{}.",
                    updated.principal_investigator_name, updated.title, updated.code, updated.revision_count
                ),
                Some(&format!("/proyectos/{}", updated.id)),
                Some(&updated.code),
                "REENVIO_SUBSANACION",
            )
            .await;
        }
    }

    Ok(Json(hydrate_proposal(&pool, updated).await))
}

pub async fn secretary_review_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Path(proposal_id): Path<Uuid>,
    Json(payload): Json<SecretaryReviewRequest>,
) -> Result<Json<ProposalFullDto>, (StatusCode, Json<serde_json::Value>)> {
    if claims.role != "SECRETARIO_CTC" && claims.role != "ADMIN" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Solo el Secretario del Comité Técnico Científico puede calificar, modificar o registrar observaciones." })),
        ));
    }

    let proposal = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
        .ok_or((StatusCode::NOT_FOUND, Json(json!({ "error": "Propuesta no encontrada" }))))?;

    let new_status = if payload.decision == "VISTO_BUENO_CTC" {
        "VISTO_BUENO_CTC"
    } else {
        "SUBSANACION_SOLICITADA"
    };

    let reviewer_uuid = Uuid::parse_str(&claims.sub).ok();

    let _ = sqlx::query(
        r#"
        INSERT INTO proposal_reviews
        (proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations)
        VALUES ($1, $2, $3, $4, 'SECRETARIA_TECNICA', $5, $6, $7)
        "#,
    )
    .bind(proposal_id)
    .bind(proposal.revision_count)
    .bind(reviewer_uuid)
    .bind(&claims.full_name)
    .bind(&payload.decision)
    .bind(&payload.general_summary)
    .bind(sqlx::types::Json(&payload.point_observations))
    .execute(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    let parsed_session_date = payload
        .ctc_session_date
        .as_deref()
        .and_then(|s| NaiveDate::parse_from_str(s, "%Y-%m-%d").ok());

    let updated = sqlx::query_as::<_, Proposal>(
        r#"
        UPDATE proposals
        SET status = $1,
            ctc_session_date = COALESCE($2, ctc_session_date),
            updated_at = NOW()
        WHERE id = $3
        RETURNING *
        "#,
    )
    .bind(new_status)
    .bind(parsed_session_date)
    .bind(proposal_id)
    .fetch_one(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    if new_status == "VISTO_BUENO_CTC" {
        record_email(
            &pool,
            &updated.principal_investigator_email,
            &updated.principal_investigator_name,
            &format!("Visto Bueno Secretaría Técnica - Propuesta {} agendada al próximo Comité Técnico Científico", updated.code),
            &format!(
                "Estimado(a) {}, el Secretario del Comité Técnico Científico ha otorgado el VISTO BUENO a la propuesta '{}' ({}). Su propuesta será revisada en el próximo Comité Técnico Científico del Instituto MASIRA.",
                updated.principal_investigator_name, updated.title, updated.code
            ),
            Some(&format!("/proyectos/{}", updated.id)),
            Some(&updated.code),
            "VISTO_BUENO_SECRETARIA",
        )
        .await;
    } else {
        record_email(
            &pool,
            &updated.principal_investigator_email,
            &updated.principal_investigator_name,
            &format!("Solicitud de Modificaciones / Revisión - Propuesta {}", updated.code),
            &format!(
                "Estimado(a) {}, la Secretaría del Comité Técnico Científico ha revisado su envío '{}' ({}) y solicita modificaciones/mejoras: {}. Ingrese a la plataforma para realizar los ajustes y reenviar la propuesta.",
                updated.principal_investigator_name, updated.title, updated.code, payload.general_summary
            ),
            Some(&format!("/proyectos/{}", updated.id)),
            Some(&updated.code),
            "SOLICITUD_SUBSANACION",
        )
        .await;
    }

    Ok(Json(hydrate_proposal(&pool, updated).await))
}

pub async fn ctc_plenary_decision_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Path(proposal_id): Path<Uuid>,
    Json(payload): Json<CtcPlenaryDecisionRequest>,
) -> Result<Json<ProposalFullDto>, (StatusCode, Json<serde_json::Value>)> {
    if claims.role != "SECRETARIO_CTC" && claims.role != "ADMIN" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Solo el Secretario del Comité Técnico Científico puede cargar la decisión y observaciones del pleno." })),
        ));
    }

    let proposal = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
        .ok_or((StatusCode::NOT_FOUND, Json(json!({ "error": "Propuesta no encontrada" }))))?;

    let reviewer_uuid = Uuid::parse_str(&claims.sub).ok();
    let _ = sqlx::query(
        r#"
        INSERT INTO proposal_reviews
        (proposal_id, revision_number, reviewer_id, reviewer_name, stage, decision, general_summary, point_observations)
        VALUES ($1, $2, $3, $4, 'PLENO_CTC', $5, $6, $7)
        "#,
    )
    .bind(proposal_id)
    .bind(proposal.revision_count)
    .bind(reviewer_uuid)
    .bind(&claims.full_name)
    .bind(&payload.concept)
    .bind(&payload.general_summary)
    .bind(sqlx::types::Json(&payload.point_observations))
    .execute(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    let cleared = payload.concept == "FAVORABLE";
    let updated = sqlx::query_as::<_, Proposal>(
        r#"
        UPDATE proposals
        SET status = $1,
            ctc_concept = $1,
            ctc_general_concept_notes = $2,
            ctc_modifications_cleared = $3,
            updated_at = NOW()
        WHERE id = $4
        RETURNING *
        "#,
    )
    .bind(&payload.concept)
    .bind(&payload.general_summary)
    .bind(cleared)
    .bind(proposal_id)
    .fetch_one(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    if payload.generate_member_tokens {
        let _ = sqlx::query("DELETE FROM ctc_signature_tokens WHERE proposal_id = $1")
            .bind(proposal_id)
            .execute(&pool)
            .await;

        let members = sqlx::query_as::<_, User>(
            "SELECT * FROM users WHERE role IN ('MIEMBRO_CTC', 'SECRETARIO_CTC') ORDER BY created_at ASC",
        )
        .fetch_all(&pool)
        .await
        .unwrap_or_default();

        for member in members {
            let single_token = generate_single_use_token("CTC-SIG");
            let tok = sqlx::query_as::<_, CtcSignatureToken>(
                r#"
                INSERT INTO ctc_signature_tokens
                (proposal_id, revision_number, member_id, member_name, member_email, member_position, single_use_token)
                VALUES ($1, $2, $3, $4, $5, $6, $7)
                RETURNING *
                "#,
            )
            .bind(proposal_id)
            .bind(updated.revision_count)
            .bind(member.id)
            .bind(&member.full_name)
            .bind(&member.email)
            .bind(member.academic_unit.as_deref().unwrap_or("Miembro Comité Técnico Científico"))
            .bind(&single_token)
            .fetch_one(&pool)
            .await;

            if let Ok(token_row) = tok {
                record_email(
                    &pool,
                    &member.email,
                    &member.full_name,
                    &format!("Token de Una Sola Utilización [{}] para Firma de Concepto CTC - {}", token_row.single_use_token, updated.code),
                    &format!(
                        "Estimado(a) {}, se ha emitido su token criptográfico de un solo uso [{}] para firmar el concepto del proyecto '{}' ({}).",
                        member.full_name, token_row.single_use_token, updated.title, updated.code
                    ),
                    Some(&token_row.single_use_token),
                    Some(&updated.code),
                    "TOKEN_FIRMA_CTC",
                )
                .await;
            }
        }
    }

    record_email(
        &pool,
        &updated.principal_investigator_email,
        &updated.principal_investigator_name,
        &format!("Concepto del Comité Técnico Científico MASIRA: {} ({})", payload.concept, updated.code),
        &format!(
            "El pleno del Comité Técnico Científico ha emitido concepto [{}] para la propuesta '{}' ({}). Síntesis: {}",
            payload.concept, updated.title, updated.code, payload.general_summary
        ),
        Some(&format!("/proyectos/{}", updated.id)),
        Some(&updated.code),
        "CONCEPTO_PLENO_CTC",
    )
    .await;

    Ok(Json(hydrate_proposal(&pool, updated).await))
}

pub async fn sign_with_single_use_token_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Path(proposal_id): Path<Uuid>,
    Json(payload): Json<SignWithTokenRequest>,
) -> Result<Json<ProposalFullDto>, (StatusCode, Json<serde_json::Value>)> {
    if claims.role == "INVESTIGADOR" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Los investigadores principales no tienen acceso al componente de firmado con token del Comité Técnico Científico." })),
        ));
    }

    let token_record = sqlx::query_as::<_, CtcSignatureToken>(
        "SELECT * FROM ctc_signature_tokens WHERE proposal_id = $1 AND UPPER(single_use_token) = UPPER($2)",
    )
    .bind(proposal_id)
    .bind(payload.single_use_token.trim())
    .fetch_optional(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
    .ok_or((
        StatusCode::BAD_REQUEST,
        Json(json!({ "error": "Token de firma no encontrado para esta propuesta en PostgreSQL." })),
    ))?;

    let is_owner = token_record.member_id.to_string() == claims.sub
        || token_record.member_email.eq_ignore_ascii_case(&claims.email);
    if !is_owner {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": format!(
                "Este token pertenece a {} ({}). Cada miembro del Comité Técnico Científico debe iniciar sesión con su propio usuario para firmar con su token.",
                token_record.member_name, token_record.member_email
            ) })),
        ));
    }

    if token_record.is_used {
        return Err((
            StatusCode::CONFLICT,
            Json(json!({ "error": "Este token es de una sola utilización y ya fue consumido anteriormente." })),
        ));
    }

    let sig_hash = compute_signature_hash(proposal_id, token_record.member_id, &token_record.single_use_token);
    let _ = sqlx::query(
        r#"
        UPDATE ctc_signature_tokens
        SET is_used = TRUE,
            used_at = NOW(),
            vote_decision = COALESCE($1, 'APROBADO'),
            signature_hash = $2
        WHERE id = $3
        "#,
    )
    .bind(payload.vote_decision.as_deref())
    .bind(&sig_hash)
    .bind(token_record.id)
    .execute(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    let proposal = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_one(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    Ok(Json(hydrate_proposal(&pool, proposal).await))
}

pub async fn get_proposal_details_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Path(proposal_id): Path<Uuid>,
) -> Result<Json<ProposalFullDto>, (StatusCode, Json<serde_json::Value>)> {
    let proposal = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
        .ok_or((StatusCode::NOT_FOUND, Json(json!({ "error": "Propuesta no encontrada" }))))?;

    if claims.role == "INVESTIGADOR"
        && proposal.investigator_id.to_string() != claims.sub
        && proposal.principal_investigator_email.to_lowercase() != claims.email.to_lowercase()
    {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "El investigador principal solo puede consultar los proyectos postulados a su nombre." })),
        ));
    }

    Ok(Json(hydrate_proposal(&pool, proposal).await))
}

pub async fn upload_attachment_handler(
    State(pool): State<PgPool>,
    claims: Claims,
    Path(proposal_id): Path<Uuid>,
    Json(payload): Json<UploadAttachmentRequest>,
) -> Result<Json<ProposalFullDto>, (StatusCode, Json<serde_json::Value>)> {
    if claims.role != "INVESTIGADOR" && claims.role != "ADMIN" {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "Solo el Investigador Principal puede adjuntar soportes documentales al sometimiento." })),
        ));
    }

    let existing = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?
        .ok_or((StatusCode::NOT_FOUND, Json(json!({ "error": "Propuesta no encontrada" }))))?;

    let can_investigator_edit = existing.status == "BORRADOR"
        || existing.status == "SUBSANACION_SOLICITADA"
        || (existing.status == "FAVORABLE_CON_OBSERVACIONES" && !existing.ctc_modifications_cleared);
    if !can_investigator_edit {
        return Err((
            StatusCode::FORBIDDEN,
            Json(json!({ "error": "La propuesta ya fue enviada y se encuentra bloqueada; no se pueden adjuntar ni modificar archivos hasta que el Secretario solicite modificaciones." })),
        ));
    }

    let user_id = Uuid::parse_str(&claims.sub).ok();
    let _ = sqlx::query(
        r#"
        INSERT INTO proposal_attachments
        (proposal_id, file_name, mime_type, file_size_bytes, category, content_base64, uploaded_by)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        "#,
    )
    .bind(proposal_id)
    .bind(&payload.file_name)
    .bind(&payload.mime_type)
    .bind(payload.file_size_bytes)
    .bind(&payload.category)
    .bind(&payload.content_base64)
    .bind(user_id)
    .execute(&pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    let proposal = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_one(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    Ok(Json(hydrate_proposal(&pool, proposal).await))
}

pub async fn download_proposal_pdf_handler(
    State(pool): State<PgPool>,
    Path(proposal_id): Path<Uuid>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    let proposal = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()))?
        .ok_or((StatusCode::NOT_FOUND, "Propuesta no encontrada".to_string()))?;

    let attachments = sqlx::query_as::<_, ProposalAttachment>(
        "SELECT * FROM proposal_attachments WHERE proposal_id = $1 ORDER BY created_at DESC",
    )
    .bind(proposal_id)
    .fetch_all(&pool)
    .await
    .unwrap_or_default();

    let pdf_bytes = generate_proposal_pdf(&proposal, &attachments)
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, e))?;

    let filename = format!("attachment; filename=\"{}_CIM-FT-002-BUC_V{}.pdf\"", proposal.code, proposal.revision_count);
    Ok((
        [
            (header::CONTENT_TYPE, "application/pdf".to_string()),
            (header::CONTENT_DISPOSITION, filename),
        ],
        pdf_bytes,
    ))
}

pub async fn download_concept_pdf_handler(
    State(pool): State<PgPool>,
    Path(proposal_id): Path<Uuid>,
) -> Result<impl IntoResponse, (StatusCode, String)> {
    let proposal = sqlx::query_as::<_, Proposal>("SELECT * FROM proposals WHERE id = $1")
        .bind(proposal_id)
        .fetch_optional(&pool)
        .await
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()))?
        .ok_or((StatusCode::NOT_FOUND, "Propuesta no encontrada".to_string()))?;

    let reviews = sqlx::query_as::<_, ProposalReview>(
        "SELECT * FROM proposal_reviews WHERE proposal_id = $1 ORDER BY created_at ASC",
    )
    .bind(proposal_id)
    .fetch_all(&pool)
    .await
    .unwrap_or_default();

    let tokens = sqlx::query_as::<_, CtcSignatureToken>(
        "SELECT * FROM ctc_signature_tokens WHERE proposal_id = $1 ORDER BY created_at ASC",
    )
    .bind(proposal_id)
    .fetch_all(&pool)
    .await
    .unwrap_or_default();

    let pdf_bytes = generate_ctc_concept_pdf(&proposal, &reviews, &tokens)
        .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, e))?;

    let filename = format!("attachment; filename=\"{}_Concepto_CTC_MASIRA.pdf\"", proposal.code);
    Ok((
        [
            (header::CONTENT_TYPE, "application/pdf".to_string()),
            (header::CONTENT_DISPOSITION, filename),
        ],
        pdf_bytes,
    ))
}

pub async fn list_emails_handler(
    State(pool): State<PgPool>,
    claims: Claims,
) -> Result<Json<Vec<EmailOutboxItem>>, (StatusCode, Json<serde_json::Value>)> {
    let items = if claims.role == "INVESTIGADOR" {
        sqlx::query_as::<_, EmailOutboxItem>(
            "SELECT * FROM email_outbox WHERE LOWER(recipient_email) = LOWER($1) AND email_category != 'TOKEN_FIRMA_CTC' ORDER BY created_at DESC LIMIT 100",
        )
        .bind(&claims.email)
        .fetch_all(&pool)
        .await
    } else {
        sqlx::query_as::<_, EmailOutboxItem>(
            "SELECT * FROM email_outbox WHERE email_category != 'TOKEN_FIRMA_CTC' OR LOWER(recipient_email) = LOWER($1) ORDER BY created_at DESC LIMIT 100",
        )
        .bind(&claims.email)
        .fetch_all(&pool)
        .await
    }
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({ "error": e.to_string() }))))?;

    Ok(Json(items))
}
