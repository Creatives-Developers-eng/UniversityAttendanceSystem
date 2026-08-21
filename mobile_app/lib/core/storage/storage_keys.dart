/// مفاتيح التخزين الموحدة للتطبيق
/// تُستخدم كعناوين ثابتة لحفظ واسترجاع البيانات المشفرة والتفضيلات المحلية
class StorageKeys {
  StorageKeys._();

  // --- مفاتيح التخزين الآمن والمشفر (Secure Storage) ---
  static const String accessToken = 'auth_access_token';
  static const String refreshToken = 'auth_refresh_token';
  static const String deviceId = 'auth_device_id';
  static const String deviceIdentifier = 'auth_device_identifier';
  static const String deviceFingerprint = 'auth_device_fingerprint';
  static const String deviceState = 'auth_device_state';
  static const String userSession = 'auth_user_session_json';

  // --- مفاتيح التفضيلات المحلية غير الحساسة (SharedPreferences) ---
  static const String themeMode = 'pref_theme_mode';
  static const String languageCode = 'pref_language_code';
  static const String isFirstLaunch = 'pref_is_first_launch';
  static const String lastSyncTimestamp = 'pref_last_sync_timestamp';
  static const String offlineCacheVersion = 'pref_offline_cache_version';

  // --- مفاتيح التخزين المؤقت للعمل دون اتصال (Offline Cache Keys) ---
  static const String offlineStudentProfile = 'cache_student_profile';
  static const String offlineStudentCourses = 'cache_student_courses';
  static const String offlineAttendanceHistory = 'cache_attendance_history';
  static const String offlineAttendanceStats = 'cache_attendance_stats';
  static const String offlineDelegatedSections = 'cache_delegated_sections';
  static const String offlineRecentSessions = 'cache_recent_sessions';
  static const String offlineLabGroups = 'cache_lab_groups';
  static const String offlineLabSessions = 'cache_lab_sessions';
  static const String offlineTheoryCourses = 'cache_theory_courses';
}
