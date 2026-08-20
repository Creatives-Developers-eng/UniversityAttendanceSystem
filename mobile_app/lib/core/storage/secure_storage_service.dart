import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../authentication/user_session.dart';
import 'storage_keys.dart';

/// خدمة التخزين المشفر والآمن على مستوى نظام التشغيل
/// تعتمد على Android KeyStore و iOS Keychain لتأمين التوكنات والبيانات الحساسة
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  // --- العمليات الأساسية العامة (Core Operations) ---

  /// كتابة وتشفير قيمة نصية بمفتاح محدد
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// قراءة وفك تشفير قيمة نصية بمفتاح محدد
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// حذف قيمة محددة
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// مسح كافة البيانات المشفرة المخزنة
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// التحقق من وجود مفتاح في التخزين المشفر
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  // --- دوال إدارة توكنات المصادقة (Auth Tokens) ---

  /// حفظ توكنات المصادقة (Access & Refresh Tokens)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await write(StorageKeys.accessToken, accessToken);
    await write(StorageKeys.refreshToken, refreshToken);
  }

  /// استرجاع الـ Access Token
  Future<String?> getAccessToken() async {
    return await read(StorageKeys.accessToken);
  }

  /// استرجاع الـ Refresh Token
  Future<String?> getRefreshToken() async {
    return await read(StorageKeys.refreshToken);
  }

  /// مسح توكنات المصادقة
  Future<void> clearTokens() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
  }

  // --- دوال إدارة بيانات الجهاز الموثق (Device Credentials) ---

  /// حفظ بيانات ومعرفات الجهاز الموثق
  Future<void> saveDeviceCredentials({
    required String deviceId,
    required String deviceIdentifier,
    required String deviceFingerprint,
    String? deviceState,
  }) async {
    await write(StorageKeys.deviceId, deviceId);
    await write(StorageKeys.deviceIdentifier, deviceIdentifier);
    await write(StorageKeys.deviceFingerprint, deviceFingerprint);
    if (deviceState != null) {
      await write(StorageKeys.deviceState, deviceState);
    }
  }

  /// استرجاع معرف الجهاز المسجل بالخادم
  Future<String?> getDeviceId() async {
    return await read(StorageKeys.deviceId);
  }

  /// استرجاع المعرف الفيزيائي للجهاز
  Future<String?> getDeviceIdentifier() async {
    return await read(StorageKeys.deviceIdentifier);
  }

  /// استرجاع البصمة الرقمية للجهاز
  Future<String?> getDeviceFingerprint() async {
    return await read(StorageKeys.deviceFingerprint);
  }

  /// استرجاع حالة الجهاز المخزنة
  Future<String?> getDeviceState() async {
    return await read(StorageKeys.deviceState);
  }

  // --- دوال إدارة جلسة المستخدم المشفرة (User Session) ---

  /// حفظ بيانات الجلسة كاملة بصيغة JSON مشفرة
  Future<void> saveUserSession(UserSession session) async {
    final jsonString = jsonEncode(session.toJson());
    await write(StorageKeys.userSession, jsonString);

    // تحديث التوكنات ومعرف الجهاز بشكل متزامن
    if (session.accessToken != null && session.refreshToken != null) {
      await saveTokens(
        accessToken: session.accessToken!,
        refreshToken: session.refreshToken!,
      );
    }
    if (session.deviceId != null) {
      await write(StorageKeys.deviceId, session.deviceId!);
    }
    await write(StorageKeys.deviceState, session.deviceState.toStateString());
  }

  /// استرجاع بيانات الجلسة المشفرة
  Future<UserSession?> getUserSession() async {
    final jsonString = await read(StorageKeys.userSession);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserSession.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  /// مسح الجلسة وكافة بيانات المصادقة المرتبطة بها
  Future<void> clearSession() async {
    await delete(StorageKeys.userSession);
    await clearTokens();
  }
}
