import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/municipio_controller.dart';
import 'package:store_sqlite/models/municipio_model.dart';

class MunicipiosScreen extends StatefulWidget {
  const MunicipiosScreen({super.key});

  @override
  State<MunicipiosScreen> createState() => _MunicipiosScreenState();
}

class _MunicipiosScreenState extends State<MunicipiosScreen> {
  TextEditingController conMunicipio = TextEditingController();
  MunicipioController municipioController = MunicipioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Categorias'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modal(context, null, null);
        },
        child: const Icon(Icons.add_circle),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: municipioController.mostrarTodosLosMunicipios(),
          builder: (context, AsyncSnapshot<List<MunicipioModel>?> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(136, 60, 81, 73),
                          border: const Border(
                            left: BorderSide(
                              color: Color.fromARGB(255, 100, 80, 73),
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Texto del pedido y fecha de entrega
                                Expanded(
                                  child: Text(
                                    'id: ${snapshot.data![index].id_municipio}\nCategoria: ${snapshot.data![index].municipio}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                // Botón de editar
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    modal(
                                        context,
                                        snapshot.data![index].municipio,
                                        snapshot.data![index].id_municipio);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Es el boton editar y tenemos el id=${snapshot.data![index].id_municipio}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                                // Botón de borrar
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    // Acción para eliminar el elemento
                                    // Aquí podrías mostrar una confirmación de eliminación antes de proceder.
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },

                //${snapshot.data![index].fecha_entrega}',
                //);
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> modal(
      BuildContext context, String? municipio, int? id_municipio) {
    if (municipio != null) {
      conMunicipio.text = municipio;
    } else {
      conMunicipio.clear(); // Limpia el controlador si es una nueva categoría.
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * .9,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(

                    ///valida si la categoria viene vacia
                    id_municipio == null
                        ? 'Nuevo Municipio'
                        : 'EDITAR Municipio'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: conMunicipio,
                  decoration: const InputDecoration(
                    label: Text('Ingresa una categoría'),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.cancel,
                            color: Color.fromARGB(255, 107, 4, 4)),
                        Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Color.fromARGB(255, 158, 6, 6),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ///valida si la categoria no esta vacia
                      if (conMunicipio.text.trim().isNotEmpty) {
                        if (id_municipio == null) {
                          // Si id_categoria es nulo, significa que es una nueva categoría.
                          _agregarMunicipio();
                        } else {
                          // Si id_categoria tiene un valor, significa que estamos editando.
                          _editarMucipio(id_municipio);
                        }
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('El campo no puede estar vacío'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.done_outline_outlined,
                          color: Colors.greenAccent,
                        ),
                        Text(
                          id_municipio == null ? 'Agregar' : 'Guardar Cambios',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarMunicipio() {
    try {
      municipioController.insertarMunicipio(
        'municipio',
        {'municipio': conMunicipio.text.trim()},
      );
      conMunicipio.clear();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoría agregada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      setState(() {}); // Actualizar la lista de categorías.
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hubo un error al agregar la categoría: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editarMucipio(
    int id_municipio,
  ) {
    try {
      // categoriaController.insertCategoria(
      //   'categoria',
      //   {'categoria': conCategoria.text.trim()},
      //   id_categoria,
      // );
      municipioController.actualizarMunicipio('municipio', {
        'id_municipio': id_municipio,
        'municipio': conMunicipio.text.trim()
      });
      conMunicipio.clear();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoría actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      setState(() {}); // Actualizar la lista de categorías.
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hubo un error al actualizar la categoría: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
