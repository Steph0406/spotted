import '../entities/spot.dart';

/// Contrato (abstracción) del repositorio de spots.
///
/// Principio de Inversión de Dependencias (la D de SOLID):
/// las pantallas dependen de esta clase abstracta, NO de SQLite.
/// Si mañana cambiamos SQLite por Firebase, la UI no se modifica.
abstract class SpotRepository {
  /// Obtiene todos los spots, del más reciente al más antiguo.
  Future<List<Spot>> getAll();

  /// Obtiene un spot por su id, o null si no existe.
  Future<Spot?> getById(int id);

  /// Guarda un spot nuevo y regresa el id generado.
  Future<int> create(Spot spot);

  /// Actualiza un spot existente.
  Future<void> update(Spot spot);

  /// Elimina un spot por su id.
  Future<void> delete(int id);
}