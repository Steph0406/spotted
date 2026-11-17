import 'package:flutter/material.dart';

import 'package:spotted/domain/entities/spot.dart';

/// Formulario para crear o editar un spot.
///
/// VERSIÓN DEL PASO 3: solo un marcador de posición para probar la
/// navegación. En el Paso 4 se construye el formulario real.
class SpotFormScreen extends StatelessWidget {
  /// null = crear spot nuevo; con valor = editar ese spot.
  final Spot? spot;

  const SpotFormScreen({super.key, this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(spot == null ? 'Nuevo spot' : 'Editar spot')),
      body: const Center(
        child: Text('Formulario en construcción (Paso 4) 🛠️'),
      ),
    );
  }
}
