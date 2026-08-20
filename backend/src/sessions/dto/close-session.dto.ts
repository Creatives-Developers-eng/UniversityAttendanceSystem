import { IsUUID, IsNotEmpty } from 'class-validator';

export class CloseSessionDto {
  @IsUUID('4', { message: 'session_id must be a valid UUID' })
  @IsNotEmpty({ message: 'session_id is required' })
  session_id: string;
}
