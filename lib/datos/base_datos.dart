import 'package:sqflite/sqflite.dart';

class BaseDatos {
  static Future<void> crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT UNIQUE NOT NULL,
        nombre TEXT NOT NULL,
        precio_centavos INTEGER NOT NULL,
        existencias INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ventas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        total_centavos INTEGER NOT NULL,
        iva_centavos INTEGER NOT NULL,
        pago_centavos INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE lineas_venta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        venta_id INTEGER NOT NULL,
        codigo TEXT NOT NULL,
        nombre TEXT NOT NULL,
        cantidad INTEGER NOT NULL,
        precio_centavos INTEGER NOT NULL,
        FOREIGN KEY (venta_id) REFERENCES ventas (id) ON DELETE CASCADE
      )
    ''');
  }
}