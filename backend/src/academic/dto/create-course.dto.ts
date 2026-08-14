import {
  IsString,
  IsNotEmpty,
  Length,
  IsUUID,
  IsInt,
  Min,
} from 'class-validator';

export class CreateCourseDto {
  @IsString()
  @IsNotEmpty()
  @Length(1, 30)
  course_code: string;

  @IsString()
  @IsNotEmpty()
  @Length(1, 150)
  title: string;

  @IsUUID()
  @IsNotEmpty()
  department_id: string;

  @IsInt()
  @Min(1)
  credit_hours: number;
}
