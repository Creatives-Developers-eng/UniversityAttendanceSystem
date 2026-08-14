import { PrismaService } from '../prisma/prisma.service';
import { CreateActivationCodeDto } from '../auth/dto/create-activation-code.dto';
import { BindDeviceDto } from '../auth/dto/bind-device.dto';
export declare class DevicesService {
    private readonly prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    createActivationCode(dto: CreateActivationCodeDto): Promise<{
        id: string;
        user_id: string;
        code: string;
        code_state: import(".prisma/client").$Enums.CodeState;
        expires_at: Date;
    }>;
    bindDevice(dto: BindDeviceDto, currentUserId?: string): Promise<{
        device_id: string;
        device_state: import(".prisma/client").$Enums.DeviceState;
        bound_at: Date;
    }>;
}
