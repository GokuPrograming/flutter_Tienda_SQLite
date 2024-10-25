import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/producto_controller.dart';
import 'package:store_sqlite/models/producto_model.dart';
import 'package:store_sqlite/screens/Productos/cardWidget.dart';
import 'package:store_sqlite/screens/Productos/cardWidgetToCarrito.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  late ProductoController productoController = ProductoController();
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/carrito');
              },
              icon: Icon(Icons.shop))
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: productoController.mostrarProductosConCategoria(),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong :('));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing:
                  10, // usualmente se utilizan valores mayores que 0
              mainAxisSpacing:
                  10, // usualmente se utilizan valores mayores que 0
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return Cardwidgettocarrito(snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
