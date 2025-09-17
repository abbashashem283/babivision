import 'package:flutter/material.dart';

enum ScreenSize { sm, md, lg, xl, xxl }

extension ResponsiveContext on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get ratio => width / height;

  ScreenSize get screenSize {
    if (width >= 1536) return ScreenSize.xxl;
    if (width >= 1280) return ScreenSize.xl;
    if (width >= 1024) return ScreenSize.lg;
    if (width >= 768) return ScreenSize.md;
    return ScreenSize.sm;
  }

  T responsive<T>({required T sm, T? md, T? lg, T? xl, T? xxl}) {
    switch (screenSize) {
      case ScreenSize.xxl:
        return xxl ?? xl ?? lg ?? md ?? sm;
      case ScreenSize.xl:
        return xl ?? lg ?? md ?? sm;
      case ScreenSize.lg:
        return lg ?? md ?? sm;
      case ScreenSize.md:
        return md ?? sm;
      case ScreenSize.sm:
      default:
        return sm;
    }
  }

  double percentageOfWidth(double percent) {
    return width * percent;
  }

  double percentageOfHeight(double percent) {
    return height * percent;
  }
}
