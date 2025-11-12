import 'package:babivision/Utils/Auth.dart';
import 'package:babivision/Utils/UString.dart';
import 'package:babivision/Utils/Utils.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/Utils/popups/Utils.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:babivision/views/popups/Snackbars.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final Function()? onUnAuthenticated;
  const Profile({super.key, this.onUnAuthenticated});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;

  Future<void> _loginCheck() async {
    final user = await Auth.user();
    if (user == null && mounted) widget.onUnAuthenticated?.call();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _loginCheck();
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Function()? onPress,
  }) {
    return Container(
      height: context.percentageOfHeight(.062),
      decoration: BoxDecoration(
        //color: Colors.white,
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
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPress,
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  color: Colors.grey[600],
                  size: context.fontSizeMin(19),
                ),
              ),
              Expanded(
                flex: 8,
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
              Expanded(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: context.fontSizeMin(17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? StackLoadingIndicator.regular()
        : ValueListenableBuilder(
          valueListenable: user,
          builder: (context, userValue, _) {
            if (userValue == null) {
              return SizedBox.shrink();
            }
            final user = userValue;
            return Center(
              child: SizedBox(
                width: context.percentageOfWidth(.9).max(1000),
                child: Align(
                  alignment: AlignmentGeometry.topCenter,
                  child: FractionallySizedBox(
                    heightFactor: .92,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: context.fontSizeMin(75),
                                height: context.fontSizeMin(75),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 171, 226, 236),
                                  border: Border.all(
                                    color: KColors.profileBlue,
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
                                      overflow: TextOverflow.ellipsis,
                                      color: KColors.profileBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: context.responsiveExplicit(
                                        fallback: context.fontSizeAVG(25),
                                        onRatio: {.5: context.fontSizeMin(25)},
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
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: context.responsiveExplicit(
                                        fallback: context.fontSizeAVG(20),
                                        onRatio: {.5: context.fontSizeMin(20)},
                                      ),
                                    ),
                                  ),
                                  Text(
                                    user['email'],
                                    style: TextStyle(
                                      fontSize: context.fontSizeMin(16),
                                      color: Colors.grey[600],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 6,
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
                                title: "Change Password",
                                onPress:
                                    () => Navigator.pushNamed(
                                      context,
                                      "/password/change",
                                      arguments: {"origin": "/home"},
                                    ).then((passwordReset) {
                                      if (!mounted) return;
                                      if (passwordReset != null) {
                                        passwordReset as bool;
                                        if (passwordReset) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Password Changed"),
                                                content: Text(
                                                  "Since you have changed your password, you must logout",
                                                ),
                                                actions: [
                                                  FilledButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      await Auth.logout();
                                                      if (!mounted) return;
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      widget.onUnAuthenticated
                                                          ?.call();
                                                    },
                                                    child: Text("Confirm"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    }),
                              ),
                              _buildListTile(
                                icon: Icons.calendar_month,
                                title: "Appointments",
                                onPress:
                                    () => Navigator.pushNamed(
                                      context,
                                      "/appointments",
                                    ),
                              ),
                              _buildListTile(
                                icon: Icons.medication_rounded,
                                title: "Prescriptions",
                              ),
                              _buildListTile(
                                icon: Icons.report_sharp,
                                title: "File a Complaint",
                                onPress:
                                    () => Navigator.pushNamed(
                                      context,
                                      "/contact/complaint",
                                      arguments: {
                                        "feedbackType": "complaint",
                                        "title": "File a Complaint 🗣️",
                                        "subTitle":
                                            "In case of any mistreatement or wrongdoing, be free to file a complaint so we can resolve the issue",
                                        "appBarTitle": "Complaint",
                                        "successMessage": "Compalint Filed!",
                                        "submitButtonText": "File Complaint",
                                        "name": user['name'],
                                        "email": user['email'],
                                      },
                                    ),
                              ),
                              _buildListTile(
                                icon: Icons.bug_report,
                                title: "Report Bug",
                                onPress:
                                    () => Navigator.pushNamed(
                                      context,
                                      "/contact/bug",
                                      arguments: {
                                        "feedbackType": "bug",
                                        "title": "Report a Bug 🐞",
                                        "subTitle":
                                            "Tell us about any software issues or bugs you have encountered!",
                                        "appBarTitle": "Bug Report",
                                        "successMessage": "Bug Reported!",
                                        "submitButtonText": "Report Bug",
                                        "name": user['name'],
                                        "email": user['email'],
                                      },
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: FilledButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text("Log Out"),
                                        content: Text(
                                          "Are you sure you want to log out?",
                                        ),
                                        actions: [
                                          FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  KColors.profileBlue,
                                            ),
                                            onPressed: () async {
                                              if (mounted)
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                              final data = await Auth.logout();
                                              if (!mounted) return;
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              log(data);
                                              if (data["type"] == "success") {
                                                Navigator.pop(context);
                                                widget.onUnAuthenticated
                                                    ?.call();
                                                return;
                                              }
                                              showSnackbar(
                                                context: context,
                                                snackBar: TextSnackBar.error(
                                                  message: "Logout Failed",
                                                ),
                                              );
                                              if (mounted)
                                                Navigator.pop(context);
                                            },
                                            child: Text("Yes"),
                                          ),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  KColors.profileBlue,
                                              side: BorderSide(
                                                color: KColors.profileBlue,
                                              ),
                                            ),
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: Text("No"),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: KColors.profileBlue,
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
  }
}
