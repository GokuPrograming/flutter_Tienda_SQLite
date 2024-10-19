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
    return result.map((pedido) => PedidoModel.fromMap(pedido)).toList();
  }

  Future<int> actualizarPedido(String table, Map<String, dynamic> row) async {
    var con = await _dataBase.database;
    return await con.update(table, row,
        where: 'id_pedido = ?', whereArgs: [row['id_pedido']]);
  }

  Future<int> eliminarPedido(String table, int id_pedido) async {
    var con = await _dataBase.database;
    return await con
        .delete(table, where: 'id_pedido = ?', whereArgs: [id_pedido]);
  }

  Future<List<Map<String, dynamic>>?> mostrarPedidosConListaPedido(
      int? id_pedido) async {
    var con = await _dataBase.database;
    var result = await con.rawQuery('''
    SELECT *
    FROM lista_pedido
    inner join producto on lista_pedido.id_producto=producto.id_producto
    where id_pedido=?
  ''', [id_pedido]); // Aquí se pasa el parámetro
    print(id_pedido);
    print(result);
    return result;
  }

  Future<List<Map<String, dynamic>>?> mostrarTodosLosPedidosSinId() async {
    var con = await _dataBase.database;
    var result = await con.rawQuery('''
    SELECT *
    FROM pedido p
    inner join direccion d on p.id_direccion=d.id_direccion
  '''); // Aquí se pasa el parámetro

    print(result);
    return result;
  }

  Future<List<Map<String, dynamic>>?> mostrarPedidoDatosCliente(
      int? id_pedido) async {
    var con = await _dataBase.database;
    var result = await con.rawQuery('''
Select * from direccion d 
inner join pedido p on d.id_direccion=p.id_direccion
inner join comunidad c on d.id_comunidad=c.id_comunidad
inner join municipio m on c.id_municipio=m.id_municipio
where p.id_pedido=?
group by p.id_pedido
limit 1
  ''', [id_pedido]); // Aquí se pasa el parámetro
    print(id_pedido);
    print(result);
    return result;

//     SELECT
//     pedido.id_pedido,
//     pedido.fecha_entrega,
//     pedido.id_status,
//     direccion.calle,
//     direccion.colonia,
//     direccion.no_exterior,
//     direccion.no_interior,
//     direccion.num_telefono,
// FROM
//     lista_pedido
// INNER JOIN
//     producto ON lista_pedido.id_producto = producto.id_producto
// INNER JOIN
//     pedido ON lista_pedido.id_pedido = pedido.id_pedido
// INNER JOIN
//     direccion ON pedido.id_direccion = direccion.id_direccion
// INNER JOIN
//     categoria ON producto.id_categoria = categoria.id_categoria
// WHERE
//     lista_pedido.id_pedido = ?
// GROUP BY
//     pedido.id_pedido;
  }
}
