// helpers/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app/app/ui/pages/db/Coordenada.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'coordenadas.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE coordenadas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitudInicial REAL,
        longitudInicial REAL,
        latitudFinal REAL,
        longitudFinal REAL
      )
    ''');
  }

  Future<int> insertCoordenada(Coordenada coordenada) async {
    Database db = await database;
    return await db.insert('coordenadas', coordenada.toMap());
  }

  Future<List<Coordenada>> getCoordenadas() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('coordenadas');

    return List.generate(maps.length, (i) {
      return Coordenada(
        id: maps[i]['id'],
        latitudInicial: maps[i]['latitudInicial'],
        longitudInicial: maps[i]['longitudInicial'],
        latitudFinal: maps[i]['latitudFinal'],
        longitudFinal: maps[i]['longitudFinal'],
      );
    });
  }
}
