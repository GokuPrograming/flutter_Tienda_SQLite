class PedidoModel {
  int? id_pedido, id_status, id_direccion;
  String? fecha_entrega;

  PedidoModel(
      {this.id_pedido, this.id_status, this.id_direccion, this.fecha_entrega});

  factory PedidoModel.fromMap(Map<String, dynamic> pedido) {
    return PedidoModel(
        id_pedido: pedido['id_pedido'],
        id_status: pedido['id_status'],
        id_direccion: pedido['id_direccion'],
        fecha_entrega: pedido['fecha_entrega']);
  }
}
