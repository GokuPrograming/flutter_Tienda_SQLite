import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/Comunidad_controller.dart';
import 'package:store_sqlite/controller/categoria_controller.dart';
import 'package:store_sqlite/models/categoria_model.dart';

class DropdownCategoriaWidget extends StatefulWidget {
  final Function(CategoriaModel?) OnChanged;
  final int? id_categoria;
  final String? categoria;
  DropdownCategoriaWidget(
    this.id_categoria,
    this.categoria, {
    super.key,
    required this.OnChanged,
  });

  @override
  State<DropdownCategoriaWidget> createState() =>
      _DropdownCategoriaWidgetState();
}

class _DropdownCategoriaWidgetState extends State<DropdownCategoriaWidget> {
  CategoriaController categoriaController = CategoriaController();
  List<CategoriaModel> _categorias = [];
  List<Map<String, dynamic>> _categoria_by_id = [];

  CategoriaModel? _categoriaSeleccionada;
  CategoriaModel? _editarCategoria;
  int? id_categoria;
  String? categoria = 'Selecciona categoria';

  @override
  void initState() {
    // TODO: implement initState
    id_categoria = widget.id_categoria;
    
    categoria = widget.categoria;
    agregarAlModelo(id_categoria, categoria);
    cargarCategorias();
    super.initState();
  }

  void cargarCategorias() async {
    try {
      List<CategoriaModel>? categorias =
          await categoriaController.mostrarTodasLasCategorias();
      setState(() {
        _categorias = categorias ?? [];
      });
    } catch (e) {
      print(e);
    }
  }

  void agregarAlModelo(int? id_categoria, String? categoria) {
    _editarCategoria =
        CategoriaModel(id_categoria: id_categoria, categoria: categoria);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: DropdownButton<CategoriaModel>(
          // value: id_municipio == null ? _editarMunicipio : _selectedMunicipio,
          //en el onchange mapeamos
          value: _categoriaSeleccionada,
          onChanged: (CategoriaModel? value) {
            setState(() {
              _categoriaSeleccionada = value;
            });
            widget.OnChanged(value); // Pasar el valor seleccionado al callback
            categoria = _categoriaSeleccionada?.categoria;
            debugPrint(
                "Has seleccionado: ${_categoriaSeleccionada?.categoria} con ID: ${_categoriaSeleccionada?.id_categoria}");
          },
          hint: Center(
            child: Text(
              id_categoria == null ? 'Seleccione Categoria' : '${categoria}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          underline: Container(),
          dropdownColor: const Color.fromARGB(255, 202, 188, 145),
          icon: const Icon(
            Icons.arrow_downward,
            color: Color.fromARGB(255, 130, 126, 92),
          ),
          isExpanded: true,
          items: _categorias
              .map((categoria) => DropdownMenuItem<CategoriaModel>(
                    value: categoria, // El objeto MunicipioModel es el valor
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${categoria.categoria}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _categorias
              .map((categoria) => Center(
                    child: Text(
                      '${categoria.categoria}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 223, 200, 131),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
