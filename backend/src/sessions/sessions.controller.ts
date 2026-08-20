import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { SessionsService } from './sessions.service';
import { StartSessionDto } from './dto/start-session.dto';
import { CloseSessionDto } from './dto/close-session.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../prisma/prisma.service';

@Controller('sessions')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SessionsController {
  constructor(private readonly sessionsService: SessionsService) {}

  @Post('start')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async startSession(@Body() dto: StartSessionDto, @Request() req: any) {
    return this.sessionsService.startSession(dto, req.user);
  }

  @Post('close')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async closeSession(@Body() dto: CloseSessionDto, @Request() req: any) {
    return this.sessionsService.closeSession(dto, req.user);
  }

  @Get('active')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getActiveSessions() {
    return this.sessionsService.getActiveSessions();
  }

  @Get(':id')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getSessionById(@Param('id') id: string) {
    return this.sessionsService.getSessionById(id);
  }

  @Get('section/:sectionId')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getSectionSessions(@Param('sectionId') sectionId: string) {
    return this.sessionsService.getSectionSessions(sectionId);
  }
}
