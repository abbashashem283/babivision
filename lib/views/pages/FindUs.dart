import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FindUs extends StatefulWidget {
  const FindUs({super.key});

  @override
  State<FindUs> createState() => _FindUsState();
}

class _FindUsState extends State<FindUs> {
  final _mapController = MapController();

  TileLayer get _mapTile {
    return TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: "com.flutter.babivision",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5, // thin shadow for separation
        // --- Back button on the top left ---
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),

        // --- App bar title ---
        title: Text(
          "Find Us",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            //!
            fontSize: context.responsiveExplicit(
              fallback: 16,
              onHeight: {1024: 24},
            ),
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: SizedBox(
          width: double.infinity.max(1000),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: B(
              child: Column(
                children: [
                  Expanded(
                    flex: 24,
                    child: B(
                      color: "r",
                      inExpanded: true,
                      child: B(
                        color: "b",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Our Locations",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveExplicit(
                                  fallback: context.percentageOfWidth(.06),
                                  // .max(35),
                                  onWidth: {
                                    500: context.percentageOfWidth(.05),
                                    650: context.percentageOfWidth(.045),
                                    800: context.percentageOfWidth(.042),
                                    900: context.percentageOfWidth(.04),
                                    1000: 40,
                                    //.max(40),
                                  },
                                  onRatio: {
                                    -.77: context.percentageOfWidth(.06),
                                    -.6: context.percentageOfWidth(.062),
                                    -.54: context.percentageOfWidth(.065),
                                    -.46: context.percentageOfWidth(.067),
                                    -.39: context.percentageOfWidth(.07),
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
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  //fontWeight: FontWeight.bold,
                                  fontSize: context.responsiveExplicit(
                                    fallback: context.percentageOfWidth(.04),
                                    //.max(20),
                                    onWidth: {
                                      500: context.percentageOfWidth(.03),
                                      650: context.percentageOfWidth(.025),
                                      800: context.percentageOfWidth(.022),
                                      900: context.percentageOfWidth(.02),
                                      1000: 20,
                                      // .max(20),
                                    },
                                    onRatio: {
                                      -.77: context.percentageOfWidth(.04),
                                      -.6: context.percentageOfWidth(.042),
                                      -.54: context.percentageOfWidth(.045),
                                      -.46: context.percentageOfWidth(.047),
                                      -.39: context.percentageOfWidth(.05),
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 39,
                    child: B(
                      color: "r",
                      inExpanded: true,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: const MapOptions(
                          initialCenter: LatLng(33.8617842, 35.5294576),
                          initialZoom: 15,
                          interactionOptions: InteractionOptions(
                            flags: InteractiveFlag.all,
                          ),
                        ),
                        children: [_mapTile],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 37,
                    child: B(
                      color: "r",
                      inExpanded: true,
                      child: SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
