import 'dart:developer';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Utils.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ServicesList extends StatefulWidget {
  final List items;
  const ServicesList({super.key, required this.items});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.items.length,
      padding: EdgeInsets.only(left: 10, right: 10),
      separatorBuilder: (context, index) => SizedBox(height: 50),
      itemBuilder: (context, index) {
        return Container(
          //height: context.percentageOfHeight(.67),
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(50, 50, 93, 0.25),
                blurRadius: 27,
                spreadRadius: -5,
                offset: Offset(0, 13),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                blurRadius: 16,
                spreadRadius: -8,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 6,
                child: Image.asset(
                  'assets/images/basic-eye-test.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
                //child: SizedBox.shrink(),
              ),
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //SizedBox(height: 25),
                        B(
                          //inExpanded: true,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Basic Eye Exam in the nortenfn jffj jfnf j",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        B(
                          //inExpanded: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Duration: 30 mins",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Price: 50\$",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        B(
                          //inExpanded: true,
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Book Appointment",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  bool _isLoading = false, _isError = false;
  List? _services;

  void _fetchServices() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    try {
      final response = await Http.get("/api/services");
      final data = response.data;
      if (!mounted) return;
      if (data["type"] == "error") {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
        return;
      }

      if (data["services"] != null) {
        setState(() {
          _isLoading = false;
          _isError = false;
          _services = data["services"];
        });
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("init services");
    _fetchServices();

    // (() async {
    //   final response = await Http.get(
    //     "/storage/service_images/basic-eye-test.png",
    //   );
    //   debugPrint(
    //     "${response.statusMessage} ${response.statusCode} ${response.data.toString()}",
    //   );
    // })();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox.shrink();

    if (!_isLoading) {
      if (_isError)
        content = Center(
          child: TextButton.icon(
            onPressed: null,
            label: Text(
              "An Error has Occured!",
              style: TextStyle(color: Colors.red),
            ),
            icon: Icon(Icons.error, color: Colors.red),
          ),
        );
      else
        content = ServicesList(items: _services ?? []);
    }

    return Stack(
      children: [
        content,
        if (_isLoading)
          StackLoadingIndicator(
            indicator: SpinKitWave(color: Colors.purple, size: 24),
          ),
      ],
    );
  }
}
