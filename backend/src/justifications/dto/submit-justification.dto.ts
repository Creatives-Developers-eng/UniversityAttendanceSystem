import { IsNotEmpty, IsString, IsUUID, IsOptional, IsUrl } from 'class-validator';

export class SubmitJustificationDto {
  @IsNotEmpty()
  @IsUUID('4')
  session_id: string;

  @IsNotEmpty()
  @IsString()
  reason: string;

  @IsOptional()
  @IsString()
  document_url?: string;
}
