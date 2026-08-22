import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/storage_keys.dart';
import '../../student/models/student_profile.dart';
import '../../student/models/student_course.dart';
import '../../student/models/student_attendance_record.dart';
import '../../student/models/attendance_stats.dart';
import '../../delegate/models/delegate_section.dart';
import '../../delegate/models/delegate_session.dart';
import '../../practical_teacher/models/lab_group.dart';
import '../../practical_teacher/models/lab_session.dart';
import '../../theoretical_teacher/models/theory_course.dart';
import 'cache_policy.dart';
import 'connectivity_service.dart';

/// مدير التخزين المؤقت والعمل دون اتصال الموحد (Offline Cache Manager)
/// يدير حفظ واسترجاع بيانات المقررات، الشعب، الملف الشخصي، وسجلات الحضور محلياً
/// مع تطبيق سياسات الكاش (CachePolicy) والتحقق من الصلاحية (TTL)
class OfflineCacheManager {
  final SharedPreferences? _prefs;
  final ConnectivityService? _connectivityService;
  final Map<String, String> _inMemoryStorage = {};

  static const Duration defaultTTL = Duration(hours: 24);
  static const int currentCacheVersion = 1;

  OfflineCacheManager({
    SharedPreferences? prefs,
    ConnectivityService? connectivityService,
  })  : _prefs = prefs,
        _connectivityService = connectivityService;

  /// تهيئة الكلاس عبر استدعاء SharedPreferences.getInstance()
  static Future<OfflineCacheManager> create({ConnectivityService? connectivityService}) async {
    final prefs = await SharedPreferences.getInstance();
    return OfflineCacheManager(
      prefs: prefs,
      connectivityService: connectivityService ?? ConnectivityService(),
    );
  }

  // =========================================================================
  // العمليات الأساسية العامة (Core Generic Operations)
  // =========================================================================

  /// كتابة قيمة JSON مع زمن صلاحية محدد
  Future<void> putJson(String key, dynamic rawData, {Duration? ttl = defaultTTL}) async {
    final entry = CacheEntry<dynamic>(
      data: rawData,
      cachedAt: DateTime.now(),
      ttl: ttl,
      version: currentCacheVersion,
    );

    final jsonString = entry.toJsonString((v) => v);
    if (_prefs != null) {
      await _prefs!.setString(key, jsonString);
    } else {
      _inMemoryStorage[key] = jsonString;
    }
  }

  /// استرجاع كائن JSON مع التحقق من انتهاء الصلاحية
  Future<dynamic> getJson(String key, {bool ignoreExpiration = false}) async {
    String? jsonString;
    if (_prefs != null) {
      jsonString = _prefs!.getString(key);
    } else {
      jsonString = _inMemoryStorage[key];
    }

    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final entry = CacheEntry<dynamic>.fromJsonString(jsonString, (v) => v);
      if (!ignoreExpiration && entry.isExpired) {
        return null;
      }
      return entry.data;
    } catch (_) {
      return null;
    }
  }

  /// إبطال وحذف عنصر محدد من الكاش
  Future<bool> invalidate(String key) async {
    if (_prefs != null) {
      return await _prefs!.remove(key);
    } else {
      return _inMemoryStorage.remove(key) != null;
    }
  }

  /// مسح كافة عناصر التخزين المؤقت
  Future<void> clearAll() async {
    if (_prefs != null) {
      final keys = _prefs!.getKeys();
      for (final key in keys) {
        if (key.startsWith('cache_')) {
          await _prefs!.remove(key);
        }
      }
    }
    _inMemoryStorage.clear();
  }

  /// التحقق مما إذا كان المفتاح موجوداً في الكاش
  Future<bool> containsKey(String key) async {
    if (_prefs != null) {
      return _prefs!.containsKey(key);
    }
    return _inMemoryStorage.containsKey(key);
  }

  /// استرجاع وقت آخر تحديث لعنصر في الكاش
  Future<DateTime?> getLastUpdated(String key) async {
    String? jsonString;
    if (_prefs != null) {
      jsonString = _prefs!.getString(key);
    } else {
      jsonString = _inMemoryStorage[key];
    }

    if (jsonString == null) return null;

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      final cachedAtStr = map['cached_at'] as String?;
      return cachedAtStr != null ? DateTime.tryParse(cachedAtStr) : null;
    } catch (_) {
      return null;
    }
  }

  /// التحقق مما إذا كان العنصر منتهي الصلاحية
  Future<bool> isExpired(String key) async {
    String? jsonString;
    if (_prefs != null) {
      jsonString = _prefs!.getString(key);
    } else {
      jsonString = _inMemoryStorage[key];
    }

    if (jsonString == null) return true;

    try {
      final entry = CacheEntry<dynamic>.fromJsonString(jsonString, (v) => v);
      return entry.isExpired;
    } catch (_) {
      return true;
    }
  }

  // =========================================================================
  // إدارة كاش الطالب (Student Cache Operations)
  // =========================================================================

  /// حفظ الملف الشخصي للطالب محلياً
  Future<void> saveStudentProfile(
    StudentProfile profile, {
    String? studentId,
    Duration? ttl = defaultTTL,
  }) async {
    final key = _buildKey(StorageKeys.offlineStudentProfile, studentId);
    await putJson(key, profile.toJson(), ttl: ttl);
  }

  /// استرجاع الملف الشخصي للطالب من الكاش المحلي
  Future<StudentProfile?> getStudentProfile({
    String? studentId,
    bool ignoreExpiration = false,
  }) async {
    final key = _buildKey(StorageKeys.offlineStudentProfile, studentId);
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is Map<String, dynamic>) {
      return StudentProfile.fromJson(data);
    }
    return null;
  }

  /// حفظ قائمة المقررات المسجلة للطالب محلياً
  Future<List<StudentCourse>> saveStudentCourses(
    List<StudentCourse> courses, {
    String? studentId,
    Duration? ttl = defaultTTL,
  }) async {
    final key = _buildKey(StorageKeys.offlineStudentCourses, studentId);
    final coursesJson = courses.map((c) => c.toJson()).toList();
    await putJson(key, coursesJson, ttl: ttl);
    return courses;
  }

  /// استرجاع قائمة المقررات المسجلة للطالب من الكاش المحلي
  Future<List<StudentCourse>?> getStudentCourses({
    String? studentId,
    bool ignoreExpiration = false,
  }) async {
    final key = _buildKey(StorageKeys.offlineStudentCourses, studentId);
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is List<dynamic>) {
      return data
          .map((item) => StudentCourse.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  /// حفظ سجلات الحضور السابقة محلياً
  Future<void> saveAttendanceHistory(
    List<StudentAttendanceRecord> records, {
    String? studentId,
    Duration? ttl = defaultTTL,
  }) async {
    final key = _buildKey(StorageKeys.offlineAttendanceHistory, studentId);
    final recordsJson = records.map((r) => r.toJson()).toList();
    await putJson(key, recordsJson, ttl: ttl);
  }

  /// استرجاع سجلات الحضور السابقة من الكاش المحلي
  Future<List<StudentAttendanceRecord>?> getAttendanceHistory({
    String? studentId,
    bool ignoreExpiration = false,
  }) async {
    final key = _buildKey(StorageKeys.offlineAttendanceHistory, studentId);
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is List<dynamic>) {
      return data
          .map((item) => StudentAttendanceRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  /// حفظ إحصائيات الحضور الشاملة للطالب محلياً
  Future<void> saveAttendanceStats(
    AttendanceStats stats, {
    String? studentId,
    Duration? ttl = defaultTTL,
  }) async {
    final key = _buildKey(StorageKeys.offlineAttendanceStats, studentId);
    await putJson(key, stats.toJson(), ttl: ttl);
  }

  /// استرجاع إحصائيات الحضور الشاملة للطالب من الكاش المحلي
  Future<AttendanceStats?> getAttendanceStats({
    String? studentId,
    bool ignoreExpiration = false,
  }) async {
    final key = _buildKey(StorageKeys.offlineAttendanceStats, studentId);
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is Map<String, dynamic>) {
      return AttendanceStats.fromJson(data);
    }
    return null;
  }

  // =========================================================================
  // إدارة كاش المندوب (Delegate Cache Operations)
  // =========================================================================

  /// حفظ الشعب المفوض بها المندوب محلياً
  Future<void> saveDelegatedSections(
    List<DelegateSection> sections, {
    Duration? ttl = defaultTTL,
  }) async {
    const key = StorageKeys.offlineDelegatedSections;
    final sectionsJson = sections.map((s) => s.toJson()).toList();
    await putJson(key, sectionsJson, ttl: ttl);
  }

  /// استرجاع الشعب المفوض بها المندوب من الكاش المحلي
  Future<List<DelegateSection>?> getDelegatedSections({
    bool ignoreExpiration = false,
  }) async {
    const key = StorageKeys.offlineDelegatedSections;
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is List<dynamic>) {
      return data
          .map((item) => DelegateSection.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  /// حفظ سجل الجلسات الحديثة للمندوب محلياً
  Future<void> saveRecentSessions(
    List<DelegateSession> sessions, {
    Duration? ttl = defaultTTL,
  }) async {
    const key = StorageKeys.offlineRecentSessions;
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await putJson(key, sessionsJson, ttl: ttl);
  }

  /// استرجاع سجل الجلسات الحديثة للمندوب من الكاش المحلي
  Future<List<DelegateSession>?> getRecentSessions({
    bool ignoreExpiration = false,
  }) async {
    const key = StorageKeys.offlineRecentSessions;
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is List<dynamic>) {
      return data
          .map((item) => DelegateSession.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  // =========================================================================
  // إدارة كاش الأستاذ العملي والنظري (Teacher Cache Operations)
  // =========================================================================

  /// حفظ مجموعات المعامل للأستاذ العملي محلياً
  Future<void> saveLabGroups(
    List<LabGroup> groups, {
    Duration? ttl = defaultTTL,
  }) async {
    const key = StorageKeys.offlineLabGroups;
    final groupsJson = groups.map((g) => g.toJson()).toList();
    await putJson(key, groupsJson, ttl: ttl);
  }

  /// استرجاع مجموعات المعامل من الكاش المحلي
  Future<List<LabGroup>?> getLabGroups({bool ignoreExpiration = false}) async {
    const key = StorageKeys.offlineLabGroups;
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is List<dynamic>) {
      return data
          .map((item) => LabGroup.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  /// حفظ الجلسات المعملية محلياً
  Future<void> saveLabSessions(
    List<LabSession> sessions, {
    String? groupId,
    Duration? ttl = defaultTTL,
  }) async {
    final key = _buildKey(StorageKeys.offlineLabSessions, groupId);
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await putJson(key, sessionsJson, ttl: ttl);
  }

  /// استرجاع الجلسات المعملية من الكاش المحلي
  Future<List<LabSession>?> getLabSessions({
    String? groupId,
    bool ignoreExpiration = false,
  }) async {
    final key = _buildKey(StorageKeys.offlineLabSessions, groupId);
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is List<dynamic>) {
      return data
          .map((item) => LabSession.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  /// حفظ المقررات النظرية للأستاذ النظري محلياً
  Future<void> saveTheoryCourses(
    List<TheoryCourse> courses, {
    Duration? ttl = defaultTTL,
  }) async {
    const key = StorageKeys.offlineTheoryCourses;
    final coursesJson = courses.map((c) => c.toJson()).toList();
    await putJson(key, coursesJson, ttl: ttl);
  }

  /// استرجاع المقررات النظرية من الكاش المحلي
  Future<List<TheoryCourse>?> getTheoryCourses({
    bool ignoreExpiration = false,
  }) async {
    const key = StorageKeys.offlineTheoryCourses;
    final data = await getJson(key, ignoreExpiration: ignoreExpiration);
    if (data is List<dynamic>) {
      return data
          .map((item) => TheoryCourse.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  // =========================================================================
  // المنسق الذكي لتنفيذ الطلبات مع السياسات (Smart Policy Executor)
  // =========================================================================

  /// تنفيذ عملية جلب البيانات بناءً على سياسة الكاش المحددة
  Future<T> executeWithPolicy<T>({
    required String cacheKey,
    required Future<T> Function() networkFetch,
    required Future<void> Function(T data) saveToCache,
    required Future<T?> Function() getFromCache,
    CachePolicy policy = CachePolicy.networkFirst,
    Duration? ttl = defaultTTL,
    T Function()? fallback,
  }) async {
    switch (policy) {
      case CachePolicy.networkOnly:
        try {
          final data = await networkFetch();
          await saveToCache(data);
          return data;
        } catch (_) {
          if (fallback != null) return fallback();
          rethrow;
        }

      case CachePolicy.cacheOnly:
        final cached = await getFromCache();
        if (cached != null) return cached;
        if (fallback != null) return fallback();
        throw Exception('البيانات غير متوفرة في التخزين المحلي');

      case CachePolicy.cacheFirst:
        final cached = await getFromCache();
        if (cached != null) {
          return cached;
        }
        try {
          final data = await networkFetch();
          await saveToCache(data);
          return data;
        } catch (_) {
          if (fallback != null) return fallback();
          rethrow;
        }

      case CachePolicy.staleWhileRevalidate:
        final cached = await getFromCache();
        final networkFuture = networkFetch().then((data) async {
          await saveToCache(data);
          return data;
        }).catchError((_) => cached as T);

        if (cached != null) {
          return cached;
        }
        return await networkFuture;

      case CachePolicy.networkFirst:
        final isOnline = await _isNetworkAvailable();
        if (isOnline) {
          try {
            final data = await networkFetch();
            await saveToCache(data);
            return data;
          } catch (_) {
            final cached = await getFromCache();
            if (cached != null) return cached;
            if (fallback != null) return fallback();
            rethrow;
          }
        } else {
          final cached = await getFromCache();
          if (cached != null) return cached;
          if (fallback != null) return fallback();
          throw Exception('لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة محلياً');
        }
    }
  }

  // --- دوال مساعدة خاصة ---

  Future<bool> _isNetworkAvailable() async {
    if (_connectivityService != null) {
      return await _connectivityService!.isConnected;
    }
    return true;
  }

  String _buildKey(String baseKey, String? suffix) {
    if (suffix == null || suffix.isEmpty) {
      return baseKey;
    }
    return '${baseKey}_$suffix';
  }
}
