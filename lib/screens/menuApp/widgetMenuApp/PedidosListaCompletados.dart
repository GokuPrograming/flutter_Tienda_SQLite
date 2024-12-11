import 'package:flutter/material.dart';
import 'package:store_sqlite/backend/producto_controller.dart';

import 'package:store_sqlite/models/pedido_model.dart';

class Pedidoslistacompletados extends StatefulWidget {
  final int opc;

  const Pedidoslistacompletados({super.key, required this.opc});

  @override
  State<Pedidoslistacompletados> createState() => _PedidoslistawidgetState();
}

class _PedidoslistawidgetState extends State<Pedidoslistacompletados> {
  //late PedidoController pedidoController;

  ProductoController productoController = new ProductoController();

  @override
  void initState() {
    productoController = ProductoController();
    // print('////////////////////////////////////////////');
    // pedidoController.mostrarPedidosConListaPedido(1);
    // print('////////////////////////////////////////////');
    super.initState();
  }

  Color getColorByStatus(int? idStatus) {
    switch (idStatus) {
      case 1:
        return Colors.green; // Si el idStatus es 1, el color será verde.
      case 3:
        return Colors.red; // Si el idStatus es 2, el color será rojo.
      case 2:
        return Colors.white; // Si el idStatus es 3, el color será blanco.
      default:
        return Colors
            .grey; // Color por defecto si no es ninguno de los anteriores.
    }
  }

  Icon getIconStatus(int? idStatus) {
    switch (idStatus) {
      case 1:
        return const Icon(
          Icons.done,
          color: Colors.green,
        );
      case 3:
        return const Icon(
          Icons.cancel,
          color: Colors.red,
        );
      case 2:
        return const Icon(
          Icons.hourglass_empty,
          color: Colors.grey,
        );
    }
    return const Icon(Icons.error);
  }

  @override
  Widget build(BuildContext context) {
    var LargoContenedorList = MediaQuery.of(context).size.width * .1;
    return Scaffold(
        body: FutureBuilder(
      future: productoController.MostrarTodosLosPedidosCompletados(),
      builder: (context, AsyncSnapshot<List<PedidoModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay pedidos disponibles'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final pedido = snapshot.data![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/informacionPedido',
                    arguments: {
                      'id_pedido': pedido.id_pedido,
                      'id_status': pedido.id_status,
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(40, 75, 39, 39),
                    border: Border(
                      left: BorderSide(
                        color: getColorByStatus(pedido.id_status),
                        width: 4,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Pedido: ${pedido.id_pedido}\nFecha entrega: ${pedido.fecha_entrega},\n${pedido.id_status}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      getIconStatus(pedido.id_status),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
