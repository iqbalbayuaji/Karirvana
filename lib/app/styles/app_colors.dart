import 'package:flutter/material.dart';

class AppColors {
  // Main Palette
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryContainer = Color(0xFFC7D2FE);
  static const Color secondary = Color(0xFF3B82F6); // Blue 500
  static const Color secondaryContainer = Color(0xFFBFDBFE);
  static const Color tertiary = Color(0xFFA855F7); // Purple 500

  // Layout Colors
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFEEF2FF); // For subtle cards/backgrounds
  static const Color outline = Color(0xFFCBD5E1);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textOnPrimary = Colors.white;

  // Gradients
  static const List<Color> heroGradient = [
    Color(0xFF3B82F6), // Biru
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Ungu
  ];

  static const List<Color> heroGradientSecondary = [
    Color.fromARGB(255, 71, 47, 207), // Biru
    Color.fromARGB(255, 129, 95, 209), // Ungu
  ];
}
