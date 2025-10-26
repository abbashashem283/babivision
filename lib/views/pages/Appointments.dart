import 'dart:async';

import 'package:babivision/Utils/Auth.dart';
import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Time.dart';
import 'package:babivision/Utils/Widgets.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/Utils/popups/Utils.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/page-components/ErrorMessage.dart';
import 'package:babivision/views/popups/Snackbars.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppointmentListDelegate extends StatefulWidget {
  final bool isLastItem;
  final String serviceName;
  final String appointmentStatus;
  final String day;
  final String startTime;
  final String endTime;
  final Function()? onDelete;
  final Function()? onLongPress;
  const AppointmentListDelegate({
    super.key,
    required this.isLastItem,
    required this.serviceName,
    required this.appointmentStatus,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.onDelete,
    this.onLongPress,
  });

  @override
  State<AppointmentListDelegate> createState() =>
      _AppointmentListDelegateState();
}

class _AppointmentListDelegateState extends State<AppointmentListDelegate> {
  bool _deleteVisible = false, _deleteConfirmation = false;
  Timer? _hideDelete;

  @override
  Widget build(BuildContext context) {
    final dateTimeTextSize = context.responsiveExplicit(
      fallback: context.percentageOfHeight(.017),
      onRatio: {
        .39: context.percentageOfHeight(.019),
        .45: context.percentageOfHeight(.02),
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPress: () {
            widget.onLongPress?.call();
            setState(() {
              _deleteVisible = true;
            });
            _hideDelete?.cancel();
            _hideDelete = Timer(Duration(seconds: 5), () {
              if (mounted)
                setState(() {
                  _deleteVisible = false;
                });
            });
          },
          child: Container(
            width: double.infinity,
            height: context.percentageOfHeight(.12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(
                context.responsive(sm: 0, md: 8),
              ),
            ),
            child: SizedBox(
              //height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex:
                        context.responsiveExplicit(
                          fallback: 1,
                          onWidth: {380: 55},
                        )!,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? service name
                        Text(
                          widget.serviceName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: context.percentageOfHeight(.022),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: KColors.opaqueBlack20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            widget.appointmentStatus,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.percentageOfHeight(.022),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex:
                        context.responsiveExplicit(
                          fallback: 1,
                          onWidth: {380: 45},
                        )!,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 5,
                      children: [
                        Text(
                          Time.displayFullDate(widget.day),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: dateTimeTextSize,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "${widget.startTime} - ${widget.endTime}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: dateTimeTextSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _deleteConfirmation = true;
            });
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Cancel Appointment"),
                  content: Text(
                    "Do you really wish to cancel you appointment ${widget.day} @ ${widget.startTime}?",
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _deleteConfirmation = false;
                        });
                        Navigator.pop(context);
                        widget.onDelete?.call();
                      },
                      child: Text("Yes"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _deleteConfirmation = false;
                        });

                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                  ],
                );
              },
            );
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: widget.isLastItem ? 0 : 200),
            width: double.infinity.clamp(0, 690),
            height: (_deleteVisible || _deleteConfirmation) ? 40 : 0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: context.responsiveExplicit(
                fallback: null,
                onWidth: {
                  700: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                },
              ),
            ),
            child: Center(
              child: TextButton.icon(
                onPressed: null,
                label: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.percentageOfWidth(.05).clamp(0, 30),
                  ),
                ),
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: context.percentageOfWidth(.05).clamp(0, 30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppointmentsList extends StatefulWidget {
  final List items;
  final ScrollController? controller;
  final Function(int id, int index)? onAppointmentDeleted;
  final Function(int index)? onItemLongPress;
  final EdgeInsetsGeometry? padding;
  const AppointmentsList({
    super.key,
    required this.items,
    this.controller,
    this.onAppointmentDeleted,
    this.onItemLongPress,
    this.padding,
  });

  @override
  State<AppointmentsList> createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: Colors.white,
      child: ListView.separated(
        itemCount: widget.items.length,
        controller: widget.controller,
        padding: widget.padding,
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 2),
        itemBuilder: (context, index) {
          final appointment = widget.items[index];
          final service = appointment["service"];
          final startTime = appointment['start_time'].substring(0, 5);
          final endTime = appointment['end_time'].substring(0, 5);
          return AppointmentListDelegate(
            isLastItem: index == widget.items.length - 1,
            key: ValueKey(appointment['id']),
            serviceName: service["name"],
            appointmentStatus: appointment["status"],
            day: appointment["day"],
            startTime: startTime,
            endTime: endTime,
            onLongPress: () => widget.onItemLongPress?.call(index),
            onDelete:
                () =>
                    widget.onAppointmentDeleted?.call(appointment["id"], index),
          );
        },
      ),
    );
  }
}

//?page
class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  bool _isLoading = true,
      _isMiniLoading = false,
      _isError = false,
      _showBottomListPadding = false;
  ValueNotifier<bool> _showFAB = ValueNotifier(false);
  final ScrollController _controller = ScrollController();
  Timer? _hideTimer;
  List<dynamic>? _appointments;

  bool get _noAppointments {
    return (_appointments == null) || (_appointments!.isEmpty);
  }

  Future<Response<dynamic>?> _fetchAppointments() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    await Auth.user();
    if (user.value == null && mounted)
      Navigator.pushNamed(
        context,
        '/login',
        arguments: {"origin": '/appointments', "redirect": '/appointments'},
      );
    final id = user.value?['id'];
    try {
      if (id == null) return null;
      final response = await Http.get(
        "/api/appointments?user=$id",
        isAuth: true,
      );
      final appointments = response.data["appointments"];
      debugPrint(
        "appointments from server for $id ${response.data.toString()} ${appointments.toString()}",
      );
      if (mounted)
        setState(() {
          _isLoading = false;
          _appointments = appointments;
        });
    } catch (e) {
      if (e is MissingTokenException || e is AuthenticationFailedException) {
        if (mounted)
          Navigator.pushNamed(
            context,
            '/login',
            arguments: {"origin": '/appointments', "redirect": '/appointments'},
          );
      }
      if (mounted) debugPrint(e.toString());
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  Future<void> _deleteAppointment(int id, int index) async {
    debugPrint("deleting appointment $id");

    if (mounted)
      setState(() {
        _isMiniLoading = true;
      });

    try {
      final deleteResponse = await Http.post("/api/appointments/delete", {
        'id': id,
        'user_id': user.value?['id'],
      }, isAuth: true);
      final data = deleteResponse.data;
      debugPrint("${data.toString()}");
      if (data["type"] == "error" || data["errors"] != null) {
        if (mounted)
          showSnackbar(
            context: context,
            snackBar: TextSnackBar.error(message: data["message"]),
          );
        return;
      }
      if (mounted) {
        showSnackbar(
          context: context,
          snackBar: TextSnackBar.success(message: "Appointment Cancelled!"),
        );
        _appointments?.removeAt(index);
      }
      if (mounted)
        setState(() {
          _isMiniLoading = false;
        });
    } catch (e) {
      if (e is MissingTokenException || e is AuthenticationFailedException) {
        if (mounted)
          Navigator.pushNamed(
            context,
            '/login',
            arguments: {"origin": '/appointments', "redirect": '/appointments'},
          );
      } else {
        rethrow;
      }
    }
    return null;
  }

  void _manageFAB() {
    debugPrint("setting state FAB");
    _showFAB.value = true;
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 2), () {
      _showFAB.value = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAppointments();
    _controller.addListener(() {
      _manageFAB();
    });
  }

  @override
  Widget build(BuildContext context) {
    late final Widget content;

    if (_isLoading)
      content = SizedBox.shrink();
    else if (_isError)
      content = Center(child: ErrorMessage(message: "An error has occured!"));
    else if (_noAppointments)
      content = Center(child: Text("No Appointments Found"));
    else {
      //? appointment list
      List items = _appointments ?? [];
      content = Center(
        child: B(
          child: Container(
            //padding: EdgeInsets.only(left: 20, right: 20),
            color: Color.fromARGB(255, 236, 160, 248),
            width: double.infinity.clamp(0, 700),
            child: AppointmentsList(
              items: items,
              controller: _controller,
              padding:
                  _showBottomListPadding ? EdgeInsets.only(bottom: 40) : null,
              onItemLongPress: (index) {
                final bool isLastItem = index == (items.length - 1);
                if (isLastItem) {
                  onPostFrame((_) {
                    final toOffset = _controller.position.maxScrollExtent;
                    debugPrint(
                      "offset scroll ${_controller.offset} | toOffset $toOffset",
                    );
                    _controller.animateTo(
                      toOffset + (140 - toOffset),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  });
                }
              },
              onAppointmentDeleted:
                  (id, index) => _deleteAppointment(id, index),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Appointments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _showFAB,
        builder: (context, showFAB, _) {
          if (!_isLoading && (showFAB || _noAppointments))
            return SizedBox(
              child: FloatingActionButton(
                backgroundColor: Colors.purple[200],
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/appointments/book');
                },
                child: Text("+", style: TextStyle(fontSize: 25)),
              ),
            );
          return SizedBox.shrink();
        },
      ),
      body: GestureDetector(
        onTap: () {
          _manageFAB();
        },
        onPanStart: (_) {
          _manageFAB();
        },
        child: Stack(
          children: [
            content,

            if (_isLoading || _isMiniLoading)
              Container(
                color: KColors.opaqueBlack20,
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
