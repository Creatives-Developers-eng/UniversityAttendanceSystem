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
var EnrollmentsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.EnrollmentsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let EnrollmentsService = EnrollmentsService_1 = class EnrollmentsService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(EnrollmentsService_1.name);
    }
    async create(dto) {
        const student = await this.prisma.student.findUnique({
            where: { id: dto.student_id },
        });
        if (!student) {
            throw new common_1.NotFoundException(`Student with ID '${dto.student_id}' not found`);
        }
        const section = await this.prisma.section.findUnique({
            where: { id: dto.section_id },
        });
        if (!section) {
            throw new common_1.NotFoundException(`Section with ID '${dto.section_id}' not found`);
        }
        const existing = await this.prisma.enrollment.findUnique({
            where: {
                student_id_section_id: {
                    student_id: dto.student_id,
                    section_id: dto.section_id,
                },
            },
        });
        if (existing) {
            throw new common_1.ConflictException(`Student '${dto.student_id}' is already enrolled in section '${dto.section_id}'`);
        }
        const enrollment = await this.prisma.enrollment.create({
            data: {
                student_id: dto.student_id,
                section_id: dto.section_id,
            },
        });
        this.logger.log(`Student ${dto.student_id} enrolled in section ${dto.section_id}`);
        return enrollment;
    }
    async findAll(sectionId, studentId) {
        const where = {};
        if (sectionId)
            where.section_id = sectionId;
        if (studentId)
            where.student_id = studentId;
        return this.prisma.enrollment.findMany({
            where,
            include: {
                student: true,
                section: true,
            },
        });
    }
    async delete(id) {
        const existing = await this.prisma.enrollment.findUnique({
            where: { id },
        });
        if (!existing) {
            throw new common_1.NotFoundException(`Enrollment with ID '${id}' not found`);
        }
        await this.prisma.enrollment.delete({
            where: { id },
        });
        this.logger.log(`Enrollment ${id} removed successfully`);
        return {
            message: `Enrollment '${id}' deleted successfully`,
        };
    }
};
exports.EnrollmentsService = EnrollmentsService;
exports.EnrollmentsService = EnrollmentsService = EnrollmentsService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], EnrollmentsService);
//# sourceMappingURL=enrollments.service.js.map