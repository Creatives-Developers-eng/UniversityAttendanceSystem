import { Test, TestingModule } from '@nestjs/testing';
import { BiometricsService } from './biometrics.service';
import { BiometricsCryptoService } from './biometrics-crypto.service';
import { PrismaService, Role } from '../../prisma/prisma.service';
import { NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';

describe('BiometricsService', () => {
  let service: BiometricsService;
  let prisma: PrismaService;
  let cryptoService: BiometricsCryptoService;

  const validHash = 'a'.repeat(64);

  const mockPrisma = {
    student: {
      findUnique: jest.fn(),
    },
    section: {
      findUnique: jest.fn(),
    },
    enrollment: {
      findMany: jest.fn(),
    },
    biometricTemplate: {
      upsert: jest.fn(),
      findUnique: jest.fn(),
      delete: jest.fn(),
    },
    auditLog: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BiometricsService,
        BiometricsCryptoService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<BiometricsService>(BiometricsService);
    prisma = module.get<PrismaService>(PrismaService);
    cryptoService = module.get<BiometricsCryptoService>(BiometricsCryptoService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('enrollTemplate', () => {
    const studentId = 'stud-123';
    const dto = {
      template_hash: validHash,
      encrypted_template_data: 'encrypted-aes256-data',
    };
    const adminUser = { id: 'admin-1', role: Role.ADMIN };

    it('should enroll biometric template successfully for student by admin', async () => {
      mockPrisma.student.findUnique.mockResolvedValue({
        id: studentId,
        student_number: 'STU001',
        user: { full_name: 'Owab Al-Nazili' },
      });

      mockPrisma.biometricTemplate.upsert.mockResolvedValue({
        id: 'tmpl-1',
        student_id: studentId,
        template_hash: validHash,
        created_at: new Date(),
      });

      mockPrisma.auditLog.create.mockResolvedValue({ id: 'audit-1' });

      const result = await service.enrollTemplate(studentId, dto, adminUser);

      expect(result.student_id).toBe(studentId);
      expect(result.template_hash).toBe(validHash);
      expect(mockPrisma.biometricTemplate.upsert).toHaveBeenCalled();
    });

    it('should throw NotFoundException if student is not found', async () => {
      mockPrisma.student.findUnique.mockResolvedValue(null);

      await expect(service.enrollTemplate(studentId, dto, adminUser)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if student tries to enroll for another student', async () => {
      mockPrisma.student.findUnique.mockResolvedValue({
        id: studentId,
        student_number: 'STU001',
        user: { full_name: 'Owab' },
      });

      const unauthorizedStudent = { id: 'another-student', role: Role.STUDENT };

      await expect(
        service.enrollTemplate(studentId, dto, unauthorizedStudent),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw BadRequestException if hash format is invalid', async () => {
      mockPrisma.student.findUnique.mockResolvedValue({
        id: studentId,
        student_number: 'STU001',
        user: { full_name: 'Owab' },
      });

      const invalidDto = {
        template_hash: 'short-hash',
        encrypted_template_data: 'data',
      };

      await expect(
        service.enrollTemplate(studentId, invalidDto, adminUser),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('getSectionBiometrics', () => {
    const sectionId = 'sec-123';
    const teacherUser = { id: 'teacher-1', role: Role.TEACHER };

    it('should export biometric templates for authorized teacher', async () => {
      mockPrisma.section.findUnique.mockResolvedValue({
        id: sectionId,
        teacher_id: 'teacher-1',
        delegates: [],
      });

      mockPrisma.enrollment.findMany.mockResolvedValue([
        {
          student: {
            id: 'stud-1',
            student_number: 'STU001',
            user: { full_name: 'Student One', username: 'stu1' },
            biometric_template: {
              template_hash: validHash,
              encrypted_template_data: 'enc-data-1',
              created_at: new Date(),
            },
          },
        },
      ]);

      const result = await service.getSectionBiometrics(sectionId, teacherUser);

      expect(result.section_id).toBe(sectionId);
      expect(result.templates_count).toBe(1);
      expect(result.templates[0].encrypted_template_data).toBe('enc-data-1');
    });

    it('should throw ForbiddenException if user is not teacher or delegate of section', async () => {
      mockPrisma.section.findUnique.mockResolvedValue({
        id: sectionId,
        teacher_id: 'teacher-other',
        delegates: [{ student_id: 'del-other', is_active: true }],
      });

      const unauthorizedUser = { id: 'random-student', role: Role.STUDENT };

      await expect(
        service.getSectionBiometrics(sectionId, unauthorizedUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });
});
