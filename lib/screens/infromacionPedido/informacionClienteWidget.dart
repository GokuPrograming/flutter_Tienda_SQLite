import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/pedido_controller.dart';

class InformacionClientewidget extends StatefulWidget {
  final int? id;
  const InformacionClientewidget(this.id,
      {super.key}); 

  @override
  State<InformacionClientewidget> createState() =>
      _InformacionpedidowidgetState();
}

class _InformacionpedidowidgetState extends State<InformacionClientewidget> {
  PedidoController informacionPedido = PedidoController();
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    // print(arguments['id_pedido']);

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * .29,
      decoration: BoxDecoration(color: const Color.fromARGB(255, 57, 56, 51)),
      child: FutureBuilder<List<Map<String, dynamic>>?>(
        future: informacionPedido
            .mostrarPedidoDatosCliente(widget.id), // Usar el id aquí
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
                    title: Text('Datos De Entrega:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cliente: ${pedido['nombre_cliente']}'),
                        IconButton(
                            onPressed: () {
                              print(' ${pedido['num_telefono']}');
                            },
                            icon: Text(
                              'Num Tel: ${pedido['num_telefono']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),

                        Text(
                          'Municipio:${pedido['municipio']}',
                        ),
                        SizedBox(height: 4.0), // Espacio entre textos
                        Text('Comunidad: ${pedido['comunidad']}'),
                        SizedBox(height: 4.0),
                        Text('Colonia: ${pedido['colonia']}'),
                        SizedBox(height: 4.0),
                        Text('Calle: ${pedido['calle']}'),
                        SizedBox(height: 4.0),
                        Text('No.Ext: ${pedido['no_exterior']}'),
                        SizedBox(height: 4.0),
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
