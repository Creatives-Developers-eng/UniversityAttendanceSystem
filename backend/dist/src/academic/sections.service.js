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
var SectionsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.SectionsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let SectionsService = SectionsService_1 = class SectionsService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(SectionsService_1.name);
    }
    async create(dto) {
        const course = await this.prisma.course.findUnique({
            where: { id: dto.course_id },
        });
        if (!course) {
            throw new common_1.NotFoundException(`Course with ID '${dto.course_id}' not found`);
        }
        const semester = await this.prisma.semester.findUnique({
            where: { id: dto.semester_id },
        });
        if (!semester) {
            throw new common_1.NotFoundException(`Semester with ID '${dto.semester_id}' not found`);
        }
        const teacher = await this.prisma.teacher.findUnique({
            where: { id: dto.teacher_id },
        });
        if (!teacher) {
            throw new common_1.NotFoundException(`Teacher with ID '${dto.teacher_id}' not found`);
        }
        const section = await this.prisma.section.create({
            data: {
                course_id: dto.course_id,
                semester_id: dto.semester_id,
                teacher_id: dto.teacher_id,
                section_type: dto.section_type,
                section_number: dto.section_number,
            },
        });
        this.logger.log(`Section '${section.section_number}' created for course ${dto.course_id}`);
        return section;
    }
    async findAll(semesterId, teacherId) {
        const where = {};
        if (semesterId)
            where.semester_id = semesterId;
        if (teacherId)
            where.teacher_id = teacherId;
        return this.prisma.section.findMany({
            where,
            include: {
                course: true,
                semester: true,
                teacher: true,
            },
        });
    }
    async findById(id) {
        const section = await this.prisma.section.findUnique({
            where: { id },
            include: {
                course: true,
                semester: true,
                teacher: true,
            },
        });
        if (!section) {
            throw new common_1.NotFoundException(`Section with ID '${id}' not found`);
        }
        return section;
    }
};
exports.SectionsService = SectionsService;
exports.SectionsService = SectionsService = SectionsService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SectionsService);
//# sourceMappingURL=sections.service.js.map