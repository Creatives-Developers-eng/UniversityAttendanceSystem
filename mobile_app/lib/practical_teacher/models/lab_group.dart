/// نوع مجموعة المعمل العملي
enum LabGroupType {
  softwareLab,
  networkLab,
  databaseLab,
  hardwareLab,
}

/// نموذج يمثل مجموعة المعمل العملي والشعبة المسندة لأستاذ العملي (Lab Group)
class LabGroup {
  final String id;
  final String courseId;
  final String courseCode;
  final String courseName;
  final String sectionNumber;
  final String groupName; // e.g. "مجموعة A - معمل البرمجيات 1"
  final LabGroupType groupType;
  final String roomName;
  final String scheduleTime;
  final int totalStudents;
  final int attendedStudents;
  final String? delegateId;
  final String? delegateName;
  final bool isLiveNow;
  final String? activeSessionId;

  const LabGroup({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.sectionNumber,
    required this.groupName,
    this.groupType = LabGroupType.softwareLab,
    this.roomName = 'معمل الحاسوب 1',
    this.scheduleTime = 'غير محدد',
    required this.totalStudents,
    this.attendedStudents = 0,
    this.delegateId,
    this.delegateName,
    this.isLiveNow = false,
    this.activeSessionId,
  });

  double get attendancePercentage => totalStudents > 0
      ? ((attendedStudents / totalStudents) * 100.0).clamp(0.0, 100.0)
      : 0.0;

  String get groupTypeArabic {
    switch (groupType) {
      case LabGroupType.softwareLab:
        return 'معمل برمجيات';
      case LabGroupType.networkLab:
        return 'معمل شبكات';
      case LabGroupType.databaseLab:
        return 'معمل قواعد بيانات';
      case LabGroupType.hardwareLab:
        return 'معمل عتاد ودوائر';
    }
  }

  LabGroup copyWith({
    String? id,
    String? courseId,
    String? courseCode,
    String? courseName,
    String? sectionNumber,
    String? groupName,
    LabGroupType? groupType,
    String? roomName,
    String? scheduleTime,
    int? totalStudents,
    int? attendedStudents,
    String? delegateId,
    String? delegateName,
    bool? isLiveNow,
    String? activeSessionId,
  }) {
    return LabGroup(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      sectionNumber: sectionNumber ?? this.sectionNumber,
      groupName: groupName ?? this.groupName,
      groupType: groupType ?? this.groupType,
      roomName: roomName ?? this.roomName,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      totalStudents: totalStudents ?? this.totalStudents,
      attendedStudents: attendedStudents ?? this.attendedStudents,
      delegateId: delegateId ?? this.delegateId,
      delegateName: delegateName ?? this.delegateName,
      isLiveNow: isLiveNow ?? this.isLiveNow,
      activeSessionId: activeSessionId ?? this.activeSessionId,
    );
  }

  factory LabGroup.fromJson(Map<String, dynamic> json) {
    LabGroupType parseType(String? val) {
      switch (val?.toLowerCase()) {
        case 'network':
          return LabGroupType.networkLab;
        case 'database':
          return LabGroupType.databaseLab;
        case 'hardware':
          return LabGroupType.hardwareLab;
        case 'software':
        default:
          return LabGroupType.softwareLab;
      }
    }

    return LabGroup(
      id: json['id'] as String? ?? '',
      courseId: json['course_id'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? json['title'] as String? ?? '',
      sectionNumber: json['section_number'] as String? ?? '01',
      groupName: json['group_name'] as String? ?? 'مجموعة معملية',
      groupType: parseType(json['group_type'] as String?),
      roomName: json['room_name'] as String? ?? 'معمل الحاسوب 1',
      scheduleTime: json['schedule_time'] as String? ?? 'غير محدد',
      totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
      attendedStudents: (json['attended_students'] as num?)?.toInt() ?? 0,
      delegateId: json['delegate_id'] as String?,
      delegateName: json['delegate_name'] as String?,
      isLiveNow: json['is_live_now'] as bool? ?? false,
      activeSessionId: json['active_session_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'course_code': courseCode,
      'course_name': courseName,
      'section_number': sectionNumber,
      'group_name': groupName,
      'group_type': groupType.name,
      'room_name': roomName,
      'schedule_time': scheduleTime,
      'total_students': totalStudents,
      'attended_students': attendedStudents,
      'delegate_id': delegateId,
      'delegate_name': delegateName,
      'is_live_now': isLiveNow,
      'active_session_id': activeSessionId,
    };
  }
}
