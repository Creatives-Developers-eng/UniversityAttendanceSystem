import {
  Injectable,
  ConflictException,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEnrollmentDto } from './dto/create-enrollment.dto';

@Injectable()
export class EnrollmentsService {
  private readonly logger = new Logger(EnrollmentsService.name);

  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateEnrollmentDto) {
    const student = await this.prisma.student.findUnique({
      where: { id: dto.student_id },
    });

    if (!student) {
      throw new NotFoundException(
        `Student with ID '${dto.student_id}' not found`,
      );
    }

    const section = await this.prisma.section.findUnique({
      where: { id: dto.section_id },
    });

    if (!section) {
      throw new NotFoundException(
        `Section with ID '${dto.section_id}' not found`,
      );
    }

    const existing = await this.prisma.enrollment.findUnique({
      where: {
        student_id_section_id: {
          student_id: dto.student_id,
          section_id: dto.section_id,
        },
      },
    });

    if (existing) {
      throw new ConflictException(
        `Student '${dto.student_id}' is already enrolled in section '${dto.section_id}'`,
      );
    }

    const enrollment = await this.prisma.enrollment.create({
      data: {
        student_id: dto.student_id,
        section_id: dto.section_id,
      },
    });

    this.logger.log(
      `Student ${dto.student_id} enrolled in section ${dto.section_id}`,
    );
    return enrollment;
  }

  async findAll(sectionId?: string, studentId?: string) {
    const where: any = {};
    if (sectionId) where.section_id = sectionId;
    if (studentId) where.student_id = studentId;

    return this.prisma.enrollment.findMany({
      where,
      include: {
        student: true,
        section: true,
      },
    });
  }

  async delete(id: string) {
    const existing = await this.prisma.enrollment.findUnique({
      where: { id },
    });

    if (!existing) {
      throw new NotFoundException(`Enrollment with ID '${id}' not found`);
    }

    await this.prisma.enrollment.delete({
      where: { id },
    });

    this.logger.log(`Enrollment ${id} removed successfully`);
    return {
      message: `Enrollment '${id}' deleted successfully`,
    };
  }
}
