import {
  IsUUID,
  IsNotEmpty,
  IsEnum,
  IsOptional,
  IsBoolean,
} from 'class-validator';
import { SemesterType } from '../../prisma/prisma.service';

export class CreateSemesterDto {
  @IsUUID()
  @IsNotEmpty()
  academic_year_id: string;

  @IsEnum(SemesterType)
  @IsNotEmpty()
  semester_type: SemesterType;

  @IsOptional()
  @IsBoolean()
  is_active?: boolean;
}
