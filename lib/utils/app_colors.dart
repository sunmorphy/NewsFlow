import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF8E2DE2);
  static const Color primaryOrange = Color(0xFFFF9966);

  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);

  static const Color error = Color(0xFFD32F2F);

  static const Gradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryPurple, primaryOrange],
  );
}
