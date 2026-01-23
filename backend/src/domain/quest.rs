use serde::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct QuestStruct {
    pub title: String,
    pub description: String,
    pub difficulty: String,
    pub xp_reward: i32,
    pub penalty: String,
}

impl QuestStruct {
    pub fn fallback() -> Self {
        Self {
            title: "Survival Quest".to_string(),
            description: "Do 100 Pushups. The System is currently offline.".to_string(),
            difficulty: "E".to_string(),
            xp_reward: 10,
            penalty: "None".to_string(),
        }
    }
}
