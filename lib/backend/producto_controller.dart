import 'dart:convert'; // Para convertir la respuesta JSON en un objeto Dart
import 'package:http/http.dart' as http; // Importamos la librería http

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
}
