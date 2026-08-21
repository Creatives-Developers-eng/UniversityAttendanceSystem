/// نوع الشعبة الدراسية (عملي أو نظري)
enum SectionType {
  practical,
  theoretical,
}

/// نموذج المادة الدراسية والشعبة المسجلة للطالب
class StudentCourse {
  final String id;
  final String courseCode;
  final String courseName;
  final int creditHours;
  final String sectionId;
  final String sectionNumber;
  final SectionType sectionType;
  final String teacherName;
  final int totalLectures;
  final int attendedLectures;
  final int absentLectures;
  final int lateLectures;
  final int excusedLectures;
  final String roomName;
  final String scheduleTime;

  const StudentCourse({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.creditHours,
    required this.sectionId,
    required this.sectionNumber,
    required this.sectionType,
    required this.teacherName,
    required this.totalLectures,
    required this.attendedLectures,
    this.absentLectures = 0,
    this.lateLectures = 0,
    this.excusedLectures = 0,
    required this.roomName,
    required this.scheduleTime,
  });

  /// حساب النسبة المئوية للحضور بدقة
  double get attendancePercentage {
    if (totalLectures <= 0) return 100.0;
    final percentage = (attendedLectures / totalLectures) * 100.0;
    return percentage.clamp(0.0, 100.0);
  }

  /// هل الطالب في دائرة الخطر (أقل من 85%)
  bool get isWarning => attendancePercentage < 85.0 && attendancePercentage >= 75.0;

  /// هل الطالب محروم من المادة (أقل من 75%)
  bool get isDeprived => attendancePercentage < 75.0;

  /// اسم نوع الشعبة بالعربية
  String get sectionTypeArabic => sectionType == SectionType.practical ? 'عملي' : 'نظري';

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    return StudentCourse(
      id: json['id'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      creditHours: (json['credit_hours'] as num?)?.toInt() ?? 3,
      sectionId: json['section_id'] as String? ?? '',
      sectionNumber: json['section_number'] as String? ?? '1',
      sectionType: (json['section_type'] as String?)?.toUpperCase() == 'PRACTICAL'
          ? SectionType.practical
          : SectionType.theoretical,
      teacherName: json['teacher_name'] as String? ?? '',
      totalLectures: (json['total_lectures'] as num?)?.toInt() ?? 0,
      attendedLectures: (json['attended_lectures'] as num?)?.toInt() ?? 0,
      absentLectures: (json['absent_lectures'] as num?)?.toInt() ?? 0,
      lateLectures: (json['late_lectures'] as num?)?.toInt() ?? 0,
      excusedLectures: (json['excused_lectures'] as num?)?.toInt() ?? 0,
      roomName: json['room_name'] as String? ?? '',
      scheduleTime: json['schedule_time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_name': courseName,
      'credit_hours': creditHours,
      'section_id': sectionId,
      'section_number': sectionNumber,
      'section_type': sectionType == SectionType.practical ? 'PRACTICAL' : 'THEORETICAL',
      'teacher_name': teacherName,
      'total_lectures': totalLectures,
      'attended_lectures': attendedLectures,
      'absent_lectures': absentLectures,
      'late_lectures': lateLectures,
      'excused_lectures': excusedLectures,
      'room_name': roomName,
      'schedule_time': scheduleTime,
    };
  }
}
