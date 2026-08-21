import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/network/network_exception.dart';

void main() {
  group('ApiClient Configuration & Call Tests', () {
    test('Configures default BaseOptions properly', () {
      final client = ApiClient(
        baseUrl: 'https://test.university.edu/api/v1',
        timeout: const Duration(seconds: 20),
      );

      expect(client.dio.options.baseUrl, 'https://test.university.edu/api/v1');
      expect(client.dio.options.connectTimeout, const Duration(seconds: 20));
      expect(client.dio.options.headers['Accept'], 'application/json');
      expect(client.dio.options.headers['Content-Type'], 'application/json');
    });

    test('Throws NetworkException on connection failure', () async {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:9999/api/v1',
          connectTimeout: const Duration(milliseconds: 100),
          receiveTimeout: const Duration(milliseconds: 100),
        ),
      );

      final client = ApiClient(customDio: dio);

      expect(
        () => client.get('/non-existent-endpoint'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
