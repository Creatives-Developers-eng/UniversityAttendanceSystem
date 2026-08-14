"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AcademicModule = void 0;
const common_1 = require("@nestjs/common");
const prisma_module_1 = require("../prisma/prisma.module");
const departments_controller_1 = require("./departments.controller");
const departments_service_1 = require("./departments.service");
const academic_years_controller_1 = require("./academic-years.controller");
const academic_years_service_1 = require("./academic-years.service");
const semesters_controller_1 = require("./semesters.controller");
const semesters_service_1 = require("./semesters.service");
const courses_controller_1 = require("./courses.controller");
const courses_service_1 = require("./courses.service");
const sections_controller_1 = require("./sections.controller");
const sections_service_1 = require("./sections.service");
const enrollments_controller_1 = require("./enrollments.controller");
const enrollments_service_1 = require("./enrollments.service");
let AcademicModule = class AcademicModule {
};
exports.AcademicModule = AcademicModule;
exports.AcademicModule = AcademicModule = __decorate([
    (0, common_1.Module)({
        imports: [prisma_module_1.PrismaModule],
        controllers: [
            departments_controller_1.DepartmentsController,
            academic_years_controller_1.AcademicYearsController,
            semesters_controller_1.SemestersController,
            courses_controller_1.CoursesController,
            sections_controller_1.SectionsController,
            enrollments_controller_1.EnrollmentsController,
        ],
        providers: [
            departments_service_1.DepartmentsService,
            academic_years_service_1.AcademicYearsService,
            semesters_service_1.SemestersService,
            courses_service_1.CoursesService,
            sections_service_1.SectionsService,
            enrollments_service_1.EnrollmentsService,
        ],
        exports: [
            departments_service_1.DepartmentsService,
            academic_years_service_1.AcademicYearsService,
            semesters_service_1.SemestersService,
            courses_service_1.CoursesService,
            sections_service_1.SectionsService,
            enrollments_service_1.EnrollmentsService,
        ],
    })
], AcademicModule);
//# sourceMappingURL=academic.module.js.map