"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const jwt_1 = require("@nestjs/jwt");
const common_1 = require("@nestjs/common");
const auth_service_1 = require("./auth.service");
const prisma_service_1 = require("../prisma/prisma.service");
const bcrypt = require("bcrypt");
describe('AuthService', () => {
    let service;
    let prismaService;
    let jwtService;
    const mockUser = {
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'testadmin',
        email: 'admin@university.edu',
        password_hash: '',
        full_name: 'System Admin',
        phone_number: '+123456789',
        role: prisma_service_1.Role.ADMIN,
        account_state: prisma_service_1.AccountState.Active,
        created_at: new Date(),
        updated_at: new Date(),
    };
    beforeEach(async () => {
        mockUser.password_hash = await bcrypt.hash('secret123', 12);
        prismaService = {
            user: {
                findUnique: jest.fn(),
            },
        };
        jwtService = {
            sign: jest.fn().mockReturnValue('mocked_token'),
            verify: jest.fn(),
        };
        const module = await testing_1.Test.createTestingModule({
            providers: [
                auth_service_1.AuthService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
                {
                    provide: jwt_1.JwtService,
                    useValue: jwtService,
                },
            ],
        }).compile();
        service = module.get(auth_service_1.AuthService);
    });
    it('should be defined', () => {
        expect(service).toBeDefined();
    });
    describe('login', () => {
        it('should successfully authenticate user with correct credentials and active state', async () => {
            prismaService.user.findUnique.mockResolvedValue(mockUser);
            const result = await service.login({
                username: 'testadmin',
                password: 'secret123',
            });
            expect(result).toHaveProperty('access_token', 'mocked_token');
            expect(result).toHaveProperty('refresh_token', 'mocked_token');
            expect(result.username).toBe('testadmin');
            expect(result.account_state).toBe(prisma_service_1.AccountState.Active);
        });
        it('should throw UnauthorizedException on wrong password', async () => {
            prismaService.user.findUnique.mockResolvedValue(mockUser);
            await expect(service.login({ username: 'testadmin', password: 'wrongpassword' })).rejects.toThrow(common_1.UnauthorizedException);
        });
        it('should throw UnauthorizedException on inactive account_state', async () => {
            const inactiveUser = { ...mockUser, account_state: prisma_service_1.AccountState.Suspended };
            prismaService.user.findUnique.mockResolvedValue(inactiveUser);
            await expect(service.login({ username: 'testadmin', password: 'secret123' })).rejects.toThrow(common_1.UnauthorizedException);
        });
    });
});
//# sourceMappingURL=auth.service.spec.js.map