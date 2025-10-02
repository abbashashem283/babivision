import 'dart:convert';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/controllers/AppointmentManager.dart';
import 'package:babivision/models/Clinic.dart';
import 'package:babivision/models/Service.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  Future<Map<String, dynamic>> _getServicesWClinics() async {
    //debugPrint("getting services + clinics");
    final servicesResponse = await Http.get("/api/services");
    final Map<String, dynamic> jsonServices = jsonDecode(
      servicesResponse.toString(),
    );
    // //debugPrint(jsonServices.toString());
    final clinicsResponse = await Http.get("/api/clinics");
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

    return {"services": services, "clinics": clinics};
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedClinic = _noClinicPlaceHolder;
    _selectedService = _noServicePlaceHolder;
    super.initState();
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
        child: Column(
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
                      FutureBuilder(
                        future: _getServicesWClinics(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            //debugPrint("4");
                            final Map<String, dynamic> data = snapshot.data!;
                            _services = data["services"];
                            //debugPrint("5");
                            _clinics = data["clinics"];
                            //debugPrint("6");
                            //debugPrint(_services.toString());
                            return B(
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
                                      // child: SizedBox(
                                      //   width: double.infinity,
                                      //   height: 30,
                                      // ),
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
                            );
                          }
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        },
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
                                : SingleChildScrollView(
                                  child: FutureBuilder(
                                    future: Http.get(
                                      "/api/appointments?upto=3&clinic=${_selectedClinic.id}",
                                    ),
                                    builder: (context, snapshot) {
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
                                                  _selectedService.durationMin,
                                              openTime:
                                                  _selectedClinic.openTime,
                                              closeTime:
                                                  _selectedClinic.closeTime,
                                              workdays: {
                                                ..._selectedClinic.workDays,
                                              },
                                              appointments: data,
                                            );
                                        return Text(
                                          appointmentController
                                              .allAvailableAppointments(
                                                '2025-10-02',
                                                upto: 1,
                                              )
                                              .toString(),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Text(snapshot.error.toString());
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
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
                  style: FilledButton.styleFrom(backgroundColor: Colors.purple),
                  child: Center(
                    child: Text(
                      "Book Appointment",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
