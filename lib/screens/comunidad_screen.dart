import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/Comunidad_controller.dart';
import 'package:store_sqlite/controller/carrito_controller.dart';
import 'package:store_sqlite/controller/categoria_controller.dart';
import 'package:store_sqlite/controller/municipio_controller.dart';
import 'package:store_sqlite/models/municipio_model.dart';
import 'package:store_sqlite/screens/comunidad/dropdown_Comunidad_widget.dart';

class ComunidadScreen extends StatefulWidget {
  const ComunidadScreen({super.key});

  @override
  State<ComunidadScreen> createState() => _ComunidadScreenState();
}

class _ComunidadScreenState extends State<ComunidadScreen> {
  CarritoController carritoController = CarritoController();
  ComunidadController comunidadController = ComunidadController();
  MunicipioController municipioController = MunicipioController();
  TextEditingController conComunidad = TextEditingController();

  String? _selectedMunicipio; // Guardamos el valor seleccionado aquí
  int? id_municipio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        modal(context, null, null);
      }),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: comunidadController.mostrarComunidadYMunicipio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Map<String, dynamic>> comunidades = snapshot.data!;
            return ListView.builder(
              itemCount: comunidades.length,
              itemBuilder: (context, index) {
                var comunidad = comunidades[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(40, 75, 39, 39),
                        border: const Border(
                          left: BorderSide(
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${comunidad['id_comunidad']}\n comunidad=${comunidad['comunidad']}\n municipio=${comunidad['municipio']}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  modal(context, comunidad['comunidad'],
                                      comunidad['id_comunidad']);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Es el boton editar y tenemos el id=${comunidad['id_comunidad']}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.blue),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
            );
          } else {
            return const Center(
              child: Text('No hay pedidos disponibles'),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> modal(
      BuildContext context, String? comunidad, int? id_comunidad) {
    //le pasa el valor a la caja de texto
    if (comunidad != null) {
      conComunidad.text = comunidad;
    } else {
      conComunidad.clear();
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
                child: Text(id_comunidad == null
                    ? 'NUEVA COMUNIDAD'
                    : 'EDITAR COMUNIDAD'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: conComunidad,
                  decoration: const InputDecoration(
                    label: Text('COMUNIDAD'),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                ),
              ),
              DropdownComunidadWidget(
                //le pasamos el modelo para que pueda leerlo
                id_comunidad = id_comunidad,
                onChanged: (MunicipioModel? municipio) {
                  if (municipio != null) {
                    // si no viene vacio
                    print(
                        "Municipio seleccionado: ${municipio.municipio}, ID: ${municipio.id_municipio}");
                    setState(() {
                      id_municipio = municipio.id_municipio;
                    });
                  } else {
                    print(
                        "Municipio editar seleccionado : ${municipio?.municipio}, ID: ${municipio?.id_municipio}");
                  }
                },
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
                      if (conComunidad.text.trim().isNotEmpty) {
                        if (id_comunidad == null) {
                          // Si id_categoria es nulo, significa que es una nueva categoría.
                          // _agregarComunidad();
                          print('¿¿¿¿¿¿¿¿¿');
                          print('${conComunidad.text}' '${id_municipio}');
                          _agregarComunidad(conComunidad.text, id_municipio!);
                        } else {
                          // Si id_categoria tiene un valor, significa que estamos editando.
                          //_editarMucipio(id_municipio);
                          _editarComunidad(
                              id_comunidad!, id_municipio, conComunidad.text);
                          print('tiene comuniad');
                          print(id_comunidad);
                          print('tiene municipio');
                          print(id_municipio);
                          print('nombreCoomunidad');
                          print(comunidad);
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
                          id_comunidad == null ? 'Agregar' : 'Guardar Cambios',
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

  void _agregarComunidad(String comunidad, int id_municipio) {
    // 'INSERT INTO comunidad (comunidad, id_comunidad)
    try {
      comunidadController.insertarComunidad(
        'comunidad',
        {'comunidad': comunidad, 'id_municipio': id_municipio},
      );
      conComunidad.clear();
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

  void _editarComunidad(id_comunidad, id_municipio, comunidad) {
    try {
      // SqfliteDatabaseException (DatabaseException(no such column: id_comunidad (code 1 SQLITE_ERROR):
      //  , while compiling: UPDATE municipio SET id_comunidad = ?, comunidad = ?, id_municipio = ?
      //  WHERE id_comunidad = ?) sql
      //  'UPDATE municipio SET id_comunidad = ?, comunidad = ?, id_municipio = ? WHERE id_comunidad = ?'
      //  args [4, rrrrr, 4, 4])
      comunidadController.actualizarComunidad(
        'comunidad',
        {
          'comunidad': comunidad,
          'id_municipio': id_municipio,
          'id_comunidad': id_comunidad
        },
      );
      conComunidad.clear();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comunidad actualizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      setState(() {}); // Actualizar la lista de categorías.
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hubo un error al actualizar la comunidad: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
