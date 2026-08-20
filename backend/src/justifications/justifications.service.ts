import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import {
  PrismaService,
  Role,
  AttendanceState,
  AttendanceMethod,
} from '../prisma/prisma.service';
import { SubmitJustificationDto } from './dto/submit-justification.dto';
import { ReviewJustificationDto } from './dto/review-justification.dto';

@Injectable()
export class JustificationsService {
  private readonly logger = new Logger(JustificationsService.name);

  constructor(private readonly prisma: PrismaService) {}

  private get db(): any {
    return this.prisma;
  }

  async submitJustification(
    studentId: string,
    dto: SubmitJustificationDto,
    user: any,
  ) {
    const { session_id, reason, document_url } = dto;

    if (user.role !== Role.ADMIN && user.id !== studentId) {
      throw new ForbiddenException(
        'You can only submit absence justifications for yourself',
      );
    }

    // 1. Verify student exists
    const student = await this.db.student.findUnique({
      where: { id: studentId },
      include: { user: true },
    });

    if (!student) {
      throw new NotFoundException(`Student with ID ${studentId} not found`);
    }

    // 2. Verify session exists
    const session = await this.db.session.findUnique({
      where: { id: session_id },
      include: { section: true },
    });

    if (!session) {
      throw new NotFoundException(`Session with ID ${session_id} not found`);
    }

    // 3. Verify student is enrolled in the section
    const enrollment = await this.db.enrollment.findUnique({
      where: {
        student_id_section_id: {
          student_id: studentId,
          section_id: session.section_id,
        },
      },
    });

    if (!enrollment) {
      throw new BadRequestException(
        `Student is not enrolled in the section for this session`,
      );
    }

    // 4. Record justification in audit logs
    const auditRecord = await this.db.auditLog.create({
      data: {
        user_id: user.id,
        action: 'JUSTIFICATION_SUBMIT',
        entity_type: 'Justification',
        entity_id: session_id,
        payload: JSON.stringify({
          student_id: studentId,
          student_number: student.student_number,
          session_id,
          section_id: session.section_id,
          reason,
          document_url,
          status: 'PENDING',
          submitted_at: new Date(),
        }),
      },
    });

    this.logger.log(
      `Absence justification submitted by student ${student.student_number} for session ${session_id}`,
    );

    return {
      justification_id: auditRecord.id,
      student_id: studentId,
      session_id,
      reason,
      document_url,
      status: 'PENDING',
      message: 'Absence justification submitted successfully and queued for review',
    };
  }

  async reviewJustification(
    justificationId: string,
    dto: ReviewJustificationDto,
    reviewer: any,
  ) {
    const { status, notes } = dto;

    // 1. Fetch justification audit log
    const justificationLog = await this.db.auditLog.findUnique({
      where: { id: justificationId },
    });

    if (
      !justificationLog ||
      justificationLog.entity_type !== 'Justification'
    ) {
      throw new NotFoundException(
        `Justification with ID ${justificationId} not found`,
      );
    }

    let payload: any = {};
    try {
      payload = JSON.parse(justificationLog.payload || '{}');
    } catch (e) {
      payload = {};
    }

    const { student_id, session_id, section_id } = payload;

    // 2. Authorization check: Section Teacher or Admin
    if (reviewer.role !== Role.ADMIN) {
      const section = await this.db.section.findUnique({
        where: { id: section_id },
      });

      if (!section || section.teacher_id !== reviewer.id) {
        throw new ForbiddenException(
          'Only the course teacher or an administrator can review this justification',
        );
      }
    }

    // 3. If APPROVED: update or create attendance record with Excused state
    if (status === 'APPROVED') {
      await this.db.attendance.upsert({
        where: {
          session_id_student_id: {
            session_id,
            student_id,
          },
        },
        update: {
          attendance_state: AttendanceState.Excused,
        },
        create: {
          session_id,
          student_id,
          attendance_state: AttendanceState.Excused,
          attendance_method: AttendanceMethod.Manual,
        },
      });

      this.logger.log(
        `Attendance state updated to Excused for student ${student_id} in session ${session_id}`,
      );
    }

    // 4. Record review decision in audit logs
    const reviewLog = await this.db.auditLog.create({
      data: {
        user_id: reviewer.id,
        action: `JUSTIFICATION_REVIEW_${status}`,
        entity_type: 'Justification',
        entity_id: justificationId,
        payload: JSON.stringify({
          justification_id: justificationId,
          student_id,
          session_id,
          reviewed_by: reviewer.id,
          status,
          notes,
          reviewed_at: new Date(),
        }),
      },
    });

    return {
      justification_id: justificationId,
      student_id,
      session_id,
      status,
      notes,
      reviewed_by: reviewer.id,
      message: `Justification ${status.toLowerCase()} successfully`,
    };
  }

  async getSectionJustifications(sectionId: string, user: any) {
    if (user.role !== Role.ADMIN) {
      const section = await this.db.section.findUnique({
        where: { id: sectionId },
      });

      if (!section || section.teacher_id !== user.id) {
        throw new ForbiddenException(
          'You are not authorized to view justifications for this section',
        );
      }
    }

    const logs = await this.db.auditLog.findMany({
      where: {
        entity_type: 'Justification',
        action: 'JUSTIFICATION_SUBMIT',
      },
      include: {
        user: { select: { id: true, full_name: true, username: true } },
      },
      orderBy: { timestamp: 'desc' },
    });

    const sectionJustifications = logs
      .filter((log: any) => {
        try {
          const parsed = JSON.parse(log.payload || '{}');
          return parsed.section_id === sectionId;
        } catch {
          return false;
        }
      })
      .map((log: any) => {
        const payload = JSON.parse(log.payload || '{}');
        return {
          id: log.id,
          student_id: payload.student_id,
          student_name: log.user?.full_name,
          session_id: payload.session_id,
          reason: payload.reason,
          document_url: payload.document_url,
          status: payload.status || 'PENDING',
          submitted_at: log.timestamp,
        };
      });

    return {
      section_id: sectionId,
      total_justifications: sectionJustifications.length,
      justifications: sectionJustifications,
    };
  }
}
