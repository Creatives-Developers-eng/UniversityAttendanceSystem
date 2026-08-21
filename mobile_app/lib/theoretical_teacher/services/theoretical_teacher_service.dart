import '../models/attendance_analytics.dart';
import '../models/deprivation_student.dart';
import '../models/theory_course.dart';
import 'mock_theory_data.dart';

/// خدمة إدارة واجهات وتحليلات الأستاذ النظري (Theoretical Teacher Service)
class TheoreticalTeacherService {
  final bool forceMockData;

  final List<TheoryCourse> _inMemoryCourses = [];
  final Map<String, List<DeprivationStudent>> _inMemoryDeprivations = {};

  TheoreticalTeacherService({this.forceMockData = true}) {
    _initMockState();
  }

  void _initMockState() {
    _inMemoryCourses.clear();
    _inMemoryCourses.addAll(MockTheoryData.theoryCourses);

    for (final c in _inMemoryCourses) {
      _inMemoryDeprivations[c.id] = List.from(MockTheoryData.getDeprivationStudentsForCourse(c.id));
    }
  }

  /// جلب الملف الأكاديمي للأستاذ النظري
  Future<Map<String, dynamic>> getTeacherProfile() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return Map<String, dynamic>.from(MockTheoryData.teacherProfile);
  }

  /// جلب كافة المقررات النظرية المسندة للأستاذ
  Future<List<TheoryCourse>> getTheoryCourses() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_inMemoryCourses);
  }

  /// جلب تفاصيل مقرر نظري محدد
  Future<TheoryCourse?> getCourseDetails(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _inMemoryCourses.firstWhere((c) => c.id == courseId || c.courseCode == courseId);
    } catch (_) {
      return null;
    }
  }

  /// جلب تحليلات وإحصائيات الحضور والغياب للمقرر
  Future<AttendanceAnalytics> getCourseAnalytics(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return MockTheoryData.getAnalyticsForCourse(courseId);
  }

  /// جلب الطلاب المعرضين للحرمان للمقرر مع إمكانية التصفية
  Future<List<DeprivationStudent>> getDeprivationStudents(
    String courseId, {
    DeprivationRiskLevel? riskFilter,
    String? sectionFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final students = _inMemoryDeprivations[courseId] ?? MockTheoryData.getDeprivationStudentsForCourse(courseId);
    var result = List<DeprivationStudent>.from(students);

    if (riskFilter != null) {
      result = result.where((s) => s.riskLevel == riskFilter).toList();
    }
    if (sectionFilter != null && sectionFilter.isNotEmpty && sectionFilter != 'ALL') {
      result = result.where((s) => s.sectionNumber == sectionFilter).toList();
    }

    return result;
  }

  /// جلب جميع الطلاب المعرضين للحرمان من كافة المواد
  Future<List<DeprivationStudent>> getAllAtRiskStudents() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final List<DeprivationStudent> all = [];
    for (final list in _inMemoryDeprivations.values) {
      all.addAll(list.where((s) => s.isAtRisk));
    }
    return all;
  }

  /// إرسال إشعار إنذار حرمان رسمي للطالب
  Future<DeprivationStudent> sendDeprivationWarning(
    String courseId,
    String studentId,
    String warningType, // e.g. \"FIRST_WARNING\", \"FINAL_WARNING\", \"DEPRIVATION_DECISION\"
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final list = _inMemoryDeprivations[courseId];
    if (list == null) {
      throw Exception('قائمة المادة غير موجودة');
    }

    final index = list.indexWhere((s) => s.studentId == studentId);
    if (index == -1) {
      throw Exception('الطالب غير مسجل في هذه المادة');
    }

    final current = list[index];
    String statusText;
    DeprivationRiskLevel level = current.riskLevel;

    if (warningType == 'FINAL_WARNING') {
      statusText = 'تم إرسال الإنذار الثاني الحرج';
      level = DeprivationRiskLevel.warningSecond;
    } else if (warningType == 'DEPRIVATION_DECISION') {
      statusText = 'تم إصدار واعتماد قرار الحرمان النهائي';
      level = DeprivationRiskLevel.deprived;
    } else {
      statusText = 'تم إرسال الإنذار الأكاديمي الأول';
      level = DeprivationRiskLevel.warningFirst;
    }

    final updated = current.copyWith(
      warningStatus: statusText,
      lastWarningSentAt: DateTime.now(),
      riskLevel: level,
    );

    list[index] = updated;
    return updated;
  }

  /// تصدير تقرير الحضور والغياب (PDF / Excel محاكاة)
  Future<String> exportAttendanceReport(String courseId, String format) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'REPORT-${courseId.toUpperCase()}-$timestamp.$format';
  }
}
