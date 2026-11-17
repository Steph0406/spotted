import 'package:flutter/material.dart';

import 'package:spotted/core/di/service_locator.dart';
import 'package:spotted/core/errors/app_exception.dart';
import 'package:spotted/core/theme/category_style.dart';
import 'package:spotted/domain/entities/spot.dart';
import 'package:spotted/domain/repositories/spot_repository.dart';
import 'package:spotted/presentation/widgets/rating_stars.dart';

/// Formulario para crear o editar un spot.
///
/// - Valida los campos con un [Form] y su GlobalKey.
/// - Guarda usando el repositorio (abstracción) dentro de try-catch.
/// - Regresa `true` a la pantalla anterior si se guardó, para que la
///   lista se recargue.
class SpotFormScreen extends StatefulWidget {
  /// null = crear spot nuevo; con valor = editar ese spot.
  final Spot? spot;

  const SpotFormScreen({super.key, this.spot});

  @override
  State<SpotFormScreen> createState() => _SpotFormScreenState();
}

class _SpotFormScreenState extends State<SpotFormScreen> {
  final SpotRepository _repository = ServiceLocator.spotRepository;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _category;
  late int _rating;
  bool _isSaving = false;

  bool get _isEditing => widget.spot != null;

  @override
  void initState() {
    super.initState();
    // Si estamos editando, precargamos los datos del spot.
    _titleController = TextEditingController(text: widget.spot?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.spot?.description ?? '');
    _category = widget.spot?.category ?? kSpotCategories.first;
    _rating = widget.spot?.rating ?? 0;
  }

  @override
  void dispose() {
    // Liberar los controladores evita fugas de memoria.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      _showMessage('Califica el lugar con al menos 1 estrella ⭐');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditing) {
        await _repository.update(widget.spot!.copyWith(
          title: title,
          description: description,
          category: _category,
          rating: _rating,
        ));
      } else {
        await _repository.create(Spot(
          title: title,
          description: description,
          category: _category,
          rating: _rating,
          createdAt: DateTime.now(),
        ));
      }

      if (!mounted) return;
      Navigator.pop(context, true); // avisamos a la lista que recargue
    } on AppException catch (e) {
      if (!mounted) return;
      _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar spot' : 'Nuevo spot')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            // ---------- Nombre ----------
            const _SectionTitle('¿Cómo se llama el lugar?'),
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ej. Café Latte Art',
                prefixIcon: Icon(Icons.storefront_rounded),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Escribe el nombre del lugar'
                  : null,
            ),

            // ---------- Categoría ----------
            const _SectionTitle('Categoría'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kSpotCategories.map((category) {
                return ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(CategoryStyle.iconFor(category), size: 18),
                  label: Text(category),
                  selected: _category == category,
                  onSelected: (_) => setState(() => _category = category),
                );
              }).toList(),
            ),

            // ---------- Calificación ----------
            const _SectionTitle('Calificación'),
            Align(
              alignment: Alignment.centerLeft,
              child: RatingStars(
                rating: _rating,
                size: 34,
                onChanged: (value) => setState(() => _rating = value),
              ),
            ),

            // ---------- Reseña ----------
            const _SectionTitle('Reseña'),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: '¿Qué te gustó? ¿Qué pediste? ¿Volverías?',
              ),
            ),

            const SizedBox(height: 28),

            // ---------- Guardar ----------
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              icon: _isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.favorite_rounded),
              label: Text(_isEditing ? 'Guardar cambios' : 'Guardar spot'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Título pequeño de cada sección del formulario.
class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}