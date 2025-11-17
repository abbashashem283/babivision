import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static final _instance = HiveStorage._internal();

  Box? _box;

  Future<void> initBox(String name) async {
    if (!Hive.isBoxOpen(name)) {
      _box = await Hive.openBox(name);
    } else {
      _box = Hive.box(name);
    }
  }

  HiveStorage._internal();

  factory HiveStorage() {
    return _instance;
  }

  Future<void> write(dynamic key, dynamic value) async {
    assert(_box != null, "no selected box");
    final box = _box!;
    await box.put(key, value);
  }

  Future<dynamic> read(dynamic key, {dynamic defaultValue}) async {
    assert(_box != null, "no selected box");
    final box = _box!;
    return await box.get(key, defaultValue: defaultValue);
  }

  Future<void> delete(dynamic key) async {
    assert(_box != null, "no selected box");
    final box = _box!;
    await box.delete(key);
  }
}
