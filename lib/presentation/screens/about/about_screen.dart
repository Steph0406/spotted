import 'package:flutter/material.dart';

import 'package:spotted/core/theme/app_theme.dart';

/// Pantalla informativa: qué problema resuelve la app y qué usa.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.brandGradient,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 56),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Spotted ✨',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const Center(child: Text('Versión 1.0')),
          const SizedBox(height: 24),
          Text(
            '¿Qué problema resuelve?',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Descubrimos cafés, restaurantes y rincones bonitos, pero después '
            'olvidamos su nombre, dónde estaban o qué nos gustó. Spotted es un '
            'diario personal para guardar cada lugar con foto, una reseña '
            'dictada por voz y su ubicación GPS, para volver o recomendarlo.',
          ),
          const SizedBox(height: 24),
          Text(
            'Funciones',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const _Feature(icon: Icons.photo_camera_rounded, text: 'Foto con cámara o galería'),
          const _Feature(icon: Icons.mic_rounded, text: 'Dictado por voz de la reseña'),
          const _Feature(icon: Icons.location_on_rounded, text: 'Ubicación GPS y mapa'),
          const _Feature(icon: Icons.storage_rounded, text: 'Guardado local con SQLite'),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Programación para Dispositivos Móviles · Parcial 2',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Feature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text),
    );
  }
}
