import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

//location
Future<bool> _requestLocationPermission() async {
  Location location = Location();
  bool hasPermission = (await location.hasPermission()) as bool;
  if (!hasPermission) {
    PermissionStatus status = await location.requestPermission();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

//get user location
Future<Position?> _getUserLocation() async {
  bool hasPermission = await _requestLocationPermission();
  if (hasPermission) {
    return  await Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
  } else {
    return null;
  }
}





