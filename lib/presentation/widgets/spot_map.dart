import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Mapa interactivo (OpenStreetMap) con un pin en la ubicación del spot.
///
/// Se usa `flutter_map` porque es gratuito y no requiere API key.
/// Permite arrastrar y hacer zoom con los dedos.
class SpotMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double height;

  const SpotMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 230,
  });

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);
    final color = Theme.of(context).colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 16,
            interactionOptions: const InteractionOptions(
              // Todo menos rotar, para que el mapa no se gire por accidente.
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.stephanie.spotted',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 48,
                  height: 48,
                  alignment: Alignment.topCenter, // la punta del pin en el punto
                  child: Icon(Icons.location_on_rounded, color: color, size: 48),
                ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
