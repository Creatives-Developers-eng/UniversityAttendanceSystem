import {
  Controller,
  Get,
  Post,
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
import { DepartmentsService } from './departments.service';
import { CreateDepartmentDto } from './dto/create-department.dto';

@Controller('departments')
@UseGuards(JwtAuthGuard, RolesGuard)
export class DepartmentsController {
  constructor(private readonly departmentsService: DepartmentsService) {}

  @Post()
  @Roles(Role.ADMIN)
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: CreateDepartmentDto) {
    return this.departmentsService.create(dto);
  }

  @Get()
  @Roles(Role.ADMIN, Role.STUDENT)
  @HttpCode(HttpStatus.OK)
  async findAll() {
    return this.departmentsService.findAll();
  }

  @Get(':id')
  @Roles(Role.ADMIN, Role.STUDENT)
  @HttpCode(HttpStatus.OK)
  async findById(@Param('id', ParseUUIDPipe) id: string) {
    return this.departmentsService.findById(id);
  }
}
