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

  void write(dynamic key, dynamic value) {
    assert(_box != null, "no selected box");
    final box = _box!;
    box.put(key, value);
  }

  void read(dynamic key) {
    assert(_box != null, "no selected box");
    final box = _box!;
    box.get(key);
  }
}
