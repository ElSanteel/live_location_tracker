import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  // step 1 : method to check if location service is enabled or not
  Future<bool> checkAndRequestLocationService() async {
    // check if location service is enabled or not
    var isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      // request location service
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        return false;
      }
    }
    return true;
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
      // checking the permission status ( way two )
      return permissionStatus == PermissionStatus.granted;

      // checking the permission status ( way one )
      // // check if the permission is not granted
      // if (permissionStatus != PermissionStatus.granted) {
      //   // return false if the permission is not granted and the user denied the permission
      //   return false;
      // } else {
      //   // return true if the permission is granted and the user allowed the permission
      //   return true;
      // }
    }
    // return true if the permission is granted and the user allowed the permission
    return true;
  }

  void getRealTimeLocationData(void Function(LocationData)? onData) {
    location.onLocationChanged.listen(onData);
  }
}
