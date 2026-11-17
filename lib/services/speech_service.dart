import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:spotted/core/errors/app_exception.dart';

/// Contrato del servicio de dictado (GADGET 2: micrófono y voz a texto).
abstract class SpeechService {
  bool get isListening;

  /// Empieza a escuchar el micrófono.
  /// [onText] recibe el texto reconocido (se va actualizando en vivo).
  /// [onStopped] se llama cuando deja de escuchar (silencio, error o stop).
  Future<void> startListening({
    required ValueChanged<String> onText,
    VoidCallback? onStopped,
  });

  Future<void> stopListening();
}

/// Implementación con el paquete `speech_to_text`.
///
/// Captura el audio del micrófono y usa el reconocedor de voz del
/// sistema Android para convertirlo a texto en español.
class SpeechToTextService implements SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;
  String? _localeId;
  VoidCallback? _onStopped;

  @override
  bool get isListening => _speech.isListening;

  /// Inicializa una sola vez (aquí Android pide el permiso del micrófono).
  Future<bool> _initialize() async {
    if (_isAvailable) return true;
    try {
      _isAvailable = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _onStopped?.call();
          }
        },
        onError: (error) {
          debugPrint('Error de dictado: ${error.errorMsg}');
          _onStopped?.call();
        },
      );
      if (_isAvailable) _localeId = await _findSpanishLocale();
      return _isAvailable;
    } on PlatformException catch (e) {
      throw AppException('No se pudo acceder al micrófono.', e);
    } catch (e) {
      throw AppException('El dictado por voz no está disponible.', e);
    }
  }

  /// Busca un idioma español disponible (prefiere es-MX).
  Future<String?> _findSpanishLocale() async {
    final locales = await _speech.locales();
    final spanish = locales
        .where((l) => l.localeId.toLowerCase().startsWith('es'))
        .toList();
    if (spanish.isEmpty) return null; // usa el idioma del sistema
    return spanish
        .firstWhere(
          (l) => l.localeId.toLowerCase().contains('mx'),
          orElse: () => spanish.first,
        )
        .localeId;
  }

  @override
  Future<void> startListening({
    required ValueChanged<String> onText,
    VoidCallback? onStopped,
  }) async {
    final available = await _initialize();
    if (!available) {
      throw const AppException(
        'El dictado no está disponible. Revisa el permiso del micrófono.',
      );
    }
    _onStopped = onStopped;
    try {
      await _speech.listen(
        onResult: (result) => onText(result.recognizedWords),
        listenOptions: SpeechListenOptions(
          localeId: _localeId,
          listenFor: const Duration(minutes: 1),
          pauseFor: const Duration(seconds: 4), // se detiene tras 4 s de silencio
          partialResults: true, // muestra el texto mientras hablas
          listenMode: ListenMode.dictation,
          cancelOnError: true,
        ),
      );
    } catch (e) {
      throw AppException('No se pudo iniciar el dictado.', e);
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await _speech.stop();
    } catch (e) {
      debugPrint('Error al detener el dictado: $e');
    }
  }
}
