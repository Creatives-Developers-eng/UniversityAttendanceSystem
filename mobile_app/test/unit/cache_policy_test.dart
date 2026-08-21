import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/offline/cache_policy.dart';

void main() {
  group('CachePolicy & CacheEntry Unit Tests', () {
    test('CachePolicy enum values check', () {
      expect(CachePolicy.values, contains(CachePolicy.networkFirst));
      expect(CachePolicy.values, contains(CachePolicy.cacheFirst));
      expect(CachePolicy.values, contains(CachePolicy.cacheOnly));
      expect(CachePolicy.values, contains(CachePolicy.networkOnly));
      expect(CachePolicy.values, contains(CachePolicy.staleWhileRevalidate));
    });

    test('CacheEntry isExpired returns false when ttl is null', () {
      final entry = CacheEntry<String>(
        data: 'test_data',
        cachedAt: DateTime.now().subtract(const Duration(days: 10)),
        ttl: null,
      );

      expect(entry.isExpired, isFalse);
    });

    test('CacheEntry isExpired returns false when within ttl window', () {
      final entry = CacheEntry<String>(
        data: 'test_data',
        cachedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ttl: const Duration(hours: 1),
      );

      expect(entry.isExpired, isFalse);
    });

    test('CacheEntry isExpired returns true when ttl has passed', () {
      final entry = CacheEntry<String>(
        data: 'test_data',
        cachedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ttl: const Duration(hours: 1),
      );

      expect(entry.isExpired, isTrue);
    });

    test('CacheEntry serializes and deserializes correctly with JSON string', () {
      final original = CacheEntry<Map<String, dynamic>>(
        data: {'course_code': 'CS101', 'title': 'Introduction to CS'},
        cachedAt: DateTime.now(),
        ttl: const Duration(hours: 12),
        version: 1,
      );

      final jsonStr = original.toJsonString((v) => v);
      final restored = CacheEntry<Map<String, dynamic>>.fromJsonString(
        jsonStr,
        (raw) => Map<String, dynamic>.from(raw as Map),
      );

      expect(restored.data['course_code'], equals('CS101'));
      expect(restored.data['title'], equals('Introduction to CS'));
      expect(restored.ttl?.inHours, equals(12));
      expect(restored.version, equals(1));
      expect(restored.isExpired, isFalse);
    });

    test('CacheEntry handles corrupted or missing optional fields gracefully', () {
      final map = <String, dynamic>{
        'data': 'simple_string',
      };

      final restored = CacheEntry<String>.fromMap(map, (raw) => raw.toString());
      expect(restored.data, equals('simple_string'));
      expect(restored.ttl, isNull);
      expect(restored.version, equals(1));
      expect(restored.isExpired, isFalse);
    });
  });
}
