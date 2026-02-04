import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { AssessmentService } from './assessment.service';
import { CreateAssessmentDto } from './dto/create-assessment.dto';
import { AuthGuard } from '@nestjs/passport';

@Controller('assessment')
@UseGuards(AuthGuard('jwt'))
export class AssessmentController {
  constructor(private readonly assessmentService: AssessmentService) { }

  @Post('submit')
  create(@Request() req: { user: { userId: string } }, @Body() createAssessmentDto: CreateAssessmentDto) {
    return this.assessmentService.create(req.user.userId, createAssessmentDto);
  }

  @Get('history')
  findAll(@Request() req: { user: { userId: string } }) {
    return this.assessmentService.findAllByUser(req.user.userId);
  }

  @Get('stats')
  getStats(@Request() req: { user: { userId: string } }) {
    return this.assessmentService.getStats(req.user.userId);
  }
}
