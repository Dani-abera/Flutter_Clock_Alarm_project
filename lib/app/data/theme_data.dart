import 'package:flutter/material.dart';

class CustomColors {
  static Color primaryTextColor = Colors.white;
  static Color seconderyTextColor = Colors.black;
  static Color dividerColor = Colors.white;
  static Color pageBackgroundColor = Color.fromARGB(255, 89, 61, 28);
  static Color menuBackgroundColor = Colors.white;

  static Color clockBG = Colors.white30;
  static Color clockOutline = Colors.white54;
  static Color? secHandColor = Colors.orange;
  static Color minHandStatColor = Color(0xFF748EF6);
  static Color minHandEndColor = Color(0xFF77DDFF);
  static Color hourHandStatColor = Color(0xFF748EF6);
  static Color hourHandEndColor = Color(0xFF77DDFF);
}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF5FC6FF), Color(0x4C6255EA)];
  static List<Color> Soft_bloom = [Color(0x3B82EB), Color(0xFF5FC6FF)];
  static List<Color> Twilight_Bliss = [Color(0x9B59B6), Color(0xFF6448FE)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.Soft_bloom),
    GradientColors(GradientColors.Twilight_Bliss),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
  ];
}