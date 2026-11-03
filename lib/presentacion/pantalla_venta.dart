import 'package:flutter/material.dart';
import '../dominio/producto.dart';
import 'caja_viewmodel.dart';

class PantallaVentaConViewModel extends StatelessWidget {
  final CajaViewModel viewModel;
  final List<Producto> productosIniciales;

  const PantallaVentaConViewModel({
    super.key,
    required this.viewModel,
    this.productosIniciales = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta - Dolores'),
        backgroundColor: const Color(0xFF191970), // Midnight Blue
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productosIniciales.length,
              itemBuilder: (context, index) {
                final producto = productosIniciales[index];
                final double precio = producto.precioCentavos / 100.0;

                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Código: ${producto.codigo} - \$${precio.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () => viewModel.agregar(producto),
                  ),
                );
              },
            ),
          ),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              final double totalFormateado = viewModel.totalCentavos / 100.0;

              return Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${totalFormateado.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: viewModel.totalCentavos == 0
                          ? null
                          : () async {
                              await viewModel.cobrar(viewModel.totalCentavos);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF191970),
                      ),
                      child: const Text('Cobrar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}