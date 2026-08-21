import 'dart:async';
import 'sync_payload_dto.dart';

/// واجهة طابور المزامنة المجردة (Sync Queue Interface Boundary)
/// تعزل منطق الواجهات والخدمات عن تفاصيل بروتوكول المزامنة المركزي
abstract class ISyncQueue {
  /// إضافة دفعة حضور جديدة إلى طابور المزامنة
  Future<void> enqueue(SyncPayloadDto payload);

  /// معاينة الدفعة الأولى في الطابور دون سحبها
  Future<SyncPayloadDto?> peek();

  /// سحب الدفعة الأولى من الطابور
  Future<SyncPayloadDto?> dequeue();

  /// استرجاع عدد الدفعات المعلقة في الطابور
  Future<int> getQueueSize();

  /// استرجاع كافة الدفعات المعلقة في الطابور
  Future<List<SyncPayloadDto>> getAllQueued();

  /// التحقق مما إذا كان هناك دفعات معلقة في الطابور
  Future<bool> hasPendingPayloads();

  /// معالجة ورفع الدفعة التالية في الطابور باستخدام دالة الرفع المحددة
  Future<SyncResponseDto> processNext({
    required Future<SyncResponseDto> Function(SyncPayloadDto payload) uploader,
  });

  /// معالجة ورفع كافة الدفعات المعلقة في الطابور تباعاً
  Future<List<SyncResponseDto>> processAll({
    required Future<SyncResponseDto> Function(SyncPayloadDto payload) uploader,
  });

  /// تفريغ طابور المزامنة بالكامل
  Future<void> clearQueue();

  /// بث تفاعلي يرسل تحديثات حالة المزامنة اللحظية
  Stream<SyncStatus> get syncStatusStream;

  /// الحالة اللحظية الحالية لطابور المزامنة
  SyncStatus get currentStatus;

  /// إغلاق وتحرير موارد الطابور
  void dispose();
}

/// تطبيق عملي مرجعي لطابور المزامنة في الذاكرة (In-Memory Reference Implementation)
/// يوفر جاهزية كاملة للاستخدام في التطبيق والاختبارات الموجهة
class InMemorySyncQueue implements ISyncQueue {
  final List<SyncQueueItem> _queue = [];
  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();
  SyncStatus _currentStatus = SyncStatus.idle;

  InMemorySyncQueue({List<SyncPayloadDto>? initialPayloads}) {
    if (initialPayloads != null) {
      for (final p in initialPayloads) {
        _queue.add(SyncQueueItem(
          id: 'q-item-${DateTime.now().microsecondsSinceEpoch}-${_queue.length}',
          payload: p,
          createdAt: DateTime.now(),
        ));
      }
    }
  }

  @override
  SyncStatus get currentStatus => _currentStatus;

  @override
  Stream<SyncStatus> get syncStatusStream => _statusController.stream;

  void _setStatus(SyncStatus status) {
    _currentStatus = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  @override
  Future<void> enqueue(SyncPayloadDto payload) async {
    final item = SyncQueueItem(
      id: 'q-item-${DateTime.now().microsecondsSinceEpoch}-${_queue.length}',
      payload: payload,
      status: SyncStatus.idle,
      createdAt: DateTime.now(),
    );
    _queue.add(item);
  }

  @override
  Future<SyncPayloadDto?> peek() async {
    if (_queue.isEmpty) return null;
    return _queue.first.payload;
  }

  @override
  Future<SyncPayloadDto?> dequeue() async {
    if (_queue.isEmpty) return null;
    final item = _queue.removeAt(0);
    return item.payload;
  }

  @override
  Future<int> getQueueSize() async {
    return _queue.length;
  }

  @override
  Future<List<SyncPayloadDto>> getAllQueued() async {
    return _queue.map((item) => item.payload).toList();
  }

  @override
  Future<bool> hasPendingPayloads() async {
    return _queue.isNotEmpty;
  }

  @override
  Future<SyncResponseDto> processNext({
    required Future<SyncResponseDto> Function(SyncPayloadDto payload) uploader,
  }) async {
    if (_queue.isEmpty) {
      throw StateError('طابور المزامنة فارغ');
    }

    final item = _queue.first;
    _setStatus(SyncStatus.preparing);

    try {
      _setStatus(SyncStatus.syncing);
      final response = await uploader(item.payload);

      if (response.isSuccess) {
        _queue.removeAt(0);
        _setStatus(SyncStatus.success);
        _setStatus(SyncStatus.idle);
        return response;
      } else {
        _queue[0] = item.copyWith(
          status: SyncStatus.failed,
          retryCount: item.retryCount + 1,
          lastAttemptAt: DateTime.now(),
          errorMessage: response.message,
        );
        _setStatus(SyncStatus.failed);
        throw Exception('فشلت المزامنة: ${response.message}');
      }
    } catch (e) {
      if (_queue.isNotEmpty) {
        _queue[0] = item.copyWith(
          status: SyncStatus.failed,
          retryCount: item.retryCount + 1,
          lastAttemptAt: DateTime.now(),
          errorMessage: e.toString(),
        );
      }
      _setStatus(SyncStatus.failed);
      rethrow;
    }
  }

  @override
  Future<List<SyncResponseDto>> processAll({
    required Future<SyncResponseDto> Function(SyncPayloadDto payload) uploader,
  }) async {
    final responses = <SyncResponseDto>[];

    while (_queue.isNotEmpty) {
      final response = await processNext(uploader: uploader);
      responses.add(response);
    }

    _setStatus(SyncStatus.idle);
    return responses;
  }

  @override
  Future<void> clearQueue() async {
    _queue.clear();
    _setStatus(SyncStatus.idle);
  }

  @override
  void dispose() {
    _statusController.close();
  }
}
