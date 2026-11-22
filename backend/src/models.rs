use chrono::{DateTime, NaiveDate, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct User {
    pub id: Uuid,
    pub email: String,
    pub full_name: String,
    pub role: String,
    pub academic_unit: Option<String>,
    pub research_group: Option<String>,
    #[serde(skip_serializing)]
    pub password_hash: Option<String>,
    pub password_setup_token: Option<String>,
    pub password_setup_expires_at: Option<DateTime<Utc>>,
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CreateUserRequest {
    pub email: String,
    pub full_name: String,
    pub role: String,
    pub academic_unit: Option<String>,
    pub research_group: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SetPasswordRequest {
    pub token: String,
    pub new_password: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct LoginRequest {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct OAuthTokenResponse {
    pub access_token: String,
    pub token_type: String,
    pub expires_in: usize,
    pub user: User,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct WorkTeamMember {
    pub nombre: String,
    pub rol: String,
    pub entidad: String,
    pub responsabilidades: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct RiskItem {
    pub tipo_riesgo: String,
    pub descripcion: String,
    pub probabilidad: String,
    pub impacto: String,
    pub medidas_mitigacion: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct BudgetRubro {
    pub item: i32,
    pub rubro: String,
    pub contrapartida_udes_especie: i64,
    pub contrapartida_udes_efectivo: i64,
    pub aliado_especie: i64,
    pub aliado_efectivo: i64,
    pub entidad_convocatoria_efectivo: i64,
    pub total: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ScheduleRow {
    pub objetivo: String,
    pub actividades: String,
    pub trimestres: Vec<bool>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ProposalVersionSnapshot {
    pub version_number: i32,
    pub version_label: String,
    pub submitted_at: String,
    pub title: String,
    pub academic_program: String,
    pub campus: String,
    pub backing_group: String,
    pub group_leader: String,
    pub research_line: String,
    pub principal_investigator_name: String,
    pub principal_investigator_email: String,
    pub allied_entity_name: String,
    pub development_location: String,
    pub call_name: String,
    pub call_type: String,
    pub call_deadline: Option<String>,
    pub work_team: Vec<WorkTeamMember>,
    pub problem_and_justification: String,
    pub general_objective: String,
    pub specific_objectives: String,
    pub methodology_design: String,
    pub study_setting: String,
    pub participants_and_sampling: String,
    pub eligibility_criteria: String,
    pub recruitment_plan: String,
    pub data_collection_techniques: String,
    pub procedures_description: String,
    pub data_analysis_plan: String,
    pub ethical_considerations: String,
    pub expected_results: String,
    pub possible_alliances: String,
    pub risk_matrix: Vec<RiskItem>,
    pub budget_items: Vec<BudgetRubro>,
    pub budget_total: i64,
    pub schedule_items: Vec<ScheduleRow>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct PointObservation {
    pub item_code: String,
    pub item_label: String,
    pub observation: String,
    pub resolved: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct Proposal {
    pub id: Uuid,
    pub code: String,
    pub investigator_id: Uuid,
    pub status: String,
    pub revision_count: i32,
    pub title: String,
    pub academic_program: String,
    pub campus: String,
    pub backing_group: String,
    pub group_leader: String,
    pub research_line: String,
    pub principal_investigator_name: String,
    pub principal_investigator_email: String,
    pub allied_entity_name: String,
    pub development_location: String,
    pub call_name: String,
    pub call_type: String,
    pub call_deadline: Option<NaiveDate>,
    pub work_team: sqlx::types::Json<Vec<WorkTeamMember>>,
    pub problem_and_justification: String,
    pub general_objective: String,
    pub specific_objectives: String,
    pub methodology_design: String,
    pub study_setting: String,
    pub participants_and_sampling: String,
    pub eligibility_criteria: String,
    pub recruitment_plan: String,
    pub data_collection_techniques: String,
    pub procedures_description: String,
    pub data_analysis_plan: String,
    pub ethical_considerations: String,
    pub expected_results: String,
    pub possible_alliances: String,
    pub risk_matrix: sqlx::types::Json<Vec<RiskItem>>,
    pub budget_items: sqlx::types::Json<Vec<BudgetRubro>>,
    pub budget_total: i64,
    pub schedule_items: sqlx::types::Json<Vec<ScheduleRow>>,
    #[sqlx(default)]
    pub version_history: sqlx::types::Json<Vec<ProposalVersionSnapshot>>,
    pub ctc_session_date: Option<NaiveDate>,
    pub ctc_concept: Option<String>,
    pub ctc_general_concept_notes: Option<String>,
    pub ctc_modifications_cleared: bool,
    pub submitted_at: Option<DateTime<Utc>>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ProposalFullDto {
    #[serde(flatten)]
    pub proposal: Proposal,
    pub attachments: Vec<ProposalAttachment>,
    pub reviews: Vec<ProposalReview>,
    pub signature_tokens: Vec<CtcSignatureToken>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UpsertProposalRequest {
    pub title: String,
    pub academic_program: String,
    pub campus: String,
    pub backing_group: String,
    pub group_leader: String,
    pub research_line: String,
    pub principal_investigator_name: String,
    pub principal_investigator_email: String,
    pub allied_entity_name: String,
    pub development_location: String,
    pub call_name: String,
    pub call_type: String,
    pub call_deadline: Option<String>,
    pub work_team: Vec<WorkTeamMember>,
    pub problem_and_justification: String,
    pub general_objective: String,
    pub specific_objectives: String,
    pub methodology_design: String,
    pub study_setting: String,
    pub participants_and_sampling: String,
    pub eligibility_criteria: String,
    pub recruitment_plan: String,
    pub data_collection_techniques: String,
    pub procedures_description: String,
    pub data_analysis_plan: String,
    pub ethical_considerations: String,
    pub expected_results: String,
    pub possible_alliances: String,
    pub risk_matrix: Vec<RiskItem>,
    pub budget_items: Vec<BudgetRubro>,
    pub schedule_items: Vec<ScheduleRow>,
    pub submit_now: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct ProposalAttachment {
    pub id: Uuid,
    pub proposal_id: Uuid,
    pub file_name: String,
    pub mime_type: String,
    pub file_size_bytes: i64,
    pub category: String,
    pub content_base64: Option<String>,
    pub uploaded_by: Option<Uuid>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct UploadAttachmentRequest {
    pub file_name: String,
    pub mime_type: String,
    pub file_size_bytes: i64,
    pub category: String,
    pub content_base64: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct ProposalReview {
    pub id: Uuid,
    pub proposal_id: Uuid,
    pub revision_number: i32,
    pub reviewer_id: Option<Uuid>,
    pub reviewer_name: String,
    pub stage: String,
    pub decision: String,
    pub general_summary: String,
    pub point_observations: sqlx::types::Json<Vec<PointObservation>>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SecretaryReviewRequest {
    pub decision: String,
    pub general_summary: String,
    pub point_observations: Vec<PointObservation>,
    pub ctc_session_date: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CtcPlenaryDecisionRequest {
    pub concept: String,
    pub general_summary: String,
    pub point_observations: Vec<PointObservation>,
    pub generate_member_tokens: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct CtcSignatureToken {
    pub id: Uuid,
    pub proposal_id: Uuid,
    pub revision_number: i32,
    pub member_id: Uuid,
    pub member_name: String,
    pub member_email: String,
    pub member_position: String,
    pub single_use_token: String,
    pub is_used: bool,
    pub used_at: Option<DateTime<Utc>>,
    pub vote_decision: Option<String>,
    pub signature_hash: Option<String>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct SignWithTokenRequest {
    pub single_use_token: String,
    pub vote_decision: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct EmailOutboxItem {
    pub id: Uuid,
    pub recipient_email: String,
    pub recipient_name: String,
    pub subject: String,
    pub body_text: String,
    pub action_link: Option<String>,
    pub related_proposal_code: Option<String>,
    pub email_category: String,
    pub is_read: bool,
    pub created_at: DateTime<Utc>,
}
