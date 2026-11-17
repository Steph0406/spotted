import 'package:flutter/material.dart';

import 'package:spotted/core/theme/category_style.dart';
import 'package:spotted/core/utils/formatters.dart';
import 'package:spotted/domain/entities/spot.dart';
import 'package:spotted/presentation/widgets/rating_stars.dart';
import 'package:spotted/presentation/widgets/spot_image.dart';

/// Tarjeta de un spot en la lista principal.
class SpotCard extends StatelessWidget {
  final Spot spot;
  final VoidCallback onTap;

  const SpotCard({super.key, required this.spot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SpotImage(spot: spot),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CategoryStyle.iconFor(spot.category),
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(spot.category, style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RatingStars(rating: spot.rating, size: 16),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (spot.hasLocation)
                    Icon(
                      Icons.location_on_rounded,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.date(spot.createdAt),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
