import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../datos/base_datos.dart';
import '../datos/repositorio_productos.dart';
import '../datos/repositorio_ventas.dart';
import '../dominio/producto.dart';
import '../presentacion/caja_viewmodel.dart';
import '../presentacion/pantalla_venta.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización para compatibilidad con escritorio (Windows)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 1,
    onCreate: BaseDatos.crearTablas,
  );

  final repoProductos = RepositorioProductos(db);
  final repoVentas = RepositorioVentas(db);

  final productosCatalogo = [
    const Producto(
      codigo: 'NV-001',
      nombre: 'Nieve de limón',
      precioCentavos: 2500,
      existencias: 20,
    ),
    const Producto(
      codigo: 'NV-002',
      nombre: 'Nieve de tequila',
      precioCentavos: 3500,
      existencias: 15,
    ),
    const Producto(
      codigo: 'NV-003',
      nombre: 'Nieve de mantecado',
      precioCentavos: 3000,
      existencias: 12,
    ),
  ];

  for (final p in productosCatalogo) {
    await repoProductos.agregar(p);
  }

  final cajaViewModel = CajaViewModel(repoProductos, repoVentas);

  runApp(PuntoVentaApp(
    viewModel: cajaViewModel,
    productosIniciales: productosCatalogo,
  ));
}

class PuntoVentaApp extends StatelessWidget {
  final CajaViewModel viewModel;
  final List<Producto> productosIniciales;

  const PuntoVentaApp({
    super.key,
    required this.viewModel,
    required this.productosIniciales,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punto de Venta - Dolores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF191970),
        ),
        useMaterial3: true,
      ),
      home: PantallaVentaConViewModel(
        viewModel: viewModel,
        productosIniciales: productosIniciales,
      ),
    );
  }
}