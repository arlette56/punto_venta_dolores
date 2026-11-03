import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punto_venta_dolores/dominio/producto.dart';
import 'package:punto_venta_dolores/presentacion/pantalla_venta.dart';

void main() {
  testWidgets('Agregar producto incrementa el total visual en pantalla',
      (WidgetTester tester) async {
    const productoPrueba = Producto(
      codigo: 'NV-001',
      nombre: 'Nieve de limón',
      precioCentavos: 2500,
      existencias: 10,
    );

    // Construye la pantalla de ventas
    await tester.pumpWidget(
      const MaterialApp(
        home: PantallaVenta(productosIniciales: [productoPrueba]),
      ),
    );

    // Verificamos que el total inicie en $0.00
    expect(find.text('Total: \$0.00'), findsOneWidget);

    // Simulamos presionar el botón de agregar producto
    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pump();

    // Verificamos que el total visual se actualice a $25.00
    expect(find.text('Total: \$25.00'), findsOneWidget);
  });
}