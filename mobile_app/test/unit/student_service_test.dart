import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/student/services/student_service.dart';

void main() {
  group('StudentService Unit Tests', () {
    late StudentService service;

    setUp(() {
      service = StudentService(forceMockData: true);
    });

    test('getStudentProfile returns valid student profile data', () async {
      final profile = await service.getStudentProfile();
      expect(profile.id, isNotEmpty);
      expect(profile.studentNumber, contains('STD-'));
      expect(profile.fullName, isNotEmpty);
      expect(profile.departmentName, isNotEmpty);
    });

    test('getEnrolledCourses returns list of enrolled courses', () async {
      final courses = await service.getEnrolledCourses();
      expect(courses, isNotEmpty);
      expect(courses.length, greaterThanOrEqualTo(3));
      expect(courses.first.courseCode, isNotEmpty);
      expect(courses.first.attendancePercentage, inInclusiveRange(0.0, 100.0));
    });

    test('getCourseDetails finds course by ID or code', () async {
      final course = await service.getCourseDetails('CS301');
      expect(course, isNotNull);
      expect(course?.courseCode, 'CS301');

      final notFound = await service.getCourseDetails('NON_EXISTING_999');
      expect(notFound, isNull);
    });

    test('getAttendanceHistory returns all records and applies filters', () async {
      final allRecords = await service.getAttendanceHistory();
      expect(allRecords, isNotEmpty);

      final presentRecords = await service.getAttendanceHistory(attendanceState: 'Present');
      expect(presentRecords.every((r) => r.isPresent), true);

      final courseRecords = await service.getAttendanceHistory(courseCode: 'CS301');
      expect(courseRecords.every((r) => r.courseCode == 'CS301'), true);
    });

    test('getAttendanceStats returns valid aggregated stats', () async {
      final stats = await service.getAttendanceStats();
      expect(stats.totalSessions, greaterThan(0));
      expect(stats.totalPresent, greaterThan(0));
      expect(stats.attendancePercentage, inInclusiveRange(0.0, 100.0));
    });
  });
}
