import { Test, TestingModule } from '@nestjs/testing';
import { SessionsService } from './sessions.service';
import { PrismaService, SessionState, Role } from '../prisma/prisma.service';
import {
  NotFoundException,
  BadRequestException,
  ConflictException,
  ForbiddenException,
} from '@nestjs/common';

describe('SessionsService', () => {
  let service: SessionsService;
  let prisma: PrismaService;

  const mockPrisma = {
    section: {
      findUnique: jest.fn(),
    },
    delegate: {
      findUnique: jest.fn(),
    },
    session: {
      findFirst: jest.fn(),
      findUnique: jest.fn(),
      findMany: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    auditLog: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SessionsService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<SessionsService>(SessionsService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('startSession', () => {
    const startDto = {
      section_id: 'sec-123',
      delegate_id: 'del-456',
    };
    const adminUser = { id: 'admin-1', role: Role.ADMIN };

    it('should start a session successfully for admin', async () => {
      mockPrisma.section.findUnique.mockResolvedValue({
        id: 'sec-123',
        teacher_id: 'teacher-1',
        course: { course_code: 'CS101' },
      });

      mockPrisma.delegate.findUnique.mockResolvedValue({
        id: 'del-456',
        section_id: 'sec-123',
        student_id: 'student-1',
        is_active: true,
      });

      mockPrisma.session.findFirst.mockResolvedValue(null);

      mockPrisma.session.create.mockResolvedValue({
        id: 'sess-789',
        section_id: 'sec-123',
        delegate_id: 'del-456',
        session_state: SessionState.Active,
        opened_at: new Date(),
      });

      mockPrisma.auditLog.create.mockResolvedValue({ id: 'audit-1' });

      const result = await service.startSession(startDto, adminUser);

      expect(result.id).toBe('sess-789');
      expect(result.session_state).toBe(SessionState.Active);
      expect(mockPrisma.session.create).toHaveBeenCalled();
    });

    it('should throw NotFoundException if section is not found', async () => {
      mockPrisma.section.findUnique.mockResolvedValue(null);

      await expect(service.startSession(startDto, adminUser)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException if delegate is inactive', async () => {
      mockPrisma.section.findUnique.mockResolvedValue({ id: 'sec-123' });
      mockPrisma.delegate.findUnique.mockResolvedValue({
        id: 'del-456',
        section_id: 'sec-123',
        is_active: false,
      });

      await expect(service.startSession(startDto, adminUser)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw ConflictException if active session already exists', async () => {
      mockPrisma.section.findUnique.mockResolvedValue({
        id: 'sec-123',
        teacher_id: 'teacher-1',
      });
      mockPrisma.delegate.findUnique.mockResolvedValue({
        id: 'del-456',
        section_id: 'sec-123',
        student_id: 'student-1',
        is_active: true,
      });
      mockPrisma.session.findFirst.mockResolvedValue({
        id: 'active-sess-1',
        session_state: SessionState.Active,
      });

      await expect(service.startSession(startDto, adminUser)).rejects.toThrow(
        ConflictException,
      );
    });
  });

  describe('closeSession', () => {
    const closeDto = { session_id: 'sess-789' };
    const adminUser = { id: 'admin-1', role: Role.ADMIN };

    it('should close an active session successfully', async () => {
      mockPrisma.session.findUnique.mockResolvedValue({
        id: 'sess-789',
        session_state: SessionState.Active,
        section: { teacher_id: 'teacher-1' },
        delegate: { student_id: 'student-1' },
      });

      mockPrisma.session.update.mockResolvedValue({
        id: 'sess-789',
        session_state: SessionState.Closed,
        closed_at: new Date(),
        attendances: [],
      });

      mockPrisma.auditLog.create.mockResolvedValue({ id: 'audit-2' });

      const result = await service.closeSession(closeDto, adminUser);

      expect(result.session_state).toBe(SessionState.Closed);
      expect(mockPrisma.session.update).toHaveBeenCalled();
    });

    it('should throw BadRequestException if session is already closed', async () => {
      mockPrisma.session.findUnique.mockResolvedValue({
        id: 'sess-789',
        session_state: SessionState.Closed,
        section: { teacher_id: 'teacher-1' },
        delegate: { student_id: 'student-1' },
      });

      await expect(service.closeSession(closeDto, adminUser)).rejects.toThrow(
        BadRequestException,
      );
    });
  });
});
