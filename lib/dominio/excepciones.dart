class CodigoDuplicadoException implements Exception {
  final String codigo;
  CodigoDuplicadoException(this.codigo);

  @override
  String toString() => 'El producto con código $codigo ya existe.';
}

class ExistenciasInsuficientesException implements Exception {
  final String producto;
  final int disponibles;
  ExistenciasInsuficientesException(this.producto, this.disponibles);

  @override
  String toString() =>
      'Existencias insuficientes para $producto (disponibles: $disponibles).';
}

class PagoInsuficienteException implements Exception {
  final int total;
  final int pago;
  PagoInsuficienteException(this.total, this.pago);

  @override
  String toString() => 'Pago insuficiente: total $total, entregado $pago.';
}