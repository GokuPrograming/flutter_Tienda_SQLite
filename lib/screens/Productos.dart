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
  Future<void> _initializeCartBadge() async {
    await NumeroArticulosEnCArrito(); // Espera a que se complete
    setState(() {
      _cartBadgeAmount =
          relaConteo; // Asigna el valor actualizado dentro de setState
    });
    print('nex?=$_cartBadgeAmount');
  }

  Future<List<Map>> NumeroArticulosEnCArrito() async {
    var resp = await carritoController.conteoDeArticulosEnCarrito();
    print('este es el parametro de articulos=$resp');
    relaConteo = (resp[0]['sum(cantidad)'] ?? 0) as int;
    print('in metodo=$relaConteo');
    return resp;
  }

  @override
  void initState() {
    super.initState();
    _initializeCartBadge();
  }

  late ProductoController productoController = ProductoController();
  int _cartBadgeAmount = 4;
  int relaConteo = 0;
  late bool _showCartBadge = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        ValueListenableBuilder(
          valueListenable: Globalvalues.refrecarCarritoContador,
          builder: (BuildContext context, bool value, Widget? child) {
            // _initializeCartBadge();
            return _shoppingCartBadge();
          },
        )
      ]),
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

  Widget _shoppingCartBadge() {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      badgeAnimation: badges.BadgeAnimation.slide(
          // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
          // curve: Curves.easeInCubic,
          ),
      showBadge: _showCartBadge,
      badgeStyle: badges.BadgeStyle(
        badgeColor: const Color.fromARGB(255, 172, 6, 6),
      ),
      badgeContent: Text(
        _cartBadgeAmount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/carrito');
          }),
    );
  }
}
