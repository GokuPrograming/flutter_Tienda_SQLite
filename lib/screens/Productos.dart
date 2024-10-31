import 'package:flutter/material.dart';
import 'package:store_sqlite/config/globalValues.dart';
import 'package:store_sqlite/controller/producto_controller.dart';
import 'package:store_sqlite/models/producto_model.dart';
import 'package:store_sqlite/screens/Productos/cardWidget.dart';
import 'package:store_sqlite/screens/Productos/cardWidgetToCarrito.dart';
import 'package:badges/badges.dart' as badges;
import 'package:store_sqlite/screens/menuApp/MenuApp_screenV.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  late ProductoController productoController = ProductoController();
  int _cartBadgeAmount = 4;
  int relaConteo = 0;
  late bool _showCartBadge = true;

  Future<void> _initializeCartBadge() async {
    await NumeroArticulosEnCArrito();
    setState(() {
      _cartBadgeAmount = relaConteo;

      Globalvalues.carritoContador.value =
          relaConteo; // Actualiza el valor global
    });
  }

  Future<List<Map>> NumeroArticulosEnCArrito() async {
    var resp = await carritoController.conteoDeArticulosEnCarrito();
    relaConteo = (resp[0]['sum(cantidad)'] ?? 0) as int;
    return resp;
  }

  @override
  void initState() {
    super.initState();
    _initializeCartBadge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[_shoppingCartBadge()]),
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
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
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

  Widget _shoppingCartBadge() {
    return ValueListenableBuilder<int>(
      valueListenable: Globalvalues.carritoContador,
      builder: (BuildContext context, int value, Widget? child) {
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          badgeAnimation: badges.BadgeAnimation.slide(),
          showBadge: _showCartBadge,
          badgeStyle: badges.BadgeStyle(
            badgeColor: const Color.fromARGB(255, 172, 6, 6),
          ),
          badgeContent: Text(
            value.toString(),
            style: TextStyle(color: Colors.white),
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
          ),
        );
      },
    );
  }

}
