import 'package:babivision/Utils/navigation/Routes.dart';
import 'package:babivision/data/storage/HiveStorage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:babivision/views/pages/homepage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: false,
      builder:
          (context) => ScreenUtilInit(
            designSize: Size(375, 667),
            builder: (context, child) {
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
            },
          ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(
  //         seedColor: Colors.deepPurple,
  //       ).copyWith(primary: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home: Homepage(),
  //     routes: getRoutes(context),
  //     onGenerateRoute: dynamicRoutes,
  //   );
  // }
}

Future main() async {
  //debugPaintSizeEnabled = true;
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await HiveStorage().initBox("babivision");
  runApp(const MyApp());
}
