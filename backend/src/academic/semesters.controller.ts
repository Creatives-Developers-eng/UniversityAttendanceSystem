import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Role } from '../prisma/prisma.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { SemestersService } from './semesters.service';
import { CreateSemesterDto } from './dto/create-semester.dto';

@Controller('semesters')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SemestersController {
  constructor(private readonly semestersService: SemestersService) {}

  @Post()
  @Roles(Role.ADMIN)
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: CreateSemesterDto) {
    return this.semestersService.create(dto);
  }

  @Get()
  @Roles(Role.ADMIN, Role.STUDENT)
  @HttpCode(HttpStatus.OK)
  async findAll(@Query('academic_year_id') academicYearId?: string) {
    return this.semestersService.findAll(academicYearId);
  }
}
