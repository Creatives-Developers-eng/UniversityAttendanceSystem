import { IsString, IsNotEmpty, Length } from 'class-validator';

export class EnrollBiometricDto {
  @IsString({ message: 'template_hash must be a string' })
  @IsNotEmpty({ message: 'template_hash is required' })
  @Length(64, 64, { message: 'template_hash must be a 64-character SHA-256 hex string' })
  template_hash: string;

  @IsString({ message: 'encrypted_template_data must be a string' })
  @IsNotEmpty({ message: 'encrypted_template_data is required' })
  encrypted_template_data: string;
}
