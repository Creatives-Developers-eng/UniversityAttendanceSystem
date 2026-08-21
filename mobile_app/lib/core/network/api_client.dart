import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'network_exception.dart';

/// عميل الـ REST API الموحد للتطبيق
/// يدير الاتصال بالخادم المركزي، الترويسات، وإعادة المحاولة، والتحويل إلى NetworkException
class ApiClient {
  static const String defaultBaseUrl = 'https://api.university-attendance.edu/api/v1';
  static const Duration defaultTimeout = Duration(seconds: 15);

  final Dio _dio;

  Dio get dio => _dio;

  ApiClient({
    String baseUrl = defaultBaseUrl,
    Duration timeout = defaultTimeout,
    Dio? customDio,
    SecureStorageService? secureStorage,
    Interceptor? authInterceptor,
    List<Interceptor>? additionalInterceptors,
  }) : _dio = customDio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // إضافة معترض المصادقة إذا تم تزويد خدمة التخزين المشفر
    if (authInterceptor != null) {
      _dio.interceptors.add(authInterceptor);
    } else if (secureStorage != null) {
      _dio.interceptors.add(
        AuthInterceptor(
          secureStorage: secureStorage,
          refreshDio: Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: timeout,
              receiveTimeout: timeout,
            ),
          ),
        ),
      );
    }

    if (additionalInterceptors != null) {
      _dio.interceptors.addAll(additionalInterceptors);
    }
  }

  // --- دوال طلبات الـ HTTP المعيارية (CRUD Operations) ---

  /// إرسال طلب GET
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (e) {
      throw NetworkException(
        message: 'حدث خطأ غير متوقع: $e',
        originalError: e,
      );
    }
  }

  /// إرسال طلب POST
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (e) {
      throw NetworkException(
        message: 'حدث خطأ غير متوقع: $e',
        originalError: e,
      );
    }
  }

  /// إرسال طلب PUT
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (e) {
      throw NetworkException(
        message: 'حدث خطأ غير متوقع: $e',
        originalError: e,
      );
    }
  }

  /// إرسال طلب DELETE
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (e) {
      throw NetworkException(
        message: 'حدث خطأ غير متوقع: $e',
        originalError: e,
      );
    }
  }

  /// إرسال طلب PATCH
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } catch (e) {
      throw NetworkException(
        message: 'حدث خطأ غير متوقع: $e',
        originalError: e,
      );
    }
  }
}
