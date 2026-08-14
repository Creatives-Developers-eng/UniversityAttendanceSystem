"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const devices_service_1 = require("./devices.service");
const prisma_service_1 = require("../prisma/prisma.service");
describe('DevicesService', () => {
    let service;
    let prismaService;
    const mockUser = {
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'teststudent',
    };
    const mockActivationCode = {
        id: 'code-uuid-123',
        user_id: mockUser.id,
        code: '123456',
        code_state: prisma_service_1.CodeState.Generated,
        expires_at: new Date(Date.now() + 3600000),
        used_at: null,
        user: mockUser,
    };
    const mockDevice = {
        id: 'device-uuid-999',
        user_id: mockUser.id,
        device_identifier: 'device-id-abc',
        device_fingerprint: 'fingerprint-xyz',
        device_state: prisma_service_1.DeviceState.Bound,
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
        const module = await testing_1.Test.createTestingModule({
            providers: [
                devices_service_1.DevicesService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
            ],
        }).compile();
        service = module.get(devices_service_1.DevicesService);
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
            expect(result.code_state).toBe(prisma_service_1.CodeState.Generated);
        });
        it('should throw NotFoundException if user does not exist', async () => {
            prismaService.user.findUnique.mockResolvedValue(null);
            await expect(service.createActivationCode({ user_id: 'non-existent-id' })).rejects.toThrow(common_1.NotFoundException);
        });
    });
    describe('bindDevice', () => {
        it('should bind device successfully with valid activation code', async () => {
            prismaService.activationCode.findFirst.mockResolvedValue(mockActivationCode);
            prismaService.activationCode.update.mockResolvedValue({
                ...mockActivationCode,
                code_state: prisma_service_1.CodeState.Used,
            });
            prismaService.device.upsert.mockResolvedValue(mockDevice);
            const result = await service.bindDevice({
                code: '123456',
                device_identifier: 'device-id-abc',
                device_fingerprint: 'fingerprint-xyz',
            });
            expect(result.device_state).toBe(prisma_service_1.DeviceState.Bound);
            expect(result).toHaveProperty('device_id');
        });
        it('should throw BadRequestException if activation code is invalid', async () => {
            prismaService.activationCode.findFirst.mockResolvedValue(null);
            await expect(service.bindDevice({
                code: '999999',
                device_identifier: 'device-id-abc',
                device_fingerprint: 'fingerprint-xyz',
            })).rejects.toThrow(common_1.BadRequestException);
        });
        it('should throw BadRequestException if activation code has expired', async () => {
            const expiredCode = {
                ...mockActivationCode,
                expires_at: new Date(Date.now() - 3600000),
            };
            prismaService.activationCode.findFirst.mockResolvedValue(expiredCode);
            await expect(service.bindDevice({
                code: '123456',
                device_identifier: 'device-id-abc',
                device_fingerprint: 'fingerprint-xyz',
            })).rejects.toThrow(common_1.BadRequestException);
        });
    });
});
//# sourceMappingURL=devices.service.spec.js.map