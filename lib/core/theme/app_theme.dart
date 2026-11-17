import 'package:flutter/material.dart';

/// Tema visual de Spotted: paleta pastel rosa + lila (Material 3).
///
/// Centralizar colores y estilos aquí cumple Responsabilidad Única:
/// si queremos cambiar el look de la app, solo se toca este archivo.
class AppTheme {
  AppTheme._(); // no se instancia

  static const Color pink = Color(0xFFF06292);
  static const Color lilac = Color(0xFFB39DDB);
  static const Color background = Color(0xFFFFF7FB);
  static const Color star = Color(0xFFFFB300);

  /// Degradado de marca (encabezado del Drawer, imágenes sin foto).
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFFF8BBD0), Color(0xFFD1C4E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: pink,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: scheme.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
