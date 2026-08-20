import {
  IsUUID,
  IsNotEmpty,
  IsArray,
  ValidateNested,
  IsEnum,
  IsString,
  IsNumber,
  IsOptional,
  IsDateString,
} from 'class-validator';
import { Type } from 'class-transformer';
import { AttendanceMethod, AttendanceState } from '../../prisma/prisma.service';

export class AttendanceRecordItemDto {
  @IsUUID('4', { message: 'request_id must be a valid UUID' })
  @IsNotEmpty({ message: 'request_id is required' })
  request_id: string;

  @IsUUID('4', { message: 'student_id must be a valid UUID' })
  @IsNotEmpty({ message: 'student_id is required' })
  student_id: string;

  @IsEnum(AttendanceState, {
    message: 'attendance_state must be Present, Absent, Late, or Excused',
  })
  @IsOptional()
  attendance_state?: AttendanceState = AttendanceState.Present;

  @IsEnum(AttendanceMethod, {
    message: 'attendance_method must be QR, Biometric, or Manual',
  })
  @IsNotEmpty({ message: 'attendance_method is required' })
  attendance_method: AttendanceMethod;

  @IsString({ message: 'nonce must be a string' })
  @IsNotEmpty({ message: 'nonce is required' })
  nonce: string;

  @IsNumber({}, { message: 'timestamp must be a number' })
  @IsNotEmpty({ message: 'timestamp is required' })
  timestamp: number;

  @IsDateString({}, { message: 'marked_at must be an ISO-8601 date string' })
  @IsOptional()
  marked_at?: string;
}

export class SyncAttendanceDto {
  @IsUUID('4', { message: 'session_id must be a valid UUID' })
  @IsNotEmpty({ message: 'session_id is required' })
  session_id: string;

  @IsUUID('4', { message: 'delegate_id must be a valid UUID' })
  @IsNotEmpty({ message: 'delegate_id is required' })
  delegate_id: string;

  @IsArray({ message: 'records must be an array' })
  @ValidateNested({ each: true })
  @Type(() => AttendanceRecordItemDto)
  records: AttendanceRecordItemDto[];
}
