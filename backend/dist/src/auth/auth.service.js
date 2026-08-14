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
var AuthService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const bcrypt = require("bcrypt");
const prisma_service_1 = require("../prisma/prisma.service");
let AuthService = AuthService_1 = class AuthService {
    constructor(prisma, jwtService) {
        this.prisma = prisma;
        this.jwtService = jwtService;
        this.logger = new common_1.Logger(AuthService_1.name);
    }
    async login(loginDto) {
        const { username, password } = loginDto;
        const user = await this.prisma.user.findUnique({
            where: { username },
        });
        if (!user) {
            throw new common_1.UnauthorizedException('Invalid username or password');
        }
        const isPasswordValid = await bcrypt.compare(password, user.password_hash);
        if (!isPasswordValid) {
            throw new common_1.UnauthorizedException('Invalid username or password');
        }
        if (user.account_state !== prisma_service_1.AccountState.Active) {
            throw new common_1.UnauthorizedException(`Account is not active. Current state: ${user.account_state}`);
        }
        const payload = {
            sub: user.id,
            username: user.username,
            role: user.role,
            account_state: user.account_state,
        };
        const accessToken = this.jwtService.sign(payload, { expiresIn: '15m' });
        const refreshToken = this.jwtService.sign(payload, { expiresIn: '7d' });
        this.logger.log(`User ${user.username} logged in successfully`);
        return {
            user_id: user.id,
            username: user.username,
            role: user.role,
            account_state: user.account_state,
            access_token: accessToken,
            refresh_token: refreshToken,
        };
    }
    async refresh(refreshTokenDto) {
        const { refresh_token } = refreshTokenDto;
        try {
            const payload = this.jwtService.verify(refresh_token);
            const user = await this.prisma.user.findUnique({
                where: { id: payload.sub },
            });
            if (!user || user.account_state !== prisma_service_1.AccountState.Active) {
                throw new common_1.UnauthorizedException('Invalid refresh token or inactive user');
            }
            const newPayload = {
                sub: user.id,
                username: user.username,
                role: user.role,
                account_state: user.account_state,
            };
            const accessToken = this.jwtService.sign(newPayload, { expiresIn: '15m' });
            return {
                access_token: accessToken,
            };
        }
        catch (error) {
            throw new common_1.UnauthorizedException('Invalid or expired refresh token');
        }
    }
    async logout(userId) {
        this.logger.log(`User ${userId} logged out successfully`);
        return {
            message: 'Logout successful',
        };
    }
    async hashPassword(password) {
        const saltRounds = 12;
        return bcrypt.hash(password, saltRounds);
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = AuthService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        jwt_1.JwtService])
], AuthService);
//# sourceMappingURL=auth.service.js.map