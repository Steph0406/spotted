/// Excepción propia de Spotted.
///
/// Envuelve errores técnicos (SQLite, GPS, cámara, micrófono) en un
/// mensaje entendible para la usuaria, sin exponer detalles internos.
/// Principio de Responsabilidad Única: solo representa un error de la app.
class AppException implements Exception {
  /// Mensaje amigable que se puede mostrar en pantalla.
  final String message;

  /// Error original (útil para depurar en consola).
  final Object? cause;

  const AppException(this.message, [this.cause]);

  @override
  String toString() =>
      'AppException: $message${cause != null ? ' (causa: $cause)' : ''}';
}