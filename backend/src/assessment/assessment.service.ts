import { Injectable } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { CreateAssessmentDto } from './dto/create-assessment.dto';

@Injectable()
export class AssessmentService {
  constructor(private usersService: UsersService) {}

  async submit(userId: string, _data: CreateAssessmentDto) {
    // In the future, save 'data' to PhysicalStats/MentalStats entities
    // For now, just mark onboarding as completed
    await this.usersService.update(userId, {
      isOnboardingCompleted: true,
    });
    return { message: 'Assessment submitted successfully' };
  }
}
