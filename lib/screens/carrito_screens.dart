import 'package:flutter/material.dart';

class CarritoScreens extends StatefulWidget {
  const CarritoScreens({super.key});

  @override
  State<CarritoScreens> createState() => _CarritoScreensState();
}

class _CarritoScreensState extends State<CarritoScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('Carrito De Compras'),
    ),);
  }
}
