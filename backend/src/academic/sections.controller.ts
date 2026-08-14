import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
} from '@nestjs/common';
import { Role } from '../prisma/prisma.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { SectionsService } from './sections.service';
import { CreateSectionDto } from './dto/create-section.dto';

@Controller('sections')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SectionsController {
  constructor(private readonly sectionsService: SectionsService) {}

  @Post()
  @Roles(Role.ADMIN)
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: CreateSectionDto) {
    return this.sectionsService.create(dto);
  }

  @Get()
  @Roles(Role.ADMIN, Role.STUDENT)
  @HttpCode(HttpStatus.OK)
  async findAll(
    @Query('semester_id') semesterId?: string,
    @Query('teacher_id') teacherId?: string,
  ) {
    return this.sectionsService.findAll(semesterId, teacherId);
  }

  @Get(':id')
  @Roles(Role.ADMIN, Role.STUDENT)
  @HttpCode(HttpStatus.OK)
  async findById(@Param('id', ParseUUIDPipe) id: string) {
    return this.sectionsService.findById(id);
  }
}
