"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const enrollments_service_1 = require("./enrollments.service");
const prisma_service_1 = require("../prisma/prisma.service");
describe('EnrollmentsService', () => {
    let service;
    let prismaService;
    const mockEnrollment = {
        id: 'enrollment-uuid-1',
        student_id: 'student-uuid-1',
        section_id: 'section-uuid-1',
        enrolled_at: new Date(),
    };
    beforeEach(async () => {
        prismaService = {
            student: { findUnique: jest.fn() },
            section: { findUnique: jest.fn() },
            enrollment: {
                findUnique: jest.fn(),
                create: jest.fn(),
                findMany: jest.fn(),
                delete: jest.fn(),
            },
        };
        const module = await testing_1.Test.createTestingModule({
            providers: [
                enrollments_service_1.EnrollmentsService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
            ],
        }).compile();
        service = module.get(enrollments_service_1.EnrollmentsService);
    });
    it('should be defined', () => {
        expect(service).toBeDefined();
    });
    it('should create enrollment successfully', async () => {
        prismaService.student.findUnique.mockResolvedValue({ id: 'student-uuid-1' });
        prismaService.section.findUnique.mockResolvedValue({ id: 'section-uuid-1' });
        prismaService.enrollment.findUnique.mockResolvedValue(null);
        prismaService.enrollment.create.mockResolvedValue(mockEnrollment);
        const result = await service.create({
            student_id: 'student-uuid-1',
            section_id: 'section-uuid-1',
        });
        expect(result.id).toBe('enrollment-uuid-1');
    });
    it('should throw ConflictException on duplicate enrollment for same student and section', async () => {
        prismaService.student.findUnique.mockResolvedValue({ id: 'student-uuid-1' });
        prismaService.section.findUnique.mockResolvedValue({ id: 'section-uuid-1' });
        prismaService.enrollment.findUnique.mockResolvedValue(mockEnrollment);
        await expect(service.create({
            student_id: 'student-uuid-1',
            section_id: 'section-uuid-1',
        })).rejects.toThrow(common_1.ConflictException);
    });
    it('should delete enrollment successfully', async () => {
        prismaService.enrollment.findUnique.mockResolvedValue(mockEnrollment);
        prismaService.enrollment.delete.mockResolvedValue(mockEnrollment);
        const result = await service.delete('enrollment-uuid-1');
        expect(result.message).toContain('deleted successfully');
    });
    it('should throw NotFoundException on delete non-existent enrollment', async () => {
        prismaService.enrollment.findUnique.mockResolvedValue(null);
        await expect(service.delete('non-existent')).rejects.toThrow(common_1.NotFoundException);
    });
});
//# sourceMappingURL=enrollments.service.spec.js.map