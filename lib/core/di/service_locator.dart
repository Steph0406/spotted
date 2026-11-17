import 'package:spotted/data/datasources/spot_local_datasource.dart';
import 'package:spotted/data/repositories/spot_repository_impl.dart';
import 'package:spotted/domain/repositories/spot_repository.dart';

/// Localizador de servicios: el único lugar donde se decide QUÉ
/// implementación concreta se usa (Inversión de Dependencias).
///
/// Las pantallas piden un [SpotRepository] (abstracción) y no saben
/// que por detrás está SQLite.
class ServiceLocator {
  ServiceLocator._();

  static final SpotRepository spotRepository =
      SpotRepositoryImpl(SpotLocalDataSource());
}
