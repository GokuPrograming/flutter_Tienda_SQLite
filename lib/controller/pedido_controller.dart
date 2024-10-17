import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/pedido_model.dart';

class PedidoController {
   final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertarPedido(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<PedidoModel>?> mostrarTodosLosPedidos() async {
    var con = await _dataBase.database;
    var result = await con.query('pedido');
    return result.map((pedido)=>PedidoModel.fromMap(pedido)).toList();
  }

    Future<int> actualizarPedido(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con
        .update(table, row, where: 'id_pedido = ?', whereArgs: [row['id_pedido']]);
  }
    Future<int> eliminarPedido(String table, int id_pedido) async {
    var con = await _dataBase.database;
    return await con.delete(table, where: 'id_pedido = ?', whereArgs: [id_pedido]);
  }

}