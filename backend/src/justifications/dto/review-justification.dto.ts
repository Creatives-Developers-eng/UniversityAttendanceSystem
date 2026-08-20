import { IsNotEmpty, IsIn, IsOptional, IsString } from 'class-validator';

export class ReviewJustificationDto {
  @IsNotEmpty()
  @IsIn(['APPROVED', 'REJECTED'])
  status: 'APPROVED' | 'REJECTED';

  @IsOptional()
  @IsString()
  notes?: string;
}
