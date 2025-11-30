import 'dart:math';

import 'package:flutter/material.dart';

enum ScreenSize { sm, md, lg, xl, xxl }

extension DoubleMaxExtension on double {
  /// Returns this double if it is less than [maxValue], otherwise returns [maxValue]
  double max(double maxValue) {
    return this >= maxValue ? maxValue : this;
  }

  double get rem {
    return this * 16;
  }
}

extension ResponsiveContext on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get ratio => width / height;
  Orientation get orientation => MediaQuery.of(this).orientation;
  int get xxl => 1536;
  int get xl => 1280;
  int get lg => 1024;
  int get md => 768;
  int get sm => 0;

  double get dpr => MediaQuery.devicePixelRatioOf(this);

  TextScaler get textScaler => MediaQuery.textScalerOf(this);

  ScreenSize get screenSize {
    if (width >= xxl) return ScreenSize.xxl;
    if (width >= xl) return ScreenSize.xl;
    if (width >= lg) return ScreenSize.lg;
    if (width >= md) return ScreenSize.md;
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
      default:
        return sm;
    }
  }

  T? responsiveExplicit<T>({
    required T? fallback,
    Map<int, T>? onWidth,
    Map<int, T>? onHeight,
    Map<double, T>? onRatio,
  }) {
    assert(
      onWidth != null || onHeight != null || onRatio != null,
      "Must supply breakpoints for either width or height or ratio",
    );
    final List? pointsWidth = onWidth?.keys.toList();
    final List? pointsHeight = onHeight?.keys.toList();
    final List? pointsRatio = onRatio?.keys.toList();
    T? apply;
    if (pointsWidth != null) {
      for (final point in pointsWidth) {
        if (point < 0) {
          if (width <= point.abs()) apply = onWidth?[point];
          continue;
        }
        if (width >= point) apply = onWidth?[point];
      }
    }
    if (pointsHeight != null) {
      for (final point in pointsHeight) {
        if (point < 0) {
          if (height <= point.abs()) apply = onHeight?[point];
          continue;
        }
        if (height >= point) apply = onHeight?[point];
      }
    }
    if (pointsRatio != null) {
      for (final point in pointsRatio) {
        if (point < 0) {
          if (ratio <= point.abs()) apply = onRatio?[point];
          continue;
        }
        if (ratio >= point) apply = onRatio?[point];
      }
    }

    apply ??= fallback;
    return apply;
  }

  T responsiveOrientation<T>({T? fallback, T? onLandscape, T? onPortrait}) {
    assert(
      onLandscape != null || onPortrait != null,
      "At least one orientation mode must be specified",
    );
    if (onLandscape != null && orientation == Orientation.landscape)
      return onLandscape;
    assert(
      onPortrait != null || fallback != null,
      "Either specify onPortrait or a fallback",
    );
    return (onPortrait ?? fallback)!;
  }

  double percentageOfWidth(double percent) {
    return width * percent;
  }

  double percentageOfHeight(double percent) {
    return height * percent;
  }

  double fontSizeMin(double size, {double? maxWidth, double? maxHeight}) {
    double constrainedWidth = min(maxWidth ?? double.infinity, width);
    double constrainedHeight = min(maxHeight ?? double.infinity, height);
    double scaleWidth = constrainedWidth / 375; //iphone SE reference width
    double scaleHeight = constrainedHeight / 667; //iphone SE reference height
    double scaledSize = size * min(scaleWidth, scaleHeight);
    return scaledSize;
  }

  double fontSizeMax(double size) {
    double scaleWidth = width / 375; //iphone SE reference width
    double scaleHeight = height / 667; //iphone SE reference height
    double scaledSize = size * max(scaleWidth, scaleHeight);
    return scaledSize;
  }

  double fontSizeAVG(double size) {
    double scaleWidth = width / 375; //iphone SE reference width
    double scaleHeight = height / 667; //iphone SE reference height
    double scaledSize = size * ((scaleWidth + scaleHeight) / 2);
    return scaledSize;
  }
}
