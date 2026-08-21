import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/sync/sync_payload_dto.dart';
import 'package:mobile_app/core/sync/sync_queue_interface.dart';

void main() {
  group('ISyncQueue & InMemorySyncQueue Unit Tests', () {
    late InMemorySyncQueue queue;

    setUp(() {
      queue = InMemorySyncQueue();
    });

    tearDown(() {
      queue.dispose();
    });

    test('Queue starts empty with idle status', () async {
      expect(await queue.getQueueSize(), equals(0));
      expect(await queue.hasPendingPayloads(), isFalse);
      expect(await queue.peek(), isNull);
      expect(await queue.dequeue(), isNull);
      expect(queue.currentStatus, equals(SyncStatus.idle));
    });

    test('enqueue adds payloads in FIFO order', () async {
      final payload1 = SyncPayloadDto.create(
        sessionId: 'ses-1',
        delegateId: 'del-1',
        attendanceList: const [],
      );
      final payload2 = SyncPayloadDto.create(
        sessionId: 'ses-2',
        delegateId: 'del-1',
        attendanceList: const [],
      );

      await queue.enqueue(payload1);
      await queue.enqueue(payload2);

      expect(await queue.getQueueSize(), equals(2));
      expect(await queue.hasPendingPayloads(), isTrue);

      final peeked = await queue.peek();
      expect(peeked?.sessionId, equals('ses-1'));

      final all = await queue.getAllQueued();
      expect(all.length, equals(2));
      expect(all.first.sessionId, equals('ses-1'));
      expect(all.last.sessionId, equals('ses-2'));

      final dequeued1 = await queue.dequeue();
      expect(dequeued1?.sessionId, equals('ses-1'));
      expect(await queue.getQueueSize(), equals(1));

      final dequeued2 = await queue.dequeue();
      expect(dequeued2?.sessionId, equals('ses-2'));
      expect(await queue.getQueueSize(), equals(0));
    });

    test('processNext transitions through status states on success', () async {
      final payload = SyncPayloadDto.create(
        sessionId: 'ses-success-1',
        delegateId: 'del-1',
        attendanceList: const [],
      );

      await queue.enqueue(payload);

      final emittedStatuses = <SyncStatus>[];
      final sub = queue.syncStatusStream.listen(emittedStatuses.add);

      final result = await queue.processNext(
        uploader: (p) async {
          return SyncResponseDto(
            syncRecordId: 'sync-rec-888',
            sessionId: p.sessionId,
            syncState: 'Success',
            processedCount: 0,
            syncedAt: DateTime.now(),
          );
        },
      );

      await Future.delayed(const Duration(milliseconds: 10));

      expect(result.syncRecordId, equals('sync-rec-888'));
      expect(result.isSuccess, isTrue);
      expect(await queue.getQueueSize(), equals(0));

      expect(emittedStatuses, contains(SyncStatus.preparing));
      expect(emittedStatuses, contains(SyncStatus.syncing));
      expect(emittedStatuses, contains(SyncStatus.success));

      await sub.cancel();
    });

    test('processNext updates item and emits failed status on network failure', () async {
      final payload = SyncPayloadDto.create(
        sessionId: 'ses-fail-1',
        delegateId: 'del-1',
        attendanceList: const [],
      );

      await queue.enqueue(payload);

      final emittedStatuses = <SyncStatus>[];
      final sub = queue.syncStatusStream.listen(emittedStatuses.add);

      expect(
        () async => await queue.processNext(
          uploader: (_) async => throw Exception('Connection Timeout'),
        ),
        throwsA(isA<Exception>()),
      );

      await Future.delayed(const Duration(milliseconds: 10));

      expect(await queue.getQueueSize(), equals(1));
      expect(queue.currentStatus, equals(SyncStatus.failed));
      expect(emittedStatuses, contains(SyncStatus.failed));

      await sub.cancel();
    });

    test('processAll processes all queued payloads sequentially', () async {
      final payload1 = SyncPayloadDto.create(
        sessionId: 'ses-1',
        delegateId: 'del-1',
        attendanceList: const [],
      );
      final payload2 = SyncPayloadDto.create(
        sessionId: 'ses-2',
        delegateId: 'del-1',
        attendanceList: const [],
      );

      await queue.enqueue(payload1);
      await queue.enqueue(payload2);

      final results = await queue.processAll(
        uploader: (p) async {
          return SyncResponseDto(
            syncRecordId: 'sync-${p.sessionId}',
            sessionId: p.sessionId,
            syncState: 'Success',
            processedCount: 0,
            syncedAt: DateTime.now(),
          );
        },
      );

      expect(results.length, equals(2));
      expect(results[0].syncRecordId, equals('sync-ses-1'));
      expect(results[1].syncRecordId, equals('sync-ses-2'));
      expect(await queue.getQueueSize(), equals(0));
    });

    test('clearQueue empties all pending items and resets status', () async {
      await queue.enqueue(SyncPayloadDto.create(
        sessionId: 'ses-1',
        delegateId: 'del-1',
        attendanceList: const [],
      ));

      await queue.clearQueue();

      expect(await queue.getQueueSize(), equals(0));
      expect(await queue.hasPendingPayloads(), isFalse);
      expect(queue.currentStatus, equals(SyncStatus.idle));
    });
  });
}
