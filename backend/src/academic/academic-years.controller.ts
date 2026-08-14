import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
} from '@nestjs/common';
import { Role } from '../prisma/prisma.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { AcademicYearsService } from './academic-years.service';
import { CreateAcademicYearDto } from './dto/create-academic-year.dto';

@Controller('academic-years')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AcademicYearsController {
  constructor(private readonly academicYearsService: AcademicYearsService) {}

  @Post()
  @Roles(Role.ADMIN)
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: CreateAcademicYearDto) {
    return this.academicYearsService.create(dto);
  }

  @Get()
  @Roles(Role.ADMIN, Role.STUDENT)
  @HttpCode(HttpStatus.OK)
  async findAll() {
    return this.academicYearsService.findAll();
  }

  @Patch(':id/current')
  @Roles(Role.ADMIN)
  @HttpCode(HttpStatus.OK)
  async setCurrent(@Param('id', ParseUUIDPipe) id: string) {
    return this.academicYearsService.setCurrent(id);
  }
}
