import 'dart:convert';

import 'package:babivision/Utils/Auth.dart';
import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Time.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/Utils/popups/Utils.dart';
import 'package:babivision/controllers/AppointmentManager.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/models/Clinic.dart';
import 'package:babivision/models/Service.dart';
import 'package:babivision/views/popups/Snackbars.dart';
import 'package:dio/dio.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SlotButton extends StatefulWidget {
  final bool active;
  final String label;
  final void Function()? onPressed;
  const SlotButton({
    super.key,
    required this.label,
    this.active = false,
    this.onPressed,
  });

  @override
  State<SlotButton> createState() => _SlotButtonState();
}

class _SlotButtonState extends State<SlotButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Color get _foreGroundColor {
    return widget.active ? Colors.white : KColors.selectedSlot;
  }

  Color? get _backgroundColor {
    return widget.active ? KColors.selectedSlot : null;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: _foreGroundColor,
        backgroundColor: _backgroundColor,
        side: BorderSide(color: Colors.purple),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        // setState(() {
        //   _isActive = !_isActive;
        // });
        if (widget.onPressed != null) widget.onPressed!();
      },
      child: Text(widget.label),
    );
  }
}

class AppointmentSlots extends StatefulWidget {
  final List<dynamic> appointments;
  final String? selectedAppointment;
  final Function(String appointment) onAppointmentSelected;
  const AppointmentSlots({
    super.key,
    required this.appointments,
    required this.onAppointmentSelected,
    this.selectedAppointment,
  });

  @override
  State<AppointmentSlots> createState() => _AppointmentSlotsState();
}

class _AppointmentSlotsState extends State<AppointmentSlots> {
  String? _selectedAppointment;
  String? _visibleDate;

  Widget _buildCalendarTitle({required String date}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: Text(
        date,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListDelegate({
    required String displayDate,
    required String day,
    required List slots,
  }) {
    return VisibilityDetector(
      key: Key(displayDate),
      onVisibilityChanged: (info) {
        double top = info.visibleBounds.top;
        double height = info.size.height;
        if (top > 0 && (_visibleDate == null || _visibleDate != displayDate)) {
          setState(() {
            _visibleDate = displayDate;
          });
        }
        if (info.visibleBounds == Rect.zero) {
          setState(() {
            _visibleDate = null;
          });
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: double.infinity.clamp(100, 700),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VisibilityDetector(
                  key: Key('$displayDate!title'),
                  onVisibilityChanged: (info) {
                    if (info.visibleBounds == Rect.zero) {
                      // setState(() {
                      //   _visibleDate = displayDate;
                      // });
                    }
                  },
                  child: _buildCalendarTitle(date: displayDate),
                ),
                Container(
                  width: double.infinity,
                  //height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount:
                        context.responsiveExplicit(
                          fallback: 3,
                          onWidth: {500: 4},
                        )!, // number of columns
                    mainAxisSpacing: 10, // vertical spacing
                    crossAxisSpacing: 10, // horizontal spacing hohohoh
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    children: List.generate(slots.length, (index) {
                      String slot = slots[index];
                      String currentAppointment = '$day $slot';
                      bool slotActive =
                          currentAppointment == _selectedAppointment;

                      return SlotButton(
                        label: slot,
                        active: slotActive,
                        onPressed: () {
                          setState(() {
                            _selectedAppointment = currentAppointment;
                          });
                          widget.onAppointmentSelected(currentAppointment);
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedAppointment = widget.selectedAppointment;
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.appointments.length;
    return Stack(
      children: [
        GlowingOverscrollIndicator(
          color: Colors.purple,
          axisDirection: AxisDirection.down,
          child: ListView.separated(
            itemCount: itemCount,
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              final appointment = widget.appointments[index];
              return _buildListDelegate(
                displayDate: appointment["displayDate"],
                day: appointment["day"],
                slots: appointment["appointments"],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 50),
          ),
        ),

        _visibleDate != null
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.purple,
                ),
                child: Text(
                  _visibleDate!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ) //_buildCalendarTitle(date: _visibleDate!)
            : SizedBox.shrink(),
      ],
    );
  }
}

class AppointmentBooker extends StatefulWidget {
  final Service? service;
  final Clinic? clinic;
  const AppointmentBooker({super.key, this.service, this.clinic});

  @override
  State<AppointmentBooker> createState() => _AppointmentBookerState();
}

class ComboPlaceHolder {
  final int id;
  final String name;
  ComboPlaceHolder({required this.id, required this.name});
}

class _AppointmentBookerState extends State<AppointmentBooker> {
  String? _appointment;

  final ComboPlaceHolder _noServicePlaceHolder = ComboPlaceHolder(
    id: -1,
    name: "- select a service -",
  );

  final ComboPlaceHolder _noClinicPlaceHolder = ComboPlaceHolder(
    id: -1,
    name: "- select a clinic -",
  );

  late dynamic _selectedService;
  late dynamic _selectedClinic;
  Future<Response<dynamic>>? _appointmentFetcher;
  AppointmentManager? _appointmentController;
  List<Service>? _services;
  List<Clinic>? _clinics;

  bool _isLoading = true, _isError = false, _isDone = false, _isBooking = false;

  Future<Response<dynamic>> fetchAppointments({
    required startDay,

    required clinic,
  }) async {
    //debugPrint("fetch data $startDay  $clinic");
    return Http.get(
      "/api/appointments?startDay=$startDay&clinic=$clinic",
      isAuth: true,
    );
  }

  String get optionUnselectedSvgUrl {
    if (_selectedService.id == -1) return "assets/icon-images/no-service.svg";
    if (_selectedClinic.id == -1) return "assets/icon-images/no-clinic.svg";
    return "";
  }

  Widget _buildPageError(String message) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 150, color: Colors.red),
          Text(message, style: TextStyle(color: Colors.red, fontSize: 32)),
        ],
      ),
    );
  }

  Widget _buildCombo({
    required dynamic value,
    required ComboPlaceHolder placeHolder,
    required List items,
    required void Function(Object?) onChanged,
  }) {
    List itemsWPlaceHolder = [placeHolder, ...items];

    TextStyle getTextStyle(int id) {
      return TextStyle(
        color: id == -1 ? Colors.grey : Colors.black,
        fontStyle: id == -1 ? FontStyle.italic : FontStyle.normal,
        fontSize: context.responsiveExplicit(
          fallback: 9,
          onWidth: {
            350: 10,
            400: 11,
            450: 12,
            500: 14,
            600: 16,
            700: 18,
            800: 20,
            1000: 22,
          },
        ),
      );
    }

    return DropdownButton(
      value: value,
      isExpanded: true,
      alignment: Alignment.center,
      selectedItemBuilder: (context) {
        return itemsWPlaceHolder.map((item) {
          return Center(child: Text(item.name, style: getTextStyle(item.id)));
        }).toList();
      },
      items:
          itemsWPlaceHolder
              .map(
                (item) => DropdownMenuItem(
                  //alignment: Alignment.center,
                  value: item,
                  child: Text(item.name, style: getTextStyle(item.id)),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }

  void get _getServicesWClinics async {
    ////debugPrint("getting services + clinics");
    if (_services != null && _clinics != null) return;
    if (mounted) {
      setState(() {
        _isLoading = true;
        _isDone = false;
        _isError = false;
      });
    }
    try {
      final servicesResponse = await Http.get("/api/services", isAuth: true);
      final clinicsResponse = await Http.get("/api/clinics", isAuth: true);
      // //debugPrint(
      //   "clinics and services response ${servicesResponse.toString()}",
      // );
      final Map<String, dynamic> jsonServices = jsonDecode(
        servicesResponse.toString(),
      );
      // ////debugPrint(jsonServices.toString());
      final Map<String, dynamic> jsonClinics = jsonDecode(
        clinicsResponse.toString(),
      );
      ////debugPrint("1");
      List<Service> services =
          (jsonServices["services"] as List)
              .map((service) => Service.fromJson(service))
              .toList();
      ////debugPrint("2");
      List<Clinic> clinics =
          (jsonClinics["clinics"] as List)
              .map((clinic) => Clinic.fromJson(clinic))
              .toList();
      ////debugPrint("3");

      _services = services;
      _clinics = clinics;

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isDone = true;
          _isError = false;
        });
      }
    } on Exception catch (e) {
      // TODO
      //debugPrint("caught must _isError");
      if (e is MissingTokenException || e is AuthenticationFailedException) {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            "/login",
            arguments: {
              "origin": "/appointments/book",
              "redirect": "/appointments/book",
              "redirectData": {
                "service": _selectedService,
                "clinic": _selectedClinic,
              },
            },
          );
        }
      }
    }
  }

  Future<Response<dynamic>?> _bookAppointment() async {
    //get user based on login
    List<String> appointmentAsList = _appointment!.split(" ");
    final clinic = _selectedClinic.id;
    final service = _selectedService.id;
    final day = appointmentAsList[0];
    final time = appointmentAsList[1];
    final String? optician = _appointmentController!.bookOptician(day, time);
    if (optician == null) return null;
    try {
      final user = await Auth.user();
      //final user = userResponse.data['user'];
      //useeeeeeeeeeeeeeer

      final postData = {
        "user_id": user?['id'],
        "optician_id": optician,
        "service_id": service,
        "clinic_id": clinic,
        "day": day,
        "start_time": time,
        "end_time": Time.addMinutes(time, _selectedService.durationMin),
      };
      //debugPrint(postData.toString());
      return Http.post("/api/appointments/book", postData, isAuth: true);
    } catch (e) {
      if (e is MissingTokenException || e is AuthenticationFailedException) {
        if (mounted)
          Navigator.pushReplacementNamed(
            context,
            "/login",
            arguments: {
              "origin": "/appointments/book",
              "redirect": "/appointments/book",
            },
          );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _selectedClinic = widget.clinic ?? _noClinicPlaceHolder;
    _selectedService = widget.service ?? _noServicePlaceHolder;

    _getServicesWClinics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Book Appointment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _isDone
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 12,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _buildCombo(
                                    value: _selectedService,
                                    placeHolder: _noServicePlaceHolder,
                                    items: _services!,
                                    onChanged: (newValue) {
                                      setState(() {
                                        assert(
                                          newValue != null,
                                          "The new value of dropdown btn is null",
                                        );
                                        _selectedService = newValue!;
                                        _appointmentFetcher = fetchAppointments(
                                          startDay: Time.today.day,

                                          clinic: _selectedClinic.id,
                                        );
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _buildCombo(
                                    value: _selectedClinic,
                                    placeHolder: _noClinicPlaceHolder,
                                    items: _clinics!,
                                    onChanged: (newValue) {
                                      setState(() {
                                        assert(
                                          newValue != null,
                                          "The new value of dropdown btn is null",
                                        );
                                        _selectedClinic = newValue!;
                                        _appointmentFetcher = fetchAppointments(
                                          startDay: Time.today.day,

                                          clinic: _selectedClinic.id,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child:
                                  _selectedService.id == -1 ||
                                          _selectedClinic.id == -1
                                      ? Center(
                                        child: SvgPicture.asset(
                                          optionUnselectedSvgUrl,
                                          width: 150,
                                          height: 150,
                                        ),
                                      )
                                      : Stack(
                                        children: [
                                          FutureBuilder(
                                            future: _appointmentFetcher,
                                            builder: (context, snapshot) {
                                              bool hasServerError = false;
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                // //debugPrint(
                                                //   "ff1 ${snapshot.data.toString()}",
                                                // );
                                                final Map<String, dynamic>
                                                data = jsonDecode(
                                                  snapshot.data.toString(),
                                                );
                                                // //debugPrint(
                                                //   'appointments from db ${data.toString()}',
                                                // );

                                                if (data["type"] == "error")
                                                  return _buildPageError(
                                                    "Error",
                                                  );

                                                _appointmentController =
                                                    AppointmentManager(
                                                      serviceTime:
                                                          _selectedService
                                                              .durationMin,
                                                      openTime:
                                                          _selectedClinic
                                                              .openTime,
                                                      closeTime:
                                                          _selectedClinic
                                                              .closeTime,
                                                      workdays: {
                                                        ..._selectedClinic
                                                            .workDays,
                                                      },
                                                      appointments: data,
                                                    );
                                                if (snapshot.hasError ||
                                                    hasServerError) {
                                                  return _buildPageError(
                                                    'Error',
                                                  );
                                                }
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 10,
                                                      ),
                                                  child: AppointmentSlots(
                                                    onAppointmentSelected: (
                                                      newAppointment,
                                                    ) {
                                                      _appointment =
                                                          newAppointment;
                                                      // //debugPrint(
                                                      //   "book appointment $newAppointment",
                                                      // );
                                                    },
                                                    appointments:
                                                        _appointmentController!
                                                            .allAvailableAppointments(
                                                              Time.today.day,
                                                              upto: 30,
                                                              day0Time:
                                                                  Time
                                                                      .today
                                                                      .time,
                                                            ),
                                                  ),
                                                );
                                              }
                                              if (snapshot.hasError) {
                                                return Text(
                                                  snapshot.error.toString(),
                                                );
                                              }
                                              return SizedBox.shrink();
                                            },
                                          ),
                                          _isBooking
                                              ? Container(
                                                color: Colors.black12,
                                                child: Center(
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        width: 0.2,
                                                      ),
                                                    ),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                              )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        onPressed: () {
                          if (_appointmentController == null) return;
                          if (_appointment == null) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text("No Appointment!"),
                                    content: Text(
                                      "Please choose an appointment",
                                    ),
                                    actions: [
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                    actionsAlignment: MainAxisAlignment.center,
                                  ),
                            );
                            return;
                          }

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text("Book Appointment"),

                                content: Text(
                                  "Proceed with booking appointment at $_appointment",
                                ),
                                actions: [
                                  FilledButton(
                                    onPressed: () async {
                                      Navigator.pop(dialogContext);

                                      if (!mounted) return;
                                      setState(() {
                                        _isBooking = true;
                                      });

                                      final response = await _bookAppointment();

                                      final data = response?.data;
                                      // //debugPrint(
                                      //   "response data ${response?.data.toString()}",
                                      // );
                                      if (!mounted) return;
                                      setState(() {
                                        _isBooking = false;
                                      });

                                      if (data?["type"] == "error" ||
                                          data?["message"] == null ||
                                          data?["errors"] != null) {
                                        //debugPrint("checking mounted");
                                        if (!mounted) return;
                                        //debugPrint("showing snack");
                                        showSnackbar(
                                          context: context,
                                          snackBar:
                                              TextSnackBar(
                                                icon: Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                                backgroundColor:
                                                    Colors.grey[200],
                                                foreGroundColor: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                label:
                                                    "Couldn't place appointment",
                                                duration: Duration(seconds: 3),
                                              ).create(),
                                        );
                                      } else if (data?["type"] == "success") {
                                        if (!mounted) return;
                                        showSnackbar(
                                          context: context,
                                          snackBar:
                                              TextSnackBar(
                                                icon: Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                ),
                                                backgroundColor:
                                                    Colors.grey[200],
                                                foreGroundColor: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                label: "Appointment Booked!",
                                                duration: Duration(seconds: 3),
                                              ).create(),
                                        );
                                        Navigator.pushReplacementNamed(
                                          context,
                                          "/appointments",
                                        );
                                      }
                                    },
                                    child: Text("Yes"),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        child: Center(
                          child: Text(
                            "Book Appointment",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsive(
                                sm: 14,
                                md: 20,
                                lg: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : _buildPageError("Error"),
      ),
    );
  }
}
