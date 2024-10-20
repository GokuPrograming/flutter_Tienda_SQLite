import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:store_sqlite/controller/carrito_controller.dart';

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
                            onPressed: () {
                              // Acceder a todos los datos al presionar "Completado"
                              String nombreCliente = conNombreCliente.text;
                              String telefono = conTelefono.text;
                              String colonia = conColonia.text;
                              String calle = conCalle.text;
                              String noExterior = conNoExterior.text;

                              // Puedes realizar cualquier acción con los datos aquí,
                              // como guardarlos en la base de datos o mostrarlos en consola.
                              print('Nombre del Cliente: $nombreCliente');
                              print('Teléfono: $telefono');
                              print('Colonia: $colonia');
                              print('Calle: $calle');
                              print('Número Exterior: $noExterior');
                              print('Valores de los contadores: $_counterValues');

                              // Aquí podrías enviar los datos a tu base de datos usando carritoController

                              // Cerrar el modal
                              Navigator.pop(context);
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
}
