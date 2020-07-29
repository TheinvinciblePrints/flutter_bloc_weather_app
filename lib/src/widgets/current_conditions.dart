import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';
import 'package:flutter_bloc_weather_app/src/model/weather.dart';
import 'package:flutter_bloc_weather_app/src/utils/string_utils.dart';
import 'package:flutter_bloc_weather_app/src/widgets/value_tile.dart';

/// Renders Weather Icon, current, min and max temperatures
class CurrentConditions extends StatelessWidget {
  final Weather weather;

  const CurrentConditions({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          weather.getIconData(),
          color: AppStateContainer.of(context).theme.accentColor,
          size: 70,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          '${this.weather.temperature.as(AppStateContainer.of(context).temperatureUnit).round()}°',
          style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w100,
              color: AppStateContainer.of(context).theme.accentColor),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          ValueTile(StringUtils.max,
              '${this.weather.maxTemperature.as(AppStateContainer.of(context).temperatureUnit).round()}°'),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Center(
                child: Container(
              width: 1,
              height: 30,
              color:
                  AppStateContainer.of(context).theme.accentColor.withAlpha(50),
            )),
          ),
          ValueTile(StringUtils.min,
              '${this.weather.minTemperature.as(AppStateContainer.of(context).temperatureUnit).round()}°'),
        ]),
      ],
    );
  }
}
