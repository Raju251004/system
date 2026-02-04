import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AssessmentService } from './assessment.service';
import { AssessmentController } from './assessment.controller';
import { Assessment } from './entities/assessment.entity';

import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Assessment]), UsersModule],
  controllers: [AssessmentController],
  providers: [AssessmentService],
})
export class AssessmentModule { }
