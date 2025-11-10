import 'package:flutter/material.dart';

class KColors {
  static final Color homeFloatingBtn = const Color.fromARGB(255, 241, 19, 119);
  static final Color profileIconColor = const Color.fromARGB(255, 34, 136, 156);
  static final Color notificationIconColor = const Color.fromARGB(
    255,
    218,
    153,
    1,
  );
  static final Color offWhite = const Color.fromARGB(255, 253, 248, 253);
  static final Color aboutUsIcon = const Color.fromARGB(255, 90, 51, 176);
  static final Color contactIcon = const Color.fromARGB(255, 39, 118, 143);
  static final Color appointment = const Color.fromARGB(255, 137, 101, 211);
  static final Color findUs = const Color.fromARGB(255, 236, 240, 249);
  static final Color findUsIcon = const Color.fromARGB(255, 32, 107, 173);
  static final Color orderLenses = const Color.fromARGB(255, 206, 242, 206);
  static final Color selectedSlot = const Color.fromARGB(255, 94, 24, 107);
  static final Color opaqueBlack48 = const Color.fromARGB(122, 0, 0, 0);
  static final Color opaqueBlack20 = const Color.fromARGB(50, 0, 0, 0);
  static final Color profileBlue = const Color.fromARGB(255, 40, 123, 137);

  static Color getColor(context, String color) {
    switch (color) {
      case "primary":
        return Theme.of(context).primaryColor;
      case "secondary":
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
