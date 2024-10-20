import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/pedido_controller.dart';
import 'package:store_sqlite/models/pedido_model.dart';

class Pedidoslistawidget extends StatefulWidget {
  const Pedidoslistawidget({super.key});

  @override
  State<Pedidoslistawidget> createState() => _PedidoslistawidgetState();
}

class _PedidoslistawidgetState extends State<Pedidoslistawidget> {
  late PedidoController pedidoController;

  @override
  void initState() {
    pedidoController = PedidoController();
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
        future: pedidoController.mostrarTodosLosPedidos(),
        builder: (context, AsyncSnapshot<List<PedidoModel>?> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/informacionPedido',
                          arguments: {
                            'id_pedido': snapshot.data![index].id_pedido,
                            'id_status': snapshot.data![index].id_status
                          });
                    },
                    child: Container(
                      width: LargoContenedorList,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(40, 75, 39, 39),
                        border: Border(
                          left: BorderSide(
                            color: getColorByStatus(
                                snapshot.data![index].id_status),
                            width: 4,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Texto del pedido y fecha de entrega
                          Expanded(
                            child: Text(
                              'No_pedido: ${snapshot.data![index].id_pedido}\nFecha entrega: ${snapshot.data![index].fecha_entrega}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 16,
                                // color: Colors.black,
                              ),
                            ),
                          ),
                          // Ícono que representa el estado del pedido
                          getIconStatus(snapshot.data![index].id_status),
                        ],
                      ),
                    ),
                  ),
                );
              },

              //${snapshot.data![index].fecha_entrega}',
              //);
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }

}
