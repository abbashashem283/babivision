import 'package:babivision/Utils/navigation/Routes.dart';
import 'package:flutter/widgets.dart';

bool _routeIsProtected(String route) {
  return protectedRoutes.contains(route);
}

Future pushReplacementNamed(
  BuildContext context,
  String route, {
  String? protectedFallbackRoute,
}) {
  if (_routeIsProtected(route)) {
    route = protectedFallbackRoute ?? "/login";
  }
  return Navigator.pushReplacementNamed(context, route);
}

Future pushNamed(
  BuildContext context,
  String route, {
  String? protectedFallbackRoute,
}) {
  if (_routeIsProtected(route)) {
    route = protectedFallbackRoute ?? "/login";
  }
  return Navigator.pushNamed(context, route);
}
