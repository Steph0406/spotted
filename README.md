# Spotted ✨ — Diario de lugares bonitos

App móvil desarrollada en **Flutter** para la materia **Programación para Dispositivos Móviles (Parcial 2)**.

## 💡 Problema que resuelve

Descubrimos cafés, restaurantes y rincones bonitos, pero después olvidamos su nombre, dónde estaban o qué nos gustó.
**Spotted** es un diario personal para guardar cada lugar con **foto**, una **reseña dictada por voz** y su **ubicación GPS**, para volver o recomendarlo.

## 📱 Funcionalidades

- Lista de spots, vista de detalle y formulario de creación/edición.
- **Cámara y galería** para la foto del lugar (`image_picker`).
- **Dictado por voz** de la reseña con el micrófono (`speech_to_text`).
- **GPS** capturado al guardar un spot nuevo (`geolocator`).
- **Mapa interactivo** en el detalle (`flutter_map` + OpenStreetMap) y botón para **abrir en Google Maps** (`url_launcher`).
- Almacenamiento local con **SQLite** (`sqflite`).
- Calificación con estrellas, categorías, edición y eliminación.

## 🧱 Arquitectura por capas

```
lib/
├── core/          # Tema, rutas, errores, inyección de dependencias, utilidades
├── domain/        # Entidad Spot y contrato SpotRepository (abstracción)
├── data/          # Modelo SQLite, fuente de datos local e implementación del repositorio
├── services/      # Cámara, voz, GPS y mapas (cada uno con su interfaz)
└── presentation/  # Pantallas (lista, detalle, formulario, acerca de) y widgets
```

### Principios SOLID aplicados

- **S** — Cada clase tiene una sola responsabilidad (ej. `SpotLocalDataSource` solo habla con SQLite).
- **O** — Se puede cambiar SQLite por otra base de datos sin modificar la UI.
- **L** — `SpotRepositoryImpl` puede sustituir a `SpotRepository` en cualquier lugar.
- **I** — Interfaces pequeñas por gadget: `ImageService`, `SpeechService`, `LocationService`, `MapsLauncher`.
- **D** — Las pantallas dependen de abstracciones; `ServiceLocator` decide las implementaciones concretas.

## 🧭 Navegación y UI

`Scaffold`, `AppBar`, `Drawer`, rutas con nombre (`onGenerateRoute` + `Navigator.pushNamed`) y animación **Hero** de la imagen entre la lista y el detalle. Tema pastel con Material 3.

## ⚠️ Manejo de errores

Todos los accesos a SQLite, cámara, micrófono y GPS están dentro de `try-catch` y se convierten en `AppException` con mensajes amigables para la usuaria.
La carga de datos usa `FutureBuilder` con cuatro estados: cargando, error, vacío y lista.

## ▶️ Cómo ejecutar

```bash
flutter pub get
flutter run
```

> En el emulador: activar el micrófono virtual (*Extended Controls → Microphone*) y fijar una ubicación (*Extended Controls → Location*).

## 👩‍💻 Autora

Stephanie Bayona Jimbo — Ingeniería en TI y Negocios Digitales, Universidad Anáhuac Mayab
