import 'dart:io';

import 'package:flutter/material.dart';

import 'package:spotted/core/theme/app_theme.dart';
import 'package:spotted/domain/entities/spot.dart';

/// Imagen de un spot envuelta en un [Hero].
///
/// Se usa en la lista (miniatura) y en el detalle (imagen grande).
/// Como ambas usan el MISMO tag, Flutter anima la imagen "volando"
/// de una pantalla a otra.
class SpotImage extends StatelessWidget {
  final Spot spot;
  final double width;
  final double height;
  final double borderRadius;

  const SpotImage({
    super.key,
    required this.spot,
    this.width = 84,
    this.height = 84,
    this.borderRadius = 16,
  });

  /// Tag único por spot para la animación Hero.
  static String heroTag(Spot spot) => 'spot-image-${spot.id}';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag(spot),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: width,
          height: height,
          child: spot.hasImage
              ? Image.file(
                  File(spot.imagePath!),
                  fit: BoxFit.cover,
                  // Si la foto se borró del teléfono, mostramos el placeholder.
                  errorBuilder: (context, error, stackTrace) => _placeholder(),
                )
              : _placeholder(),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.brandGradient),
      child: Icon(
        Icons.photo_camera_back_rounded,
        color: Colors.white,
        size: height * 0.4,
      ),
    );
  }
}
