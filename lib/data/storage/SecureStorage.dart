import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> read(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  Future<void> write(String key, String data) async {
    await storage.write(key: key, value: data);
  }

  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }
}
