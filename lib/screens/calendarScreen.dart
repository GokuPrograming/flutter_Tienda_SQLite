import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/pedido_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _selectedDate;
  Map<String, List> mySelectedEvents = {};
  PedidoController pedidoController = PedidoController();

  @override
  void initState() {
    super.initState();
    main(); // Cargar eventos al inicio
  }

  Future<List<Map<String, dynamic>>?> recuperandoDatos() async {
    List<Map<String, dynamic>>? datos =
        await pedidoController.mostrarTodosLosPedidosSinId();
    print('Imprimiendo los datos de la base de datos:');
    return datos;
  }

  Future<void> extraerDatos() async {
    var datos = await recuperandoDatos();

    if (datos != null && datos.isNotEmpty) {
      for (var dato in datos) {
        String fecha = dato['fecha_entrega'];
        String eventTitle = dato['colonia'];
        String eventDescp = dato['calle'];

        // Revisa si la fecha se almacena en el formato correcto
        print('Fecha: $fecha, Título: $eventTitle, Descripción: $eventDescp');

        mySelectedEvents[fecha] ??= [];
        mySelectedEvents[fecha]!.add({
          'eventTitle': eventTitle,
          'eventDescp': eventDescp,
        });
      }

      print('Eventos cargados: $mySelectedEvents');
    } else {
      print('No se obtuvieron datos o la lista está vacía.');
    }
  }

  Future<void> main() async {
    await extraerDatos();
    setState(() {});
  }

  List _listOfDayEvents(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    print(
        'Eventos para la fecha $formattedDate: ${mySelectedEvents[formattedDate]}');
    return mySelectedEvents[formattedDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Eventos')),
        body: Column(children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedDate = selectedDay;
                });

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SafeArea(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .9,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha seleccionada: ${selectedDay.toLocal()}'),
                          SizedBox(height: 10),
                          ..._listOfDayEvents(selectedDay).map((event) {
                            return ListTile(
                              title: Text(event['eventTitle']),
                              subtitle: Text(event['eventDescp']),
                            );
                          }).toList(),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cerrar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _listOfDayEvents,
          ),
          if (_selectedDate != null)
            ..._listOfDayEvents(_selectedDate!).map((myEvents) => ListTile(
                  leading: const Icon(
                    Icons.done,
                    color: Colors.teal,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Event Title:   ${myEvents['eventTitle']}'),
                  ),
                  subtitle: Text('Description:   ${myEvents['eventDescp']}'),
                ))
        ]));
  }
}
