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
var DevicesService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.DevicesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let DevicesService = DevicesService_1 = class DevicesService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(DevicesService_1.name);
    }
    async createActivationCode(dto) {
        const user = await this.prisma.user.findUnique({
            where: { id: dto.user_id },
        });
        if (!user) {
            throw new common_1.NotFoundException(`User with ID ${dto.user_id} not found`);
        }
        const code = Math.floor(100000 + Math.random() * 900000).toString();
        const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000);
        const savedCode = await this.prisma.activationCode.create({
            data: {
                user_id: user.id,
                code,
                code_state: prisma_service_1.CodeState.Generated,
                expires_at: expiresAt,
            },
        });
        this.logger.log(`Activation code generated for user ${user.id}`);
        return {
            id: savedCode.id,
            user_id: savedCode.user_id,
            code: savedCode.code,
            code_state: savedCode.code_state,
            expires_at: savedCode.expires_at,
        };
    }
    async bindDevice(dto, currentUserId) {
        const { code, device_identifier, device_fingerprint } = dto;
        const activationCode = await this.prisma.activationCode.findFirst({
            where: { code },
            include: { user: true },
        });
        if (!activationCode) {
            throw new common_1.BadRequestException('Invalid activation code');
        }
        if (activationCode.code_state !== prisma_service_1.CodeState.Generated &&
            activationCode.code_state !== prisma_service_1.CodeState.Sent) {
            throw new common_1.BadRequestException(`Activation code is not valid for use. Current state: ${activationCode.code_state}`);
        }
        if (new Date() > new Date(activationCode.expires_at)) {
            await this.prisma.activationCode.update({
                where: { id: activationCode.id },
                data: { code_state: prisma_service_1.CodeState.Expired },
            });
            throw new common_1.BadRequestException('Activation code has expired');
        }
        await this.prisma.activationCode.update({
            where: { id: activationCode.id },
            data: {
                code_state: prisma_service_1.CodeState.Used,
                used_at: new Date(),
            },
        });
        const savedDevice = await this.prisma.device.upsert({
            where: { device_identifier },
            create: {
                user_id: activationCode.user_id,
                device_identifier,
                device_fingerprint,
                device_state: prisma_service_1.DeviceState.Bound,
                bound_at: new Date(),
            },
            update: {
                user_id: activationCode.user_id,
                device_fingerprint,
                device_state: prisma_service_1.DeviceState.Bound,
                bound_at: new Date(),
            },
        });
        this.logger.log(`Device ${device_identifier} bound to user ${activationCode.user_id}`);
        return {
            device_id: savedDevice.id,
            device_state: savedDevice.device_state,
            bound_at: savedDevice.bound_at,
        };
    }
};
exports.DevicesService = DevicesService;
exports.DevicesService = DevicesService = DevicesService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], DevicesService);
//# sourceMappingURL=devices.service.js.map