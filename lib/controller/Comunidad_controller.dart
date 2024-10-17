import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/comunidad_model.dart';

class ComunidadController {
   final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertarComunidad(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<ComunidadModel>?> mostrarTodasLasComunidades() async {
    var con = await _dataBase.database;
    var result = await con.query('comunidad');
    return result.map((comunidad)=>ComunidadModel.fromMap(comunidad)).toList();
  }

    Future<int> actualizarComunidad(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con
        .update(table, row, where: 'id_comunidad = ?', whereArgs: [row['id_comunidad']]);
  }
    Future<int> eliminarComunidad(String table, int id_comunidad) async {
    var con = await _dataBase.database;
    return await con.delete(table, where: 'id_comunidad = ?', whereArgs: [id_comunidad]);
  }

}