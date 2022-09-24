import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Flutter Google Maps Demo',
      // home: MapsPage(),
      // home: HomePage(),
      home: MapSample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng currentUserLocation =
      const LatLng(-5.171089568250141, 106.81344336578967);
  LatLng currentOfficeLocation = const LatLng(-6.170742, 106.813554);

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static const CameraPosition _hashmicroMaps = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-6.170742, 106.813554),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static const CameraPosition _hashmicroSingaporeMaps = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(1.2808814698626885, 103.8491853396067),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final LatLng hasmicroLocation = const LatLng(-6.170742, 106.813554);
  final LatLng hasmicroSingaporeLocation = const LatLng(1.2808814698626885, 103.8491853396067);
  final LatLng userNearOfficeLocation =
      const LatLng(-6.171089568250141, 106.81344336578967);

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Attendace')),
        backgroundColor: const Color(0xFFB41E29),
      ),
      body: GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
        height: 70,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
            ]),
        child: ClipRRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Center(
                      child: IconButton(
                        icon: const Icon(MdiIcons.officeBuildingMarker),
                        onPressed: () => showMaterialModalBottomSheet(
                          expand: false,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: 200,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: const Text(
                                      "Mater Data",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                ListTile(
                                  title: const Text('Hashmicro Office Jakarta'),
                                  trailing: ElevatedButton(
                                    onPressed: _goToOffice,
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFFB41E29),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        )),
                                    child: const Text("View"),
                                  ),
                                  // trailing: IconButton(
                                  //     onPressed: _goToOffice,
                                  //     icon: const Icon(MdiIcons.mapMarker)),
                                ),
                                ListTile(
                                  title: const Text('Hashmicro Office Singapore'),
                                  trailing: ElevatedButton(
                                    onPressed: _goToSingaporeOffice,
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFFB41E29),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        )),
                                    child: const Text("View"),
                                  ),
                                  // trailing: IconButton(
                                  //     onPressed: _goToOffice,
                                  //     icon: const Icon(MdiIcons.mapMarker)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                        child: IconButton(
                      icon: const Icon(MdiIcons.account),
                      // onPressed: _goToUserPosition,
                      onPressed: () => showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          height: 200,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: const Text(
                                    "User Location",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              ListTile(
                                title: const Text('Get User Location'),
                                trailing: ElevatedButton(
                                  onPressed: _goToUserPosition,
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFFB41E29),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      )),
                                  child: const Text("View"),
                                ),
                                // trailing: IconButton(
                                //     onPressed: _goToUserPosition,
                                //     icon: const Icon(MdiIcons.mapMarker)),
                              ),
                              ListTile(
                                title:
                                    const Text('Get User Near Office Location'),
                                trailing: ElevatedButton(
                                  onPressed: _goToUserNearOfficePosition,
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFFB41E29),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      )),
                                  child: const Text("View"),
                                ),
                                // trailing: IconButton(
                                //     onPressed: _goToUserNearOfficePosition,
                                //     icon: const Icon(MdiIcons.mapMarker)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    double distance = calculateDistance(
                        currentUserLocation.latitude,
                        currentUserLocation.longitude,
                        currentOfficeLocation.latitude,
                        currentOfficeLocation.longitude);
                    if (distance >= 0.50) {
                      Get.snackbar('Attend Rejected',
                          'Clock in: ${DateTime.now().toString()} \nDistance: $distance km',
                          backgroundColor: const Color.fromARGB(255, 225, 35, 35),
                          colorText: Colors.white);
                    } else {
                      Get.snackbar('Attend Suucess',
                          'Clock in: ${DateTime.now().toString()} \nDistance: $distance km',
                          colorText: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 30, 156, 36));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFB41E29),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  child: const Text("Attend"),
                )
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(40))),
      ),
    );
  }

  Future<void> _goToOffice() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_hashmicroMaps));
    setState(() {
      _markers.add(Marker(
          infoWindow: const InfoWindow(title: 'Office Location', snippet: ''),
          icon: BitmapDescriptor.defaultMarker,
          markerId: const MarkerId('hashmicroLocation'),
          position: hasmicroLocation));
    });
    currentOfficeLocation = hasmicroLocation;
    Get.back();
  }
  Future<void> _goToSingaporeOffice() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_hashmicroSingaporeMaps));
    setState(() {
      _markers.add(Marker(
          infoWindow: const InfoWindow(title: 'Singapore Office Location'),
          icon: BitmapDescriptor.defaultMarker,
          markerId: const MarkerId('hashmicroSingaporeLocation'),
          position: hasmicroSingaporeLocation));
    });
    currentOfficeLocation = hasmicroSingaporeLocation;
    Get.back();
  }

  Future<void> _goToUserPosition() async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition userPosition = await _getUserLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(userPosition));
    setState(() {
      _markers.add(Marker(
          infoWindow: const InfoWindow(
            title: 'User Location',
            snippet: '',
          ),
          icon: BitmapDescriptor.defaultMarker,
          markerId: const MarkerId(
            'userLocation',
          ),
          position: userPosition.target));
    });
    Get.back();
  }

  Future<void> _goToUserNearOfficePosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: userNearOfficeLocation, zoom: 19.151926040649414)));
    setState(() {
      _markers.add(Marker(
          infoWindow: const InfoWindow(
            title: 'User Location Near Office',
          ),
          icon: BitmapDescriptor.defaultMarker,
          markerId: const MarkerId(
            'userLocationNearOffice',
          ),
          position: userNearOfficeLocation));
    });
    currentUserLocation = userNearOfficeLocation;
    Get.back();
  }

  Future<CameraPosition> _getUserLocation() async {
    await Geolocator.requestPermission();

    Position userLocation;

    userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    currentUserLocation = LatLng(userLocation.latitude, userLocation.longitude);

    return CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(userLocation.latitude, userLocation.longitude),
        tilt: 0.0,
        zoom: 19.151926040649414);
  }
}
