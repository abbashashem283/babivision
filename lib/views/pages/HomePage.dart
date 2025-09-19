import 'dart:math';

import 'package:babivision/views/buttons/CIconButton.dart';
import 'package:babivision/views/cards/DiagonalShadow.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:flutter_svg/svg.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  Widget _buildGridRow(
    BuildContext context,
    List<Map<String, dynamic>> itemsData,
  ) {
    return Expanded(
      child: Row(
        children:
            itemsData
                .map(
                  (data) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DiagonalShadow(
                        //shadowSize: (height * .08) * .9,
                        shadowSize: context.percentageOfHeight(.08) * .9,
                        spacing: context.responsiveExplicit(
                          fallback: 2,
                          onHeight: {555: 15},
                        ),
                        label: Text(
                          data["label"],
                          style: TextStyle(
                            //color: data["color"],
                            color: data["color"],
                            fontSize: context.responsiveExplicit(
                              fallback: 16,
                              onWidth: {context.sm: 16, context.md: 26},
                              onHeight: {-500: 9},
                            ),
                          ),
                        ),
                        icon: SvgPicture.asset(
                          data["img_src"],
                          width: context.responsiveExplicit(
                            onHeight: {555: context.percentageOfHeight(.08)},
                            fallback: context.percentageOfHeight(.07),
                          ),
                          height: context.responsiveExplicit(
                            onHeight: {555: context.percentageOfHeight(.08)},
                            fallback: context.percentageOfHeight(.07),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: data["backgroundColor"],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[400]!),
                        ),

                        //shadowDecoration: BoxDecoration(color: Colors.red),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildBottomNavBtn({
    required Function() onPress,
    required bool isActive,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    required IconData icon,
    required String text,
  }) {
    return CIconButton(
      onPress: onPress,
      width: context.responsiveExplicit(
        fallback: 10,
        onWidth: {
          context.sm: context.percentageOfHeight(.1).clamp(0, 68),
          context.md: context.percentageOfWidth(.12),
          context.lg: context.percentageOfWidth(.1),
        },
      ),
      padding: EdgeInsets.all(1.5),
      isActive: isActive,
      backgroundColor: bgColor,
      icon: Icon(
        icon,
        color: iconColor,
        size: context.responsiveExplicit(
          fallback: 35,
          onWidth: {
            context.sm: 35,
            context.md: context.percentageOfHeight(.04),
            context.lg: context.percentageOfWidth(.04).clamp(0, 40),
          },
          onHeight: {-580: context.percentageOfHeight(.03).clamp(20, 25)},
        ),
      ), //35
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: context.responsiveExplicit(
            fallback: 9,
            onWidth: {
              context.sm: context.responsiveExplicit(
                fallback: 9,
                onHeight: {-580: 5},
              ),
              context.md: context.responsiveExplicit(
                //onWidth: {1300: 11},
                onHeight: {-580: 5},
                fallback: 9,
              ),
              context.lg: 16,
            },
          ),
          //fontSize: context.responsiveExplicit({}, fallback: 9)
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return ListTile(
      leading: Icon(icon, size: 35, color: iconColor),
      title: Text(
        label,
        style: TextStyle(
          fontSize: (context.percentageOfWidth(.02)).clamp(18, 25),
        ),
      ),
    );
  }

  Widget _buildSideMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: context.responsiveOrientation(fallback: 0, onLandscape: 15),
      children: [
        _buildDrawerTile(
          icon: Icons.info,
          iconColor: KColors.aboutUsIcon,
          label: "About Us",
        ),

        _buildDrawerTile(
          icon: Icons.message_rounded,
          iconColor: KColors.contactIcon,
          label: "Contact / Support",
        ),
        _buildDrawerTile(
          icon: Icons.settings,
          iconColor: Colors.grey[600]!,
          label: "Settings",
        ),
        Divider(),
        _buildDrawerTile(
          icon: Icons.article,
          iconColor: Colors.orange,
          label: "Terms & Privacy",
        ),
        _buildDrawerTile(
          icon: Icons.logout_outlined,
          iconColor: Colors.red,
          label: "Logout",
        ),
      ],
    );
  }

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
        preferredSize: Size.fromHeight(80),
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
                          icon: Icon(
                            Icons.menu,
                            color: Colors.black,
                            size: context.percentageOfWidth(.1).clamp(20, 50),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/babivision-logo.svg',
                          width: context.percentageOfWidth(.2).clamp(120, 150),

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
          width: context.percentageOfWidth(.7),
          height: double.infinity,
          color: KColors.offWhite,
          child: Column(
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    width: (context.percentageOfWidth(.2) / context.ratio)
                        .clamp(100, 150),
                    height: (context.percentageOfWidth(.2) / context.ratio)
                        .clamp(100, 150),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(
                        ((context.percentageOfWidth(.2) / 2) / context.ratio)
                            .clamp(50, 75),
                      ),
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
              context.responsiveOrientation(
                onLandscape: Expanded(
                  child: SingleChildScrollView(child: _buildSideMenu()),
                ),
                onPortrait: Expanded(child: _buildSideMenu()),
              ),
            ],
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: double.infinity.clamp(50, 800),
          child: FractionallySizedBox(
            //height: 250,
            widthFactor: 0.95,
            heightFactor: 0.92,
            //height: 250,
            child: Column(
              children: [
                _buildGridRow(context, [
                  {
                    "onPress": null,
                    "img_src": "assets/icon-images/calendar.svg",
                    "label": "Book Appointment",
                    "color": Colors.white,
                    "backgroundColor": KColors.appointment,
                  },
                  {
                    "onPress": null,
                    "img_src": "assets/icon-images/map.svg",
                    "label": "Find Us",
                    "color": Colors.black,
                    "backgroundColor": KColors.findUs,
                  },
                ]),
                _buildGridRow(context, [
                  {
                    "onPress": null,
                    "img_src": "assets/icon-images/note.svg",
                    "label": "My Prescriptions",
                    "color": Colors.black,
                    "backgroundColor": Colors.white,
                  },
                  {
                    "onPress": null,
                    "img_src": "assets/icon-images/accessories.svg",
                    "label": "Accessories",
                    "color": Colors.black,
                    "backgroundColor": KColors.orderLenses,
                  },
                ]),
                _buildGridRow(context, [
                  {
                    "onPress": null,
                    "img_src": "assets/icon-images/lenses.svg",
                    "label": "Lenses",
                    "color": Colors.black,
                    "backgroundColor": KColors.findUs,
                  },
                  {
                    "onPress": null,
                    "img_src": "assets/icon-images/glasses.svg",
                    "label": "Glasses",
                    "color": Colors.black,
                    "backgroundColor": Color.fromARGB(255, 233, 244, 248),
                  },
                ]),
              ],
            ),
          ),
        ),
      ),
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
              _buildBottomNavBtn(
                onPress: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                icon: Icons.home,
                isActive: homeActive,
                bgColor: homeBgColor,
                iconColor: homeIconColor,
                textColor: homeIconColor,
                text: "Home",
              ),
              _buildBottomNavBtn(
                onPress: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                icon: Icons.format_list_bulleted,
                isActive: servicesActive,
                bgColor: servicesBgColor,
                iconColor: servicesIconColor,
                textColor: servicesIconColor,
                text: "Services",
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
              _buildBottomNavBtn(
                onPress: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                isActive: profileActive,
                bgColor: profileBgColor,
                iconColor: profileIconColor,
                textColor: profileIconColor,
                icon: Icons.person_outline_rounded,
                text: "Profile",
              ),
              _buildBottomNavBtn(
                onPress: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                isActive: notificationsActive,
                bgColor: notificationsBgColor,
                iconColor: notificationsIconColor,
                textColor: notificationsIconColor,
                icon: Icons.notifications_none,
                text: "Notifications",
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
