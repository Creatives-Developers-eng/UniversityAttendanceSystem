import '../models/lab_group.dart';
import '../models/lab_session.dart';
import '../models/lab_student_record.dart';
import 'mock_practical_data.dart';

/// خدمة إدارة واجهات وبيانات الأستاذ العملي (Practical Teacher Service)
class PracticalTeacherService {
  final bool forceMockData;

  // ذاكرة الحالة المحلية للمحاكاة الميدانية
  final List<LabGroup> _inMemoryGroups = [];
  final List<LabSession> _inMemorySessions = [];
  final Map<String, List<LabStudentRecord>> _inMemoryRosters = {};

  PracticalTeacherService({this.forceMockData = true}) {
    _initMockState();
  }

  void _initMockState() {
    _inMemoryGroups.clear();
    _inMemoryGroups.addAll(MockPracticalData.labGroups);

    _inMemorySessions.clear();
    _inMemorySessions.addAll(MockPracticalData.labSessions);

    for (final group in _inMemoryGroups) {
      _inMemoryRosters[group.id] = List.from(MockPracticalData.getLabStudentsForGroup(group.id));
    }
  }

  /// جلب الملف الشخصي للأستاذ العملي
  Future<Map<String, dynamic>> getTeacherProfile() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return Map<String, dynamic>.from(MockPracticalData.teacherProfile);
  }

  /// جلب كافة مجموعات المعامل المسندة للأستاذ
  Future<List<LabGroup>> getLabGroups() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_inMemoryGroups);
  }

  /// جلب الجلسات المعملية الحالية والسابقة
  Future<List<LabSession>> getLabSessions({String? groupId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (groupId != null && groupId.isNotEmpty) {
      return _inMemorySessions.where((s) => s.groupId == groupId).toList();
    }
    return List.from(_inMemorySessions);
  }

  /// جلب الجلسة النشطة حالياً إن وجدت
  Future<LabSession?> getActiveLabSession() async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _inMemorySessions.firstWhere((s) => s.isActive);
    } catch (_) {
      return null;
    }
  }

  /// جلب كشف طلاب مجموعة المعمل
  Future<List<LabStudentRecord>> getLabAttendanceRoster(String groupId, {String? sessionId}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final roster = _inMemoryRosters[groupId] ?? MockPracticalData.getLabStudentsForGroup(groupId);
    return List.from(roster);
  }

  /// بدء جلسة معملية جديدة مباشرة
  Future<LabSession> startLabSession(LabGroup group, String roomName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newSessionId = 'ses-prac-${DateTime.now().millisecondsSinceEpoch}';

    final newSession = LabSession(
      id: newSessionId,
      groupId: group.id,
      groupName: group.groupName,
      courseCode: group.courseCode,
      courseName: group.courseName,
      sectionNumber: group.sectionNumber,
      sessionDate: DateTime.now(),
      roomName: roomName.isNotEmpty ? roomName : group.roomName,
      sessionState: LabSessionState.active,
      totalStudents: group.totalStudents,
      attendedCount: 0,
      absentCount: group.totalStudents,
      lateCount: 0,
      excusedCount: 0,
      pendingExceptionsCount: 0,
    );

    // تحديث حالة المجموعة
    final groupIndex = _inMemoryGroups.indexWhere((g) => g.id == group.id);
    if (groupIndex != -1) {
      _inMemoryGroups[groupIndex] = _inMemoryGroups[groupIndex].copyWith(
        isLiveNow: true,
        activeSessionId: newSessionId,
      );
    }

    _inMemorySessions.insert(0, newSession);
    return newSession;
  }

  /// إغلاق الجلسة المعملية
  Future<LabSession> closeLabSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _inMemorySessions.indexWhere((s) => s.id == sessionId);
    if (index == -1) {
      throw Exception('الجلسة المعملية غير موجودة');
    }

    final current = _inMemorySessions[index];
    final closed = current.copyWith(
      sessionState: LabSessionState.closed,
      closedAt: DateTime.now(),
    );
    _inMemorySessions[index] = closed;

    // تحديث حالة المجموعة
    final groupIndex = _inMemoryGroups.indexWhere((g) => g.id == current.groupId);
    if (groupIndex != -1) {
      _inMemoryGroups[groupIndex] = _inMemoryGroups[groupIndex].copyWith(
        isLiveNow: false,
        activeSessionId: null,
      );
    }

    return closed;
  }

  /// اعتماد أو رفض طلب استثناء أو تحضير يدوي لطالب
  Future<LabStudentRecord> approveException(
    String groupId,
    String studentId, {
    required bool approved,
    String? teacherNotes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final roster = _inMemoryRosters[groupId];
    if (roster == null) {
      throw Exception('كشف طلاب المجموعة غير موجود');
    }

    final stdIndex = roster.indexWhere((s) => s.studentId == studentId);
    if (stdIndex == -1) {
      throw Exception('الطالب غير مسجل في هذه المجموعة المعملية');
    }

    final current = roster[stdIndex];
    final updated = current.copyWith(
      exceptionStatus: approved ? LabExceptionStatus.approved : LabExceptionStatus.rejected,
      attendanceState: approved ? (current.attendanceState == 'ABSENT' ? 'EXCUSED' : current.attendanceState) : 'ABSENT',
      isVerified: approved,
      teacherNotes: teacherNotes ?? (approved ? 'تم الاعتماد من أستاذ المعمل' : 'تم الرفض لعدم كفاية المبرر'),
      markedAt: approved ? (current.markedAt ?? DateTime.now()) : current.markedAt,
    );

    roster[stdIndex] = updated;
    return updated;
  }

  /// تسجيل تحضير يدوي فوري لطالب في المعمل
  Future<LabStudentRecord> recordManualAttendance(
    String groupId,
    String studentNumber, {
    required String state, // PRESENT | LATE | EXCUSED | ABSENT
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final roster = _inMemoryRosters[groupId];
    if (roster == null) {
      throw Exception('كشف طلاب المجموعة غير موجود');
    }

    final stdIndex = roster.indexWhere(
      (s) => s.studentNumber.toLowerCase() == studentNumber.trim().toLowerCase(),
    );

    if (stdIndex == -1) {
      // إنشاء قيد يدوي جديد إن لم يكن موجوداً
      final newStudent = LabStudentRecord(
        studentId: 'std-manual-${DateTime.now().millisecondsSinceEpoch}',
        studentNumber: studentNumber.trim().toUpperCase(),
        fullName: 'طالب معمل (تحضير يدوي استثنائي)',
        departmentName: 'قسم تقنية المعلومات',
        groupName: 'مجموعة المعمل',
        attendanceState: state,
        attendanceMethod: 'MANUAL',
        markedAt: DateTime.now(),
        isVerified: true,
        manualReason: reason,
        exceptionStatus: LabExceptionStatus.approved,
        teacherNotes: 'تحضير يدوي مباشر من أستاذ المعمل',
      );
      roster.add(newStudent);
      return newStudent;
    }

    final current = roster[stdIndex];
    final updated = current.copyWith(
      attendanceState: state,
      attendanceMethod: 'MANUAL',
      manualReason: reason,
      isVerified: true,
      markedAt: DateTime.now(),
      exceptionStatus: LabExceptionStatus.approved,
      teacherNotes: 'تم التعديل اليدوي المباشر بواسطة أستاذ المعمل',
    );

    roster[stdIndex] = updated;
    return updated;
  }

  /// تحديث جماعي سريع لحالات الطلاب
  Future<void> batchUpdateAttendance(String groupId, Map<String, String> studentStates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final roster = _inMemoryRosters[groupId];
    if (roster == null) return;

    for (int i = 0; i < roster.length; i++) {
      final std = roster[i];
      if (studentStates.containsKey(std.studentId)) {
        final newState = studentStates[std.studentId]!;
        roster[i] = std.copyWith(
          attendanceState: newState,
          attendanceMethod: 'MANUAL',
          markedAt: newState != 'ABSENT' ? (std.markedAt ?? DateTime.now()) : null,
          isVerified: newState != 'ABSENT',
        );
      }
    }
  }
}
