import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Time.dart';
import 'package:babivision/Utils/Widgets.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/data/storage/Cache.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/CheckBox.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationListDelegate extends StatefulWidget {
  final String title;
  final String? subTitle;
  final String? clinic;
  final String? day;
  final String? time;

  const NotificationListDelegate({
    super.key,
    required this.title,
    this.subTitle,
    this.clinic,
    this.day,
    this.time,
  });

  @override
  State<NotificationListDelegate> createState() =>
      _NotificationListDelegateState();
}

class _NotificationListDelegateState extends State<NotificationListDelegate> {
  Widget _iconSubtitle({required IconData icon, required String label}) {
    return TextButton.icon(
      onPressed: null,
      icon: Icon(
        icon,
        color: Colors.amber[700],
        size: context.fontSizeMin(context.responsive(sm: 11, md: 12, lg: 14)),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.amber[700],
          fontSize: context.fontSizeMin(
            context.responsive(sm: 11, md: 12, lg: 14),
          ),
        ),
      ),
    );
  }

  Widget get _divider {
    return SizedBox(
      height: 15,
      child: B(
        color: "tr",
        child: VerticalDivider(
          color: Colors.amber[700],
          width: context.responsive(sm: 1, md: 5, lg: 10),
          thickness: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[200],
      height: context.percentageOfHeight(.12),
      child: B(
        color: "r",
        child: Row(
          children: [
            B(
              inExpanded: false,
              color: "p",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
            Expanded(
              child: B(
                inExpanded: true,
                color: "p",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: context.fontSizeMin(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   widget.subTitle ?? "",
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(
                    //     color: Colors.amber[700],
                    //     fontSize: context.fontSizeMin(16),
                    //   ),
                    // ),
                    B(
                      color: "tr",
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _iconSubtitle(
                            icon: Icons.calendar_month,
                            label: widget.day ?? "",
                          ),
                          _divider,
                          B(
                            color: "tr",
                            child: _iconSubtitle(
                              icon: Icons.access_time,
                              label: widget.time ?? "",
                            ),
                          ),
                          _divider,
                          _iconSubtitle(
                            icon: Icons.location_on,
                            label: widget.clinic ?? "",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            B(
              inExpanded: false,
              color: "p",
              child: SizedBox(
                height: double.infinity,
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
  final ScrollController controller;
  const NotificationList({
    super.key,
    required this.items,
    required this.controller,
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: Colors.amber[900]!,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final title = (item['service'])['name'];
            final day = item['day'];
            final time = item['start_time'].substring(0, 5);
            final clinic = (item['clinic'])['name'];
            //final title = item['day'];
            return NotificationListDelegate(
              title: title,
              day: day,
              time: time,
              clinic: clinic,
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 2),
          itemCount: widget.items.length,
          padding: EdgeInsets.only(bottom: 50),
          physics: AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
        ),
      ),
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
  List? _appointments;
  bool _isLoading = false;
  bool _isError = false;
  bool _prefrencesLoading = false;
  bool _dialogShown = false;
  bool _dialogDontShow = false;

  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchAppointments() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    //List appointments;
    // final cachedAppointments = await HiveStorage().read("appointments_tmw");
    // if (cachedAppointments != null) {
    //   appointments = cachedAppointments;
    // } else {
    //   final String tommorow = Time.addDays(Time.today.day, 2);
    //   debugPrint("tmw is $tommorow");
    //   final response = await Http.get(
    //     "/api/appointments?user=${user.value!['id']}&at_day=$tommorow",
    //     isAuth: true,
    //   );
    //   appointments = response.data['appointments'];
    //   await HiveStorage().write("appointments_tmw", appointments);
    // }

    final appointments = await Cache.get(
      "appointments_tmw",
      onExpiredOrNull: () async {
        final String tommorow = Time.addDays(Time.today.day, 2);
        debugPrint("tmw is $tommorow");
        final response = await Http.get(
          "/api/appointments?user=${user.value!['id']}&at_day=$tommorow",
          isAuth: true,
        );
        return response.data['appointments'];
      },
      ttl: 60,
    );

    if (mounted)
      setState(() {
        _isLoading = false;
        _appointments = appointments;
      });
  }

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPreferences();
    if (user.value != null) _fetchAppointments();
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
                              initialValue: _dialogDontShow,
                              activeColor: Colors.amber,
                              onValueChanged:
                                  (value) => setState(() {
                                    _dialogDontShow = value;
                                  }),
                            ),
                            Text("Don't show this again"),
                          ],
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            debugPrint("_dialogDontShow: $_dialogDontShow");
                            prefs.setBool(
                              "showNotificationDialog",
                              !_dialogDontShow,
                            );
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

    Widget content = SizedBox.shrink();

    if (_isLoading) {
      content = StackLoadingIndicator(
        indicator: SpinKitWave(size: 24, color: Colors.amber[700]),
      );
    } else if (_isError) {
      content = Center(
        child: TextButton.icon(
          onPressed: null,
          label: Text(
            "An Error Has Occured!",
            style: TextStyle(
              color: Colors.red,
              fontSize: context.fontSizeMin(24),
            ),
          ),
          icon: Icon(
            Icons.error,
            color: Colors.red,
            size: context.fontSizeMin(26),
          ),
        ),
      );
    } else if (_appointments == null || _appointments!.isEmpty) {
      content = Center(
        child: TextButton.icon(
          onPressed: null,
          label: Text(
            "No notifications!",
            style: TextStyle(
              color: Colors.amber[700],
              fontSize: context.fontSizeMin(24),
            ),
          ),
          icon: Icon(
            Icons.notifications,
            size: context.fontSizeMin(26),
            color: Colors.amber[700],
          ),
        ),
      );
    } else {
      content = B(
        child: Scrollbar(
          thickness: context.responsiveExplicit(
            fallback: 5,
            onWidth: {1000: 15},
          ),
          thumbVisibility: context.responsiveExplicit(
            fallback: false,
            onWidth: {1000: true},
          ),
          trackVisibility: context.responsiveExplicit(
            fallback: false,
            onWidth: {1000: true},
          ),
          controller: _scrollController,
          child: Center(
            child: SizedBox(
              width: double.infinity.max(1000),
              height: double.infinity,
              child: NotificationList(
                controller: _scrollController,
                items: _appointments ?? [],
              ),
            ),
          ),
        ),
      );
    }

    return content;
  }
}
