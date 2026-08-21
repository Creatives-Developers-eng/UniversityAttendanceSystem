import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/practical_teacher/models/lab_group.dart';
import 'package:mobile_app/practical_teacher/models/lab_session.dart';
import 'package:mobile_app/practical_teacher/models/lab_student_record.dart';

void main() {
  group('LabGroup Model Tests', () {
    test('Constructs, computes rate, and serializes correctly', () {
      const group = LabGroup(
        id: 'grp-001',
        courseId: 'crs-101',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات',
        sectionNumber: '01',
        groupName: 'مجموعة A - معمل البرمجيات',
        groupType: LabGroupType.softwareLab,
        roomName: 'معمل 3',
        scheduleTime: 'الأحد 08:00 ص',
        totalStudents: 30,
        attendedStudents: 24,
        delegateName: 'أحمد علي',
        isLiveNow: true,
      );

      expect(group.id, 'grp-001');
      expect(group.groupTypeArabic, 'معمل برمجيات');
      expect(group.attendancePercentage, 80.0);
      expect(group.isLiveNow, true);

      final json = group.toJson();
      expect(json['group_type'], 'softwareLab');
      expect(json['total_students'], 30);

      final fromJson = LabGroup.fromJson(json);
      expect(fromJson.id, group.id);
      expect(fromJson.courseCode, group.courseCode);
      expect(fromJson.groupType, LabGroupType.softwareLab);
    });

    test('Translates network and database lab types correctly', () {
      const netGroup = LabGroup(
        id: 'grp-002',
        courseId: 'crs-102',
        courseCode: 'IT302',
        courseName: 'شبكات الحاسوب',
        sectionNumber: '01',
        groupName: 'مجموعة شبكات',
        groupType: LabGroupType.networkLab,
        totalStudents: 25,
      );
      expect(netGroup.groupTypeArabic, 'معمل شبكات');

      const dbGroup = LabGroup(
        id: 'grp-003',
        courseId: 'crs-103',
        courseCode: 'CS303',
        courseName: 'قواعد البيانات',
        sectionNumber: '01',
        groupName: 'مجموعة قواعد بيانات',
        groupType: LabGroupType.databaseLab,
        totalStudents: 20,
      );
      expect(dbGroup.groupTypeArabic, 'معمل قواعد بيانات');
    });
  });

  group('LabSession Model Tests', () {
    test('Constructs and evaluates state and percentage correctly', () {
      final now = DateTime(2026, 8, 21, 9, 0);
      final session = LabSession(
        id: 'ses-prac-01',
        groupId: 'grp-001',
        groupName: 'مجموعة A',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات',
        sectionNumber: '01',
        sessionDate: now,
        roomName: 'معمل 3',
        sessionState: LabSessionState.active,
        totalStudents: 30,
        attendedCount: 27,
        pendingExceptionsCount: 2,
      );

      expect(session.isActive, true);
      expect(session.isClosed, false);
      expect(session.isSynced, false);
      expect(session.stateArabic, 'جلسة نشطة ومباشرة');
      expect(session.attendancePercentage, 90.0);
      expect(session.pendingExceptionsCount, 2);

      final synced = session.copyWith(
        sessionState: LabSessionState.synced,
        syncedAt: now,
        syncRecordId: 'sync-001',
      );
      expect(synced.isSynced, true);
      expect(synced.stateArabic, 'تمت المزامنة والاعتماد');

      final json = session.toJson();
      final fromJson = LabSession.fromJson(json);
      expect(fromJson.id, session.id);
      expect(fromJson.sessionState, LabSessionState.active);
      expect(fromJson.attendancePercentage, 90.0);
    });
  });

  group('LabStudentRecord Model Tests', () {
    test('Constructs, verifies exception statuses and states correctly', () {
      final now = DateTime.now();
      final record = LabStudentRecord(
        studentId: 'std-001',
        studentNumber: 'STD-2023-4019',
        fullName: 'أحمد علي عبد الله',
        departmentName: 'تقنية المعلومات',
        groupName: 'مجموعة A',
        attendanceState: 'PRESENT',
        attendanceMethod: 'QR',
        markedAt: now,
        isVerified: true,
      );

      expect(record.isPresent, true);
      expect(record.isAbsent, false);
      expect(record.stateArabic, 'حاضر');
      expect(record.methodArabic, 'رمز QR');
      expect(record.hasPendingException, false);

      final withPending = record.copyWith(
        attendanceState: 'ABSENT',
        manualReason: 'عطل في الهاتف',
        exceptionStatus: LabExceptionStatus.pending,
      );
      expect(withPending.isAbsent, true);
      expect(withPending.hasPendingException, true);
      expect(withPending.exceptionStatusArabic, 'بانتظار الاعتماد');

      final approved = withPending.copyWith(
        attendanceState: 'EXCUSED',
        exceptionStatus: LabExceptionStatus.approved,
        teacherNotes: 'تم التحقق من العذر',
      );
      expect(approved.isExcused, true);
      expect(approved.isExceptionApproved, true);
      expect(approved.exceptionStatusArabic, 'معتمد');

      final json = record.toJson();
      final fromJson = LabStudentRecord.fromJson(json);
      expect(fromJson.studentNumber, 'STD-2023-4019');
      expect(fromJson.attendanceState, 'PRESENT');
    });
  });
}
