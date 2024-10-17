import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/carrito_model.dart';

class CarritoController {
  final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertCarrito(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<CarritoModel>?> mostrarCarritos() async {
    var con = await _dataBase.database;
    var result = await con.query('id_carrito');
    return result.map((carrito) => CarritoModel.fromMap(carrito)).toList();
  }

  Future<int> actualizarCarrito(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con.update(table, row,
        where: 'id_carrito = ?', whereArgs: [row['id_carrito']]);
  }

  Future<int> eliminarCarrito(String table, int id_carrito) async {
    var con = await _dataBase.database;
    return await con
        .delete(table, where: 'id_carrito = ?', whereArgs: [id_carrito]);
  }
}
