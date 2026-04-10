import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1E3A5F),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    );
  }
}
