import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { EnrollmentsService } from './enrollments.service';
import { PrismaService } from '../prisma/prisma.service';

describe('EnrollmentsService', () => {
  let service: EnrollmentsService;
  let prismaService: any;

  const mockEnrollment = {
    id: 'enrollment-uuid-1',
    student_id: 'student-uuid-1',
    section_id: 'section-uuid-1',
    enrolled_at: new Date(),
  };

  beforeEach(async () => {
    prismaService = {
      student: { findUnique: jest.fn() },
      section: { findUnique: jest.fn() },
      enrollment: {
        findUnique: jest.fn(),
        create: jest.fn(),
        findMany: jest.fn(),
        delete: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EnrollmentsService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<EnrollmentsService>(EnrollmentsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create enrollment successfully', async () => {
    prismaService.student.findUnique.mockResolvedValue({ id: 'student-uuid-1' });
    prismaService.section.findUnique.mockResolvedValue({ id: 'section-uuid-1' });
    prismaService.enrollment.findUnique.mockResolvedValue(null);
    prismaService.enrollment.create.mockResolvedValue(mockEnrollment);

    const result = await service.create({
      student_id: 'student-uuid-1',
      section_id: 'section-uuid-1',
    });

    expect(result.id).toBe('enrollment-uuid-1');
  });

  it('should throw ConflictException on duplicate enrollment for same student and section', async () => {
    prismaService.student.findUnique.mockResolvedValue({ id: 'student-uuid-1' });
    prismaService.section.findUnique.mockResolvedValue({ id: 'section-uuid-1' });
    prismaService.enrollment.findUnique.mockResolvedValue(mockEnrollment);

    await expect(
      service.create({
        student_id: 'student-uuid-1',
        section_id: 'section-uuid-1',
      }),
    ).rejects.toThrow(ConflictException);
  });

  it('should delete enrollment successfully', async () => {
    prismaService.enrollment.findUnique.mockResolvedValue(mockEnrollment);
    prismaService.enrollment.delete.mockResolvedValue(mockEnrollment);

    const result = await service.delete('enrollment-uuid-1');
    expect(result.message).toContain('deleted successfully');
  });

  it('should throw NotFoundException on delete non-existent enrollment', async () => {
    prismaService.enrollment.findUnique.mockResolvedValue(null);

    await expect(service.delete('non-existent')).rejects.toThrow(
      NotFoundException,
    );
  });
});
