import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/authentication/activation_service.dart';
import 'package:mobile_app/authentication/device_activation_dto.dart';
import 'package:mobile_app/authentication/user_session.dart';

void main() {
  group('ActivationService Logic Tests', () {
    late ActivationService service;

    setUp(() {
      service = ActivationService();
    });

    test('Rejects invalid DTO with empty fields', () async {
      const invalidDto = DeviceActivationDto(
        code: '',
        deviceIdentifier: '',
        deviceFingerprint: '',
      );

      final result = await service.activateDevice(invalidDto);
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('رمز تفعيل صالح'));
      expect(result.updatedState, DeviceState.unregistered);
    });

    test('Rejects activation code that is too short', () async {
      const shortCodeDto = DeviceActivationDto(
        code: '12',
        deviceIdentifier: 'dev-1',
        deviceFingerprint: 'fp-1',
      );

      final result = await service.activateDevice(shortCodeDto);
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('4 خانات'));
    });

    test('Performs successful activation and returns Bound state', () async {
      const validDto = DeviceActivationDto(
        code: 'ACT-9821',
        deviceIdentifier: 'android-hw-12345',
        deviceFingerprint: 'sha256-device-hash',
      );

      final result = await service.activateDevice(validDto);
      expect(result.isSuccess, isTrue);
      expect(result.updatedState, DeviceState.bound);
      expect(result.response?.deviceId, isNotEmpty);
      expect(result.response?.deviceState, 'Bound');
    });
  });
}
