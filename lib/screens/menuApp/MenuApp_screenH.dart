import 'package:flutter/material.dart';

class MenuappScreenH extends StatefulWidget {
  const MenuappScreenH({super.key});

  @override
  State<MenuappScreenH> createState() => _MenuappScreenvState();
}

class _MenuappScreenvState extends State<MenuappScreenH> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu App'),
      ),
      body: Text('menu app'),
    );
  }
}
