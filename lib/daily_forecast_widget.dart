import 'package:daily_forecast/model/weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'daily_forecast_list_widget.dart';

class ShowDailyForecast extends StatelessWidget {
  const ShowDailyForecast({
    Key key,
    @required this.weatherList,
  }) : super(key: key);

  final List<WeatherList> weatherList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Daily Forecast'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontFamily: 'Roboto Condensed Regular',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('EEEE, dd MMM yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              weatherList[0].time * 1000)),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black38,
                        fontFamily: 'Roboto Condensed Regular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _getImagePath(weatherList[0].main, true),
                  Text(
                    weatherList[0].max.round().toString() + '°',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 54.0,
                      color: Colors.black,
                      fontFamily: 'Roboto Condensed Regular',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'MAX'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black38,
                                fontFamily: 'Roboto Condensed Regular',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            weatherList[0].max.round().toString() + '°',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontFamily: 'Roboto Condensed Regular',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        child: VerticalDivider(color: Colors.black38),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'MIN'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black38,
                                fontFamily: 'Roboto Condensed Regular',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            weatherList[0].min.round().toString() + '°',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontFamily: 'Roboto Condensed Regular',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Divider(color: Colors.black38),
            ),
            ShowDailyForecastList(weatherList: weatherList),
            Container(
              child: Divider(color: Colors.black38),
            ),
          ],
        ),
      ),
    );
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
