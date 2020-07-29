import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_weather_app/src/api/api_keys.dart';
import 'package:flutter_bloc_weather_app/src/api/network/network_provider.dart';
import 'package:flutter_bloc_weather_app/src/api/weather_api_client.dart';
import 'package:flutter_bloc_weather_app/src/bloc/city_bloc.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_bloc.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_event.dart';
import 'package:flutter_bloc_weather_app/src/bloc/weather_state.dart';
import 'package:flutter_bloc_weather_app/src/config/assets.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';
import 'package:flutter_bloc_weather_app/src/enums/weather_enum.dart';
import 'package:flutter_bloc_weather_app/src/repository/weather_repository.dart';
import 'package:flutter_bloc_weather_app/src/screens/city_screen.dart';
import 'package:flutter_bloc_weather_app/src/screens/current_location_screen.dart';
import 'package:flutter_bloc_weather_app/src/utils/string_utils.dart';
import 'package:flutter_bloc_weather_app/src/widgets/error_view.dart';
import 'package:flutter_bloc_weather_app/src/widgets/no_internet_connection.dart';
import 'package:flutter_bloc_weather_app/src/widgets/weather_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(
          httpClient: http.Client(), apiKey: ApiKey.OPEN_WEATHER_MAP));

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  final _cityBloc = CityBloc();
  WeatherBloc _weatherBloc;

  String _cityName = '';
  int defaultCityIndex = 0;
  TabController _tabController;

  String _selectedTab;

  // String to set the default selected tab
  String defaultCity = StringUtils.defaultCity;

  List<String> defaultList;
  List<String> tabItems;

  @override
  void initState() {
    super.initState();

    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityResult>.value(
      stream: NetworkProvider().networkState,
      child: Consumer<ConnectivityResult>(
        builder: (context, value, model) {
          Widget container = NoInternetConnection();

          if (value == null) {
            container = Container();

            return container;
          }

          if (value != ConnectivityResult.none) {
            container = Scaffold(
              appBar: new AppBar(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      StringUtils.app_title,
                      style: TextStyle(
                        color: AppStateContainer.of(context).theme.accentColor,
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  _appBarIcons(Assets.iconCurrentLocation),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: PopupMenuButton<OptionsMenu>(
                            child: Icon(
                              Icons.more_vert,
                              color: AppStateContainer.of(context)
                                  .theme
                                  .accentColor,
                            ),
                            onSelected: this._onOptionMenuItemSelected,
                            itemBuilder: (context) =>
                                <PopupMenuEntry<OptionsMenu>>[
                                  PopupMenuItem<OptionsMenu>(
                                    value: OptionsMenu.selectCity,
                                    child: Text(StringUtils.selectCity),
                                  ),
                                  PopupMenuItem<OptionsMenu>(
                                    value: OptionsMenu.settings,
                                    child: Text(StringUtils.settings),
                                  ),
                                ]),
                      )),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor:
                      AppStateContainer.of(context).theme.accentColor,
                  labelColor: AppStateContainer.of(context).theme.accentColor,
                  unselectedLabelColor:
                      AppStateContainer.of(context).theme.accentColor,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: List<Widget>.generate(tabItems.length, (int index) {
                    return new Tab(
                        child: Text(tabItems[index],
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15.0)));
                  }),
                ),
                bottomOpacity: 1,
              ),
              body: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: AppStateContainer.of(context).theme.primaryColor,
                ),
                child: RefreshIndicator(
                  color: AppStateContainer.of(context).theme.primaryColor,
                  backgroundColor:
                      AppStateContainer.of(context).theme.accentColor,
                  child: _tabsContent(),
                  onRefresh: () => _refresh(),
                ),
              ),
            );
          }

          return container;
        },
      ),
    );
  }

  _onOptionMenuItemSelected(OptionsMenu item) {
    switch (item) {
      case OptionsMenu.selectCity:

        // Added the callback to refresh the tab items
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => CityScreen(
                    onSave: (List<String> selectedCities) {
                      if (selectedCities != null) {
                        _refreshData();
                      }
                    },
                  )),
        );
        break;
      case OptionsMenu.settings:
        Navigator.of(context).pushNamed("/settings");
        break;
    }
  }

  _fetchWeatherWithCity() {
    _weatherBloc.dispatch(FetchWeather(cityName: _cityName));
  }

  @override
  void dispose() {
    _tabController.dispose();
    NetworkProvider().disposeStreams();
    super.dispose();
  }

  _refresh() async {
    _weatherBloc.dispatch(RefreshWeather(cityName: this._cityName));
  }

  _tabsContent() {
    return Center(
      child: BlocBuilder(
          bloc: _weatherBloc,
          builder: (context, WeatherState weatherState) {
            if (weatherState is WeatherLoaded) {
              this._cityName = weatherState.weather.cityName;
              return ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: WeatherWidget(
                      weather: weatherState.weather,
                    ),
                  ),
                ],
              );
            } else if (weatherState is WeatherError) {
              String errorText = StringUtils.errorFetchingData;
              if (weatherState is WeatherError) {
                if (weatherState.errorCode == 404) {
                  errorText = StringUtils.troubleFetchingData + _cityName;
                }
              }
              return Container(
                child: Center(
                  child: ErrorView(
                    action: () async {
                      await _fetchWeatherWithCity;
                    },
                    message: errorText,
                  ),
                ),
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

  Widget _appBarIcons(String icon) {
    return Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => CurrentLocationScreen(
                        context: context,
                      )),
            );
          },
          child: Image(
            image: AssetImage(icon),
            width: 26,
            height: 10,
            color: AppStateContainer.of(context).theme.accentColor,
          ),
        ));
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.indexIsChanging) {
        _selectedTab = tabItems[_tabController.index];

        // Added cityName to be equal to the selectedTab name
        _cityName = _selectedTab.toString().split('.').last;

        _fetchWeatherWithCity();
      }
    });
  }

  void _refreshData() {
    _cityBloc.getFirstTimeRun().then((value) {
      if (value) {
        defaultList = _cityBloc.defaultItems;
        _cityBloc.saveList(defaultList).then((value) {
          _cityBloc.saveFirstTimeRun(false).then((value) => getData());
        });
      } else {
        getData();
      }
    });
  }

  getData() {
    _cityBloc.getList().then((value) {
      tabItems = value;

      if (value.contains(defaultCity)) {
        defaultCityIndex = tabItems.indexOf(defaultCity);
      } else {
        defaultCityIndex = 0;
      }
      _tabController = TabController(
          length: tabItems.length, initialIndex: defaultCityIndex, vsync: this);

      _selectedTab = tabItems[_tabController.index];

//      print('tabItems ${tabItems}');

      _cityName = _selectedTab.toString().split('.').last;

      _tabController.addListener(_handleTabSelection);

      _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
      _fetchWeatherWithCity();
    });
  }
}
