/// حالة الحضور للجلسة الفردية
enum StudentAttendanceState {
  present,
  absent,
  late,
  excused,
}

/// طريقة تسجيل الحضور
enum AttendanceVerificationMethod {
  qr,
  biometric,
  manual,
}

/// نموذج سجل الحضور لجلسة أو محاضرة معينة
class StudentAttendanceRecord {
  final String id;
  final String sessionId;
  final String courseId;
  final String courseCode;
  final String courseName;
  final String sectionNumber;
  final String teacherName;
  final DateTime sessionDate;
  final String attendanceState;
  final String verificationMethod;
  final DateTime? verifiedAt;
  final String? note;

  const StudentAttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.sectionNumber,
    required this.teacherName,
    required this.sessionDate,
    required this.attendanceState,
    required this.verificationMethod,
    this.verifiedAt,
    this.note,
  });

  bool get isPresent => attendanceState.toUpperCase() == 'PRESENT';
  bool get isAbsent => attendanceState.toUpperCase() == 'ABSENT';
  bool get isLate => attendanceState.toUpperCase() == 'LATE';
  bool get isExcused => attendanceState.toUpperCase() == 'EXCUSED';

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
    switch (verificationMethod.toUpperCase()) {
      case 'QR':
        return 'رمز QR';
      case 'BIOMETRIC':
        return 'التحقق الحيوي';
      case 'MANUAL':
        return 'تحضير يدوي';
      default:
        return verificationMethod;
    }
  }

  factory StudentAttendanceRecord.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceRecord(
      id: json['id'] as String? ?? '',
      sessionId: json['session_id'] as String? ?? '',
      courseId: json['course_id'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      sectionNumber: json['section_number'] as String? ?? '',
      teacherName: json['teacher_name'] as String? ?? '',
      sessionDate: json['session_date'] != null
          ? DateTime.tryParse(json['session_date'] as String) ?? DateTime.now()
          : DateTime.now(),
      attendanceState: json['attendance_state'] as String? ?? 'PRESENT',
      verificationMethod: json['verification_method'] as String? ?? 'QR',
      verifiedAt: json['verified_at'] != null
          ? DateTime.tryParse(json['verified_at'] as String)
          : null,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'course_id': courseId,
      'course_code': courseCode,
      'course_name': courseName,
      'section_number': sectionNumber,
      'teacher_name': teacherName,
      'session_date': sessionDate.toIso8601String(),
      'attendance_state': attendanceState,
      'verification_method': verificationMethod,
      'verified_at': verifiedAt?.toIso8601String(),
      'note': note,
    };
  }
}
