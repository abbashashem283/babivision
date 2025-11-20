import 'dart:math';

import 'package:babivision/Utils/Auth.dart';
import 'package:babivision/Utils/navigation/Routing.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/views/buttons/CIconButton.dart';
import 'package:babivision/views/cards/DiagonalShadow.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/layout/AppBarDrawerScaffold.dart';
import 'package:babivision/views/pages/homepage/tabs/Notifications.dart';
import 'package:babivision/views/pages/homepage/tabs/Profile.dart';
import 'package:babivision/views/pages/homepage/tabs/Services.dart';
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
  Map<String, dynamic>? _user;

  Widget _getSelectedTab() {
    switch (_currentIndex) {
      case 0:
        return SizedBox(
          width: double.infinity.max(800),
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: .95,
            child: Column(
              children: [
                _buildGridRow(context, [
                  {
                    "onPress": () async {
                      final user = await Auth.user();
                      if (mounted) {
                        if (user == null) {
                          Navigator.pushNamed(
                            context,
                            '/login',
                            arguments: {
                              "origin": '/home',
                              "redirect": '/appointments',
                            },
                          ).then((_) {
                            //debugPrint("MUST REFRESH NOOOOOW!");
                          });
                        } else {
                          Navigator.pushNamed(context, '/appointments');
                        }
                      }
                    },
                    "img_src": "assets/icon-images/calendar.svg",
                    "label": "My Appointments",
                    "color": Colors.white,
                    "backgroundColor": KColors.appointment,
                  },
                  {
                    "onPress": () => Navigator.pushNamed(context, "/findUs"),
                    "img_src": "assets/icon-images/map.svg",
                    "label": "Find Us",
                    "color": Colors.black,
                    "backgroundColor": KColors.findUs,
                  },
                ]),
                _buildGridRow(context, [
                  {
                    "onPress":
                        () => Navigator.pushNamed(context, "/prescriptions"),
                    "img_src": "assets/icon-images/note.svg",
                    "label": "My Prescriptions",
                    "color": Colors.black,
                    "backgroundColor": Colors.white,
                  },
                  {
                    "onPress":
                        () => Navigator.pushNamed(
                          context,
                          '/products',
                          arguments: {'category': 'Accessories'},
                        ),
                    "img_src": "assets/icon-images/accessories.svg",
                    "label": "Accessories",
                    "color": Colors.black,
                    "backgroundColor": KColors.orderLenses,
                  },
                ]),
                _buildGridRow(context, [
                  {
                    "onPress":
                        () => Navigator.pushNamed(
                          context,
                          '/products',
                          arguments: {'category': 'Lenses'},
                        ),
                    "img_src": "assets/icon-images/lenses.svg",
                    "label": "Lenses",
                    "color": Colors.black,
                    "backgroundColor": KColors.findUs,
                  },
                  {
                    "onPress":
                        () => Navigator.pushNamed(
                          context,
                          '/products',
                          arguments: {'category': 'Glasses'},
                        ),
                    "img_src": "assets/icon-images/glasses.svg",
                    "label": "Glasses",
                    "color": Colors.black,
                    "backgroundColor": Color.fromARGB(255, 233, 244, 248),
                  },
                ]),
              ],
            ),
          ),
        );
      case 1:
        return Services();
      case 2:
        return Profile(
          onUnAuthenticated: () {
            setState(() {
              _currentIndex = 0;
            });
            Navigator.pushNamed(
              context,
              "/login",
              arguments: {"origin": "/home", "redirect": "/home"},
            );
          },
        );
      case 3:
        return Notifications();
      default:
        return SizedBox.shrink();
    }
  }

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
                        onPress: data["onPress"],
                        shadowSize: context.percentageOfHeight(.08) * .9,
                        spacing:
                            context.responsiveExplicit(
                              fallback: 2,
                              onHeight: {555: 15},
                            )!,
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
              context.sm:
                  context.responsiveExplicit(fallback: 9, onHeight: {-580: 5})!,
              context.md:
                  context.responsiveExplicit(
                    //onWidth: {1300: 11},
                    onHeight: {-580: 5},
                    fallback: 9,
                  )!,
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
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("Home state init");
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("building homepage NOOOW! with user ${_user}");
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

    return AppbaDrawerScaffold(
      user: _user,
      onSideMenuItemTapped: (item) {
        switch (item) {
          case 3:
            setState(() {
              _currentIndex = 2;
            });
            Navigator.pop(context);
        }
      },
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(child: _getSelectedTab()),
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
