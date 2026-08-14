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
var SemestersService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.SemestersService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let SemestersService = SemestersService_1 = class SemestersService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(SemestersService_1.name);
    }
    async create(dto) {
        const academicYear = await this.prisma.academicYear.findUnique({
            where: { id: dto.academic_year_id },
        });
        if (!academicYear) {
            throw new common_1.NotFoundException(`Academic year with ID '${dto.academic_year_id}' not found`);
        }
        const semester = await this.prisma.semester.create({
            data: {
                academic_year_id: dto.academic_year_id,
                semester_type: dto.semester_type,
                is_active: dto.is_active ?? false,
            },
        });
        this.logger.log(`Semester created for academic year ${dto.academic_year_id}`);
        return semester;
    }
    async findAll(academicYearId) {
        const where = academicYearId ? { academic_year_id: academicYearId } : {};
        return this.prisma.semester.findMany({
            where,
            include: {
                academic_year: true,
            },
        });
    }
};
exports.SemestersService = SemestersService;
exports.SemestersService = SemestersService = SemestersService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SemestersService);
//# sourceMappingURL=semesters.service.js.map