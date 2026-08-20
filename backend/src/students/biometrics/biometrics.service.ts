import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { PrismaService, Role } from '../../prisma/prisma.service';
import { EnrollBiometricDto } from './dto/enroll-biometric.dto';
import { BiometricsCryptoService } from './biometrics-crypto.service';

@Injectable()
export class BiometricsService {
  private readonly logger = new Logger(BiometricsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly cryptoService: BiometricsCryptoService,
  ) {}

  private get db(): any {
    return this.prisma;
  }

  async enrollTemplate(
    studentId: string,
    dto: EnrollBiometricDto,
    user: any,
  ) {
    const { template_hash, encrypted_template_data } = dto;

    // 1. Verify student exists
    const student = await this.db.student.findUnique({
      where: { id: studentId },
      include: { user: true },
    });

    if (!student) {
      throw new NotFoundException(`Student with ID ${studentId} not found`);
    }

    // 2. Authorization check: Admin or the student themselves
    if (user.role !== Role.ADMIN && user.id !== studentId) {
      throw new ForbiddenException(
        'You are not authorized to enroll biometric data for this student',
      );
    }

    // 3. Validate template hash format
    if (!this.cryptoService.isValidHash(template_hash)) {
      throw new BadRequestException(
        'Invalid template_hash format. Must be a valid 64-character SHA-256 string',
      );
    }

    // 4. Upsert template in database (Zero Raw Image Storage: Embeddings Only)
    const template = await this.db.biometricTemplate.upsert({
      where: { student_id: studentId },
      update: {
        template_hash,
        encrypted_template_data,
        created_at: new Date(),
      },
      create: {
        student_id: studentId,
        template_hash,
        encrypted_template_data,
      },
    });

    // 5. Record Audit Log
    try {
      await this.db.auditLog.create({
        data: {
          user_id: user.id || user.sub,
          action: 'BIOMETRIC_TEMPLATE_ENROLL',
          entity_type: 'BiometricTemplate',
          entity_id: template.id,
          payload: JSON.stringify({
            student_id: studentId,
            student_number: student.student_number,
            template_hash,
          }),
        },
      });
    } catch (err: any) {
      this.logger.warn(`Failed to write audit log: ${err.message}`);
    }

    this.logger.log(`Biometric template enrolled for student ${student.student_number}`);

    return {
      id: template.id,
      student_id: template.student_id,
      student_number: student.student_number,
      full_name: student.user.full_name,
      template_hash: template.template_hash,
      created_at: template.created_at,
    };
  }

  async getSectionBiometrics(sectionId: string, user: any) {
    // 1. Verify section exists
    const section = await this.db.section.findUnique({
      where: { id: sectionId },
      include: {
        teacher: true,
        delegates: { where: { is_active: true } },
      },
    });

    if (!section) {
      throw new NotFoundException(`Section with ID ${sectionId} not found`);
    }

    // 2. Authorization check: Admin, Section Teacher, or Active Section Delegate
    if (user.role !== Role.ADMIN) {
      const isTeacher = section.teacher_id === user.id;
      const isDelegate = section.delegates.some(
        (d: any) => d.student_id === user.id,
      );

      if (!isTeacher && !isDelegate) {
        throw new ForbiddenException(
          'You are not authorized to download biometric packages for this section',
        );
      }
    }

    // 3. Fetch enrolled students and their encrypted biometric templates
    const enrollments = await this.db.enrollment.findMany({
      where: { section_id: sectionId },
      include: {
        student: {
          include: {
            user: {
              select: {
                id: true,
                full_name: true,
                username: true,
              },
            },
            biometric_template: true,
          },
        },
      },
    });

    const studentTemplates = enrollments
      .filter((e: any) => e.student && e.student.biometric_template !== null)
      .map((e: any) => ({
        student_id: e.student.id,
        student_number: e.student.student_number,
        full_name: e.student.user.full_name,
        template_hash: e.student.biometric_template.template_hash,
        encrypted_template_data:
          e.student.biometric_template.encrypted_template_data,
        updated_at: e.student.biometric_template.created_at,
      }));

    this.logger.log(
      `Exported ${studentTemplates.length} biometric templates for section ${sectionId}`,
    );

    return {
      section_id: sectionId,
      total_enrolled: enrollments.length,
      templates_count: studentTemplates.length,
      templates: studentTemplates,
    };
  }

  async getStudentBiometric(studentId: string, user: any) {
    const student = await this.db.student.findUnique({
      where: { id: studentId },
      include: {
        user: true,
        biometric_template: true,
      },
    });

    if (!student) {
      throw new NotFoundException(`Student with ID ${studentId} not found`);
    }

    if (user.role !== Role.ADMIN && user.id !== studentId) {
      throw new ForbiddenException(
        'You are not authorized to view this biometric template metadata',
      );
    }

    if (!student.biometric_template) {
      throw new NotFoundException(
        `No biometric template registered for student ${studentId}`,
      );
    }

    return {
      id: student.biometric_template.id,
      student_id: student.id,
      student_number: student.student_number,
      full_name: student.user.full_name,
      template_hash: student.biometric_template.template_hash,
      created_at: student.biometric_template.created_at,
    };
  }

  async deleteBiometric(studentId: string, user: any) {
    if (user.role !== Role.ADMIN) {
      throw new ForbiddenException(
        'Only administrators can delete or revoke biometric templates',
      );
    }

    const template = await this.db.biometricTemplate.findUnique({
      where: { student_id: studentId },
    });

    if (!template) {
      throw new NotFoundException(
        `Biometric template for student ${studentId} not found`,
      );
    }

    await this.db.biometricTemplate.delete({
      where: { student_id: studentId },
    });

    // Record Audit Log
    try {
      await this.db.auditLog.create({
        data: {
          user_id: user.id || user.sub,
          action: 'BIOMETRIC_TEMPLATE_REVOKE',
          entity_type: 'BiometricTemplate',
          entity_id: template.id,
          payload: JSON.stringify({
            student_id: studentId,
            revoked_at: new Date(),
          }),
        },
      });
    } catch (err: any) {
      this.logger.warn(`Failed to write audit log: ${err.message}`);
    }

    return {
      message: `Biometric template for student ${studentId} revoked successfully`,
    };
  }
}
