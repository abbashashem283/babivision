import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

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
                child: Expanded(
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
                        size: context.fontSizeMin(30),
                      ),
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
                        fontSize: context.fontSizeMin(22),
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
                child: Expanded(
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
  @override
  Widget build(BuildContext context) {
    return B(
      child: SizedBox(
        width: double.infinity.max(1000),
        height: double.infinity,
        child: NotificationList(items: [1, 2, 3]),
      ),
    );
  }
}
