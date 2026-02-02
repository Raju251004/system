import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { ConfigModule } from '@nestjs/config';
import { GeminiService } from './gemini.service';
import { HuggingFaceService } from './huggingface.service';
import { IntelligenceController } from './intelligence.controller';

@Module({
  imports: [HttpModule, ConfigModule],
  controllers: [IntelligenceController],
  providers: [GeminiService, HuggingFaceService],
  exports: [GeminiService, HuggingFaceService],
})
export class GeminiModule {}
