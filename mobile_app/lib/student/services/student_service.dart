import '../../core/network/api_client.dart';
import '../../core/network/network_exception.dart';
import '../../core/offline/offline_cache_manager.dart';
import '../models/attendance_stats.dart';
import '../models/student_attendance_record.dart';
import '../models/student_course.dart';
import '../models/student_profile.dart';
import 'mock_student_data.dart';

/// خدمة إدارة واسترجاع بيانات الطالب الأكاديمية وسجلات الحضور
/// تتواصل مع الخادم المركزي عبر ApiClient مع توفير دعم آمن للعمل غير المتصل بالإنترنت
class StudentService {
  final ApiClient? _apiClient;
  final OfflineCacheManager? _cacheManager;
  final bool _forceMockData;

  StudentService({
    ApiClient? apiClient,
    OfflineCacheManager? cacheManager,
    bool forceMockData = false,
  })  : _apiClient = apiClient,
        _cacheManager = cacheManager,
        _forceMockData = forceMockData;

  OfflineCacheManager? get cacheManager => _cacheManager;

  /// جلب الملف الشخصي للطالب
  Future<StudentProfile> getStudentProfile({String? studentId}) async {
    final client = _apiClient;
    final targetId = studentId ?? MockStudentData.defaultProfile.id;

    if (_forceMockData || client == null) {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentProfile(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultProfile;
    }

    try {
      final response = await client.get('/students/$targetId');
      if (response.data is Map<String, dynamic>) {
        final dataMap = response.data as Map<String, dynamic>;
        final studentData = dataMap['data'] as Map<String, dynamic>? ?? dataMap;
        final profile = StudentProfile.fromJson(studentData);
        if (_cacheManager != null) {
          await _cacheManager!.saveStudentProfile(profile, studentId: targetId);
        }
        return profile;
      }
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentProfile(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultProfile;
    } on NetworkException {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentProfile(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultProfile;
    } catch (_) {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentProfile(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultProfile;
    }
  }

  /// جلب قائمة المقررات والشعب المسجلة للطالب
  Future<List<StudentCourse>> getEnrolledCourses({String? studentId}) async {
    final client = _apiClient;
    final targetId = studentId ?? MockStudentData.defaultProfile.id;

    if (_forceMockData || client == null) {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentCourses(studentId: targetId);
        if (cached != null && cached.isNotEmpty) return cached;
      }
      return MockStudentData.defaultCourses;
    }

    try {
      final response = await client.get(
        '/reports/attendance',
        queryParameters: {'student_id': targetId},
      );

      if (response.data is Map<String, dynamic>) {
        final dataMap = response.data as Map<String, dynamic>;
        final coursesList = dataMap['data']?['courses'] as List<dynamic>?;
        if (coursesList != null) {
          final courses = coursesList
              .map((c) => StudentCourse.fromJson(c as Map<String, dynamic>))
              .toList();
          if (_cacheManager != null) {
            await _cacheManager!.saveStudentCourses(courses, studentId: targetId);
          }
          return courses;
        }
      }
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentCourses(studentId: targetId);
        if (cached != null && cached.isNotEmpty) return cached;
      }
      return MockStudentData.defaultCourses;
    } on NetworkException {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentCourses(studentId: targetId);
        if (cached != null && cached.isNotEmpty) return cached;
      }
      return MockStudentData.defaultCourses;
    } catch (_) {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getStudentCourses(studentId: targetId);
        if (cached != null && cached.isNotEmpty) return cached;
      }
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
    final targetId = studentId ?? MockStudentData.defaultProfile.id;

    if (_forceMockData || client == null) {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getAttendanceHistory(studentId: targetId);
        records = cached != null && cached.isNotEmpty ? cached : List.from(MockStudentData.defaultAttendanceHistory);
      } else {
        records = List.from(MockStudentData.defaultAttendanceHistory);
      }
    } else {
      try {
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
            if (_cacheManager != null) {
              await _cacheManager!.saveAttendanceHistory(records, studentId: targetId);
            }
          } else {
            final cached = _cacheManager != null ? await _cacheManager!.getAttendanceHistory(studentId: targetId) : null;
            records = cached ?? MockStudentData.defaultAttendanceHistory;
          }
        } else {
          final cached = _cacheManager != null ? await _cacheManager!.getAttendanceHistory(studentId: targetId) : null;
          records = cached ?? MockStudentData.defaultAttendanceHistory;
        }
      } on NetworkException {
        final cached = _cacheManager != null ? await _cacheManager!.getAttendanceHistory(studentId: targetId) : null;
        records = cached ?? MockStudentData.defaultAttendanceHistory;
      } catch (_) {
        final cached = _cacheManager != null ? await _cacheManager!.getAttendanceHistory(studentId: targetId) : null;
        records = cached ?? MockStudentData.defaultAttendanceHistory;
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
    final targetId = studentId ?? MockStudentData.defaultProfile.id;

    if (_forceMockData || client == null) {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getAttendanceStats(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultStats;
    }

    try {
      final response = await client.get(
        '/reports/attendance',
        queryParameters: {'student_id': targetId},
      );

      if (response.data is Map<String, dynamic>) {
        final dataMap = response.data as Map<String, dynamic>;
        final statsData = dataMap['data'] as Map<String, dynamic>?;
        if (statsData != null) {
          final stats = AttendanceStats.fromJson(statsData);
          if (_cacheManager != null) {
            await _cacheManager!.saveAttendanceStats(stats, studentId: targetId);
          }
          return stats;
        }
      }
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getAttendanceStats(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultStats;
    } on NetworkException {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getAttendanceStats(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultStats;
    } catch (_) {
      if (_cacheManager != null) {
        final cached = await _cacheManager!.getAttendanceStats(studentId: targetId);
        if (cached != null) return cached;
      }
      return MockStudentData.defaultStats;
    }
  }
}
