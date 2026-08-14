import {
  Controller,
  Post,
  Body,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Role } from '../prisma/prisma.service';
import { DevicesService } from './devices.service';
import { CreateActivationCodeDto } from '../auth/dto/create-activation-code.dto';
import { BindDeviceDto } from '../auth/dto/bind-device.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@Controller('devices')
export class DevicesController {
  constructor(private readonly devicesService: DevicesService) {}

  @Post('activation-code')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  @HttpCode(HttpStatus.CREATED)
  async createActivationCode(@Body() dto: CreateActivationCodeDto) {
    return this.devicesService.createActivationCode(dto);
  }

  @Post('bind')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async bindDevice(@Body() dto: BindDeviceDto, @CurrentUser() user: any) {
    return this.devicesService.bindDevice(dto, user?.userId);
  }
}
