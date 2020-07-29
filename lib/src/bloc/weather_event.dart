import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class WeatherEvent extends Equatable {
  WeatherEvent([List props = const []]) : super(props);
}

class FetchWeather extends WeatherEvent {
  final String cityName;
  final double longitude;
  final double latitude;

  FetchWeather({this.cityName, this.longitude, this.latitude})
      : assert(cityName != null || longitude != null || latitude != null),
        super([cityName, longitude, latitude]);
}

class RefreshWeather extends WeatherEvent {
  final String cityName;

  RefreshWeather({@required this.cityName}) : assert(cityName != null);

  @override
  List<Object> get props => [cityName];
}
