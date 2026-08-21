import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/delegate/models/delegate_section.dart';
import 'package:mobile_app/delegate/models/delegate_session.dart';
import 'package:mobile_app/delegate/models/delegate_student_entry.dart';

void main() {
  group('DelegateSection Model Tests', () {
    test('Constructs, serializes, and checks helpers correctly', () {
      const section = DelegateSection(
        id: 'sec-101',
        courseId: 'crs-101',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات المتقدمة',
        sectionNumber: '01',
        sectionType: DelegateSectionType.practical,
        teacherId: 'tch-001',
        teacherName: 'د. محمد',
        totalStudents: 30,
        roomName: 'معمل 3',
        scheduleTime: 'الأحد 08:00 ص',
      );

      expect(section.id, 'sec-101');
      expect(section.isPractical, true);
      expect(section.isTheoretical, false);
      expect(section.sectionTypeArabic, 'شعبة عملية');

      final json = section.toJson();
      expect(json['section_type'], 'PRACTICAL');
      expect(json['total_students'], 30);

      final fromJson = DelegateSection.fromJson(json);
      expect(fromJson.id, section.id);
      expect(fromJson.courseCode, section.courseCode);
      expect(fromJson.isPractical, true);
    });
  });

  group('DelegateSession Model Tests', () {
    test('Constructs, computes rate, and checks states correctly', () {
      final now = DateTime(2026, 8, 21, 10, 0);
      final session = DelegateSession(
        id: 'ses-101',
        sectionId: 'sec-101',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات',
        sectionNumber: '01',
        sectionType: DelegateSectionType.practical,
        teacherName: 'د. محمد',
        delegateId: 'del-001',
        delegateName: 'أحمد علي',
        sessionState: DelegateSessionState.active,
        openedAt: now,
        totalExpectedStudents: 30,
        attendedCount: 24,
      );

      expect(session.isActive, true);
      expect(session.isClosed, false);
      expect(session.isSynced, false);
      expect(session.stateArabic, 'نشطة ومباشرة');
      expect(session.attendancePercentage, 80.0);

      final updated = session.copyWith(
        sessionState: DelegateSessionState.synced,
        syncedAt: now,
        syncRecordId: 'sync-123',
      );
      expect(updated.isSynced, true);
      expect(updated.stateArabic, 'تمت المزامنة');
      expect(updated.syncRecordId, 'sync-123');

      final json = session.toJson();
      final fromJson = DelegateSession.fromJson(json);
      expect(fromJson.id, session.id);
      expect(fromJson.sessionState, DelegateSessionState.active);
      expect(fromJson.attendancePercentage, 80.0);
    });
  });

  group('DelegateStudentEntry Model Tests', () {
    test('Constructs and translates states correctly', () {
      final now = DateTime.now();
      final entry = DelegateStudentEntry(
        studentId: 'std-101',
        studentNumber: 'STD-2023-4019',
        fullName: 'أحمد علي عبد الله',
        attendanceState: 'PRESENT',
        attendanceMethod: 'QR',
        markedAt: now,
        isVerified: true,
      );

      expect(entry.isPresent, true);
      expect(entry.isAbsent, false);
      expect(entry.stateArabic, 'حاضر');
      expect(entry.methodArabic, 'رمز QR');

      final json = entry.toJson();
      final fromJson = DelegateStudentEntry.fromJson(json);
      expect(fromJson.studentNumber, 'STD-2023-4019');
      expect(fromJson.attendanceState, 'PRESENT');

      final lateEntry = entry.copyWith(attendanceState: 'LATE', attendanceMethod: 'BIOMETRIC');
      expect(lateEntry.isLate, true);
      expect(lateEntry.stateArabic, 'متأخر');
      expect(lateEntry.methodArabic, 'التحقق الحيوي');

      final excusedEntry = entry.copyWith(
        attendanceState: 'EXCUSED',
        attendanceMethod: 'MANUAL',
        manualReason: 'عذر مرضي',
      );
      expect(excusedEntry.isExcused, true);
      expect(excusedEntry.stateArabic, 'معذور');
      expect(excusedEntry.manualReason, 'عذر مرضي');
    });
  });
}
