import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_weather_app/src/api/http_exception.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_event.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_state.dart';
import 'package:flutter_bloc_weather_app/src/model/weather.dart';
import 'package:flutter_bloc_weather_app/src/repository/weather_repository.dart';
import 'package:meta/meta.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({@required this.weatherRepository})
      : assert(weatherRepository != null);

  @override
  WeatherState get initialState => WeatherEmpty();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield* _mapFetchWeatherToState(event);
    } else if (event is RefreshWeather) {
      yield* _mapRefreshWeatherToState(event);
    }
  }

  Stream<WeatherState> _mapFetchWeatherToState(FetchWeather event) async* {
    yield WeatherLoading();
    try {
      final Weather weather = await weatherRepository.getWeather(event.cityName,
          latitude: event.latitude, longitude: event.longitude);
      yield WeatherLoaded(weather: weather);
    } catch (exception) {
      print(exception);
      if (exception is HTTPException) {
        yield WeatherError(errorCode: exception.code);
      } else {
        yield WeatherError(errorCode: 500);
      }
    }
  }

  Stream<WeatherState> _mapRefreshWeatherToState(RefreshWeather event) async* {
    try {
      final Weather weather =
          await weatherRepository.getWeather(event.cityName);
      yield WeatherLoaded(weather: weather);
    } catch (_) {
      yield WeatherError(errorCode: 500);
    }
  }
}
