import 'package:flutter/material.dart';
import 'package:store_sqlite/config/globalValues.dart';
import 'package:store_sqlite/backend/producto_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:store_sqlite/screens/menuApp/MenuApp_screenV.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  late ProductoController productoController = ProductoController();
  int _cartBadgeAmount = 4;
  int relaConteo = 0;
  late bool _showCartBadge = true;

  Future<void> _initializeCartBadge() async {
    await NumeroArticulosEnCArrito();
    setState(() {
      _cartBadgeAmount = relaConteo;

      Globalvalues.carritoContador.value =
          relaConteo; // Actualiza el valor global
    });
  }

  Future<List<Map>> NumeroArticulosEnCArrito() async {
    var resp = await carritoController.conteoDeArticulosEnCarrito();
    relaConteo = (resp[0]['sum(cantidad)'] ?? 0) as int;
    return resp;
  }

  @override
  void initState() {
    super.initState();
    _initializeCartBadge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[_shoppingCartBadge()],
          backgroundColor: Color.fromARGB(255, 255, 99, 71)),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: productoController.mostrarProductos(),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          // Si los datos son correctos, mostramos el GridView
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return CardWidgetToCarrito(snapshot.data![index]);
            },
          );
        },
      ),
    );
  }

  Widget _shoppingCartBadge() {
    return ValueListenableBuilder<int>(
      valueListenable: Globalvalues.carritoContador,
      builder: (BuildContext context, int value, Widget? child) {
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          badgeAnimation: badges.BadgeAnimation.slide(),
          showBadge: _showCartBadge,
          badgeStyle: badges.BadgeStyle(
            badgeColor: const Color.fromARGB(255, 172, 6, 6),
          ),
          badgeContent: Text(
            value.toString(),
            style: TextStyle(color: Colors.white),
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
          ),
        );
      },
    );
  }
}

class CardWidgetToCarrito extends StatefulWidget {
  final Map<String, dynamic> producto;

  CardWidgetToCarrito(this.producto);

  @override
  _CardWidgetToCarritoState createState() => _CardWidgetToCarritoState();
}

class _CardWidgetToCarritoState extends State<CardWidgetToCarrito> {
  int _contador = 0; // Variable para el contador

  // Función para incrementar el contador
  void _incrementarContador() {
    setState(() {
      _contador++;
    });
  }

  // Función para disminuir el contador
  void _decrementarContador() {
    if (_contador > 0) {
      setState(() {
        _contador--;
      });
    }
  }

  // Función para agregar el producto al carrito
  void _agregarAlCarrito() async {
    ProductoController productoController =
        ProductoController(); // No es necesario usar 'new'

    if (_contador > 0) {
      try {
        // Convertimos el precio a double, asegurándonos de que sea válido
        double precio =
            double.tryParse(widget.producto['precio'].toString()) ?? 0.0;
        double subtotal = precio * _contador;

        // Llamamos al método asincrónico para agregar al carrito
        await productoController.agregarAlCarrito(
            widget.producto['id_producto'], _contador, subtotal);

        // Si todo sale bien, mostramos un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Agregaste $_contador ${widget.producto['producto']} al carrito!',
            ),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _contador = 0;
        });
      } catch (e) {
        // Si ocurre un error al agregar al carrito, mostramos un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hubo un error al agregar el producto al carrito.',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Por favor, selecciona una cantidad para agregar al carrito.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto con tamaño reducido
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              widget.producto['img_producto'] ?? '',
              height: 80, // Imagen más pequeña
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del producto con texto más pequeño
                Text(
                  widget.producto['producto'] ?? 'Producto sin nombre',
                  style: TextStyle(
                    fontSize: 14, // Texto más pequeño
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                // Descripción del producto con texto más pequeño
                Text(
                  widget.producto['descripcion'] ?? 'Descripción no disponible',
                  style: TextStyle(
                    fontSize: 12, // Texto más pequeño
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                // Fila con precio y botón de agregar al carrito
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Precio del producto con texto más pequeño
                    Text(
                      '\$${widget.producto['price'] ?? '0'}',
                      style: TextStyle(
                        fontSize: 14, // Texto más pequeño
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    // Botón de agregar al carrito
                    ElevatedButton(
                      onPressed: _agregarAlCarrito,
                      child: Text('Agregar'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: TextStyle(
                            fontSize: 12), // Letra más pequeña en el botón
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Contador para agregar la cantidad
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decrementarContador,
                    ),
                    Text('$_contador', style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _incrementarContador,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
