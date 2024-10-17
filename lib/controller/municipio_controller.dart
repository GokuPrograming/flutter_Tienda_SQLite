import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/municipio_model.dart';

class MunicipioController {
 final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertarMunicipio(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<MunicipioModel>?> mostrarTodosLosMunicipios() async {
    var con = await _dataBase.database;
    var result = await con.query('municipio');
    return result.map((municipio)=>MunicipioModel.fromMap(municipio)).toList();
  }

    Future<int> actualizarMunicipio(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con
        .update(table, row, where: 'id_municipio = ?', whereArgs: [row['id_municipio']]);
  }
    Future<int> eliminarMunicipio(String table, int id_municipio) async {
    var con = await _dataBase.database;
    return await con.delete(table, where: 'id_municipio = ?', whereArgs: [id_municipio]);
  }


}