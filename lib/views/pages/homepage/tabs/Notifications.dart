import 'package:babivision/Utils/Widgets.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/CheckBox.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationListDelegate extends StatefulWidget {
  const NotificationListDelegate({super.key});

  @override
  State<NotificationListDelegate> createState() =>
      _NotificationListDelegateState();
}

class _NotificationListDelegateState extends State<NotificationListDelegate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[200],
      height: context.percentageOfHeight(.12),
      child: B(
        color: "r",
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: B(
                inExpanded: true,
                color: "p",
                child: Center(
                  child: Container(
                    width: context.fontSizeMin(60),
                    height: context.fontSizeMin(60),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      border: Border.all(color: Colors.amber[700]!),
                      borderRadius: BorderRadius.circular(
                        context.fontSizeMin(60) / 2,
                      ),
                    ),
                    child: Icon(
                      Icons.medication,
                      color: Colors.amber[700],
                      size: context.fontSizeMin(25),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: B(
                inExpanded: true,
                color: "p",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Title Sample",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: context.fontSizeMin(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "subtitle sample",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: context.fontSizeMin(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: B(
                inExpanded: true,
                color: "p",
                child: Material(
                  color: Colors.amber[200],
                  child: InkWell(
                    onTap: () {},
                    splashColor: Colors.red[500],
                    child: Icon(
                      Icons.cancel,
                      size: context.fontSizeMin(30),
                      color: Colors.amber[700],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatefulWidget {
  final List items;
  const NotificationList({super.key, required this.items});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => NotificationListDelegate(),
      separatorBuilder: (context, index) => SizedBox(height: 2),
      itemCount: widget.items.length,
    );
  }
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late final SharedPreferences prefs;
  bool _isLoading = false;
  bool _prefrencesLoading = false;
  bool _dialogShown = false;
  bool _dialogDontShow = false;

  Future<void> _fetchPreferences() async {
    setState(() {
      _prefrencesLoading = true;
    });
    final prefrences = await SharedPreferences.getInstance();
    if (prefrences.getBool("showNotificationDialog") == null)
      await prefrences.setBool("showNotificationDialog", true);
    setState(() {
      prefs = prefrences;
      _prefrencesLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPreferences();
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefrencesLoading) {
      bool showNotificationDialog =
          prefs.getBool("showNotificationDialog") ?? false;
      if (showNotificationDialog && user.value == null && !_dialogShown) {
        _dialogShown = true;
        onPostFrame((_) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("User Notifications!"),
                //actionsAlignment: MainAxisAlignment.start,
                content: Text(
                  "You are not logged in so you won't be capable of viewing user related notifications",
                ),
                actions: [
                  Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CheckBox(
                              initialValue: false,
                              activeColor: Colors.amber,
                            ),
                            Text("Don't show this again"),
                          ],
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.amber[800],
                          ),
                          child: Text("confirm"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
      }
    }

    return B(
      child: SizedBox(
        width: double.infinity.max(1000),
        height: double.infinity,
        child: NotificationList(items: [1, 2, 3]),
      ),
    );
  }
}
