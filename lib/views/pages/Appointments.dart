import 'dart:convert';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/controllers/AppointmentController.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  int _selectedService = -1;
  int _selectedClinic = -1;
  List? _services;
  List? _clinics;

  Widget _buildCombo({
    required int value,
    required String placeHolder,
    required List items,
    required void Function(Object?) onChanged,
  }) {
    List itemsWPlaceHolder = [
      {'id': -1, 'name': placeHolder},
      ...items,
    ];

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
          return Center(
            child: Text(item["name"], style: getTextStyle(item["id"])),
          );
        }).toList();
      },
      items:
          itemsWPlaceHolder
              .map(
                (item) => DropdownMenuItem(
                  //alignment: Alignment.center,
                  value: item["id"],
                  child: Text(item["name"], style: getTextStyle(item["id"])),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }

  Future<Map<String, dynamic>> _getServicesWClinics() async {
    final servicesResponse = await Http.get("/api/services");
    final Map<String, dynamic> services = jsonDecode(
      servicesResponse.toString(),
    );
    final clinicsResponse = await Http.get("/api/clinics");
    final Map<String, dynamic> clinics = jsonDecode(clinicsResponse.toString());
    return {"services": services["services"], "clinics": clinics["clinics"]};
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
                color: "g",
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: _getServicesWClinics(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final Map<String, dynamic> data = snapshot.data!;
                            _services = data["services"];
                            _clinics = data["clinics"];
                            return B(
                              color: "r",
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: B(
                                      color: "t",
                                      child: _buildCombo(
                                        value: _selectedService,
                                        placeHolder: "- select a service -",
                                        items: _services!,
                                        onChanged: (newValue) {
                                          setState(() {
                                            assert(
                                              newValue != null,
                                              "The new value of dropdown btn is null",
                                            );
                                            _selectedService = newValue! as int;
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
                                      color: "t",
                                      child: _buildCombo(
                                        value: _selectedClinic,
                                        placeHolder: "- select a clinic -",
                                        items: _clinics!,
                                        onChanged: (newValue) {
                                          setState(() {
                                            assert(
                                              newValue != null,
                                              "The new value of dropdown btn is null",
                                            );
                                            _selectedClinic = newValue! as int;
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
                            return Text("Error");
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      Expanded(
                        child:
                            _selectedService == -1
                                ? Center(
                                  child: SvgPicture.asset(
                                    "assets/icon-images/no-service.svg",
                                    width: 150,
                                    height: 150,
                                  ),
                                )
                                : SingleChildScrollView(
                                  child: FutureBuilder(
                                    future: Http.get(
                                      "/api/appointments?upto=3",
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final Map<String, dynamic> data =
                                            jsonDecode(
                                              snapshot.data.toString(),
                                            );
                                        //AppointmentController appointmentController = AppointmentController(serviceTime: serviceTime, openTime: openTime, closeTime: closeTime, workdays: workdays, appointments: appointments)
                                        return Text(snapshot.data.toString());
                                      }
                                      if (snapshot.hasError) {
                                        return Text("error");
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
