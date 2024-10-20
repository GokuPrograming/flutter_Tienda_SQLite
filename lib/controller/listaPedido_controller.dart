import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/lista_pedido_model.dart';

class ListapedidoController {
   final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertarListaPedido(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<ListaPedidoModel>?> mostrarTodosLosListaPedidos() async {
    var con = await _dataBase.database;
    var result = await con.query('lista_pedido');
    return result.map((lista_pedido)=>ListaPedidoModel.fromMap(lista_pedido)).toList();
  }

    Future<int> actualizarListaPedido(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con
        .update(table, row, where: 'id_lista_pedido = ?', whereArgs: [row['id_lista_pedido']]);
  }
    Future<int> eliminarListaPedido(String table, int id_lista_pedido) async {
    var con = await _dataBase.database;
    return await con.delete(table, where: 'id_lista_pedido = ?', whereArgs: [id_lista_pedido]);
  }

}