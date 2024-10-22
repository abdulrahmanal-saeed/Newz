import 'package:flutter/material.dart';

class AppTheme {
  // الألوان الثابتة للتطبيق
  static const Color primary = Color(0xFFF44336); // اللون الأساسي
  static const Color accent = Color(0xFFBBFB4C); // لون الإبراز
  static const Color darkGray = Color(0xFF181818); // اللون الداكن
  static const Color lightGray = Color(0xFFF0F5F4);
  static const Color white = Color.fromARGB(255, 255, 255, 255);

  // إعدادات الثيم للـ Light Theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: darkGray,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(40),
          right: Radius.circular(40),
        ),
      ),
    ),
    scaffoldBackgroundColor: lightGray,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontFamily: 'AbrilFatface', // يمكنك تحديد نوع الخط هنا
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: darkGray,
      ),
      titleSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: lightGray,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
