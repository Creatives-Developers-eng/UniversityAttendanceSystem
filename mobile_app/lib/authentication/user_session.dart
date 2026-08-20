/// الأدوار الرسمية الأربعة المعتمدة في تطبيق الهاتف المحمول
/// مطابقة لوثيقة PROJECT_ROLES.md و PROJECT_GLOSSARY.md
enum UserRole {
  /// دور الطالب الأساسي (مسح QR وتسجيل الحضور)
  student,

  /// دور المندوب (استضافة الخادم المحلي وإدارة الجلسة)
  delegate,

  /// دور الأستاذ العملي (الإشراف على المعامل والتحضير الميداني)
  practicalTeacher,

  /// دور الأستاذ النظري (الإشراف الأكاديمي الشامل والمحاضرات النظرية)
  theoreticalTeacher;

  /// تحويل النص القادم من الـ API إلى التعداد المقابل
  static UserRole fromString(String roleStr) {
    switch (roleStr.toUpperCase()) {
      case 'STUDENT':
        return UserRole.student;
      case 'DELEGATE':
        return UserRole.delegate;
      case 'PRACTICAL_TEACHER':
      case 'PRACTICALTEACHER':
        return UserRole.practicalTeacher;
      case 'THEORETICAL_TEACHER':
      case 'THEORETICALTEACHER':
      case 'TEACHER':
        return UserRole.theoreticalTeacher;
      default:
        return UserRole.student;
    }
  }

  /// القيمة النصية الرسمية للدور
  String toRoleString() {
    switch (this) {
      case UserRole.student:
        return 'STUDENT';
      case UserRole.delegate:
        return 'DELEGATE';
      case UserRole.practicalTeacher:
        return 'PRACTICAL_TEACHER';
      case UserRole.theoreticalTeacher:
        return 'THEORETICAL_TEACHER';
    }
  }

  /// الاسم العربي الرسمي للدور
  String get arabicTitle {
    switch (this) {
      case UserRole.student:
        return 'طالب';
      case UserRole.delegate:
        return 'مندوب';
      case UserRole.practicalTeacher:
        return 'أستاذ عملي';
      case UserRole.theoreticalTeacher:
        return 'أستاذ نظري';
    }
  }
}

/// حالات الجهاز الرسمية المعتمدة في وثيقة SYSTEM_STATES.md
enum DeviceState {
  /// غير مسجل
  unregistered,

  /// بانتظار التحقق
  pendingVerification,

  /// مرتبط وموثق
  bound,

  /// ملغى التوثيق
  revoked;

  /// تحويل النص القادم من الـ API إلى حالة الجهاز
  static DeviceState fromString(String stateStr) {
    switch (stateStr.toLowerCase()) {
      case 'bound':
        return DeviceState.bound;
      case 'pendingverification':
      case 'pending_verification':
        return DeviceState.pendingVerification;
      case 'revoked':
        return DeviceState.revoked;
      case 'unregistered':
      default:
        return DeviceState.unregistered;
    }
  }

  /// القيمة النصية الرسمية للحالة
  String toStateString() {
    switch (this) {
      case DeviceState.bound:
        return 'Bound';
      case DeviceState.pendingVerification:
        return 'PendingVerification';
      case DeviceState.revoked:
        return 'Revoked';
      case DeviceState.unregistered:
        return 'Unregistered';
    }
  }
}

/// كائن يمثل الجلسة الحالية للمستخدم الموثق في التطبيق
class UserSession {
  final String userId;
  final String username;
  final String fullName;
  final UserRole role;
  final DeviceState deviceState;
  final String? deviceId;
  final String? accessToken;
  final String? refreshToken;

  const UserSession({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
    this.deviceState = DeviceState.unregistered,
    this.deviceId,
    this.accessToken,
    this.refreshToken,
  });

  /// إنشاء نسخة محدثة من الجلسة
  UserSession copyWith({
    String? userId,
    String? username,
    String? fullName,
    UserRole? role,
    DeviceState? deviceState,
    String? deviceId,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserSession(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      deviceState: deviceState ?? this.deviceState,
      deviceId: deviceId ?? this.deviceId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'full_name': fullName,
      'role': role.toRoleString(),
      'device_state': deviceState.toStateString(),
      'device_id': deviceId,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      userId: json['user_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      role: UserRole.fromString(json['role'] as String? ?? 'STUDENT'),
      deviceState: DeviceState.fromString(json['device_state'] as String? ?? 'Unregistered'),
      deviceId: json['device_id'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }
}
