import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/sync/sync_payload_dto.dart';

void main() {
  group('SyncPayloadDto & Models Unit Tests', () {
    test('SyncStatus properties and arabic names', () {
      expect(SyncStatus.idle.arabicName, equals('خامل'));
      expect(SyncStatus.preparing.arabicName, equals('قيد تجهيز الحزمة'));
      expect(SyncStatus.syncing.arabicName, equals('قيد النقل إلى الخادم'));
      expect(SyncStatus.success.arabicName, equals('مكتملة بنجاح'));
      expect(SyncStatus.failed.arabicName, equals('فاشلة'));

      expect(SyncStatus.preparing.isInProgress, isTrue);
      expect(SyncStatus.syncing.isInProgress, isTrue);
      expect(SyncStatus.idle.isInProgress, isFalse);
      expect(SyncStatus.success.isSuccess, isTrue);
      expect(SyncStatus.failed.isFailed, isTrue);
    });

    test('SyncAttendanceItemDto serialization and deserialization', () {
      final now = DateTime(2026, 8, 22, 10, 30, 0);
      final item = SyncAttendanceItemDto(
        studentId: 'std-uuid-1',
        requestId: 'req-uuid-1',
        attendanceState: 'Present',
        attendanceMethod: 'QR',
        markedAt: now,
      );

      final json = item.toJson();
      expect(json['student_id'], equals('std-uuid-1'));
      expect(json['request_id'], equals('req-uuid-1'));
      expect(json['attendance_state'], equals('Present'));
      expect(json['attendance_method'], equals('QR'));
      expect(json['marked_at'], equals(now.toIso8601String()));

      final restored = SyncAttendanceItemDto.fromJson(json);
      expect(restored.studentId, equals('std-uuid-1'));
      expect(restored.requestId, equals('req-uuid-1'));
      expect(restored.attendanceState, equals('Present'));
      expect(restored.attendanceMethod, equals('QR'));
      expect(restored.markedAt, equals(now));
      expect(restored, equals(item));
    });

    test('SyncPayloadDto create and json conversion matches API specification', () {
      final now = DateTime(2026, 8, 22, 10, 30, 0);
      final items = [
        SyncAttendanceItemDto(
          studentId: 'std-1',
          requestId: 'req-1',
          attendanceState: 'Present',
          attendanceMethod: 'QR',
          markedAt: now,
        ),
        SyncAttendanceItemDto(
          studentId: 'std-2',
          requestId: 'req-2',
          attendanceState: 'Late',
          attendanceMethod: 'Biometric',
          markedAt: now,
        ),
      ];

      final payload = SyncPayloadDto.create(
        sessionId: 'ses-uuid-99',
        delegateId: 'del-uuid-55',
        attendanceList: items,
      );

      expect(payload.recordsCount, equals(2));
      expect(payload.sessionId, equals('ses-uuid-99'));
      expect(payload.delegateId, equals('del-uuid-55'));

      final json = payload.toJson();
      expect(json['session_id'], equals('ses-uuid-99'));
      expect(json['delegate_id'], equals('del-uuid-55'));
      expect(json['records_count'], equals(2));
      expect((json['attendance_list'] as List).length, equals(2));

      final jsonString = payload.toJsonString();
      final restored = SyncPayloadDto.fromJsonString(jsonString);

      expect(restored.sessionId, equals('ses-uuid-99'));
      expect(restored.delegateId, equals('del-uuid-55'));
      expect(restored.recordsCount, equals(2));
      expect(restored.attendanceList.length, equals(2));
      expect(restored.attendanceList.first.studentId, equals('std-1'));
      expect(restored.attendanceList.last.attendanceMethod, equals('Biometric'));
    });

    test('SyncResponseDto parsing matches 201 Created format', () {
      final responseMap = {
        'statusCode': 201,
        'message': 'Attendance batch synchronized successfully',
        'data': {
          'sync_record_id': 'sync-rec-1234',
          'session_id': 'ses-uuid-99',
          'sync_state': 'Success',
          'processed_count': 2,
          'synced_at': '2026-08-22T10:35:00.000Z',
        }
      };

      final responseDto = SyncResponseDto.fromJson(responseMap);
      expect(responseDto.syncRecordId, equals('sync-rec-1234'));
      expect(responseDto.sessionId, equals('ses-uuid-99'));
      expect(responseDto.syncState, equals('Success'));
      expect(responseDto.processedCount, equals(2));
      expect(responseDto.isSuccess, isTrue);
      expect(responseDto.message, equals('Attendance batch synchronized successfully'));
    });

    test('SyncQueueItem tracks retry counts and error state', () {
      final now = DateTime(2026, 8, 22, 10, 0, 0);
      final payload = SyncPayloadDto.create(
        sessionId: 'ses-1',
        delegateId: 'del-1',
        attendanceList: const [],
      );

      final queueItem = SyncQueueItem(
        id: 'q-item-1',
        payload: payload,
        status: SyncStatus.idle,
        createdAt: now,
      );

      expect(queueItem.retryCount, equals(0));
      expect(queueItem.status, equals(SyncStatus.idle));

      final updated = queueItem.copyWith(
        status: SyncStatus.failed,
        retryCount: 1,
        lastAttemptAt: DateTime(2026, 8, 22, 10, 5, 0),
        errorMessage: 'Network timeout',
      );

      expect(updated.status, equals(SyncStatus.failed));
      expect(updated.retryCount, equals(1));
      expect(updated.errorMessage, equals('Network timeout'));

      final json = updated.toJson();
      final restored = SyncQueueItem.fromJson(json);
      expect(restored.id, equals('q-item-1'));
      expect(restored.status, equals(SyncStatus.failed));
      expect(restored.retryCount, equals(1));
      expect(restored.errorMessage, equals('Network timeout'));
    });
  });
}
