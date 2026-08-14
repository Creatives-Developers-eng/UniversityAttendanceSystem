import {
  Injectable,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSemesterDto } from './dto/create-semester.dto';

@Injectable()
export class SemestersService {
  private readonly logger = new Logger(SemestersService.name);

  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateSemesterDto) {
    const academicYear = await this.prisma.academicYear.findUnique({
      where: { id: dto.academic_year_id },
    });

    if (!academicYear) {
      throw new NotFoundException(
        `Academic year with ID '${dto.academic_year_id}' not found`,
      );
    }

    const semester = await this.prisma.semester.create({
      data: {
        academic_year_id: dto.academic_year_id,
        semester_type: dto.semester_type,
        is_active: dto.is_active ?? false,
      },
    });

    this.logger.log(`Semester created for academic year ${dto.academic_year_id}`);
    return semester;
  }

  async findAll(academicYearId?: string) {
    const where = academicYearId ? { academic_year_id: academicYearId } : {};
    return this.prisma.semester.findMany({
      where,
      include: {
        academic_year: true,
      },
    });
  }
}
