import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

class CIconButton extends StatefulWidget {
  final dynamic Function()? onPress;
  final Icon icon;
  final Text label;
  final Color backgroundColor;
  final Color activeBgColor;
  final Color textColor;
  final Color activeTextColor;
  final bool isActive;
  final double? width;
  final double? height;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  const CIconButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.isActive = false,
    this.activeBgColor = Colors.red,
    this.activeTextColor = Colors.white,
    this.width,
    this.height,
    this.padding,
    this.spacing = 0,
  });

  @override
  State<CIconButton> createState() => _CIconButtonState();
}

class _CIconButtonState extends State<CIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.backgroundColor,
        ),
        child: Column(
          spacing: widget.spacing,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [widget.icon, widget.label],
        ),
      ),
    );
  }
}
