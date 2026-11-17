import 'package:spotted/data/datasources/spot_local_datasource.dart';
import 'package:spotted/data/repositories/spot_repository_impl.dart';
import 'package:spotted/domain/repositories/spot_repository.dart';
import 'package:spotted/services/image_service.dart';
import 'package:spotted/services/location_service.dart';
import 'package:spotted/services/speech_service.dart';

/// Localizador de servicios: el único lugar donde se decide QUÉ
/// implementación concreta se usa (Inversión de Dependencias).
///
/// Las pantallas piden abstracciones ([SpotRepository], [ImageService],
/// [SpeechService], [LocationService]) y no saben qué paquete o base de
/// datos hay por detrás.
class ServiceLocator {
  ServiceLocator._();

  static final SpotRepository spotRepository =
      SpotRepositoryImpl(SpotLocalDataSource());

  static final ImageService imageService = ImagePickerService();

  static final SpeechService speechService = SpeechToTextService();

  static final LocationService locationService = GeolocatorLocationService();
}
