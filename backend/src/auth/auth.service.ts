import {
  Injectable,
  UnauthorizedException,
  Logger,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService, AccountState } from '../prisma/prisma.service';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async login(loginDto: LoginDto) {
    const { username, password } = loginDto;

    const user = await this.prisma.user.findUnique({
      where: { username },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid username or password');
    }

    // Verify password hash with bcrypt
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid username or password');
    }

    // Verify account_state is Active
    if (user.account_state !== AccountState.Active) {
      throw new UnauthorizedException(
        `Account is not active. Current state: ${user.account_state}`,
      );
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

  async refresh(refreshTokenDto: RefreshTokenDto) {
    const { refresh_token } = refreshTokenDto;

    try {
      const payload = this.jwtService.verify(refresh_token);

      const user = await this.prisma.user.findUnique({
        where: { id: payload.sub },
      });

      if (!user || user.account_state !== AccountState.Active) {
        throw new UnauthorizedException('Invalid refresh token or inactive user');
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
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }
  }

  async logout(userId: string) {
    this.logger.log(`User ${userId} logged out successfully`);
    return {
      message: 'Logout successful',
    };
  }

  async hashPassword(password: string): Promise<string> {
    const saltRounds = 12;
    return bcrypt.hash(password, saltRounds);
  }
}
