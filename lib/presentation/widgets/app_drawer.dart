import 'package:flutter/material.dart';

import 'package:spotted/core/routes/app_routes.dart';
import 'package:spotted/core/theme/app_theme.dart';

/// Menú lateral (Drawer) de la pantalla principal.
class AppDrawer extends StatelessWidget {
  /// Acción para crear un spot (la pantalla de lista la provee para
  /// poder recargar los datos al volver del formulario).
  final VoidCallback onNewSpot;

  const AppDrawer({super.key, required this.onNewSpot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: AppTheme.brandGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Spotted',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Tu diario de lugares bonitos',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_rounded),
            title: const Text('Mis spots'),
            selected: true,
            onTap: () => Navigator.pop(context), // ya estamos en la lista
          ),
          ListTile(
            leading: const Icon(Icons.add_location_alt_rounded),
            title: const Text('Nuevo spot'),
            onTap: () {
              Navigator.pop(context); // cierra el drawer
              onNewSpot();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.about);
            },
          ),
        ],
      ),
    );
  }
}
