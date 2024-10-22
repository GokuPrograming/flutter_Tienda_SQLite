import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/municipio_controller.dart';
import 'package:store_sqlite/models/municipio_model.dart';

class DropdownComunidadWidget extends StatefulWidget {
  //recibe el modelo de municipio
  final Function(MunicipioModel?) onChanged;
  final int? id_comunidad;
  const DropdownComunidadWidget(this.id_comunidad,
      {super.key, required this.onChanged});

  @override
  State<DropdownComunidadWidget> createState() =>
      _DropdownComunidadWidgetState();
}

class _DropdownComunidadWidgetState extends State<DropdownComunidadWidget> {
  MunicipioController municipioController = MunicipioController();

  // Lista de municipios obtenidos de la base de datos
  List<MunicipioModel> _municipios = []; //para gau
  List<Map<String, dynamic>> _municipioBuId = [{}];
  // Variable para almacenar el municipio seleccionado
  MunicipioModel? _selectedMunicipio;
  MunicipioModel? _editarMunicipio;
  int? id_comunidad;
  int? id_municipio;
  String? municipioN ='Selecciona';
  @override
  void initState() {
    super.initState();
    id_comunidad = widget.id_comunidad;
    print('el id que llego=${id_comunidad}');
    // Cargar los municipios desde la base de datos al iniciar la pantalla
    _loadMunicipioById(id_comunidad);
    print(_municipioBuId);
    print('++++++++++++++++++');
    _loadMunicipios();
    print(municipioN);
    print('7777777777777777777777');
  }

  Future<void> _loadMunicipios() async {
    try {
      // Obtener los municipios desde el controlador
      List<MunicipioModel>? municipios =
          await municipioController.mostrarTodosLosMunicipios();

      setState(() {
        _municipios = municipios ?? [];
      });
    } catch (e) {
      debugPrint('Error al cargar municipios: $e');
    }
  }

  Future<void> _loadMunicipioById(int? id_comunidad) async {
    try {
      // Obtener los municipios desde el controlador

      List<Map<String, dynamic>>? municipioByid =
          await municipioController.mostrarmunicipioById(id_comunidad!);
      setState(() {
        print('estamos imprimiendo MunicipioByID $id_comunidad');
        print(municipioByid);

        setState(() {
          _municipioBuId = municipioByid!;
          for (var municipio in _municipioBuId) {
            municipioN = municipio['municipio'];
            id_municipio = municipio['id_municipio'];
            agregarAlModelo(id_municipio, municipio['municipio']);
          }
          print('el munucipio ggs');
          print(municipioN);
        });
      });
    } catch (e) {
      debugPrint('Error al cargar municipios: $e');
    }
  }

  void agregarAlModelo(int? id_municipio, String? municipio) {
    _editarMunicipio = MunicipioModel(
      id_municipio: id_municipio,
      municipio: municipio,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(id_municipio);
    print('------------------------------------');

    if (id_comunidad == null) {
      _selectedMunicipio = _editarMunicipio;
    } else {
      _editarMunicipio = _selectedMunicipio;
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: DropdownButton<MunicipioModel>(
          // value: id_municipio == null ? _editarMunicipio : _selectedMunicipio,
          //en el onchange mapeamos
          value: _selectedMunicipio,
          onChanged: (MunicipioModel? value) {
            setState(() {
              _selectedMunicipio = value;
            });
            widget.onChanged(value); // Pasar el valor seleccionado al callback
            municipioN = _selectedMunicipio?.municipio;
            debugPrint(
                "Has seleccionado: ${_selectedMunicipio?.municipio} con ID: ${_selectedMunicipio?.id_municipio}");
          },
          hint: Center(
            child: Text(
              id_comunidad == null ? '${municipioN}' : '${municipioN}',
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
          items: _municipios
              .map((municipio) => DropdownMenuItem<MunicipioModel>(
                    value: municipio, // El objeto MunicipioModel es el valor
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${municipio.municipio}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _municipios
              .map((municipio) => Center(
                    child: Text(
                      '${municipio.municipio}',
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
