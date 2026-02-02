import { Injectable, Logger } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { CreateAssessmentDto } from './dto/create-assessment.dto';

@Injectable()
export class AssessmentService {
  private readonly logger = new Logger(AssessmentService.name);

  constructor(private usersService: UsersService) {}

  async submit(
    userId: string,
    _data: CreateAssessmentDto,
  ): Promise<{ message: string }> {
    // In the future, save 'data' to PhysicalStats/MentalStats entities
    // For now, just mark onboarding as completed
    await this.usersService.update(userId, {
      isOnboardingCompleted: true,
    });
    this.logger.log(`Assessment Data: ${JSON.stringify(_data)}`);
    return { message: 'Assessment submitted successfully' };
  }
}
