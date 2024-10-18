import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/producto_model.dart';

class ProductoController {
  final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertProducto(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<ProductoModel>?> mostrarTodosLosProductos() async {
    var con = await _dataBase.database;
    var result = await con.query('producto');
    return result.map((producto) => ProductoModel.fromMap(producto)).toList();
  }

  Future<List<Map<String, dynamic>>?> mostrarProductosConCategoria() async {
    var con = await _dataBase.database;
    var result = await con.rawQuery(
      '''
    SELECT *
    FROM producto p
    inner join categoria c on p.id_categoria=c.id_categoria 
  ''',
    );
    return result;
  }

  Future<int> actualizarProducto(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con.update(table, row,
        where: 'id_producto = ?', whereArgs: [row['id_producto']]);
  }

  Future<int> eliminarProducto(String table, int id_producto) async {
    var con = await _dataBase.database;
    return await con
        .delete(table, where: 'id_producto = ?', whereArgs: [id_producto]);
  }
}
