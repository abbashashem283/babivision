import 'dart:convert';
import 'dart:math';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/data/storage/SecureStorage.dart';
import 'package:babivision/views/cards/DiagonalShadow.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<LaraformState> formKey = GlobalKey<LaraformState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        /*child: ClipRRect(
          child: Container(
            color: Colors.blue,
            width: 200,
            height: 600,
            child: B(
              child: Stack(
                children: [
                  B(
                    color: "p",
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final parentWidth = constraints.maxWidth;
                        final parentHeight = constraints.maxHeight;
                        final diagonal = sqrt(
                          parentWidth * parentWidth +
                              parentHeight * parentHeight,
                        );
                        debugPrint("w $parentWidth");
                        debugPrint("h $parentHeight");
                        debugPrint("h $diagonal");
                        return OverflowBox(
                          maxWidth: diagonal,
                          child: Align(
                            alignment: Alignment.center,
                            child: FractionalTranslation(
                              translation: Offset(.5, 0),
                              child: Transform.rotate(
                                angle: atan(parentHeight / parentWidth),
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  color: Colors.green,
                                  height: 30,
                                  width: diagonal / 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: B(color: "o", child: Icon(Icons.home, size: 50)),
                  ),
                ],
              ),
            ),
          ),
        ),*/
        child: Center(
          child: FutureBuilder(
            future: Http.get("/api/appointments?upto=30"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Response<dynamic>? data = snapshot.data;
                Map<String, dynamic> jsonData = jsonDecode(
                  data?.toString() ?? "null",
                );
                return Text((jsonData["appointments"].toString()));
              }
              if (snapshot.hasError) return Text("error");
              return Text("Loading...");
            },
          ),
        ),
      ),
    );
  }
}
