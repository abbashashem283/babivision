import 'package:babivision/views/pages/Auth/RegisterPage.dart';
import 'package:babivision/views/pages/HomePage.dart';
import 'package:babivision/views/pages/Auth/LoginPage.dart';
import 'package:babivision/views/pages/SplashScreen.dart';
import 'package:flutter/material.dart';

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
      home: RegisterPage(),
    );
  }
}

void main() {
  //debugPaintSizeEnabled = true;
  runApp(const MyApp());
}
