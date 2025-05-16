import 'package:flutter/material.dart';

// App theme
class AppColors {
  static const Color primary = Color(0xFF3897F0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFEFEFEF);
  static const Color darkGrey = Color(0xFF999999);
  static const Color lightGrey = Color(0xFFF8F8F8);
  static const Color red = Color(0xFFED4956);
}

// App dimensions
class AppDimensions {
  static const double padding = 16.0;
  static const double borderRadius = 3.0;
  static const double buttonHeight = 44.0;
  static const double inputHeight = 44.0;
}

// Routes
class Routes {
  static const String login = '/login';
  static const String feed = '/feed';
}

// App assets
class AppAssets {
  static const String logoPath = 'assets/images/Instagram-Logo-2016-present.png';
}

// Text styles
class TextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.black,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.darkGrey,
  );
}