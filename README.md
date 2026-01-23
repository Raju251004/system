# System (Project Antigravity)

![System Status](https://img.shields.io/badge/System-Online-cyan?style=for-the-badge&logo=prometheus)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

> "The System uses you. You use the System."

**System** is a full-stack "Life OS" designed to gamify human potential. It integrates a Flutter frontend with a Rust backend to convert productivity into a leveling system.

## 🏗 Architecture

The project is structured as a monorepo:

*   **`system/`**: The Flutter Mobile Application (The Interface).
*   **`backend/`**: The Rust API Server (The Core).
*   **`database/`**: The PostgreSQL Schema (The Memory).

### Why is `database/` separate?
The database schema is the source of truth for the entire System. It is decoupled from the backend logic to allow for:
1.  **Independent Migrations**: Schema changes can be managed by specialized tools without recompiling the backend.
2.  **Polyglot Access**: Future services (Python analytics, Go microservices) can access the DB without depending on the Rust codebase.
3.  **Clarity**: It separates *data structure* from *application logic*.

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK
*   Rust (Cargo)
*   Docker & Docker Compose (for PostgreSQL)

### Installation

1.  **Clone the Gate**:
    ```bash
    git clone https://github.com/your-username/system.git
    cd system
    ```

2.  **Ignite the Database**:
    ```bash
    docker-compose up -d
    ```

3.  **Awaken the Backend**:
    ```bash
    cd backend
    cargo run
    ```
    *Server will listen on `0.0.0.0:3000`*

4.  **Enter the System (Frontend)**:
    ```bash
    cd ../system
    flutter run
    ```

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for the "Antigravity" protocol.
