import { Test, TestingModule } from '@nestjs/testing';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { AcademicYearsService } from './academic-years.service';
import { PrismaService } from '../prisma/prisma.service';

describe('AcademicYearsService', () => {
  let service: AcademicYearsService;
  let prismaService: any;

  const mockYear = {
    id: 'year-uuid-1',
    year_name: '2025-2026',
    start_date: new Date('2025-09-01'),
    end_date: new Date('2026-06-30'),
    is_current: true,
  };

  beforeEach(async () => {
    prismaService = {
      academicYear: {
        findUnique: jest.fn(),
        create: jest.fn(),
        findMany: jest.fn(),
        update: jest.fn(),
        updateMany: jest.fn(),
      },
      $transaction: jest.fn((callback) => callback(prismaService)),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AcademicYearsService,
        {
          provide: PrismaService,
          useValue: prismaService,
        },
      ],
    }).compile();

    service = module.get<AcademicYearsService>(AcademicYearsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create academic year successfully', async () => {
    prismaService.academicYear.findUnique.mockResolvedValue(null);
    prismaService.academicYear.create.mockResolvedValue(mockYear);

    const result = await service.create({
      year_name: '2025-2026',
      start_date: '2025-09-01',
      end_date: '2026-06-30',
    });

    expect(result.year_name).toBe('2025-2026');
  });

  it('should throw ConflictException if year_name exists', async () => {
    prismaService.academicYear.findUnique.mockResolvedValue(mockYear);

    await expect(
      service.create({
        year_name: '2025-2026',
        start_date: '2025-09-01',
        end_date: '2026-06-30',
      }),
    ).rejects.toThrow(ConflictException);
  });

  it('should set current academic year using transaction', async () => {
    prismaService.academicYear.findUnique.mockResolvedValue(mockYear);
    prismaService.academicYear.update.mockResolvedValue(mockYear);

    const result = await service.setCurrent('year-uuid-1');
    expect(result.is_current).toBe(true);
    expect(prismaService.academicYear.updateMany).toHaveBeenCalledWith({
      data: { is_current: false },
    });
  });

  it('should throw NotFoundException if setting current on non-existent year', async () => {
    prismaService.academicYear.findUnique.mockResolvedValue(null);

    await expect(service.setCurrent('non-existent')).rejects.toThrow(
      NotFoundException,
    );
  });
});
