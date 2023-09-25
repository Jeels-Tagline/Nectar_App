// ignore_for_file: prefer_const_declarations, use_build_context_synchronously, prefer_final_fields

import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/utils/images_path.dart';
import 'package:nectar_app/views/components/common_action_button.dart';
import 'package:nectar_app/views/components/common_show_dialog.dart';
import 'package:nectar_app/views/components/common_title_text.dart';
import 'package:permission_handler/permission_handler.dart';

class GetLocationScreen extends StatefulWidget {
  const GetLocationScreen({super.key});

  @override
  State<GetLocationScreen> createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  String address = "Search";
  String city = "Jakatnaka, Surat";

  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[];

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
    city = '${place.subLocality}, ${place.locality}';

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
            CommonShowDialog.show(context: context);
            getUserCurrentLocation().then((value) async {
              await getAddressFromLatLong(value);

              Map data = {
                'location': address,
                'city': city,
              };

              Navigator.pop(context, data);
            });
            CommonShowDialog.close(context: context);
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
                  CommonShowDialog.show(context: context);
                  getUserCurrentLocation().then((value) async {
                    await getAddressFromLatLong(value);

                    Map data = {
                      'location': address,
                      'city': city,
                    };

                    Navigator.pop(context, data);
                  });
                  CommonShowDialog.close(context: context);
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
                  final status = await Permission.location.request();

                  if (status.isGranted) {
                    CommonShowDialog.show(context: context);
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

                    CommonShowDialog.close(context: context);
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Container(
                            height: h / 2.2,
                            width: w * 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: h * 0.01),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: h * 0.17,
                                        child: Image.asset(ImagesPath.location),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: h * 0.04),
                                        child: const CommonTitleText(
                                          title:
                                              "Please Allow location permission",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: h * 0.06),
                                        child: GestureDetector(
                                          onTap: () async {
                                            //open setting
                                            await AppSettings.openAppSettings(
                                                type: AppSettingsType.location);
                                            Navigator.pop(context);
                                          },
                                          child: const CommonActionButton(
                                            name: "Setting",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
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
