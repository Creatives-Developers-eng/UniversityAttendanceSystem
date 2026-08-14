import {
  Injectable,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSectionDto } from './dto/create-section.dto';

@Injectable()
export class SectionsService {
  private readonly logger = new Logger(SectionsService.name);

  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateSectionDto) {
    const course = await this.prisma.course.findUnique({
      where: { id: dto.course_id },
    });

    if (!course) {
      throw new NotFoundException(
        `Course with ID '${dto.course_id}' not found`,
      );
    }

    const semester = await this.prisma.semester.findUnique({
      where: { id: dto.semester_id },
    });

    if (!semester) {
      throw new NotFoundException(
        `Semester with ID '${dto.semester_id}' not found`,
      );
    }

    const teacher = await this.prisma.teacher.findUnique({
      where: { id: dto.teacher_id },
    });

    if (!teacher) {
      throw new NotFoundException(
        `Teacher with ID '${dto.teacher_id}' not found`,
      );
    }

    const section = await this.prisma.section.create({
      data: {
        course_id: dto.course_id,
        semester_id: dto.semester_id,
        teacher_id: dto.teacher_id,
        section_type: dto.section_type,
        section_number: dto.section_number,
      },
    });

    this.logger.log(
      `Section '${section.section_number}' created for course ${dto.course_id}`,
    );
    return section;
  }

  async findAll(semesterId?: string, teacherId?: string) {
    const where: any = {};
    if (semesterId) where.semester_id = semesterId;
    if (teacherId) where.teacher_id = teacherId;

    return this.prisma.section.findMany({
      where,
      include: {
        course: true,
        semester: true,
        teacher: true,
      },
    });
  }

  async findById(id: string) {
    const section = await this.prisma.section.findUnique({
      where: { id },
      include: {
        course: true,
        semester: true,
        teacher: true,
      },
    });

    if (!section) {
      throw new NotFoundException(`Section with ID '${id}' not found`);
    }

    return section;
  }
}
