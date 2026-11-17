import 'package:flutter/material.dart';

import 'package:spotted/core/theme/app_theme.dart';

/// Estrellas de calificación (1 a 5).
///
/// Si se pasa [onChanged], las estrellas se pueden tocar (formulario);
/// si no, solo se muestran (lista y detalle).
class RatingStars extends StatelessWidget {
  final int rating;
  final double size;
  final ValueChanged<int>? onChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final icon = Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: AppTheme.star,
        );
        if (onChanged == null) return icon;
        return GestureDetector(
          onTap: () => onChanged!(index + 1),
          child: Padding(padding: const EdgeInsets.all(4), child: icon),
        );
      }),
    );
  }
}
