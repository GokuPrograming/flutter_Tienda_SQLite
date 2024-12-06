import 'package:flutter/material.dart';
import 'package:store_sqlite/config/globalValues.dart';
import 'package:store_sqlite/controller/producto_controller.dart';
import 'package:store_sqlite/models/producto_model.dart';
import 'package:store_sqlite/screens/Productos/cardWidget.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosState();
}

class _ProductosState extends State<ProductosScreen> {
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled:
                  true, // Permite que el modal ocupe toda la pantalla
              // barrierColor: Colors.greenAccent,
              backgroundColor: const Color.fromARGB(255, 46, 45, 41),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              builder: (BuildContext context) {
                return editarProducto(
                  widget: null,
                );
              },
            );
          }),
      body: ValueListenableBuilder(
          valueListenable: Globalvalues.refrescarWidget,
          builder: (BuildContext context, bool value, Widget? child) {
            return FutureBuilder<List<Map<String, dynamic>>?>(
                future: productoController.mostrarProductosConCategoria(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong :('));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .9,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing:
                            10, // usualmente se utilizan valores mayores que 0
                        mainAxisSpacing:
                            10, // usualmente se utilizan valores mayores que 0
                      ),
                      itemCount: snapshot.data?.length ?? 0, // chequeo nulo
                      itemBuilder: (BuildContext context, int index) {
                        return Cardwidget(snapshot.data![index]);
                      },
                    ),
                  );
                });
          }),
    );
  }
}
