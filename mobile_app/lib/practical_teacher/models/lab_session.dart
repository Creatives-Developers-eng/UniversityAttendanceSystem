/// حالة جلسة المعمل العملي
enum LabSessionState {
  active,
  closed,
  synced,
}

/// نموذج يمثل جلسة المعمل العملي (Lab Session)
class LabSession {
  final String id;
  final String groupId;
  final String groupName;
  final String courseCode;
  final String courseName;
  final String sectionNumber;
  final DateTime sessionDate;
  final String roomName;
  final LabSessionState sessionState;
  final int totalStudents;
  final int attendedCount;
  final int absentCount;
  final int lateCount;
  final int excusedCount;
  final int pendingExceptionsCount;
  final DateTime? closedAt;
  final DateTime? syncedAt;
  final String? syncRecordId;

  const LabSession({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.courseCode,
    required this.courseName,
    required this.sectionNumber,
    required this.sessionDate,
    required this.roomName,
    this.sessionState = LabSessionState.active,
    required this.totalStudents,
    this.attendedCount = 0,
    this.absentCount = 0,
    this.lateCount = 0,
    this.excusedCount = 0,
    this.pendingExceptionsCount = 0,
    this.closedAt,
    this.syncedAt,
    this.syncRecordId,
  });

  bool get isActive => sessionState == LabSessionState.active;
  bool get isClosed => sessionState == LabSessionState.closed;
  bool get isSynced => sessionState == LabSessionState.synced;

  double get attendancePercentage => totalStudents > 0
      ? ((attendedCount / totalStudents) * 100.0).clamp(0.0, 100.0)
      : 0.0;

  String get stateArabic {
    switch (sessionState) {
      case LabSessionState.active:
        return 'جلسة نشطة ومباشرة';
      case LabSessionState.closed:
        return 'مغلقة محلياً';
      case LabSessionState.synced:
        return 'تمت المزامنة والاعتماد';
    }
  }

  LabSession copyWith({
    String? id,
    String? groupId,
    String? groupName,
    String? courseCode,
    String? courseName,
    String? sectionNumber,
    DateTime? sessionDate,
    String? roomName,
    LabSessionState? sessionState,
    int? totalStudents,
    int? attendedCount,
    int? absentCount,
    int? lateCount,
    int? excusedCount,
    int? pendingExceptionsCount,
    DateTime? closedAt,
    DateTime? syncedAt,
    String? syncRecordId,
  }) {
    return LabSession(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      sectionNumber: sectionNumber ?? this.sectionNumber,
      sessionDate: sessionDate ?? this.sessionDate,
      roomName: roomName ?? this.roomName,
      sessionState: sessionState ?? this.sessionState,
      totalStudents: totalStudents ?? this.totalStudents,
      attendedCount: attendedCount ?? this.attendedCount,
      absentCount: absentCount ?? this.absentCount,
      lateCount: lateCount ?? this.lateCount,
      excusedCount: excusedCount ?? this.excusedCount,
      pendingExceptionsCount: pendingExceptionsCount ?? this.pendingExceptionsCount,
      closedAt: closedAt ?? this.closedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      syncRecordId: syncRecordId ?? this.syncRecordId,
    );
  }

  factory LabSession.fromJson(Map<String, dynamic> json) {
    LabSessionState parseState(String? val) {
      switch (val?.toLowerCase()) {
        case 'synced':
          return LabSessionState.synced;
        case 'closed':
          return LabSessionState.closed;
        case 'active':
        default:
          return LabSessionState.active;
      }
    }

    return LabSession(
      id: json['id'] as String? ?? '',
      groupId: json['group_id'] as String? ?? '',
      groupName: json['group_name'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      sectionNumber: json['section_number'] as String? ?? '01',
      sessionDate: json['session_date'] != null
          ? DateTime.tryParse(json['session_date'] as String) ?? DateTime.now()
          : DateTime.now(),
      roomName: json['room_name'] as String? ?? 'معمل الحاسوب 1',
      sessionState: parseState(json['session_state'] as String?),
      totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
      attendedCount: (json['attended_count'] as num?)?.toInt() ?? 0,
      absentCount: (json['absent_count'] as num?)?.toInt() ?? 0,
      lateCount: (json['late_count'] as num?)?.toInt() ?? 0,
      excusedCount: (json['excused_count'] as num?)?.toInt() ?? 0,
      pendingExceptionsCount: (json['pending_exceptions_count'] as num?)?.toInt() ?? 0,
      closedAt: json['closed_at'] != null ? DateTime.tryParse(json['closed_at'] as String) : null,
      syncedAt: json['synced_at'] != null ? DateTime.tryParse(json['synced_at'] as String) : null,
      syncRecordId: json['sync_record_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'group_name': groupName,
      'course_code': courseCode,
      'course_name': courseName,
      'section_number': sectionNumber,
      'session_date': sessionDate.toIso8601String(),
      'room_name': roomName,
      'session_state': sessionState.name,
      'total_students': totalStudents,
      'attended_count': attendedCount,
      'absent_count': absentCount,
      'late_count': lateCount,
      'excused_count': excusedCount,
      'pending_exceptions_count': pendingExceptionsCount,
      'closed_at': closedAt?.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'sync_record_id': syncRecordId,
    };
  }
}
