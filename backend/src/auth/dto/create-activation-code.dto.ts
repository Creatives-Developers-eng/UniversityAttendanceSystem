import { IsNotEmpty, IsUUID } from 'class-validator';

export class CreateActivationCodeDto {
  @IsNotEmpty()
  @IsUUID()
  user_id: string;
}
