import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { SemestersService } from './semesters.service';
import { PrismaService, SemesterType } from '../prisma/prisma.service';

describe('SemestersService', () => {
  let service: SemestersService;
  let prismaService: any;

  const mockSemester = {
    id: 'sem-uuid-1',
    academic_year_id: 'year-uuid-1',
    semester_type: SemesterType.FIRST,
    is_active: true,
  };

  beforeEach(async () => {
    prismaService = {
      academicYear: {
        findUnique: jest.fn(),
      },
      semester: {
        create: jest.fn(),
        findMany: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SemestersService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<SemestersService>(SemestersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create semester successfully when academic year exists', async () => {
    prismaService.academicYear.findUnique.mockResolvedValue({ id: 'year-uuid-1' });
    prismaService.semester.create.mockResolvedValue(mockSemester);

    const result = await service.create({
      academic_year_id: 'year-uuid-1',
      semester_type: SemesterType.FIRST,
    });

    expect(result.semester_type).toBe(SemesterType.FIRST);
  });

  it('should throw NotFoundException if academic year does not exist', async () => {
    prismaService.academicYear.findUnique.mockResolvedValue(null);

    await expect(
      service.create({
        academic_year_id: 'non-existent',
        semester_type: SemesterType.FIRST,
      }),
    ).rejects.toThrow(NotFoundException);
  });
});
