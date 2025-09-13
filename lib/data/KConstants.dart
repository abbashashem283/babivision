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
  static final Color offWhite = Color.fromARGB(255, 253, 248, 253);
  static final Color aboutUsIcon = Color.fromARGB(255, 90, 51, 176);
  static final Color contactIcon = Color.fromARGB(255, 39, 118, 143);

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
