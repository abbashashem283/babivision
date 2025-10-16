import 'package:babivision/views/pages/AppointmentBooker.dart';
import 'package:babivision/views/pages/Appointments.dart';
import 'package:babivision/views/pages/Auth/LoginPage.dart';
import 'package:flutter/material.dart';

final protectedRoutes = ["/appointments/book", "/appointments"];

Map<String, Widget Function(BuildContext context)> getRoutes(
  BuildContext context,
) {
  return {
    "/login": (context) => Loginpage(),
    "/appointments/book": (context) => AppointmentBooker(),
    "/appointments": (context) => Appointments(),
  };
}
