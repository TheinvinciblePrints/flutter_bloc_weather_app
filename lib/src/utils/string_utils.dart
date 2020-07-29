class StringUtils {
  static String app_title = 'Bloc Weather App';
  static String current_location_title = 'Current Location';
  static String subtitle = 'subtitle';
  static String title = 'title';
  static String filter = 'Filter by name or email or body';
  static String requestTimeout = 'Request timeout please refresh';
  static String noInternetConnection = 'No Internet Connection';
  static String noInternetSub = 'You are not connected to the internet.';
  static String noInternet =
      'Make sure Wi-Fi is on, Airplane Mode is off\n and try again';
  static String cityAdd = 'Add';
  static String chooseCity = 'Choose a city';
  static String selectCity = 'Select city';
  static String locationDisabled = 'Location is disabled :(';
  static String locationEnable = 'Enable!';
  static String errorFetchingData = 'There was an error fetching weather data';
  static String troubleFetchingData = 'We have trouble fetching weather for';
  static String settings = 'Settings';
  static String theme = 'Theme';
  static String darkTheme = 'Dark';
  static String lightTheme = 'Light';
  static String unit = 'Unit';
  static String temperature = 'Temperature';
  static String celsius = 'Celsius';
  static String windSpeed = 'wind speed';
  static String fahrenheit = 'Fahrenheit';
  static String sunrise = 'sunrise';
  static String humidity = 'humidity';
  static String kelvin = 'Kelvin';
  static String max = 'max';
  static String min = 'min';
  static String defaultCity = 'Kuala Lumpur';

  static String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }
}
