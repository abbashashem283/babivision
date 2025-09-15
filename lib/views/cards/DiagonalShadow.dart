import 'dart:math';

import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

class DiagonalShadow extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconWidth;
  final double? iconHeight;
  final BoxDecoration? shadowDecoration;
  final Decoration? decoration;
  final double shadowSize;
  final Text label;
  final Widget icon;
  final Function()? onPress;
  const DiagonalShadow({
    super.key,
    this.width,
    this.height,
    this.shadowDecoration,
    this.decoration,
    this.onPress,
    this.iconWidth = 30,
    this.iconHeight = 30,
    required this.shadowSize,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: ClipRRect(
        child: Container(
          decoration: decoration ?? BoxDecoration(color: Colors.blue),
          width: width,
          height: height,
          child: B(
            child: B(
              color: "p",
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final parentWidth = constraints.maxWidth;
                  final parentHeight = constraints.maxHeight;
                  final diagonal = sqrt(
                    parentWidth * parentWidth + parentHeight * parentHeight,
                  );
                  debugPrint("w $parentWidth");
                  debugPrint("h $parentHeight");
                  debugPrint("h $diagonal");
                  return Stack(
                    children: [
                      OverflowBox(
                        maxWidth: diagonal,
                        child: Align(
                          alignment: Alignment.center,
                          child: FractionalTranslation(
                            translation: Offset(.5, -.4),
                            child: Transform.rotate(
                              angle: (atan(parentHeight / parentWidth)) * 1,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: shadowSize,
                                width: diagonal / 2 + 100,
                                decoration:
                                    shadowDecoration ??
                                    BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(50, 0, 0, 0),
                                          Color.fromARGB(5, 0, 0, 0),
                                        ],
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 15,
                          children: [B(color: "tr", child: icon), label],
                        ),
                      ),
                      /*Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: parentHeight * 0.15),
                          child: label,
                        ),
                      ),*/
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
