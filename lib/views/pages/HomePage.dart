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
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    bool homeActive = _currentIndex == 0;
    bool servicesActive = _currentIndex == 1;
    bool profileActive = _currentIndex == 2;
    bool notificationsActive = _currentIndex == 3;

    Color homeIconColor = homeActive ? Colors.white : Colors.purple;
    Color homeBgColor = homeActive ? Colors.purple : Colors.transparent;

    Color servicesIconColor =
        servicesActive ? Colors.white : KColors.homeFloatingBtn;
    Color servicesBgColor =
        servicesActive ? KColors.homeFloatingBtn : Colors.transparent;

    Color profileIconColor =
        profileActive ? Colors.white : KColors.profileIconColor;
    Color profileBgColor =
        profileActive ? KColors.profileIconColor : Colors.transparent;

    Color notificationsIconColor =
        notificationsActive ? Colors.white : KColors.notificationIconColor;
    Color notificationsBgColor =
        notificationsActive
            ? KColors.notificationIconColor
            : Colors.transparent;

    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("This is home page")),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: BottomAppBar(
          //height: 53,
          padding: EdgeInsets.all(3),
          color: Colors.white10,

          shape: CircularNotchedRectangle(),
          notchMargin: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavButton(
                onPress: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                isActive: homeActive,
                backgroundColor: homeBgColor,
                icon: Icon(Icons.home, color: homeIconColor, size: 35),
                label: Text(
                  "Home",
                  style: TextStyle(color: homeIconColor, fontSize: 9),
                ),
              ),
              BottomNavButton(
                onPress: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                isActive: servicesActive,
                backgroundColor: servicesBgColor,
                icon: Icon(
                  Icons.format_list_bulleted,
                  color: servicesIconColor,
                  size: 35,
                ),
                label: Text(
                  "Services",
                  style: TextStyle(color: servicesIconColor, fontSize: 9),
                ),
              ),
              SizedBox(
                width: 60,
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Shop",
                      style: TextStyle(
                        color: KColors.homeFloatingBtn,
                        fontWeight: FontWeight.bold,
                        //fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ),
              BottomNavButton(
                onPress: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                isActive: profileActive,
                backgroundColor: profileBgColor,
                icon: Icon(
                  Icons.person_outline_rounded,
                  color: profileIconColor,
                  size: 35,
                ),
                label: Text(
                  "Profile",
                  style: TextStyle(color: profileIconColor, fontSize: 9),
                ),
              ),
              BottomNavButton(
                onPress: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                isActive: notificationsActive,
                backgroundColor: notificationsBgColor,
                icon: Icon(
                  Icons.notifications_none,
                  color: notificationsIconColor,
                  size: 35,
                ),
                label: Text(
                  "Notifications",
                  style: TextStyle(color: notificationsIconColor, fontSize: 9),
                ),
              ),
            ],
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
