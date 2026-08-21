import '../../core/network/api_client.dart';
import '../../core/offline/offline_cache_manager.dart';
import '../models/delegate_section.dart';
import '../models/delegate_session.dart';
import '../models/delegate_student_entry.dart';
import 'mock_delegate_data.dart';

/// خدمة إدارة جلسات الحضور والشعب الخاصة بمندوب الدفعة (Delegate Service)
class DelegateService {
  final ApiClient? apiClient;
  final OfflineCacheManager? cacheManager;
  final bool forceMockData;

  // حالة الجلسة الحية النشطة محلياً في الذاكرة
  static DelegateSession? _activeLocalSession;
  static List<DelegateStudentEntry> _liveSessionAttendees = [];

  DelegateService({
    this.apiClient,
    this.cacheManager,
    this.forceMockData = false,
  });

  /// جلب الشعب والمقررات المفوض بها المندوب
  Future<List<DelegateSection>> getDelegatedSections() async {
    if (forceMockData || apiClient == null) {
      if (cacheManager != null) {
        final cached = await cacheManager!.getDelegatedSections();
        if (cached != null && cached.isNotEmpty) return cached;
      }
      await Future.delayed(const Duration(milliseconds: 200));
      return List.from(MockDelegateData.sections);
    }

    try {
      final response = await apiClient!.get('/api/v1/delegates/sections');
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data as List<dynamic>;
        final sections = list.map((e) => DelegateSection.fromJson(e as Map<String, dynamic>)).toList();
        if (cacheManager != null) {
          await cacheManager!.saveDelegatedSections(sections);
        }
        return sections;
      }
    } catch (_) {}

    if (cacheManager != null) {
      final cached = await cacheManager!.getDelegatedSections();
      if (cached != null && cached.isNotEmpty) return cached;
    }

    return List.from(MockDelegateData.sections);
  }

  /// جلب سجل الجلسات الحديثة والمزامنة
  Future<List<DelegateSession>> getRecentSessions() async {
    if (forceMockData || apiClient == null) {
      if (cacheManager != null) {
        final cached = await cacheManager!.getRecentSessions();
        if (cached != null && cached.isNotEmpty) {
          final list = <DelegateSession>[];
          if (_activeLocalSession != null) {
            list.add(_activeLocalSession!);
          }
          list.addAll(cached);
          return list;
        }
      }
      await Future.delayed(const Duration(milliseconds: 200));
      final list = <DelegateSession>[];
      if (_activeLocalSession != null) {
        list.add(_activeLocalSession!);
      }
      list.addAll(MockDelegateData.recentSessions);
      return list;
    }

    try {
      final response = await apiClient!.get('/api/v1/sessions');
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data as List<dynamic>;
        final sessions = list.map((e) => DelegateSession.fromJson(e as Map<String, dynamic>)).toList();
        if (cacheManager != null) {
          await cacheManager!.saveRecentSessions(sessions);
        }
        final result = <DelegateSession>[];
        if (_activeLocalSession != null) {
          result.add(_activeLocalSession!);
        }
        result.addAll(sessions);
        return result;
      }
    } catch (_) {}

    if (cacheManager != null) {
      final cached = await cacheManager!.getRecentSessions();
      if (cached != null && cached.isNotEmpty) {
        final list = <DelegateSession>[];
        if (_activeLocalSession != null) {
          list.add(_activeLocalSession!);
        }
        list.addAll(cached);
        return list;
      }
    }

    final list = <DelegateSession>[];
    if (_activeLocalSession != null) {
      list.add(_activeLocalSession!);
    }
    list.addAll(MockDelegateData.recentSessions);
    return list;
  }

  /// جلب الجلسة الحية النشطة حالياً إن وجدت
  Future<DelegateSession?> getActiveSession() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _activeLocalSession;
  }

  /// بدء وإنشاء جلسة حضور جديدة للشعبة وتشغيل الخادم المحلي
  Future<DelegateSession> startSession(DelegateSection section, String roomName) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newSession = DelegateSession(
      id: 'ses-live-${DateTime.now().millisecondsSinceEpoch}',
      sectionId: section.id,
      courseCode: section.courseCode,
      courseName: section.courseName,
      sectionNumber: section.sectionNumber,
      sectionType: section.sectionType,
      teacherName: section.teacherName,
      delegateId: 'usr-std-001',
      delegateName: 'أحمد علي عبد الله',
      sessionState: DelegateSessionState.active,
      openedAt: DateTime.now(),
      totalExpectedStudents: section.totalStudents > 0 ? section.totalStudents : 30,
      attendedCount: 0,
      roomName: roomName.isNotEmpty ? roomName : section.roomName,
      isOfflineMode: true,
    );

    _activeLocalSession = newSession;
    _liveSessionAttendees = [];

    return newSession;
  }

  /// جلب الطلاب الحاضرين في الجلسة الحية الحالية
  Future<List<DelegateStudentEntry>> getLiveAttendees(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_liveSessionAttendees);
  }

  /// تسجيل حضور طالب محلياً (مسح QR أو تحقق حيوي)
  Future<DelegateStudentEntry> recordLiveAttendance(
    String sessionId,
    String studentNumber, {
    String method = 'QR',
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final newEntry = DelegateStudentEntry(
      studentId: 'std-${DateTime.now().millisecondsSinceEpoch}',
      studentNumber: studentNumber,
      fullName: 'طالب $studentNumber',
      departmentName: 'هندسة تقنية المعلومات',
      attendanceState: 'PRESENT',
      attendanceMethod: method,
      markedAt: DateTime.now(),
      isVerified: true,
    );

    _liveSessionAttendees.insert(0, newEntry);

    if (_activeLocalSession != null) {
      _activeLocalSession = _activeLocalSession!.copyWith(
        attendedCount: _liveSessionAttendees.length,
      );
    }

    return newEntry;
  }

  /// إنهاء وإغلاق الجلسة الحية وحفظ بياناتها محلياً
  Future<DelegateSession> closeSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_activeLocalSession != null && _activeLocalSession!.id == sessionId) {
      _activeLocalSession = _activeLocalSession!.copyWith(
        sessionState: DelegateSessionState.closed,
        closedAt: DateTime.now(),
      );
      final closed = _activeLocalSession!;
      MockDelegateData.recentSessions.insert(0, closed);
      _activeLocalSession = null;
      return closed;
    }

    final dummyClosed = DelegateSession(
      id: sessionId,
      sectionId: 'sec-001-p',
      courseCode: 'CS301',
      courseName: 'هندسة البرمجيات المتقدمة',
      sectionNumber: '01',
      sectionType: DelegateSectionType.practical,
      teacherName: 'د. محمد السعيد',
      delegateId: 'usr-std-001',
      delegateName: 'أحمد علي عبد الله',
      sessionState: DelegateSessionState.closed,
      openedAt: DateTime.now().subtract(const Duration(hours: 1)),
      closedAt: DateTime.now(),
      totalExpectedStudents: 28,
      attendedCount: _liveSessionAttendees.length,
    );

    MockDelegateData.recentSessions.insert(0, dummyClosed);
    _activeLocalSession = null;
    return dummyClosed;
  }

  /// مزامنة سجلات الجلسة مع الخادم المركزي
  Future<DelegateSession> syncSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final index = MockDelegateData.recentSessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      final updated = MockDelegateData.recentSessions[index].copyWith(
        sessionState: DelegateSessionState.synced,
        syncedAt: DateTime.now(),
        syncRecordId: 'sync-rec-${DateTime.now().millisecondsSinceEpoch}',
      );
      MockDelegateData.recentSessions[index] = updated;
      return updated;
    }

    return DelegateSession(
      id: sessionId,
      sectionId: 'sec-001-p',
      courseCode: 'CS301',
      courseName: 'هندسة البرمجيات المتقدمة',
      sectionNumber: '01',
      sectionType: DelegateSectionType.practical,
      teacherName: 'د. محمد السعيد',
      delegateId: 'usr-std-001',
      delegateName: 'أحمد علي عبد الله',
      sessionState: DelegateSessionState.synced,
      openedAt: DateTime.now().subtract(const Duration(hours: 2)),
      closedAt: DateTime.now().subtract(const Duration(hours: 1)),
      syncedAt: DateTime.now(),
      totalExpectedStudents: 28,
      attendedCount: 26,
      syncRecordId: 'sync-rec-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// جلب كشف حضور الطلاب الكامل للشعبة
  Future<List<DelegateStudentEntry>> getSectionAttendanceSheet(
    String sectionId, {
    String? sessionId,
  }) async {
    if (forceMockData || apiClient == null) {
      await Future.delayed(const Duration(milliseconds: 250));
      return MockDelegateData.getStudentsRoster(sectionId);
    }

    try {
      final response = await apiClient!.get('/api/v1/sections/$sectionId/attendance-sheet');
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data as List<dynamic>;
        return list.map((e) => DelegateStudentEntry.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    return MockDelegateData.getStudentsRoster(sectionId);
  }

  /// رفع طلب تحضير يدوي استثنائي للطالب
  Future<DelegateStudentEntry> requestManualAttendance(
    String sessionId,
    String studentId,
    String state,
    String reason,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return DelegateStudentEntry(
      studentId: studentId,
      studentNumber: 'STD-2023-MANUAL',
      fullName: 'طالب تحضير يدوي',
      attendanceState: state,
      attendanceMethod: 'MANUAL',
      markedAt: DateTime.now(),
      manualReason: reason,
      isVerified: true,
    );
  }
}
