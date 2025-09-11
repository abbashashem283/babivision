import 'package:flutter/material.dart';

class KColors {
  static final Color homeFloatingBtn = Color.fromARGB(255, 241, 19, 119);

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
