import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI, GenerativeModel } from '@google/generative-ai';

@Injectable()
export class GeminiService {
  private readonly logger = new Logger(GeminiService.name);
  private genAI: GoogleGenerativeAI;
  private model: GenerativeModel;

  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get<string>('GEMINI_API_KEY');
    if (!apiKey) {
      this.logger.error('GEMINI_API_KEY is not set in environment variables');
    }
    this.genAI = new GoogleGenerativeAI(apiKey || 'dummy_key');
    this.model = this.genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
  }

  async generateText(prompt: string): Promise<string> {
    try {
      const result = await this.model.generateContent(prompt);
      const response = result.response;
      return response.text();
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error(`Gemini API Error: ${errorMessage}`, errorStack);
      return 'The System is offline. (AI Generation Failed)';
    }
  }

  async generateDailyQuest(userStats: Record<string, any>): Promise<any> {
    const prompt = `
      You are the "System" from Solo Leveling. Generate a daily quest for a hunter with the following attributes:
      ${JSON.stringify(userStats)}

      The quest MUST follow this JSON format exactly:
      {
        "title": "Quest Title",
        "description": "Flavor text in a cold, authoritative system tone",
        "objectives": ["Objective 1", "Objective 2"],
        "rewards": ["Reward 1 (+XP)", "Reward 2"],
        "penalty": "Description of what happens if they fail",
        "difficulty": "E | D | C | B | A | S"
      }

      Focus on physical or mental improvement based on their goals.
      Return ONLY the JSON.
    `;

    try {
      const text = await this.generateText(prompt);
      // Clean up potential markdown code blocks more robustly
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      const cleanJson = jsonMatch ? jsonMatch[0] : text;

      return JSON.parse(cleanJson);
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      this.logger.warn(
        `Failed to parse Gemini response as JSON. Falling back to default quest. Error: ${errorMessage}`,
      );
      return {
        title: 'System Recovery Quest',
        description: 'The system is recalibrating. Perform basic maintenance.',
        objectives: ['10 Pushups', '10 Situps'],
        rewards: ['10 XP'],
        penalty: 'Reduced growth',
        difficulty: 'E',
      };
    }
  }
}
