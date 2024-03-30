import 'dart:convert';
import 'dart:io';

import 'package:bitweather/models/weather_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:bitweather/secrets/variables.dart';

class WeatherService {
  //https://api.openweathermap.org/data/2.5/weather?q={cityName}&appid=d1af8b8d29fc4120682200efe94c578f&units=metric
  static const accuweather =
      "https://dataservice.accuweather.com/currentconditions/v1/";

  WeatherService();
  // WeatherService.init();
  // static LocationService instance = LocationService.init();
  // final Location _location = Location();

  Future<Position?> getCurrentCity() async {
    //get permissions from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    }
    //fetch the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      ).then((value) => exit(0));
      return null;
    }
  }

  Future<Placemark?> getLocation(Position? position) async {
    if (position != null) {
      try {
        final placemark = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemark.isNotEmpty) {
          return placemark[0];
        } else {
          return null;
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
        // ignore: avoid_print
        print(e);
      }
    }
    return null;
  }

  Future<Weather> getAccuweather(String postCode) async {
    var apiKey = apiKeys[4];

    final response = await http.get(Uri.parse(
        'https://dataservice.accuweather.com/locations/v1/postalcodes/IN/search?apikey=$apiKey&details=true&q=$postCode'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        String key = responseData[0]['Key'];
        final response = await http.get(Uri.parse(
            'http://dataservice.accuweather.com/currentconditions/v1/$key?apikey=$apiKey&details=true'));

        try {
          final jsonData = json.decode(response.body);
          if (jsonData is List && jsonData.isNotEmpty) {
            // Access the first item in the array
            final firstItem = jsonData[0];

            return Weather.fromJSON(firstItem);
          } else {
            throw Exception("Invalid JSON format: $jsonData");
          }
        } catch (e) {
          rethrow;
        }
      } else {
        throw Exception("Somthing went wrong");
      }
    } else {
      throw Exception("Somthing went wrong");
    }
  }
}
