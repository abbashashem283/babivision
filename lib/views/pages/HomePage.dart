import 'dart:math';

import 'package:babivision/views/buttons/BottomNavButton.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';
import 'package:babivision/data/KConstants.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("This is home page")),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: BottomAppBar(
          //height: 83,
          color: Colors.white10,

          shape: CircularNotchedRectangle(),
          notchMargin: 0,
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BottomNavButton(
                  onPress: null,
                  icon: Icon(Icons.home, color: Colors.purple, size: 35),
                  label: Text(
                    "Home",
                    style: TextStyle(color: Colors.purple, fontSize: 10),
                  ),
                ),
                BottomNavButton(
                  onPress: null,
                  icon: Icon(
                    Icons.format_list_bulleted,
                    color: KColors.homeFloatingBtn,
                    size: 35,
                  ),
                  label: Text(
                    "Services",
                    style: TextStyle(
                      color: KColors.homeFloatingBtn,
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 35,
                  child: Center(
                    child: Text(
                      "Shop",
                      style: TextStyle(
                        color: KColors.homeFloatingBtn,
                        fontWeight: FontWeight.bold,
                        //fontSize: 10,
                      ),
                    ),
                  ),
                ),
                BottomNavButton(
                  onPress: null,
                  icon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.grey,
                    size: 35,
                  ),
                  label: Text(
                    "Profile",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
                BottomNavButton(
                  onPress: null,
                  icon: Icon(
                    Icons.notifications_none,
                    color: Colors.grey,
                    size: 35,
                  ),
                  label: Text(
                    "Notifications",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: KColors.homeFloatingBtn,
          shape: const CircleBorder(),
          child: Icon(Icons.shopping_cart, color: Colors.white, size: 35),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
