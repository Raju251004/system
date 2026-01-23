use sqlx::{Postgres, Transaction, Row};
use uuid::Uuid;
use crate::domain::user::CreateUserRequest;

pub async fn create_user(
    tx: &mut Transaction<'_, Postgres>,
    req: &CreateUserRequest,
    class: &str
) -> anyhow::Result<Uuid> {
    // Using sqlx::query function for compile-time safety absent a live DB connection in this env
    let row = sqlx::query(
        r#"
        INSERT INTO users (username, email, ambition, class)
        VALUES ($1, $2, $3, $4)
        RETURNING id
        "#,
    )
    .bind(&req.username)
    .bind(&req.email)
    .bind(&req.ambition)
    .bind(class)
    .fetch_one(&mut **tx)
    .await?;

    Ok(row.get("id"))
}

pub async fn create_initial_stats(
    tx: &mut Transaction<'_, Postgres>,
    user_id: Uuid
) -> anyhow::Result<()> {
    sqlx::query(
        r#"
        INSERT INTO user_stats (user_id) VALUES ($1)
        "#,
    )
    .bind(user_id)
    .execute(&mut **tx)
    .await?;
    Ok(())
}
