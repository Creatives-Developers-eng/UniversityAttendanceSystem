"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const academic_years_service_1 = require("./academic-years.service");
const prisma_service_1 = require("../prisma/prisma.service");
describe('AcademicYearsService', () => {
    let service;
    let prismaService;
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
        const module = await testing_1.Test.createTestingModule({
            providers: [
                academic_years_service_1.AcademicYearsService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
            ],
        }).compile();
        service = module.get(academic_years_service_1.AcademicYearsService);
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
        await expect(service.create({
            year_name: '2025-2026',
            start_date: '2025-09-01',
            end_date: '2026-06-30',
        })).rejects.toThrow(common_1.ConflictException);
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
        await expect(service.setCurrent('non-existent')).rejects.toThrow(common_1.NotFoundException);
    });
});
//# sourceMappingURL=academic-years.service.spec.js.map