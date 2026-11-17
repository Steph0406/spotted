import 'package:url_launcher/url_launcher.dart';

import 'package:spotted/core/errors/app_exception.dart';

/// Contrato para abrir coordenadas en una app de mapas externa.
abstract class MapsLauncher {
  Future<void> openInMaps(double latitude, double longitude);
}

/// Implementación con `url_launcher`: abre Google Maps (app o navegador)
/// con las coordenadas guardadas del spot.
class GoogleMapsLauncher implements MapsLauncher {
  @override
  Future<void> openInMaps(double latitude, double longitude) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        throw const AppException('No se encontró una app para abrir el mapa.');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('No se pudo abrir Google Maps.', e);
    }
  }
}
