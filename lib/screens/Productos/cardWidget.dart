import 'package:flutter/material.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:counter_button/counter_button.dart';
import 'package:store_sqlite/config/globalValues.dart';
import 'package:store_sqlite/controller/carrito_controller.dart';
import 'package:store_sqlite/controller/categoria_controller.dart';
import 'package:store_sqlite/controller/producto_controller.dart';
import 'package:store_sqlite/models/categoria_model.dart';
import 'package:store_sqlite/screens/Productos/dropDown_Categoria_widget.dart';

class Cardwidget extends StatefulWidget {
  final Map<String, dynamic> producto;
  Cardwidget(this.producto, {super.key});

  @override
  State<Cardwidget> createState() => _CardwidgetState();
}

class _CardwidgetState extends State<Cardwidget> {
  static ValueNotifier<bool> refrescarWidget = ValueNotifier(true);

  CarritoController carritoController = CarritoController();
  int _counterValue = 0;
  int newId = 0;
  @override
  Widget build(BuildContext context) {
    double precio = widget.producto['precio'];
    return Column(
      children: [
        ProductCard(
          imageUrl:
              'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcQndSK7hvssofrM2uzv75NxVjrkAwH3RwyqWcBesUsmq1ipmkuljRr6x_SRbCKaBXvjTR9CKfAaEFtmUFw-69o52wgVMgk2hp8KDYr4FvKtQ8ZfKewgOW4gDQ&usqp=CAE4',
          categoryName: '${widget.producto['id_producto']}',
          productName: '${widget.producto['producto']}',
          price: precio,
          currency: '\$',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled:
                  true, // Permite que el modal ocupe toda la pantalla
              // barrierColor: Colors.greenAccent,
              backgroundColor: const Color.fromARGB(255, 46, 45, 41),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              builder: (BuildContext context) {
                int id = widget.producto['id_producto'];
                return editarProducto(widget: widget);
              },
            );
          },
          cardColor: Colors.white,
          textColor: Colors.black,
          borderRadius: 6.0,
        ),
        // Usa SizedBox para controlar el espacio entre el ProductCard y el CounterButton
        SizedBox(height: 1), // Ajusta este valor para el espaciado deseado
      ],
    );
  }
}

class editarProducto extends StatefulWidget {
  final Cardwidget? widget;
  const editarProducto({
    super.key,
    this.widget,
  });

  @override
  _editarProductoState createState() => _editarProductoState();
}

class _editarProductoState extends State<editarProducto> {
  TextEditingController conNameProduct = TextEditingController();
  TextEditingController conDescripcion = TextEditingController();
  TextEditingController conPrecio = TextEditingController();
  int? id_categoria;
  String? categoria;

  @override
  void initState() {
    super.initState();
    if (widget.widget != null) {
      // Inicializa los controladores con los valores actuales del producto
      conNameProduct.text = widget.widget?.producto['producto'];
      conDescripcion.text = widget.widget?.producto['descripcion'];
      conPrecio.text = widget.widget!.producto['precio'].toString();
      id_categoria = widget.widget?.producto['id_categoria'];
      categoria = widget.widget?.producto['categoria'];
    } else {
      conNameProduct.clear();
      conDescripcion.clear();
      conPrecio.clear();
    }
  }

  @override
  void dispose() {
    // Limpia los controladores cuando el widget se destruye
    conNameProduct.dispose();
    conDescripcion.dispose();
    conPrecio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextFormField txtName = TextFormField(
      controller: conNameProduct,
      decoration: InputDecoration(
          label: Text(id_categoria == null
              ? 'Nombre del producto'
              : 'Agregar Nuevo Producto')),
    );

    TextFormField txtDescripcion = TextFormField(
      controller: conDescripcion,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Escribe una descripción:',
      ),
      maxLines: 3,
    );

    TextFormField txtPrecio = TextFormField(
      controller: conPrecio,
      decoration: InputDecoration(label: Text('Precio:')),
    );

    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(child: Text('EDITAR PRODUCTO')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: txtName,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: txtDescripcion,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: txtPrecio,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Categoria:')),
              ),
              DropdownCategoriaWidget(
                id_categoria,
                categoria,
                OnChanged: (CategoriaModel? categoria) {
                  print('trae el valor de vuelta');
                  print(categoria?.id_categoria);
                  if (categoria != null) {
                    setState(() {
                      id_categoria = categoria.id_categoria!;
                    });
                  } else {
                    print('ocurrio un error');
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .3,
                      height: MediaQuery.of(context).size.height * .05,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 21, 10),
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .3,
                      height: MediaQuery.of(context).size.height * .05,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 11, 141, 11),
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                          onPressed: () {
                            double precio_Converter =
                                double.parse(conPrecio.text);
                            try {
                              if (widget.widget?.producto['id_producto'] !=
                                  null) {
                                ActualizarProducto(precio_Converter);
                              } else if (widget
                                      .widget?.producto['id_producto'] ==
                                  null) {
                                insertarProducto(precio_Converter);
                              }
                            } catch (e) {
                              print('el error al editar el producto= $e');
                            }
                          },
                          icon: Icon(Icons.done)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void insertarProducto(double precio_converter) {
    ProductoController productoController = ProductoController();
    productoController.insertProducto('producto', {
      'id_categoria': '$id_categoria',
      'producto': conNameProduct.text,
      'descripcion': conDescripcion.text,
      'precio': '${precio_converter}'
    });
    print('Producto Agregado');
    Globalvalues.refrescarWidget.value = !Globalvalues.refrescarWidget.value;
    Navigator.pop(context);
  }

  void ActualizarProducto(double precio_converter) {
    ProductoController productoController = ProductoController();
    productoController.actualizarProducto('producto', {
      'id_producto': '${widget.widget!.producto['id_producto']}',
      'id_categoria': '$id_categoria',
      'producto': conNameProduct.text,
      'descripcion': conDescripcion.text,
      'precio': '${precio_converter}'
    });
    print('el producto se actualizo');
    Globalvalues.refrescarWidget.value = !Globalvalues.refrescarWidget.value;
    Navigator.pop(context);
  }
}
