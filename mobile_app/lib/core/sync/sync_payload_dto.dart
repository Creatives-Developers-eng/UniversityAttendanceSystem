import 'dart:convert';

/// حالات المزامنة الرسمية للواجهات والخدمات (Synchronization States)
/// متوافقة مع القسم 7 في SYSTEM_STATES.md
enum SyncStatus {
  /// خامل / بانتظار البدء
  idle,

  /// قيد تجهيز وتجميع وتشفير حزمة سجلات الحضور
  preparing,

  /// قيد النقل إلى الخادم المركزي NestJS عبر الشبكة
  syncing,

  /// مكتملة بنجاح واستلام معرف الحفظ المركزي
  success,

  /// فاشلة بسبب انقطاع الاتصال أو رفض الخادم
  failed;

  /// المسمى العربي لحالة المزامنة
  String get arabicName {
    switch (this) {
      case SyncStatus.idle:
        return 'خامل';
      case SyncStatus.preparing:
        return 'قيد تجهيز الحزمة';
      case SyncStatus.syncing:
        return 'قيد النقل إلى الخادم';
      case SyncStatus.success:
        return 'مكتملة بنجاح';
      case SyncStatus.failed:
        return 'فاشلة';
    }
  }

  /// هل الحالة تدل على انشغال النظام بعملية مزامنة
  bool get isInProgress => this == SyncStatus.preparing || this == SyncStatus.syncing;

  /// هل الحالة نهائية ناجحة
  bool get isSuccess => this == SyncStatus.success;

  /// هل الحالة فاشلة
  bool get isFailed => this == SyncStatus.failed;
}

/// كائن يمثل سجل حضور طالب مفرد داخل دفعة المزامنة
/// متوافق مع بنية `attendance_list` في مسار `POST /api/v1/sync`
class SyncAttendanceItemDto {
  final String studentId;
  final String requestId;
  final String attendanceState; // Present | Late | Excused
  final String attendanceMethod; // QR | Biometric | Manual
  final DateTime markedAt;

  const SyncAttendanceItemDto({
    required this.studentId,
    required this.requestId,
    required this.attendanceState,
    required this.attendanceMethod,
    required this.markedAt,
  });

  /// إنشاء كائن من JSON
  factory SyncAttendanceItemDto.fromJson(Map<String, dynamic> json) {
    return SyncAttendanceItemDto(
      studentId: json['student_id'] as String? ?? '',
      requestId: json['request_id'] as String? ?? '',
      attendanceState: json['attendance_state'] as String? ?? 'Present',
      attendanceMethod: json['attendance_method'] as String? ?? 'QR',
      markedAt: json['marked_at'] != null
          ? DateTime.tryParse(json['marked_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// تحويل الكائن إلى خريطة JSON
  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'request_id': requestId,
      'attendance_state': attendanceState,
      'attendance_method': attendanceMethod,
      'marked_at': markedAt.toIso8601String(),
    };
  }

  SyncAttendanceItemDto copyWith({
    String? studentId,
    String? requestId,
    String? attendanceState,
    String? attendanceMethod,
    DateTime? markedAt,
  }) {
    return SyncAttendanceItemDto(
      studentId: studentId ?? this.studentId,
      requestId: requestId ?? this.requestId,
      attendanceState: attendanceState ?? this.attendanceState,
      attendanceMethod: attendanceMethod ?? this.attendanceMethod,
      markedAt: markedAt ?? this.markedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncAttendanceItemDto &&
          runtimeType == other.runtimeType &&
          studentId == other.studentId &&
          requestId == other.requestId &&
          attendanceState == other.attendanceState &&
          attendanceMethod == other.attendanceMethod &&
          markedAt == other.markedAt;

  @override
  int get hashCode =>
      studentId.hashCode ^
      requestId.hashCode ^
      attendanceState.hashCode ^
      attendanceMethod.hashCode ^
      markedAt.hashCode;
}

/// كائن حمولة دفعة المزامنة الموجهة للخادم المركزي (Sync Payload DTO)
/// يطابق بدقة متناهية عقد `POST /api/v1/sync` في `API_SPECIFICATION.md`
class SyncPayloadDto {
  final String sessionId;
  final String delegateId;
  final int recordsCount;
  final List<SyncAttendanceItemDto> attendanceList;

  const SyncPayloadDto({
    required this.sessionId,
    required this.delegateId,
    required this.recordsCount,
    required this.attendanceList,
  });

  /// إنشاء كائن دفعة تلقائياً مع ضبط عدد السجلات بناءً على القائمة
  factory SyncPayloadDto.create({
    required String sessionId,
    required String delegateId,
    required List<SyncAttendanceItemDto> attendanceList,
  }) {
    return SyncPayloadDto(
      sessionId: sessionId,
      delegateId: delegateId,
      recordsCount: attendanceList.length,
      attendanceList: attendanceList,
    );
  }

  /// إنشاء الكائن من JSON
  factory SyncPayloadDto.fromJson(Map<String, dynamic> json) {
    final list = (json['attendance_list'] as List<dynamic>?)
            ?.map((e) => SyncAttendanceItemDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    return SyncPayloadDto(
      sessionId: json['session_id'] as String? ?? '',
      delegateId: json['delegate_id'] as String? ?? '',
      recordsCount: (json['records_count'] as num?)?.toInt() ?? list.length,
      attendanceList: list,
    );
  }

  /// إنشاء الكائن من سلسلة JSON
  factory SyncPayloadDto.fromJsonString(String jsonString) {
    return SyncPayloadDto.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  /// تحويل الكائن إلى خريطة JSON
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'delegate_id': delegateId,
      'records_count': recordsCount,
      'attendance_list': attendanceList.map((e) => e.toJson()).toList(),
    };
  }

  /// تحويل الكائن إلى سلسلة JSON مشفرة
  String toJsonString() => jsonEncode(toJson());

  SyncPayloadDto copyWith({
    String? sessionId,
    String? delegateId,
    int? recordsCount,
    List<SyncAttendanceItemDto>? attendanceList,
  }) {
    return SyncPayloadDto(
      sessionId: sessionId ?? this.sessionId,
      delegateId: delegateId ?? this.delegateId,
      recordsCount: recordsCount ?? this.recordsCount,
      attendanceList: attendanceList ?? this.attendanceList,
    );
  }
}

/// كائن استجابة المزامنة الوارد من الخادم المركزي
/// يطابق استجابة `POST /api/v1/sync` (201 Created)
class SyncResponseDto {
  final String syncRecordId;
  final String sessionId;
  final String syncState;
  final int processedCount;
  final DateTime syncedAt;
  final String message;

  const SyncResponseDto({
    required this.syncRecordId,
    required this.sessionId,
    required this.syncState,
    required this.processedCount,
    required this.syncedAt,
    this.message = 'Attendance batch synchronized successfully',
  });

  /// إنشاء كائن من خريطة JSON للاستجابة
  factory SyncResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return SyncResponseDto(
      syncRecordId: data['sync_record_id'] as String? ?? '',
      sessionId: data['session_id'] as String? ?? '',
      syncState: data['sync_state'] as String? ?? 'Success',
      processedCount: (data['processed_count'] as num?)?.toInt() ?? 0,
      syncedAt: data['synced_at'] != null
          ? DateTime.tryParse(data['synced_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      message: json['message'] as String? ?? 'Attendance batch synchronized successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'sync_record_id': syncRecordId,
        'session_id': sessionId,
        'sync_state': syncState,
        'processed_count': processedCount,
        'synced_at': syncedAt.toIso8601String(),
      }
    };
  }

  bool get isSuccess => syncState.toUpperCase() == 'SUCCESS';
}

/// غلاف عنصر طابور المزامنة المحلي لتتبع المحاولات والحالة الداخلية
class SyncQueueItem {
  final String id;
  final SyncPayloadDto payload;
  final SyncStatus status;
  final int retryCount;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final String? errorMessage;

  const SyncQueueItem({
    required this.id,
    required this.payload,
    this.status = SyncStatus.idle,
    this.retryCount = 0,
    required this.createdAt,
    this.lastAttemptAt,
    this.errorMessage,
  });

  SyncQueueItem copyWith({
    String? id,
    SyncPayloadDto? payload,
    SyncStatus? status,
    int? retryCount,
    DateTime? createdAt,
    DateTime? lastAttemptAt,
    String? errorMessage,
  }) {
    return SyncQueueItem(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payload': payload.toJson(),
      'status': status.name,
      'retry_count': retryCount,
      'created_at': createdAt.toIso8601String(),
      'last_attempt_at': lastAttemptAt?.toIso8601String(),
      'error_message': errorMessage,
    };
  }

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) {
    SyncStatus parseStatus(String? val) {
      return SyncStatus.values.firstWhere(
        (e) => e.name == val,
        orElse: () => SyncStatus.idle,
      );
    }

    return SyncQueueItem(
      id: json['id'] as String? ?? '',
      payload: SyncPayloadDto.fromJson(json['payload'] as Map<String, dynamic>),
      status: parseStatus(json['status'] as String?),
      retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      lastAttemptAt: json['last_attempt_at'] != null
          ? DateTime.tryParse(json['last_attempt_at'] as String)
          : null,
      errorMessage: json['error_message'] as String?,
    );
  }
}
