import 'package:animated_botton_navigation/animated_botton_navigation.dart';
import 'package:flutter/material.dart';
import 'package:store_sqlite/config/globalValues.dart';
import 'package:store_sqlite/controller/carrito_controller.dart';
import 'package:store_sqlite/screens/calendarScreen.dart';
import 'package:store_sqlite/screens/menuApp/widgetMenuApp/PedidosListaWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:badges/badges.dart' as badges;

class MenuappScreenv extends StatefulWidget {
  const MenuappScreenv({super.key});

  @override
  State<MenuappScreenv> createState() => _MenuappScreenvState();
}

Future<void> requestPermission() async {
  final permission = Permission.location;

  if (await permission.isDenied) {
    await permission.request();
  }
}

Future<bool> checkPermissionStatus() async {
  final permission = Permission.location;
  return await permission.status.isGranted;
}

Future<void> requestPermissionCamera() async {
  final permission = Permission.storage;

  if (await permission.isDenied) {
    await permission.request();
  }
}

Future<bool> checkPermissionStatusCamera() async {
  final permission = Permission.camera;

  return await permission.status.isGranted;
}

Future<void> requestPermissionManageStorage() async {
  final permission = Permission.manageExternalStorage;

  if (await permission.isDenied) {
    // Solicitar el permiso
    final result = await permission.request();

    // Manejar el resultado
    if (result.isGranted) {
      print('Se le dieron los permisos');
    } else if (result.isDenied) {
      print('Permiso denegado, no se puede acceder al almacenamiento');
    } else if (result.isPermanentlyDenied) {
      print('Permiso permanentemente denegado, redirigiendo a configuración');
      // Redirigir a la configuración de la app
      openAppSettings();
    }
  } else {
    print('Ya tiene permisos de almacenamiento');
  }
}

CarritoController carritoController = CarritoController();
int _cartBadgeAmount = 4;
int relaConteo = 0;
late bool _showCartBadge;

// Future<List<Map>> NumeroArticulosEnCArrito() async {
//   var resp = await carritoController.conteoDeArticulosEnCarrito();
//   print(' este es  el parametro de articulos=$resp');

//   relaConteo = (resp[0]['sum(cantidad)'] ?? 0) as int;
//   print('in metodo=$relaConteo');
//   // for (var cantidad in resp) {
//   //   cantidad['sum(cantidad)'];
//   //   print('el for');
//   //   print(cantidad['sum(cantidad)']);
//   //   cantidad['sum(cantidad)'];
//   // }
//   print('cantidad carirto cast');
//   // print(cantidadCarrito);
//   return resp;
// }

// Color color = Colors.red;
Future<void> requestPermissionStorage() async {
  final permission = Permission.manageExternalStorage;

  if (await permission.isDenied) {
    final result = await permission.request();
    if (result.isGranted) {
      // Permission is granted
    } else if (result.isDenied) {
      // Permission is denied
    } else if (result.isPermanentlyDenied) {
      // Permission is permanently denied
    }
  }
}

class _MenuappScreenvState extends State<MenuappScreenv> {
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

  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(
        child: Pedidoslistawidget(
      opc: 0,
    )),
    Center(
        child: Pedidoslistawidget(
      opc: 1,
    )),
    Center(child: TableBasicsExample()),
    Center(
        child: Pedidoslistawidget(
      opc: 2,
    )),
  ];

  @override
  Widget build(BuildContext context) {
    _showCartBadge = _cartBadgeAmount > 0;
    return Scaffold(
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/img/logo_pizza.jfif',
                  ),
                ),
                ListTile(
                  onTap: () {
                    ///perdir permisos
                    requestPermissionManageStorage();
                    // requestPermissionStorage()
                    Navigator.pushNamed(context, '/listaProductos');
                  },
                  leading: Icon(Icons.food_bank),
                  title: Text('Productos'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/categoria');
                  },
                  leading: Icon(Icons.category),
                  title: Text('Categorias'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/municipios');
                  },
                  leading: Icon(Icons.location_city),
                  title: Text('Municipios'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/comunidades');
                  },
                  leading: Icon(Icons.gps_fixed),
                  title: Text('Comunidades'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Glorys Pizza Admin App'),
        backgroundColor: const Color.fromARGB(131, 33, 31, 31),
        actions: <Widget>[
          _shoppingCartBadge(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/productos');
        },
        child: Icon(
          Icons.add,
        ),
        tooltip: 'Nuevo',
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: AnimatedBottomNavigation(
        height: 70,
        indicatorSpaceBotton: 25,
        selectedColor: Colors.black,
        icons: [
          Icons.pending_outlined,
          Icons.schedule,
          Icons.calendar_month,
          Icons.task_alt
        ],
        currentIndex: _currentIndex,
        onTapChange: (index) {
          setState(() {
            _currentIndex = index;
          });
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
