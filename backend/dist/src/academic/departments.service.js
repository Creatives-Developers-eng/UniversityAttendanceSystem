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
var DepartmentsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.DepartmentsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let DepartmentsService = DepartmentsService_1 = class DepartmentsService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(DepartmentsService_1.name);
    }
    async create(dto) {
        const existing = await this.prisma.department.findUnique({
            where: { code: dto.code },
        });
        if (existing) {
            throw new common_1.ConflictException(`Department with code '${dto.code}' already exists`);
        }
        const department = await this.prisma.department.create({
            data: {
                code: dto.code,
                name: dto.name,
            },
        });
        this.logger.log(`Department created: ${department.code}`);
        return department;
    }
    async findAll() {
        return this.prisma.department.findMany({
            orderBy: { created_at: 'desc' },
        });
    }
    async findById(id) {
        const department = await this.prisma.department.findUnique({
            where: { id },
        });
        if (!department) {
            throw new common_1.NotFoundException(`Department with ID '${id}' not found`);
        }
        return department;
    }
};
exports.DepartmentsService = DepartmentsService;
exports.DepartmentsService = DepartmentsService = DepartmentsService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], DepartmentsService);
//# sourceMappingURL=departments.service.js.map