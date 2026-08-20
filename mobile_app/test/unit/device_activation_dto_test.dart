import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/authentication/device_activation_dto.dart';

void main() {
  group('DeviceActivationDto & Response Tests', () {
    test('DeviceActivationDto serializes and deserializes correctly', () {
      const dto = DeviceActivationDto(
        code: 'ACT-12345',
        deviceIdentifier: 'device-uuid-abc-123',
        deviceFingerprint: 'sha256-fingerprint-hex',
      );

      expect(dto.isValid(), isTrue);

      final json = dto.toJson();
      expect(json['code'], 'ACT-12345');
      expect(json['device_identifier'], 'device-uuid-abc-123');
      expect(json['device_fingerprint'], 'sha256-fingerprint-hex');

      final fromJson = DeviceActivationDto.fromJson(json);
      expect(fromJson.code, dto.code);
      expect(fromJson.deviceIdentifier, dto.deviceIdentifier);
      expect(fromJson.deviceFingerprint, dto.deviceFingerprint);
    });

    test('DeviceActivationDto invalidates empty or whitespace data', () {
      const emptyCodeDto = DeviceActivationDto(
        code: '   ',
        deviceIdentifier: 'id-1',
        deviceFingerprint: 'fp-1',
      );
      expect(emptyCodeDto.isValid(), isFalse);

      const emptyIdDto = DeviceActivationDto(
        code: 'ACT-123',
        deviceIdentifier: '',
        deviceFingerprint: 'fp-1',
      );
      expect(emptyIdDto.isValid(), isFalse);
    });

    test('DeviceActivationResponseDto parses JSON from API properly', () {
      final json = {
        'device_id': '8f6b2f7a-1122-3344-5566-778899aabbcc',
        'device_state': 'Bound',
        'bound_at': '2026-08-21T02:00:00.000Z',
      };

      final response = DeviceActivationResponseDto.fromJson(json);
      expect(response.deviceId, '8f6b2f7a-1122-3344-5566-778899aabbcc');
      expect(response.deviceState, 'Bound');
      expect(response.boundAt, '2026-08-21T02:00:00.000Z');

      final backToJson = response.toJson();
      expect(backToJson['device_id'], response.deviceId);
      expect(backToJson['device_state'], 'Bound');
    });
  });
}
