import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punto_venta_dolores/datos/base_datos.dart';
import 'package:punto_venta_dolores/datos/repositorio_productos.dart';
import 'package:punto_venta_dolores/datos/repositorio_ventas.dart';
import 'package:punto_venta_dolores/dominio/producto.dart';
import 'package:punto_venta_dolores/presentacion/caja_viewmodel.dart';
import 'package:punto_venta_dolores/presentacion/pantalla_venta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('Agregar producto incrementa el total visual en pantalla',
      (WidgetTester tester) async {
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: BaseDatos.crearTablas,
    );
    final repoProductos = RepositorioProductos(db);
    final repoVentas = RepositorioVentas(db);
    final vm = CajaViewModel(repoProductos, repoVentas);

    const productoPrueba = Producto(
      codigo: 'NV-001',
      nombre: 'Nieve de limón',
      precioCentavos: 2500,
      existencias: 10,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PantallaVentaConViewModel(
          viewModel: vm,
          productosIniciales: const [productoPrueba],
        ),
      ),
    );

    expect(find.text('Total: \$0.00'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pump();

    expect(find.text('Total: \$25.00'), findsOneWidget);
    await db.close();
  });
}