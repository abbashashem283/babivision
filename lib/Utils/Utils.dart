import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String serverAsset(String? path) {
  return "${dotenv.env['HOST']}/$path";
}

void log(Object a) {
  debugPrint(a.toString());
}
