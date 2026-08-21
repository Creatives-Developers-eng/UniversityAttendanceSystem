import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/student/models/attendance_stats.dart';
import 'package:mobile_app/student/models/student_attendance_record.dart';
import 'package:mobile_app/student/models/student_course.dart';
import 'package:mobile_app/student/models/student_profile.dart';

void main() {
  group('StudentProfile Model Tests', () {
    test('Constructs and converts to/from JSON correctly', () {
      const profile = StudentProfile(
        id: 'usr-std-001',
        studentNumber: 'STD-2023-4019',
        fullName: 'أحمد علي عبد الله',
        email: 'ahmed.ali@univ.edu',
        phone: '+967 771 234 567',
        departmentId: 'dep-it-01',
        departmentName: 'هندسة تقنية المعلومات',
        collegeName: 'كلية الهندسة والحاسوب',
        academicYearId: 'ay-2025-2026',
        academicYearName: '2025/2026',
        academicLevel: 3,
        accountState: StudentAccountState.active,
        deviceState: StudentDeviceState.bound,
        boundDeviceId: 'dev-sec-samsung-n960u',
      );

      expect(profile.id, 'usr-std-001');
      expect(profile.studentNumber, 'STD-2023-4019');
      expect(profile.fullName, 'أحمد علي عبد الله');
      expect(profile.accountState, StudentAccountState.active);
      expect(profile.deviceState, StudentDeviceState.bound);

      final json = profile.toJson();
      expect(json['id'], 'usr-std-001');
      expect(json['student_number'], 'STD-2023-4019');
      expect(json['account_state'], 'active');
      expect(json['device_state'], 'bound');

      final fromJson = StudentProfile.fromJson(json);
      expect(fromJson.id, profile.id);
      expect(fromJson.studentNumber, profile.studentNumber);
      expect(fromJson.fullName, profile.fullName);
      expect(fromJson.accountState, StudentAccountState.active);
    });
  });

  group('StudentCourse Model Tests', () {
    test('Constructs, calculates attendance percentage, and handles warnings', () {
      const course = StudentCourse(
        id: 'crs-001',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات المتقدمة',
        creditHours: 3,
        sectionId: 'sec-001-p',
        sectionNumber: 'شعبة 1',
        sectionType: SectionType.practical,
        teacherName: 'د. محمد السعيد',
        totalLectures: 14,
        attendedLectures: 13,
        absentLectures: 1,
        lateLectures: 0,
        excusedLectures: 0,
        roomName: 'معمل الحاسوب 3',
        scheduleTime: 'الأحد 08:00 ص - 10:00 ص',
      );

      expect(course.attendancePercentage, closeTo(92.85, 0.1));
      expect(course.isWarning, false);
      expect(course.isDeprived, false);
      expect(course.sectionTypeArabic, 'عملي');

      final json = course.toJson();
      final fromJson = StudentCourse.fromJson(json);
      expect(fromJson.courseCode, 'CS301');
      expect(fromJson.sectionType, SectionType.practical);
    });

    test('Identifies warning and deprived states correctly', () {
      const warningCourse = StudentCourse(
        id: 'crs-002',
        courseCode: 'CS302',
        courseName: 'مادة إنذار',
        creditHours: 3,
        sectionId: 'sec-002-t',
        sectionNumber: 'شعبة 2',
        sectionType: SectionType.theoretical,
        teacherName: 'أستاذ',
        totalLectures: 10,
        attendedLectures: 8,
        absentLectures: 2,
        roomName: 'قاعة 1',
        scheduleTime: 'الوقت',
      );
      // 8 / 10 = 80.0% -> warning (<85% and >=75%)
      expect(warningCourse.attendancePercentage, 80.0);
      expect(warningCourse.isWarning, true);
      expect(warningCourse.isDeprived, false);

      const deprivedCourse = StudentCourse(
        id: 'crs-003',
        courseCode: 'CS303',
        courseName: 'مادة حرمان',
        creditHours: 3,
        sectionId: 'sec-003-p',
        sectionNumber: 'شعبة 1',
        sectionType: SectionType.practical,
        teacherName: 'أستاذ',
        totalLectures: 10,
        attendedLectures: 6,
        absentLectures: 4,
        roomName: 'معمل 1',
        scheduleTime: 'الوقت',
      );
      // 6 / 10 = 60.0% -> deprived (<75%)
      expect(deprivedCourse.attendancePercentage, 60.0);
      expect(deprivedCourse.isDeprived, true);
    });
  });

  group('StudentAttendanceRecord Model Tests', () {
    test('Constructs, serializes, and parses state helpers correctly', () {
      final now = DateTime(2026, 8, 20, 9, 0);
      final record = StudentAttendanceRecord(
        id: 'rec-001',
        sessionId: 'ses-101',
        courseId: 'crs-004',
        courseCode: 'IT308',
        courseName: 'تطوير تطبيقات الهواتف الذكية',
        sectionNumber: 'شعبة 1',
        teacherName: 'م. أواب النزيلي',
        sessionDate: now,
        attendanceState: 'PRESENT',
        verificationMethod: 'QR',
        verifiedAt: now,
      );

      expect(record.isPresent, true);
      expect(record.isAbsent, false);
      expect(record.stateArabic, 'حاضر');
      expect(record.methodArabic, 'رمز QR');

      final json = record.toJson();
      final fromJson = StudentAttendanceRecord.fromJson(json);
      expect(fromJson.id, 'rec-001');
      expect(fromJson.attendanceState, 'PRESENT');
    });

    test('Translates all attendance states and methods to Arabic', () {
      final now = DateTime.now();
      final absent = StudentAttendanceRecord(
        id: '2',
        sessionId: 's',
        courseId: 'c',
        courseCode: 'C',
        courseName: 'T',
        sectionNumber: '1',
        teacherName: 'TN',
        sessionDate: now,
        attendanceState: 'ABSENT',
        verificationMethod: 'MANUAL',
      );
      expect(absent.isAbsent, true);
      expect(absent.stateArabic, 'غائب');
      expect(absent.methodArabic, 'تحضير يدوي');

      final lateRec = StudentAttendanceRecord(
        id: '3',
        sessionId: 's',
        courseId: 'c',
        courseCode: 'C',
        courseName: 'T',
        sectionNumber: '1',
        teacherName: 'TN',
        sessionDate: now,
        attendanceState: 'LATE',
        verificationMethod: 'BIOMETRIC',
      );
      expect(lateRec.isLate, true);
      expect(lateRec.stateArabic, 'متأخر');
      expect(lateRec.methodArabic, 'التحقق الحيوي');

      final excused = StudentAttendanceRecord(
        id: '4',
        sessionId: 's',
        courseId: 'c',
        courseCode: 'C',
        courseName: 'T',
        sectionNumber: '1',
        teacherName: 'TN',
        sessionDate: now,
        attendanceState: 'EXCUSED',
        verificationMethod: 'MANUAL',
      );
      expect(excused.isExcused, true);
      expect(excused.stateArabic, 'معذور');
    });
  });

  group('AttendanceStats Model Tests', () {
    test('Calculates overall rates and percentages properly', () {
      const stats = AttendanceStats(
        totalSessions: 50,
        totalPresent: 40,
        totalAbsent: 5,
        totalLate: 3,
        totalExcused: 2,
        totalCourses: 4,
      );

      // (40 + 3) / 50 = 43 / 50 = 86.0%
      expect(stats.attendancePercentage, 86.0);
      expect(stats.absencePercentage, 10.0);

      final json = stats.toJson();
      final fromJson = AttendanceStats.fromJson(json);
      expect(fromJson.totalSessions, 50);
      expect(fromJson.attendancePercentage, 86.0);
    });

    test('Handles zero total sessions safely without division by zero', () {
      const zeroStats = AttendanceStats(
        totalSessions: 0,
        totalPresent: 0,
        totalAbsent: 0,
        totalLate: 0,
        totalExcused: 0,
        totalCourses: 0,
      );
      expect(zeroStats.attendancePercentage, 100.0);
      expect(zeroStats.absencePercentage, 0.0);
    });
  });
}
