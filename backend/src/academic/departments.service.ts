import {
  Injectable,
  ConflictException,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateDepartmentDto } from './dto/create-department.dto';

@Injectable()
export class DepartmentsService {
  private readonly logger = new Logger(DepartmentsService.name);

  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateDepartmentDto) {
    const existing = await this.prisma.department.findUnique({
      where: { code: dto.code },
    });

    if (existing) {
      throw new ConflictException(
        `Department with code '${dto.code}' already exists`,
      );
    }

    const department = await this.prisma.department.create({
      data: {
        code: dto.code,
        name: dto.name,
      },
    });

    this.logger.log(`Department created: ${department.code}`);
    return department;
  }

  async findAll() {
    return this.prisma.department.findMany({
      orderBy: { created_at: 'desc' },
    });
  }

  async findById(id: string) {
    const department = await this.prisma.department.findUnique({
      where: { id },
    });

    if (!department) {
      throw new NotFoundException(`Department with ID '${id}' not found`);
    }

    return department;
  }
}
