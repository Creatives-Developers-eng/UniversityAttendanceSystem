"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const courses_service_1 = require("./courses.service");
const prisma_service_1 = require("../prisma/prisma.service");
describe('CoursesService', () => {
    let service;
    let prismaService;
    const mockCourse = {
        id: 'course-uuid-1',
        course_code: 'CS101',
        title: 'Introduction to Computer Science',
        department_id: 'dept-uuid-1',
        credit_hours: 3,
    };
    beforeEach(async () => {
        prismaService = {
            course: {
                findUnique: jest.fn(),
                create: jest.fn(),
                findMany: jest.fn(),
            },
            department: {
                findUnique: jest.fn(),
            },
        };
        const module = await testing_1.Test.createTestingModule({
            providers: [
                courses_service_1.CoursesService,
                {
                    provide: prisma_service_1.PrismaService,
                    useValue: prismaService,
                },
            ],
        }).compile();
        service = module.get(courses_service_1.CoursesService);
    });
    it('should be defined', () => {
        expect(service).toBeDefined();
    });
    it('should create course successfully', async () => {
        prismaService.course.findUnique.mockResolvedValue(null);
        prismaService.department.findUnique.mockResolvedValue({ id: 'dept-uuid-1' });
        prismaService.course.create.mockResolvedValue(mockCourse);
        const result = await service.create({
            course_code: 'CS101',
            title: 'Introduction to Computer Science',
            department_id: 'dept-uuid-1',
            credit_hours: 3,
        });
        expect(result.course_code).toBe('CS101');
    });
    it('should throw ConflictException if course_code exists', async () => {
        prismaService.course.findUnique.mockResolvedValue(mockCourse);
        await expect(service.create({
            course_code: 'CS101',
            title: 'Introduction to Computer Science',
            department_id: 'dept-uuid-1',
            credit_hours: 3,
        })).rejects.toThrow(common_1.ConflictException);
    });
    it('should throw NotFoundException if department does not exist', async () => {
        prismaService.course.findUnique.mockResolvedValue(null);
        prismaService.department.findUnique.mockResolvedValue(null);
        await expect(service.create({
            course_code: 'CS101',
            title: 'Introduction to Computer Science',
            department_id: 'non-existent',
            credit_hours: 3,
        })).rejects.toThrow(common_1.NotFoundException);
    });
});
//# sourceMappingURL=courses.service.spec.js.map