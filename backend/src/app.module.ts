import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import configuration from './config/configuration';
import { DatabaseModule } from './database/database.module';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';
import { DevicesModule } from './devices/devices.module';
import { AcademicModule } from './academic/academic.module';
import { SessionsModule } from './sessions/sessions.module';
import { AttendanceModule } from './attendance/attendance.module';
import { BiometricsModule } from './students/biometrics/biometrics.module';
import { AuditModule } from './audit/audit.module';
import { ReportsModule } from './reports/reports.module';
import { JustificationsModule } from './justifications/justifications.module';
import { DocsModule } from './docs/docs.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    DatabaseModule,
    UsersModule,
    AuthModule,
    DevicesModule,
    AcademicModule,
    SessionsModule,
    AttendanceModule,
    BiometricsModule,
    AuditModule,
    ReportsModule,
    JustificationsModule,
    DocsModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
