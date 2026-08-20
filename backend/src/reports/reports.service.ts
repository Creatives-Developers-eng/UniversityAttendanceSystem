import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { PrismaService, AttendanceState } from '../prisma/prisma.service';
import { DeprivationQueryDto } from './dto/deprivation-query.dto';

@Injectable()
export class ReportsService {
  private readonly logger = new Logger(ReportsService.name);

  constructor(private readonly prisma: PrismaService) {}

  private get db(): any {
    return this.prisma;
  }

  async getSectionAttendanceReport(sectionId: string) {
    const section = await this.db.section.findUnique({
      where: { id: sectionId },
      include: {
        course: true,
        semester: { include: { academic_year: true } },
        teacher: { include: { user: true } },
        sessions: {
          orderBy: { opened_at: 'asc' },
        },
        enrollments: {
          include: {
            student: {
              include: { user: true },
            },
          },
        },
      },
    });

    if (!section) {
      throw new NotFoundException(`Section with ID ${sectionId} not found`);
    }

    const totalSessions = section.sessions.length;
    const sessionIds = section.sessions.map((s: any) => s.id);

    const attendanceRecords = await this.db.attendance.findMany({
      where: { session_id: { in: sessionIds } },
    });

    const studentsReport = section.enrollments.map((enrollment: any) => {
      const student = enrollment.student;
      const studentAttendances = attendanceRecords.filter(
        (a: any) => a.student_id === student.id,
      );

      const presentCount = studentAttendances.filter(
        (a: any) => a.attendance_state === AttendanceState.Present,
      ).length;

      const lateCount = studentAttendances.filter(
        (a: any) => a.attendance_state === AttendanceState.Late,
      ).length;

      const excusedCount = studentAttendances.filter(
        (a: any) => a.attendance_state === AttendanceState.Excused,
      ).length;

      const absentCount =
        totalSessions > 0
          ? totalSessions - (presentCount + lateCount + excusedCount)
          : 0;

      const effectiveAbsent = absentCount > 0 ? absentCount : 0;
      const totalAttended = presentCount + lateCount + excusedCount;

      const attendancePercentage =
        totalSessions > 0
          ? Number(((totalAttended / totalSessions) * 100).toFixed(2))
          : 100.0;

      const absencePercentage =
        totalSessions > 0
          ? Number(((effectiveAbsent / totalSessions) * 100).toFixed(2))
          : 0.0;

      const isDeprived = absencePercentage > 25.0;

      let warningStatus = 'NORMAL';
      if (isDeprived) {
        warningStatus = 'DEPRIVED';
      } else if (absencePercentage >= 20.0) {
        warningStatus = 'CRITICAL';
      } else if (absencePercentage >= 15.0) {
        warningStatus = 'WARNING';
      }

      return {
        student_id: student.id,
        student_number: student.student_number,
        full_name: student.user.full_name,
        present_count: presentCount,
        late_count: lateCount,
        excused_count: excusedCount,
        absent_count: effectiveAbsent,
        total_sessions: totalSessions,
        attendance_percentage: attendancePercentage,
        absence_percentage: absencePercentage,
        is_deprived: isDeprived,
        warning_status: warningStatus,
      };
    });

    const overallAttendanceRate =
      studentsReport.length > 0
        ? Number(
            (
              studentsReport.reduce(
                (sum: number, s: any) => sum + s.attendance_percentage,
                0,
              ) / studentsReport.length
            ).toFixed(2),
          )
        : 100.0;

    const deprivedCount = studentsReport.filter((s: any) => s.is_deprived).length;

    return {
      section_id: section.id,
      course_code: section.course.course_code,
      course_title: section.course.title,
      section_number: section.section_number,
      section_type: section.section_type,
      teacher_name: section.teacher.user.full_name,
      academic_year: section.semester.academic_year.year_name,
      semester: section.semester.semester_type,
      total_sessions: totalSessions,
      total_enrolled: section.enrollments.length,
      deprived_students_count: deprivedCount,
      overall_attendance_rate: overallAttendanceRate,
      students: studentsReport,
    };
  }

  async getStudentAttendanceReport(studentId: string, semesterId?: string) {
    const student = await this.db.student.findUnique({
      where: { id: studentId },
      include: {
        user: true,
        department: true,
        academic_year: true,
      },
    });

    if (!student) {
      throw new NotFoundException(`Student with ID ${studentId} not found`);
    }

    const whereEnrollment: any = { student_id: studentId };
    if (semesterId) {
      whereEnrollment.section = { semester_id: semesterId };
    }

    const enrollments = await this.db.enrollment.findMany({
      where: whereEnrollment,
      include: {
        section: {
          include: {
            course: true,
            semester: true,
            teacher: { include: { user: true } },
            sessions: true,
          },
        },
      },
    });

    const coursesReport = await Promise.all(
      enrollments.map(async (e: any) => {
        const section = e.section;
        const totalSessions = section.sessions.length;
        const sessionIds = section.sessions.map((s: any) => s.id);

        const attendances = await this.db.attendance.findMany({
          where: {
            session_id: { in: sessionIds },
            student_id: studentId,
          },
        });

        const presentCount = attendances.filter(
          (a: any) => a.attendance_state === AttendanceState.Present,
        ).length;
        const lateCount = attendances.filter(
          (a: any) => a.attendance_state === AttendanceState.Late,
        ).length;
        const excusedCount = attendances.filter(
          (a: any) => a.attendance_state === AttendanceState.Excused,
        ).length;

        const absentCount =
          totalSessions > 0
            ? totalSessions - (presentCount + lateCount + excusedCount)
            : 0;

        const effectiveAbsent = absentCount > 0 ? absentCount : 0;
        const totalAttended = presentCount + lateCount + excusedCount;

        const attendancePercentage =
          totalSessions > 0
            ? Number(((totalAttended / totalSessions) * 100).toFixed(2))
            : 100.0;

        const absencePercentage =
          totalSessions > 0
            ? Number(((effectiveAbsent / totalSessions) * 100).toFixed(2))
            : 0.0;

        const isDeprived = absencePercentage > 25.0;

        return {
          section_id: section.id,
          course_code: section.course.course_code,
          course_title: section.course.title,
          section_type: section.section_type,
          teacher_name: section.teacher.user.full_name,
          total_sessions: totalSessions,
          present_count: presentCount,
          late_count: lateCount,
          excused_count: excusedCount,
          absent_count: effectiveAbsent,
          attendance_percentage: attendancePercentage,
          absence_percentage: absencePercentage,
          is_deprived: isDeprived,
        };
      }),
    );

    return {
      student_id: student.id,
      student_number: student.student_number,
      full_name: student.user.full_name,
      department: student.department.name,
      academic_year: student.academic_year.year_name,
      total_enrolled_courses: coursesReport.length,
      courses: coursesReport,
    };
  }

  async getCourseDeprivationList(
    courseId: string,
    query: DeprivationQueryDto = {},
  ) {
    const { section_id, threshold_percent = 25.0 } = query;

    const course = await this.db.course.findUnique({
      where: { id: courseId },
      include: {
        sections: {
          where: section_id ? { id: section_id } : undefined,
          include: {
            teacher: { include: { user: true } },
            sessions: true,
            enrollments: {
              include: {
                student: { include: { user: true } },
              },
            },
          },
        },
      },
    });

    if (!course) {
      throw new NotFoundException(`Course with ID ${courseId} not found`);
    }

    const deprivedStudents: any[] = [];

    for (const section of course.sections) {
      const totalSessions = section.sessions.length;
      if (totalSessions === 0) continue;

      const sessionIds = section.sessions.map((s: any) => s.id);
      const attendances = await this.db.attendance.findMany({
        where: { session_id: { in: sessionIds } },
      });

      for (const enrollment of section.enrollments) {
        const student = enrollment.student;
        const studentAttendances = attendances.filter(
          (a: any) => a.student_id === student.id,
        );

        const attended = studentAttendances.filter(
          (a: any) =>
            a.attendance_state === AttendanceState.Present ||
            a.attendance_state === AttendanceState.Late ||
            a.attendance_state === AttendanceState.Excused,
        ).length;

        const absentCount = totalSessions - attended;
        const absencePercentage = Number(
          ((absentCount / totalSessions) * 100).toFixed(2),
        );

        if (absencePercentage > threshold_percent) {
          deprivedStudents.push({
            student_id: student.id,
            student_number: student.student_number,
            full_name: student.user.full_name,
            section_id: section.id,
            section_number: section.section_number,
            section_type: section.section_type,
            teacher_name: section.teacher.user.full_name,
            total_sessions: totalSessions,
            absent_sessions: absentCount,
            absence_percentage: absencePercentage,
            threshold_percent,
            deprivation_status: 'DEPRIVED',
          });
        }
      }
    }

    return {
      course_id: course.id,
      course_code: course.course_code,
      course_title: course.title,
      threshold_percent,
      deprived_count: deprivedStudents.length,
      deprived_students: deprivedStudents,
    };
  }

  async getTeacherSectionsSummary(teacherId: string) {
    const teacher = await this.db.teacher.findUnique({
      where: { id: teacherId },
      include: {
        user: true,
        sections: {
          include: {
            course: true,
            sessions: true,
            enrollments: true,
          },
        },
      },
    });

    if (!teacher) {
      throw new NotFoundException(`Teacher with ID ${teacherId} not found`);
    }

    const sectionsSummary = teacher.sections.map((section: any) => ({
      section_id: section.id,
      course_code: section.course.course_code,
      course_title: section.course.title,
      section_number: section.section_number,
      section_type: section.section_type,
      total_sessions: section.sessions.length,
      total_enrolled_students: section.enrollments.length,
    }));

    return {
      teacher_id: teacher.id,
      teacher_name: teacher.user.full_name,
      total_sections: sectionsSummary.length,
      sections: sectionsSummary,
    };
  }

  async getSystemDashboardStats() {
    const [
      totalStudents,
      totalTeachers,
      totalCourses,
      totalSections,
      totalSessions,
      totalAttendances,
    ] = await Promise.all([
      this.db.student.count(),
      this.db.teacher.count(),
      this.db.course.count(),
      this.db.section.count(),
      this.db.session.count(),
      this.db.attendance.count(),
    ]);

    const presentAttendances = await this.db.attendance.count({
      where: {
        attendance_state: {
          in: [
            AttendanceState.Present,
            AttendanceState.Late,
            AttendanceState.Excused,
          ],
        },
      },
    });

    const systemAttendanceRate =
      totalAttendances > 0
        ? Number(((presentAttendances / totalAttendances) * 100).toFixed(2))
        : 100.0;

    return {
      total_students: totalStudents,
      total_teachers: totalTeachers,
      total_courses: totalCourses,
      total_sections: totalSections,
      total_sessions: totalSessions,
      total_attendance_records: totalAttendances,
      system_attendance_rate: systemAttendanceRate,
    };
  }
}
