import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:store_sqlite/controller/status_controller.dart';
import 'package:store_sqlite/models/lista_pedido_model.dart';
import 'package:store_sqlite/models/status_model.dart';

class Dropdownbuttonlistwidget extends StatefulWidget {
  const Dropdownbuttonlistwidget( {super.key});
  
// Constructor modificado

  @override
  State<Dropdownbuttonlistwidget> createState() =>
      _DropdownbuttonlistwidgetState();
}

class _DropdownbuttonlistwidgetState extends State<Dropdownbuttonlistwidget> {
  late StatusController statusController = StatusController();
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  
  ValueNotifier<String?> selectedValueNotifier = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    print('+++++++++++++++++++++++++++++++++++++++++');
    Lista();
  }

  void Lista() async {
    List<StatusModel>? list = await statusController.mostrarTodosLosStatus();
    print(list); // Esto imprimirá la lista cuando esté disponible.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Ajusta el ancho del Container
      child: ValueListenableBuilder<String?>(
        valueListenable: selectedValueNotifier,
        builder: (context, selectedValue, child) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: items
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (String? value) {
                selectedValueNotifier.value = value;
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
