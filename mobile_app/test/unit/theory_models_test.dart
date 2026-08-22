import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/theoretical_teacher/models/attendance_analytics.dart';
import 'package:mobile_app/theoretical_teacher/models/deprivation_student.dart';
import 'package:mobile_app/theoretical_teacher/models/theory_course.dart';

void main() {
  group('TheoryCourse Model Tests', () {
    test('Constructs, computes rate, and serializes correctly', () {
      const course = TheoryCourse(
        id: 'crs-swe-301',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات المتقدمة',
        departmentName: 'علوم الحاسوب',
        creditHours: 3,
        sections: ['01', '02'],
        totalStudents: 95,
        totalLecturesDelivered: 14,
        averageAttendanceRate: 86.5,
        atRiskStudentsCount: 3,
        deprivedStudentsCount: 1,
      );

      expect(course.id, 'crs-swe-301');
      expect(course.courseCode, 'CS301');
      expect(course.formattedAttendanceRate, '86.5%');
      expect(course.sections.length, 2);

      final json = course.toJson();
      expect(json['course_code'], 'CS301');
      expect(json['total_students'], 95);

      final fromJson = TheoryCourse.fromJson(json);
      expect(fromJson.id, course.id);
      expect(fromJson.courseName, course.courseName);
      expect(fromJson.averageAttendanceRate, 86.5);
    });
  });

  group('AttendanceAnalytics Model Tests', () {
    test('Constructs, computes percentages, and serializes correctly', () {
      const analytics = AttendanceAnalytics(
        courseId: 'crs-swe-301',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات المتقدمة',
        totalLectures: 14,
        totalEnrolledStudents: 100,
        presentCount: 700,
        absentCount: 150,
        lateCount: 100,
        excusedCount: 50,
        weeklyTrends: [
          WeeklyTrendItem(weekNumber: 1, weekLabel: 'أسبوع 1', attendanceRate: 90.0, absentRate: 10.0),
        ],
      );

      expect(analytics.totalRecords, 1000);
      expect(analytics.presentPercentage, 70.0);
      expect(analytics.absentPercentage, 15.0);
      expect(analytics.latePercentage, 10.0);
      expect(analytics.excusedPercentage, 5.0);
      expect(analytics.weeklyTrends.first.weekLabel, 'أسبوع 1');

      final json = analytics.toJson();
      final fromJson = AttendanceAnalytics.fromJson(json);
      expect(fromJson.courseCode, 'CS301');
      expect(fromJson.presentPercentage, 70.0);
      expect(fromJson.weeklyTrends.length, 1);
    });
  });

  group('DeprivationStudent Model Tests', () {
    test('Constructs and evaluates risk levels correctly', () {
      final now = DateTime(2026, 8, 21);
      final student = DeprivationStudent(
        studentId: 'std-201',
        studentNumber: 'STD-2023-5011',
        fullName: 'خالد وليد النعيمي',
        departmentName: 'علوم الحاسوب',
        sectionNumber: '01',
        totalLectures: 14,
        absentLecturesCount: 4,
        absencePercentage: 28.5,
        riskLevel: DeprivationRiskLevel.deprived,
        warningStatus: 'قرار الحرمان النهائي',
        lastWarningSentAt: now,
      );

      expect(student.isDeprived, true);
      expect(student.isAtRisk, true);
      expect(student.riskLevelArabic, 'محروم نهائياً (25%+)');

      final warningStudent = student.copyWith(
        riskLevel: DeprivationRiskLevel.warningFirst,
        absencePercentage: 15.0,
      );
      expect(warningStudent.isWarningFirst, true);
      expect(warningStudent.isDeprived, false);
      expect(warningStudent.riskLevelArabic, 'إنذار أول (15%)');

      final json = student.toJson();
      final fromJson = DeprivationStudent.fromJson(json);
      expect(fromJson.studentNumber, 'STD-2023-5011');
      expect(fromJson.riskLevel, DeprivationRiskLevel.deprived);
    });
  });
}
