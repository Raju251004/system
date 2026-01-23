use serde::{Deserialize, Serialize};
use crate::domain::quest::QuestStruct;
use std::env;

#[derive(Serialize)]
struct GeminiRequest {
    contents: Vec<Content>,
}
#[derive(Serialize)]
struct Content {
    parts: Vec<Part>,
}
#[derive(Serialize)]
struct Part {
    text: String,
}

#[derive(Deserialize, Debug)]
struct GeminiResponse {
    candidates: Option<Vec<Candidate>>,
}
#[derive(Deserialize, Debug)]
struct Candidate {
    content: Option<ResponseContent>,
}
#[derive(Deserialize, Debug)]
struct ResponseContent {
    parts: Option<Vec<ResponsePart>>,
}
#[derive(Deserialize, Debug)]
struct ResponsePart {
    text: String,
}

pub async fn generate_daily_quest(ambition: &str, level: i32) -> anyhow::Result<QuestStruct> {
    let api_key = match env::var("GEMINI_API_KEY") {
        Ok(k) => k,
        Err(_) => {
            eprintln!("GEMINI_API_KEY not set. Using fallback.");
            return Ok(QuestStruct::fallback());
        }
    };

    let url = format!("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key={}", api_key);
    
    // Prompt asking for a SINGLE JSON object matching our struct
    let prompt = format!(
        "You are 'The System' from Solo Leveling. The user wants to be '{}'. They are Level {}. \
        Generate 1 daily quest (Difficulty E) that is actionable (physical sets or study goals). \
        Return ONLY valid JSON matching this schema: \
        {{ \"title\": \"String\", \"description\": \"String\", \"difficulty\": \"E\", \"xp_reward\": Int, \"penalty\": \"String\" }}. \
        Do not wrap the response in markdown code blocks.",
        ambition, level
    );

    let request_body = GeminiRequest {
        contents: vec![Content {
            parts: vec![Part { text: prompt }],
        }],
    };

    let client = reqwest::Client::new();
    let resp = client.post(&url)
        .json(&request_body)
        .send()
        .await;

    match resp {
        Ok(response) => {
             if !response.status().is_success() {
                 eprintln!("Gemini API returned error status: {}", response.status());
                 return Ok(QuestStruct::fallback());
             }

             let gemini_resp: GeminiResponse = response.json().await.unwrap_or(GeminiResponse { candidates: None });
             
             // Iterate through nested structure to find the text
             if let Some(candidates) = gemini_resp.candidates {
                 if let Some(candidate) = candidates.first() {
                     if let Some(content) = &candidate.content {
                         if let Some(parts) = &content.parts {
                             if let Some(part) = parts.first() {
                                 let json_text = &part.text;
                                 // Clean cleanup if model wrapped in ```json ... ```
                                 let clean_json = json_text.trim()
                                     .trim_start_matches("```json")
                                     .trim_start_matches("```")
                                     .trim_end_matches("```");

                                 match serde_json::from_str::<QuestStruct>(clean_json) {
                                     Ok(quest) => return Ok(quest),
                                     Err(e) => {
                                         eprintln!("Failed to parse Quest JSON: {}. Text was: {}", e, json_text);
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
             Ok(QuestStruct::fallback())
        },
        Err(e) => {
            eprintln!("Failed to contact Gemini API: {}", e);
            Ok(QuestStruct::fallback())
        }
    }
}
