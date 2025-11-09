import 'package:babivision/Utils/UString.dart';
import 'package:babivision/Utils/Utils.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final Function()? onUnAuthenticated;
  const Profile({super.key, this.onUnAuthenticated});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    log("init pro");
  }

  Widget _buildListTile({required IconData icon, required String title}) {
    return Container(
      height: context.percentageOfHeight(.062),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.23),
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: B(
              inExpanded: true,
              child: Icon(
                icon,
                color: Colors.grey[600],
                size: context.fontSizeMin(19),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: B(
              inExpanded: true,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,

                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: context.fontSizeMin(16),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: B(
              inExpanded: true,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: context.fontSizeMin(17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: user,
      builder: (context, userValue, _) {
        if (userValue == null) {
          widget.onUnAuthenticated?.call();
          return SizedBox.shrink();
        }
        final user = userValue;
        return Center(
          child: B(
            color: "b",
            child: SizedBox(
              width: context.percentageOfWidth(.9).max(1000),
              child: Align(
                alignment: AlignmentGeometry.topCenter,
                child: B(
                  child: FractionallySizedBox(
                    heightFactor: .92,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: B(
                            color: "r",
                            inExpanded: true,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: context.fontSizeMin(75),
                                  height: context.fontSizeMin(75),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 171, 226, 236),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 40, 123, 137),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      context.fontSizeMin(75) / 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      Ustring.initials(user['name']),
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          40,
                                          123,
                                          137,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: context.responsiveExplicit(
                                          fallback: context.fontSizeAVG(25),
                                          onRatio: {
                                            .5: context.fontSizeMin(25),
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      user['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: context.responsiveExplicit(
                                          fallback: context.fontSizeAVG(20),
                                          onRatio: {
                                            .5: context.fontSizeMin(20),
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      user['email'],
                                      style: TextStyle(
                                        fontSize: context.fontSizeMin(16),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: B(
                            color: "r",
                            inExpanded: true,
                            child: Column(
                              //spacing: 6,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Account Information",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: context.fontSizeMin(17),
                                  ),
                                ),
                                SizedBox.shrink(),
                                _buildListTile(
                                  icon: Icons.edit,
                                  title: "Change Name",
                                ),
                                _buildListTile(
                                  icon: Icons.edit,
                                  title: "Change Password",
                                ),
                                _buildListTile(
                                  icon: Icons.calendar_month,
                                  title: "Appointments",
                                ),
                                _buildListTile(
                                  icon: Icons.medication_rounded,
                                  title: "Prescriptions",
                                ),
                                _buildListTile(
                                  icon: Icons.bug_report,
                                  title: "Report Bug",
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: B(
                            color: "r",
                            inExpanded: true,
                            child: Center(
                              child: FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    40,
                                    123,
                                    137,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: context.fontSizeMin(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
