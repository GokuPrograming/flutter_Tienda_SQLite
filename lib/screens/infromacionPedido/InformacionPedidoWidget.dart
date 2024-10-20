import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/pedido_controller.dart';

class Informacionpedidowidget extends StatefulWidget {
  final int? id;
  const Informacionpedidowidget(this.id, {super.key}); // Constructor modificado

  @override
  State<Informacionpedidowidget> createState() =>
      _InformacionpedidowidgetState();
}

class _InformacionpedidowidgetState extends State<Informacionpedidowidget> {
  PedidoController informacionPedido = PedidoController();
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    // print(arguments['id_pedido']);
    
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * .58,
      decoration: BoxDecoration(),
      child: FutureBuilder<List<Map<String, dynamic>>?>(
        future: informacionPedido
            .mostrarPedidosConListaPedido(widget.id), // Usar el id aquí
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron pedidos'));
          } else {
            List<Map<String, dynamic>> pedidos = snapshot.data!;
            return ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                var pedido = pedidos[index];
                return Container(
                  child: ListTile(
                    title: Text('Artículo: ${pedido['producto']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad: ${pedido['cantidad']}'),
                        SizedBox(height: 4.0), // Espacio entre textos
                        Text('Precio: \$${pedido['precio']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4.0), // Espacio entre textos
                        Text('Subtotal: ${pedido['']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
