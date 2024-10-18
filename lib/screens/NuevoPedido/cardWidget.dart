import 'package:flutter/material.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:counter_button/counter_button.dart';

class Cardwidget extends StatefulWidget {
  final Map<String, dynamic> producto;
  Cardwidget(this.producto, {super.key});

  @override
  State<Cardwidget> createState() => _CardwidgetState();
}

class _CardwidgetState extends State<Cardwidget> {
  int _counterValue = 0;

  @override
  Widget build(BuildContext context) {
    double precio = widget.producto['precio'];
    return Column(
      children: [
        ProductCard(
          imageUrl:
              'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcQndSK7hvssofrM2uzv75NxVjrkAwH3RwyqWcBesUsmq1ipmkuljRr6x_SRbCKaBXvjTR9CKfAaEFtmUFw-69o52wgVMgk2hp8KDYr4FvKtQ8ZfKewgOW4gDQ&usqp=CAE4',
          categoryName: '${widget.producto['categoria']}',
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
          onPressed: () {},
          icon: Icon(Icons.add_shopping_cart_rounded),
        ),
      ],
    );
  }
}
