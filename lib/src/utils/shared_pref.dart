import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<List<String>> readCities(String key) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList(key) != null) {
      return prefs.getStringList(key);
    } else {
      return [];
    }
    return prefs.getStringList(key);
  }

  saveCity(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  saveFirstTimeRun(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future readFirstTimeRun(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(key) != null) {
      if (prefs.getBool(key)) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  removeCity(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
