import {
  IsString,
  IsNotEmpty,
  Length,
  IsDateString,
  IsOptional,
  IsBoolean,
} from 'class-validator';

export class CreateAcademicYearDto {
  @IsString()
  @IsNotEmpty()
  @Length(1, 50)
  year_name: string;

  @IsDateString()
  @IsNotEmpty()
  start_date: string;

  @IsDateString()
  @IsNotEmpty()
  end_date: string;

  @IsOptional()
  @IsBoolean()
  is_current?: boolean;
}
