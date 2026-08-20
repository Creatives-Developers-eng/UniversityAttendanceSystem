import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { BiometricsService } from './biometrics.service';
import { EnrollBiometricDto } from './dto/enroll-biometric.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { Role } from '../../prisma/prisma.service';

@Controller('students')
@UseGuards(JwtAuthGuard, RolesGuard)
export class BiometricsController {
  constructor(private readonly biometricsService: BiometricsService) {}

  @Post(':studentId/biometrics')
  @Roles(Role.ADMIN, Role.STUDENT)
  async enrollTemplate(
    @Param('studentId') studentId: string,
    @Body() dto: EnrollBiometricDto,
    @Request() req: any,
  ) {
    return this.biometricsService.enrollTemplate(studentId, dto, req.user);
  }

  @Get('biometrics/section/:sectionId')
  @Roles(Role.ADMIN, Role.TEACHER, Role.STUDENT)
  async getSectionBiometrics(
    @Param('sectionId') sectionId: string,
    @Request() req: any,
  ) {
    return this.biometricsService.getSectionBiometrics(sectionId, req.user);
  }

  @Get(':studentId/biometrics')
  @Roles(Role.ADMIN, Role.STUDENT)
  async getStudentBiometric(
    @Param('studentId') studentId: string,
    @Request() req: any,
  ) {
    return this.biometricsService.getStudentBiometric(studentId, req.user);
  }

  @Delete(':studentId/biometrics')
  @Roles(Role.ADMIN)
  async deleteBiometric(
    @Param('studentId') studentId: string,
    @Request() req: any,
  ) {
    return this.biometricsService.deleteBiometric(studentId, req.user);
  }
}
