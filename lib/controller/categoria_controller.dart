import 'package:sqflite/sqflite.dart';
import 'package:store_sqlite/database/database.dart';
import 'package:store_sqlite/models/categoria_model.dart';

class CategoriaController {
  final TiendaDataBase _dataBase = TiendaDataBase();

  Future<int> insertCategoria(String table, Map<String, dynamic> row) async {
    final db = await _dataBase.database;
    return await db.insert(table, row);
  }

  Future<List<CategoriaModel>?> mostrarTodasLasCategorias() async {
    var con = await _dataBase.database;
    var result = await con.query('categoria');
    return result.map((categoria)=>CategoriaModel.fromMap(categoria)).toList();
  }

    Future<int> actualizarCategoria(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con
        .update(table, row, where: 'id_categoria = ?', whereArgs: [row['id_categoria']]);
  }
    Future<int> eliminarCategoria(String table, int id_categoria) async {
    var con = await _dataBase.database;
    return await con.delete(table, where: 'id_categoria = ?', whereArgs: [id_categoria]);
  }

  // Métodos adicionales como update, delete, etc.
}
