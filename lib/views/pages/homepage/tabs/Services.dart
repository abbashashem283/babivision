import 'dart:developer';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Utils.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:babivision/models/Service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ServicesList extends StatefulWidget {
  final List items;
  final ScrollController? controller;

  const ServicesList({super.key, this.controller, required this.items});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle subTextStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: context.responsiveExplicit(
        fallback: context.percentageOfWidth(.05),
        onWidth: {
          350: context.percentageOfWidth(.025),
          550: context.percentageOfWidth(.015),
          800: context.percentageOfWidth(.01),
          1000: 16,
        },
      ),
    );

    return GlowingOverscrollIndicator(
      color: Colors.purple,
      axisDirection: AxisDirection.down,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          controller: widget.controller,
          itemCount: widget.items.length,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 40),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                context.responsiveExplicit(
                  fallback: 1,
                  onWidth: {350: 2, 550: 3, 1500: 4},
                )!,
            mainAxisSpacing:
                context.responsiveExplicit(fallback: 0, onWidth: {350: 10})!,
            crossAxisSpacing:
                context.responsiveExplicit(fallback: 0, onWidth: {350: 10})!,
            childAspectRatio: .7,
          ),

          itemBuilder: (context, index) {
            final item = widget.items[index];
            final image = item.image;
            final name = item.name;
            final duration = item.durationMin;
            final price = item.price;
            return Container(
              //height: context.percentageOfHeight(.67),
              //height: 400,
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
                    child: Image.network(
                      serverAsset(image),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                      errorBuilder: (_, _, _) {
                        return Container(
                          color: Colors.grey,
                          width: double.infinity,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                          ),
                        );
                      },
                    ),
                    //child: SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                            context.responsiveExplicit(
                              fallback: const EdgeInsets.fromLTRB(20, 20, 8, 8),
                              onWidth: {
                                350: const EdgeInsets.fromLTRB(10, 10, 8, 8),
                                //500: const EdgeInsets.fromLTRB(20, 20, 8, 8),
                              },
                            )!,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.responsiveExplicit(
                                    fallback: context.percentageOfWidth(.06),
                                    onWidth: {
                                      350: context.percentageOfWidth(.035),
                                      550: context.percentageOfWidth(.025),
                                      800: context.percentageOfWidth(.02),
                                      1000: 20,
                                    },
                                  ),
                                ),
                              ),
                            ),

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Duration: $duration mins",
                                  style: subTextStyle,
                                ),
                                SizedBox(height: 2),
                                Text("Price: $price\$", style: subTextStyle),
                              ],
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/appointments/book',
                                    arguments: {"service": item as Service},
                                  );
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: context.responsiveExplicit(
                                    fallback: null,
                                    onWidth: {350: EdgeInsets.zero},
                                  ),
                                  //padding: EdgeInsets.zero,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Book Appointment",
                                      style: TextStyle(
                                        fontSize: context.responsiveExplicit(
                                          fallback: context.percentageOfWidth(
                                            .045,
                                          ),
                                          onWidth: {
                                            350: context.percentageOfWidth(.02),
                                            550: context.percentageOfWidth(.01),
                                            1000: 16,
                                          },
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward),
                                  ],
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
        ),
      ),
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

  final _scrollController = ScrollController();

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
        final services =
            data["services"].map((service) {
              return Service.fromJson(service);
            }).toList();
        setState(() {
          _isLoading = false;
          _isError = false;
          _services = services;
        });
      }
    } catch (e) {
      log("error has occured !!!!!! ${e.toString()}");
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
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
        content = Scrollbar(
          thumbVisibility: true,
          thickness: context.responsive(sm: 5, md: 10),
          trackVisibility: context.responsive(sm: false, lg: true),
          controller: _scrollController,
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: SizedBox(
                width: context.responsiveExplicit(
                  fallback: double.infinity,
                  onWidth: {800: context.percentageOfWidth(.7)},
                  onRatio: {-1: double.infinity},
                ),
                child: ServicesList(
                  controller: _scrollController,
                  items: _services ?? [],
                ),
              ),
            ),
          ),
        );
    }

    return Stack(
      children: [
        content,
        // Positioned(
        //   right: 0,
        //   child: B(
        //     child: RawScrollbar(
        //       thickness: 4,
        //       controller: _scrollController,
        //       thumbVisibility: true,
        //       child: SingleChildScrollView(
        //         controller: _scrollController,
        //         child: SizedBox(
        //           height: context.percentageOfHeight(1),
        //           width: 4,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        if (_isLoading)
          StackLoadingIndicator(
            indicator: SpinKitWave(color: Colors.purple, size: 24),
          ),
      ],
    );
  }
}
