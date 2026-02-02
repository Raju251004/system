import { IsObject, IsNotEmpty } from 'class-validator';

export class DailyQuestDto {
  @IsObject()
  @IsNotEmpty()
  userStats: Record<string, any>;
}
