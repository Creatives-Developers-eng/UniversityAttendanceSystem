import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';

/// نموذج يمثل قيد الطالب في كشف حضور الشعبة الخاصة بالمندوب (Delegate Student Entry)
class DelegateStudentEntry {
  final String studentId;
  final String studentNumber;
  final String fullName;
  final String departmentName;
  final int academicLevel;
  final String attendanceState; // PRESENT | ABSENT | LATE | EXCUSED
  final String? attendanceMethod; // QR | BIOMETRIC | MANUAL
  final DateTime? markedAt;
  final String? manualReason;
  final bool isVerified;

  const DelegateStudentEntry({
    required this.studentId,
    required this.studentNumber,
    required this.fullName,
    this.departmentName = 'هندسة تقنية المعلومات',
    this.academicLevel = 3,
    this.attendanceState = 'ABSENT',
    this.attendanceMethod,
    this.markedAt,
    this.manualReason,
    this.isVerified = false,
  });

  bool get isPresent => attendanceState.toUpperCase() == 'PRESENT';
  bool get isAbsent => attendanceState.toUpperCase() == 'ABSENT';
  bool get isLate => attendanceState.toUpperCase() == 'LATE';
  bool get isExcused => attendanceState.toUpperCase() == 'EXCUSED';

  String get stateArabic {
    switch (attendanceState.toUpperCase()) {
      case 'PRESENT':
        return 'حاضر';
      case 'LATE':
        return 'متأخر';
      case 'EXCUSED':
        return 'معذور';
      case 'ABSENT':
      default:
        return 'غائب';
    }
  }

  Color get stateColor {
    switch (attendanceState.toUpperCase()) {
      case 'PRESENT':
        return AppColors.success;
      case 'LATE':
        return AppColors.warning;
      case 'EXCUSED':
        return const Color(0xFF0284C7);
      case 'ABSENT':
      default:
        return AppColors.error;
    }
  }

  String get methodArabic {
    switch (attendanceMethod?.toUpperCase()) {
      case 'QR':
        return 'رمز QR';
      case 'BIOMETRIC':
        return 'التحقق الحيوي';
      case 'MANUAL':
        return 'تحضير يدوي';
      default:
        return 'غير محدد';
    }
  }

  DelegateStudentEntry copyWith({
    String? studentId,
    String? studentNumber,
    String? fullName,
    String? departmentName,
    int? academicLevel,
    String? attendanceState,
    String? attendanceMethod,
    DateTime? markedAt,
    String? manualReason,
    bool? isVerified,
  }) {
    return DelegateStudentEntry(
      studentId: studentId ?? this.studentId,
      studentNumber: studentNumber ?? this.studentNumber,
      fullName: fullName ?? this.fullName,
      departmentName: departmentName ?? this.departmentName,
      academicLevel: academicLevel ?? this.academicLevel,
      attendanceState: attendanceState ?? this.attendanceState,
      attendanceMethod: attendanceMethod ?? this.attendanceMethod,
      markedAt: markedAt ?? this.markedAt,
      manualReason: manualReason ?? this.manualReason,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  factory DelegateStudentEntry.fromJson(Map<String, dynamic> json) {
    return DelegateStudentEntry(
      studentId: json['student_id'] as String? ?? json['id'] as String? ?? '',
      studentNumber: json['student_number'] as String? ?? '',
      fullName: json['full_name'] as String? ?? json['name'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? 'هندسة تقنية المعلومات',
      academicLevel: (json['academic_level'] as num?)?.toInt() ?? 3,
      attendanceState: json['attendance_state'] as String? ?? 'ABSENT',
      attendanceMethod: json['attendance_method'] as String? directions,
      markedAt: json['marked_at'] != null ? DateTime.parse(json['marked_at'] as String) : null,
      manualReason: json['manual_reason'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_number': studentNumber,
      'full_name': fullName,
      'department_name': departmentName,
      'academic_level': academicLevel,
      'attendance_state': attendanceState,
      'attendance_method': attendanceMethod,
      'marked_at': markedAt?.toIso8601String(),
      'manual_reason': manualReason,
      'is_verified': isVerified,
    };
  }
}
