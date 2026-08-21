import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/delegate/services/delegate_service.dart';

void main() {
  group('DelegateService Unit Tests', () {
    late DelegateService service;

    setUp(() {
      service = DelegateService(forceMockData: true);
    });

    test('getDelegatedSections returns assigned sections', () async {
      final sections = await service.getDelegatedSections();
      expect(sections, isNotEmpty);
      expect(sections.length, greaterThanOrEqualTo(2));
      expect(sections.first.courseCode, isNotEmpty);
      expect(sections.first.totalStudents, greaterThan(0));
    });

    test('getRecentSessions returns previous sessions', () async {
      final sessions = await service.getRecentSessions();
      expect(sessions, isNotEmpty);
      expect(sessions.any((s) => s.isSynced), true);
    });

    test('startSession, recordLiveAttendance, closeSession, and syncSession workflow', () async {
      final sections = await service.getDelegatedSections();
      final section = sections.first;

      // 1. بدء الجلسة
      final liveSession = await service.startSession(section, 'معمل 3');
      expect(liveSession.isActive, true);
      expect(liveSession.roomName, 'معمل 3');

      final active = await service.getActiveSession();
      expect(active, isNotNull);
      expect(active?.id, liveSession.id);

      // 2. تسجيل حضور مباشر
      final attendee = await service.recordLiveAttendance(
        liveSession.id,
        'STD-2023-4019',
        method: 'QR',
      );
      expect(attendee.isPresent, true);
      expect(attendee.studentNumber, 'STD-2023-4019');

      final attendees = await service.getLiveAttendees(liveSession.id);
      expect(attendees.length, 1);

      // 3. إغلاق الجلسة
      final closedSession = await service.closeSession(liveSession.id);
      expect(closedSession.isClosed, true);
      expect(closedSession.closedAt, isNotNull);

      final activeAfterClose = await service.getActiveSession();
      expect(activeAfterClose, isNull);

      // 4. مزامنة الجلسة
      final syncedSession = await service.syncSession(closedSession.id);
      expect(syncedSession.isSynced, true);
      expect(syncedSession.syncRecordId, isNotNull);
    });

    test('getSectionAttendanceSheet returns students list', () async {
      final students = await service.getSectionAttendanceSheet('sec-001-p');
      expect(students, isNotEmpty);
      expect(students.length, greaterThanOrEqualTo(10));
      expect(students.first.studentNumber, contains('STD-'));
    });

    test('requestManualAttendance records manual exception with reason', () async {
      final entry = await service.requestManualAttendance(
        'ses-101',
        'std-manual-01',
        'EXCUSED',
        'عذر طبي رسمي',
      );
      expect(entry.isExcused, true);
      expect(entry.attendanceMethod, 'MANUAL');
      expect(entry.manualReason, 'عذر طبي رسمي');
    });
  });
}
