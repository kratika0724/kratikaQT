import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF0C99D2);
  static const Color primaryLight = Color(0xFF0C99D2);

  // Background Colors
  static const Color background = Colors.white;
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF0C99D2);
  static const Color textSecondary = Colors.grey;

  // Input Colors
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBorder = Color(0xFF0C99D2);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF0C99D2);
  static const Color buttonText = Colors.white;

  // Icon Colors
  static const Color iconPrimary = Color(0xFF0C99D2);

  // Gradient Colors
  static List<Color> get backgroundGradient => [
        primary.withOpacity(0.1),
        background,
      ];
}
