import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
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
    logout(user: any): Promise<{
        message: string;
    }>;
    getProfile(user: any): Promise<any>;
}
