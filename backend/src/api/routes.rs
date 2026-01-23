use axum::{Router, routing::post};
use sqlx::PgPool;
use crate::api::handlers;

pub fn app(pool: PgPool) -> Router {
    Router::new()
        .route("/awaken", post(handlers::awaken_user))
        .with_state(pool)
}
