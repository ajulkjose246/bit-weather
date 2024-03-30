class Weather {
  final String weatherText;
  final double temperatureCelsius;
  final String uvindextext;
  final String link;
  final double uvindex;
  final double humidity;
  final double realfeeltemperature;
  final double pressure;

  Weather({
    required this.uvindextext,
    required this.uvindex,
    required this.link,
    required this.humidity,
    required this.weatherText,
    required this.temperatureCelsius,
    required this.realfeeltemperature,
    required this.pressure,
  });

  factory Weather.fromJSON(Map<String, dynamic> json) {
    return Weather(
      weatherText: json["WeatherText"] ?? "",
      temperatureCelsius: json["Temperature"]["Metric"]["Value"] ?? 0.0,
      uvindextext: json["UVIndexText"] ?? "",
      uvindex: json["UVIndex"].toDouble() ?? 0.0,
      humidity: json["RelativeHumidity"].toDouble() ?? 0.0,
      realfeeltemperature:
          json["RealFeelTemperature"]["Metric"]["Value"].toDouble() ?? 0.0,
      pressure: json["Pressure"]["Metric"]["Value"].toDouble() ?? 0.0,
      link: json["Link"] ?? "",
    );
  }
}
