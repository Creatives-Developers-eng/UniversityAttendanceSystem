import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/storage/storage_keys.dart';

void main() {
  group('StorageKeys Verification', () {
    test('All storage keys are non-empty and uniquely distinct', () {
      final keys = [
        StorageKeys.accessToken,
        StorageKeys.refreshToken,
        StorageKeys.deviceId,
        StorageKeys.deviceIdentifier,
        StorageKeys.deviceFingerprint,
        StorageKeys.deviceState,
        StorageKeys.userSession,
        StorageKeys.themeMode,
        StorageKeys.languageCode,
        StorageKeys.isFirstLaunch,
        StorageKeys.lastSyncTimestamp,
        StorageKeys.offlineCacheVersion,
      ];

      for (final key in keys) {
        expect(key.trim(), isNotEmpty);
      }

      final uniqueKeys = keys.toSet();
      expect(uniqueKeys.length, keys.length, reason: 'Duplicate storage key found');
    });
  });
}
