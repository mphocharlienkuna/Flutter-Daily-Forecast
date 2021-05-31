import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber[800],
        accentColor: Colors.black,
        fontFamily: 'Roboto Condensed Regular',
        scaffoldBackgroundColor: Colors.white,
      ),
      locale: Locale('en', 'US'),
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('th', 'TH'), // Thai
      ],
      initialRoute: HomeScreen.screenId,
      routes: {
        HomeScreen.screenId: (context) => HomeScreen(),
      },
    );
  }
}
