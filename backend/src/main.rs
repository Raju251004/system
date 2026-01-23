mod api;
mod domain;
mod infrastructure;
mod services;

use infrastructure::db;
use dotenv::dotenv;
use tracing_subscriber;

#[tokio::main]
async fn main() {
    dotenv().ok();
    tracing_subscriber::fmt::init();

    // Check if DATABASE_URL is set, if not, warn or panic (handled in connect)
    println!("Connecting to database...");
    let pool = db::connect().await;
    println!("Database connected.");

    let app = api::routes::app(pool);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("System Online. Listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}
