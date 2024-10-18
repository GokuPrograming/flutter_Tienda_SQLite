import 'package:animated_botton_navigation/animated_botton_navigation.dart';
import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/producto_controller.dart';
import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/producto_model.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:store_sqlite/screens/menuApp/widgetMenuApp/PedidosListaWidget.dart';

class MenuappScreenv extends StatefulWidget {
  const MenuappScreenv({super.key});

  @override
  State<MenuappScreenv> createState() => _MenuappScreenvState();
}

class _MenuappScreenvState extends State<MenuappScreenv> {
  late TiendaDataBase categoriaDB;
  late ProductoController productoController;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Pedidoslistawidget()),
    Center(child: Text('Search Page')),
    Center(child: Text('Profile Page')),
  ];

  @override
  void initState() {
    super.initState();
    productoController = ProductoController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Glorys Pizza Admin App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
        backgroundColor: const Color.fromARGB(131, 33, 31, 31),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: AnimatedBottomNavigation(
        height: 70,
        indicatorSpaceBotton: 25,
        selectedColor: Colors.black,
        icons: [
          Icons.motorcycle,
          Icons.calendar_month,
          Icons.person,
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
