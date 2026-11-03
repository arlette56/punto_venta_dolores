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

  late Database db;
  late RepositorioProductos repoProductos;
  late RepositorioVentas repoVentas;
  late CajaViewModel vm;

  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: BaseDatos.crearTablas,
    );
    repoProductos = RepositorioProductos(db);
    repoVentas = RepositorioVentas(db);
    vm = CajaViewModel(repoProductos, repoVentas);

    await repoProductos.agregar(const Producto(
      codigo: 'NV-001',
      nombre: 'Nieve de limón',
      precioCentavos: 2500,
      existencias: 10,
    ));
  });

  tearDown(() async {
    await db.close();
  });

  test('agregar al carrito notifica cambios y procesa cobro', () async {
    final p = (await repoProductos.buscarPorCodigo('NV-001'))!;
    
    vm.agregar(p, cantidad: 2);
    expect(vm.totalCentavos, 5000);

    final venta = await vm.cobrar(10000);
    expect(venta.cambioCentavos, 5000);
    expect(vm.totalCentavos, 0);
  });

  testWidgets('Flujo de UI procesa venta usando el ViewModel',
      (WidgetTester tester) async {
    final p = (await repoProductos.buscarPorCodigo('NV-001'))!;

    await tester.pumpWidget(
      MaterialApp(
        home: PantallaVentaConViewModel(
          viewModel: vm,
          productosIniciales: [p],
        ),
      ),
    );

    expect(find.text('Total: \$0.00'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_shopping_cart));
    await tester.pump();

    expect(find.text('Total: \$25.00'), findsOneWidget);

    await tester.tap(find.text('Cobrar'));
    await tester.pumpAndSettle();

    expect(find.text('Total: \$0.00'), findsOneWidget);
  });
}