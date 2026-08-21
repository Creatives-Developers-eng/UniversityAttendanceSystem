import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/network/network_exception.dart';

void main() {
  group('NetworkException & ApiResponse Tests', () {
    test('Converts timeout DioException into NetworkException', () {
      final dioTimeout = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final exception = NetworkException.fromDioException(dioTimeout);
      expect(exception.statusCode, 408);
      expect(exception.message, contains('انتهت المهلة الزمنية'));
    });

    test('Converts connection error into NetworkException', () {
      final dioConnError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      final exception = NetworkException.fromDioException(dioConnError);
      expect(exception.statusCode, isNull);
      expect(exception.message, contains('تعذر الاتصال بالخادم'));
    });

    test('Parses 400 Bad Request with server message and errors array', () {
      final dio400 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {
            'statusCode': 400,
            'message': 'بيانات غير صالحة',
            'errors': ['حقل الاسم مطلوب', 'الرمز قصير جداً'],
          },
        ),
      );

      final exception = NetworkException.fromDioException(dio400);
      expect(exception.statusCode, 400);
      expect(exception.message, 'بيانات غير صالحة');
      expect(exception.errors?.length, 2);
    });

    test('Parses 401, 403, 404, 500 status codes appropriately', () {
      final dio401 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: {'message': 'انتهت الجلسة'},
        ),
      );
      expect(NetworkException.fromDioException(dio401).statusCode, 401);

      final dio403 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
          data: {'message': 'ممنوع'},
        ),
      );
      expect(NetworkException.fromDioException(dio403).statusCode, 403);

      final dio500 = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );
      expect(NetworkException.fromDioException(dio500).statusCode, 500);
    });

    test('ApiResponse deserializes payload correctly', () {
      final json = {
        'statusCode': 200,
        'message': 'Success',
        'data': {'id': '123', 'name': 'علي'},
      };

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (data) => data as Map<String, dynamic>,
      );

      expect(apiResponse.isSuccess, isTrue);
      expect(apiResponse.statusCode, 200);
      expect(apiResponse.data?['id'], '123');
    });
  });
}
