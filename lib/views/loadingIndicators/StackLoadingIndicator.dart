import 'package:babivision/data/KConstants.dart';
import 'package:flutter/material.dart';

class StackLoadingIndicator extends StatelessWidget {
  final Widget indicator;
  final double size;
  const StackLoadingIndicator({
    super.key,
    required this.indicator,
    this.size = 50,
  });

  factory StackLoadingIndicator.regular() {
    return StackLoadingIndicator(indicator: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KColors.opaqueBlack20,
      width: double.infinity,
      height: double.infinity,
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.all(8),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: indicator,
        ),
      ),
    );
  }
}
