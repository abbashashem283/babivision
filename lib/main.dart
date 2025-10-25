import 'package:babivision/Utils/navigation/Routes.dart';
import 'package:babivision/views/debug/Playground.dart';
import 'package:babivision/views/pages/Appointments.dart';
import 'package:babivision/views/pages/Auth/PasswordCodeConfirmation.dart';
import 'package:babivision/views/pages/Auth/PasswordReset.dart';
import 'package:babivision/views/pages/Auth/RegisterPage.dart';
import 'package:babivision/views/pages/homepage/HomePage.dart';
import 'package:babivision/views/pages/Auth/LoginPage.dart';
import 'package:babivision/views/pages/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ).copyWith(primary: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Homepage(),
      routes: getRoutes(context),
      onGenerateRoute: dynamicRoutes,
    );
  }
}

Future main() async {
  //debugPaintSizeEnabled = true;
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
