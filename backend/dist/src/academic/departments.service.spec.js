"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const departments_service_1 = require("./departments.service");
const prisma_service_1 = require("../prisma/prisma.service");
describe('DepartmentsService', () => {
    let service;
    let prismaService;
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
        const module = await testing_1.Test.createTestingModule({
            providers: [
                departments_service_1.DepartmentsService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
            ],
        }).compile();
        service = module.get(departments_service_1.DepartmentsService);
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
        await expect(service.create({ code: 'CS', name: 'Computer Science' })).rejects.toThrow(common_1.ConflictException);
    });
    it('should return department by id', async () => {
        prismaService.department.findUnique.mockResolvedValue(mockDepartment);
        const result = await service.findById('dept-uuid-1');
        expect(result.id).toBe('dept-uuid-1');
    });
    it('should throw NotFoundException if id not found', async () => {
        prismaService.department.findUnique.mockResolvedValue(null);
        await expect(service.findById('non-existent')).rejects.toThrow(common_1.NotFoundException);
    });
});
//# sourceMappingURL=departments.service.spec.js.map