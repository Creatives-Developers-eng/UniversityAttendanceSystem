import { IsString, IsNotEmpty, Length } from 'class-validator';

export class CreateDepartmentDto {
  @IsString()
  @IsNotEmpty()
  @Length(1, 20)
  code: string;

  @IsString()
  @IsNotEmpty()
  @Length(1, 150)
  name: string;
}
