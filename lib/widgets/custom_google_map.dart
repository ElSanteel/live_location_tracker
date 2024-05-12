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

  // we have made the googleMapController nullable because we are sure that it will be initialized in the onMapCreated callback
  GoogleMapController? googleMapController;

  late Location location;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 17, target: LatLng(31.187084851056554, 29.928110526889437));

    // initCircles();
    location = Location();

    updateMyLocation();
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
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  void initMapStyle() async {
    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');

    googleMapController!.setMapStyle(nightMapStyle);
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

  // step 1 : method to check if location service is enabled or not
  Future<void> checkAndRequestLocationService() async {
    // check if location service is enabled or not
    var isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      // request location service
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        // TODO: show error bar
      }
    }
  }

  // // step 2 : method to check if location permission is granted or not ( first way )
  // Future<bool> checkAndRequestLocationPermission() async {
  //   // check if location permission is granted or not
  //   var permissionStatus = await location.hasPermission();
  //   if (permissionStatus == PermissionStatus.denied) {
  //     // request location permission
  //     permissionStatus = await location.requestPermission();
  //     if (permissionStatus != PermissionStatus.granted) {
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     if (permissionStatus == PermissionStatus.deniedForever) {
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   }
  // }

  // step 2 : method to check if location permission is granted or not ( second way )
  Future<bool> checkAndRequestLocationPermission() async {
    // check if location permission is granted or not
    var permissionStatus = await location.hasPermission();
    // check if the permission is denied forever
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    // check if the permission is denied
    if (permissionStatus == PermissionStatus.denied) {
      // request location permission
      permissionStatus = await location.requestPermission();
      // check if the permission is not granted
      if (permissionStatus != PermissionStatus.granted) {
        // return false if the permission is not granted and the user denied the permission
        return false;
      }
    }
    // return true if the permission is granted and the user allowed the permission
    return true;
  }

  // step 3 : method to get the user location data
  void getLocationData() {
    location.onLocationChanged.listen(
      (locationData) {
        // create a camera position object with the user location
        var cameraPosition = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
        );
        // animate the camera to the user location

        // ? -> null safety operator used here to check if the googleMapController is null or not
        // so if the googleMapController is null the animateCamera method will not be called
        googleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      },
    );
  }

  void updateMyLocation() async {
    await checkAndRequestLocationService();
    var hasPermission = await checkAndRequestLocationPermission();
    if (hasPermission) {
      getLocationData();
    } else {}
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
