import 'dart:convert';

import 'package:bitweather/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  //https://api.openweathermap.org/data/2.5/weather?q={cityName}&appid=d1af8b8d29fc4120682200efe94c578f&units=metric
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJSON(json.decode(response.body));
    } else {
      throw Exception("Somthing went wrong");
    }
  }

  Future<Position> getCurrentCity() async {
    //get permissions from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //current location to city

    return position;
  }
}
