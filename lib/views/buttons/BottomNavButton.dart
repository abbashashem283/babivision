import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

class BottomNavButton extends StatefulWidget {
  final dynamic Function()? onPress;
  final Icon icon;
  final Text label;
  final Color backgroundColor;
  final Color activeBgColor;
  final Color textColor;
  final Color activeTextColor;
  final bool isActive;
  const BottomNavButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.isActive = false,
    this.activeBgColor = Colors.red,
    this.activeTextColor = Colors.white,
  });

  @override
  State<BottomNavButton> createState() => _BottomNavButtonState();
}

class _BottomNavButtonState extends State<BottomNavButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        width: 63,
        height: 63,
        padding: EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [widget.icon, widget.label],
        ),
      ),
    );
  }
}
