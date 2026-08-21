/// عنصر اتجاه الحضور الأسبوعي للرسم البياني
class WeeklyTrendItem {
  final int weekNumber;
  final String weekLabel;
  final double attendanceRate;
  final double absentRate;

  const WeeklyTrendItem({
    required this.weekNumber,
    required this.weekLabel,
    required this.attendanceRate,
    this.absentRate = 0.0,
  });

  factory WeeklyTrendItem.fromJson(Map<String, dynamic> json) {
    return WeeklyTrendItem(
      weekNumber: (json['week_number'] as num?)?.toInt() ?? 1,
      weekLabel: json['week_label'] as String? ?? 'الأسبوع 1',
      attendanceRate: (json['attendance_rate'] as num?)?.toDouble() ?? 0.0,
      absentRate: (json['absent_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week_number': weekNumber,
      'week_label': weekLabel,
      'attendance_rate': attendanceRate,
      'absent_rate': absentRate,
    };
  }
}

/// نموذج يمثل تحليلات وإحصائيات الحضور للمقرر النظري (Attendance Analytics)
class AttendanceAnalytics {
  final String courseId;
  final String courseCode;
  final String courseName;
  final int totalLectures;
  final int totalEnrolledStudents;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final int excusedCount;
  final List<WeeklyTrendItem> weeklyTrends;

  const AttendanceAnalytics({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.totalLectures,
    required this.totalEnrolledStudents,
    this.presentCount = 0,
    this.absentCount = 0,
    this.lateCount = 0,
    this.excusedCount = 0,
    this.weeklyTrends = const [],
  });

  int get totalRecords => presentCount + absentCount + lateCount + excusedCount;

  double get presentPercentage => totalRecords > 0 ? ((presentCount / totalRecords) * 100.0) : 0.0;
  double get absentPercentage => totalRecords > 0 ? ((absentCount / totalRecords) * 100.0) : 0.0;
  double get latePercentage => totalRecords > 0 ? ((lateCount / totalRecords) * 100.0) : 0.0;
  double get excusedPercentage => totalRecords > 0 ? ((excusedCount / totalRecords) * 100.0) : 0.0;

  factory AttendanceAnalytics.fromJson(Map<String, dynamic> json) {
    return AttendanceAnalytics(
      courseId: json['course_id'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      totalLectures: (json['total_lectures'] as num?)?.toInt() ?? 0,
      totalEnrolledStudents: (json['total_enrolled_students'] as num?)?.toInt() ?? 0,
      presentCount: (json['present_count'] as num?)?.toInt() ?? 0,
      absentCount: (json['absent_count'] as num?)?.toInt() ?? 0,
      lateCount: (json['late_count'] as num?)?.toInt() ?? 0,
      excusedCount: (json['excused_count'] as num?)?.toInt() ?? 0,
      weeklyTrends: (json['weekly_trends'] as List<dynamic>?)
              ?.map((e) => WeeklyTrendItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_code': courseCode,
      'course_name': courseName,
      'total_lectures': totalLectures,
      'total_enrolled_students': totalEnrolledStudents,
      'present_count': presentCount,
      'absent_count': absentCount,
      'late_count': lateCount,
      'excused_count': excusedCount,
      'weekly_trends': weeklyTrends.map((e) => e.toJson()).toList(),
    };
  }
}
