import { DevicesService } from './devices.service';
import { CreateActivationCodeDto } from '../auth/dto/create-activation-code.dto';
import { BindDeviceDto } from '../auth/dto/bind-device.dto';
export declare class DevicesController {
    private readonly devicesService;
    constructor(devicesService: DevicesService);
    createActivationCode(dto: CreateActivationCodeDto): Promise<{
        id: string;
        user_id: string;
        code: string;
        code_state: import(".prisma/client").$Enums.CodeState;
        expires_at: Date;
    }>;
    bindDevice(dto: BindDeviceDto, user: any): Promise<{
        device_id: string;
        device_state: import(".prisma/client").$Enums.DeviceState;
        bound_at: Date;
    }>;
}
