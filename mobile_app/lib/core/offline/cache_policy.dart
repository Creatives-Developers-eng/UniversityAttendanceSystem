import 'dart:convert';

/// سياسات واستراتيجيات التخزين المؤقت المعتمدة في التطبيق
/// تحدد سلوك جلب البيانات والمفاضلة بين الشبكة والتخزين المحلي
enum CachePolicy {
  /// محاولة الاتصال بالشبكة أولاً، والرجوع للتخزين المحلي عند انقطاع الإنترنت أو فشل الطلب
  /// (السياسة الافتراضية للبيانات الحيوية كالمقررات والشعب)
  networkFirst,

  /// فحص التخزين المحلي أولاً، وإذا كانت البيانات متوفرة وصالحة يتم إرجاعها دون استهلاك الشبكة
  /// وإلا يتم جلبها من الشبكة وتحديث الكاش
  cacheFirst,

  /// قراءة البيانات حصرياً من التخزين المحلي دون إجراء أي طلب شبكي
  /// (مثالية للعمل في القاعات المعزولة تماماً)
  cacheOnly,

  /// جلب البيانات حصرياً من الشبكة وتحديث الكاش المحلي عند النجاح
  networkOnly,

  /// إرجاع البيانات المخزنة محلياً فوراً لتسريع العرض، مع إطلاق طلب في الخلفية لتحديث الكاش
  staleWhileRevalidate,
}

/// غلاف كائن التخزين المؤقت شاملاً الطابع الزمني وزمن الصلاحية والإصدار
class CacheEntry<T> {
  final T data;
  final DateTime cachedAt;
  final Duration? ttl;
  final int version;

  const CacheEntry({
    required this.data,
    required this.cachedAt,
    this.ttl,
    this.version = 1,
  });

  /// التحقق مما إذا كانت صلاحية الكائن قد انقضت بناءً على الـ TTL
  bool get isExpired {
    if (ttl == null) return false;
    return DateTime.now().isAfter(cachedAt.add(ttl!));
  }

  /// تحويل كائن الكاش إلى خريطة JSON
  Map<String, dynamic> toMap(dynamic Function(T value) dataToJson) {
    return {
      'cached_at': cachedAt.toIso8601String(),
      'ttl_ms': ttl?.inMilliseconds,
      'version': version,
      'data': dataToJson(data),
    };
  }

  /// تحويل كائن الكاش إلى سلسلة JSON مشفرة
  String toJsonString(dynamic Function(T value) dataToJson) {
    return jsonEncode(toMap(dataToJson));
  }

  /// إنشاء كائن الكاش من خريطة JSON
  factory CacheEntry.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic raw) dataFromJson,
  ) {
    final cachedAtStr = map['cached_at'] as String?;
    final cachedAt = cachedAtStr != null ? DateTime.tryParse(cachedAtStr) ?? DateTime.now() : DateTime.now();
    final ttlMs = map['ttl_ms'] as num?;
    final ttl = ttlMs != null ? Duration(milliseconds: ttlMs.toInt()) : null;
    final version = (map['version'] as num?)?.toInt() ?? 1;
    final rawData = map['data'];

    return CacheEntry<T>(
      data: dataFromJson(rawData),
      cachedAt: cachedAt,
      ttl: ttl,
      version: version,
    );
  }

  /// إنشاء كائن الكاش من سلسلة JSON
  factory CacheEntry.fromJsonString(
    String jsonString,
    T Function(dynamic raw) dataFromJson,
  ) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return CacheEntry.fromMap(map, dataFromJson);
  }
}
