mod auth;
mod handlers;
mod models;
mod pdf;

use axum::{
    routing::{get, post},
    Json, Router,
};
use serde_json::json;
use sqlx::postgres::PgPoolOptions;
use std::net::SocketAddr;
use tower_http::cors::{Any, CorsLayer};

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt::init();

    let database_url = std::env::var("DATABASE_URL")
        .expect("La variable de entorno DATABASE_URL debe estar configurada en el archivo .env");

    let pool = PgPoolOptions::new()
        .max_connections(10)
        .connect(&database_url)
        .await
        .expect("No se pudo conectar a PostgreSQL");

    let _ = sqlx::query(
        "ALTER TABLE proposals ADD COLUMN IF NOT EXISTS version_history JSONB NOT NULL DEFAULT '[]'::jsonb",
    )
    .execute(&pool)
    .await;

    let cors = CorsLayer::new()
        .allow_origin(Any)
        .allow_methods(Any)
        .allow_headers(Any);

    let app = Router::new()
        .route("/api/health", get(|| async { Json(json!({ "status": "ok", "service": "masira-ctc-rust-api", "database": "postgresql", "format": "CIM-FT-002-BUC V00" })) }))
        .route("/api/auth/login", post(handlers::login_handler))
        .route("/api/auth/oauth/token", post(handlers::login_handler))
        .route("/api/auth/set-password", post(handlers::set_password_handler))
        .route("/api/auth/pending-users", get(handlers::pending_users_handler))
        .route("/api/users", get(handlers::list_users_handler).post(handlers::create_user_handler))
        .route("/api/proposals", get(handlers::list_proposals_handler).post(handlers::create_proposal_handler))
        .route("/api/proposals/:id", get(handlers::get_proposal_details_handler).put(handlers::update_proposal_handler))
        .route("/api/proposals/:id/attachments", post(handlers::upload_attachment_handler))
        .route("/api/proposals/:id/secretary-review", post(handlers::secretary_review_handler))
        .route("/api/proposals/:id/ctc-plenary", post(handlers::ctc_plenary_decision_handler))
        .route("/api/proposals/:id/sign-token", post(handlers::sign_with_single_use_token_handler))
        .route("/api/proposals/:id/pdf", get(handlers::download_proposal_pdf_handler))
        .route("/api/proposals/:id/concept-pdf", get(handlers::download_concept_pdf_handler))
        .route("/api/emails", get(handlers::list_emails_handler))
        .layer(cors)
        .with_state(pool);

    let port: u16 = std::env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(8080);
    let addr = SocketAddr::from(([0, 0, 0, 0], port));
    tracing::info!("Servidor Rust REST API (CTC MASIRA - UDES) escuchando en http://{}", addr);

    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
