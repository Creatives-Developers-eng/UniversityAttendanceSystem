import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/storage/local_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalPreferences Tests', () {
    late LocalPreferences localPrefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      localPrefs = await LocalPreferences.create();
    });

    test('ThemeMode defaults to system and persists updates', () async {
      expect(localPrefs.getThemeMode(), 'system');

      await localPrefs.setThemeMode('dark');
      expect(localPrefs.getThemeMode(), 'dark');

      await localPrefs.setThemeMode('light');
      expect(localPrefs.getThemeMode(), 'light');
    });

    test('LanguageCode defaults to ar and persists updates', () async {
      expect(localPrefs.getLanguageCode(), 'ar');

      await localPrefs.setLanguageCode('en');
      expect(localPrefs.getLanguageCode(), 'en');
    });

    test('isFirstLaunch defaults to true and updates properly', () async {
      expect(localPrefs.isFirstLaunch(), isTrue);

      await localPrefs.setIsFirstLaunch(false);
      expect(localPrefs.isFirstLaunch(), isFalse);
    });

    test('LastSyncTimestamp saves and parses correctly', () async {
      expect(localPrefs.getLastSyncTimestamp(), isNull);

      final now = DateTime(2026, 8, 21, 2, 30);
      await localPrefs.setLastSyncTimestamp(now);

      final retrieved = localPrefs.getLastSyncTimestamp();
      expect(retrieved, isNotNull);
      expect(retrieved!.year, 2026);
      expect(retrieved.month, 8);
      expect(retrieved.day, 21);
    });

    test('clearAll resets all stored preferences', () async {
      await localPrefs.setThemeMode('dark');
      await localPrefs.setLanguageCode('en');
      await localPrefs.setIsFirstLaunch(false);

      await localPrefs.clearAll();

      expect(localPrefs.getThemeMode(), 'system');
      expect(localPrefs.getLanguageCode(), 'ar');
      expect(localPrefs.isFirstLaunch(), isTrue);
    });
  });
}
