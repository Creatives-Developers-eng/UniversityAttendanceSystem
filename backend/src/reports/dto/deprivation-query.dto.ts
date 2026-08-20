import { IsOptional, IsUUID, IsNumber, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

export class DeprivationQueryDto {
  @IsOptional()
  @IsUUID('4')
  section_id?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  @Max(100)
  threshold_percent?: number = 25.0;
}
