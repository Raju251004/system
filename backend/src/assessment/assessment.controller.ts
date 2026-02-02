import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AssessmentService } from './assessment.service';
import { AuthGuard } from '@nestjs/passport';

import { CreateAssessmentDto } from './dto/create-assessment.dto';

@Controller('assessment')
export class AssessmentController {
  constructor(private readonly assessmentService: AssessmentService) {}

  @UseGuards(AuthGuard('jwt'))
  @Post('submit')
  submit(@Request() req, @Body() data: CreateAssessmentDto) {
    return this.assessmentService.submit(req.user.userId, data);
  }
}
