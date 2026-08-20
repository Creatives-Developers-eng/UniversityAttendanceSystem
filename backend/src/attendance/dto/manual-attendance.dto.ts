import {
  IsUUID,
  IsNotEmpty,
  IsEnum,
  IsOptional,
  IsString,
} from 'class-validator';
import { AttendanceState } from '../../prisma/prisma.service';

export class ManualAttendanceDto {
  @IsUUID('4', { message: 'session_id must be a valid UUID' })
  @IsNotEmpty({ message: 'session_id is required' })
  session_id: string;

  @IsUUID('4', { message: 'student_id must be a valid UUID' })
  @IsNotEmpty({ message: 'student_id is required' })
  student_id: string;

  @IsEnum(AttendanceState, {
    message: 'attendance_state must be Present, Absent, Late, or Excused',
  })
  @IsNotEmpty({ message: 'attendance_state is required' })
  attendance_state: AttendanceState;

  @IsString()
  @IsOptional()
  reason?: string;
}
