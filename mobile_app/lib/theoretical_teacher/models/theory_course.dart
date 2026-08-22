/// نموذج يمثل المقرر النظري والشعب التابعة له المسندة للأستاذ النظري (Theory Course)
class TheoryCourse {
  final String id;
  final String courseCode;
  final String courseName;
  final String departmentName;
  final int creditHours;
  final List<String> sections;
  final int totalStudents;
  final int totalLecturesDelivered;
  final double averageAttendanceRate;
  final int atRiskStudentsCount;
  final int deprivedStudentsCount;

  const TheoryCourse({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.departmentName,
    this.creditHours = 3,
    this.sections = const ['01'],
    required this.totalStudents,
    this.totalLecturesDelivered = 0,
    this.averageAttendanceRate = 0.0,
    this.atRiskStudentsCount = 0,
    this.deprivedStudentsCount = 0,
  });

  String get formattedAttendanceRate => '${averageAttendanceRate.toStringAsFixed(1)}%';

  TheoryCourse copyWith({
    String? id,
    String? courseCode,
    String? courseName,
    String? departmentName,
    int? creditHours,
    List<String>? sections,
    int? totalStudents,
    int? totalLecturesDelivered,
    double? averageAttendanceRate,
    int? atRiskStudentsCount,
    int? deprivedStudentsCount,
  }) {
    return TheoryCourse(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      departmentName: departmentName ?? this.departmentName,
      creditHours: creditHours ?? this.creditHours,
      sections: sections ?? this.sections,
      totalStudents: totalStudents ?? this.totalStudents,
      totalLecturesDelivered: totalLecturesDelivered ?? this.totalLecturesDelivered,
      averageAttendanceRate: averageAttendanceRate ?? this.averageAttendanceRate,
      atRiskStudentsCount: atRiskStudentsCount ?? this.atRiskStudentsCount,
      deprivedStudentsCount: deprivedStudentsCount ?? this.deprivedStudentsCount,
    );
  }

  factory TheoryCourse.fromJson(Map<String, dynamic> json) {
    return TheoryCourse(
      id: json['id'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? json['title'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? 'تقنية المعلومات',
      creditHours: (json['credit_hours'] as num?)?.toInt() ?? 3,
      sections: (json['sections'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['01'],
      totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
      totalLecturesDelivered: (json['total_lectures_delivered'] as num?)?.toInt() ?? 0,
      averageAttendanceRate: (json['average_attendance_rate'] as num?)?.toDouble() ?? 0.0,
      atRiskStudentsCount: (json['at_risk_students_count'] as num?)?.toInt() ?? 0,
      deprivedStudentsCount: (json['deprived_students_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_name': courseName,
      'department_name': departmentName,
      'credit_hours': creditHours,
      'sections': sections,
      'total_students': totalStudents,
      'total_lectures_delivered': totalLecturesDelivered,
      'average_attendance_rate': averageAttendanceRate,
      'at_risk_students_count': atRiskStudentsCount,
      'deprived_students_count': deprivedStudentsCount,
    };
  }
}
