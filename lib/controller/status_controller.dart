import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/status_model.dart';

class StatusController {
   final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertarNuevoStatus(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<StatusModel>?> mostrarTodosLosStatus() async {
    var con = await _dataBase.database;
    var result = await con.query('status');
    return result.map((status)=>StatusModel.fromMap(status)).toList();
  }

    Future<int> actualizarStatus(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con
        .update(table, row, where: 'id_status = ?', whereArgs: [row['id_status']]);
  }
    Future<int> eliminarStatus(String table, int id_status) async {
    var con = await _dataBase.database;
    return await con.delete(table, where: 'id_status = ?', whereArgs: [id_status]);
  }

}