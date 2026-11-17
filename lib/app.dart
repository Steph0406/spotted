import 'package:flutter/material.dart';

import 'package:spotted/core/routes/app_routes.dart';
import 'package:spotted/core/theme/app_theme.dart';

/// Widget raíz: configura tema y navegación por rutas con nombre.
class SpottedApp extends StatelessWidget {
  const SpottedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotted',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.list,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
