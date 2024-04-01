import 'package:bitweather/components/weather_charts.dart';
import 'package:bitweather/models/weather_model.dart';
import 'package:bitweather/services/shared_preferences.dart';
import 'package:bitweather/services/weather_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? _weather;
  String? locality;
  var placemark;
  bool _isRefreshed = false;
  String? postalCode;

  final _weatherService = WeatherService();

  Future<void> _fetchWeather() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Fluttertoast.showToast(
        msg: 'Network is not connected',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
      return;
    }

    try {
      postalCode = SharedPreferencesService().getPostalCode();
      locality = SharedPreferencesService().getLocality();

      print(postalCode);
      if (_isRefreshed) {
        Position? city = await _weatherService.getCurrentCity();
        placemark = await _weatherService.getLocation(city);
        postalCode = placemark?.postalCode;
        locality = placemark?.locality;
      }
      if (postalCode == null) {
        Position? city = await _weatherService.getCurrentCity();
        placemark = await _weatherService.getLocation(city);
        postalCode = placemark?.postalCode;
        locality = placemark?.locality;
      }

      final Weather? weather =
          await _weatherService.getAccuweather(postalCode!);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
      Fluttertoast.showToast(
        msg: 'Error fetching weather data',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(_weather?.link ?? "");
    // ignore: deprecated_member_use
    if (await canLaunch(url.toString())) {
      // ignore: deprecated_member_use
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _handleRefresh() async {
    _isRefreshed = true;
    await _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: SafeArea(
        child: Center(
          child: _weather != null
              ? LiquidPullToRefresh(
                  onRefresh: _handleRefresh,
                  showChildOpacityTransition: false,
                  child: ListView(
                    children: [
                      const SizedBox(height: 25),
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.white,
                      ),
                      Align(
                        child: Text(
                          locality ?? placemark?.locality ?? "loading ...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DotLottieLoader.fromAsset(
                        getWeatherAnimation(_weather?.weatherText),
                        frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                          if (dotlottie != null) {
                            return Lottie.memory(
                              dotlottie.animations.values.single,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Align(
                        child: Text(
                          '${_weather?.temperatureCelsius}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          const Spacer(),
                          WeatherChart(
                            size: size,
                            heading: 'UV',
                            subheading: _weather?.uvindextext ?? "loading ...",
                            value: _weather?.uvindex ?? 0,
                            color: Colors.yellow,
                            minimum: 0,
                            maximum: 10,
                          ),
                          const Spacer(),
                          WeatherChart(
                            size: size,
                            heading: 'Humidity',
                            subheading: "${_weather?.humidity.toString()}%",
                            value: _weather?.humidity ?? 0,
                            color: Colors.blue,
                            minimum: 0,
                            maximum: 100,
                          ),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          const Spacer(),
                          WeatherChart(
                            size: size,
                            heading: 'Real Feel',
                            subheading: "${_weather?.realfeeltemperature}°",
                            value: _weather?.realfeeltemperature ?? 0,
                            color: Colors.green,
                            minimum: 0,
                            maximum: 60,
                          ),
                          const Spacer(),
                          WeatherChart(
                            size: size,
                            heading: 'Pressure',
                            subheading:
                                _weather?.pressure.toString() ?? "loading ...",
                            value: _weather?.pressure ?? 0,
                            color: Colors.blue,
                            minimum: 0,
                            maximum: 1084,
                          ),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Data provided by ",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: _launchUrl,
                            child: Image.asset(
                              "assets/images/accuweather.png",
                              scale: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                )
              : DotLottieLoader.fromAsset(
                  "assets/lottie/loading.lottie",
                  frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                    if (dotlottie != null) {
                      return Lottie.memory(
                        dotlottie.animations.values.single,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
        ),
      ),
    );
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/lottie/clear.lottie";
    switch (mainCondition.toLowerCase()) {
      case "clear":
        return "assets/lottie/clear.lottie";
      case "clouds and sun":
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
}
