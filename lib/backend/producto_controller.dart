import 'dart:convert'; // Para convertir la respuesta JSON en un objeto Dart
import 'package:http/http.dart' as http;
import 'package:store_sqlite/backend/lista_productoModel.dart';
import 'package:store_sqlite/backend/pedidoModel_back.dart';
import 'package:store_sqlite/models/direccion_model.dart';
import 'package:store_sqlite/models/pedido_model.dart'; // Importamos la librería http

class ProductoController {
  // URL base de la API
  final String apiUrl = 'https://backen-linsfood.onrender.com/api/products';

  // Método para obtener productos
  Future<List<Map<String, dynamic>>> mostrarProductos() async {
    try {
      // Hacemos la solicitud GET
      final response = await http.get(Uri.parse(apiUrl));

      // Si la respuesta es exitosa (status 200)
      if (response.statusCode == 200) {
        // Decodificamos la respuesta JSON
        List<dynamic> data = json.decode(response.body);

        // Convertimos la lista de productos en una lista de Map<String, dynamic>
        List<Map<String, dynamic>> productos = data.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        return productos;
      } else {
        // Si la respuesta no es exitosa, lanzamos un error
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Si hay un error, lo mostramos
      throw Exception('Error fetching products: $e');
    }
  }

  // Método para agregar un producto al carrito
  Future<void> agregarAlCarrito(
      int idProducto, int cantidad, double subtotal) async {
    try {
      // Datos que se van a enviar al servidor
      Map<String, dynamic> data = {
        'id_producto': idProducto,
        'cantidad': cantidad,
        'subtotal': subtotal,
      };

      // Hacemos la solicitud POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Si la respuesta es exitosa (status 200)
      if (response.statusCode == 200) {
        print('Producto agregado al carrito');
        // Aquí podrías manejar la respuesta si es necesario
      } else {
        throw Exception('Failed to add product to cart');
      }
    } catch (e) {
      // Si hay un error, lo mostramos
      throw Exception('Error adding product to cart: $e');
    }
  }

  Future<int> BorrarDeCarrito(int idProducto) async {
    try {
      // Datos que se van a enviar al servidor
      Map<String, dynamic> data = {
        'id_producto': idProducto,
      };

      // Hacemos la solicitud DELETE
      final response = await http.delete(
        Uri.parse('https://backen-linsfood.onrender.com/api/carrito'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            data), // Aseguramos que estamos enviando el cuerpo correctamente
      );

      // Si la respuesta es exitosa (status 200)
      if (response.statusCode == 200) {
        print('Producto Borrado de carrito');
        return 1; // Producto borrado exitosamente
      } else {
        throw Exception('Failed to delete product from cart');
      }
    } catch (e) {
      // Si hay un error, lo mostramos
      throw Exception('Error deleting product from cart: $e');
    }
  }

  Future<List<Map<String, dynamic>>> mostrarCarrito() async {
    try {
      // Hacemos la solicitud GET
      final response = await http
          .get(Uri.parse('https://backen-linsfood.onrender.com/api/carrito'));

      // Si la respuesta es exitosa (status 200)
      if (response.statusCode == 200) {
        // Decodificamos la respuesta JSON
        List<dynamic> data = json.decode(response.body);

        // Convertimos la lista de productos en una lista de Map<String, dynamic>
        List<Map<String, dynamic>> productos = data.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        return productos;
      } else {
        // Si la respuesta no es exitosa, lanzamos un error
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Si hay un error, lo mostramos
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Map<String, dynamic>>> mostrarComunidad() async {
    try {
      // Hacemos la solicitud GET
      final response = await http
          .get(Uri.parse('https://backen-linsfood.onrender.com/api/comunidad'));

      // Si la respuesta es exitosa (status 200)
      if (response.statusCode == 200) {
        // Decodificamos la respuesta JSON
        List<dynamic> data = json.decode(response.body);

        // Convertimos la lista de productos en una lista de Map<String, dynamic>
        List<Map<String, dynamic>> productos = data.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        return productos;
      } else {
        // Si la respuesta no es exitosa, lanzamos un error
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Si hay un error, lo mostramos
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Map<String, dynamic>>> mostrarMunicipio() async {
    try {
      // Hacemos la solicitud GET
      final response = await http
          .get(Uri.parse('https://backen-linsfood.onrender.com/api/municipio'));

      // Si la respuesta es exitosa (status 200)
      if (response.statusCode == 200) {
        // Decodificamos la respuesta JSON
        List<dynamic> data = json.decode(response.body);

        // Convertimos la lista de productos en una lista de Map<String, dynamic>
        List<Map<String, dynamic>> productos = data.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        return productos;
      } else {
        // Si la respuesta no es exitosa, lanzamos un error
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Si hay un error, lo mostramos
      throw Exception('Error fetching products: $e');
    }
  }

  Future<int> ProcesarPedido(
    int idComunidad,
    String calle,
    String colonia,
    String noExterior,
    String? noInterior, // Si es opcional, usa '?'
    String telefono,
    String nombreCliente,
    String fecha,
  ) async {
    try {
      print('llega asi la fecha');
      print(fecha);
      // Crear el cuerpo de la solicitud
      final requestBody = {
        'id_comunidad': idComunidad,
        'calle': calle,
        'colonia': colonia,
        'no_exterior': noExterior,
        'no_interior': 4,
        'telefono': telefono,
        'nombre_cliente': nombreCliente,
        'fecha_entrega': fecha,
      };

      // Imprimir los datos antes de enviarlos
      print('Datos enviados al backend: $requestBody');

      // Realizar la solicitud HTTP
      final response = await http.post(
        Uri.parse('https://backen-linsfood.onrender.com/api/procesarPedido'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return 1; // Indicar éxito
      } else {
        throw Exception('Error al procesar pedido: ${response.body}');
      }
    } catch (e) {
      print('Error en ProcesarPedido: $e');
      return 0; // Indicar fallo
    }
  }

  Future<List<PedidoModel>> MostrarTodosLosPedidos() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backen-linsfood.onrender.com/api/todosLosPedidos'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Convierte cada elemento del JSON a PedidoModel
        return data.map((item) => PedidoModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load pedidos');
      }
    } catch (e) {
      throw Exception('Error fetching pedidos: $e');
    }
  }

  Future<List<PedidoModel>> MostrarTodosLosPedidosEnEspera() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backen-linsfood.onrender.com/api/pedidos_en_espera'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Convierte cada elemento del JSON a PedidoModel
        return data.map((item) => PedidoModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load pedidos');
      }
    } catch (e) {
      throw Exception('Error fetching pedidos: $e');
    }
  }

  Future<List<PedidoModel>> MostrarTodosLosPedidosCompletados() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backen-linsfood.onrender.com/api/pedidosCompletados'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Convierte cada elemento del JSON a PedidoModel
        return data.map((item) => PedidoModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load pedidos');
      }
    } catch (e) {
      throw Exception('Error fetching pedidos: $e');
    }
  }

  Future<List<PedidomodelBack>> MostrarDireccionPedido(int? id_pedido) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://backen-linsfood.onrender.com/api/mostrarDireccionPedido'),
        body: json.encode({'id_pedido': id_pedido}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Imprimir los datos recibidos para depuración
        print("Datos recibidos:");
        print(data);

        // Convertir a la lista de PedidomodelBack
        List<PedidomodelBack> pedidos =
            data.map((item) => PedidomodelBack.fromMap(item)).toList();

        // Imprimir los objetos PedidomodelBack para ver sus valores
        print("Objetos PedidomodelBack:");
        pedidos.forEach((pedido) {
          print("Nombre Cliente: ${pedido.nombreCliente}");
          print("Teléfono: ${pedido.numTelefono}");
          print("Municipio: ${pedido.municipio}");
          print("Comunidad: ${pedido.comunidad}");
          print("Calle: ${pedido.calle}");
          print("Colonia: ${pedido.colonia}");
          print("No Exterior: ${pedido.noExterior}");
        });

        return pedidos;
      } else {
        throw Exception('Failed to load pedidos');
      }
    } catch (e) {
      throw Exception('Error fetching pedidos: $e');
    }
  }

  Future<List<ListaProducto>> mostrarProductosPedido(int? id_pedido) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://backen-linsfood.onrender.com/api/mostrarProductosPedido'),
        body: json.encode({'id_pedido': id_pedido}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Imprimir los datos recibidos para depuración
        print("Datos recibidos:");
        print(data);

        // Convertir a la lista de ListaProducto
        List<ListaProducto> pedidos =
            data.map((item) => ListaProducto.fromMap(item)).toList();

        // Imprimir los objetos ListaProducto para ver sus valores
        pedidos.forEach((pedido) {
          print("Producto: ${pedido.producto}");
          print("Cantidad: ${pedido.cantidad}");
          print("Precio: ${pedido.precio}");
          print("Subtotal: ${pedido.subtotal}");
        });

        return pedidos;
      } else {
        throw Exception('Failed to load productos');
      }
    } catch (e) {
      throw Exception('Error fetching productos: $e');
    }
  }

  Future<bool> changeStatus(int idPedido, int idStatus) async {
    try {
      print('////////////////////////////////////////////////////');
      print('el id del pedido es= $idPedido  y el estatus= $idStatus');
      print('////////////////////////////////////////////////////');
      // Realizar la solicitud POST al endpoint de cambio de estado
      final response = await http.post(
        Uri.parse(
            'https://backen-linsfood.onrender.com/api/actualizarEstadoPedido'),
        body: json.encode({
          'id_pedido': idPedido,
          'id_status': idStatus,
        }),
        headers: {"Content-Type": "application/json"},
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta y verificar el éxito
        final data = json.decode(response.body);
        print("Respuesta del servidor: $data");

        // Evaluar si la operación fue exitosa según la respuesta
        return data['success'] == true;
      } else {
        print("Error al cambiar el estado del pedido: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Excepción al cambiar el estado del pedido: $e");
      return false;
    }
  }
}
