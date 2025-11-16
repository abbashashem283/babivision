import 'dart:async';

import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/pages/homepage/HomePage.dart';
import 'package:babivision/views/pages/homepage/tabs/Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 5), () {
        Navigator.pushNamed(context, "/home");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.offWhite,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/babivision-logo.svg',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
