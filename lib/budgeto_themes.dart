import 'package:budgeto/colors.dart';
import 'package:flutter/material.dart';

class BudgetoThemes {
  static final lightTheme = ThemeData(
    textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kFontBlackC),
        bodyMedium: TextStyle(color: kFontBlackC),
        bodySmall: TextStyle(color: kFontBlackC)),
    fontFamily: 'Outfit',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    primaryColor: kGreenColor,
    cardColor: kCardColor,
    inputDecorationTheme: InputDecorationTheme(
      hoverColor: kGreenColor,
      focusColor: kTextFieldColor,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kTextFieldBorderC),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kTextFieldBorderC),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final darkTheme = ThemeData(
      datePickerTheme: const DatePickerThemeData(
          todayBorder: BorderSide(color: kDarkGreenColor),
          rangePickerSurfaceTintColor: kDarkGreenColor),
      fontFamily: 'Outfit',
      scaffoldBackgroundColor: kDarkScaffoldC,
      colorScheme: const ColorScheme.dark(),
      cardColor: kDarkCardC,
      primaryColor: kDarkGreenColor,
      inputDecorationTheme: InputDecorationTheme(
          hoverColor: kDarkGreenColor,
          focusColor: kDarkGreenColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          )));

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
