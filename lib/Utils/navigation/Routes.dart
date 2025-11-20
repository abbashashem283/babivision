import 'package:babivision/views/forms/MessageForm.dart';
import 'package:babivision/views/pages/AboutUs.dart';
import 'package:babivision/views/pages/AppointmentBooker.dart';
import 'package:babivision/views/pages/Appointments.dart';
import 'package:babivision/views/pages/Auth/LoginPage.dart';
import 'package:babivision/views/pages/Auth/PasswordChange.dart';
import 'package:babivision/views/pages/Auth/PasswordCodeConfirmation.dart';
import 'package:babivision/views/pages/Auth/PasswordReset.dart';
import 'package:babivision/views/pages/Auth/RegisterPage.dart';
import 'package:babivision/views/pages/FindUs.dart';
import 'package:babivision/views/pages/Prescriptions.dart';
import 'package:babivision/views/pages/Products.dart';
import 'package:babivision/views/pages/TermsPrivacy.dart';
import 'package:babivision/views/pages/homepage/HomePage.dart';
import 'package:flutter/material.dart';

final protectedRoutes = ["/appointments/book", "/appointments"];

final _dynamicRoutes = {
  "/login":
      (args) => Loginpage(
        origin: args['origin'],
        redirect: args['redirect'],
        redirectArguments: args['redirectArguments'],
      ),
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
  "/password/change": (args) => PasswordChange(origin: args['origin']),
  "/appointments/book":
      (args) =>
          AppointmentBooker(service: args['service'], clinic: args['clinic']),
  "/contact":
      (args) => MessageForm(
        feedbackType: args['feedbackType'],
        title: args['title'],
        subTitle: args['subTitle'],
        appBarTitle: args['appBarTitle'],
      ),
  "/contact/bug":
      (args) => MessageForm(
        feedbackType: args['feedbackType'],
        title: args['title'],
        subTitle: args['subTitle'],
        appBarTitle: args['appBarTitle'],
        name: args['name'],
        email: args['email'],
      ),
  "/contact/complaint":
      (args) => MessageForm(
        feedbackType: args['feedbackType'],
        title: args['title'],
        subTitle: args['subTitle'],
        appBarTitle: args['appBarTitle'],
        name: args['name'],
        email: args['email'],
      ),
  "/products": (args) => Products(category: args['category']),
};

Map<String, Widget Function(BuildContext context)> getRoutes(
  BuildContext context,
) {
  return {
    "/appointments": (context) => Appointments(),
    "/home": (context) => Homepage(),
    "/register": (context) => RegisterPage(),
    "/about": (context) => AboutUs(),
    "/terms": (context) => TermsPrivacyPage(),
    "/findUs": (context) => FindUs(),
    "/prescriptions": (context) => Prescriptions(),
  };
}

Route? dynamicRoutes(RouteSettings settings) {
  String? routeName = settings.name;
  final args = (settings.arguments as Map?) ?? {};
  if (routeName == null) return null;
  final pageBuilder = _dynamicRoutes[routeName];
  if (pageBuilder == null) return null;
  return MaterialPageRoute(
    builder: (_) => pageBuilder({...args}),
    settings: settings,
  );
}
