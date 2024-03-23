class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int sunrise;
  final int sunset;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.sunrise,
      required this.sunset,
      required this.mainCondition});

  factory Weather.fromJSON(Map<String, dynamic> json) {
    return Weather(
        cityName: json["name"],
        temperature: json["main"]["temp"].toDouble(),
        sunrise: json["sys"]["sunrise"].toInt(),
        sunset: json["sys"]["sunset"],
        mainCondition: json["weather"][0]["main"]);
  }
}
