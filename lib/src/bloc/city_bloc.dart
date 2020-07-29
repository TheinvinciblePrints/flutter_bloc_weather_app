import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc_weather_app/src/config/assets.dart';
import 'package:flutter_bloc_weather_app/src/model/city.dart';
import 'package:flutter_bloc_weather_app/src/utils/shared_pref.dart';
import 'package:flutter_bloc_weather_app/src/utils/shared_pref_constants.dart';

class CityBloc {
  List<City> _cities;

  List<String> defaultItems = ['Kuala Lumpur', 'George Town', 'Johor Bahru'];

  SharedPref sharedPref = SharedPref();

  List<String> _tabItems = [];

  List<String> get tabItems => _tabItems;

  final StreamController<List<City>> _cityController =
      StreamController<List<City>>();

  Stream<List<City>> get cityStream => _cityController.stream;

  Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  Future<City> fetchCity() async {
    List<dynamic> cityFromFile = await parseJsonFromAssets(Assets.cityJson);

    final _cityResponse = CityResponse.fromJson(cityFromFile);

    _cities = _cityResponse.city;
    _cityController.sink.add(_cities);
  }

  void dispose() {
    _cityController.close();
    _cities.clear();
  }

  Future saveList(List<String> list) async {
    await sharedPref.saveCity(CONSTANTS.SHARED_PREF_KEY_TABITEMS, list);
  }

  Future<List<String>> getList() {
    return sharedPref.readCities(CONSTANTS.SHARED_PREF_KEY_TABITEMS);
  }

  Future saveFirstTimeRun(bool value) async {
    await sharedPref.saveFirstTimeRun(
        CONSTANTS.SHARED_PREF_KEY_FIRST_TIME, value);
  }

  Future getFirstTimeRun() {
    return sharedPref.readFirstTimeRun(CONSTANTS.SHARED_PREF_KEY_FIRST_TIME);
  }

//  Future<List<String>> fetchFirstItem() async {
//    List<dynamic> cityFromFile = await parseJsonFromAssets(Assets.cityJson);
//
//    final _cityResponse = CityResponse.fromJson(cityFromFile);
//
//    _cities = _cityResponse.city;
//
//    for (int i = 0; i < _cities.length; i++) {
//      String cityObject = _cities[i].city;
//      for (int j = 0; j < defaultItems.length; j++) {
//        String defaultCityObject = defaultItems[j];
//        if (cityObject == defaultCityObject) {
//          tabItems.add(cityObject);
//        }
//      }
//    }
//
//    return tabItems;
//  }
}
