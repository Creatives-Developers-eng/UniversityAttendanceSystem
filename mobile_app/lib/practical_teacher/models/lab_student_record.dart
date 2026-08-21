/// حالة الاستثناء أو التحضير اليدوي المعلق
enum LabExceptionStatus {
  none,
  pending,
  approved,
  rejected,
}

/// سجل حضور الطالب الفردي في كشف المعمل العملي (Lab Student Record)
class LabStudentRecord {
  final String studentId;
  final String studentNumber;
  final String fullName;
  final String departmentName;
  final String academicLevel;
  final String groupName;
  final String attendanceState; // PRESENT | ABSENT | LATE | EXCUSED
  final String attendanceMethod; // QR | BIOMETRIC | MANUAL
  final DateTime? markedAt;
  final bool isVerified;
  final String? manualReason;
  final LabExceptionStatus exceptionStatus;
  final String? teacherNotes;

  const LabStudentRecord({
    required this.studentId,
    required this.studentNumber,
    required this.fullName,
    required this.departmentName,
    this.academicLevel = 'المستوى الثالث',
    required this.groupName,
    this.attendanceState = 'ABSENT',
    this.attendanceMethod = 'MANUAL',
    this.markedAt,
    this.isVerified = false,
    this.manualReason,
    this.exceptionStatus = LabExceptionStatus.none,
    this.teacherNotes,
  });

  bool get isPresent => attendanceState.toUpperCase() == 'PRESENT';
  bool get isAbsent => attendanceState.toUpperCase() == 'ABSENT';
  bool get isLate => attendanceState.toUpperCase() == 'LATE';
  bool get isExcused => attendanceState.toUpperCase() == 'EXCUSED';

  bool get hasPendingException => exceptionStatus == LabExceptionStatus.pending;
  bool get isExceptionApproved => exceptionStatus == LabExceptionStatus.approved;
  bool get isExceptionRejected => exceptionStatus == LabExceptionStatus.rejected;

  String get stateArabic {
    switch (attendanceState.toUpperCase()) {
      case 'PRESENT':
        return 'حاضر';
      case 'ABSENT':
        return 'غائب';
      case 'LATE':
        return 'متأخر';
      case 'EXCUSED':
        return 'معذور';
      default:
        return attendanceState;
    }
  }

  String get methodArabic {
    switch (attendanceMethod.toUpperCase()) {
      case 'QR':
        return 'رمز QR';
      case 'BIOMETRIC':
        return 'التحقق الحيوي';
      case 'MANUAL':
      default:
        return 'تحضير يدوي';
    }
  }

  String get exceptionStatusArabic {
    switch (exceptionStatus) {
      case LabExceptionStatus.pending:
        return 'بانتظار الاعتماد';
      case LabExceptionStatus.approved:
        return 'معتمد';
      case LabExceptionStatus.rejected:
        return 'مرفوض';
      case LabExceptionStatus.none:
        return 'لا يوجد';
    }
  }

  LabStudentRecord copyWith({
    String? studentId,
    String? studentNumber,
    String? fullName,
    String? departmentName,
    String? academicLevel,
    String? groupName,
    String? attendanceState,
    String? attendanceMethod,
    DateTime? markedAt,
    bool? isVerified,
    String? manualReason,
    LabExceptionStatus? exceptionStatus,
    String? teacherNotes,
  }) {
    return LabStudentRecord(
      studentId: studentId ?? this.studentId,
      studentNumber: studentNumber ?? this.studentNumber,
      fullName: fullName ?? this.fullName,
      departmentName: departmentName ?? this.departmentName,
      academicLevel: academicLevel ?? this.academicLevel,
      groupName: groupName ?? this.groupName,
      attendanceState: attendanceState ?? this.attendanceState,
      attendanceMethod: attendanceMethod ?? this.attendanceMethod,
      markedAt: markedAt ?? this.markedAt,
      isVerified: isVerified ?? this.isVerified,
      manualReason: manualReason ?? this.manualReason,
      exceptionStatus: exceptionStatus ?? this.exceptionStatus,
      teacherNotes: teacherNotes ?? this.teacherNotes,
    );
  }

  factory LabStudentRecord.fromJson(Map<String, dynamic> json) {
    LabExceptionStatus parseException(String? val) {
      switch (val?.toLowerCase()) {
        case 'pending':
          return LabExceptionStatus.pending;
        case 'approved':
          return LabExceptionStatus.approved;
        case 'rejected':
          return LabExceptionStatus.rejected;
        case 'none':
        default:
          return LabExceptionStatus.none;
      }
    }

    return LabStudentRecord(
      studentId: json['student_id'] as String? ?? '',
      studentNumber: json['student_number'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? 'تقنية المعلومات',
      academicLevel: json['academic_level'] as String? ?? 'المستوى الثالث',
      groupName: json['group_name'] as String? ?? '',
      attendanceState: json['attendance_state'] as String? ?? 'ABSENT',
      attendanceMethod: json['attendance_method'] as String? ?? 'MANUAL',
      markedAt: json['marked_at'] != null
          ? DateTime.tryParse(json['marked_at'] as String)
          : null,
      isVerified: json['is_verified'] as bool? ?? false,
      manualReason: json['manual_reason'] as String?,
      exceptionStatus: parseException(json['exception_status'] as String?),
      teacherNotes: json['teacher_notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_number': studentNumber,
      'full_name': fullName,
      'department_name': departmentName,
      'academic_level': academicLevel,
      'group_name': groupName,
      'attendance_state': attendanceState,
      'attendance_method': attendanceMethod,
      'marked_at': markedAt?.toIso8601String(),
      'is_verified': isVerified,
      'manual_reason': manualReason,
      'exception_status': exceptionStatus.name,
      'teacher_notes': teacherNotes,
    };
  }
}
