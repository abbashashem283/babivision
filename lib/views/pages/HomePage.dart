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
  int _currentIndex = 0;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: SafeArea(
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  SizedBox(
                    width: 50,
                    child: Builder(
                      builder: (context) {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 4,
                            minHeight: 4,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(Icons.menu, color: Colors.black),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/babivision-logo.png',
                          width: 120,

                          //height: 75,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: SafeArea(
        child: Container(
          width: 280,
          height: double.infinity,
          color: KColors.offWhite,
          child: Column(
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "JD",
                        style: TextStyle(color: Colors.purple, fontSize: 40),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("John Doe", style: TextStyle(fontSize: 25)),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      "jdoe@example.com",
                      style: TextStyle(
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info,
                      size: 35,
                      color: KColors.aboutUsIcon,
                    ),
                    title: Text("About Us", style: TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.message_rounded,
                      size: 35,
                      color: KColors.contactIcon,
                    ),
                    title: Text(
                      "Contact / Support",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                    title: Text("Settings", style: TextStyle(fontSize: 20)),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                    title: Text("Settings", style: TextStyle(fontSize: 20)),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      size: 35,
                      color: Colors.grey[600],
                    ),
                    title: Text("Settings", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
