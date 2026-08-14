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
exports.SemestersController = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
const roles_guard_1 = require("../auth/guards/roles.guard");
const roles_decorator_1 = require("../auth/decorators/roles.decorator");
const semesters_service_1 = require("./semesters.service");
const create_semester_dto_1 = require("./dto/create-semester.dto");
let SemestersController = class SemestersController {
    constructor(semestersService) {
        this.semestersService = semestersService;
    }
    async create(dto) {
        return this.semestersService.create(dto);
    }
    async findAll(academicYearId) {
        return this.semestersService.findAll(academicYearId);
    }
};
exports.SemestersController = SemestersController;
__decorate([
    (0, common_1.Post)(),
    (0, roles_decorator_1.Roles)(prisma_service_1.Role.ADMIN),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_semester_dto_1.CreateSemesterDto]),
    __metadata("design:returntype", Promise)
], SemestersController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    (0, roles_decorator_1.Roles)(prisma_service_1.Role.ADMIN, prisma_service_1.Role.STUDENT),
    (0, common_1.HttpCode)(common_1.HttpStatus.OK),
    __param(0, (0, common_1.Query)('academic_year_id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], SemestersController.prototype, "findAll", null);
exports.SemestersController = SemestersController = __decorate([
    (0, common_1.Controller)('semesters'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [semesters_service_1.SemestersService])
], SemestersController);
//# sourceMappingURL=semesters.controller.js.map