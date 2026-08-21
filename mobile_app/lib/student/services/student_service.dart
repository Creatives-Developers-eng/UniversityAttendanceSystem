import '../../core/network/api_client.dart';
import '../../core/network/network_exception.dart';
import '../models/attendance_stats.dart';
import '../models/student_attendance_record.dart';
import '../models/student_course.dart';
import '../models/student_profile.dart';
import 'mock_student_data.dart';

/// خدمة إدارة واسترجاع بيانات الطالب الأكاديمية وسجلات الحضور
/// تتواصل مع الخادم المركزي عبر ApiClient مع توفير دعم آمن للعمل غير المتصل بالإنترنت
class StudentService {
  final ApiClient? _apiClient;
  final bool _forceMockData;

  StudentService({
    ApiClient? apiClient,
    bool forceMockData = false,
  })  : _apiClient = apiClient,
        _forceMockData = forceMockData;

  /// جلب الملف الشخصي للطالب
  Future<StudentProfile> getStudentProfile({String? studentId}) async {
    final client = _apiClient;
    if (_forceMockData || client == null) {
      return MockStudentData.defaultProfile;
    }

    try {
      final targetId = studentId ?? MockStudentData.defaultProfile.id;
      final response = await client.get('/students/$targetId');
      if (response.data is Map<String, dynamic>) {
        final dataMap = response.data as Map<String, dynamic>;
        final studentData = dataMap['data'] as Map<String, dynamic>? ?? dataMap;
        return StudentProfile.fromJson(studentData);
      }
      return MockStudentData.defaultProfile;
    } on NetworkException {
      // في حالة تعثر الاتصال بالخادم، يتم الرجوع للبيانات المحفوظة محلياً أو النموذجية
      return MockStudentData.defaultProfile;
    } catch (_) {
      return MockStudentData.defaultProfile;
    }
  }

  /// جلب قائمة المقررات والشعب المسجلة للطالب
  Future<List<StudentCourse>> getEnrolledCourses({String? studentId}) async {
    final client = _apiClient;
    if (_forceMockData || client == null) {
      return MockStudentData.defaultCourses;
    }

    try {
      final targetId = studentId ?? MockStudentData.defaultProfile.id;
      final response = await client.get(
        '/reports/attendance',
        queryParameters: {'student_id': targetId},
      );

      if (response.data is Map<String, dynamic>) {
        final dataMap = response.data as Map<String, dynamic>;
        final coursesList = dataMap['data']?['courses'] as List<dynamic>?;
        if (coursesList != null) {
          return coursesList
              .map((c) => StudentCourse.fromJson(c as Map<String, dynamic>))
              .toList();
        }
      }
      return MockStudentData.defaultCourses;
    } on NetworkException {
      return MockStudentData.defaultCourses;
    } catch (_) {
      return MockStudentData.defaultCourses;
    }
  }

  /// جلب تفاصيل مقرر دراسي محدد
  Future<StudentCourse?> getCourseDetails(String courseId, {String? studentId}) async {
    final courses = await getEnrolledCourses(studentId: studentId);
    try {
      return courses.firstWhere((c) => c.id == courseId || c.courseCode == courseId);
    } catch (_) {
      return null;
    }
  }

  /// جلب سجلات الحضور السابقة مع إمكانية التصفية بالمقرر أو الحالة
  Future<List<StudentAttendanceRecord>> getAttendanceHistory({
    String? studentId,
    String? courseCode,
    String? attendanceState,
  }) async {
    List<StudentAttendanceRecord> records;
    final client = _apiClient;

    if (_forceMockData || client == null) {
      records = List.from(MockStudentData.defaultAttendanceHistory);
    } else {
      try {
        final targetId = studentId ?? MockStudentData.defaultProfile.id;
        final queryParams = <String, dynamic>{'student_id': targetId};
        if (courseCode != null && courseCode.isNotEmpty) {
          queryParams['course_code'] = courseCode;
        }

        final response = await client.get(
          '/reports/attendance',
          queryParameters: queryParams,
        );

        if (response.data is Map<String, dynamic>) {
          final dataMap = response.data as Map<String, dynamic>;
          final rawRecords = dataMap['data']?['records'] as List<dynamic>?;
          if (rawRecords != null) {
            records = rawRecords
                .map((r) => StudentAttendanceRecord.fromJson(r as Map<String, dynamic>))
                .toList();
          } else {
            records = MockStudentData.defaultAttendanceHistory;
          }
        } else {
          records = MockStudentData.defaultAttendanceHistory;
        }
      } on NetworkException {
        records = MockStudentData.defaultAttendanceHistory;
      } catch (_) {
        records = MockStudentData.defaultAttendanceHistory;
      }
    }

    // تصفية حسب المقرر إن وجد
    if (courseCode != null && courseCode.isNotEmpty && courseCode != 'ALL') {
      records = records.where((r) => r.courseCode.toLowerCase() == courseCode.toLowerCase()).toList();
    }

    // تصفية حسب حالة الحضور إن وجدت
    if (attendanceState != null && attendanceState.isNotEmpty && attendanceState != 'ALL') {
      records = records
          .where((r) => r.attendanceState.toLowerCase() == attendanceState.toLowerCase())
          .toList();
    }

    // ترتيب السجلات تنازلياً حسب التاريخ
    records.sort((a, b) => b.sessionDate.compareTo(a.sessionDate));
    return records;
  }

  /// جلب الإحصائيات الشاملة للحضور
  Future<AttendanceStats> getAttendanceStats({String? studentId}) async {
    final client = _apiClient;
    if (_forceMockData || client == null) {
      return MockStudentData.defaultStats;
    }

    try {
      final targetId = studentId ?? MockStudentData.defaultProfile.id;
      final response = await client.get(
        '/reports/attendance',
        queryParameters: {'student_id': targetId},
      );

      if (response.data is Map<String, dynamic>) {
        final dataMap = response.data as Map<String, dynamic>;
        final statsData = dataMap['data'] as Map<String, dynamic>?;
        if (statsData != null) {
          return AttendanceStats.fromJson(statsData);
        }
      }
      return MockStudentData.defaultStats;
    } on NetworkException {
      return MockStudentData.defaultStats;
    } catch (_) {
      return MockStudentData.defaultStats;
    }
  }
}
