import {
  Injectable,
  ConflictException,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCourseDto } from './dto/create-course.dto';

@Injectable()
export class CoursesService {
  private readonly logger = new Logger(CoursesService.name);

  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateCourseDto) {
    const existing = await this.prisma.course.findUnique({
      where: { course_code: dto.course_code },
    });

    if (existing) {
      throw new ConflictException(
        `Course with code '${dto.course_code}' already exists`,
      );
    }

    const department = await this.prisma.department.findUnique({
      where: { id: dto.department_id },
    });

    if (!department) {
      throw new NotFoundException(
        `Department with ID '${dto.department_id}' not found`,
      );
    }

    const course = await this.prisma.course.create({
      data: {
        course_code: dto.course_code,
        title: dto.title,
        department_id: dto.department_id,
        credit_hours: dto.credit_hours,
      },
    });

    this.logger.log(`Course created: ${course.course_code}`);
    return course;
  }

  async findAll(departmentId?: string) {
    const where = departmentId ? { department_id: departmentId } : {};
    return this.prisma.course.findMany({
      where,
      include: {
        department: true,
      },
    });
  }
}
