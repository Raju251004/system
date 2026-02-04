import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Quest } from './entities/quest.entity';
import { CreateQuestDto } from './dto/create-quest.dto';
import { UpdateQuestDto } from './dto/update-quest.dto';
import { UsersService } from '../users/users.service';
import { LeetCodeService } from '../leetcode/leetcode.service';

@Injectable()
export class QuestsService {
  constructor(
    @InjectRepository(Quest)
    private questRepository: Repository<Quest>,
    private usersService: UsersService,
    private leetcodeService: LeetCodeService,
  ) { }

  async create(createQuestDto: CreateQuestDto) {
    return this.questRepository.save(
      this.questRepository.create(createQuestDto),
    );
  }

  async findAll() {
    return this.questRepository.find();
  }

  async findOne(id: string) {
    return this.questRepository.findOneBy({ id });
  }

  async update(id: string, updateQuestDto: UpdateQuestDto) {
    await this.questRepository.update(id, updateQuestDto);
    return this.findOne(id);
  }

  async remove(id: string) {
    return this.questRepository.delete(id);
  }

  async completeQuest(userId: string, questId: string) {
    const quest = await this.findOne(questId);
    if (!quest && questId !== 'PENALTY_QUEST') throw new NotFoundException('Quest not found'); // Only check DB for normal quests

    const user = await this.usersService.findOne(userId);
    if (!user) throw new NotFoundException('User not found');

    // MOCK REWARDS for Penalty Quest if not in DB
    const rewards = quest ? quest.rewards : { xp: 0, gold: 0 };

    // Award XP
    await this.usersService.addXp(userId, rewards.xp);

    // Update Progress
    let progress = user.dailyQuestProgress + 1;
    let streak = user.streak;

    // If Penalty Quest Completed
    if (user.status === 'PUNISHED' && questId === 'PENALTY_QUEST') {
      await this.usersService.update(userId, { status: 'NORMAL', dailyQuestProgress: 0 }); // Reset
      return { message: 'PENALTY CLEARED', rewards };
    }

    if (user.status === 'NORMAL') {
      const TOTAL_DAILY_QUESTS = 4;
      if (progress >= TOTAL_DAILY_QUESTS) {
        streak += 1; // Daily Complete!
      }
      await this.usersService.update(userId, { dailyQuestProgress: progress, streak });
    }

    return {
      message: 'Quest Completed',
      rewards,
      userUpdates: {
        level: user.level,
        xp: user.currentXp,
        stats: user.stats,
        streak,
        progress
      },
    };
  }

  async generateDailyQuests(userId: string): Promise<any[]> {
    const user = await this.usersService.findOne(userId);
    if (!user) throw new NotFoundException('User not found');

    // Scale Physical Quests based on Stats
    const str = user.stats?.str || 10;
    const pushups = Math.round(str * 2.5); // Str 10 = 25 pushups
    const squats = Math.round(str * 3.0);  // Str 10 = 30 squats
    const runDist = 2 + (user.level * 0.1); // Base 2km

    // Fetch Technical Quest
    let techQuest = {
      title: 'Algorithm Practice',
      description: 'Solve a LeetCode Easy problem',
      xp: 100,
      type: 'TECHNICAL'
    };

    try {
      const daily = await this.leetcodeService.getDailyProblem();
      techQuest = {
        title: `Code: ${daily.title}`,
        description: `Solve LeetCode ${daily.difficulty}: ${daily.link}`,
        xp: daily.difficulty === 'Hard' ? 300 : (daily.difficulty === 'Medium' ? 200 : 100),
        type: 'TECHNICAL'
      };
    } catch (e) {
      console.log('Failed to fetch LeetCode', e);
    }

    // Build Quest List (Dynamic)
    return [
      {
        id: 'daily_phys_1',
        title: 'Strength Training',
        description: `Complete ${pushups} Push-ups`,
        rewards: { xp: 50, gold: 10 },
        type: 'PHYSICAL',
        target: pushups,
        unit: 'reps'
      },
      {
        id: 'daily_phys_2',
        title: 'Leg Day',
        description: `Complete ${squats} Squats`,
        rewards: { xp: 50, gold: 10 },
        type: 'PHYSICAL',
        target: squats,
        unit: 'reps'
      },
      {
        id: 'daily_tech_1',
        title: techQuest.title,
        description: techQuest.description,
        rewards: { xp: techQuest.xp, gold: 20 },
        type: 'TECHNICAL',
        link: (techQuest as any).description.split(': ')[1] // Extract link hack
      },
      {
        id: 'daily_study_1',
        title: 'Focus Session',
        description: 'Study for 60 Minutes (Deep Work)',
        rewards: { xp: 100, gold: 0 },
        type: 'STUDY',
        target: 60,
        unit: 'minutes'
      }
    ];
  }
}
