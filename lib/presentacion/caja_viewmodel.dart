import 'package:flutter/foundation.dart';
import '../datos/repositorio_productos.dart';
import '../datos/repositorio_ventas.dart';
import '../dominio/carrito.dart';
import '../dominio/producto.dart';
import '../dominio/venta.dart';

class CajaViewModel extends ChangeNotifier {
  final RepositorioProductos repoProductos;
  final RepositorioVentas repoVentas;
  final Carrito carrito = Carrito();

  CajaViewModel(this.repoProductos, this.repoVentas);

  int get totalCentavos => carrito.totalCentavos;

  void agregar(Producto p, {int cantidad = 1}) {
    carrito.agregar(p, cantidad: cantidad);
    notifyListeners();
  }

  Future<Venta> cobrar(int pagoCentavos) async {
    final venta = await repoVentas.cobrar(carrito, pagoCentavos);
    carrito.lineas.clear();
    notifyListeners();
    return venta;
  }
}