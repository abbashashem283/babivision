import 'package:babivision/views/pages/AppointmentBooker.dart';
import 'package:babivision/views/pages/Appointments.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> getRoutes(
  BuildContext context,
) {
  return {
    "/appointments/book": (context) => AppointmentBooker(),
    "/appointments": (context) => Appointments(),
  };
}
