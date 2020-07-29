import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/screens/main_screen.dart';
import 'package:flutter_bloc_weather_app/src/screens/settings_screen.dart';

class Routes {
  static final mainRoute = <String, WidgetBuilder>{
    '/home': (context) => MainScreen(),
    '/settings': (context) => SettingsScreen()
  };
}
