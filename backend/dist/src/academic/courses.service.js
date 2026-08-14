"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var CoursesService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.CoursesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let CoursesService = CoursesService_1 = class CoursesService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(CoursesService_1.name);
    }
    async create(dto) {
        const existing = await this.prisma.course.findUnique({
            where: { course_code: dto.course_code },
        });
        if (existing) {
            throw new common_1.ConflictException(`Course with code '${dto.course_code}' already exists`);
        }
        const department = await this.prisma.department.findUnique({
            where: { id: dto.department_id },
        });
        if (!department) {
            throw new common_1.NotFoundException(`Department with ID '${dto.department_id}' not found`);
        }
        const course = await this.prisma.course.create({
            data: {
                course_code: dto.course_code,
                title: dto.title,
                department_id: dto.department_id,
                credit_hours: dto.credit_hours,
            },
        });
        this.logger.log(`Course created: ${course.course_code}`);
        return course;
    }
    async findAll(departmentId) {
        const where = departmentId ? { department_id: departmentId } : {};
        return this.prisma.course.findMany({
            where,
            include: {
                department: true,
            },
        });
    }
};
exports.CoursesService = CoursesService;
exports.CoursesService = CoursesService = CoursesService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], CoursesService);
//# sourceMappingURL=courses.service.js.map