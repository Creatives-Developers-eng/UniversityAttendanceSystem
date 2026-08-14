import { IsUUID, IsNotEmpty } from 'class-validator';

export class CreateEnrollmentDto {
  @IsUUID()
  @IsNotEmpty()
  student_id: string;

  @IsUUID()
  @IsNotEmpty()
  section_id: string;
}
