import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';

import 'package:store_sqlite/backend/lista_productoModel.dart';
import 'package:store_sqlite/backend/producto_controller.dart';

class Informacionpedidowidget extends StatefulWidget {
  final int? id;
  const Informacionpedidowidget(this.id, {super.key}); // Constructor modificado

  @override
  State<Informacionpedidowidget> createState() =>
      _InformacionpedidowidgetState();
}

class _InformacionpedidowidgetState extends State<Informacionpedidowidget> {
  ProductoController productoController = new ProductoController();

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Container(
      width: MediaQuery.of(context).size.width, // Ajuste en MediaQuery
      height: MediaQuery.of(context).size.height * .45,
      decoration: BoxDecoration(),
      child: FutureBuilder<List<ListaProducto>>(
        future: productoController
            .mostrarProductosPedido(widget.id), // Usar el id aquí
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error en snapshot: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron pedidos'));
          } else {
            List<ListaProducto> pedidos = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      var pedido = pedidos[index];
                      return Column(
                        children: [
                          Container(
                            child: ListTile(
                              title: Text('Artículo: ${pedido.producto}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text('Cantidad: ${pedido.cantidad}'),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Precio: \$${pedido.precio}\n cantidad: ${pedido.cantidad}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text('Subtotal: ${pedido.subtotal}'),
                                  // Ajuste en Subtotal
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                arguments['id_status'] == 2
                    ? Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 18),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 255, 0, 0),
                                  ),
                                ),
                                onPressed: () => _handlePedidoAction(
                                    context, widget.id, 3, "rechazar"),
                                child: Text(
                                  "Rechazar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 18),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(213, 0, 188, 0),
                                  ),
                                ),
                                onPressed: () => _handlePedidoAction(
                                    context, widget.id, 1, "completar"),
                                child: Text(
                                  "Completar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Divider(),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _handlePedidoAction(
      BuildContext context, int? id, int status, String action) async {
    if (id == null) {
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.warning,
          title: "ID inválido",
          confirmButtonColor: Colors.orange,
        ),
      );
      return;
    }

    String actionText =
        action == "rechazar" ? "rechazarlo" : "completar el pedido";

    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        showCancelBtn: true,
        title: "¿Seguro que quieres $actionText?",
        confirmButtonColor: action == "rechazar" ? Colors.red : Colors.green,
        confirmButtonText: action == "rechazar" ? "Rechazar" : "Completar",
        cancelButtonText: "Cancelar",
      ),
    );

    if (response == null || response.isTapDenyButton) return;

    bool success = await productoController.changeStatus(id, status);
    if (success) {
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title:
              "El pedido se ${action == "rechazar" ? "rechazó" : "completó"} correctamente",
          confirmButtonColor: Colors.green,
          onConfirm: () {
            Navigator.pushNamed(context, '/MenuScreen');
          },
        ),
      );
    } else {
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.danger,
          title:
              "No se pudo ${action == "rechazar" ? "rechazar" : "completar"} el pedido",
          confirmButtonColor: Colors.red,
        ),
      );
    }
  }
}
