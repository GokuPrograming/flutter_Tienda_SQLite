import 'package:animated_botton_navigation/animated_botton_navigation.dart';
import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/producto_controller.dart';
import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/producto_model.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:store_sqlite/screens/calendarScreen.dart';
import 'package:store_sqlite/screens/menuApp/widgetMenuApp/PedidosListaWidget.dart';
import 'package:store_sqlite/screens/menuApp/widgetMenuApp/drawer.dart';

class MenuappScreenv extends StatefulWidget {
  const MenuappScreenv({super.key});

  @override
  State<MenuappScreenv> createState() => _MenuappScreenvState();
}

class _MenuappScreenvState extends State<MenuappScreenv> {
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
                  onTap: () {},
                  leading: Icon(Icons.food_bank),
                  title: Text('Productos'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.category),
                  title: Text('Categorias'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.location_city),
                  title: Text('Municipios'),
                ),
                ListTile(
                  onTap: () {},
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
        backgroundColor: const Color.fromARGB(131, 33, 31, 31),
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
}
