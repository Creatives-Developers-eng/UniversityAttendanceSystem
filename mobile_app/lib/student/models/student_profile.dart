/// حالة الحساب الرسمية للطالب وفقاً لنظام الحضور
enum StudentAccountState {
  active,
  inactive,
  suspended,
}

/// حالة ارتباط الجهاز الحالي للطالب
enum StudentDeviceState {
  bound,
  unbound,
  pendingVerification,
}

/// نموذج الملف الشخصي للطالب والبطاقة الجامعية
class StudentProfile {
  final String id;
  final String studentNumber;
  final String fullName;
  final String email;
  final String? phone;
  final String departmentId;
  final String departmentName;
  final String collegeName;
  final String academicYearId;
  final String academicYearName;
  final int academicLevel;
  final String? profileImageUrl;
  final StudentAccountState accountState;
  final StudentDeviceState deviceState;
  final String? boundDeviceId;
  final DateTime? boundAt;

  const StudentProfile({
    required this.id,
    required this.studentNumber,
    required this.fullName,
    required this.email,
    this.phone,
    required this.departmentId,
    required this.departmentName,
    required this.collegeName,
    required this.academicYearId,
    required this.academicYearName,
    required this.academicLevel,
    this.profileImageUrl,
    this.accountState = StudentAccountState.active,
    this.deviceState = StudentDeviceState.bound,
    this.boundDeviceId,
    this.boundAt,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as String? ?? '',
      studentNumber: json['student_number'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      departmentId: json['department_id'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? '',
      collegeName: json['college_name'] as String? ?? 'كلية الهندسة وتكنولوجيا المعلومات',
      academicYearId: json['academic_year_id'] as String? ?? '',
      academicYearName: json['academic_year_name'] as String? ?? '2025/2026',
      academicLevel: (json['academic_level'] as num?)?.toInt() ?? 3,
      profileImageUrl: json['profile_image_url'] as String?,
      accountState: _parseAccountState(json['account_state'] as String?),
      deviceState: _parseDeviceState(json['device_state'] as String?),
      boundDeviceId: json['bound_device_id'] as String?,
      boundAt: json['bound_at'] != null ? DateTime.tryParse(json['bound_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_number': studentNumber,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'department_id': departmentId,
      'department_name': departmentName,
      'college_name': collegeName,
      'academic_year_id': academicYearId,
      'academic_year_name': academicYearName,
      'academic_level': academicLevel,
      'profile_image_url': profileImageUrl,
      'account_state': accountState.name,
      'device_state': deviceState.name,
      'bound_device_id': boundDeviceId,
      'bound_at': boundAt?.toIso8601String(),
    };
  }

  static StudentAccountState _parseAccountState(String? state) {
    switch (state?.toLowerCase()) {
      case 'active':
        return StudentAccountState.active;
      case 'suspended':
        return StudentAccountState.suspended;
      default:
        return StudentAccountState.active;
    }
  }

  static StudentDeviceState _parseDeviceState(String? state) {
    switch (state?.toLowerCase()) {
      case 'bound':
        return StudentDeviceState.bound;
      case 'pending':
        return StudentDeviceState.pendingVerification;
      case 'unbound':
      default:
        return StudentDeviceState.bound;
    }
  }
}
