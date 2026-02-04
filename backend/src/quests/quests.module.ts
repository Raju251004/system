import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { QuestsService } from './quests.service';
import { QuestsController } from './quests.controller';
import { Quest } from './entities/quest.entity';
import { UsersModule } from '../users/users.module';
import { LeetCodeModule } from '../leetcode/leetcode.module';

@Module({
  imports: [TypeOrmModule.forFeature([Quest]), UsersModule, LeetCodeModule],
  controllers: [QuestsController],
  providers: [QuestsService],
  exports: [QuestsService, TypeOrmModule], // Export TypeOrmModule for Seeding
})
export class QuestsModule { }
