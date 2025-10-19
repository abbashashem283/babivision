import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() {
    return _instance;
  }

  SecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<dynamic> read(String key) async {
    final value = await _storage.read(key: key);
    return value;
  }

  Future<void> write(String key, String data) async {
    await _storage.write(key: key, value: data);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
