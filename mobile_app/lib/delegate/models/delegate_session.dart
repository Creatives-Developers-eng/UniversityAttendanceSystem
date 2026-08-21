import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import 'delegate_section.dart';

/// حالات جلسة الحضور الرسمية المعتمدة في SYSTEM_STATES.md
enum DelegateSessionState {
  created,
  opened,
  active,
  closing,
  closed,
  synced,
}

/// نموذج يمثل جلسة الحضور المحلية التي يديرها المندوب (Delegate Session)
class DelegateSession {
  final String id;
  final String sectionId;
  final String courseCode;
  final String courseName;
  final String sectionNumber;
  final DelegateSectionType sectionType;
  final String teacherName;
  final String delegateId;
  final String delegateName;
  final DelegateSessionState sessionState;
  final DateTime openedAt;
  final DateTime? closedAt;
  final DateTime? syncedAt;
  final int totalExpectedStudents;
  final int attendedCount;
  final String roomName;
  final bool isOfflineMode;
  final String? syncRecordId;

  const DelegateSession({
    required this.id,
    required this.sectionId,
    required this.courseCode,
    required this.courseName,
    required this.sectionNumber,
    required this.sectionType,
    required this.teacherName,
    required this.delegateId,
    required this.delegateName,
    required this.sessionState,
    required this.openedAt,
    this.closedAt,
    this.syncedAt,
    required this.totalExpectedStudents,
    this.attendedCount = 0,
    this.roomName = 'القاعة الرئيسية',
    this.isOfflineMode = true,
    this.syncRecordId,
  });

  bool get isActive => sessionState == DelegateSessionState.active || sessionState == DelegateSessionState.opened;
  bool get isClosed => sessionState == DelegateSessionState.closed;
  bool get isSynced => sessionState == DelegateSessionState.synced;
  bool get isClosing => sessionState == DelegateSessionState.closing;

  double get attendancePercentage => totalExpectedStudents > 0
      ? ((attendedCount / totalExpectedStudents) * 100.0).clamp(0.0, 100.0)
      : 0.0;

  String get stateArabic {
    switch (sessionState) {
      case DelegateSessionState.created:
        return 'مجدولة';
      case DelegateSessionState.opened:
        return 'تم الفتح';
      case DelegateSessionState.active:
        return 'نشطة ومباشرة';
      case DelegateSessionState.closing:
        return 'قيد الإغلاق';
      case DelegateSessionState.closed:
        return 'مغلقة ومحفوظة';
      case DelegateSessionState.synced:
        return 'تمت المزامنة';
    }
  }

  Color get stateColor {
    switch (sessionState) {
      case DelegateSessionState.created:
        return AppColors.textSecondary;
      case DelegateSessionState.opened:
        return AppColors.primary;
      case DelegateSessionState.active:
        return AppColors.success;
      case DelegateSessionState.closing:
        return AppColors.warning;
      case DelegateSessionState.closed:
        return const Color(0xFF6366F1); // Indigo
      case DelegateSessionState.synced:
        return AppColors.success;
    }
  }

  DelegateSession copyWith({
    String? id,
    String? sectionId,
    String? courseCode,
    String? courseName,
    String? sectionNumber,
    DelegateSectionType? sectionType,
    String? teacherName,
    String? delegateId,
    String? delegateName,
    DelegateSessionState? sessionState,
    DateTime? openedAt,
    DateTime? closedAt,
    DateTime? syncedAt,
    int? totalExpectedStudents,
    int? attendedCount,
    String? roomName,
    bool? isOfflineMode,
    String? syncRecordId,
  }) {
    return DelegateSession(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      sectionNumber: sectionNumber ?? this.sectionNumber,
      sectionType: sectionType ?? this.sectionType,
      teacherName: teacherName ?? this.teacherName,
      delegateId: delegateId ?? this.delegateId,
      delegateName: delegateName ?? this.delegateName,
      sessionState: sessionState ?? this.sessionState,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      totalExpectedStudents: totalExpectedStudents ?? this.totalExpectedStudents,
      attendedCount: attendedCount ?? this.attendedCount,
      roomName: roomName ?? this.roomName,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      syncRecordId: syncRecordId ?? this.syncRecordId,
    );
  }

  factory DelegateSession.fromJson(Map<String, dynamic> json) {
    DelegateSessionState parseState(String? val) {
      switch (val?.toLowerCase()) {
        case 'created':
          return DelegateSessionState.created;
        case 'opened':
          return DelegateSessionState.opened;
        case 'active':
          return DelegateSessionState.active;
        case 'closing':
          return DelegateSessionState.closing;
        case 'closed':
          return DelegateSessionState.closed;
        case 'synced':
          return DelegateSessionState.synced;
        default:
          return DelegateSessionState.active;
      }
    }

    return DelegateSession(
      id: json['id'] as String? ?? '',
      sectionId: json['section_id'] as String? ?? '',
      courseCode: json['course_code'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      sectionNumber: json['section_number'] as String? ?? '01',
      sectionType: (json['section_type'] as String?)?.toUpperCase() == 'THEORETICAL'
          ? DelegateSectionType.theoretical
          : DelegateSectionType.practical,
      teacherName: json['teacher_name'] as String? ?? '',
      delegateId: json['delegate_id'] as String? ?? '',
      delegateName: json['delegate_name'] as String? ?? 'مندوب الدفعة',
      sessionState: parseState(json['session_state'] as String?),
      openedAt: json['opened_at'] != null ? DateTime.parse(json['opened_at'] as String) : DateTime.now(),
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null,
      syncedAt: json['synced_at'] != null ? DateTime.parse(json['synced_at'] as String) : null,
      totalExpectedStudents: (json['total_expected_students'] as num?)?.toInt() ?? 0,
      attendedCount: (json['attended_count'] as num?)?.toInt() ?? 0,
      roomName: json['room_name'] as String? ?? 'القاعة الرئيسية',
      isOfflineMode: json['is_offline_mode'] as bool? ?? true,
      syncRecordId: json['sync_record_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section_id': sectionId,
      'course_code': courseCode,
      'course_name': courseName,
      'section_number': sectionNumber,
      'section_type': sectionType == DelegateSectionType.practical ? 'PRACTICAL' : 'THEORETICAL',
      'teacher_name': teacherName,
      'delegate_id': delegateId,
      'delegate_name': delegateName,
      'session_state': sessionState.name,
      'opened_at': openedAt.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'total_expected_students': totalExpectedStudents,
      'attended_count': attendedCount,
      'room_name': roomName,
      'is_offline_mode': isOfflineMode,
      'sync_record_id': syncRecordId,
    };
  }
}
