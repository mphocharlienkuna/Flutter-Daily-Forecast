import 'package:daily_forecast/model/weather.dart';
import 'package:flutter/material.dart';

class ShowDailyForecastList extends StatelessWidget {
  const ShowDailyForecastList({
    Key key,
    @required this.weatherList,
  }) : super(key: key);

  final List<WeatherList> weatherList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _getProductListWidgets(),
          ),
        ),
      ],
    );
  }

  Widget _getProductListWidgets() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < weatherList.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: Center(
            child: Container(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      weatherList[i].dayOfWeek,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black38,
                        fontFamily: 'Roboto Condensed Regular',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFECEFF1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _getImagePath(weatherList[i].main, false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      weatherList[i].max.round().toString() + '°',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Roboto Condensed Regular',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return new Row(children: list);
  }

  Widget _getImagePath(String img, bool isList) {
    return img.toLowerCase() == 'SUNNY'.toLowerCase()
        ? Icon(
            Icons.wb_sunny,
            size: !isList ? 18.0 : 196.0,
          )
        : Icon(
            Icons.cloud_circle,
            size: !isList ? 18.0 : 196.0,
          );
  }
}
