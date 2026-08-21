import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/theoretical_teacher/models/deprivation_student.dart';
import 'package:mobile_app/theoretical_teacher/services/theoretical_teacher_service.dart';

void main() {
  group('TheoreticalTeacherService Unit Tests', () {
    late TheoreticalTeacherService service;

    setUp(() {
      service = TheoreticalTeacherService(forceMockData: true);
    });

    test('getTeacherProfile returns valid theoretical teacher data', () async {
      final profile = await service.getTeacherProfile();
      expect(profile['full_name'], contains('السقاف'));
      expect(profile['active_courses_count'], greaterThan(0));
    });

    test('getTheoryCourses returns courses list', () async {
      final courses = await service.getTheoryCourses();
      expect(courses, isNotEmpty);
      expect(courses.first.courseCode, isNotEmpty);
      expect(courses.first.sections, isNotEmpty);
    });

    test('getCourseDetails returns matching course', () async {
      final course = await service.getCourseDetails('crs-swe-301');
      expect(course, isNotNull);
      expect(course?.courseCode, 'CS301');
    });

    test('getCourseAnalytics returns comprehensive metrics and trends', () async {
      final analytics = await service.getCourseAnalytics('crs-swe-301');
      expect(analytics.courseCode, 'CS301');
      expect(analytics.weeklyTrends, isNotEmpty);
      expect(analytics.totalRecords, greaterThan(0));
    });

    test('getDeprivationStudents filters by risk correctly', () async {
      final all = await service.getDeprivationStudents('crs-swe-301');
      expect(all, isNotEmpty);

      final deprivedOnly = await service.getDeprivationStudents(
        'crs-swe-301',
        riskFilter: DeprivationRiskLevel.deprived,
      );
      expect(deprivedOnly.every((s) => s.isDeprived), true);
    });

    test('getAllAtRiskStudents returns aggregated risk list', () async {
      final atRisk = await service.getAllAtRiskStudents();
      expect(atRisk, isNotEmpty);
      expect(atRisk.every((s) => s.isAtRisk), true);
    });

    test('sendDeprivationWarning updates student status and sends warning', () async {
      final updated = await service.sendDeprivationWarning(
        'crs-swe-301',
        'std-205',
        'FINAL_WARNING',
      );

      expect(updated.riskLevel, DeprivationRiskLevel.warningSecond);
      expect(updated.warningStatus, contains('الإنذار الثاني'));
      expect(updated.lastWarningSentAt, isNotNull);
    });

    test('exportAttendanceReport returns valid filename', () async {
      final pdfReport = await service.exportAttendanceReport('crs-swe-301', 'pdf');
      expect(pdfReport, contains('REPORT-CRS-SWE-301'));
      expect(pdfReport, endsWith('.pdf'));

      final xlsxReport = await service.exportAttendanceReport('crs-swe-301', 'xlsx');
      expect(xlsxReport, endsWith('.xlsx'));
    });
  });
}
