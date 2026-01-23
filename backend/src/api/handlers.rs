use axum::{extract::State, Json, http::StatusCode};
use sqlx::PgPool;
use crate::domain::user::CreateUserRequest;
use crate::services::awakening_service;

pub async fn awaken_user(
    State(pool): State<PgPool>,
    Json(payload): Json<CreateUserRequest>,
) -> Result<Json<String>, StatusCode> {
    // Invoke service
    match awakening_service::awaken(pool, payload).await {
        Ok(msg) => Ok(Json(msg)),
        Err(_) => Err(StatusCode::INTERNAL_SERVER_ERROR),
    }
}
