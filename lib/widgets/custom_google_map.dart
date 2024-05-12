import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/utils/location_service.dart';

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
  // we have made markers set
  Set<Marker> markers = {};
  // we have made locationService object
  late LocationService locationService;
  bool isFirstCall = true;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
        zoom: 1, target: LatLng(31.187084851056554, 29.928110526889437));

    // we have initialized the locationService object
    locationService = LocationService();
    updateMyLocation();
    super.initState();
  }

  // Set<Circle> circles = {};
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
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

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationService();
    var hasPermission =
        await locationService.checkAndRequestLocationPermission();
    if (hasPermission) {
      locationService.getRealTimeLocationData((locationData) {
        // set the user location marker
        setMyLocationMarker(locationData);

        // set the camera position to the user location
        updateMyCamera(locationData);
      });
    } else {}
  }

  void updateMyCamera(LocationData locationData) {
    if (isFirstCall) {
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 17);

      // animate the camera to the user location
      // ? -> null safety operator used here to check if the googleMapController is null or not
      // so if the googleMapController is null the animateCamera method will not be called
      googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      isFirstCall = false;
    } else {
      // animate the camera to the user location
      // ? -> null safety operator used here to check if the googleMapController is null or not
      // so if the googleMapController is null the animateCamera method will not be called
      googleMapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!)));
    }
  }

  void setMyLocationMarker(LocationData locationData) {
    // create a marker for the user location
    var myLocationMarker = Marker(
      markerId: const MarkerId('my_location_marker'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
    );

    // add the marker to the markers set
    markers.add(myLocationMarker);

    // update the state to rebuild the widget cuz animateCamera method will not rebuild the widget , it just change the position of the camera
    setState(() {});
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
