# Contributing to The System

Welcome, Hunter. You have chosen to contribute to the evolution of the System.

## The Antigravity Protocol

1.  **The Living Record**:
    *   Every Pull Request MUST include a meaningful description.
    *   Update `CHANGELOG.md` if you make user-facing changes.

2.  **Code Philosophy**:
    *   **Backend (Rust)**: Follow DDD. pure functions > side effects. `unwrap()` is forbidden; use `anyhow` or `thiserror`.
    *   **Frontend (Flutter)**: strict typing. `const` constructors. Separation of `presentation`, `domain`, and `data` (Riverpod).

3.  **Database Integrity (The Rule of Iron)**:
    *   Never modify `schema.sql` directly for production changes; use migration files.
    *   Ideally, the schema in `database/` reflects the *current ideal state*.

## Workflow
1.  Fork the repository.
2.  Create your branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'feat: Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

**Arise.**
