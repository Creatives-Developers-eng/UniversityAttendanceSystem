import {
  IsUUID,
  IsNotEmpty,
  IsEnum,
  IsString,
  Length,
} from 'class-validator';
import { SectionType } from '../../prisma/prisma.service';

export class CreateSectionDto {
  @IsUUID()
  @IsNotEmpty()
  course_id: string;

  @IsUUID()
  @IsNotEmpty()
  semester_id: string;

  @IsUUID()
  @IsNotEmpty()
  teacher_id: string;

  @IsEnum(SectionType)
  @IsNotEmpty()
  section_type: SectionType;

  @IsString()
  @IsNotEmpty()
  @Length(1, 10)
  section_number: string;
}
