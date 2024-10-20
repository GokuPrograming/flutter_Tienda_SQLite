import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/pedido_controller.dart';
import 'package:store_sqlite/screens/infromacionPedido/InformacionPedidoWidget.dart';
import 'package:store_sqlite/screens/infromacionPedido/dropDownButtonListWidget.dart';
import 'package:store_sqlite/screens/infromacionPedido/floatingButtonWidget.dart';
import 'package:store_sqlite/screens/infromacionPedido/informacionClienteWidget.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';

class Informacionpedido extends StatefulWidget {
  const Informacionpedido({super.key});

  @override
  State<Informacionpedido> createState() => _InformacionpedidoState();
}

class _InformacionpedidoState extends State<Informacionpedido> {
  PedidoController informacionPedido = PedidoController();

  late int? id = 0;
  late int? id_status = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    // print(arguments['id_pedido']);
    id = arguments['id_pedido'];
    id_status = arguments['id_status'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Datos pedido $id'),
          // actions: [Dropdownbuttonlistwidget(id_status)],
        ),
        body: Column(
          children: [
            InformacionClientewidget(id),
            Informacionpedidowidget(id),
          ],
        ),
        floatingActionButton: Floatingbuttonwidget(id));
  }
}
