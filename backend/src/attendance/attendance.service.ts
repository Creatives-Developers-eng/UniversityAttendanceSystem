import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import {
  PrismaService,
  SessionState,
  SyncState,
  RequestState,
  AttendanceState,
  AttendanceMethod,
  Role,
} from '../prisma/prisma.service';
import { SyncAttendanceDto } from './dto/sync-attendance.dto';
import { ManualAttendanceDto } from './dto/manual-attendance.dto';

@Injectable()
export class AttendanceService {
  private readonly logger = new Logger(AttendanceService.name);

  constructor(private readonly prisma: PrismaService) {}

  async syncAttendance(dto: SyncAttendanceDto, user: any) {
    const { session_id, delegate_id, records } = dto;

    // 1. Verify session exists
    const session = await this.prisma.session.findUnique({
      where: { id: session_id },
      include: {
        section: true,
        delegate: true,
      },
    });

    if (!session) {
      throw new NotFoundException(`Session with ID ${session_id} not found`);
    }

    // 2. Authorization check
    if (user.role !== Role.ADMIN) {
      const isSectionTeacher = session.section.teacher_id === user.id;
      const isDelegateStudent = session.delegate.student_id === user.id;

      if (!isSectionTeacher && !isDelegateStudent) {
        throw new ForbiddenException(
          'You are not authorized to sync attendance records for this session',
        );
      }
    }

    // 3. Process records idempotently (Transaction or sequential upserts)
    let successfulSyncCount = 0;

    for (const record of records) {
      try {
        // Upsert in Attendance table with unique (session_id, student_id)
        await this.prisma.attendance.upsert({
          where: {
            session_id_student_id: {
              session_id,
              student_id: record.student_id,
            },
          },
          update: {
            attendance_state:
              record.attendance_state || AttendanceState.Present,
            attendance_method: record.attendance_method,
            marked_at: record.marked_at
              ? new Date(record.marked_at)
              : new Date(),
          },
          create: {
            session_id,
            student_id: record.student_id,
            attendance_state:
              record.attendance_state || AttendanceState.Present,
            attendance_method: record.attendance_method,
            marked_at: record.marked_at
              ? new Date(record.marked_at)
              : new Date(),
          },
        });

        // Upsert in AttendanceRequest for offline audit tracking
        await this.prisma.attendanceRequest.upsert({
          where: { request_id: record.request_id },
          update: {
            request_state: RequestState.Accepted,
          },
          create: {
            request_id: record.request_id,
            session_id,
            student_id: record.student_id,
            request_state: RequestState.Accepted,
            nonce: record.nonce,
            timestamp: BigInt(record.timestamp),
          },
        });

        successfulSyncCount++;
      } catch (error) {
        this.logger.error(
          `Failed to sync record for student ${record.student_id}: ${error.message}`,
        );
      }
    }

    // 4. Create SyncRecord
    const syncRecord = await this.prisma.syncRecord.create({
      data: {
        session_id,
        delegate_id,
        records_count: successfulSyncCount,
        sync_state: SyncState.Success,
        synced_at: new Date(),
      },
    });

    // 5. Update Session synced_at and state
    const nextState =
      session.session_state === SessionState.Closed
        ? SessionState.Synced
        : session.session_state;

    await this.prisma.session.update({
      where: { id: session_id },
      data: {
        synced_at: new Date(),
        session_state: nextState,
      },
    });

    // 6. Record Audit Log
    try {
      await this.prisma.auditLog.create({
        data: {
          user_id: user.id || user.sub,
          action: 'ATTENDANCE_SYNC_BATCH',
          entity_type: 'Session',
          entity_id: session_id,
          payload: JSON.stringify({
            synced_count: successfulSyncCount,
            total_sent: records.length,
            sync_record_id: syncRecord.id,
          }),
        },
      });
    } catch (err) {
      this.logger.warn(`Failed to write audit log: ${err.message}`);
    }

    this.logger.log(
      `Successfully synced ${successfulSyncCount}/${records.length} records for session ${session_id}`,
    );

    return {
      success: true,
      message: 'Attendance records synced successfully',
      session_id,
      synced_records_count: successfulSyncCount,
      total_received: records.length,
      synced_at: syncRecord.synced_at,
    };
  }

  async manualAttendance(dto: ManualAttendanceDto, user: any) {
    const { session_id, student_id, attendance_state, reason } = dto;

    const session = await this.prisma.session.findUnique({
      where: { id: session_id },
      include: { section: true },
    });

    if (!session) {
      throw new NotFoundException(`Session with ID ${session_id} not found`);
    }

    if (user.role !== Role.ADMIN && session.section.teacher_id !== user.id) {
      throw new ForbiddenException(
        'Only the instructor or an administrator can manually override attendance',
      );
    }

    const attendance = await this.prisma.attendance.upsert({
      where: {
        session_id_student_id: {
          session_id,
          student_id,
        },
      },
      update: {
        attendance_state,
        attendance_method: AttendanceMethod.Manual,
        marked_at: new Date(),
      },
      create: {
        session_id,
        student_id,
        attendance_state,
        attendance_method: AttendanceMethod.Manual,
        marked_at: new Date(),
      },
      include: {
        student: {
          include: {
            user: true,
          },
        },
      },
    });

    // Record Audit Log
    try {
      await this.prisma.auditLog.create({
        data: {
          user_id: user.id || user.sub,
          action: 'ATTENDANCE_MANUAL_MARK',
          entity_type: 'Attendance',
          entity_id: attendance.id,
          payload: JSON.stringify({
            session_id,
            student_id,
            attendance_state,
            reason: reason || 'Manual instructor adjustment',
          }),
        },
      });
    } catch (err) {
      this.logger.warn(`Failed to write audit log: ${err.message}`);
    }

    return attendance;
  }

  async getSessionAttendance(sessionId: string) {
    const session = await this.prisma.session.findUnique({
      where: { id: sessionId },
    });

    if (!session) {
      throw new NotFoundException(`Session with ID ${sessionId} not found`);
    }

    return this.prisma.attendance.findMany({
      where: { session_id: sessionId },
      include: {
        student: {
          include: {
            user: true,
            department: true,
          },
        },
      },
      orderBy: {
        marked_at: 'asc',
      },
    });
  }

  async getStudentAttendanceHistory(studentId: string) {
    return this.prisma.attendance.findMany({
      where: { student_id: studentId },
      include: {
        session: {
          include: {
            section: {
              include: {
                course: true,
                teacher: {
                  include: {
                    user: true,
                  },
                },
              },
            },
          },
        },
      },
      orderBy: {
        marked_at: 'desc',
      },
    });
  }
}
