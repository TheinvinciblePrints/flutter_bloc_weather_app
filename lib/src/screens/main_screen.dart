import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/api/network/network_provider.dart';
import 'package:flutter_bloc_weather_app/src/screens/weather_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provider<NetworkProvider>(
        builder: (context) => NetworkProvider(),
        child: Consumer<NetworkProvider>(
          builder: (context, value, _) => Center(
            child: WeatherScreen(),
          ),
        ),
      ),
    );
  }
}
