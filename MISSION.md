# Project Antigravity: The Awakening

## The Vision
**Antigravity** is not merely a task manager. It is a comprehensive **"Life OS"** designed to break the gravitational pull of procrastination and mediocrity.

We are building a system that gamifies human potential, leveraging advanced AI to turn daily life into an RPG. It transforms mundane tasks into Quests, personal growth into Stats, and ambition into a tangible Leveling System. We are not building tools; we are building a framework for human evolution.

## The Antigravity Protocol
To maintain the integrity of the System, all Hunters (developers) must adhere to the following protocols:

### 1. The Living Record
Every update, no matter how small, is a piece of history. **Every Pull Request must include a Changelog entry.** We document our ascent.

### 2. Self-Documenting Arts
Code is read more often than it is written.
*   **Variable Names > Comments**: Do not write comments explaining *what* code does; write code that explains itself. Use comments only to explain *why* a complex decision was made.
*   *Bad*: `// Calculates xp`
*   *Good*: `calculate_level_up_threshold(current_level)`

### 3. The Rule of Iron
Data is the lifeblood of the System.
*   **No breaking changes to the Database Schema without a migration file.**
*   Schema integrity is paramount. If you break the schema, you break the System.

## Calling All Hunters (How to Contribute)
Join the raid. Here is your starter kit:

1.  **Initialize the Gate**:
    ```bash
    git clone https://github.com/your-org/antigravity.git
    cd antigravity
    ```

2.  **Summon the Infrastructure**:
    ```bash
    docker-compose up -d
    ```

3.  **Awaken the Core**:
    ```bash
    cd backend
    cargo watch -x run
    ```

**Arise.**
