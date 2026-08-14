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
var AcademicYearsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AcademicYearsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let AcademicYearsService = AcademicYearsService_1 = class AcademicYearsService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(AcademicYearsService_1.name);
    }
    async create(dto) {
        const existing = await this.prisma.academicYear.findUnique({
            where: { year_name: dto.year_name },
        });
        if (existing) {
            throw new common_1.ConflictException(`Academic year '${dto.year_name}' already exists`);
        }
        const startDate = new Date(dto.start_date);
        const endDate = new Date(dto.end_date);
        if (dto.is_current) {
            return this.prisma.$transaction(async (tx) => {
                await tx.academicYear.updateMany({
                    data: { is_current: false },
                });
                const created = await tx.academicYear.create({
                    data: {
                        year_name: dto.year_name,
                        start_date: startDate,
                        end_date: endDate,
                        is_current: true,
                    },
                });
                this.logger.log(`Academic year '${created.year_name}' created and set as current`);
                return created;
            });
        }
        const academicYear = await this.prisma.academicYear.create({
            data: {
                year_name: dto.year_name,
                start_date: startDate,
                end_date: endDate,
                is_current: dto.is_current ?? false,
            },
        });
        this.logger.log(`Academic year created: ${academicYear.year_name}`);
        return academicYear;
    }
    async findAll() {
        return this.prisma.academicYear.findMany({
            orderBy: { start_date: 'desc' },
        });
    }
    async setCurrent(id) {
        const existing = await this.prisma.academicYear.findUnique({
            where: { id },
        });
        if (!existing) {
            throw new common_1.NotFoundException(`Academic year with ID '${id}' not found`);
        }
        return this.prisma.$transaction(async (tx) => {
            await tx.academicYear.updateMany({
                data: { is_current: false },
            });
            const updated = await tx.academicYear.update({
                where: { id },
                data: { is_current: true },
            });
            this.logger.log(`Academic year '${updated.year_name}' is now set as current`);
            return updated;
        });
    }
};
exports.AcademicYearsService = AcademicYearsService;
exports.AcademicYearsService = AcademicYearsService = AcademicYearsService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AcademicYearsService);
//# sourceMappingURL=academic-years.service.js.map