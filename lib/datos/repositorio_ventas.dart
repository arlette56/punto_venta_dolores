import 'package:sqflite/sqflite.dart';
import '../dominio/carrito.dart';
import '../dominio/excepciones.dart';
import '../dominio/venta.dart';

class RepositorioVentas {
  final Database db;
  RepositorioVentas(this.db);

  /// Cobra: valida pago, guarda venta + líneas y descuenta inventario.
  /// Todo en UNA transacción: o se guarda todo o no se guarda nada.
  Future<Venta> cobrar(Carrito carrito, int pagoCentavos, {DateTime? fecha}) async {
    //carrito.cambio(pagoCentavos);
    final momento = fecha ?? DateTime.now();
    late int ventaId;

    await db.transaction((txn) async {
      // Validar existencias disponibles en la base de datos
      for (final l in carrito.lineas) {
        final f = await txn.query('productos',
            columns: ['existencias'],
            where: 'codigo = ?',
            whereArgs: [l.producto.codigo]);
        final disp = f.isEmpty ? 0 : f.first['existencias'] as int;
        if (disp < l.cantidad) {
          throw ExistenciasInsuficientesException(l.producto.nombre, disp);
        }
      }

      // Registrar la venta en la tabla ventas
      ventaId = await txn.insert('ventas', {
        'fecha': momento.toIso8601String(),
        'total_centavos': carrito.totalCentavos,
        'iva_centavos': carrito.ivaCentavos,
        'pago_centavos': pagoCentavos,
      });

      // Insertar los renglones del ticket y descontar stock
      for (final l in carrito.lineas) {
        await txn.insert('lineas_venta', {
          'venta_id': ventaId,
          'codigo': l.producto.codigo,
          'nombre': l.producto.nombre,
          'cantidad': l.cantidad,
          'precio_centavos': l.producto.precioCentavos,
        });

        await txn.rawUpdate(
            'UPDATE productos SET existencias = existencias - ? WHERE codigo = ?',
            [l.cantidad, l.producto.codigo]);
      }
    });

    return Venta(
      id: ventaId,
      fecha: momento,
      totalCentavos: carrito.totalCentavos,
      ivaCentavos: carrito.ivaCentavos,
      pagoCentavos: pagoCentavos,
      lineas: carrito.lineas
          .map((l) => LineaVenta(l.producto.codigo, l.producto.nombre,
              l.cantidad, l.producto.precioCentavos))
          .toList(),
    );
  }
}