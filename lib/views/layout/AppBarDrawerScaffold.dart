import 'package:babivision/data/KConstants.dart';
import 'package:flutter/material.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:flutter_svg/svg.dart';

class AppbaDrawerScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  const AppbaDrawerScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
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
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
