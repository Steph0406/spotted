import 'package:flutter/material.dart';

/// Asigna un ícono a cada categoría de spot.
class CategoryStyle {
  CategoryStyle._();

  static IconData iconFor(String category) {
    return switch (category) {
      'Café' => Icons.local_cafe_rounded,
      'Restaurante' => Icons.restaurant_rounded,
      'Mirador' => Icons.landscape_rounded,
      'Tienda' => Icons.shopping_bag_rounded,
      'Rincón aesthetic' => Icons.auto_awesome_rounded,
      _ => Icons.place_rounded,
    };
  }
}
