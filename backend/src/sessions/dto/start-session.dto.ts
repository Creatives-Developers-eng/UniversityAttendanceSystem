import { IsUUID, IsNotEmpty } from 'class-validator';

export class StartSessionDto {
  @IsUUID('4', { message: 'section_id must be a valid UUID' })
  @IsNotEmpty({ message: 'section_id is required' })
  section_id: string;

  @IsUUID('4', { message: 'delegate_id must be a valid UUID' })
  @IsNotEmpty({ message: 'delegate_id is required' })
  delegate_id: string;
}
