import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_weather_app/src/api/api_keys.dart';
import 'package:flutter_bloc_weather_app/src/api/weather_api_client.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_bloc.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_event.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_state.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';
import 'package:flutter_bloc_weather_app/src/repository/weather_repository.dart';
import 'package:flutter_bloc_weather_app/src/utils/string_utils.dart';
import 'package:flutter_bloc_weather_app/src/widgets/error_view.dart';
import 'package:flutter_bloc_weather_app/src/widgets/weather_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class CurrentLocationScreen extends StatefulWidget {
  final BuildContext context;

  CurrentLocationScreen({this.context});

  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(
          httpClient: http.Client(), apiKey: ApiKey.OPEN_WEATHER_MAP));

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen>
    with TickerProviderStateMixin {
  WeatherBloc _weatherBloc;

  String _cityName = '';

  @override
  void initState() {
    super.initState();

    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    _fetchWeatherWithLocation().catchError((error) {
      _fetchWeatherWithCity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              StringUtils.current_location_title,
              style: TextStyle(
                color: AppStateContainer.of(context).theme.accentColor,
              ),
            )
          ],
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: AppStateContainer.of(context).theme.primaryColor,
        ),
        child: Container(
          color: AppStateContainer.of(context).theme.primaryColor,
          child: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: _tabsContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _fetchWeatherWithCity() {
    _weatherBloc.dispatch(FetchWeather(cityName: _cityName));
  }

  _fetchWeatherWithLocation() async {
    var permissionHandler = PermissionHandler();
    var permissionResult = await permissionHandler
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    switch (permissionResult[PermissionGroup.locationWhenInUse]) {
      case PermissionStatus.denied:
      case PermissionStatus.unknown:
        print('location permission denied');
        _showLocationDeniedDialog(permissionHandler);
        throw Error();
    }

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    _weatherBloc.dispatch(FetchWeather(
        longitude: position.longitude, latitude: position.latitude));
  }

  void _showLocationDeniedDialog(PermissionHandler permissionHandler) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(StringUtils.locationDisabled,
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  StringUtils.locationEnable,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                onPressed: () {
                  permissionHandler.openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _tabsContent() {
    return Center(
      child: BlocBuilder(
          bloc: _weatherBloc,
          builder: (context, WeatherState weatherState) {
            if (weatherState is WeatherLoaded) {
              this._cityName = weatherState.weather.cityName;
              return WeatherWidget(
                weather: weatherState.weather,
              );
            } else if (weatherState is WeatherError) {
              String errorText = StringUtils.errorFetchingData;
              if (weatherState is WeatherError) {
                if (weatherState.errorCode == 404) {
                  errorText = StringUtils.troubleFetchingData + _cityName;
                }
              }
              return ErrorView(
                action: () async {
                  await _fetchWeatherWithCity;
                },
                message: errorText,
              );
            } else if (weatherState is WeatherEmpty) {
              return Container();
            } else if (weatherState is WeatherLoading) {
//                      print('message: LOADING..');
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor:
                      AppStateContainer.of(context).theme.primaryColor,
                ),
              );
            }
            return null;
          }),
    );
  }
}
