# Solo Leveling System

> "I alone level up."

A comprehensive full-stack application inspired by *Solo Leveling*, designed to gamify real-life self-improvement. Built with **NestJS** (Backend) and **Flutter** (Frontend).

![Welcome Screen](https://via.placeholder.com/800x400?text=System+Welcome+Screen)

## 📌 Features

### Core System
-   **Player System**: XP, Levels, and Stats (STR, AGI, INT, VIT, PER).
-   **Class System**: "Shadow Monarch" progression path.
-   **Rank System**: E-Rank to S-Rank progression based on power.

### Modules
-   **Quests**: Daily quests (e.g., "Pushup Mastery", "Running 5km") with automatic or manual verification.
-   **LeetCode Integration**: Automate "Intelligence" stat growth by solving coding problems.
-   **Authentication**: Secure JWT-based auth with "Hunter Registration" logic.

## 🛠 Tech Stack

### Backend (The System)
-   **Framework**: [NestJS](https://nestjs.com/)
-   **Database**: PostgreSQL + TypeORM
-   **AI Integration**: Google Gemini API (for quest generation)
-   **External APIs**: LeetCode API
-   **Security**: BCrypt, Passport, JWT

### Frontend (The Interface)
-   **Framework**: [Flutter](https://flutter.dev/)
-   **State Management**: Riverpod (AsyncNotifier)
-   **Networking**: Dio + Retrofit pattern
-   **Storage**: Flutter Secure Storage
-   **UI/UX**: Custom "System" Dark Theme, Glassmorphism, Animated Text.

## 🚀 Getting Started

### Prerequisites
-   Node.js (v18+)
-   Flutter SDK (v3.10+)
-   PostgreSQL (Local or Cloud)
-   Android Emulator / Physical Device

### Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/solo-leveling-system.git
    cd solo-leveling-system
    ```

2.  **Backend Setup**
    ```bash
    cd backend
    npm install
    # Configure .env (see backend/README.md)
    npm run start:dev
    ```

3.  **Frontend Setup**
    ```bash
    cd system
    flutter pub get
    flutter run
    ```

## 📂 Project Structure

```
solo-leveling-system/
├── backend/            # NestJS API
│   ├── src/
│   │   ├── auth/       # Authentication Module
│   │   ├── users/      # Player Stats & Logic
│   │   ├── quests/     # Quest Management
│   │   └── ...
│   └── ...
├── system/             # Flutter App
│   ├── lib/
│   │   ├── core/       # Shared configs (Theme, API)
│   │   ├── features/   # Auth, Status, Home features
│   │   └── ...
│   └── ...
└── README.md           # You are here
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
**"Arise."**
