import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

class BottomNavButton extends StatefulWidget {
  final dynamic Function()? onPress;
  final Icon icon;
  final Widget label;
  final Color backgroundColor;
  final Color activeBgColor;
  final bool isActive;
  const BottomNavButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.transparent,
    this.isActive = false,
    this.activeBgColor = Colors.red,
  });

  @override
  State<BottomNavButton> createState() => _BottomNavButtonState();
}

class _BottomNavButtonState extends State<BottomNavButton> {
  @override
  Widget build(BuildContext context) {
    final Color _bgColor =
        widget.isActive ? widget.activeBgColor : widget.backgroundColor;

    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        width: 63,
        color: _bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [widget.icon, widget.label],
        ),
      ),
    );
  }
}
