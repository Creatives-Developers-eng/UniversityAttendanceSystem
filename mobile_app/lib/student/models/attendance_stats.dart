/// نموذج الإحصائيات الشاملة لحضور الطالب التراكمي
class AttendanceStats {
  final int totalSessions;
  final int totalPresent;
  final int totalAbsent;
  final int totalLate;
  final int totalExcused;
  final int totalCourses;

  const AttendanceStats({
    required this.totalSessions,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalExcused,
    required this.totalCourses,
  });

  /// معدل الحضور الكلي بالنسبة المئوية
  double get attendancePercentage {
    if (totalSessions <= 0) return 100.0;
    return ((totalPresent + totalLate) / totalSessions * 100.0).clamp(0.0, 100.0);
  }

  /// نسبة الغياب الكلية
  double get absencePercentage {
    if (totalSessions <= 0) return 0.0;
    return (totalAbsent / totalSessions * 100.0).clamp(0.0, 100.0);
  }

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
      totalPresent: (json['total_present'] as num?)?.toInt() ?? 0,
      totalAbsent: (json['total_absent'] as num?)?.toInt() ?? 0,
      totalLate: (json['total_late'] as num?)?.toInt() ?? 0,
      totalExcused: (json['total_excused'] as num?)?.toInt() ?? 0,
      totalCourses: (json['total_courses'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sessions': totalSessions,
      'total_present': totalPresent,
      'total_absent': totalAbsent,
      'total_late': totalLate,
      'total_excused': totalExcused,
      'total_courses': totalCourses,
      'attendance_percentage': attendancePercentage,
    };
  }
}
