import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/practical_teacher/models/lab_student_record.dart';
import 'package:mobile_app/practical_teacher/services/practical_teacher_service.dart';

void main() {
  group('PracticalTeacherService Unit Tests', () {
    late PracticalTeacherService service;

    setUp(() {
      service = PracticalTeacherService(forceMockData: true);
    });

    test('getTeacherProfile returns valid teacher data', () async {
      final profile = await service.getTeacherProfile();
      expect(profile['full_name'], contains('عمر'));
      expect(profile['active_labs_count'], greaterThan(0));
    });

    test('getLabGroups returns lab groups list', () async {
      final groups = await service.getLabGroups();
      expect(groups, isNotEmpty);
      expect(groups.first.groupName, isNotEmpty);
      expect(groups.first.totalStudents, greaterThan(0));
    });

    test('getLabSessions returns sessions list', () async {
      final sessions = await service.getLabSessions();
      expect(sessions, isNotEmpty);
      expect(sessions.any((s) => s.isActive), true);
    });

    test('startLabSession and closeLabSession flow', () async {
      final groups = await service.getLabGroups();
      final group = groups.first;

      final session = await service.startLabSession(group, 'معمل 4');
      expect(session.isActive, true);
      expect(session.roomName, 'معمل 4');

      final active = await service.getActiveLabSession();
      expect(active, isNotNull);
      expect(active?.id, session.id);

      final closed = await service.closeLabSession(session.id);
      expect(closed.isClosed, true);
      expect(closed.closedAt, isNotNull);
    });

    test('getLabAttendanceRoster returns students list', () async {
      final students = await service.getLabAttendanceRoster('grp-001');
      expect(students, isNotEmpty);
      expect(students.first.studentNumber, contains('STD-'));
    });

    test('approveException approves and changes student state', () async {
      final roster = await service.getLabAttendanceRoster('grp-001');
      final pendingStudent = roster.firstWhere((s) => s.hasPendingException);

      final approved = await service.approveException(
        'grp-001',
        pendingStudent.studentId,
        approved: true,
        teacherNotes: 'تم قبول العذر',
      );

      expect(approved.isExceptionApproved, true);
      expect(approved.exceptionStatus, LabExceptionStatus.approved);
      expect(approved.teacherNotes, 'تم قبول العذر');
    });

    test('recordManualAttendance creates or updates attendance', () async {
      final updated = await service.recordManualAttendance(
        'grp-001',
        'STD-2023-4019',
        state: 'PRESENT',
        reason: 'تحضير يدوي في المعمل',
      );

      expect(updated.isPresent, true);
      expect(updated.attendanceMethod, 'MANUAL');
      expect(updated.manualReason, 'تحضير يدوي في المعمل');
    });

    test('batchUpdateAttendance updates multiple students', () async {
      final roster = await service.getLabAttendanceRoster('grp-001');
      final id1 = roster[0].studentId;
      final id2 = roster[1].studentId;

      await service.batchUpdateAttendance('grp-001', {
        id1: 'PRESENT',
        id2: 'LATE',
      });

      final updatedRoster = await service.getLabAttendanceRoster('grp-001');
      expect(updatedRoster.firstWhere((s) => s.studentId == id1).isPresent, true);
      expect(updatedRoster.firstWhere((s) => s.studentId == id2).isLate, true);
    });
  });
}
