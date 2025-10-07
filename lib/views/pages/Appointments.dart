import 'dart:convert';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Time.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/controllers/AppointmentManager.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/models/Clinic.dart';
import 'package:babivision/models/Service.dart';
import 'package:babivision/views/debug/B.dart';
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

class AppointmentList extends StatefulWidget {
  final List<dynamic> appointments;
  final String? selectedAppointment;
  final Function(String appointment) onAppointmentSelected;
  const AppointmentList({
    super.key,
    required this.appointments,
    required this.onAppointmentSelected,
    this.selectedAppointment,
  });

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
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
        debugPrint(
          '$displayDate - ${info.size} - ${info.visibleFraction * 100} - ${info.visibleBounds.toString()}',
        );
        double top = info.visibleBounds.top;
        double height = info.size.height;
        if (top > 0 && (_visibleDate == null || _visibleDate != displayDate)) {
          setState(() {
            debugPrint("SETTING VISIBLE DATE !!!");
            _visibleDate = displayDate;
          });
        }
        if (info.visibleBounds == Rect.zero) {
          setState(() {
            debugPrint("REMOVING VISIBLE DATE !!!");

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
                    crossAxisCount: 3, // number of columns
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
                      debugPrint('slot active: $slotActive');
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
    debugPrint("${widget.appointments.length}");
    return Stack(
      children: [
        ListView.separated(
          itemCount: widget.appointments.length,
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

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class ComboPlaceHolder {
  final int id;
  final String name;
  ComboPlaceHolder({required this.id, required this.name});
}

class _AppointmentsState extends State<Appointments> {
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
  List<Service>? _services;
  List<Clinic>? _clinics;

  bool _isLoading = true, _isError = false, _isDone = false;

  String get optionUnselectedSvgUrl {
    if (_selectedService.id == -1) return "assets/icon-images/no-service.svg";
    if (_selectedClinic.id == -1) return "assets/icon-images/no-clinic.svg";
    return "";
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
    //debugPrint("getting services + clinics");
    if (mounted) {
      setState(() {
        _isLoading = true;
        _isDone = false;
        _isError = false;
      });
    }
    try {
      final servicesResponse = await Http.get("/api/services");
      final clinicsResponse = await Http.get("/api/clinics");
      debugPrint(servicesResponse.toString());
      final Map<String, dynamic> jsonServices = jsonDecode(
        servicesResponse.toString(),
      );
      // //debugPrint(jsonServices.toString());
      final Map<String, dynamic> jsonClinics = jsonDecode(
        clinicsResponse.toString(),
      );
      //debugPrint("1");
      List<Service> services =
          (jsonServices["services"] as List)
              .map((service) => Service.fromJson(service))
              .toList();
      //debugPrint("2");
      List<Clinic> clinics =
          (jsonClinics["clinics"] as List)
              .map((clinic) => Clinic.fromJson(clinic))
              .toList();
      //debugPrint("3");

      _services = services;
      _clinics = clinics;

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isDone = true;
          _isError = false;
        });
      }
    } on Exception catch (_) {
      // TODO
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isDone = false;
          _isError = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _selectedClinic = _noClinicPlaceHolder;
    _selectedService = _noServicePlaceHolder;
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
          "Appointments",
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
                      child: B(
                        color: "tr",
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              B(
                                color: "tr",
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: B(
                                        color: "tr",
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
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: B(
                                        color: "tr",
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
                                            });
                                          },
                                        ),
                                        // child: SizedBox(width: 30, height: 30),
                                      ),
                                    ),
                                  ],
                                ),
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
                                        : FutureBuilder(
                                          future: Http.get(
                                            "/api/appointments?upto=3&clinic=${_selectedClinic.id}",
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            if (snapshot.hasData) {
                                              final Map<String, dynamic> data =
                                                  jsonDecode(
                                                    snapshot.data.toString(),
                                                  );
                                              debugPrint("1");
                                              AppointmentManager
                                              appointmentController =
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
                                              // return Text(
                                              //   appointmentController
                                              //       .allAvailableAppointments(
                                              //         Time.today.day,
                                              //         upto: 2,
                                              //         day0Time:
                                              //             Time.today.time,
                                              //       )
                                              //       .toString(),
                                              // );
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: AppointmentList(
                                                  onAppointmentSelected: (
                                                    newAppointment,
                                                  ) {
                                                    // setState(() {
                                                    //   _appointment =
                                                    //       newAppointment;
                                                    // });
                                                  },
                                                  appointments:
                                                      appointmentController
                                                          .allAvailableAppointments(
                                                            Time.today.day,
                                                            upto: 30,
                                                            day0Time:
                                                                Time.today.time,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: B(
                        color: "r",
                        child: FilledButton(
                          onPressed: () {},
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
                    ),
                  ],
                )
                : SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 150, color: Colors.red),
                      Text(
                        "Error",
                        style: TextStyle(color: Colors.red, fontSize: 32),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
