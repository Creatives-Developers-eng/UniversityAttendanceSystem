import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import '../storage/storage_keys.dart';

/// معترض المصادقة وتجديد التوكن التلقائي
/// يقوم بحقن توكن Bearer ومعرف الجهاز في الترويسات
/// ويعترض أخطاء 401 لتجديد الـ Access Token وإعادة المحاولة بسلاسة
class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService _secureStorage;
  final Dio _refreshDio;
  final VoidCallback? _onSessionExpired;

  AuthInterceptor({
    required SecureStorageService secureStorage,
    Dio? refreshDio,
    VoidCallback? onSessionExpired,
  })  : _secureStorage = secureStorage,
        _refreshDio = refreshDio ?? Dio(),
        _onSessionExpired = onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // إعداد الترويسات الافتراضية
    options.headers['Accept'] = 'application/json';
    if (!options.headers.containsKey('Content-Type')) {
      options.headers['Content-Type'] = 'application/json';
    }

    // التحقق مما إذا كان الطلب يتطلب مصادقة
    final requiresAuth = options.extra['requiresAuth'] as bool? ?? true;
    final isAuthEndpoint = options.path.contains('/auth/login') ||
        options.path.contains('/auth/refresh');

    if (requiresAuth && !isAuthEndpoint) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      final deviceId = await _secureStorage.getDeviceId();
      if (deviceId != null && deviceId.isNotEmpty) {
        options.headers['X-Device-Id'] = deviceId;
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final isRetry = err.requestOptions.extra['isRetry'] as bool? ?? false;
    final isRefreshEndpoint = err.requestOptions.path.contains('/auth/refresh');

    // إذا كان الخطأ 401 ولم تتم إعادة المحاولة مسبقاً وليس نقطة تجديد التوكن
    if (statusCode == 401 && !isRetry && !isRefreshEndpoint) {
      final refreshToken = await _secureStorage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // إرسال طلب تجديد الـ Access Token
          final refreshResponse = await _refreshDio.post(
            '/api/v1/auth/refresh',
            data: {'refresh_token': refreshToken},
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

          if (refreshResponse.statusCode == 200) {
            final data = refreshResponse.data['data'] as Map<String, dynamic>? ?? {};
            final newAccessToken = data['access_token'] as String?;

            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              // حفظ التوكن الجديد
              await _secureStorage.write(StorageKeys.accessToken, newAccessToken);

              // تحديث ترويسة الطلب الأصلي
              final options = err.requestOptions;
              options.headers['Authorization'] = 'Bearer $newAccessToken';
              options.extra['isRetry'] = true;

              // إعادة تنفيذ الطلب الأصلي
              final retryResponse = await _refreshDio.fetch(options);
              return handler.resolve(retryResponse);
            }
          }
        } catch (_) {
          // فشل التجديد - يتم مسح الجلسة وتنبيه التطبيق
        }
      }

      // إذا لم يتوفر Refresh Token أو فشل التجديد
      await _secureStorage.clearSession();
      _onSessionExpired?.call();
    }

    return handler.next(err);
  }
}
