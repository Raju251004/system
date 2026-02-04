import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Assessment, AssessmentType } from './entities/assessment.entity';
import { CreateAssessmentDto } from './dto/create-assessment.dto';

@Injectable()
export class AssessmentService {
  constructor(
    @InjectRepository(Assessment)
    private assessmentRepository: Repository<Assessment>,
  ) { }

  async create(userId: string, createAssessmentDto: CreateAssessmentDto): Promise<Assessment> {
    const score = this.calculateScore(createAssessmentDto.type, createAssessmentDto.data);

    const assessment = this.assessmentRepository.create({
      userId,
      type: createAssessmentDto.type,
      data: createAssessmentDto.data,
      score,
    });

    return this.assessmentRepository.save(assessment);
  }

  async findAllByUser(userId: string): Promise<Assessment[]> {
    return this.assessmentRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  async getStats(userId: string) {
    const assessments = await this.findAllByUser(userId);
    if (!assessments.length) return { average: 0, level: 'Unranked', history: [] };

    // Calculate Average of latest bests or just simple average?
    // Let's do simple average of all assessments for now, or grouped by type.
    const sum = assessments.reduce((acc, curr) => acc + curr.score, 0);
    const average = sum / assessments.length;

    let level = 'Needs Improvement';
    if (average >= 90) level = 'Excellent';
    else if (average >= 75) level = 'Good';
    else if (average >= 60) level = 'Average';
    else if (average >= 40) level = 'Below Average';

    return {
      average: Math.round(average),
      level,
      totalAssessments: assessments.length,
    };
  }

  private calculateScore(type: AssessmentType, data: any): number {
    let score = 0;

    // Standards
    const STD_PUSHUPS = 50;
    const STD_SQUATS = 50;
    const STD_PLANK_SEC = 120;
    const STD_RUNNING_PACE = 300; // 5 min/km (300 sec/km)
    const STD_SIT_REACH = 30; // cm

    switch (type) {
      case AssessmentType.PUSHUPS:
      case AssessmentType.SQUATS:
        // Ability Score = (User Reps / Standard Reps) × 100
        const reps = Number(data.reps || 0);
        score = (reps / (type === AssessmentType.PUSHUPS ? STD_PUSHUPS : STD_SQUATS)) * 100;
        break;

      case AssessmentType.PLANK:
        // Ability Score = (User Time / Standard Time) × 100
        const sec = Number(data.seconds || 0);
        score = (sec / STD_PLANK_SEC) * 100;
        break;

      case AssessmentType.RUNNING:
        // Ability Score = (Standard Time / User Time) × 100
        // Input: distance (km), time (sec). Calculate Pace (sec/km).
        // User Pace = time / distance
        const dist = Number(data.distance || 1); // Avoid div by 0
        const time = Number(data.time || 300);
        const userPace = time / dist; // sec per km
        score = (STD_RUNNING_PACE / userPace) * 100;
        break;

      case AssessmentType.SKIPPING:
        // Skipping Score = Successful Skips × Accuracy Factor
        // Accuracy Factor = 1 - (Missed Skips / Total Skips)
        // We need a Standard for "Successful Skips" to normalize to 100 scale?
        // Prompt says: "Skipping Score = Successful Skips × Accuracy Factor".
        // This creates a raw number (e.g. 200 skips * 0.9 = 180).
        // To normalize to 0-100 scale, let's assume Standard Skips = 200?
        const total = Number(data.total || 0);
        const missed = Number(data.missed || 0);
        const success = total - missed;
        const accuracy = total > 0 ? (1 - (missed / total)) : 0;
        const rawScore = success * accuracy;
        // Normalize: Let's say 200 perfect skips = 100 score.
        score = (rawScore / 200) * 100;
        break;

      case AssessmentType.SIT_AND_REACH:
        // Compare with standard. Let's use simple ratio
        const cm = Number(data.cm || 0);
        score = (cm / STD_SIT_REACH) * 100;
        break;
    }

    return Math.min(Math.max(Math.round(score), 0), 100); // Cap at 100? Or allow >100?
    // "Ability Score" implies percentage of standard. Let's allow >100 for "Level S".
    // Actually, prompt classification is 90+. 100 is max usually. Let's cap at 120 maybe?
    // Let's NOT cap for now, raw ability.
    // Ideally cap at 100 for the "Average" calculation or it skews.
    // Let's cap at 100 for implementation simplicity unless requested otherwise.
    return Math.min(Math.round(score), 100);
  }
}
