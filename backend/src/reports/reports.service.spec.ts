import { Test, TestingModule } from '@nestjs/testing';
import { ReportsService } from './reports.service';
import { PrismaService, AttendanceState } from '../prisma/prisma.service';
import { NotFoundException } from '@nestjs/common';

describe('ReportsService', () => {
  let service: ReportsService;
  let prisma: PrismaService;

  const mockPrisma = {
    section: {
      findUnique: jest.fn(),
      count: jest.fn(),
    },
    student: {
      findUnique: jest.fn(),
      count: jest.fn(),
    },
    teacher: {
      findUnique: jest.fn(),
      count: jest.fn(),
    },
    course: {
      findUnique: jest.fn(),
      count: jest.fn(),
    },
    session: {
      count: jest.fn(),
    },
    attendance: {
      findMany: jest.fn(),
      count: jest.fn(),
    },
    enrollment: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReportsService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<ReportsService>(ReportsService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getSectionAttendanceReport', () => {
    const sectionId = 'sec-100';

    it('should accurately calculate attendance percentages and deprivation status (>25% absence)', async () => {
      mockPrisma.section.findUnique.mockResolvedValue({
        id: sectionId,
        section_number: '1',
        section_type: 'THEORETICAL',
        course: { course_code: 'CS101', title: 'Computer Science 101' },
        semester: { semester_type: 'FIRST', academic_year: { year_name: '2025/2026' } },
        teacher: { user: { full_name: 'Dr. John' } },
        sessions: [{ id: 'sess-1' }, { id: 'sess-2' }, { id: 'sess-3' }, { id: 'sess-4' }],
        enrollments: [
          {
            student: {
              id: 'stud-1',
              student_number: 'STU001',
              user: { full_name: 'Active Student' },
            },
          },
          {
            student: {
              id: 'stud-2',
              student_number: 'STU002',
              user: { full_name: 'Deprived Student' },
            },
          },
        ],
      });

      // stud-1 attended 4 sessions (0% absence)
      // stud-2 attended 2 sessions (50% absence -> Deprived)
      mockPrisma.attendance.findMany.mockResolvedValue([
        { session_id: 'sess-1', student_id: 'stud-1', attendance_state: AttendanceState.Present },
        { session_id: 'sess-2', student_id: 'stud-1', attendance_state: AttendanceState.Present },
        { session_id: 'sess-3', student_id: 'stud-1', attendance_state: AttendanceState.Present },
        { session_id: 'sess-4', student_id: 'stud-1', attendance_state: AttendanceState.Present },
        { session_id: 'sess-1', student_id: 'stud-2', attendance_state: AttendanceState.Present },
        { session_id: 'sess-2', student_id: 'stud-2', attendance_state: AttendanceState.Present },
      ]);

      const report = await service.getSectionAttendanceReport(sectionId);

      expect(report.section_id).toBe(sectionId);
      expect(report.total_sessions).toBe(4);
      expect(report.total_enrolled).toBe(2);
      expect(report.deprived_students_count).toBe(1);

      const activeStudent = report.students.find((s) => s.student_id === 'stud-1');
      expect(activeStudent.absence_percentage).toBe(0);
      expect(activeStudent.is_deprived).toBe(false);
      expect(activeStudent.warning_status).toBe('NORMAL');

      const deprivedStudent = report.students.find((s) => s.student_id === 'stud-2');
      expect(deprivedStudent.absence_percentage).toBe(50.0);
      expect(deprivedStudent.is_deprived).toBe(true);
      expect(deprivedStudent.warning_status).toBe('DEPRIVED');
    });

    it('should throw NotFoundException if section is not found', async () => {
      mockPrisma.section.findUnique.mockResolvedValue(null);

      await expect(service.getSectionAttendanceReport('sec-missing')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('getCourseDeprivationList', () => {
    const courseId = 'course-1';

    it('should list all students exceeding deprivation threshold', async () => {
      mockPrisma.course.findUnique.mockResolvedValue({
        id: courseId,
        course_code: 'CS101',
        title: 'Computer Science',
        sections: [
          {
            id: 'sec-1',
            section_number: '1',
            section_type: 'THEORETICAL',
            teacher: { user: { full_name: 'Dr. John' } },
            sessions: [{ id: 'sess-1' }, { id: 'sess-2' }, { id: 'sess-3' }, { id: 'sess-4' }],
            enrollments: [
              {
                student: {
                  id: 'stud-1',
                  student_number: 'STU001',
                  user: { full_name: 'Deprived Student' },
                },
              },
            ],
          },
        ],
      });

      // stud-1 attended 1 out of 4 (75% absence > 25%)
      mockPrisma.attendance.findMany.mockResolvedValue([
        { session_id: 'sess-1', student_id: 'stud-1', attendance_state: AttendanceState.Present },
      ]);

      const result = await service.getCourseDeprivationList(courseId, { threshold_percent: 25.0 });

      expect(result.course_id).toBe(courseId);
      expect(result.deprived_count).toBe(1);
      expect(result.deprived_students[0].student_id).toBe('stud-1');
      expect(result.deprived_students[0].absence_percentage).toBe(75.0);
      expect(result.deprived_students[0].deprivation_status).toBe('DEPRIVED');
    });
  });
});
