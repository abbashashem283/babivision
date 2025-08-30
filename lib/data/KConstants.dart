import 'package:flutter/material.dart';

class KColors {
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
