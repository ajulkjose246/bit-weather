import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bitweather/models/weather_model.dart';
import 'package:bitweather/services/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const accuweather =
      "https://dataservice.accuweather.com/currentconditions/v1/";

  WeatherService();

  Future<Position?> getCurrentCity() async {
    print("getCurrentCity");
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
      ).then((value) => Future.delayed(const Duration(seconds: 2), () {
            exit(0);
          }));
      return null;
    }
  }

  Future<Placemark?> getLocation(Position? position) async {
    print("getLocation");
    if (position != null) {
      try {
        final placemark = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemark.isNotEmpty) {
          SharedPreferencesService()
              .storePostalCode(placemark[0].postalCode.toString());
          SharedPreferencesService()
              .storeLocality(placemark[0].locality.toString());
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

  Future<Weather?> getAccuweather(String postCode) async {
    print("getAccuweather");
    String? apiKey;

    bool foundApiKey = false;

    final apiCollection = await http
        .get(Uri.parse('https://ajulkjose-v1.000webhostapp.com/apikeys'));
    print(apiCollection.statusCode);
    if (apiCollection.statusCode == 200) {
      final jsonData = json.decode(apiCollection.body);
      for (var entry in jsonData.entries) {
        final value = entry.value;

        final response = await http.get(Uri.parse(
            'https://dataservice.accuweather.com/locations/v1/postalcodes/IN/search?apikey=$value&details=true&q=$postCode'));
        if (response.statusCode == 200) {
          apiKey = value;
          print(value);
          foundApiKey = true;
          break; // Exit from the loop
        }
      }
    }

    if (foundApiKey) {
      print(apiKey);
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
    return null;
  }
}
