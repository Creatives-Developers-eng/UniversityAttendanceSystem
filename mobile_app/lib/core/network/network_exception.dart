import 'package:dio/dio.dart';

/// استثناء شبكي موحد لمعالجة وتحويل أخطاء الـ HTTP وانقطاع الاتصال
class NetworkException implements Exception {
  final int? statusCode;
  final String message;
  final List<String>? errors;
  final dynamic originalError;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.errors,
    this.originalError,
  });

  /// إنشاء استثناء من كائن DioException
  factory NetworkException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          statusCode: 408,
          message: 'انتهت المهلة الزمنية للاتصال بالخادم، يرجى المحاولة لاحقاً.',
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          statusCode: null,
          message: 'تعذر الاتصال بالخادم المركزي، يرجى التحقق من اتصال الإنترنت.',
          originalError: error,
        );

      case DioExceptionType.badResponse:
        final response = error.response;
        final statusCode = response?.statusCode;
        final responseData = response?.data;

        String serverMessage = 'حدث خطأ في الخادم ($statusCode)';
        List<String>? errorList;

        if (responseData is Map<String, dynamic>) {
          if (responseData['message'] != null) {
            serverMessage = responseData['message'].toString();
          }
          if (responseData['errors'] is List) {
            errorList = (responseData['errors'] as List)
                .map((e) => e.toString())
                .toList();
          }
        }

        switch (statusCode) {
          case 400:
            return NetworkException(
              statusCode: 400,
              message: serverMessage.isNotEmpty
                  ? serverMessage
                  : 'طلب غير صالح، يرجى التأكد من البيانات المدخلة.',
              errors: errorList,
              originalError: error,
            );
          case 401:
            return NetworkException(
              statusCode: 401,
              message: serverMessage.isNotEmpty
                  ? serverMessage
                  : 'انتهت صلاحية الجلسة أو بيانات الاعتماد غير صالحة.',
              errors: errorList,
              originalError: error,
            );
          case 403:
            return NetworkException(
              statusCode: 403,
              message: serverMessage.isNotEmpty
                  ? serverMessage
                  : 'غير مصرح لك بتنفيذ هذه العملية.',
              errors: errorList,
              originalError: error,
            );
          case 404:
            return NetworkException(
              statusCode: 404,
              message: serverMessage.isNotEmpty
                  ? serverMessage
                  : 'العنصر أو المسار المطلوب غير موجود.',
              errors: errorList,
              originalError: error,
            );
          case 409:
            return NetworkException(
              statusCode: 409,
              message: serverMessage.isNotEmpty
                  ? serverMessage
                  : 'يوجد تعارض مع بيانات مسجلة مسبقاً.',
              errors: errorList,
              originalError: error,
            );
          case 500:
          case 502:
          case 503:
            return NetworkException(
              statusCode: statusCode,
              message: 'حدث خطأ في الخادم المركزي، يرجى المحاولة لاحقاً.',
              errors: errorList,
              originalError: error,
            );
          default:
            return NetworkException(
              statusCode: statusCode,
              message: serverMessage,
              errors: errorList,
              originalError: error,
            );
        }

      case DioExceptionType.cancel:
        return NetworkException(
          statusCode: null,
          message: 'تم إلغاء العملية.',
          originalError: error,
        );

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          statusCode: null,
          message: 'حدث خطأ غير متوقع في الاتصال بالشبكة.',
          originalError: error,
        );
    }
  }

  factory NetworkException.unauthorized([String? message]) {
    return NetworkException(
      statusCode: 401,
      message: message ?? 'غير مصرح أو انتهت صلاحية الجلسة.',
    );
  }

  factory NetworkException.forbidden([String? message]) {
    return NetworkException(
      statusCode: 403,
      message: message ?? 'لا تملك الصلاحيات الكافية للوصول.',
    );
  }

  factory NetworkException.notFound([String? message]) {
    return NetworkException(
      statusCode: 404,
      message: message ?? 'المورد المطلوب غير موجود.',
    );
  }

  factory NetworkException.serverError([String? message]) {
    return NetworkException(
      statusCode: 500,
      message: message ?? 'خطأ في الخادم الداخلي.',
    );
  }

  factory NetworkException.noInternet() {
    return const NetworkException(
      statusCode: null,
      message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.',
    );
  }

  @override
  String toString() => 'NetworkException(status: $statusCode, message: $message)';
}

/// كائن استجابة الـ API المعياري
class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T? data;
  final List<String>? errors;

  const ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
