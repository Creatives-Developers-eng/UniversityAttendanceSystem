import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/authentication/user_session.dart';
import 'package:mobile_app/core/storage/secure_storage_service.dart';
import 'package:mobile_app/core/storage/storage_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureStorageService Tests', () {
    late SecureStorageService secureStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      secureStorage = SecureStorageService(
        storage: const FlutterSecureStorage(),
      );
    });

    test('Writes, reads, and deletes generic values securely', () async {
      await secureStorage.write('custom_key', 'custom_value');
      expect(await secureStorage.read('custom_key'), 'custom_value');
      expect(await secureStorage.containsKey('custom_key'), isTrue);

      await secureStorage.delete('custom_key');
      expect(await secureStorage.read('custom_key'), isNull);
      expect(await secureStorage.containsKey('custom_key'), isFalse);
    });

    test('Saves, retrieves, and clears authentication tokens', () async {
      const access = 'jwt.access.token.123';
      const refresh = 'jwt.refresh.token.456';

      await secureStorage.saveTokens(
        accessToken: access,
        refreshToken: refresh,
      );

      expect(await secureStorage.getAccessToken(), access);
      expect(await secureStorage.getRefreshToken(), refresh);

      await secureStorage.clearTokens();

      expect(await secureStorage.getAccessToken(), isNull);
      expect(await secureStorage.getRefreshToken(), isNull);
    });

    test('Saves and retrieves device credentials', () async {
      await secureStorage.saveDeviceCredentials(
        deviceId: 'dev-uuid-999',
        deviceIdentifier: 'android-hw-serial',
        deviceFingerprint: 'sha256-fingerprint-val',
        deviceState: 'Bound',
      );

      expect(await secureStorage.getDeviceId(), 'dev-uuid-999');
      expect(await secureStorage.getDeviceIdentifier(), 'android-hw-serial');
      expect(await secureStorage.getDeviceFingerprint(), 'sha256-fingerprint-val');
      expect(await secureStorage.getDeviceState(), 'Bound');
    });

    test('Saves, parses, and clears complete UserSession object', () async {
      const session = UserSession(
        userId: 'usr-100',
        username: 'student.ali',
        fullName: 'علي محمد',
        role: UserRole.student,
        deviceState: DeviceState.bound,
        deviceId: 'dev-999',
        accessToken: 'acc-token-xyz',
        refreshToken: 'ref-token-xyz',
      );

      await secureStorage.saveUserSession(session);

      final retrieved = await secureStorage.getUserSession();
      expect(retrieved, isNotNull);
      expect(retrieved!.userId, 'usr-100');
      expect(retrieved.username, 'student.ali');
      expect(retrieved.fullName, 'علي محمد');
      expect(retrieved.role, UserRole.student);
      expect(retrieved.deviceState, DeviceState.bound);

      // Verify tokens synced
      expect(await secureStorage.getAccessToken(), 'acc-token-xyz');

      await secureStorage.clearSession();
      expect(await secureStorage.getUserSession(), isNull);
      expect(await secureStorage.getAccessToken(), isNull);
    });

    test('deleteAll removes all stored keys', () async {
      await secureStorage.write(StorageKeys.accessToken, 'token');
      await secureStorage.write(StorageKeys.deviceId, 'device');

      await secureStorage.deleteAll();

      expect(await secureStorage.getAccessToken(), isNull);
      expect(await secureStorage.getDeviceId(), isNull);
    });
  });
}
