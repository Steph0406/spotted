/// Categorías disponibles para clasificar un spot.
const List<String> kSpotCategories = [
  'Café',
  'Restaurante',
  'Mirador',
  'Tienda',
  'Rincón aesthetic',
  'Otro',
];

/// Entidad de dominio: un lugar bonito guardado en el diario.
///
/// Es una clase "pura": no sabe nada de SQLite ni de Flutter.
/// Así la lógica del negocio no depende de cómo se guardan los datos.
class Spot {
  final int? id; // null mientras no se ha guardado en la BD
  final String title;
  final String description; // texto escrito o dictado por voz
  final String category;
  final int rating; // calificación de 1 a 5
  final String? imagePath; // ruta local de la foto (cámara o galería)
  final double? latitude; // coordenadas GPS capturadas al guardar
  final double? longitude;
  final DateTime createdAt;

  const Spot({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rating,
    this.imagePath,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  /// Indica si el spot tiene ubicación guardada.
  bool get hasLocation => latitude != null && longitude != null;

  /// Indica si el spot tiene foto.
  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;

  /// Crea una copia modificando solo los campos indicados (para editar).
  Spot copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    int? rating,
    String? imagePath,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) {
    return Spot(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      imagePath: imagePath ?? this.imagePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}