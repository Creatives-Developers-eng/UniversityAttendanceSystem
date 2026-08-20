import 'dart:async';
import 'package:dio/dio.dart';
import 'device_activation_dto.dart';
import 'user_session.dart';

/// حالات واجهة وعملية التفعيل
enum ActivationState {
  idle,
  loading,
  success,
  error,
}

/// نتيجة عملية تفعيل وربط الجهاز
class ActivationResult {
  final bool isSuccess;
  final DeviceActivationResponseDto? response;
  final String? errorMessage;
  final DeviceState updatedState;

  const ActivationResult.success(DeviceActivationResponseDto res)
      : isSuccess = true,
        response = res,
        errorMessage = null,
        updatedState = DeviceState.bound;

  const ActivationResult.failure(String message)
      : isSuccess = false,
        response = null,
        errorMessage = message,
        updatedState = DeviceState.unregistered;
}

/// خدمة معالجة طلبات تفعيل وتوثيق الأجهزة الذكية
class ActivationService {
  final Dio? _dio;

  ActivationService({Dio? dio}) : _dio = dio;

  /// إرسال طلب ربط الجهاز إلى الخادم المركزي عبر POST /api/v1/devices/bind
  Future<ActivationResult> activateDevice(DeviceActivationDto dto) async {
    // 1. التحقق الأولي من صحة المدخلات
    if (!dto.isValid()) {
      return const ActivationResult.failure(
        'يرجى إدخال رمز تفعيل صالح ومعلومات الجهاز كاملة.',
      );
    }

    if (dto.code.trim().length < 4) {
      return const ActivationResult.failure(
        'رمز التفعيل يجب أن يتكون من 4 خانات على الأقل.',
      );
    }

    try {
      final dio = _dio;
      if (dio != null) {
        final response = await dio.post(
          '/api/v1/devices/bind',
          data: dto.toJson(),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.data['data'] as Map<String, dynamic>? ?? {};
          final resDto = DeviceActivationResponseDto.fromJson(data);
          return ActivationResult.success(resDto);
        } else {
          final errorMsg = response.data['message'] as String? ??
              'فشل التحقق من رمز التفعيل، يرجى المحاولة مرة أخرى.';
          return ActivationResult.failure(errorMsg);
        }
      } else {
        // محاكاة الاتصال الناجح عند غياب اتصال Dio الحقيقي لتمكين الاختبار
        await Future.delayed(const Duration(milliseconds: 300));
        final mockResponse = DeviceActivationResponseDto(
          deviceId: 'dev-${DateTime.now().millisecondsSinceEpoch}',
          deviceState: 'Bound',
          boundAt: DateTime.now().toIso8601String(),
        );
        return ActivationResult.success(mockResponse);
      }
    } on DioException catch (dioError) {
      String message = 'تعذر الاتصال بالخادم المركزي، يرجى التحقق من الشبكة.';
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        if (statusCode == 400) {
          message = 'رمز التفعيل غير صالح أو منتهي الصلاحية.';
        } else if (statusCode == 401 || statusCode == 403) {
          message = 'غير مصرح بتفعيل هذا الجهاز، يرجى مراجعة إدارة الكلية.';
        } else if (dioError.response?.data is Map &&
            dioError.response?.data['message'] != null) {
          message = dioError.response?.data['message'].toString() ?? message;
        }
      }
      return ActivationResult.failure(message);
    } catch (e) {
      return ActivationResult.failure('حدث خطأ غير متوقع أثناء التفعيل: $e');
    }
  }
}
