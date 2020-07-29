import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_weather_app/src/config/assets.dart';
import 'package:flutter_bloc_weather_app/src/enums/app_state.dart';
import 'package:flutter_bloc_weather_app/src/utils/string_utils.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: AppStateContainer.of(context).theme.primaryColor,
        ),
        child: _mainView(context),
      ),
    );
  }

  Widget _titleText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: _textItem(
          StringUtils.noInternetConnection, StringUtils.title, context),
    );
  }

  Widget _subTitleText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: <Widget>[
          _textItem(StringUtils.noInternetSub, StringUtils.subtitle, context),
          _textItem(StringUtils.noInternet, StringUtils.subtitle, context),
        ],
      ),
    );
  }

  Widget _textItem(String text, String type, BuildContext context) {
    final TextStyle _titleTextStyle = TextStyle(
        color: AppStateContainer.of(context).theme.accentColor,
        fontSize: 24,
        fontWeight: FontWeight.bold);

    final TextStyle _subTitleTextStyle = TextStyle(
        color: AppStateContainer.of(context).theme.accentColor,
        fontSize: 14,
        fontWeight: FontWeight.bold);

    switch (type) {
      case 'title':
        return Text(
          text,
          style: _titleTextStyle,
          textAlign: TextAlign.center,
        );
        break;

      case 'subtitle':
        return Text(
          text,
          style: _subTitleTextStyle,
          textAlign: TextAlign.center,
        );
        break;
    }
  }

  Widget _mainView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage(Assets.iconNoInternet),
          width: 150,
          height: 150,
          color: AppStateContainer.of(context).theme.accentColor,
        ),
        _titleText(context),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: _subTitleText(context),
        ),
      ],
    );
  }
}
