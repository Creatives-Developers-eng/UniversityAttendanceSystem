"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const semesters_service_1 = require("./semesters.service");
const prisma_service_1 = require("../prisma/prisma.service");
describe('SemestersService', () => {
    let service;
    let prismaService;
    const mockSemester = {
        id: 'sem-uuid-1',
        academic_year_id: 'year-uuid-1',
        semester_type: prisma_service_1.SemesterType.FIRST,
        is_active: true,
    };
    beforeEach(async () => {
        prismaService = {
            academicYear: {
                findUnique: jest.fn(),
            },
            semester: {
                create: jest.fn(),
                findMany: jest.fn(),
            },
        };
        const module = await testing_1.Test.createTestingModule({
            providers: [
                semesters_service_1.SemestersService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
            ],
        }).compile();
        service = module.get(semesters_service_1.SemestersService);
    });
    it('should be defined', () => {
        expect(service).toBeDefined();
    });
    it('should create semester successfully when academic year exists', async () => {
        prismaService.academicYear.findUnique.mockResolvedValue({ id: 'year-uuid-1' });
        prismaService.semester.create.mockResolvedValue(mockSemester);
        const result = await service.create({
            academic_year_id: 'year-uuid-1',
            semester_type: prisma_service_1.SemesterType.FIRST,
        });
        expect(result.semester_type).toBe(prisma_service_1.SemesterType.FIRST);
    });
    it('should throw NotFoundException if academic year does not exist', async () => {
        prismaService.academicYear.findUnique.mockResolvedValue(null);
        await expect(service.create({
            academic_year_id: 'non-existent',
            semester_type: prisma_service_1.SemesterType.FIRST,
        })).rejects.toThrow(common_1.NotFoundException);
    });
});
//# sourceMappingURL=semesters.service.spec.js.map