import 'package:flutter/material.dart';

class TextSnackBar {
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foreGroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final String label;
  final Duration duration;
  final double? textSize;
  final FontWeight? fontWeight;
  const TextSnackBar({
    required this.label,
    required this.duration,
    this.icon,
    this.backgroundColor,
    this.foreGroundColor,
    this.borderColor,
    this.padding,
    this.textSize,
    this.fontWeight,
  });

  SnackBar create() {
    return SnackBar(
      padding: EdgeInsets.fromLTRB(1, 1, 1, 0),
      backgroundColor: Colors.transparent,
      content: Container(
        padding: padding ?? EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: .2, color: borderColor ?? Colors.black),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            icon ?? SizedBox.shrink(),
            Text(
              label,
              style: TextStyle(
                color: foreGroundColor,
                fontSize: 20,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
      duration: duration,
    );
  }
}
