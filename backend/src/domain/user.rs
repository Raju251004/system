use serde::{Deserialize, Serialize};
use uuid::Uuid;
use sqlx::FromRow;

#[derive(Debug, Serialize, Deserialize, Clone, Copy, PartialEq, Eq, sqlx::Type)]
#[sqlx(type_name = "rank_type", rename_all = "UPPERCASE")] 
pub enum Rank {
    E, D, C, B, A, S
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub email: String,
    pub current_level: i32,
    pub xp: i64,
    pub rank: Rank,
    pub class: Option<String>,
    pub gold: i64,
    pub ambition: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CreateUserRequest {
    pub username: String,
    pub email: String,
    pub ambition: String,
}
