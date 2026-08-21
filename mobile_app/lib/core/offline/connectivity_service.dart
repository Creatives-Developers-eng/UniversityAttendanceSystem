import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// خدمة فحص وتتبع حالة الاتصال بالشبكة والإنترنت
/// تعتمد على حزمة connectivity_plus وتوفر بثاً تفاعلياً للتغيرات
class ConnectivityService {
  final Connectivity _connectivity;
  StreamController<bool>? _controller;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// التحقق الفوري مما إذا كان الجهاز متصلاً بالإنترنت (Wi-Fi, Cellular, Ethernet, VPN)
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isResultConnected(result);
    } catch (_) {
      return false;
    }
  }

  /// جلب نوع الاتصال الحالي بالتفصيل
  Future<ConnectivityResult> checkConnectivity() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (_) {
      return ConnectivityResult.none;
    }
  }

  /// بث تفاعلي يرسل `true` عند توفر الاتصال و `false` عند انقطاعه
  Stream<bool> get isConnectedStream {
    _controller ??= StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _controller!.stream;
  }

  void _startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final connected = _isResultConnected(result);
      if (_controller != null && !_controller!.isClosed) {
        _controller!.add(connected);
      }
    });
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// تحويل نتيجة ConnectivityResult إلى قيمة منطقية تدل على توفر الاتصال
  bool _isResultConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  /// إغلاق وتحرير الموارد
  void dispose() {
    _stopListening();
    _controller?.close();
    _controller = null;
  }
}
