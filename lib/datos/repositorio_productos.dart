import 'package:sqflite/sqflite.dart';
import '../dominio/excepciones.dart';
import '../dominio/producto.dart';

class RepositorioProductos {
  final Database db;
  RepositorioProductos(this.db);

  Future<void> agregar(Producto p) async {
    try {
      await db.insert('productos', p.aMapa());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw CodigoDuplicadoException(p.codigo);
      }
      rethrow;
    }
  }

  Future<Producto?> buscarPorCodigo(String codigo) async {
    final res = await db.query(
      'productos',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
    if (res.isEmpty) return null;
    return Producto.desdeMapa(res.first);
  }

  Future<List<Producto>> bajoInventario({int limite = 5}) async {
    final res = await db.query(
      'productos',
      where: 'existencias <= ?',
      whereArgs: [limite],
    );
    return res.map(Producto.desdeMapa).toList();
  }
}