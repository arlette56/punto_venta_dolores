import 'excepciones.dart';
import 'producto.dart';

class LineaCarrito {
  final Producto producto;
  int cantidad;

  LineaCarrito(this.producto, {this.cantidad = 1});

  int get subtotalCentavos => producto.precioCentavos * cantidad;
}

class Carrito {
  final List<LineaCarrito> lineas = [];

  void agregar(Producto p, {int cantidad = 1}) {
    final index = lineas.indexWhere((l) => l.producto.codigo == p.codigo);
    if (index >= 0) {
      lineas[index].cantidad += cantidad;
    } else {
      lineas.add(LineaCarrito(p, cantidad: cantidad));
    }
  }

  int get totalCentavos =>
      lineas.fold(0, (sum, l) => sum + l.subtotalCentavos);

  int get ivaCentavos => (totalCentavos * 0.16 / 1.16).round();

  int cambio(int pagoCentavos) {
    if (lineas.isEmpty) {
      throw Exception('El carrito está vacío.');
    }
    if (pagoCentavos < totalCentavos) {
      throw PagoInsuficienteException(totalCentavos, pagoCentavos);
    }
    return pagoCentavos - totalCentavos;
  }
}