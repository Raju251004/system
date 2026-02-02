import { IsString, MinLength } from 'class-validator';

export class AwakenDto {
  @IsString()
  @MinLength(10, {
    message:
      'Bio must be at least 10 characters long for the System to analyze',
  })
  bio: string;
}
