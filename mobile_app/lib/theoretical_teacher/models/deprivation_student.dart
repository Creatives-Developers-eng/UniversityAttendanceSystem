/// مستوى خطر الحرمان الأكاديمي
enum DeprivationRiskLevel {
  safe, // نسبة غياب أقل من 10%
  low, // 10% - 14%
  warningFirst, // إنذار أول: 15% - 19%
  warningSecond, // إنذار ثانٍ: 20% - 24%
  deprived, // حرمان نهائي: 25% فما فوق
}

/// نموذج يمثل الطالب المعرض للحرمان وسجل الإنذارات الأكاديمية (Deprivation Student)
class DeprivationStudent {
  final String studentId;
  final String studentNumber;
  final String fullName;
  final String departmentName;
  final String sectionNumber;
  final int totalLectures;
  final int absentLecturesCount;
  final double absencePercentage;
  final DeprivationRiskLevel riskLevel;
  final String warningStatus;
  final DateTime? lastWarningSentAt;
  final bool hasPendingExcuse;

  const DeprivationStudent({
    required this.studentId,
    required this.studentNumber,
    required this.fullName,
    required this.departmentName,
    this.sectionNumber = '01',
    required this.totalLectures,
    required this.absentLecturesCount,
    required this.absencePercentage,
    required this.riskLevel,
    this.warningStatus = 'لم يصدر إنذار',
    this.lastWarningSentAt,
    this.hasPendingExcuse = false,
  });

  bool get isDeprived => riskLevel == DeprivationRiskLevel.deprived;
  bool get isWarningFirst => riskLevel == DeprivationRiskLevel.warningFirst;
  bool get isWarningSecond => riskLevel == DeprivationRiskLevel.warningSecond;
  bool get isAtRisk =>
      riskLevel == DeprivationRiskLevel.warningFirst ||
      riskLevel == DeprivationRiskLevel.warningSecond ||
      riskLevel == DeprivationRiskLevel.deprived;

  String get riskLevelArabic {
    switch (riskLevel) {
      case DeprivationRiskLevel.safe:
        return 'منتظم (آمن)';
      case DeprivationRiskLevel.low:
        return 'ملاحظة غياب';
      case DeprivationRiskLevel.warningFirst:
        return 'إنذار أول (15%)';
      case DeprivationRiskLevel.warningSecond:
        return 'إنذار ثانٍ حرج (20%)';
      case DeprivationRiskLevel.deprived:
        return 'محروم نهائياً (25%+)';
    }
  }

  DeprivationStudent copyWith({
    String? studentId,
    String? studentNumber,
    String? fullName,
    String? departmentName,
    String? sectionNumber,
    int? totalLectures,
    int? absentLecturesCount,
    double? absencePercentage,
    DeprivationRiskLevel? riskLevel,
    String? warningStatus,
    DateTime? lastWarningSentAt,
    bool? hasPendingExcuse,
  }) {
    return DeprivationStudent(
      studentId: studentId ?? this.studentId,
      studentNumber: studentNumber ?? this.studentNumber,
      fullName: fullName ?? this.fullName,
      departmentName: departmentName ?? this.departmentName,
      sectionNumber: sectionNumber ?? this.sectionNumber,
      totalLectures: totalLectures ?? this.totalLectures,
      absentLecturesCount: absentLecturesCount ?? this.absentLecturesCount,
      absencePercentage: absencePercentage ?? this.absencePercentage,
      riskLevel: riskLevel ?? this.riskLevel,
      warningStatus: warningStatus ?? this.warningStatus,
      lastWarningSentAt: lastWarningSentAt ?? this.lastWarningSentAt,
      hasPendingExcuse: hasPendingExcuse ?? this.hasPendingExcuse,
    );
  }

  factory DeprivationStudent.fromJson(Map<String, dynamic> json) {
    DeprivationRiskLevel parseRisk(String? val) {
      switch (val?.toLowerCase()) {
        case 'deprived':
          return DeprivationRiskLevel.deprived;
        case 'warningsecond':
        case 'warning_second':
          return DeprivationRiskLevel.warningSecond;
        case 'warningfirst':
        case 'warning_first':
          return DeprivationRiskLevel.warningFirst;
        case 'low':
          return DeprivationRiskLevel.low;
        case 'safe':
        default:
          return DeprivationRiskLevel.safe;
      }
    }

    return DeprivationStudent(
      studentId: json['student_id'] as String? ?? '',
      studentNumber: json['student_number'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? 'تقنية المعلومات',
      sectionNumber: json['section_number'] as String? ?? '01',
      totalLectures: (json['total_lectures'] as num?)?.toInt() ?? 0,
      absentLecturesCount: (json['absent_lectures_count'] as num?)?.toInt() ?? 0,
      absencePercentage: (json['absence_percentage'] as num?)?.toDouble() ?? 0.0,
      riskLevel: parseRisk(json['risk_level'] as String?),
      warningStatus: json['warning_status'] as String? ?? 'لم يصدر إنذار',
      lastWarningSentAt: json['last_warning_sent_at'] != null
          ? DateTime.tryParse(json['last_warning_sent_at'] as String)
          : null,
      hasPendingExcuse: json['has_pending_excuse'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_number': studentNumber,
      'full_name': fullName,
      'department_name': departmentName,
      'section_number': sectionNumber,
      'total_lectures': totalLectures,
      'absent_lectures_count': absentLecturesCount,
      'absence_percentage': absencePercentage,
      'risk_level': riskLevel.name,
      'warning_status': warningStatus,
      'last_warning_sent_at': lastWarningSentAt?.toIso8601String(),
      'has_pending_excuse': hasPendingExcuse,
    };
  }
}
