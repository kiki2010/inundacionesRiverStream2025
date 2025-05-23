import 'package:geolocator/geolocator.dart';

String userLatitude = "Loading...";
String userLongitude = "Loading..."; 

  //Get User Position Funtion
  Future <void> getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      userLatitude = 'disabled';
      userLongitude = 'disabled';
    }
    
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        userLatitude = "Permission Denied";
        userLongitude = "Permission Denied";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      userLatitude = "Permission Denied Forever";
      userLongitude = "Permission Denied Forever";
      
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      double roundedLat = double.parse(position.latitude.toStringAsFixed(3));
      double roundedLon = double.parse(position.longitude.toStringAsFixed(3));
      
      userLatitude = roundedLat.toString();
      userLongitude = roundedLon.toString();

      //_getThreeDayForecast();
    } catch (e) {
      userLatitude = "Error";
      userLongitude = "Error";
    }
  }