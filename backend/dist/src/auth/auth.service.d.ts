import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
export declare class AuthService {
    private readonly prisma;
    private readonly jwtService;
    private readonly logger;
    constructor(prisma: PrismaService, jwtService: JwtService);
    login(loginDto: LoginDto): Promise<{
        user_id: string;
        username: string;
        role: import(".prisma/client").$Enums.Role;
        account_state: "Active";
        access_token: string;
        refresh_token: string;
    }>;
    refresh(refreshTokenDto: RefreshTokenDto): Promise<{
        access_token: string;
    }>;
    logout(userId: string): Promise<{
        message: string;
    }>;
    hashPassword(password: string): Promise<string>;
}
