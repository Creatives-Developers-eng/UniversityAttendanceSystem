import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { CoursesService } from './courses.service';
import { PrismaService } from '../prisma/prisma.service';

describe('CoursesService', () => {
  let service: CoursesService;
  let prismaService: any;

  const mockCourse = {
    id: 'course-uuid-1',
    course_code: 'CS101',
    title: 'Introduction to Computer Science',
    department_id: 'dept-uuid-1',
    credit_hours: 3,
  };

  beforeEach(async () => {
    prismaService = {
      course: {
        findUnique: jest.fn(),
        create: jest.fn(),
        findMany: jest.fn(),
      },
      department: {
        findUnique: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CoursesService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<CoursesService>(CoursesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create course successfully', async () => {
    prismaService.course.findUnique.mockResolvedValue(null);
    prismaService.department.findUnique.mockResolvedValue({ id: 'dept-uuid-1' });
    prismaService.course.create.mockResolvedValue(mockCourse);

    const result = await service.create({
      course_code: 'CS101',
      title: 'Introduction to Computer Science',
      department_id: 'dept-uuid-1',
      credit_hours: 3,
    });

    expect(result.course_code).toBe('CS101');
  });

  it('should throw ConflictException if course_code exists', async () => {
    prismaService.course.findUnique.mockResolvedValue(mockCourse);

    await expect(
      service.create({
        course_code: 'CS101',
        title: 'Introduction to Computer Science',
        department_id: 'dept-uuid-1',
        credit_hours: 3,
      }),
    ).rejects.toThrow(ConflictException);
  });

  it('should throw NotFoundException if department does not exist', async () => {
    prismaService.course.findUnique.mockResolvedValue(null);
    prismaService.department.findUnique.mockResolvedValue(null);

    await expect(
      service.create({
        course_code: 'CS101',
        title: 'Introduction to Computer Science',
        department_id: 'non-existent',
        credit_hours: 3,
      }),
    ).rejects.toThrow(NotFoundException);
  });
});
