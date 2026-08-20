import { Test, TestingModule } from '@nestjs/testing';
import { AttendanceService } from './attendance.service';
import {
  PrismaService,
  SessionState,
  SyncState,
  AttendanceState,
  AttendanceMethod,
  Role,
} from '../prisma/prisma.service';
import { NotFoundException, ForbiddenException } from '@nestjs/common';

describe('AttendanceService', () => {
  let service: AttendanceService;
  let prisma: PrismaService;

  const mockPrisma = {
    session: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    attendance: {
      upsert: jest.fn(),
      findMany: jest.fn(),
    },
    attendanceRequest: {
      upsert: jest.fn(),
    },
    syncRecord: {
      create: jest.fn(),
    },
    auditLog: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AttendanceService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<AttendanceService>(AttendanceService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('syncAttendance', () => {
    const syncDto = {
      session_id: 'sess-1',
      delegate_id: 'del-1',
      records: [
        {
          request_id: 'req-1',
          student_id: 'stud-1',
          attendance_state: AttendanceState.Present,
          attendance_method: AttendanceMethod.QR,
          nonce: 'nonce-123',
          timestamp: 1700000000,
        },
        {
          request_id: 'req-2',
          student_id: 'stud-2',
          attendance_state: AttendanceState.Present,
          attendance_method: AttendanceMethod.Biometric,
          nonce: 'nonce-456',
          timestamp: 1700000005,
        },
      ],
    };

    const adminUser = { id: 'admin-1', role: Role.ADMIN };

    it('should sync attendance batch successfully with idempotency', async () => {
      mockPrisma.session.findUnique.mockResolvedValue({
        id: 'sess-1',
        session_state: SessionState.Active,
        section: { teacher_id: 'teacher-1' },
        delegate: { student_id: 'del-student-1' },
      });

      mockPrisma.attendance.upsert.mockResolvedValue({ id: 'att-1' });
      mockPrisma.attendanceRequest.upsert.mockResolvedValue({ id: 'req-1' });
      mockPrisma.syncRecord.create.mockResolvedValue({
        id: 'sync-1',
        synced_at: new Date(),
      });
      mockPrisma.session.update.mockResolvedValue({ id: 'sess-1' });
      mockPrisma.auditLog.create.mockResolvedValue({ id: 'audit-1' });

      const result = await service.syncAttendance(syncDto, adminUser);

      expect(result.success).toBe(true);
      expect(result.synced_records_count).toBe(2);
      expect(mockPrisma.attendance.upsert).toHaveBeenCalledTimes(2);
      expect(mockPrisma.syncRecord.create).toHaveBeenCalled();
    });

    it('should throw NotFoundException if session is not found', async () => {
      mockPrisma.session.findUnique.mockResolvedValue(null);

      await expect(service.syncAttendance(syncDto, adminUser)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if user is not authorized', async () => {
      mockPrisma.session.findUnique.mockResolvedValue({
        id: 'sess-1',
        session_state: SessionState.Active,
        section: { teacher_id: 'teacher-1' },
        delegate: { student_id: 'del-student-1' },
      });

      const unauthorizedUser = { id: 'random-user', role: Role.STUDENT };

      await expect(
        service.syncAttendance(syncDto, unauthorizedUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('manualAttendance', () => {
    const manualDto = {
      session_id: 'sess-1',
      student_id: 'stud-1',
      attendance_state: AttendanceState.Excused,
      reason: 'Medical excuse provided',
    };

    const teacherUser = { id: 'teacher-1', role: Role.TEACHER };

    it('should mark manual attendance successfully by section teacher', async () => {
      mockPrisma.session.findUnique.mockResolvedValue({
        id: 'sess-1',
        section: { teacher_id: 'teacher-1' },
      });

      mockPrisma.attendance.upsert.mockResolvedValue({
        id: 'att-1',
        session_id: 'sess-1',
        student_id: 'stud-1',
        attendance_state: AttendanceState.Excused,
        attendance_method: AttendanceMethod.Manual,
      });

      mockPrisma.auditLog.create.mockResolvedValue({ id: 'audit-2' });

      const result = await service.manualAttendance(manualDto, teacherUser);

      expect(result.attendance_state).toBe(AttendanceState.Excused);
      expect(result.attendance_method).toBe(AttendanceMethod.Manual);
      expect(mockPrisma.attendance.upsert).toHaveBeenCalled();
    });
  });
});
