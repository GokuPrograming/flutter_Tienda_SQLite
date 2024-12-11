class PedidomodelBack {
  final String nombreCliente;
  final String numTelefono;
  final String municipio;
  final String comunidad;
  final String calle;
  final String colonia;
  final int noExterior;

  PedidomodelBack({
    required this.nombreCliente,
    required this.numTelefono,
    required this.municipio,
    required this.comunidad,
    required this.calle,
    required this.colonia,
    required this.noExterior,
  });

  // Método para crear un PedidoModel desde un mapa (json)
  factory PedidomodelBack.fromMap(Map<String, dynamic> map) {
    return PedidomodelBack(
      nombreCliente: map['nombre_cliente'],
      numTelefono: map['num_telefono'],
      municipio: map['municipio'],
      comunidad: map['comunidad'],
      calle: map['calle'],
      colonia: map['colonia'],
      noExterior: map['no_exterior'],
    );
  }
}
