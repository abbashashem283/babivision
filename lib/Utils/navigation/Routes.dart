import 'package:babivision/views/pages/AppointmentBooker.dart';
import 'package:babivision/views/pages/Appointments.dart';
import 'package:babivision/views/pages/Auth/LoginPage.dart';
import 'package:babivision/views/pages/Auth/PasswordCodeConfirmation.dart';
import 'package:babivision/views/pages/Auth/PasswordReset.dart';
import 'package:babivision/views/pages/Auth/RegisterPage.dart';
import 'package:babivision/views/pages/homepage/HomePage.dart';
import 'package:babivision/views/pages/homepage/tabs/Services.dart';
import 'package:flutter/material.dart';

final protectedRoutes = ["/appointments/book", "/appointments"];

final _dynamicRoutes = {
  "/login":
      (args) => Loginpage(origin: args['origin'], redirect: args['redirect']),
  "/password/code":
      (args) => PasswordCodeConfirmation(
        email: args['email'],
        origin: args['origin'],
      ),
  "/password/reset":
      (args) => PasswordReset(
        email: args['email'],
        code: args['code'],
        origin: args['origin'],
      ),
};

Map<String, Widget Function(BuildContext context)> getRoutes(
  BuildContext context,
) {
  return {
    "/appointments/book": (context) => AppointmentBooker(),
    "/appointments": (context) => Appointments(),
    "/home": (context) => Homepage(),
    "/register": (context) => RegisterPage(),
  };
}

Route? dynamicRoutes(RouteSettings settings) {
  String? routeName = settings.name;
  final args = settings.arguments as Map?;
  if (routeName == null || args == null) return null;
  final pageBuilder = _dynamicRoutes[routeName];
  if (pageBuilder == null) return null;
  return MaterialPageRoute(builder: (_) => pageBuilder({...args}));
}
