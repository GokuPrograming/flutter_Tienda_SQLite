import 'package:flutter/material.dart';

class CategoriaCrudScreen extends StatefulWidget {
  const CategoriaCrudScreen({super.key});

  @override
  State<CategoriaCrudScreen> createState() => _CategoriaCrudScreenState();
}

class _CategoriaCrudScreenState extends State<CategoriaCrudScreen> {
  TextEditingController conCategoria = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextFormField txtCategoria = TextFormField(
      keyboardType: TextInputType.name,
      controller: conCategoria,
      decoration: const InputDecoration(
        label: Text('Ingresa una nueva categoria'),
        prefixIcon: Icon(Icons.category_outlined),
      ),
    );

    ElevatedButton btnGuardar = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
      onPressed: () {},
      child: const Text(
        'Guardar',
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevas categorias'),
      ),
      body: ListView(
        //solo la tiene list view
        shrinkWrap: true, //hace la magia para que se pueda retraer al escribir
        //final declaras una constante en la compilacion
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: txtCategoria,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [btnGuardar, btnGuardar],
            ),
          )
        ],
      ),
    );
  }
}
