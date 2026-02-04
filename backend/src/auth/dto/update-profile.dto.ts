import { IsEnum, IsNumber, IsOptional, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { Rank } from '../../users/entities/user.entity';

class UserStatsDto {
    @IsNumber()
    @IsOptional()
    str?: number;

    @IsNumber()
    @IsOptional()
    agi?: number;

    @IsNumber()
    @IsOptional()
    vit?: number;

    @IsNumber()
    @IsOptional()
    int?: number;

    @IsNumber()
    @IsOptional()
    per?: number;
}

export class UpdateProfileDto {
    @IsOptional()
    @IsEnum(Rank)
    rank?: Rank;

    @IsOptional()
    @IsNumber()
    level?: number;

    @IsOptional()
    @IsString()
    jobClass?: string;

    @IsOptional()
    @IsString()
    title?: string;

    @IsOptional()
    @ValidateNested()
    @Type(() => UserStatsDto)
    stats?: UserStatsDto;

    @IsOptional()
    @IsNumber()
    currentXp?: number;

    @IsOptional()
    @IsNumber()
    xpToNextLevel?: number;
}
