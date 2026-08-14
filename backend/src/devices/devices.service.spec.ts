import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { DevicesService } from './devices.service';
import {
  PrismaService,
  CodeState,
  DeviceState,
  Role,
} from '../prisma/prisma.service';

describe('DevicesService', () => {
  let service: DevicesService;
  let prismaService: any;

  const mockUser = {
    id: '123e4567-e89b-12d3-a456-426614174000',
    username: 'teststudent',
  };

  const mockActivationCode = {
    id: 'code-uuid-123',
    user_id: mockUser.id,
    code: '123456',
    code_state: CodeState.Generated,
    expires_at: new Date(Date.now() + 3600000), // 1 hour in future
    used_at: null,
    user: mockUser,
  };

  const mockDevice = {
    id: 'device-uuid-999',
    user_id: mockUser.id,
    device_identifier: 'device-id-abc',
    device_fingerprint: 'fingerprint-xyz',
    device_state: DeviceState.Bound,
    bound_at: new Date(),
  };

  beforeEach(async () => {
    prismaService = {
      user: {
        findUnique: jest.fn(),
      },
      activationCode: {
        create: jest.fn(),
        findFirst: jest.fn(),
        update: jest.fn(),
      },
      device: {
        upsert: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DevicesService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<DevicesService>(DevicesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createActivationCode', () => {
    it('should generate activation code for existing user', async () => {
      prismaService.user.findUnique.mockResolvedValue(mockUser);
      prismaService.activationCode.create.mockResolvedValue(mockActivationCode);

      const result = await service.createActivationCode({
        user_id: mockUser.id,
      });

      expect(result).toHaveProperty('code', '123456');
      expect(result.code_state).toBe(CodeState.Generated);
    });

    it('should throw NotFoundException if user does not exist', async () => {
      prismaService.user.findUnique.mockResolvedValue(null);

      await expect(
        service.createActivationCode({ user_id: 'non-existent-id' }),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('bindDevice', () => {
    it('should bind device successfully with valid activation code', async () => {
      prismaService.activationCode.findFirst.mockResolvedValue(mockActivationCode);
      prismaService.activationCode.update.mockResolvedValue({
        ...mockActivationCode,
        code_state: CodeState.Used,
      });
      prismaService.device.upsert.mockResolvedValue(mockDevice);

      const result = await service.bindDevice({
        code: '123456',
        device_identifier: 'device-id-abc',
        device_fingerprint: 'fingerprint-xyz',
      });

      expect(result.device_state).toBe(DeviceState.Bound);
      expect(result).toHaveProperty('device_id');
    });

    it('should throw BadRequestException if activation code is invalid', async () => {
      prismaService.activationCode.findFirst.mockResolvedValue(null);

      await expect(
        service.bindDevice({
          code: '999999',
          device_identifier: 'device-id-abc',
          device_fingerprint: 'fingerprint-xyz',
        }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException if activation code has expired', async () => {
      const expiredCode = {
        ...mockActivationCode,
        expires_at: new Date(Date.now() - 3600000), // 1 hour in past
      };
      prismaService.activationCode.findFirst.mockResolvedValue(expiredCode);

      await expect(
        service.bindDevice({
          code: '123456',
          device_identifier: 'device-id-abc',
          device_fingerprint: 'fingerprint-xyz',
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
