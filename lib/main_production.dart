import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/main.dart';
import 'package:flutter_bloc_weather_app/src/bloc_delegate.dart';
import 'package:flutter_bloc_weather_app/src/config/flavor_config.dart';
import 'package:flutter_bloc_weather_app/src/constants/app_constants.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      values: FlavorValues(baseUrl: AppConstants.production_url));

  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(AppStateContainer(child: WeatherApp()));
}
