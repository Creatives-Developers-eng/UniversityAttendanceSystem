import { Test, TestingModule } from '@nestjs/testing';
import { AuditService } from './audit.service';
import { PrismaService } from '../prisma/prisma.service';
import { NotFoundException } from '@nestjs/common';

describe('AuditService', () => {
  let service: AuditService;
  let prisma: PrismaService;

  const mockPrisma = {
    auditLog: {
      create: jest.fn(),
      count: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      groupBy: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuditService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<AuditService>(AuditService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('logAction', () => {
    it('should record an audit log action and sanitize sensitive fields', async () => {
      const params = {
        userId: 'user-1',
        action: 'USER_LOGIN',
        entityType: 'User',
        entityId: 'user-1',
        payload: { username: 'admin', password: 'secretpassword', token: 'jwt' },
        ipAddress: '192.168.1.1',
      };

      const expectedCreated = {
        id: 'audit-1',
        user_id: 'user-1',
        action: 'USER_LOGIN',
        entity_type: 'User',
      };

      mockPrisma.auditLog.create.mockResolvedValue(expectedCreated);

      const result = await service.logAction(params);

      expect(result).toEqual(expectedCreated);
      expect(mockPrisma.auditLog.create).toHaveBeenCalledWith({
        data: {
          user_id: 'user-1',
          action: 'USER_LOGIN',
          entity_type: 'User',
          entity_id: 'user-1',
          payload: JSON.stringify({
            username: 'admin',
            _client_ip: '192.168.1.1',
          }),
        },
      });
    });
  });

  describe('getLogs', () => {
    it('should return paginated audit logs', async () => {
      mockPrisma.auditLog.count.mockResolvedValue(2);
      mockPrisma.auditLog.findMany.mockResolvedValue([
        { id: 'log-1', action: 'SESSION_START' },
        { id: 'log-2', action: 'SESSION_CLOSE' },
      ]);

      const result = await service.getLogs({ page: 1, limit: 10 });

      expect(result.total).toBe(2);
      expect(result.logs.length).toBe(2);
      expect(result.total_pages).toBe(1);
    });
  });

  describe('getLogById', () => {
    it('should return single log if found', async () => {
      mockPrisma.auditLog.findUnique.mockResolvedValue({
        id: 'log-1',
        action: 'SESSION_START',
      });

      const result = await service.getLogById('log-1');
      expect(result.id).toBe('log-1');
    });

    it('should throw NotFoundException if log is not found', async () => {
      mockPrisma.auditLog.findUnique.mockResolvedValue(null);

      await expect(service.getLogById('log-999')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
