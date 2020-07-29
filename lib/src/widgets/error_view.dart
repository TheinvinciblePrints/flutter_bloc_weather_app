import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback action;
  final String message;

  ErrorView({@required this.action, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          message,
          style: TextStyle(
            color: AppStateContainer.of(context).theme.accentColor,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: FloatingActionButton(
            backgroundColor: AppStateContainer.of(context).theme.accentColor,
            child: Icon(
              Icons.refresh,
              size: 30,
              color: AppStateContainer.of(context).theme.primaryColor,
            ),
            onPressed: action,
          ),
        ),
      ],
    );
  }
}
