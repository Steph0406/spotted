import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'package:spotted/core/errors/app_exception.dart';

/// Coordenadas simples (registro de Dart).
typedef GeoPoint = ({double latitude, double longitude});

/// Contrato del servicio de ubicación (GADGET 3: GPS).
abstract class LocationService {
  /// Obtiene la posición GPS actual del dispositivo.
  /// Lanza [AppException] si el GPS está apagado o no hay permiso.
  Future<GeoPoint> getCurrentLocation();
}

/// Implementación con el paquete `geolocator`.
class GeolocatorLocationService implements LocationService {
  @override
  Future<GeoPoint> getCurrentLocation() async {
    try {
      // 1) ¿El GPS del teléfono está encendido?
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        throw const AppException('El GPS está apagado. Actívalo para guardar la ubicación.');
      }

      // 2) ¿Tenemos permiso? Si no, lo pedimos.
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw const AppException('Permiso de ubicación denegado.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw const AppException(
          'El permiso de ubicación está bloqueado. Actívalo en Ajustes.',
        );
      }

      // 3) Pedimos la posición actual con alta precisión.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return (latitude: position.latitude, longitude: position.longitude);
    } on AppException {
      rethrow; // ya trae un mensaje amigable
    } on TimeoutException catch (e) {
      // Si tarda demasiado, usamos la última ubicación conocida.
      final last = await _lastKnownOrNull();
      if (last != null) return last;
      throw AppException('No se pudo obtener la ubicación a tiempo.', e);
    } catch (e) {
      throw AppException('No se pudo obtener la ubicación.', e);
    }
  }

  Future<GeoPoint?> _lastKnownOrNull() async {
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last == null) return null;
      return (latitude: last.latitude, longitude: last.longitude);
    } catch (_) {
      return null;
    }
  }
}
