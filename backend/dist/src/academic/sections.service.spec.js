"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const sections_service_1 = require("./sections.service");
const prisma_service_1 = require("../prisma/prisma.service");
describe('SectionsService', () => {
    let service;
    let prismaService;
    const mockSection = {
        id: 'section-uuid-1',
        course_id: 'course-uuid-1',
        semester_id: 'sem-uuid-1',
        teacher_id: 'teacher-uuid-1',
        section_type: prisma_service_1.SectionType.THEORETICAL,
        section_number: 'SEC01',
    };
    beforeEach(async () => {
        prismaService = {
            course: { findUnique: jest.fn() },
            semester: { findUnique: jest.fn() },
            teacher: { findUnique: jest.fn() },
            section: {
                create: jest.fn(),
                findMany: jest.fn(),
                findUnique: jest.fn(),
            },
        };
        const module = await testing_1.Test.createTestingModule({
            providers: [
                sections_service_1.SectionsService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
            ],
        }).compile();
        service = module.get(sections_service_1.SectionsService);
    });
    it('should be defined', () => {
        expect(service).toBeDefined();
    });
    it('should create section successfully when all FKs exist', async () => {
        prismaService.course.findUnique.mockResolvedValue({ id: 'course-uuid-1' });
        prismaService.semester.findUnique.mockResolvedValue({ id: 'sem-uuid-1' });
        prismaService.teacher.findUnique.mockResolvedValue({ id: 'teacher-uuid-1' });
        prismaService.section.create.mockResolvedValue(mockSection);
        const result = await service.create({
            course_id: 'course-uuid-1',
            semester_id: 'sem-uuid-1',
            teacher_id: 'teacher-uuid-1',
            section_type: prisma_service_1.SectionType.THEORETICAL,
            section_number: 'SEC01',
        });
        expect(result.section_number).toBe('SEC01');
    });
    it('should throw NotFoundException if course FK missing', async () => {
        prismaService.course.findUnique.mockResolvedValue(null);
        await expect(service.create({
            course_id: 'non-existent',
            semester_id: 'sem-uuid-1',
            teacher_id: 'teacher-uuid-1',
            section_type: prisma_service_1.SectionType.THEORETICAL,
            section_number: 'SEC01',
        })).rejects.toThrow(common_1.NotFoundException);
    });
    it('should throw NotFoundException if section id not found on findById', async () => {
        prismaService.section.findUnique.mockResolvedValue(null);
        await expect(service.findById('non-existent')).rejects.toThrow(common_1.NotFoundException);
    });
});
//# sourceMappingURL=sections.service.spec.js.map