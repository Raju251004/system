import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { QuestsService } from './quests.service';
import { CreateQuestDto } from './dto/create-quest.dto';
import { UpdateQuestDto } from './dto/update-quest.dto';
import { AuthGuard } from '@nestjs/passport';

@Controller('quests')
export class QuestsController {
  constructor(private readonly questsService: QuestsService) { }

  @Post()
  create(@Body() createQuestDto: CreateQuestDto) {
    return this.questsService.create(createQuestDto);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('daily')
  getDaily(@Request() req: { user: { userId: string } }) {
    return this.questsService.generateDailyQuests(req.user.userId);
  }

  @Get()
  findAll() {
    return this.questsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.questsService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateQuestDto: UpdateQuestDto) {
    return this.questsService.update(id, updateQuestDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.questsService.remove(id);
  }

  @UseGuards(AuthGuard('jwt'))
  @Post(':id/complete')
  complete(
    @Param('id') id: string,
    @Request() req: { user: { userId: string } },
  ) {
    return this.questsService.completeQuest(req.user.userId, id);
  }
}
