// ignore_for_file: prefer_const_declarations, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nectar_app/helpers/globals/globals.dart';

class GetLocationScreen extends StatefulWidget {
  const GetLocationScreen({super.key});

  @override
  State<GetLocationScreen> createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  String address = "Search";
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(20.42796133580664, 75.885749655962),
      infoWindow: InfoWindow(
        title: 'My Position',
      ),
    ),
  ];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  Future getAddressFromLatLong(Position position) async {
    List placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Globals.greenColor,
        leading: IconButton(
          onPressed: () async {
            getUserCurrentLocation().then((value) async {
              await getAddressFromLatLong(value);

              Navigator.pop(context, address);
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Location",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGoogle,
          markers: Set<Marker>.of(_markers),
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          right: w * 0.15,
          left: w * 0.11,
        ),
        child: SizedBox(
          width: w,
          height: h * 0.065,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  getUserCurrentLocation().then((value) async {
                    await getAddressFromLatLong(value);

                    Navigator.pop(context, address);
                  });
                },
                child: Container(
                  width: w * 0.25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Globals.greenColor,
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  getUserCurrentLocation().then((value) async {
                    _markers.add(
                      Marker(
                        markerId: const MarkerId("2"),
                        position: LatLng(value.latitude, value.longitude),
                        infoWindow: const InfoWindow(
                          title: 'My Current Location',
                        ),
                      ),
                    );

                    CameraPosition cameraPosition = CameraPosition(
                      target: LatLng(value.latitude, value.longitude),
                      zoom: 14,
                    );

                    final GoogleMapController controller =
                        await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition));
                    setState(() {});
                  });
                },
                child: Container(
                  width: w * 0.15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Globals.greenColor,
                  ),
                  child: const Icon(
                    Icons.location_history,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
