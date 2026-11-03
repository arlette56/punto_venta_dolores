import 'package:flutter_test/flutter_test.dart';
import 'package:punto_venta_dolores/dominio/carrito.dart';
import 'package:punto_venta_dolores/dominio/excepciones.dart';
import 'package:punto_venta_dolores/dominio/producto.dart';

void main() {
  group('Carrito y Modelo de Dominio', () {
    const productoPrueba = Producto(
      codigo: 'NV-001',
      nombre: 'Nieve de limón',
      precioCentavos: 2500,
      existencias: 10,
    );

    test('agrega producto y calcula total e IVA', () {
      final carrito = Carrito();
      carrito.agregar(productoPrueba, cantidad: 2);

      expect(carrito.totalCentavos, 5000);
      expect(carrito.ivaCentavos, 690);
    });

    test('pago insuficiente lanza excepcion de dominio', () {
      final carrito = Carrito();
      carrito.agregar(productoPrueba);

      expect(
        () => carrito.cambio(1000),
        throwsA(isA<PagoInsuficienteException>()),
      );
    });

    test('calcula cambio correctamente al pagar suficiente', () {
      final carrito = Carrito();
      carrito.agregar(productoPrueba);

      final cambio = carrito.cambio(3000);
      expect(cambio, 500);
    });
  });
}