/// كائن نقل البيانات لطلب ربط وتفعيل الجهاز
/// مطابق تماماً للمواصفة في API_SPECIFICATION.md لنقطة POST /api/v1/devices/bind
class DeviceActivationDto {
  /// رمز التفعيل الممنوح للمستخدم
  final String code;

  /// المعرف الفريد للجهاز (Hardware/Platform Identifier)
  final String deviceIdentifier;

  /// البصمة الرقمية المشفرة للجهاز
  final String deviceFingerprint;

  const DeviceActivationDto({
    required this.code,
    required this.deviceIdentifier,
    required this.deviceFingerprint,
  });

  /// التحقق من صلاحية واكتمال بيانات الطلب قبل الإرسال
  bool isValid() {
    return code.trim().isNotEmpty &&
        deviceIdentifier.trim().isNotEmpty &&
        deviceFingerprint.trim().isNotEmpty;
  }

  /// تحويل كائن الطلب إلى صيغة JSON المطابقة لعقد الـ API
  Map<String, dynamic> toJson() {
    return {
      'code': code.trim(),
      'device_identifier': deviceIdentifier.trim(),
      'device_fingerprint': deviceFingerprint.trim(),
    };
  }

  /// إنشاء كائن الطلب من صيغة JSON
  factory DeviceActivationDto.fromJson(Map<String, dynamic> json) {
    return DeviceActivationDto(
      code: json['code'] as String? ?? '',
      deviceIdentifier: json['device_identifier'] as String? ?? '',
      deviceFingerprint: json['device_fingerprint'] as String? ?? '',
    );
  }
}

/// كائن نقل البيانات لاستجابة نجاح ربط وتفعيل الجهاز
class DeviceActivationResponseDto {
  /// المعرف الفريد للجهاز المسجل في قاعدة البيانات المركزية
  final String deviceId;

  /// حالة الجهاز المسجلة ("Bound")
  final String deviceState;

  /// الطابع الزمني لتوثيق وربط الجهاز (ISO-8601)
  final String boundAt;

  const DeviceActivationResponseDto({
    required this.deviceId,
    required this.deviceState,
    required this.boundAt,
  });

  /// إنشاء كائن الاستجابة من JSON القادم من الخادم
  factory DeviceActivationResponseDto.fromJson(Map<String, dynamic> json) {
    return DeviceActivationResponseDto(
      deviceId: json['device_id'] as String? ?? '',
      deviceState: json['device_state'] as String? ?? 'Bound',
      boundAt: json['bound_at'] as String? ?? '',
    );
  }

  /// تحويل كائن الاستجابة إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'device_state': deviceState,
      'bound_at': boundAt,
    };
  }
}
