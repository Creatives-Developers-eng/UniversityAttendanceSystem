import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/auth_interceptor.dart';
import 'package:mobile_app/core/storage/secure_storage_service.dart';

class _Mock401Adapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"statusCode": 401, "message": "Unauthorized"}',
      401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthInterceptor Tests', () {
    late SecureStorageService secureStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      secureStorage = SecureStorageService(
        storage: const FlutterSecureStorage(),
      );
    });

    test('Injects Bearer token and Device ID into request headers', () async {
      await secureStorage.saveTokens(
        accessToken: 'valid.jwt.token',
        refreshToken: 'valid.refresh.token',
      );
      await secureStorage.saveDeviceCredentials(
        deviceId: 'device-xyz-123',
        deviceIdentifier: 'hw-id',
        deviceFingerprint: 'fp-sha',
      );

      final interceptor = AuthInterceptor(secureStorage: secureStorage);
      final options = RequestOptions(path: '/api/v1/students/me');

      final handler = RequestInterceptorHandler();
      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer valid.jwt.token');
      expect(options.headers['X-Device-Id'], 'device-xyz-123');
      expect(options.headers['Accept'], 'application/json');
    });

    test('Does not inject token for login or refresh endpoints', () async {
      await secureStorage.saveTokens(
        accessToken: 'valid.jwt.token',
        refreshToken: 'valid.refresh.token',
      );

      final interceptor = AuthInterceptor(secureStorage: secureStorage);
      final options = RequestOptions(path: '/api/v1/auth/login');

      final handler = RequestInterceptorHandler();
      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test('Clears session on 401 when no refresh token exists', () async {
      bool sessionExpiredTriggered = false;

      final interceptor = AuthInterceptor(
        secureStorage: secureStorage,
        onSessionExpired: () {
          sessionExpiredTriggered = true;
        },
      );

      final dio = Dio(BaseOptions(baseUrl: 'https://test.edu/api/v1'));
      dio.interceptors.add(interceptor);
      dio.httpClientAdapter = _Mock401Adapter();

      try {
        await dio.get('/profile');
      } catch (_) {}

      expect(sessionExpiredTriggered, isTrue);
      expect(await secureStorage.getAccessToken(), isNull);
    });
  });
}
