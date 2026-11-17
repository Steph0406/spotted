import 'package:flutter/material.dart';

import 'package:spotted/domain/entities/spot.dart';
import 'package:spotted/presentation/screens/about/about_screen.dart';
import 'package:spotted/presentation/screens/detail/spot_detail_screen.dart';
import 'package:spotted/presentation/screens/form/spot_form_screen.dart';
import 'package:spotted/presentation/screens/list/spots_list_screen.dart';

/// Rutas con nombre de la app y su generador.
///
/// Toda la navegación pasa por aquí (Navigator.pushNamed), así las
/// pantallas no se conocen entre sí directamente.
class AppRoutes {
  AppRoutes._();

  static const String list = '/';
  static const String detail = '/detail';
  static const String form = '/form';
  static const String about = '/about';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case list:
        return MaterialPageRoute(
          builder: (_) => const SpotsListScreen(),
          settings: settings,
        );

      case detail:
        // El detalle necesita recibir el Spot como argumento.
        final args = settings.arguments;
        if (args is Spot) {
          return MaterialPageRoute(
            builder: (_) => SpotDetailScreen(spot: args),
            settings: settings,
          );
        }
        return _notFound(settings);

      case form:
        // Sin argumento = spot nuevo; con Spot = editar.
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => SpotFormScreen(spot: args is Spot ? args : null),
          settings: settings,
        );

      case about:
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
          settings: settings,
        );

      default:
        return _notFound(settings);
    }
  }

  static Route<dynamic> _notFound(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Pantalla no encontrada 🥲')),
      ),
    );
  }
}
