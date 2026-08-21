import 'package:shared_preferences/shared_preferences.dart';
import 'storage_keys.dart';

/// إدارة التفضيلات والإعدادات المحلية غير الحساسة للتطبيق
/// تعتمد على SharedPreferences لتخزين خيارات المظهر واللغة وحالة المزامنة
class LocalPreferences {
  final SharedPreferences _prefs;

  LocalPreferences(this._prefs);

  /// تهيئة الكلاس عبر استدعاء SharedPreferences.getInstance()
  static Future<LocalPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalPreferences(prefs);
  }

  // --- إعدادات المظهر (Theme Mode) ---

  /// حفظ وضع المظهر (system, light, dark)
  Future<bool> setThemeMode(String mode) async {
    return await _prefs.setString(StorageKeys.themeMode, mode);
  }

  /// استرجاع وضع المظهر الحالي (الافتراضي: system)
  String getThemeMode() {
    return _prefs.getString(StorageKeys.themeMode) ?? 'system';
  }

  // --- إعدادات اللغة (Language / Locale) ---

  /// حفظ رمز لغة التطبيق (ar, en)
  Future<bool> setLanguageCode(String languageCode) async {
    return await _prefs.setString(StorageKeys.languageCode, languageCode);
  }

  /// استرجاع رمز اللغة الحالي (الافتراضي: ar)
  String getLanguageCode() {
    return _prefs.getString(StorageKeys.languageCode) ?? 'ar';
  }

  // --- حالة التشغيل الأول (First Launch / Onboarding) ---

  /// تعيين ما إذا كان هذا أول تشغيل للتطبيق
  Future<bool> setIsFirstLaunch(bool isFirst) async {
    return await _prefs.setBool(StorageKeys.isFirstLaunch, isFirst);
  }

  /// التحقق مما إذا كان التطبيق يفتح لأول مرة (الافتراضي: true)
  bool isFirstLaunch() {
    return _prefs.getBool(StorageKeys.isFirstLaunch) ?? true;
  }

  // --- توقيت آخر مزامنة غير متصلة (Offline Sync Timestamp) ---

  /// حفظ التوقيت الزمني لآخر عملية مزامنة ناجحة
  Future<bool> setLastSyncTimestamp(DateTime timestamp) async {
    return await _prefs.setString(
      StorageKeys.lastSyncTimestamp,
      timestamp.toIso8601String(),
    );
  }

  /// استرجاع تاريخ آخر مزامنة
  DateTime? getLastSyncTimestamp() {
    final dateStr = _prefs.getString(StorageKeys.lastSyncTimestamp);
    if (dateStr == null || dateStr.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  // --- مسح التفضيلات (Clear Preferences) ---

  /// مسح كافة التفضيلات المخزنة
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
