import {
  Injectable,
  ConflictException,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAcademicYearDto } from './dto/create-academic-year.dto';

@Injectable()
export class AcademicYearsService {
  private readonly logger = new Logger(AcademicYearsService.name);

  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateAcademicYearDto) {
    const existing = await this.prisma.academicYear.findUnique({
      where: { year_name: dto.year_name },
    });

    if (existing) {
      throw new ConflictException(
        `Academic year '${dto.year_name}' already exists`,
      );
    }

    const startDate = new Date(dto.start_date);
    const endDate = new Date(dto.end_date);

    if (dto.is_current) {
      return this.prisma.$transaction(async (tx) => {
        await tx.academicYear.updateMany({
          data: { is_current: false },
        });

        const created = await tx.academicYear.create({
          data: {
            year_name: dto.year_name,
            start_date: startDate,
            end_date: endDate,
            is_current: true,
          },
        });

        this.logger.log(
          `Academic year '${created.year_name}' created and set as current`,
        );
        return created;
      });
    }

    const academicYear = await this.prisma.academicYear.create({
      data: {
        year_name: dto.year_name,
        start_date: startDate,
        end_date: endDate,
        is_current: dto.is_current ?? false,
      },
    });

    this.logger.log(`Academic year created: ${academicYear.year_name}`);
    return academicYear;
  }

  async findAll() {
    return this.prisma.academicYear.findMany({
      orderBy: { start_date: 'desc' },
    });
  }

  async setCurrent(id: string) {
    const existing = await this.prisma.academicYear.findUnique({
      where: { id },
    });

    if (!existing) {
      throw new NotFoundException(`Academic year with ID '${id}' not found`);
    }

    return this.prisma.$transaction(async (tx) => {
      await tx.academicYear.updateMany({
        data: { is_current: false },
      });

      const updated = await tx.academicYear.update({
        where: { id },
        data: { is_current: true },
      });

      this.logger.log(
        `Academic year '${updated.year_name}' is now set as current`,
      );
      return updated;
    });
  }
}
