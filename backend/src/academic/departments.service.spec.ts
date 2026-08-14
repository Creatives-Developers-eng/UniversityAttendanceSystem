import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { DepartmentsService } from './departments.service';
import { PrismaService } from '../prisma/prisma.service';

describe('DepartmentsService', () => {
  let service: DepartmentsService;
  let prismaService: any;

  const mockDepartment = {
    id: 'dept-uuid-1',
    code: 'CS',
    name: 'Computer Science',
    is_active: true,
    created_at: new Date(),
  };

  beforeEach(async () => {
    prismaService = {
      department: {
        findUnique: jest.fn(),
        create: jest.fn(),
        findMany: jest.fn(),
      },
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DepartmentsService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<DepartmentsService>(DepartmentsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create department successfully', async () => {
    prismaService.department.findUnique.mockResolvedValue(null);
    prismaService.department.create.mockResolvedValue(mockDepartment);

    const result = await service.create({
      code: 'CS',
      name: 'Computer Science',
    });

    expect(result.code).toBe('CS');
    expect(result).toHaveProperty('id');
  });

  it('should throw ConflictException if department code exists', async () => {
    prismaService.department.findUnique.mockResolvedValue(mockDepartment);

    await expect(
      service.create({ code: 'CS', name: 'Computer Science' }),
    ).rejects.toThrow(ConflictException);
  });

  it('should return department by id', async () => {
    prismaService.department.findUnique.mockResolvedValue(mockDepartment);

    const result = await service.findById('dept-uuid-1');
    expect(result.id).toBe('dept-uuid-1');
  });

  it('should throw NotFoundException if id not found', async () => {
    prismaService.department.findUnique.mockResolvedValue(null);

    await expect(service.findById('non-existent')).rejects.toThrow(
      NotFoundException,
    );
  });
});
