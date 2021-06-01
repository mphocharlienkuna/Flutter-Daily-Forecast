import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/strings.dart';
import 'daily_forecast_widget.dart';
import 'model/weather.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static const String screenId = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  var networkState = false;

  var locationState = false;

  var errorState = false;

  List<WeatherList> mWeather;
  StreamSubscription<ConnectivityResult> subscription;
  StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    _setStatusBar(context);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _initConnectivity(context);
    });
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    positionStream.cancel();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _setStatusBar(context);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: !networkState
                    ? showNoNetwork(context, Strings.NoInternetConnection,
                        Strings.NoInternetConnectionTryAgain)
                    : !locationState
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.amber[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : mWeather != null
                            ? ShowDailyForecast(weatherList: mWeather)
                            : !errorState
                                ? Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor:
                                                  Colors.amber[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : showNoNetwork(context, Strings.errorHeading,
                                    Strings.errorMessage)),
          ),
        ],
      ),
    );
  }

  showNoNetwork(BuildContext context, String heading, String subHeading) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Strings.NoInternetConnection,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF808080),
                fontFamily: 'Roboto Condensed Regular',
                fontWeight: FontWeight.w900),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              Strings.NoInternetConnectionTryAgain,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto Condensed Regular',
                color: Color(0xFF808080),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          Strings.btnTryAgain,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto Condensed Regular',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _initConnectivity(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initConnectivity(BuildContext context) async {
    setState(() {
      networkState = false;
      locationState = false;
      errorState = false;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)
      setState(() {
        networkState = false;
        locationState = false;
      });
    else
      setState(() => networkState = true);

    if (networkState) _checkPermissionStatus();
  }

  void _checkPermissionStatus() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      var isPermissionGranted = false;
      if (await Permission.locationWhenInUse.isGranted) {
        isPermissionGranted = true;
      } else if (await Permission.location.isGranted) {
        isPermissionGranted = true;
      } else if (await Permission.locationAlways.isGranted) {
        isPermissionGranted = true;
      } else {
        Geolocator.openAppSettings();
      }

      if (isPermissionGranted) {
        positionStream =
            Geolocator.getPositionStream().listen((Position position) async {
          if (position != null) {
            setState(() => locationState = true);
            _fetchDailyForecast(context, position.latitude, position.longitude);
          }
        });
      }
    } else {
      Geolocator.openAppSettings();
    }
  }

  Future<void> _fetchDailyForecast(
      BuildContext context, double latitude, double longitude) async {
    final response = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast#lat=$latitude&lon=$longitude&APPID=53f9d8e4213222cf517d86dc406d67fc&units=metric');
    var newUri =
        await http.get(Uri.parse(response.toString().replaceFirst('#', '?')));
    if (newUri.statusCode == 200) {
      List<DailyForecast> weathers =
          DailyForecastResponse.fromJson(jsonDecode(newUri.body)).forecastList;

      mWeather = [];
      List<WeatherList> weatherList = [];

      var dayOfWeek = '';
      for (var forecast in weathers) {
        if (dayOfWeek.toLowerCase().toString() !=
            DateFormat('E')
                .format(
                    DateTime.fromMillisecondsSinceEpoch(forecast.time * 1000))
                .toLowerCase()) {
          dayOfWeek = DateFormat('EEE').format(
              DateTime.fromMillisecondsSinceEpoch(forecast.time * 1000));
          weatherList.add(WeatherList(
              time: forecast.time,
              dayOfWeek: DateFormat('E, ha').format(
                  DateTime.fromMillisecondsSinceEpoch(forecast.time * 1000)),
              main: forecast.weather[0].main,
              min: forecast.temp.temp_min,
              max: forecast.temp.temp_max,
              current: forecast.temp.temp_max));
        }
      }
      setState(() => mWeather.addAll(weatherList));
    } else {
      setState(() {
        mWeather = [];
        errorState = true;
      });
    }
  }

  Future<void> _setStatusBar(BuildContext context) async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    _initConnectivity(context);
  }
}