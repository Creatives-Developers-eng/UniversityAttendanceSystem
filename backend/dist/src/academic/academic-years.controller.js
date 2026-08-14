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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AcademicYearsController = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const roles_guard_1 = require("../auth/guards/roles.guard");
const roles_decorator_1 = require("../auth/decorators/roles.decorator");
const academic_years_service_1 = require("./academic-years.service");
const create_academic_year_dto_1 = require("./dto/create-academic-year.dto");
let AcademicYearsController = class AcademicYearsController {
    constructor(academicYearsService) {
        this.academicYearsService = academicYearsService;
    }
    async create(dto) {
        return this.academicYearsService.create(dto);
    }
    async findAll() {
        return this.academicYearsService.findAll();
    }
    async setCurrent(id) {
        return this.academicYearsService.setCurrent(id);
    }
};
exports.AcademicYearsController = AcademicYearsController;
__decorate([
    (0, common_1.Post)(),
    (0, roles_decorator_1.Roles)(prisma_service_1.Role.ADMIN),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_academic_year_dto_1.CreateAcademicYearDto]),
    __metadata("design:returntype", Promise)
], AcademicYearsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    (0, roles_decorator_1.Roles)(prisma_service_1.Role.ADMIN, prisma_service_1.Role.STUDENT),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], AcademicYearsController.prototype, "findAll", null);
__decorate([
    (0, common_1.Patch)(':id/current'),
    (0, roles_decorator_1.Roles)(prisma_service_1.Role.ADMIN),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AcademicYearsController.prototype, "setCurrent", null);
exports.AcademicYearsController = AcademicYearsController = __decorate([
    (0, common_1.Controller)('academic-years'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [academic_years_service_1.AcademicYearsService])
], AcademicYearsController);
//# sourceMappingURL=academic-years.controller.js.map