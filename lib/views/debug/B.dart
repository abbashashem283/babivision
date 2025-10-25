import 'package:flutter/material.dart';

class B extends StatelessWidget {
  final String color;
  final double thickness;
  final Widget child;
  final bool inExpanded;

  const B({
    super.key,
    this.color = "g",
    this.thickness = 1,
    this.inExpanded = false,
    required this.child,
  });

  Color getColor(String color) {
    switch (color) {
      case "g":
        return Colors.green;
      case "b":
        return Colors.blue;
      case "r":
        return Colors.red;
      case "p":
        return Colors.purple;
      case "o":
        return Colors.orange;
      case "t":
        return Colors.teal;
      case "tr":
        return Colors.transparent;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: inExpanded ? double.infinity : null,
      height: inExpanded ? double.infinity : null,
      decoration: BoxDecoration(
        border: Border.all(color: getColor(color), width: thickness),
      ),
      child: child,
    );
  }
}
