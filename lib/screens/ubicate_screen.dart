import 'package:flutter/material.dart';
import 'package:store_sqlite/screens/mapa.dart';

class UbicateScreen extends StatefulWidget {
  const UbicateScreen({super.key});

  @override
  State<UbicateScreen> createState() => _UbicateScreenState();
}

class _UbicateScreenState extends State<UbicateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Ubícate'),
      // ),
      body: Column(
        children: [
          // Expanded(
          //   flex: 2,
          //   child: InteractiveViewer(
          //     boundaryMargin: const EdgeInsets.all(20),
          //     minScale: 0.5,
          //     maxScale: 4.0,
          //     child: Image.asset(
          //       'assets/img/logo_tec.jpeg',
          //       fit: BoxFit.contain, // Ajusta la imagen al contenedor
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: MapSample(),
            ),
          ),
        ],
      ),
    );
  }
}
