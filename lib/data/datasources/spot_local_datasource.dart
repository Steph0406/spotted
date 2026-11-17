import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/spot_model.dart';

/// Fuente de datos local: es la ÚNICA clase que habla con SQLite.
///
/// Crea la base de datos, la tabla y ejecuta las consultas (CRUD).
class SpotLocalDataSource {
  static const String _dbName = 'spotted.db';
  static const int _dbVersion = 1;
  static const String table = 'spots';

  Database? _database;

  /// Abre la base de datos solo una vez y la reutiliza.
  Future<Database> get database async {
    _database ??= await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Tabla principal: cada fila es una entrada del diario.
        await db.execute('''
          CREATE TABLE $table (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            title       TEXT    NOT NULL,
            description TEXT    NOT NULL DEFAULT '',
            category    TEXT    NOT NULL,
            rating      INTEGER NOT NULL DEFAULT 0,
            image_path  TEXT,
            latitude    REAL,
            longitude   REAL,
            created_at  TEXT    NOT NULL
          )
        ''');
      },
    );
  }

  /// SELECT de todos los spots, más recientes primero.
  Future<List<SpotModel>> getAll() async {
    final db = await database;
    final rows = await db.query(table, orderBy: 'created_at DESC');
    return rows.map((row) => SpotModel.fromMap(row)).toList();
  }

  /// SELECT de un spot por id.
  Future<SpotModel?> getById(int id) async {
    final db = await database;
    final rows = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return SpotModel.fromMap(rows.first);
  }

  /// INSERT: regresa el id generado.
  Future<int> insert(SpotModel spot) async {
    final db = await database;
    return db.insert(table, spot.toMap());
  }

  /// UPDATE: regresa cuántas filas se modificaron.
  Future<int> update(SpotModel spot) async {
    final db = await database;
    return db.update(
      table,
      spot.toMap(),
      where: 'id = ?',
      whereArgs: [spot.id],
    );
  }

  /// DELETE: regresa cuántas filas se eliminaron.
  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}