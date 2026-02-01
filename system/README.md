# Solo Leveling System - Frontend

Flutter-based frontend for the Solo Leveling life gamification system.

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Networking**: Dio
- **Storage**: Flutter Secure Storage
- **UI System**: Custom AppTheme (Dark Mode)

## Project Structure

```
lib/
├── core/
│   ├── api/            # API Client (Dio) & Interceptors
│   └── theme/          # App Theme & Colors
├── features/
│   └── auth/           # Authentication Feature
│       ├── data/       # Repositories
│       └── presentation/ # UI & Controllers
└── main.dart           # App Entry Point & ProviderScope
```

## Setup & Running

1.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run on Emulator/Device**:
    ```bash
    flutter run
    ```

3.  **Run Tests**:
    ```bash
    flutter test
    ```

## Features Implemented

- **Authentication**:
    - Login Screen connected to Backend API (`/auth/login`)
    - JWT Token storage in Secure Storage
    - Auto-attach Bearer token to requests
- **State Management**:
    - Riverpod for dependency injection and state
    - `AuthController` handles async login logic
- **Networking**:
    - Centralized `ApiClient`
    - Timeout configuration (10s)

## Connection to Backend

The app connects to `http://localhost:3000`.
**Note for Android Emulator**: Use `10.0.2.2` instead of `localhost` in `lib/core/api/api_client.dart` if testing on Android Emulator.

## License

Personal Use
