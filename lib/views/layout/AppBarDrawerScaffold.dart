import 'package:babivision/Utils/Auth.dart';
import 'package:babivision/Utils/UString.dart';
import 'package:babivision/Utils/popups/Utils.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/views/popups/Snackbars.dart';
import 'package:flutter/material.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:flutter_svg/svg.dart';

class AppbaDrawerScaffold extends StatefulWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Function(int item)? onSideMenuItemTapped;
  final Map<String, dynamic>? user;
  const AppbaDrawerScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.user,
    this.onSideMenuItemTapped,
  });

  @override
  State<AppbaDrawerScaffold> createState() => _AppbaDrawerScaffoldState();
}

class _AppbaDrawerScaffoldState extends State<AppbaDrawerScaffold> {
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Auth.user();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: user,
      builder: (context, userValue, _) {
        Widget _buildDrawerTile({
          required IconData icon,
          required Color iconColor,
          required String label,
          required Function()? onClick,
        }) {
          return ListTile(
            leading: Icon(icon, size: 35, color: iconColor),
            onTap: onClick,
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
            spacing: context.responsiveOrientation(
              fallback: 0,
              onLandscape: 15,
            ),
            children: [
              _buildDrawerTile(
                icon: Icons.info,
                iconColor: KColors.aboutUsIcon,
                label: "About Us",
                onClick: () => Navigator.pushNamed(context, "/about"),
              ),

              _buildDrawerTile(
                icon: Icons.message_rounded,
                iconColor: KColors.contactIcon,
                label: "Contact / Support",
                onClick:
                    () => Navigator.pushNamed(
                      context,
                      "/contact",
                      arguments: {
                        "title": "We’d love to hear from you 👋",
                        "feedbackType": "feedback",
                        "subTitle":
                            "Send us a message and we’ll get back to you as soon as possible.",
                        "appBarTitle": "Contact",
                      },
                    ),
              ),
              _buildDrawerTile(
                icon: Icons.article,
                iconColor: Colors.orange,
                label: "Terms & Privacy",
                onClick: () => Navigator.pushNamed(context, "/terms"),
              ),
              Divider(),
              _buildDrawerTile(
                icon:
                    (userValue == null)
                        ? Icons.app_registration_sharp
                        : Icons.person,
                iconColor: Colors.blue[700]!,
                label: (userValue == null) ? "Register" : "My Account",
                onClick: () {
                  if (userValue == null) {
                    Navigator.pushNamed(context, "/register");
                    return;
                  }
                  widget.onSideMenuItemTapped?.call(3);
                },
              ),
              _buildDrawerTile(
                icon:
                    (userValue == null)
                        ? Icons.login_outlined
                        : Icons.logout_outlined,
                iconColor: (userValue == null) ? Colors.blue[700]! : Colors.red,
                label: (userValue == null) ? "Login" : "Logout",
                onClick: () async {
                  if (userValue == null) {
                    Navigator.pushNamed(
                      context,
                      '/login',
                      arguments: {"origin": "/home", "redirect": "/home"},
                    );
                  } else {
                    if (!mounted) return;
                    setState(() {
                      _isLoading = true;
                    });
                    final logout = await Auth.logout();
                    //debugPrint("logout response $logout");
                    setState(() {
                      _isLoading = false;
                    });
                    if (logout["type"] == "error") {
                      showSnackbar(
                        context: context,
                        snackBar: TextSnackBar.error(
                          message: "Couldn't log out",
                        ),
                      );
                    }
                    if (logout["type"] == "success") {
                      showSnackbar(
                        context: context,
                        snackBar: TextSnackBar.success(
                          message: "Log out successful",
                        ),
                      );
                      user.value = null;
                    }
                  }
                },
              ),
            ],
          );
        }

        Widget _buildDrawer() {
          if (_isLoading)
            return SafeArea(child: Center(child: CircularProgressIndicator()));

          String name = (userValue == null) ? "Guest" : userValue?['name'];
          String initials =
              (userValue == null) ? "?" : Ustring.initials(userValue?['name']);

          return SafeArea(
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
                            ((context.percentageOfWidth(.2) / 2) /
                                    context.ratio)
                                .clamp(50, 75),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      Text(name, style: TextStyle(fontSize: 25)),
                      if (userValue != null)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            userValue?['email'],
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
          );
        }

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
                                size: context
                                    .percentageOfWidth(.1)
                                    .clamp(20, 50),
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
                              width: context
                                  .percentageOfWidth(.2)
                                  .clamp(120, 150),

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
          drawer: _buildDrawer(),
          body: widget.body,
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
        );
      },
    );
  }
}
