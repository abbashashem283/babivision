import 'dart:async';

import 'package:babivision/Utils/Auth.dart';
import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Time.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/data/ValueNotifiers.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/page-components/ErrorMessage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppointmentListDelegate extends StatefulWidget {
  final String serviceName;
  final String appointmentStatus;
  final String day;
  final String startTime;
  final String endTime;
  const AppointmentListDelegate({
    super.key,
    required this.serviceName,
    required this.appointmentStatus,
    required this.day,
    required this.startTime,
    required this.endTime,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPress: () {
            setState(() {
              _deleteVisible = true;
            });
            _hideDelete?.cancel();
            _hideDelete = Timer(
              Duration(seconds: 5),
              () => setState(() {
                _deleteVisible = false;
              }),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(
                context.responsive(sm: 0, md: 8),
              ),
            ),
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? service name
                      Text(
                        widget.serviceName,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: KColors.opaqueBlack20,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          widget.appointmentStatus,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  B(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 5,
                      children: [
                        B(
                          child: Text(
                            Time.displayFullDate(widget.day),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        B(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "${widget.startTime} - ${widget.endTime}",
                              style: TextStyle(color: Colors.white),
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
            duration: Duration(milliseconds: 200),
            width: double.infinity,
            height: (_deleteVisible || _deleteConfirmation) ? 40 : 0,
            color: Colors.red,
            child: Center(
              child: TextButton.icon(
                onPressed: null,
                label: Text("Delete", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.delete_forever, color: Colors.white),
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
  const AppointmentsList({super.key, required this.items, this.controller});

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
        separatorBuilder:
            (context, index) =>
                SizedBox(height: context.responsive(sm: 2, md: 20)),
        itemBuilder: (context, index) {
          final appointment = widget.items[index];
          final service = appointment["service"];
          final startTime = appointment['start_time'].substring(0, 5);
          final endTime = appointment['end_time'].substring(0, 5);
          return AppointmentListDelegate(
            serviceName: service["name"],
            appointmentStatus: appointment["status"],
            day: appointment["day"],
            startTime: startTime,
            endTime: endTime,
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
  bool _isLoading = true, _isError = false;

  ValueNotifier<bool> _showFAB = ValueNotifier(false);

  final ScrollController _controller = ScrollController();
  Timer? _hideTimer;
  List<dynamic>? _appointments;

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
    final id = user.value!['id'];
    try {
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
      debugPrint("setting state FAB");
      _showFAB.value = true;
      _hideTimer?.cancel();
      _hideTimer = Timer(Duration(seconds: 2), () {
        _showFAB.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late final Widget content;

    if (_isLoading)
      content = SizedBox.shrink();
    else if (_isError)
      content = Center(child: ErrorMessage(message: "An error has occured!"));
    else if (_appointments == null)
      content = Center(child: Text("No Appointments Found"));
    else
      //? appointment list
      content = Center(
        child: Container(
          //padding: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity.clamp(0, 700),
          child: AppointmentsList(
            items: _appointments ?? [],
            controller: _controller,
          ),
        ),
      );

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
          if (!_isLoading && (showFAB || _appointments == null))
            return FloatingActionButton(
              backgroundColor: Colors.purple[200],
              shape: CircleBorder(),
              onPressed: () {
                Navigator.pushNamed(context, '/appointments/book');
              },
              child: Text("+", style: TextStyle(fontSize: 25)),
            );
          return SizedBox.shrink();
        },
      ),
      body: Stack(
        children: [
          if (_isLoading)
            Container(
              color: KColors.opaqueBlack48,
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
          content,
        ],
      ),
    );
  }
}
