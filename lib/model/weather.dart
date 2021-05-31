import 'package:json_annotation/json_annotation.dart';

class WeatherList {
  int time;
  String dayOfWeek;
  String main;
  double min;
  double max;
  double current;

  WeatherList(
      {this.time, this.dayOfWeek, this.main, this.min, this.max, this.current});

  factory WeatherList.fromJson(Map<String, dynamic> json) => WeatherList(
        dayOfWeek: json["dayOfWeek"],
        main: json["main"],
        min: json["min"],
        max: json["max"],
        current: json["current"],
      );

  Map<String, dynamic> toJson() => {
        '"time"': '"$time"',
        '"dayOfWeek"': '"$dayOfWeek"',
        '"main"': '"$main"',
        '"min"': '"$min"',
        '"max"': '"$max"',
        '"current"': '"$current"',
      };
}

@JsonSerializable()
class Weather {
  int id;
  String main;

  Weather({this.id, this.main});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: json["main"],
      );

  Map<String, dynamic> toJson() => {
        '"id"': '"$id"',
        '"main"': '"$main"',
      };
}

class Temp {
  double temp_min;
  double temp_max;

  Temp({this.temp_min, this.temp_max});

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
        temp_min: double.parse(json["temp_min"].toString()),
        temp_max: double.parse(json["temp_max"].toString()),
      );

  Map<String, dynamic> toJson() => {
        '"temp_min"': '"$temp_min"',
        '"temp_max"': '"$temp_max"',
      };
}

class DailyForecast {
  int time;

  @JsonKey(name: 'main')
  Temp temp;

  @JsonKey(name: 'weather')
  List<Weather> weather;

  @JsonKey(name: 'dt_txt')
  String dtTxt;

  DailyForecast({this.time, this.temp, this.weather, this.dtTxt});

  factory DailyForecast.fromJson(Map<String, dynamic> json) => DailyForecast(
        time: json['dt'],
        temp: Temp.fromJson(json["main"]),
        dtTxt: json["dt_txt"],
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        '"dt"': '"$time"',
        '"main"': temp.toJson(),
        '"dt_txt"': '"$dtTxt"',
        '"weather"': List<dynamic>.from(weather.map((x) => x.toJson())),
      };
}

class DailyForecastResponse {
  List<DailyForecast> forecastList;

  DailyForecastResponse({this.forecastList});

  factory DailyForecastResponse.fromJson(Map<String, dynamic> json) =>
      DailyForecastResponse(
        forecastList: List<DailyForecast>.from(
            json["list"].map((x) => DailyForecast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        '"list"': List<dynamic>.from(forecastList.map((x) => x.toJson())),
      };
}
