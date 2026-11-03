class Producto {
  final int? id;
  final String codigo;
  final String nombre;
  final int precioCentavos;
  final int existencias;

  const Producto({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.precioCentavos,
    required this.existencias,
  });

  Map<String, Object?> aMapa() => {
        if (id != null) 'id': id,
        'codigo': codigo,
        'nombre': nombre,
        'precio_centavos': precioCentavos,
        'existencias': existencias,
      };

  factory Producto.desdeMapa(Map<String, Object?> map) => Producto(
        id: map['id'] as int?,
        codigo: map['codigo'] as String,
        nombre: map['nombre'] as String,
        precioCentavos: map['precio_centavos'] as int,
        existencias: map['existencias'] as int,
      );
}