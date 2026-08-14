import {
  Injectable,
  BadRequestException,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import {
  PrismaService,
  CodeState,
  DeviceState,
} from '../prisma/prisma.service';
import { CreateActivationCodeDto } from '../auth/dto/create-activation-code.dto';
import { BindDeviceDto } from '../auth/dto/bind-device.dto';

@Injectable()
export class DevicesService {
  private readonly logger = new Logger(DevicesService.name);

  constructor(private readonly prisma: PrismaService) {}

  async createActivationCode(dto: CreateActivationCodeDto) {
    const user = await this.prisma.user.findUnique({
      where: { id: dto.user_id },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${dto.user_id} not found`);
    }

    // Generate a 6-digit random code
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours expiry

    const savedCode = await this.prisma.activationCode.create({
      data: {
        user_id: user.id,
        code,
        code_state: CodeState.Generated,
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

  async bindDevice(dto: BindDeviceDto, currentUserId?: string) {
    const { code, device_identifier, device_fingerprint } = dto;

    const activationCode = await this.prisma.activationCode.findFirst({
      where: { code },
      include: { user: true },
    });

    if (!activationCode) {
      throw new BadRequestException('Invalid activation code');
    }

    if (
      activationCode.code_state !== CodeState.Generated &&
      activationCode.code_state !== CodeState.Sent
    ) {
      throw new BadRequestException(
        `Activation code is not valid for use. Current state: ${activationCode.code_state}`,
      );
    }

    if (new Date() > new Date(activationCode.expires_at)) {
      await this.prisma.activationCode.update({
        where: { id: activationCode.id },
        data: { code_state: CodeState.Expired },
      });
      throw new BadRequestException('Activation code has expired');
    }

    // Mark activation code as USED
    await this.prisma.activationCode.update({
      where: { id: activationCode.id },
      data: {
        code_state: CodeState.Used,
        used_at: new Date(),
      },
    });

    // Upsert device bound to user
    const savedDevice = await this.prisma.device.upsert({
      where: { device_identifier },
      create: {
        user_id: activationCode.user_id,
        device_identifier,
        device_fingerprint,
        device_state: DeviceState.Bound,
        bound_at: new Date(),
      },
      update: {
        user_id: activationCode.user_id,
        device_fingerprint,
        device_state: DeviceState.Bound,
        bound_at: new Date(),
      },
    });

    this.logger.log(
      `Device ${device_identifier} bound to user ${activationCode.user_id}`,
    );

    return {
      device_id: savedDevice.id,
      device_state: savedDevice.device_state,
      bound_at: savedDevice.bound_at,
    };
  }
}
