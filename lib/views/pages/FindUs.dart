import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/Utils/popups/Utils.dart';
import 'package:babivision/models/Clinic.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/popups/Snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:babivision/Utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicList extends StatefulWidget {
  final List items;
  final int selectedClinic;
  final Function(int index)? onItemSelected;
  const ClinicList({
    super.key,
    required this.items,
    this.selectedClinic = 0,
    this.onItemSelected,
  });

  @override
  State<ClinicList> createState() => _ClinicListState();
}

class _ClinicListState extends State<ClinicList> {
  late int _selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.selectedClinic;
  }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      color: Colors.purple,
      axisDirection: AxisDirection.down,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final name = item.name;
          final address = item.address;
          return SizedBox(
            height: context.percentageOfHeight(.1),
            child: ListTile(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onItemSelected?.call(index);
              },
              trailing:
                  _selectedIndex == index
                      ? Icon(
                        Icons.check_circle,
                        color: Colors.purple,
                        size: context.fontSizeMin(24),
                      )
                      : null,
              leading: Icon(
                Icons.location_on,
                color: Colors.purple,
                size: context.fontSizeMin(35),
              ),
              title: Text(
                name,
                style: TextStyle(fontSize: context.fontSizeMin(19)),
              ),
              subtitle: Text(
                address,
                style: TextStyle(fontSize: context.fontSizeMin(16)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FindUs extends StatefulWidget {
  const FindUs({super.key});

  @override
  State<FindUs> createState() => _FindUsState();
}

class _FindUsState extends State<FindUs> {
  final _mapController = MapController();
  List? _clinics;
  late Clinic _selectedClinic;

  bool _isLoading = false, _isError = false;

  TileLayer get _mapTile {
    return TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: "com.flutter.babivision",
    );
  }

  Future<void> _fetchClinics() async {
    if (mounted)
      setState(() {
        _isLoading = true;
        _isError = false;
      });
    try {
      final response = await Http.get("/api/clinics");
      if (response.data["type"] == "error" || response.data["clinics"] == null)
        throw Exception();
      List clinics =
          response.data["clinics"]
              .map((clinic) => Clinic.fromJson(clinic))
              .toList();
      setState(() {
        _isLoading = false;
        _clinics = clinics;
        _selectedClinic = clinics[0];
      });
    } catch (e) {
      log(e.toString());
      if (mounted)
        setState(() {
          _isLoading = false;
          _isError = true;
        });
    }
  }

  Future<void> _openMaps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && mounted) {
      showSnackbar(
        context: context,
        snackBar: TextSnackBar.error(message: 'No Location Services'),
      );
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
        showSnackbar(
          context: context,
          snackBar: TextSnackBar.error(message: "Permission Denied"),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever && mounted) {
      showSnackbar(
        context: context,
        snackBar: TextSnackBar.error(message: "Permission Permanently Denied"),
      );
      return;
    }
    final position = await Geolocator.getCurrentPosition();
    final latitude = _selectedClinic.latitude;
    final longitude = _selectedClinic.longitude;
    final Uri googleMapsAppUri = Uri.parse(
      'google.navigation:q=$latitude,$longitude&mode=d',
    );
    final Uri googleMapsWebUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=$latitude,$longitude&travelmode=driving',
    );

    if (await canLaunchUrl(googleMapsAppUri)) {
      await launchUrl(googleMapsAppUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(googleMapsWebUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchClinics();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox.shrink();

    if (_isLoading)
      content = CircularProgressIndicator();
    else if (_isError)
      content = TextButton.icon(
        onPressed: null,
        label: Text(
          "An Error Occured",
          style: TextStyle(
            color: Colors.red,
            fontSize: context.fontSizeMax(18),
          ),
        ),
        icon: Icon(
          Icons.error,
          size: context.fontSizeMax(20),
          color: Colors.red,
        ),
      );
    else
      content = SizedBox(
        width: double.infinity.max(1000),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Our Locations",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveExplicit(
                          fallback: context.fontSizeAVG(24),
                          onRatio: {
                            -1: context.fontSizeAVG(24),
                            .5: context.fontSizeMin(25),
                            .95: context.fontSizeMin(28),
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    FractionallySizedBox(
                      widthFactor: .7,
                      child: Text(
                        "Visit one of our clinics to receive professional eye care and a wide range of eye wear",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: context.responsiveExplicit(
                            fallback: context.fontSizeAVG(16),
                            onRatio: {
                              -1: context.fontSizeAVG(16),
                              .6: context.fontSizeMin(17),
                              .95: context.fontSizeMin(18),
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 47,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    minZoom: 3,
                    maxZoom: 18,
                    initialCenter: LatLng(
                      double.parse(_selectedClinic.latitude),
                      double.parse(_selectedClinic.longitude),
                    ),
                    initialZoom: 15,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    _mapTile,
                    MarkerLayer(
                      markers: List.generate(_clinics!.length, (index) {
                        final clinic = _clinics![index];
                        final latitude = double.parse(clinic.latitude);
                        final longitude = double.parse(clinic.longitude);
                        return Marker(
                          // height: 200,
                          // alignment: Alignment.bottomCenter,
                          width: context.percentageOfWidth(.5),
                          height: context.percentageOfWidth(.5),
                          //alignment: Alignment.topCenter,
                          point: LatLng(latitude, longitude),

                          child: Align(
                            alignment: Alignment.topCenter,
                            child: FractionallySizedBox(
                              heightFactor: .52,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                "/appointments/book",
                                                arguments: {
                                                  'clinic': _selectedClinic,
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.calendar_month,
                                              color: Colors.white,
                                              size: context.fontSizeMin(35),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _openMaps();
                                            },
                                            icon: Icon(
                                              Icons.map,
                                              color: Colors.white,
                                              size: context.fontSizeMin(35),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.purple,
                                      size: context.fontSizeMin(35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 33,
                child: Center(
                  child: SizedBox(
                    height:
                        _clinics!.length <= 2
                            ? context.percentageOfHeight(.22)
                            : null,
                    child: ClinicList(
                      items: _clinics!,
                      selectedClinic: 0,
                      onItemSelected: (index) {
                        log("setting selected clinic to $index");
                        final clinic = _clinics![index];
                        setState(() {
                          _selectedClinic = clinic;
                        });
                        final double latitude = double.parse(clinic.latitude);
                        final double longitude = double.parse(clinic.longitude);
                        _mapController.move(LatLng(latitude, longitude), 15);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Find Us", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: Center(child: content),
    );
  }
}
