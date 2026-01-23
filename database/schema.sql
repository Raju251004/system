-- Solo Leveling System Schema
-- Version: 1.0.0
-- Description: Core schema for Users, Stats, Quests, and Dungeons.

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enums
CREATE TYPE rank_type AS ENUM ('E', 'D', 'C', 'B', 'A', 'S');
CREATE TYPE quest_difficulty AS ENUM ('E', 'D', 'C', 'B', 'A', 'S');
CREATE TYPE quest_status AS ENUM ('ACTIVE', 'COMPLETED', 'FAILED');
CREATE TYPE action_type AS ENUM ('XP_GAIN', 'GOLD_TRANSACTION', 'LEVEL_UP');

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    current_level INT NOT NULL DEFAULT 1,
    xp BIGINT NOT NULL DEFAULT 0,
    rank rank_type NOT NULL DEFAULT 'E',
    class TEXT, -- Nullable until Awakened (e.g., 'Necromancer', 'Fighter')
    gold BIGINT NOT NULL DEFAULT 0,
    ambition TEXT, -- User's goal/ambition
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- User Stats Table (Linked 1:1 to Users)
CREATE TABLE user_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    strength INT NOT NULL DEFAULT 10,
    agility INT NOT NULL DEFAULT 10,
    intelligence INT NOT NULL DEFAULT 10,
    vitality INT NOT NULL DEFAULT 10,
    perception INT NOT NULL DEFAULT 10
);

-- Dungeons Table
CREATE TABLE dungeons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    min_level INT NOT NULL DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE
);

-- Quests Table
CREATE TABLE quests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    dungeon_id UUID REFERENCES dungeons(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    difficulty quest_difficulty NOT NULL,
    xp_reward BIGINT NOT NULL,
    gold_reward BIGINT DEFAULT 0,
    penalty TEXT,
    deadline TIMESTAMP WITH TIME ZONE,
    status quest_status DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Audit Logs Table (Security & Tracking)
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    action action_type NOT NULL,
    amount BIGINT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Stored Procedure: add_xp
-- Logic: Adds XP to user. If XP >= Required, level up and carry over excess.
-- Formula: Required_XP = Level * 100 * 1.5
CREATE OR REPLACE PROCEDURE add_xp(p_user_id UUID, p_amount BIGINT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_xp BIGINT;
    v_current_level INT;
    v_required_xp BIGINT;
    v_xp_remaining BIGINT;
BEGIN
    -- 1. Fetch current user state
    SELECT xp, current_level INTO v_current_xp, v_current_level
    FROM users WHERE id = p_user_id;

    -- 2. Calculate initial new XP total
    v_xp_remaining := v_current_xp + p_amount;

    -- 3. Log the XP Gain
    INSERT INTO audit_logs (user_id, action, amount, metadata)
    VALUES (p_user_id, 'XP_GAIN', p_amount, jsonb_build_object('level_before', v_current_level));

    -- 4. Level Up Loop
    LOOP
        -- required = level * 100 * 1.5
        v_required_xp := (v_current_level * 100 * 1.5)::BIGINT;

        IF v_xp_remaining >= v_required_xp THEN
            -- Level Up!
            v_current_level := v_current_level + 1;
            v_xp_remaining := v_xp_remaining - v_required_xp;

            -- Log the Level Up
            INSERT INTO audit_logs (user_id, action, amount, metadata)
            VALUES (p_user_id, 'LEVEL_UP', 1, jsonb_build_object('new_level', v_current_level));
        ELSE
            -- Exit when XP is less than required for next level
            EXIT;
        END IF;
    END LOOP;

    -- 5. Commit changes to user
    UPDATE users
    SET xp = v_xp_remaining,
        current_level = v_current_level,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_user_id;
END;
$$;
