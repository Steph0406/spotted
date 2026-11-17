import 'package:flutter/material.dart';

import 'package:spotted/core/di/service_locator.dart';
import 'package:spotted/core/errors/app_exception.dart';
import 'package:spotted/core/routes/app_routes.dart';
import 'package:spotted/domain/entities/spot.dart';
import 'package:spotted/domain/repositories/spot_repository.dart';
import 'package:spotted/presentation/widgets/app_drawer.dart';
import 'package:spotted/presentation/widgets/spot_card.dart';

/// Pantalla principal: lista de spots guardados.
///
/// Usa [FutureBuilder] para cargar los datos de SQLite de forma
/// asíncrona y mostrar: cargando / error / vacío / lista.
class SpotsListScreen extends StatefulWidget {
  const SpotsListScreen({super.key});

  @override
  State<SpotsListScreen> createState() => _SpotsListScreenState();
}

class _SpotsListScreenState extends State<SpotsListScreen> {
  // Depende de la abstracción, no de SQLite (Inversión de Dependencias).
  final SpotRepository _repository = ServiceLocator.spotRepository;

  late Future<List<Spot>> _spotsFuture;

  @override
  void initState() {
    super.initState();
    _spotsFuture = _repository.getAll();
  }

  /// Vuelve a consultar la base de datos y redibuja.
  void _reload() {
    setState(() {
      _spotsFuture = _repository.getAll();
    });
  }

  Future<void> _openForm() async {
    final saved = await Navigator.pushNamed(context, AppRoutes.form);
    if (!mounted) return;
    if (saved == true) _reload();
  }

  Future<void> _openDetail(Spot spot) async {
    await Navigator.pushNamed(context, AppRoutes.detail, arguments: spot);
    if (!mounted) return;
    _reload(); // por si se editó o eliminó
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spotted ✨')),
      drawer: AppDrawer(onNewSpot: _openForm),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text('Nuevo spot'),
      ),
      body: FutureBuilder<List<Spot>>(
        future: _spotsFuture,
        builder: (context, snapshot) {
          // 1) Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) Error (el repositorio lanza AppException con mensaje amigable)
          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = error is AppException
                ? error.message
                : 'Algo salió mal al cargar tus spots.';
            return _ErrorView(message: message, onRetry: _reload);
          }

          // 3) Vacío
          final spots = snapshot.data ?? [];
          if (spots.isEmpty) return const _EmptyView();

          // 4) Lista
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 96),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return SpotCard(spot: spot, onTap: () => _openDetail(spot));
            },
          );
        },
      ),
    );
  }
}

/// Estado vacío: aún no hay spots.
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.travel_explore_rounded,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no tienes spots 💕',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toca "Nuevo spot" para guardar tu primer lugar bonito.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado de error con botón para reintentar.
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
