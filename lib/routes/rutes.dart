import 'package:flutter/material.dart';
import 'package:store_sqlite/screens/Cruds/categoria_crud/categoria_crud_screen.dart';
import 'package:store_sqlite/screens/Productos.dart';
import 'package:store_sqlite/screens/carrito_screens.dart';
import 'package:store_sqlite/screens/categoria_screen.dart';
import 'package:store_sqlite/screens/informacionPedido.dart';
import 'package:store_sqlite/screens/login/login_ScreenH.dart';
import 'package:store_sqlite/screens/login/login_screenV.dart';
import 'package:store_sqlite/screens/loginResponsiveScreen.dart';
import 'package:store_sqlite/screens/municipios_screen.dart';
import 'package:store_sqlite/screens/productos_screen.dart';

class AppRoutes {
  static const menuScreen = '/MenuScreen';
  static const loginScreen = '/loginScreen';
  static const informacionPedido = '/informacionPedido';
  static const productos = '/productos';
  static const carrito = '/carrito';
  static const categoria_screen = '/categoria';
  static const crudCategoria = '/crud_categoria';
  static const municipioScreen = '/municipios';
  static const productosScreen = '/listaProductos';
  static final routes = <String, WidgetBuilder>{
    //recibe una cadena , y un witget
    loginScreen: (context) => const loginResponsiveScreen(
        pantallaVerticalMobile: LoginScreenVertical(),
        pantallaHorizontalMobile: LoginScreenHorizontal()),
    informacionPedido: (context) => Informacionpedido(),
    productos: (context) => Productos(),
    carrito: (context) => CarritoScreens(),
    categoria_screen: (context) => CategoriaScreen(),
    crudCategoria: (context) => CategoriaCrudScreen(),
    municipioScreen: (context) => MunicipiosScreen(),
    productosScreen: (context) => ProductosScreen(),
  };
}
