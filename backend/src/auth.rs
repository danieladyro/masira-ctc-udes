use axum::{
    async_trait,
    extract::FromRequestParts,
    http::{header::AUTHORIZATION, request::Parts, StatusCode},
};
use chrono::{Duration, Utc};
use jsonwebtoken::{decode, encode, DecodingKey, EncodingKey, Header, Validation};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub email: String,
    pub full_name: String,
    pub role: String,
    pub exp: usize,
    pub iat: usize,
}

pub fn jwt_secret() -> String {
    std::env::var("JWT_SECRET").expect("La variable de entorno JWT_SECRET debe estar configurada en .env")
}

pub fn create_jwt(user_id: Uuid, email: &str, full_name: &str, role: &str) -> Result<String, StatusCode> {
    let now = Utc::now();
    let exp = (now + Duration::hours(12)).timestamp() as usize;
    let claims = Claims {
        sub: user_id.to_string(),
        email: email.to_string(),
        full_name: full_name.to_string(),
        role: role.to_string(),
        exp,
        iat: now.timestamp() as usize,
    };

    encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(jwt_secret().as_bytes()),
    )
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)
}

pub fn generate_single_use_token(prefix: &str) -> String {
    let raw = format!("{}:{}:{}", prefix, Uuid::new_v4(), Utc::now().timestamp_nanos_opt().unwrap_or(0));
    let mut hasher = Sha256::new();
    hasher.update(raw.as_bytes());
    let digest = hex::encode(hasher.finalize());
    format!("{}-{}", prefix, &digest[..12].to_uppercase())
}

pub fn compute_signature_hash(proposal_id: Uuid, member_id: Uuid, token: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(format!("{}:{}:{}:{}", proposal_id, member_id, token, Utc::now().to_rfc3339()).as_bytes());
    hex::encode(hasher.finalize())
}

#[async_trait]
impl<S> FromRequestParts<S> for Claims
where
    S: Send + Sync,
{
    type Rejection = (StatusCode, String);

    async fn from_request_parts(parts: &mut Parts, _state: &S) -> Result<Self, Self::Rejection> {
        let auth_header = parts
            .headers
            .get(AUTHORIZATION)
            .and_then(|value| value.to_str().ok())
            .ok_or((
                StatusCode::UNAUTHORIZED,
                "Token JWT OAuth requerido en encabezado Authorization".to_string(),
            ))?;

        let token = auth_header
            .strip_prefix("Bearer ")
            .ok_or((StatusCode::UNAUTHORIZED, "Formato Bearer inválido".to_string()))?;

        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(jwt_secret().as_bytes()),
            &Validation::default(),
        )
        .map_err(|_| (StatusCode::UNAUTHORIZED, "Token JWT expirado o inválido".to_string()))?;

        Ok(token_data.claims)
    }
}
