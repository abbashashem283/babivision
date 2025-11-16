import 'package:babivision/data/storage/HiveStorage.dart';

class Cache {
  static Future<void> put(dynamic key, dynamic value, {int ttl = 3600}) async {
    final now = DateTime.now().millisecondsSinceEpoch / 1000;
    await HiveStorage().write(key, {"value": value, "expires": now + ttl});
  }

  static Future<dynamic> get(
    dynamic key, {
    Function(dynamic oldValue)? onExpiredOrMiss,
    int ttl = 3600,
    bool cacheNewValue = true,
  }) async {
    final data = await HiveStorage().read(key);
    dynamic newValue;

    if (data != null) {
      final value = data["value"];
      final expires = data["expires"];
      assert(value != null && expires != null, "value is not a cached value");
      final now = DateTime.now().millisecondsSinceEpoch / 1000;
      if (now <= expires) return value;
    }

    final oldValue = data?["value"];
    newValue = await onExpiredOrMiss?.call(oldValue);

    if (newValue != null && cacheNewValue) await put(key, newValue, ttl: ttl);
    return newValue;
  }
}
