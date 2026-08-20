import {
  Controller,
  Get,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ReportsService } from './reports.service';
import { DeprivationQueryDto } from './dto/deprivation-query.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../prisma/prisma.service';

@Controller('reports')
@UseGuards(JwtAuthGuard, RolesGuard)
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get('dashboard')
  @Roles(Role.ADMIN)
  async getDashboardStats() {
    return this.reportsService.getSystemDashboardStats();
  }

  @Get('teachers/summary')
  @Roles(Role.TEACHER, Role.ADMIN)
  async getTeacherSummary(@Request() req: any) {
    const teacherId = req.user.role === Role.TEACHER ? req.user.id : req.query.teacher_id;
    return this.reportsService.getTeacherSectionsSummary(teacherId);
  }

  @Get('sections/:sectionId')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getSectionReport(@Param('sectionId') sectionId: string) {
    return this.reportsService.getSectionAttendanceReport(sectionId);
  }

  @Get('students/:studentId')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getStudentReport(
    @Param('studentId') studentId: string,
    @Query('semester_id') semesterId?: string,
  ) {
    return this.reportsService.getStudentAttendanceReport(studentId, semesterId);
  }

  @Get('courses/:courseId/deprivation')
  @Roles(Role.ADMIN, Role.TEACHER)
  async getCourseDeprivation(
    @Param('courseId') courseId: string,
    @Query() query: DeprivationQueryDto,
  ) {
    return this.reportsService.getCourseDeprivationList(courseId, query);
  }
}
