import 'package:flutter/material.dart';

import 'package:spotted/core/di/service_locator.dart';
import 'package:spotted/core/errors/app_exception.dart';
import 'package:spotted/core/routes/app_routes.dart';
import 'package:spotted/core/theme/category_style.dart';
import 'package:spotted/core/utils/formatters.dart';
import 'package:spotted/domain/entities/spot.dart';
import 'package:spotted/domain/repositories/spot_repository.dart';
import 'package:spotted/presentation/widgets/rating_stars.dart';
import 'package:spotted/presentation/widgets/spot_image.dart';
import 'package:spotted/presentation/widgets/spot_map.dart';
import 'package:spotted/services/maps_launcher.dart';

/// Detalle de un spot (vista de detalle del diario).
///
/// - Imagen con animación Hero desde la lista.
/// - Mapa interactivo con la ubicación guardada.
/// - Botón para abrir las coordenadas en Google Maps.
/// - Acciones de editar y eliminar.
class SpotDetailScreen extends StatefulWidget {
  final Spot spot;

  const SpotDetailScreen({super.key, required this.spot});

  @override
  State<SpotDetailScreen> createState() => _SpotDetailScreenState();
}

class _SpotDetailScreenState extends State<SpotDetailScreen> {
  final SpotRepository _repository = ServiceLocator.spotRepository;
  final MapsLauncher _mapsLauncher = ServiceLocator.mapsLauncher;

  /// Copia local del spot: se actualiza si la usuaria lo edita.
  late Spot _spot;

  @override
  void initState() {
    super.initState();
    _spot = widget.spot;
  }

  Future<void> _edit() async {
    final saved =
        await Navigator.pushNamed(context, AppRoutes.form, arguments: _spot);
    if (saved != true || !mounted) return;
    try {
      // Volvemos a leer de SQLite para mostrar los datos actualizados.
      final updated = await _repository.getById(_spot.id!);
      if (updated != null && mounted) setState(() => _spot = updated);
    } on AppException catch (e) {
      if (mounted) _showMessage(e.message);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar spot?'),
        content: Text(
          'Se borrará "${_spot.title}" de tu diario. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await _repository.delete(_spot.id!);
      if (!mounted) return;
      Navigator.pop(context, true); // regresa a la lista (que se recarga)
    } on AppException catch (e) {
      if (mounted) _showMessage(e.message);
    }
  }

  Future<void> _openInGoogleMaps() async {
    try {
      await _mapsLauncher.openInMaps(_spot.latitude!, _spot.longitude!);
    } on AppException catch (e) {
      if (mounted) _showMessage(e.message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_spot.title),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_rounded),
            onPressed: _edit,
          ),
          IconButton(
            tooltip: 'Eliminar',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // Mismo Hero tag que en la lista => animación de transición.
          SpotImage(
            spot: _spot,
            width: double.infinity,
            height: 260,
            borderRadius: 24,
          ),
          const SizedBox(height: 20),

          // ---------- Datos ----------
          Text(
            _spot.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(CategoryStyle.iconFor(_spot.category),
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(_spot.category),
              const Spacer(),
              RatingStars(rating: _spot.rating, size: 22),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.date(_spot.createdAt),
            style: theme.textTheme.labelMedium,
          ),

          // ---------- Reseña ----------
          const SizedBox(height: 20),
          Text('Reseña',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            _spot.description.isEmpty ? 'Sin reseña.' : _spot.description,
            style: theme.textTheme.bodyLarge,
          ),

          // ---------- Ubicación ----------
          const SizedBox(height: 24),
          Text('Ubicación',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (_spot.hasLocation) ...[
            SpotMap(latitude: _spot.latitude!, longitude: _spot.longitude!),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.my_location_rounded,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  Formatters.coordinates(_spot.latitude!, _spot.longitude!),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _openInGoogleMaps,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.map_rounded),
              label: const Text('Abrir en Google Maps'),
            ),
          ] else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_off_rounded),
                  SizedBox(width: 10),
                  Expanded(child: Text('Este spot no tiene ubicación guardada.')),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
