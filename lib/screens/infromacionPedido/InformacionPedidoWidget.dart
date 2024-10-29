import 'package:art_sweetalert/art_sweetalert.dart';
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

    return Container(
      width: MediaQuery.of(context).size.width, // Ajuste en MediaQuery
      height: MediaQuery.of(context).size.height * .58,
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
                              title: Text('Artículo: ${pedido['producto']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cantidad: ${pedido['cantidad']}'),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Precio: \$${pedido['precio']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                      'Subtotal: ${pedido['subtotal'] ?? 0}'), // Ajuste en Subtotal
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
                                      Color.fromARGB(255, 255, 0, 0)),
                                ),
                                onPressed: () async {
                                  // Acción del primer botón
                                  ArtDialogResponse? response =
                                      await ArtSweetAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                              showCancelBtn: true,
                                              title:
                                                  "¿Seguro que quieres rechazarlo?",
                                              // confirmButtonText: "Si",
                                              confirmButtonColor: Colors.red,
                                              confirmButtonText: 'Rechazar',
                                              cancelButtonText: 'Cancelar',
                                              onConfirm: () async {
                                                await informacionPedido
                                                        .CHANGE_STATUS(
                                                            widget.id!, 3)
                                                    ? ArtSweetAlert.show(
                                                        context: context,
                                                        artDialogArgs:
                                                            ArtDialogArgs(
                                                                type:
                                                                    ArtSweetAlertType
                                                                        .success,
                                                                title:
                                                                    "El pedido de rechazo",
                                                                confirmButtonColor:
                                                                    Colors
                                                                        .green,
                                                                onConfirm: () {
                                                                  setState(() {
                                                                    return;
                                                                  });
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/MenuScreen');
                                                                }),
                                                      )
                                                    : ArtSweetAlert.show(
                                                        context: context,
                                                        artDialogArgs:
                                                            ArtDialogArgs(
                                                                type:
                                                                    ArtSweetAlertType
                                                                        .danger,
                                                                title:
                                                                    "No se pudo rechazar",
                                                                confirmButtonColor:
                                                                    Colors.red,
                                                                onConfirm: () {
                                                                  setState(
                                                                      () {});
                                                                }),
                                                      );
                                              },
                                            ),
                                          ) ??
                                          null;
                                  if (response == null) {
                                    return;
                                  }

                                  if (response.isTapDenyButton) {
                                    return;
                                  }
                                },
                                child: Text("Rechazar",
                                    style: TextStyle(color: Colors.white)),
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
                                      Color.fromARGB(213, 0, 188, 0)),
                                ),
                                onPressed: () async {
                                  // Acción del primer botón
                                  ArtDialogResponse? response =
                                      await ArtSweetAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                              showCancelBtn: true,
                                              title:
                                                  "¿Seguro que quieres completar el pedido?",
                                              // confirmButtonText: "Si",
                                              confirmButtonColor: Colors.green,
                                              confirmButtonText:
                                                  'Completar pedido',
                                              cancelButtonText: 'Cancelar',
                                              onConfirm: () async {
                                                await informacionPedido
                                                        .CHANGE_STATUS(
                                                            widget.id!, 1)
                                                    ? ArtSweetAlert.show(
                                                        context: context,
                                                        artDialogArgs:
                                                            ArtDialogArgs(
                                                                type:
                                                                    ArtSweetAlertType
                                                                        .success,
                                                                title:
                                                                    "El pedido se completo",
                                                                confirmButtonColor:
                                                                    Colors
                                                                        .green,
                                                                onConfirm: () {
                                                                  setState(() {
                                                                    return;
                                                                  });
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/MenuScreen');
                                                                }),
                                                      )
                                                    : ArtSweetAlert.show(
                                                        context: context,
                                                        artDialogArgs:
                                                            ArtDialogArgs(
                                                                type:
                                                                    ArtSweetAlertType
                                                                        .danger,
                                                                title:
                                                                    "No se pudo completar el pedido",
                                                                confirmButtonColor:
                                                                    Colors.red,
                                                                onConfirm: () {
                                                                  setState(
                                                                      () {});
                                                                }),
                                                      );
                                              },
                                            ),
                                          ) ??
                                          null;
                                  if (response == null) {
                                    return;
                                  }

                                  if (response.isTapDenyButton) {
                                    return;
                                  }
                                },
                                child: Text("Completar",
                                    style: TextStyle(color: Colors.white)),
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
}
