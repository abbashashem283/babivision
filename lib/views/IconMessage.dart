import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:flutter/material.dart';

class IconMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? color;
  final double scalableSize;
  const IconMessage({
    super.key,
    required this.icon,
    required this.message,
    this.color,
    this.scalableSize = 16,
  });

  factory IconMessage.error({String message = "An Error Has Occured"}) {
    return IconMessage(
      icon: Icons.error,
      message: message,
      color: Colors.red,
      scalableSize: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: null,
      label: Text(
        message,
        style: TextStyle(
          color: color,
          fontSize: context.fontSizeMin(scalableSize),
        ),
      ),
      icon: Icon(
        icon,
        color: color,
        size: context.fontSizeMin(scalableSize + 2),
      ),
    );
  }
}
