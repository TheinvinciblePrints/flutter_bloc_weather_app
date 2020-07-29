import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';
import 'package:flutter_bloc_weather_app/src/themes.dart';
import 'package:flutter_bloc_weather_app/src/utils/converters.dart';
import 'package:flutter_bloc_weather_app/src/utils/string_utils.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStateContainer.of(context).theme.primaryColor,
        title: Text(StringUtils.settings),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        color: AppStateContainer.of(context).theme.primaryColor,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                StringUtils.theme,
                style: TextStyle(
                  color: AppStateContainer.of(context).theme.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.1),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtils.darkTheme,
                    style: TextStyle(
                        color: AppStateContainer.of(context).theme.accentColor),
                  ),
                  Radio(
                    value: Themes.DARK_THEME_CODE,
                    groupValue: AppStateContainer.of(context).themeCode,
                    onChanged: (value) {
                      AppStateContainer.of(context).updateTheme(value);
                    },
                    activeColor:
                        AppStateContainer.of(context).theme.accentColor,
                  )
                ],
              ),
            ),
            Divider(
              color: AppStateContainer.of(context).theme.primaryColor,
              height: 1,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.1),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtils.lightTheme,
                    style: TextStyle(
                        color: AppStateContainer.of(context).theme.accentColor),
                  ),
                  Radio(
                    value: Themes.LIGHT_THEME_CODE,
                    groupValue: AppStateContainer.of(context).themeCode,
                    onChanged: (value) {
                      AppStateContainer.of(context).updateTheme(value);
                    },
                    activeColor:
                        AppStateContainer.of(context).theme.accentColor,
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 8),
              child: Text(
                StringUtils.unit,
                style: TextStyle(
                  color: AppStateContainer.of(context).theme.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.1),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtils.celsius,
                    style: TextStyle(
                        color: AppStateContainer.of(context).theme.accentColor),
                  ),
                  Radio(
                    value: TemperatureUnit.celsius.index,
                    groupValue:
                        AppStateContainer.of(context).temperatureUnit.index,
                    onChanged: (value) {
                      AppStateContainer.of(context)
                          .updateTemperatureUnit(TemperatureUnit.values[value]);
                    },
                    activeColor:
                        AppStateContainer.of(context).theme.accentColor,
                  )
                ],
              ),
            ),
            Divider(
              color: AppStateContainer.of(context).theme.primaryColor,
              height: 1,
            ),
            Container(
              color: AppStateContainer.of(context)
                  .theme
                  .accentColor
                  .withOpacity(0.1),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtils.fahrenheit,
                    style: TextStyle(
                        color: AppStateContainer.of(context).theme.accentColor),
                  ),
                  Radio(
                    value: TemperatureUnit.fahrenheit.index,
                    groupValue:
                        AppStateContainer.of(context).temperatureUnit.index,
                    onChanged: (value) {
                      AppStateContainer.of(context)
                          .updateTemperatureUnit(TemperatureUnit.values[value]);
                    },
                    activeColor:
                        AppStateContainer.of(context).theme.accentColor,
                  )
                ],
              ),
            ),
            Divider(
              color: AppStateContainer.of(context).theme.primaryColor,
              height: 1,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: AppStateContainer.of(context)
                    .theme
                    .accentColor
                    .withOpacity(0.1),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtils.kelvin,
                    style: TextStyle(
                        color: AppStateContainer.of(context).theme.accentColor),
                  ),
                  Radio(
                    value: TemperatureUnit.kelvin.index,
                    groupValue:
                        AppStateContainer.of(context).temperatureUnit.index,
                    onChanged: (value) {
                      AppStateContainer.of(context)
                          .updateTemperatureUnit(TemperatureUnit.values[value]);
                    },
                    activeColor:
                        AppStateContainer.of(context).theme.accentColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
