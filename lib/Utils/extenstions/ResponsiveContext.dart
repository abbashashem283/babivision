import 'package:flutter/material.dart';

enum ScreenSize { sm, md, lg, xl, xxl }

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

  T responsiveExplicit<T>({
    required T fallback,
    Map<int, T>? onWidth,
    Map<int, T>? onHeight,
  }) {
    assert(
      onWidth != null || onHeight != null,
      "Must supply breakpoints for either width or height",
    );
    final List? pointsWidth = onWidth?.keys.toList();
    final List? pointsHeight = onHeight?.keys.toList();
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
    apply ??= fallback;
    return apply!;
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
}
