import 'package:flutter/material.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:counter_button/counter_button.dart';
import 'package:store_sqlite/config/globalValues.dart';
import 'package:store_sqlite/controller/carrito_controller.dart';

class Cardwidgettocarrito extends StatefulWidget {
  final Map<String, dynamic> producto;
  Cardwidgettocarrito(this.producto, {super.key});

  @override
  State<Cardwidgettocarrito> createState() => _CardwidgetState();
}

class _CardwidgetState extends State<Cardwidgettocarrito> {
  CarritoController carritoController = CarritoController();
  int _counterValue = 0;
  final String _directoryImage =
      '/data/user/0/com.example.store_sqlite/app_flutter/assets/img/products';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String path = 'assets/img/products';

    double precio = widget.producto['precio'];

    double subtotal = 0;
    return Column(
      children: [
        ProductCard(
          imageUrl: widget.producto['img_producto'] != null
              ? '${_directoryImage}/${widget.producto['img_producto']}'
              : 'assets/img/logo_tec.jpeg',
          categoryName: '${widget.producto['id_producto']}',
          productName: '${widget.producto['producto']}',
          price: precio,
          currency: '\$',
          onTap: () {
            // Handle card tap event
          },
          cardColor: Colors.white,
          textColor: Colors.black,
          borderRadius: 6.0,
        ),
        // Usa SizedBox para controlar el espacio entre el ProductCard y el CounterButton
        SizedBox(height: 1), // Ajusta este valor para el espaciado deseado
        CounterButton(
          loading: false,
          onChange: (int val) {
            setState(() {
              _counterValue = val;
            });
          },
          count: _counterValue,
          countColor: Colors.purple,
          buttonColor: Colors.purpleAccent,
          progressColor: Colors.purpleAccent,
        ),
        // Otro SizedBox para el espacio entre CounterButton e IconButton
        SizedBox(height: 1), // Ajusta este valor también
        IconButton(
          onPressed: () async {
            print(_counterValue);

            subtotal = precio * _counterValue;
            if (subtotal > 0 && _counterValue > 0) {
              // Validaciones
              setState(
                () {
                  inSertarACarrito(subtotal);
                  // Actualiza el contador global para que se refleje el cambio en el badge
                  _counterValue = 0;
                  // Feedback al usuario
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Producto ${widget.producto['id_producto']} cantidad=${_counterValue} subtotal= ${subtotal}agregado al carrito')),
                  );
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Error: producto no válido ${widget.producto['id_producto']} o cantidad incorrecta $_counterValue')),
              );
            }
          },
          icon: const Icon(Icons.add_shopping_cart_rounded),
        ),
      ],
    );
  }

  Future<int?> inSertarACarrito(double subtotal) async {
    try {
      int resp = await carritoController.insertCarrito('carrito', {
        'id_producto': widget.producto['id_producto'],
        'cantidad': _counterValue,
        'subtotal': subtotal,
      });

      if (resp > 0) {
        // Aquí se obtiene el número de productos en el carrito desde la base de datos
        var resp = await carritoController.conteoDeArticulosEnCarrito();
        int cantidadProductos = (resp[0]['sum(cantidad)'] ?? 0) as int;
        Globalvalues.carritoContador.value = cantidadProductos;
        print('cantidad=$cantidadProductos');
        return cantidadProductos;
      } else {
        print('no se mando nada');
      }
    } catch (e) {
      'fallo al haceer la insercion $e';
    }
    return null;
  }
}
