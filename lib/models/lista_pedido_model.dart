class ListaPedidoModel {
  int? id_lista_pedido, id_producto, cantidad;
  double? subtotal;

  ListaPedidoModel(
      {this.id_lista_pedido, this.id_producto, this.cantidad, this.subtotal});
  factory ListaPedidoModel.fromMap(Map<String, dynamic> lista_pedido) {
    return ListaPedidoModel(
        id_lista_pedido: lista_pedido['id_lista_pedido'],
        id_producto: lista_pedido['id_producto'],
        cantidad: lista_pedido['cantidad'],
        subtotal: lista_pedido['subtotal']);
  }
}
