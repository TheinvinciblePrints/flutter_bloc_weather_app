import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';
import 'package:flutter_bloc_weather_app/src/screens/main_screen.dart';
import 'package:flutter_bloc_weather_app/src/screens/routes.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppStateContainer.of(context).theme,
      home: MainScreen(),
      routes: Routes.mainRoute,
    );
  }
}
