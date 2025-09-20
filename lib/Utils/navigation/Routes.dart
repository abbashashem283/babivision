import 'package:babivision/views/pages/Appointments.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> getRoutes(
  BuildContext context,
) {
  return {"/appointments": (context) => Appointments()};
}
