class ListaProducto {
  final String producto;
  final int cantidad;
  final double precio;
  final String subtotal;

  // Constructor
  ListaProducto({
    required this.producto,
    required this.cantidad,
    required this.precio,
    required this.subtotal,
  });

  // Método para convertir un Map a un objeto ListaProducto
  factory ListaProducto.fromMap(Map<String, dynamic> map) {
    return ListaProducto(
      producto: map['producto'] ?? '',
      cantidad: map['cantidad'] ?? 0,
      precio: map['precio']?.toDouble() ?? 0.0,
      subtotal: map['subtotal']
    );
  }

  // Método para convertir un objeto ListaProducto a un Map
  Map<String, dynamic> toMap() {
    return {
      'producto': producto,
      'cantidad': cantidad,
      'precio': precio,
      'subtotal': subtotal,
    };
  }
}
