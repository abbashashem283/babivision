import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

//class Widgets {
void unfocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void onPostFrame(FrameCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback(callback);
}

//}
