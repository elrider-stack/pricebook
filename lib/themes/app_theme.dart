import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF0F9D58);
  static const Color secondary = Color(0xFFC9A227);

  static ThemeData light =
      FlexThemeData.light(
        scheme: FlexScheme.material,
        primary: primary,
        secondary: secondary,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 8,
        useMaterial3: true,
        appBarStyle: FlexAppBarStyle.primary,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 12,
          blendOnColors: true,
          defaultRadius: 18,
          cardRadius: 20,
          inputDecoratorRadius: 16,
          fabRadius: 18,
          elevatedButtonRadius: 16,
          outlinedButtonRadius: 16,
          textButtonRadius: 16,
          chipRadius: 20,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        cardTheme: CardThemeData(
          elevation: 3,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );

  static ThemeData dark =
      FlexThemeData.dark(
        scheme: FlexScheme.material,
        primary: primary,
        secondary: secondary,
        surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
        blendLevel: 12,
        useMaterial3: true,
        appBarStyle: FlexAppBarStyle.primary,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: true,
          defaultRadius: 18,
          cardRadius: 20,
          inputDecoratorRadius: 16,
          fabRadius: 18,
          elevatedButtonRadius: 16,
          outlinedButtonRadius: 16,
          textButtonRadius: 16,
          chipRadius: 20,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      );
}
