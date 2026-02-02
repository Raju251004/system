import { IsString, IsNumber, IsOptional, IsArray, IsDateString } from 'class-validator';

export class CreateAssessmentDto {
  @IsString()
  gender: string;

  @IsDateString()
  dob: string;

  @IsNumber()
  height: number;

  @IsNumber()
  weight: number;

  @IsNumber()
  pushups: number;

  @IsNumber()
  situps: number;

  @IsNumber()
  squats: number;

  @IsNumber()
  @IsOptional()
  runTime?: number;

  @IsArray()
  @IsString({ each: true })
  healthIssues: string[];

  @IsArray()
  @IsString({ each: true })
  habits: string[];

  @IsString()
  goal: string;

  @IsArray()
  @IsString({ each: true })
  profileLinks: string[];

  @IsNumber()
  selfRating: number;
}
