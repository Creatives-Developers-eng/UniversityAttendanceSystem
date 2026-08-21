/// نوع الشعبة الأكاديمية
enum DelegateSectionType {
  practical,
  theoretical,
}

/// نموذج يمثل الشعبة الأكاديمية المفوض بها الطالب كمندوب (Delegate Section)
class DelegateSection {
  final String id;
  final String courseId;
  final String courseCode;
  final String courseName;
  final String sectionNumber;
  final DelegateSectionType sectionType;
  final String teacherId;
  final String teacherName;
  final int totalStudents;
  final String roomName;
  final String scheduleTime;
  final bool isActive;

  const DelegateSection({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.sectionNumber,
    required this.sectionType,
    required this.teacherId,
    required this.teacherName,
    required this.totalStudents,
    this.roomName = 'القاعة الرئيسية',
    this.scheduleTime = 'غير محدد',
    this.isActive = true,
  });

  bool get isPractical => sectionType == DelegateSectionType.practical;
  bool get isTheoretical => sectionType == DelegateSectionType.theoretical;

  String get sectionTypeArabic => isPractical ? 'شعبة عملية' : 'شعبة نظرية';

  factory DelegateSection.fromJson(Map<String, dynamic> json) {
    return DelegateSection(
      id: json['id'] as String? ?? '',
      courseId: json['course_id'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? json['title'] as String? ?? '',
      sectionNumber: json['section_number'] as String? ?? '01',
      sectionType: (json['section_type'] as String?)?.toUpperCase() == 'THEORETICAL'
          ? DelegateSectionType.theoretical
          : DelegateSectionType.practical,
      teacherId: json['teacher_id'] as String? ?? '',
      teacherName: json['teacher_name'] as String? ?? '',
      totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
      roomName: json['room_name'] as String? ?? 'القاعة الرئيسية',
      scheduleTime: json['schedule_time'] as String? ?? 'غير محدد',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'course_code': courseCode,
      'course_name': courseName,
      'section_number': sectionNumber,
      'section_type': isPractical ? 'PRACTICAL' : 'THEORETICAL',
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'total_students': totalStudents,
      'room_name': roomName,
      'schedule_time': scheduleTime,
      'is_active': isActive,
    };
  }
}
