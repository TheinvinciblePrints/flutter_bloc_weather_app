import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/bloc/city_bloc.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';
import 'package:flutter_bloc_weather_app/src/model/city.dart';
import 'package:flutter_bloc_weather_app/src/utils/string_utils.dart';

typedef OnSaveCallback = Function(List<String> selectedCities);

class CityScreen extends StatefulWidget {
  final OnSaveCallback onSave;

  CityScreen({@required this.onSave});

  @override
  CityScreenState createState() => CityScreenState();
}

class CityScreenState extends State<CityScreen> {
  final _cityBloc = CityBloc();

  List<String> _selectedCity = List<String>();
  List<String> _selectedFinalCity = List<String>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _cityBloc.fetchCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, right: 25.0),
            child: GestureDetector(
              onTap: () async {
                final list = await _cityBloc.getList();

                for (int i = 0; i < _selectedCity.length; i++) {
                  String selectedCityName = _selectedCity[i];
                  if (list.contains(selectedCityName)) {
                    _selectedCity.remove(selectedCityName);
                    return;
                  }
                }
                List<String> newList = list.followedBy(_selectedCity).toList();
//                print('_selectedCity $_selectedCity');
//                print('newList $newList');

                await _cityBloc.saveList(newList);
                widget.onSave(newList);
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  StringUtils.cityAdd,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppStateContainer.of(context).theme.accentColor,
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: AppStateContainer.of(context).theme.primaryColor,
        title: Text(
          StringUtils.chooseCity,
          style: TextStyle(
            color: AppStateContainer.of(context).theme.accentColor,
          ),
        ),
      ),
      body: _buildCities(),
    );
  }

  Widget _buildCities() {
    return StreamBuilder<List<City>>(
        stream: _cityBloc.cityStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(8.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _buildRow(snapshot.data[index], index);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildRow(City city, int index) {
    return CheckboxListTile(
      value: city.isSelected,
      checkColor: AppStateContainer.of(context).theme.primaryColor,
      onChanged: (val) {
        toggleSelection(city, index);
      },
      title: Text(
        city.city,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(city.country),
    );
  }

  void toggleSelection(City city, int index) {
    setState(() {
      if (city.isSelected) {
        city.isSelected = false;
        _selectedCity.remove(city.city);
      } else {
        city.isSelected = true;
        _selectedCity.add(city.city);
      }
    });
  }

  _showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('$message'),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _cityBloc.dispose();
  }
}
