import '../../domain/entities/spot.dart';

/// Modelo de datos: extiende la entidad [Spot] y agrega la
/// conversión hacia/desde un Map, que es el formato que usa SQLite.
///
/// Separar Modelo y Entidad mantiene el dominio libre de detalles
/// de la base de datos (Responsabilidad Única).
class SpotModel extends Spot {
  const SpotModel({
    super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.rating,
    super.imagePath,
    super.latitude,
    super.longitude,
    required super.createdAt,
  });

  /// Convierte una entidad del dominio en modelo de datos.
  factory SpotModel.fromEntity(Spot spot) {
    return SpotModel(
      id: spot.id,
      title: spot.title,
      description: spot.description,
      category: spot.category,
      rating: spot.rating,
      imagePath: spot.imagePath,
      latitude: spot.latitude,
      longitude: spot.longitude,
      createdAt: spot.createdAt,
    );
  }

  /// Construye el modelo a partir de una fila de SQLite.
  factory SpotModel.fromMap(Map<String, dynamic> map) {
    return SpotModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      category: (map['category'] as String?) ?? 'Otro',
      rating: (map['rating'] as int?) ?? 0,
      imagePath: map['image_path'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Convierte el modelo en Map para insertarlo/actualizarlo en SQLite.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'category': category,
      'rating': rating,
      'image_path': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
    };
  }
}