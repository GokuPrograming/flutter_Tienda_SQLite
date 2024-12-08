import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/pedido_controller.dart';

class InformacionClientewidget extends StatefulWidget {
  final int? id;
  const InformacionClientewidget(this.id, {super.key});

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
      height: MediaQuery.sizeOf(context).height * .38,
      padding: const EdgeInsets.all(8.0), // Espacio alrededor del contenedor
      child: FutureBuilder<List<Map<String, dynamic>>?>(
        future: informacionPedido.mostrarPedidoDatosCliente(widget.id),
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
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0), // Margen vertical entre tarjetas
                  elevation: 5, // Sombra de la tarjeta
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Bordes redondeados
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        12.0), // Padding interno para el contenido
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Datos De Entrega:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                            height:
                                8.0), // Espacio entre el título y el contenido
                        Text('Cliente: ${pedido['nombre_cliente']}'),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 18),
                            SizedBox(width: 4.0),
                            Text(
                              'Num Tel: ${pedido['num_telefono']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.0),
                        Text('Campus: ${pedido['municipio']}'),
                        SizedBox(height: 4.0),
                        Text('Zona: ${pedido['comunidad']}'),
                        SizedBox(height: 4.0),
                        Text('Carrera: ${pedido['colonia']}'),
                        SizedBox(height: 4.0),
                        Text('Semestre: ${pedido['calle']}'),
                        SizedBox(height: 4.0),
                        Text('No.Control: ${pedido['no_exterior']}'),
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
