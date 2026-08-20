import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import { SyncAttendanceDto } from './dto/sync-attendance.dto';
import { ManualAttendanceDto } from './dto/manual-attendance.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../prisma/prisma.service';

@Controller('attendance')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Post('sync')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async syncAttendance(@Body() dto: SyncAttendanceDto, @Request() req: any) {
    return this.attendanceService.syncAttendance(dto, req.user);
  }

  @Post('manual')
  @Roles(Role.ADMIN, Role.TEACHER)
  async manualAttendance(@Body() dto: ManualAttendanceDto, @Request() req: any) {
    return this.attendanceService.manualAttendance(dto, req.user);
  }

  @Get('session/:sessionId')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getSessionAttendance(@Param('sessionId') sessionId: string) {
    return this.attendanceService.getSessionAttendance(sessionId);
  }

  @Get('student/:studentId')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getStudentAttendanceHistory(@Param('studentId') studentId: string) {
    return this.attendanceService.getStudentAttendanceHistory(studentId);
  }
}
