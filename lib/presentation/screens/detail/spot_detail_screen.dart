import 'package:flutter/material.dart';

import 'package:spotted/core/theme/category_style.dart';
import 'package:spotted/core/utils/formatters.dart';
import 'package:spotted/domain/entities/spot.dart';
import 'package:spotted/presentation/widgets/rating_stars.dart';
import 'package:spotted/presentation/widgets/spot_image.dart';

/// Detalle de un spot.
///
/// VERSIÓN DEL PASO 3: muestra la imagen (con Hero), datos y descripción.
/// En el Paso 8 se agregan el mapa, Google Maps, editar y eliminar.
class SpotDetailScreen extends StatelessWidget {
  final Spot spot;

  const SpotDetailScreen({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(spot.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Mismo Hero tag que en la lista => animación de transición.
          SpotImage(
            spot: spot,
            width: double.infinity,
            height: 260,
            borderRadius: 24,
          ),
          const SizedBox(height: 20),
          Text(
            spot.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(CategoryStyle.iconFor(spot.category),
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(spot.category),
              const Spacer(),
              RatingStars(rating: spot.rating, size: 22),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.date(spot.createdAt),
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 20),
          Text(
            spot.description.isEmpty ? 'Sin descripción.' : spot.description,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
