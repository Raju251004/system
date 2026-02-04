import { IsEnum, IsObject, IsNotEmpty } from 'class-validator';
import { AssessmentType } from '../entities/assessment.entity';

export class CreateAssessmentDto {
  @IsEnum(AssessmentType)
  type: AssessmentType;

  @IsObject()
  @IsNotEmpty()
  data: Record<string, any>;
}
