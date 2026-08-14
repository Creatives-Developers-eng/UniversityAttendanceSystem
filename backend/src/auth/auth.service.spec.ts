import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { PrismaService, AccountState, Role } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

describe('AuthService', () => {
  let service: AuthService;
  let prismaService: any;
  let jwtService: any;

  const mockUser: any = {
    id: '123e4567-e89b-12d3-a456-426614174000',
    username: 'testadmin',
    email: 'admin@university.edu',
    password_hash: '',
    full_name: 'System Admin',
    phone_number: '+123456789',
    role: Role.ADMIN,
    account_state: AccountState.Active,
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

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
        {
          provide: JwtService,
          useValue: jwtService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
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
      expect(result.account_state).toBe(AccountState.Active);
    });

    it('should throw UnauthorizedException on wrong password', async () => {
      prismaService.user.findUnique.mockResolvedValue(mockUser);

      await expect(
        service.login({ username: 'testadmin', password: 'wrongpassword' }),
      ).rejects.toThrow(UnauthorizedException);
    });

    it('should throw UnauthorizedException on inactive account_state', async () => {
      const inactiveUser = { ...mockUser, account_state: AccountState.Suspended };
      prismaService.user.findUnique.mockResolvedValue(inactiveUser);

      await expect(
        service.login({ username: 'testadmin', password: 'secret123' }),
      ).rejects.toThrow(UnauthorizedException);
    });
  });
});
