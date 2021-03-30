import 'dart:ui';

import 'package:flutter/material.dart';

part 'theme_custom_colors.dart';

part 'theme_dark.dart';

part 'theme_light.dart';

final ThemeData lightTheme = _buildLightTheme();
final ThemeData darkTheme = _buildDarkTheme();

DialogTheme dialogTheme(Color dialogTitleColor, Color dialogContentColor,
    Color dialogOverlayBackgroundColor) {
  return DialogTheme(
      titleTextStyle: TextStyle(
          fontSize: 20.0,
          color: dialogTitleColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600),
      contentTextStyle: TextStyle(
          fontSize: 14.0,
          color: dialogContentColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.normal),
      backgroundColor: dialogOverlayBackgroundColor);
}

InputDecorationTheme inputDecorationTheme(
    Color inputFieldColor, Color hintTextColor) {
  return InputDecorationTheme(
    filled: true,
    fillColor: inputFieldColor,
    border: InputBorder.none,
    hintStyle: textStyle(hintTextColor),
  );
}

TextStyle textStyle(Color hintTextColor) {
  return TextStyle(
    fontSize: 14.0,
    color: hintTextColor,
    fontFamily: 'Averta',
    height: 1.4,
    letterSpacing: 0.01
  );
}

TextTheme textTheme(Color textColor, Color primaryColor,
    Color settingsHeaderRowColor, Color hintTextColor) {
  return TextTheme(
      headline: TextStyle(
          fontSize: 18.0,
          color: textColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600),
      subhead: TextStyle(
          fontSize: 16.0,
          color: textColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.12,
      ),
      title: TextStyle(
          fontSize: 20.0,
          color: primaryColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1
      ),
      subtitle: TextStyle(
        fontSize: 13.0,
        color: textColor,
        fontFamily: 'Averta',
        letterSpacing: 0.02,
        height:1.5,
      ),
      display1: TextStyle(
          fontSize: 13.0,
          color: primaryColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1),
      display2: TextStyle(
          fontSize: 13.0,
          color: Colors.white,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600),
      display3: TextStyle(
          fontSize: 14.0,
          color: settingsHeaderRowColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600),
      body1: textStyle(textColor),
      body2: TextStyle(
          fontSize: 16.0,
          color: primaryColor,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
      ),
      button: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontFamily: 'Averta',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
      ),
      caption: textStyle(hintTextColor));
}
