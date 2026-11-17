import 'package:sqflite/sqflite.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/spot.dart';
import '../../domain/repositories/spot_repository.dart';
import '../datasources/spot_local_datasource.dart';
import '../models/spot_model.dart';

/// Implementación concreta del contrato [SpotRepository] usando SQLite.
///
/// Su trabajo: llamar a la fuente de datos y convertir cualquier
/// error técnico en un [AppException] con un mensaje amigable
/// (manejo de excepciones con try-catch).
class SpotRepositoryImpl implements SpotRepository {
  final SpotLocalDataSource _dataSource;

  /// La fuente de datos se "inyecta" desde afuera (Inversión de Dependencias).
  SpotRepositoryImpl(this._dataSource);

  @override
  Future<List<Spot>> getAll() async {
    try {
      return await _dataSource.getAll();
    } on DatabaseException catch (e) {
      throw AppException('No se pudieron cargar tus spots.', e);
    } catch (e) {
      throw AppException('Ocurrió un error inesperado al cargar.', e);
    }
  }

  @override
  Future<Spot?> getById(int id) async {
    try {
      return await _dataSource.getById(id);
    } on DatabaseException catch (e) {
      throw AppException('No se pudo cargar este spot.', e);
    } catch (e) {
      throw AppException('Ocurrió un error inesperado.', e);
    }
  }

  @override
  Future<int> create(Spot spot) async {
    try {
      return await _dataSource.insert(SpotModel.fromEntity(spot));
    } on DatabaseException catch (e) {
      throw AppException('No se pudo guardar el spot.', e);
    } catch (e) {
      throw AppException('Ocurrió un error inesperado al guardar.', e);
    }
  }

  @override
  Future<void> update(Spot spot) async {
    if (spot.id == null) {
      throw const AppException('No se puede actualizar un spot sin id.');
    }
    try {
      final rows = await _dataSource.update(SpotModel.fromEntity(spot));
      if (rows == 0) {
        throw const AppException('El spot ya no existe.');
      }
    } on AppException {
      rethrow; // ya es un error amigable, lo dejamos pasar
    } on DatabaseException catch (e) {
      throw AppException('No se pudo actualizar el spot.', e);
    } catch (e) {
      throw AppException('Ocurrió un error inesperado al actualizar.', e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await _dataSource.delete(id);
    } on DatabaseException catch (e) {
      throw AppException('No se pudo eliminar el spot.', e);
    } catch (e) {
      throw AppException('Ocurrió un error inesperado al eliminar.', e);
    }
  }
}