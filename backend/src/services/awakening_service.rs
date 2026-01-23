use sqlx::PgPool;
use crate::domain::user::CreateUserRequest;
use crate::infrastructure::repositories;
use rand::seq::SliceRandom;

pub async fn awaken(pool: PgPool, req: CreateUserRequest) -> anyhow::Result<String> {
    // 1. Random Class Generation
    // In a real system, this would be based on the answers/ambition analysis.
    let classes = vec!["Necromancer", "Fighter", "Mage", "Assassin", "Healer", "Tank"];
    let chosen_class = classes.choose(&mut rand::thread_rng()).unwrap_or(&"Fighter");

    // 2. Transactional Persistence
    let mut tx = pool.begin().await?;
    
    let _user_id = repositories::create_user(&mut tx, &req, chosen_class).await?;
    repositories::create_initial_stats(&mut tx, _user_id).await?;

    tx.commit().await?;

    Ok(format!("Welcome, {}. You have awakened as a {}.", req.username, chosen_class))
}
