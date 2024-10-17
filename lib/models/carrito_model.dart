class CarritoModel {
  int? id_carrito;
  int? id_producto;
  int? cantidad;
  double? subtotal;
  CarritoModel(
      {this.id_carrito, this.id_producto, this.cantidad, this.subtotal});
  factory CarritoModel.fromMap(Map<String, dynamic> carrito) {
    return CarritoModel(
        id_carrito: carrito['id_carrito'],
        id_producto: carrito['id_producto'],
        cantidad: carrito['cantidad'],
        subtotal: carrito['subtotal']);
  }
}
