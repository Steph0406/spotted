import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:spotted/core/errors/app_exception.dart';

/// Contrato del servicio de imágenes (GADGET 1: cámara y galería).
///
/// Segregación de Interfaces: solo expone lo que el formulario necesita.
/// Ambos métodos regresan la ruta local de la imagen, o null si la
/// usuaria canceló.
abstract class ImageService {
  Future<String?> pickFromCamera();
  Future<String?> pickFromGallery();
}

/// Implementación con el paquete `image_picker`.
///
/// La foto elegida se COPIA a la carpeta privada de la app, porque la
/// ruta que da image_picker es temporal (caché) y Android puede borrarla.
class ImagePickerService implements ImageService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> pickFromCamera() => _pick(ImageSource.camera);

  @override
  Future<String?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<String?> _pick(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1600, // reduce el tamaño para no llenar la memoria
        imageQuality: 85,
      );
      if (file == null) return null; // la usuaria canceló
      return await _saveToAppFolder(file);
    } on PlatformException catch (e) {
      // Permiso denegado, cámara no disponible, etc.
      throw AppException(
        source == ImageSource.camera
            ? 'No se pudo abrir la cámara. Revisa los permisos.'
            : 'No se pudo abrir la galería.',
        e,
      );
    } on FileSystemException catch (e) {
      throw AppException('No se pudo guardar la imagen.', e);
    } catch (e) {
      throw AppException('Ocurrió un error con la imagen.', e);
    }
  }

  /// Copia la imagen a: <documentos de la app>/spot_images/spot_<fecha>.jpg
  Future<String> _saveToAppFolder(XFile file) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(docsDir.path, 'spot_images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final extension = p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
    final fileName = 'spot_${DateTime.now().millisecondsSinceEpoch}$extension';
    final saved = await File(file.path).copy(p.join(imagesDir.path, fileName));
    return saved.path;
  }
}
