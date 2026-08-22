import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/offline/connectivity_service.dart';

class FakeConnectivity implements Connectivity {
  ConnectivityResult currentResult = ConnectivityResult.wifi;
  final StreamController<ConnectivityResult> _controller =
      StreamController<ConnectivityResult>.broadcast();

  void emit(ConnectivityResult result) {
    currentResult = result;
    _controller.add(result);
  }

  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return currentResult;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => _controller.stream;

  void close() {
    _controller.close();
  }
}

void main() {
  group('ConnectivityService Unit Tests', () {
    late FakeConnectivity fakeConnectivity;
    late ConnectivityService service;

    setUp(() {
      fakeConnectivity = FakeConnectivity();
      service = ConnectivityService(connectivity: fakeConnectivity);
    });

    tearDown(() {
      service.dispose();
      fakeConnectivity.close();
    });

    test('isConnected returns true when connected to Wi-Fi', () async {
      fakeConnectivity.currentResult = ConnectivityResult.wifi;
      final connected = await service.isConnected;
      expect(connected, isTrue);
    });

    test('isConnected returns true when connected to Mobile Data', () async {
      fakeConnectivity.currentResult = ConnectivityResult.mobile;
      final connected = await service.isConnected;
      expect(connected, isTrue);
    });

    test('isConnected returns true when connected to Ethernet', () async {
      fakeConnectivity.currentResult = ConnectivityResult.ethernet;
      final connected = await service.isConnected;
      expect(connected, isTrue);
    });

    test('isConnected returns true when connected to VPN', () async {
      fakeConnectivity.currentResult = ConnectivityResult.vpn;
      final connected = await service.isConnected;
      expect(connected, isTrue);
    });

    test('isConnected returns false when there is no connection (none)', () async {
      fakeConnectivity.currentResult = ConnectivityResult.none;
      final connected = await service.isConnected;
      expect(connected, isFalse);
    });

    test('checkConnectivity returns raw ConnectivityResult', () async {
      fakeConnectivity.currentResult = ConnectivityResult.wifi;
      expect(await service.checkConnectivity(), equals(ConnectivityResult.wifi));

      fakeConnectivity.currentResult = ConnectivityResult.none;
      expect(await service.checkConnectivity(), equals(ConnectivityResult.none));
    });

    test('isConnectedStream emits true when network connects and false when disconnected', () async {
      final emittedValues = <bool>[];
      final subscription = service.isConnectedStream.listen((status) {
        emittedValues.add(status);
      });

      // Simulate connection transitions
      fakeConnectivity.emit(ConnectivityResult.wifi);
      await Future.delayed(const Duration(milliseconds: 10));

      fakeConnectivity.emit(ConnectivityResult.none);
      await Future.delayed(const Duration(milliseconds: 10));

      fakeConnectivity.emit(ConnectivityResult.mobile);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(emittedValues, equals([true, false, true]));
      await subscription.cancel();
    });
  });
}
