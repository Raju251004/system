import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { GeminiService } from './gemini.service';
import { HuggingFaceService } from './huggingface.service';
import { AwakenDto } from './dto/awaken.dto';
import { DailyQuestDto } from './dto/daily-quest.dto';

@Controller('intelligence')
export class IntelligenceController {
  constructor(
    private readonly geminiService: GeminiService,
    private readonly huggingFaceService: HuggingFaceService,
  ) {}

  @UseGuards(AuthGuard('jwt'))
  @Post('awaken')
  async awaken(
    @Body() awakenDto: AwakenDto,
  ): Promise<{ hunterClass: string; message: string }> {
    const hunterClass = await this.huggingFaceService.classifyHunterClass(
      awakenDto.bio,
    );
    return {
      hunterClass,
      message: `The System has designated you as a ${hunterClass}. Welcome to the Awakening.`,
    };
  }

  @UseGuards(AuthGuard('jwt'))
  @Post('quest/daily')
  async getDailyQuest(@Body() dailyQuestDto: DailyQuestDto): Promise<any> {
    return this.geminiService.generateDailyQuest(dailyQuestDto.userStats);
  }
}
