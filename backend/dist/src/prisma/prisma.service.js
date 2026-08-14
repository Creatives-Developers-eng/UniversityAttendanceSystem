"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PrismaService = exports.TeacherType = exports.SectionType = exports.SemesterType = exports.CodeState = exports.DeviceState = exports.AccountState = exports.Role = void 0;
const common_1 = require("@nestjs/common");
const client_1 = require("@prisma/client");
var Role;
(function (Role) {
    Role["ADMIN"] = "ADMIN";
    Role["STUDENT"] = "STUDENT";
    Role["TEACHER"] = "TEACHER";
})(Role || (exports.Role = Role = {}));
var AccountState;
(function (AccountState) {
    AccountState["PendingActivation"] = "PendingActivation";
    AccountState["Active"] = "Active";
    AccountState["Suspended"] = "Suspended";
    AccountState["Deactivated"] = "Deactivated";
})(AccountState || (exports.AccountState = AccountState = {}));
var DeviceState;
(function (DeviceState) {
    DeviceState["Unregistered"] = "Unregistered";
    DeviceState["PendingVerification"] = "PendingVerification";
    DeviceState["Bound"] = "Bound";
    DeviceState["Revoked"] = "Revoked";
})(DeviceState || (exports.DeviceState = DeviceState = {}));
var CodeState;
(function (CodeState) {
    CodeState["Generated"] = "Generated";
    CodeState["Sent"] = "Sent";
    CodeState["Used"] = "Used";
    CodeState["Expired"] = "Expired";
    CodeState["Invalidated"] = "Invalidated";
})(CodeState || (exports.CodeState = CodeState = {}));
var SemesterType;
(function (SemesterType) {
    SemesterType["FIRST"] = "FIRST";
    SemesterType["SECOND"] = "SECOND";
    SemesterType["SUMMER"] = "SUMMER";
})(SemesterType || (exports.SemesterType = SemesterType = {}));
var SectionType;
(function (SectionType) {
    SectionType["PRACTICAL"] = "PRACTICAL";
    SectionType["THEORETICAL"] = "THEORETICAL";
})(SectionType || (exports.SectionType = SectionType = {}));
var TeacherType;
(function (TeacherType) {
    TeacherType["PRACTICAL_TEACHER"] = "PRACTICAL_TEACHER";
    TeacherType["THEORETICAL_TEACHER"] = "THEORETICAL_TEACHER";
    TeacherType["BOTH"] = "BOTH";
})(TeacherType || (exports.TeacherType = TeacherType = {}));
let PrismaService = class PrismaService extends client_1.PrismaClient {
    async onModuleInit() {
        await this.$connect();
    }
    async onModuleDestroy() {
        await this.$disconnect();
    }
};
exports.PrismaService = PrismaService;
exports.PrismaService = PrismaService = __decorate([
    (0, common_1.Injectable)()
], PrismaService);
//# sourceMappingURL=prisma.service.js.map