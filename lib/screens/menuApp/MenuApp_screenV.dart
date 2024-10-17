import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:store_sqlite/controller/categoria_controller.dart';
import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/categoria_model.dart';

class MenuappScreenv extends StatefulWidget {
  const MenuappScreenv({super.key});

  @override
  State<MenuappScreenv> createState() => _MenuappScreenvState();
}

class _MenuappScreenvState extends State<MenuappScreenv> {
  late TiendaDataBase categoriaDB;
  late CategoriaController categoriaController;
  @override
  void initState() {
    super.initState();
    categoriaController = CategoriaController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu App'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
            ),
          ],
          backgroundColor: const Color.fromARGB(131, 50, 45, 45),
        ),
        body: FutureBuilder(
            future: categoriaController.mostrarTodasLasCategorias(),
            builder: (context, AsyncSnapshot<List<CategoriaModel>?> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Text(
                        'los valores del snapshot= ${snapshot.data![index].categoria}');
                    //MovieViewItem(moviesDAO: snapshot.data![index],);
                  },
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            }));
  }
}
