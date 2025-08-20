import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF043838);
  static const Color primaryLight = Color(0xFF043838);

  // Secondary Colors
  static const Color secondary = Color(0xFF024632);
  static const Color secondaryLight = Color(0xFF024632);

  // Background Colors
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color ghostWhite = Color(0xffF8F8FF);
  static const Color grey100 = Color(0xfff1efef);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey = Colors.grey;

  // Text Colors
  static const Color textPrimary = Color(0xFF0C99D2);
  static const Color textSecondary = Color(0xFF0A5F86);
  static const Color textBlack = Colors.black;
  static const Color textBlack54 = Colors.black54;
  static const Color textWhite = Colors.white;
  static const Color textGreen = Colors.green;
  static const Color textRed = Colors.red;
  static const Color textYellow = Colors.yellow;

  // static const Color

  // Input Colors
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFF0C99D2);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF0C99D2);
  static const Color buttonText = Colors.white;

  // Icon Colors
  static const Color iconPrimary = Color(0xFF0C99D2);

  // Gradient Colors
  static List<Color> get backgroundGradient =>
      [primary.withOpacity(0.1), background];
}
