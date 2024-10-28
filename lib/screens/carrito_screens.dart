import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/carrito_controller.dart';
import 'package:store_sqlite/controller/direccion_controller.dart';
import 'package:store_sqlite/controller/listaPedido_controller.dart';
import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/lista_pedido_model.dart';
import 'package:store_sqlite/models/toast_notification.dart';
import 'package:store_sqlite/screens/carrito_widgets/dropDown_Municipio_Widget.dart';

class CarritoScreens extends StatefulWidget {
  const CarritoScreens({super.key});

  @override
  State<CarritoScreens> createState() => _CarritoScreensState();
}

class _CarritoScreensState extends State<CarritoScreens> {
  CarritoController carritoController = CarritoController();
  List<int> _counterValues = [];
  final conNombreCliente = TextEditingController();
  final conTelefono = TextEditingController();
  final conColonia = TextEditingController();
  final conCalle = TextEditingController();
  final conNoExterior = TextEditingController();
  final conNoInterior = TextEditingController();
  final conFechaEntrega = TextEditingController();
  final toast = ToastNotification();

  late TiendaDataBase db;

  @override
  void initState() {
    super.initState();
    db = TiendaDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          // Mostrar modal para ingresar datos
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * .9,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text('Datos Del Pedido'),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: conNombreCliente,
                      decoration: const InputDecoration(
                        label: Text('Nombre Del Cliente'),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: conTelefono,
                      decoration: const InputDecoration(
                        label: Text('Número De Teléfono'),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: conColonia,
                      decoration: const InputDecoration(
                        label: Text('Colonia'),
                        prefixIcon: Icon(Icons.add_location_alt_outlined),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: conCalle,
                      decoration: const InputDecoration(
                        label: Text('Calle'),
                        prefixIcon: Icon(Icons.streetview),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: conNoExterior,
                      decoration: const InputDecoration(
                        label: Text('Número Exterior'),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: conNoInterior,
                      decoration: const InputDecoration(
                        label: Text('Número Interior'),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const Row(
                      children: [
                        Text('Comunidad'),
                        DropdownMunicipioWidget(),
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType
                          .none, // Desactiva el teclado para mostrar solo el calendario
                      controller: conFechaEntrega,
                      decoration: const InputDecoration(
                        label: Text('Fecha entrega'),
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(
                            FocusNode()); // Evita que el teclado se muestre
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000), // Fecha mínima permitida
                          lastDate: DateTime(2101), // Fecha máxima permitida
                        );

                        if (pickedDate != null) {
                          // Formatea la fecha seleccionada y la asigna al controlador
                          String formattedDate =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                          conFechaEntrega.text = formattedDate;
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cerrar'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              String nombreCliente = conNombreCliente.text;
                              String telefono = conTelefono.text;
                              String colonia = conColonia.text;
                              String calle = conCalle.text;
                              String noExterior = conNoExterior.text;
                              String noInterior = conNoInterior.text;
                              String fecha = conFechaEntrega.text;

// Verifica que todos los campos estén completos
                              if (nombreCliente.isNotEmpty &&
                                  telefono.isNotEmpty &&
                                  colonia.isNotEmpty &&
                                  calle.isNotEmpty) {
                                // Crear el mapa para la tabla direccion
                                Map<String, dynamic> direccion = {
                                  'id_comunidad':
                                      1, // Puedes ajustar este valor
                                  'calle': calle,
                                  'colonia': colonia,
                                  'no_exterior': int.parse(
                                      noExterior), // Convierte a entero si es necesario
                                  'no_interior': noInterior.isNotEmpty
                                      ? int.parse(noInterior)
                                      : null,
                                  'num_telefono': telefono,
                                  'nombre_cliente': nombreCliente,
                                };

                                // Crear el mapa para la tabla pedido
                                Map<String, dynamic> pedido = {
                                  'id_status':
                                      2, // Estado inicial, ajusta si es necesario
                                  'id_direccion':
                                      null, // Este se asignará luego de insertar en 'direccion'
                                  'fecha_entrega': fecha
                                      .toString(), // O asigna la fecha específica
                                };

                                // Llama a la función para crear el pedido y la dirección
                                int res =
                                    await db.CREATE_PEDIDO(pedido, direccion);
                                print('RES CREATE: ${res}');
                                if (res > 0)
                                  setState(() {
                                    Navigator.pop(context);
                                    toast.showToast(context, 'Pedido',
                                        'Se registro con exito!', 'success');
                                  });
                              } else {
                                // Mostrar un mensaje Toast para llenar todos los campos
                                print("Por favor llena todos los campos.");
                                toast.showToast(
                                    context,
                                    'Campos incompletos',
                                    'Por favor llenar todos los campos',
                                    'error');
                              }
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.done_outline_outlined,
                                  color: Colors.greenAccent,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Completado',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: carritoController.mostrarTodosLosCarritos(),
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
            if (_counterValues.isEmpty) {
              _counterValues = List<int>.filled(snapshot.data!.length, 0);
            }
            List<Map<String, dynamic>> carritos = snapshot.data!;
            return ListView.builder(
              itemCount: carritos.length,
              itemBuilder: (context, index) {
                var carrito = carritos[index];
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${carrito['producto']}\n cantidad=${carrito['cantidad']}\n subtotal=${carrito['subtotal']}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                CounterButton(
                                  loading: false,
                                  onChange: (int val) {
                                    setState(() {
                                      _counterValues[index] = val;
                                    });
                                  },
                                  count: _counterValues[index],
                                  countColor: Colors.purple,
                                  buttonColor: Colors.purpleAccent,
                                  progressColor: Colors.purpleAccent,
                                ),
                              ],
                            ),
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

  void ingresarDireccion(String nombreCliente, String NumeroTel, String Colonia,
      String Calle, String NumExterior) {
    print('se ingresaron los datos');

    try {} catch (e) {}
    DireccionController direccionController = DireccionController();

    direccionController.insertDireccion('direccion', {
      'Id_comunidad': 1,
      'calle': '${Calle}',
      'no_exterior': '${NumExterior}',
      'colonia': '$Colonia',
      'no_interior': '',
      'telefono': '${NumeroTel}',
      'cliente_nombre': '$nombreCliente'
    });
    print('pasando los valores a las tablas');
    ListapedidoController listapedidoController = ListapedidoController();
    listapedidoController.insertarListaPedido('lista_pedido',
        {'id_pedido': '', 'id_producto': '', 'cantidad': '', 'subtotal': ''});
  }
}
