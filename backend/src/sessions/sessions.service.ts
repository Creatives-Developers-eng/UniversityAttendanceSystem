import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { PrismaService, SessionState, Role } from '../prisma/prisma.service';
import { StartSessionDto } from './dto/start-session.dto';
import { CloseSessionDto } from './dto/close-session.dto';

@Injectable()
export class SessionsService {
  private readonly logger = new Logger(SessionsService.name);

  constructor(private readonly prisma: PrismaService) {}

  async startSession(dto: StartSessionDto, user: any) {
    const { section_id, delegate_id } = dto;

    // 1. Verify section exists
    const section = await this.prisma.section.findUnique({
      where: { id: section_id },
      include: {
        course: true,
        teacher: true,
      },
    });

    if (!section) {
      throw new NotFoundException(`Section with ID ${section_id} not found`);
    }

    // 2. Verify delegate exists and is active for this section
    const delegate = await this.prisma.delegate.findUnique({
      where: { id: delegate_id },
      include: {
        student: {
          include: {
            user: true,
          },
        },
      },
    });

    if (!delegate) {
      throw new NotFoundException(`Delegate with ID ${delegate_id} not found`);
    }

    if (!delegate.is_active || delegate.section_id !== section_id) {
      throw new BadRequestException(
        `Delegate is not active or not assigned to section ${section_id}`,
      );
    }

    // 3. Authorization check: User must be Admin, the Section Teacher, or the Delegate student
    if (user.role !== Role.ADMIN) {
      const isSectionTeacher = section.teacher_id === user.id;
      const isDelegateStudent = delegate.student_id === user.id;

      if (!isSectionTeacher && !isDelegateStudent) {
        throw new ForbiddenException(
          'You are not authorized to start a session for this section',
        );
      }
    }

    // 4. Check for active/opened sessions on this section
    const existingActiveSession = await this.prisma.session.findFirst({
      where: {
        section_id,
        session_state: {
          in: [SessionState.Opened, SessionState.Active],
        },
      },
    });

    if (existingActiveSession) {
      throw new ConflictException(
        `An active session already exists for this section (Session ID: ${existingActiveSession.id})`,
      );
    }

    // 5. Create new session
    const session = await this.prisma.session.create({
      data: {
        section_id,
        delegate_id,
        session_state: SessionState.Active,
        opened_at: new Date(),
      },
      include: {
        section: {
          include: {
            course: true,
          },
        },
        delegate: {
          include: {
            student: {
              include: {
                user: true,
              },
            },
          },
        },
      },
    });

    // 6. Record Audit Log
    try {
      await this.prisma.auditLog.create({
        data: {
          user_id: user.id || user.sub,
          action: 'SESSION_START',
          entity_type: 'Session',
          entity_id: session.id,
          payload: JSON.stringify({
            section_id,
            delegate_id,
            course_code: section.course.course_code,
            opened_at: session.opened_at,
          }),
        },
      });
    } catch (err) {
      this.logger.warn(`Failed to write audit log: ${err.message}`);
    }

    this.logger.log(`Session ${session.id} started successfully for section ${section_id}`);

    return session;
  }

  async closeSession(dto: CloseSessionDto, user: any) {
    const { session_id } = dto;

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

    // 2. Check current state
    if (
      session.session_state !== SessionState.Active &&
      session.session_state !== SessionState.Opened
    ) {
      throw new BadRequestException(
        `Session cannot be closed. Current state is: ${session.session_state}`,
      );
    }

    // 3. Authorization check
    if (user.role !== Role.ADMIN) {
      const isSectionTeacher = session.section.teacher_id === user.id;
      const isDelegateStudent = session.delegate.student_id === user.id;

      if (!isSectionTeacher && !isDelegateStudent) {
        throw new ForbiddenException(
          'You are not authorized to close this session',
        );
      }
    }

    // 4. Update session to Closed
    const closedSession = await this.prisma.session.update({
      where: { id: session_id },
      data: {
        session_state: SessionState.Closed,
        closed_at: new Date(),
      },
      include: {
        section: {
          include: {
            course: true,
          },
        },
        attendances: true,
      },
    });

    // 5. Record Audit Log
    try {
      await this.prisma.auditLog.create({
        data: {
          user_id: user.id || user.sub,
          action: 'SESSION_CLOSE',
          entity_type: 'Session',
          entity_id: session.id,
          payload: JSON.stringify({
            closed_at: closedSession.closed_at,
            attendance_count: closedSession.attendances.length,
          }),
        },
      });
    } catch (err) {
      this.logger.warn(`Failed to write audit log: ${err.message}`);
    }

    this.logger.log(`Session ${session_id} closed successfully`);

    return closedSession;
  }

  async getActiveSessions() {
    return this.prisma.session.findMany({
      where: {
        session_state: {
          in: [SessionState.Opened, SessionState.Active],
        },
      },
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
        delegate: {
          include: {
            student: {
              include: {
                user: true,
              },
            },
          },
        },
        _count: {
          select: {
            attendances: true,
          },
        },
      },
      orderBy: {
        opened_at: 'desc',
      },
    });
  }

  async getSessionById(id: string) {
    const session = await this.prisma.session.findUnique({
      where: { id },
      include: {
        section: {
          include: {
            course: true,
            teacher: {
              include: {
                user: true,
              },
            },
            enrollments: {
              include: {
                student: {
                  include: {
                    user: true,
                  },
                },
              },
            },
          },
        },
        delegate: {
          include: {
            student: {
              include: {
                user: true,
              },
            },
          },
        },
        attendances: {
          include: {
            student: {
              include: {
                user: true,
              },
            },
          },
        },
      },
    });

    if (!session) {
      throw new NotFoundException(`Session with ID ${id} not found`);
    }

    return session;
  }

  async getSectionSessions(sectionId: string) {
    return this.prisma.session.findMany({
      where: { section_id: sectionId },
      include: {
        delegate: {
          include: {
            student: {
              include: {
                user: true,
              },
            },
          },
        },
        _count: {
          select: {
            attendances: true,
          },
        },
      },
      orderBy: {
        opened_at: 'desc',
      },
    });
  }
}
