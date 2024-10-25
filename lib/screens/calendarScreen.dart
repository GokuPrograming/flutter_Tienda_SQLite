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
  int? _status;

  @override
  void initState() {
    super.initState();
    // mostrarPedidoDatosCliente();
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

  Future<void> mostrarPedidoDatosCliente(String Fecha) async {
    // String Fecha = '2024-10-18';
    List<Map<String, dynamic>>? pedidoPorFecha =
        await pedidoController.mostrarPedidoDatosDelPedidoPorFecha(Fecha);
    for (var pedido in pedidoPorFecha!) {
      pedido['municipio'];
      pedido['id_municipio'];
      // print('${municipio['id_status']} ${municipio['id_pedido']}');
      _status = pedido['id_status'];
    }
  }

  Future<Color> SelectColorPoints(DateTime? selectedDate) async {
    String fecha = DateFormat('yyyy-MM-dd').format(selectedDate!);
    await mostrarPedidoDatosCliente(
        fecha); // Esperamos que la función asíncrona termine

    // Insert into status(status)values('completado'),('En Proceso'),('cancelado')
    print('status=${_status}');

    switch (_status) {
      case 1:
        return Colors.green; // Si el idStatus es 1, el color será verde.
      case 3:
        return Colors.red; // Si el idStatus es 3, el color será rojo.
      case 2:
        return Colors.white; // Si el idStatus es 2, el color será blanco.
      default:
        return Colors.grey;
    }
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

                // Recopilamos los eventos de la fecha seleccionada
                List eventosDelDia = _listOfDayEvents(selectedDay);

                // Mostramos el ModalBottomSheet con los eventos del día
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
                          Text(
                            'Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(selectedDay)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),

                          // Mostramos los eventos del día
                          ...eventosDelDia.map((event) {
                            return ListTile(
                              title: Text('Título: ${event['eventTitle']}'),
                              subtitle:
                                  Text('Descripción: ${event['eventDescp']}'),
                            );
                          }).toList(),

                          // Botón para cerrar el modal
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cerrar'),
                          ),

                          // Otros detalles adicionales que quieras mostrar
                          SizedBox(height: 10),
                          Text(
                              'Detalles adicionales sobre los eventos del día ${DateFormat('yyyy-MM-dd').format(selectedDay)}'),
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

            // Aquí está el `calendarBuilders` con los puntos de colores
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return FutureBuilder<Color>(
                    future: SelectColorPoints(
                        date), // Obtiene el color según el estado del evento
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Si está cargando, muestra un marcador gris
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // Si hay error, muestra un marcador rojo
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        );
                      } else {
                        // Si todo está bien, muestra el marcador con el color basado en el estado
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: snapshot
                                .data, // Usa el color de `SelectColorPoints`
                          ),
                        );
                      }
                    },
                  );
                }
                return SizedBox(); // Si no hay eventos, no muestra nada
              },
            ),
          ),
          if (_selectedDate != null)
            ..._listOfDayEvents(_selectedDate!).map((myEvents) =>
                FutureBuilder<Color>(
                  future: SelectColorPoints(_selectedDate),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Mientras esperamos que el futuro se complete, mostramos un indicador de carga o color predeterminado
                      return ListTile(
                        leading: const Icon(
                          Icons.done,
                          color: Colors.grey, // Muestra un color predeterminado
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child:
                              Text('Event Title:   ${myEvents['eventTitle']}'),
                        ),
                        subtitle:
                            Text('Description:   ${myEvents['eventDescp']}'),
                      );
                    } else if (snapshot.hasError) {
                      // Si hay algún error, muestra un icono o color diferente
                      return ListTile(
                        leading: const Icon(
                          Icons.error,
                          color: Colors.red, // Muestra un color de error
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child:
                              Text('Event Title:   ${myEvents['eventTitle']}'),
                        ),
                        subtitle:
                            Text('Description:   ${myEvents['eventDescp']}'),
                      );
                    } else {
                      // Una vez que el futuro se complete, usamos el color devuelto
                      return ListTile(
                        leading: Icon(
                          Icons.done,
                          color: snapshot
                              .data, // Usamos el color retornado por SelectColorPoints
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child:
                              Text('Event Title:   ${myEvents['eventTitle']}'),
                        ),
                        subtitle:
                            Text('Description:   ${myEvents['eventDescp']}'),
                      );
                    }
                  },
                ))
        ]));
  }

  // ignore: non_constant_identifier_names
}
