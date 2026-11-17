/// Funciones de formato reutilizables (fechas y coordenadas).
class Formatters {
  Formatters._();

  static const List<String> _months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];

  /// Ejemplo: 16 nov 2026
  static String date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// Ejemplo: 20.96737, -89.59258
  static String coordinates(double lat, double lng) =>
      '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
}
