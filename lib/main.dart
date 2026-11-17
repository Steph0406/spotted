import 'package:flutter/widgets.dart';

import 'package:spotted/app.dart';

/// Punto de entrada de Spotted.
void main() {
  // Necesario antes de usar plugins nativos (SQLite, cámara, GPS...).
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpottedApp());
}
