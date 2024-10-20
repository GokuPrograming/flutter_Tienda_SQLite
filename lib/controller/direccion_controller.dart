import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/direccion_model.dart';

class DireccionController {
   final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertDireccion(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<DireccionModel>?> mostrarTodasLasDirecciones() async {
    var con = await _dataBase.database;
    var result = await con.query('categoria');
    return result.map((direccion)=>DireccionModel.fromMap(direccion)).toList();
  }

    Future<int> actualizarDireccion(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con
        .update(table, row, where: 'id_direccion = ?', whereArgs: [row['id_direccion']]);
  }
    Future<int> eliminarDireccion(String table, int id_direccion) async {
    var con = await _dataBase.database;
    return await con.delete(table, where: 'id_direccion = ?', whereArgs: [id_direccion]);
  }

}