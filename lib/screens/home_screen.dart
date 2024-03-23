import 'package:bitweather/models/weather_model.dart';
import 'package:bitweather/secrets/variables.dart';
import 'package:bitweather/services/weather_service.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //apiKey

  final _weatherService = WeatherService(apiKey: apiKey);

  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get current city

    Position city = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather =
          await _weatherService.getWeather(city.latitude, city.longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/lottie/clear.lottie";
    switch (mainCondition.toLowerCase()) {
      case "clear":
        return "assets/lottie/clear.lottie";
      case "clouds":
        return "assets/lottie/clouds.lottie";
      case "rain":
        return "assets/lottie/rain.lottie";
      case "snow":
        return "assets/lottie/snow.lottie";
      case "thunderstorm":
        return "assets/lottie/storm.lottie";
      case "fog":
        return "assets/lottie/fog.lottie";
      case "haze":
        return "assets/lottie/haze.lottie";
      case "mist":
        return "assets/lottie/clouds.lottie";
      case "smoke":
        return "assets/lottie/smoke.lottie";
      case "sunny":
      default:
        return "assets/lottie/clear.lottie";
    }
  }

  String _formatTimestamp(timestamp) {
    if (timestamp != null) {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var formattedTime = DateFormat('HH:mm:ss').format(dateTime);
      return formattedTime;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Icon(
                Icons.location_on,
                size: 20,
                color: Colors.white,
              ),
              Text(
                _weather?.cityName ?? "loading ...",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              DotLottieLoader.fromAsset(
                  getWeatherAnimation(_weather?.mainCondition),
                  frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                if (dotlottie != null) {
                  return Lottie.memory(dotlottie.animations.values.single);
                } else {
                  return Container();
                }
              }),
              Text(
                '${_weather?.temperature}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: size.width,
                child: Row(
                  children: [
                    const Spacer(),
                    Stack(children: [
                      Container(
                        height: size.width / 3,
                        width: size.width / 3,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: DotLottieLoader.fromAsset(
                            "assets/lottie/sunrise.lottie", frameBuilder:
                                (BuildContext ctx, DotLottie? dotlottie) {
                          if (dotlottie != null) {
                            return Lottie.memory(
                                dotlottie.animations.values.single);
                          } else {
                            return Container();
                          }
                        }),
                      ),
                      Positioned(
                        top: 5,
                        left: 20,
                        child: Center(
                          child: Text(
                            _formatTimestamp(_weather?.sunrise),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ]),
                    const Spacer(),
                    Stack(children: [
                      Container(
                        height: size.width / 3,
                        width: size.width / 3,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: DotLottieLoader.fromAsset(
                            "assets/lottie/sunset.lottie", frameBuilder:
                                (BuildContext ctx, DotLottie? dotlottie) {
                          if (dotlottie != null) {
                            return Lottie.memory(
                                dotlottie.animations.values.single);
                          } else {
                            return Container();
                          }
                        }),
                      ),
                      Positioned(
                        top: 5,
                        left: 20,
                        child: Center(
                          child: Text(
                            _formatTimestamp(_weather?.sunset),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ]),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
