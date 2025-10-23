import 'dart:convert';
import 'dart:math';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/popups/Utils.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/data/storage/SecureStorage.dart';
import 'package:babivision/views/cards/DiagonalShadow.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:babivision/views/popups/Snackbars.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class InkUpList extends StatefulWidget {
  const InkUpList({super.key});

  @override
  State<InkUpList> createState() => _InkUpListState();
}

class _InkUpListState extends State<InkUpList> {
  //final ScrollController _scrollController = ScrollController();
  bool _showInk = false;
  double _lastOffset = 0;

  final items = List.generate(100, (index) => 'Item ${index + 1}');

  @override
  void initState() {
    super.initState();

    // _scrollController.addListener(() {
    //   double offset = _scrollController.position.pixels;
    //   double maxOffset = _scrollController.position.maxScrollExtent;

    //   bool atEnd = offset >= maxOffset - 5;
    //   bool scrollingUp = offset < _lastOffset;

    //   //debugPrint('$offset $maxOffset');

    //   // Show ink only if user is at end AND scrolling up
    //   setState(() {
    //     _showInk = atEnd;
    //   });

    //   _lastOffset = offset;
    // });
  }

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("build");
    return Stack(
      children: [
        // Scrollable list
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // if (notification is ScrollUpdateNotification) {
            //   //debugPrint("ok");
            // }
            //debugPrint(notification.runtimeType.toString());
            if (notification is OverscrollNotification) {
              //debugPrint("over");
              if (notification.overscroll < 0)
                setState(() {
                  _showInk = true;
                });
              if (notification.overscroll > 0)
                setState(() {
                  _showInk = false;
                });
            }
            return true;
          },
          child: GlowingOverscrollIndicator(
            color: Colors.purple,
            axisDirection: AxisDirection.down,
            child: ListView.separated(
              //controller: _scrollController,
              //physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder:
                  (context, index) => ListTile(title: Text(items[index])),
            ),
          ),
        ),

        // InkWell appears only when scrolling up at the end
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _showInk ? 0.5 : 0.0,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 100,
                height: _showInk ? 20 : 0,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
      appBar: AppBar(title: Text("Playground")),
      body: Center(
        child: FilledButton(
          onPressed: () {
            showSnackbar(
              context: context,
              snackBar:
                  TextSnackBar(
                    label: "Appointment Added!",
                    duration: Duration(seconds: 10),
                    foreGroundColor: Colors.black,
                    backgroundColor: Colors.grey[200],
                    icon: Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: Colors.green,
                    ),
                  ).create(),
            );
          },
          child: Text("show snackbar"),
        ),
        // child: Container(
        //   width: 200,
        //   height: 200,
        //   decoration: BoxDecoration(
        //     color: Colors.blue,
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border(
        //       top: BorderSide(color: Colors.black, width: 1),
        //       right: BorderSide(color: Colors.black, width: 1),
        //       bottom: BorderSide(color: Colors.black, width: 1),
        //       left: BorderSide(color: Colors.transparent, width: 1),
        //     ),
        //   ),
        //   child: Center(child: Text("test")),
        // ),
      ),
    );
  }
}
