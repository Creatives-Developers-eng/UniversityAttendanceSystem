import { Test, TestingModule } from '@nestjs/testing';
import { JustificationsService } from './justifications.service';
import { PrismaService, Role, AttendanceState } from '../prisma/prisma.service';
import { NotFoundException, BadRequestException, ForbiddenException } from '@nestjs/common';

describe('JustificationsService', () => {
  let service: JustificationsService;
  let prisma: PrismaService;

  const mockPrisma = {
    student: {
      findUnique: jest.fn(),
    },
    session: {
      findUnique: jest.fn(),
    },
    section: {
      findUnique: jest.fn(),
    },
    enrollment: {
      findUnique: jest.fn(),
    },
    attendance: {
      upsert: jest.fn(),
    },
    auditLog: {
      create: jest.fn(),
      findUnique: jest.fn(),
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        JustificationsService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<JustificationsService>(JustificationsService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('submitJustification', () => {
    const studentId = 'stud-1';
    const dto = {
      session_id: 'sess-1',
      reason: 'Medical emergency',
      document_url: 'https://docs.example.com/med.pdf',
    };
    const user = { id: studentId, role: Role.STUDENT };

    it('should submit justification successfully for enrolled student', async () => {
      mockPrisma.student.findUnique.mockResolvedValue({
        id: studentId,
        student_number: 'STU001',
        user: { full_name: 'Owab' },
      });

      mockPrisma.session.findUnique.mockResolvedValue({
        id: 'sess-1',
        section_id: 'sec-1',
      });

      mockPrisma.enrollment.findUnique.mockResolvedValue({
        id: 'enr-1',
      });

      mockPrisma.auditLog.create.mockResolvedValue({
        id: 'just-1',
      });

      const result = await service.submitJustification(studentId, dto, user);

      expect(result.justification_id).toBe('just-1');
      expect(result.status).toBe('PENDING');
      expect(mockPrisma.auditLog.create).toHaveBeenCalled();
    });

    it('should throw BadRequestException if student is not enrolled', async () => {
      mockPrisma.student.findUnique.mockResolvedValue({
        id: studentId,
        student_number: 'STU001',
        user: { full_name: 'Owab' },
      });

      mockPrisma.session.findUnique.mockResolvedValue({
        id: 'sess-1',
        section_id: 'sec-1',
      });

      mockPrisma.enrollment.findUnique.mockResolvedValue(null);

      await expect(service.submitJustification(studentId, dto, user)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('reviewJustification', () => {
    const reviewer = { id: 'teacher-1', role: Role.TEACHER };

    it('should approve justification and update attendance state to Excused', async () => {
      mockPrisma.auditLog.findUnique.mockResolvedValue({
        id: 'just-1',
        entity_type: 'Justification',
        payload: JSON.stringify({
          student_id: 'stud-1',
          session_id: 'sess-1',
          section_id: 'sec-1',
        }),
      });

      mockPrisma.section.findUnique.mockResolvedValue({
        id: 'sec-1',
        teacher_id: 'teacher-1',
      });

      mockPrisma.attendance.upsert.mockResolvedValue({
        id: 'att-1',
        attendance_state: AttendanceState.Excused,
      });

      mockPrisma.auditLog.create.mockResolvedValue({ id: 'review-audit-1' });

      const result = await service.reviewJustification(
        'just-1',
        { status: 'APPROVED', notes: 'Approved with medical certificate' },
        reviewer,
      );

      expect(result.status).toBe('APPROVED');
      expect(mockPrisma.attendance.upsert).toHaveBeenCalled();
    });
  });
});
