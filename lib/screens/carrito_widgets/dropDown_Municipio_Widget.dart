import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:store_sqlite/controller/municipio_controller.dart';
import 'package:store_sqlite/models/municipio_model.dart';

class DropdownMunicipioWidget extends StatefulWidget {
  const DropdownMunicipioWidget({super.key});

  @override
  State<DropdownMunicipioWidget> createState() =>
      _DropdownMunicipioWidgetState();
}

class _DropdownMunicipioWidgetState extends State<DropdownMunicipioWidget> {
  late MunicipioController municipioController = MunicipioController();
  List<MunicipioModel> municipios = [];
  ValueNotifier<MunicipioModel?> selectedMunicipioNotifier = ValueNotifier<MunicipioModel?>(null);

  @override
  void initState() {
    super.initState();
    obtenerMunicipios();
  }

  void obtenerMunicipios() async {
    List<MunicipioModel>? fetchedMunicipios = await municipioController.mostrarTodosLosMunicipios();
    if (fetchedMunicipios != null) {
      setState(() {
        municipios = fetchedMunicipios;
      });
    } else {
      print('No se encontraron municipios.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Ajusta el ancho del Container
      child: ValueListenableBuilder<MunicipioModel?>(
        valueListenable: selectedMunicipioNotifier,
        builder: (context, selectedMunicipio, child) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2<MunicipioModel>(
              isExpanded: true,
              hint: Text(
                'Seleccione un municipio',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: municipios
                  .map((municipio) => DropdownMenuItem<MunicipioModel>(
                        value: municipio,
                        child: Text(
                          '${municipio.municipio}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedMunicipio,
              onChanged: (MunicipioModel? value) {
                selectedMunicipioNotifier.value = value;
                if (value != null) {
                  print('ID: ${value.id_municipio}, Municipio: ${value.municipio}');
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 160, // Ajusta el ancho del DropdownButton2
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          );
        },
      ),
    );
  }
}
