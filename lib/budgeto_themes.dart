import 'package:budgeto/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeSwitch extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void switchTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class BudgetoThemes {
  static final lightTheme = ThemeData(
    canvasColor: kCardColor,
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
      canvasColor: kDarkCardC,
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
