import { IsNotEmpty, IsString } from 'class-validator';

export class BindDeviceDto {
  @IsNotEmpty()
  @IsString()
  code: string;

  @IsNotEmpty()
  @IsString()
  device_identifier: string;

  @IsNotEmpty()
  @IsString()
  device_fingerprint: string;
}
