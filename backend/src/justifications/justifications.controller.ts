import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { JustificationsService } from './justifications.service';
import { SubmitJustificationDto } from './dto/submit-justification.dto';
import { ReviewJustificationDto } from './dto/review-justification.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../prisma/prisma.service';

@Controller('justifications')
@UseGuards(JwtAuthGuard, RolesGuard)
export class JustificationsController {
  constructor(
    private readonly justificationsService: JustificationsService,
  ) {}

  @Post()
  @Roles(Role.STUDENT, Role.ADMIN)
  async submitJustification(
    @Body() dto: SubmitJustificationDto,
    @Request() req: any,
  ) {
    const studentId = req.user.id;
    return this.justificationsService.submitJustification(
      studentId,
      dto,
      req.user,
    );
  }

  @Patch(':id/review')
  @Roles(Role.TEACHER, Role.ADMIN)
  async reviewJustification(
    @Param('id') id: string,
    @Body() dto: ReviewJustificationDto,
    @Request() req: any,
  ) {
    return this.justificationsService.reviewJustification(id, dto, req.user);
  }

  @Get('section/:sectionId')
  @Roles(Role.TEACHER, Role.ADMIN)
  async getSectionJustifications(
    @Param('sectionId') sectionId: string,
    @Request() req: any,
  ) {
    return this.justificationsService.getSectionJustifications(
      sectionId,
      req.user,
    );
  }
}
