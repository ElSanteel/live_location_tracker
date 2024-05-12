import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController googleMapController;

  late Location location;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 17, target: LatLng(31.187084851056554, 29.928110526889437));

    // initCircles();
    location = Location();
    checkAndRequestLocationService();
    super.initState();
  }

  // Set<Circle> circles = {};
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // circles: circles,
      zoomControlsEnabled: false,
      onMapCreated: (controller) {
        googleMapController = controller;
        initMapStyle();

        location.onLocationChanged.listen((locationData) {});
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');

    googleMapController.setMapStyle(nightMapStyle);
  }

  // void initCircles() {
  //   Circle koshryAbuTarekServiceCircle = Circle(
  //       fillColor: Colors.black.withOpacity(.5),
  //       center: const LatLng(30.050250485630052, 31.237686871310093),
  //       radius: 10000,
  //       circleId: const CircleId('1'));
  //
  //   circles.add(koshryAbuTarekServiceCircle);
  // }

  // method to check if location service is enabled or not
  void checkAndRequestLocationService() async {
    // check if location service is enabled or not
    var isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      // request location service
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        //TODO: show error bar
        return;
      }
    }
    checkAndRequestLocationPermission();
  }

  void checkAndRequestLocationPermission() async {
    // check if location permission is granted or not
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // request location permission
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // TODO: show error bar
      }
    }
  }
}

// steps to get the user location
// inquire about location service or check if location service is enabled or not ?  --> done
// request permission --> done
// get location
// display

// world view 0 -> 3
// country view 4-> 6
// city view 10 -> 12
// street view 13 -> 17
// building view 18 -> 20
