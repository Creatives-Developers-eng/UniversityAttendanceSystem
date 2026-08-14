import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { SectionsService } from './sections.service';
import { PrismaService, SectionType } from '../prisma/prisma.service';

describe('SectionsService', () => {
  let service: SectionsService;
  let prismaService: any;

  const mockSection = {
    id: 'section-uuid-1',
    course_id: 'course-uuid-1',
    semester_id: 'sem-uuid-1',
    teacher_id: 'teacher-uuid-1',
    section_type: SectionType.THEORETICAL,
    section_number: 'SEC01',
  };

  beforeEach(async () => {
    prismaService = {
      course: { findUnique: jest.fn() },
      semester: { findUnique: jest.fn() },
      teacher: { findUnique: jest.fn() },
      section: {
        create: jest.fn(),
        findMany: jest.fn(),
        findUnique: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SectionsService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<SectionsService>(SectionsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create section successfully when all FKs exist', async () => {
    prismaService.course.findUnique.mockResolvedValue({ id: 'course-uuid-1' });
    prismaService.semester.findUnique.mockResolvedValue({ id: 'sem-uuid-1' });
    prismaService.teacher.findUnique.mockResolvedValue({ id: 'teacher-uuid-1' });
    prismaService.section.create.mockResolvedValue(mockSection);

    const result = await service.create({
      course_id: 'course-uuid-1',
      semester_id: 'sem-uuid-1',
      teacher_id: 'teacher-uuid-1',
      section_type: SectionType.THEORETICAL,
      section_number: 'SEC01',
    });

    expect(result.section_number).toBe('SEC01');
  });

  it('should throw NotFoundException if course FK missing', async () => {
    prismaService.course.findUnique.mockResolvedValue(null);

    await expect(
      service.create({
        course_id: 'non-existent',
        semester_id: 'sem-uuid-1',
        teacher_id: 'teacher-uuid-1',
        section_type: SectionType.THEORETICAL,
        section_number: 'SEC01',
      }),
    ).rejects.toThrow(NotFoundException);
  });

  it('should throw NotFoundException if section id not found on findById', async () => {
    prismaService.section.findUnique.mockResolvedValue(null);

    await expect(service.findById('non-existent')).rejects.toThrow(
      NotFoundException,
    );
  });
});
