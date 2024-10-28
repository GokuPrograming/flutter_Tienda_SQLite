import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/Comunidad_controller.dart';
import 'package:store_sqlite/models/comunidad_model.dart';

class DropdownComunidadCarWidget extends StatefulWidget {
  final Function(ComunidadModel?) onChanged;
  final int id_municipio;

  const DropdownComunidadCarWidget({
    required this.id_municipio,
    super.key,
    required this.onChanged,
  });

  @override
  State<DropdownComunidadCarWidget> createState() =>
      _DropdownComunidadWidgetState();
}

class _DropdownComunidadWidgetState extends State<DropdownComunidadCarWidget> {
  ComunidadController comunidadController = ComunidadController();
  List<ComunidadModel> _comunidades = [];
  ComunidadModel? _selectedComunidad;

  @override
  void initState() {
    super.initState();
    print('el id_municipio que llego =${widget.id_municipio}');
    _loadComunidadById_municipio(widget.id_municipio);
  }

  // Este método detecta cambios en los parámetros del widget
  @override
  void didUpdateWidget(DropdownComunidadCarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id_municipio != widget.id_municipio) {
      _loadComunidadById_municipio(widget.id_municipio);
    }
  }

  Future<void> _loadComunidadById_municipio(int id_municipio) async {
    try {
      // Obtener las comunidades basadas en el id_municipio
      List<ComunidadModel>? comunidades =
          await comunidadController.mostrarComunidadByIdMunicipio(id_municipio);

      setState(() {
        // Si no se encuentran comunidades, asigna una lista vacía
        _comunidades = comunidades ?? [];
        _selectedComunidad =
            null; // Reinicia la selección al cargar nuevos datos
      });
    } catch (e) {
      debugPrint('Error al cargar comunidades: $e');
      setState(() {
        _comunidades = []; // Si hay un error, también se reinicia la lista
        _selectedComunidad = null;
      });
    }
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
        child: DropdownButton<ComunidadModel>(
          value: _selectedComunidad,
          onChanged: (ComunidadModel? value) {
            setState(() {
              _selectedComunidad = value;
            });
            widget.onChanged(value); // Pasar el valor seleccionado al callback
          },
          hint: Center(
            child: Text(
              _selectedComunidad?.comunidad ?? 'Selecciona',
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
          items: _comunidades
              .map((comunidad) => DropdownMenuItem<ComunidadModel>(
                    value: comunidad,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        comunidad.comunidad!,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
