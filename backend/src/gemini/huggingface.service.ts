import { Injectable, Logger } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class HuggingFaceService {
  private readonly logger = new Logger(HuggingFaceService.name);
  private readonly apiUrl =
    'https://api-inference.huggingface.co/models/facebook/bart-large-mnli';

  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {}

  async classifyHunterClass(bio: string): Promise<string> {
    const apiKey = this.configService.get<string>('HF_API_KEY');
    if (!apiKey || apiKey === 'hf_placeholder_key_here') {
      this.logger.warn(
        'HF_API_KEY not configured. Falling back to default class.',
      );
      return 'Warrior';
    }

    const candidateLabels = [
      'Necromancer',
      'Assassin',
      'Tank',
      'Mage',
      'Ranger',
      'Healer',
    ];

    try {
      const response = await firstValueFrom(
        this.httpService.post<{ labels: string[] }>(
          this.apiUrl,
          {
            inputs: bio,
            parameters: { candidate_labels: candidateLabels },
          },
          {
            headers: { Authorization: `Bearer ${apiKey}` },
          },
        ),
      );

      const labels = response.data.labels;
      // Return the label with the highest score
      return labels[0];
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      const errorStack = error instanceof Error ? error.stack : undefined;
      this.logger.error(
        `Hugging Face classification failed: ${errorMessage}`,
        errorStack,
      );
      return 'Warrior'; // Neutral fallback
    }
  }
}
