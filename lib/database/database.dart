import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_sqlite/models/categoria_model.dart';

class TiendaDataBase {
  static final NAMEDB = 'PizzeriaDB';
  static final VERSIONDB = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await initDatabase();
  }

  Future<Database> initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String path = join(folder.path, NAMEDB);
    return openDatabase(
      path,
      version: VERSIONDB,
      onCreate: (db, version) {
        String query1 = '''
          CREATE TABLE categoria(
          id_categoria INTEGER PRIMARY KEY,
          categoria VARCHAR(100)
          );
        ''';

        db.execute(query1);

        String query2 = '''
         CREATE TABLE producto(
          id_producto INTEGER PRIMARY KEY,
          producto VARCHAR(100),
          precio REAL,
          descripcion VARCHAR(300),
          id_categoria INT,
          img_producto VARCHAR(150),
          CONSTRAINT Producto_categoria_fk FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria)
        );''';
        db.execute(query2);

        String query3 = '''
         CREATE TABLE carrito(
          id_carrito INTEGER PRIMARY KEY,
          id_producto INT,
          cantidad INT,
          subtotal NUMERIC,
          CONSTRAINT carrito_producto_fk FOREIGN KEY(id_producto) REFERENCES producto(id_producto)
        );''';
        db.execute(query3);

        String query4 = '''
         CREATE TABLE status(
          id_status INTEGER PRIMARY KEY,
          status VARCHAR(50)
        );''';
        db.execute(query4);
        String query5 = '''
         CREATE TABLE municipio(
          id_municipio INTEGER PRIMARY KEY,
          municipio varchar(150)
        );''';
        db.execute(query5);
        String query6 = '''
         CREATE TABLE comunidad(
          id_comunidad INTEGER PRIMARY KEY,
          id_municipio INT,
          comunidad VARCHAR(150),
          CONSTRAINT comunidad_municipio_fk FOREIGN KEY(id_municipio) REFERENCES municipio(id_municipio)
        );''';
        db.execute(query6);
        String query7 = '''
         CREATE TABLE direccion(
          id_direccion INTEGER PRIMARY KEY,
          id_comunidad INT,
          calle VARCHAR(150) not null,
          colonia VARCHAR(150),
          no_exterior INT not null,
          no_interior INT,
          num_telefono VARCHAR(18),
          nombre_cliente VARCHAR(100) not null,
          CONSTRAINT direccion_comunidad_fk FOREIGN KEY(id_comunidad) REFERENCES comunidad(id_comunidad)
        );''';
        db.execute(query7);
        String query8 = '''
         CREATE TABLE pedido(
          id_pedido INTEGER PRIMARY KEY,
          id_status INT,
          id_direccion INT,
          fecha_entrega TEXT,
          CONSTRAINT pedido_status_fk FOREIGN KEY(id_status) REFERENCES status(id_status),
          CONSTRAINT pedido_direccion_fk FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion)
        );''';
        db.execute(query8);

        String query9 = '''
         CREATE TABLE lista_pedido(
          id_lista_pedido INTEGER PRIMARY KEY,
          id_producto INT,
          id_pedido int,
          cantidad INT,
          precio Real,
          subtotal NUMERIC,
          Constraint listaPpedido_pedido_fk  Foreign key(id_pedido) references pedido(id_pedido),
          CONSTRAINT listaPedido_producto_fk FOREIGN KEY(id_producto) REFERENCES producto(id_producto)
        );''';
        db.execute(query9);

        String query10 = '''
        INSERT INTO categoria
        (categoria) 
        VALUES
        ('Pizza'),
        ('Refreco'),
        ('Agua')
        ;
''';
        db.execute(query10);

        String query11 = '''
 INSERT INTO producto
    (producto, precio, descripcion, id_categoria) 
VALUES
    ('Pizza Grande de Peperoni', 200.50, 'Pizza Grande de 10 Rebanadas, con mucho peperoni y queso, orilla normal', 1),
    ('Refresco 2L Pepsi Sabor cola', 29.00, 'Pepsi 2L sabor Cola', 2),
    ('Agua de Jamaica 1L Marca La mamá de Pichis', 25.00, 'Agua de jamaica 100% natural', 3);

''';
        db.execute(query11);

        String query12 = '''
        Insert into status(status)values('completado'),('En Proceso'),('cancelado')
        ''';
        db.execute(query12);

        String query13 = '''
        insert into municipio(municipio)values('Cortazar'),('Celaya'),('Salamanca'),('Villagran')
        ''';
        db.execute(query13);
        String query14 = '''
        insert into comunidad(comunidad,id_municipio)values('Tierra Fria',1)
        ''';
        db.execute(query14);
        String query15 = '''
        insert into direccion(id_comunidad,calle,colonia,no_exterior,no_interior,num_telefono,nombre_cliente)
        values                 (1,'Alameda','Alameda',104,104,'4111549487','Miguel Vera Franco')
        ''';
        db.execute(query15);

        String query17 = '''
        insert into pedido(id_status,id_direccion,fecha_entrega)values(1,1,'2024-10-18'),(2,1,'2024-11-19'),(3,1,'2024-11-20')
        ''';
        db.execute(query17);

        String query16 = '''
      INSERT INTO lista_pedido(id_pedido, id_producto, cantidad, subtotal, precio)
      VALUES 
      (1, 1, 2, 211, 105), 
      (1, 3, 3, 333, 111),
      (2, 3, 3, 333, 111),
      (3, 3, 3, 333, 111)
        ''';
        db.execute(query16);
        // int? id_lista_pedido, id_producto, cantidad;
        // double? subtotal;
        print('se creo la base de datos');
      },
    );
  } // initdatabase

  // Future<int> INSERT(String table, Map<String, dynamic> row) async {
  //   var con = await database;
  //   return await con.insert(table, row);
  // }

  // Future<int> UPDATE(String table, Map<String, dynamic> row) async {
  //   var con = await database;
  //   return await con
  //       .update(table, row, where: 'idMovie = ?', whereArgs: [row['idMovie']]);
  // }

  // Future<int> DELETE(String table, int idMovie) async {
  //   var con = await database;
  //   return await con.delete(table, where: 'idMovie = ?', whereArgs: [idMovie]);
  // }

  // Future<List<CategoriaModel>?> SELECT() async {
  //   var con = await database;
  //   var result = await con.query('categoria');
  //   return result.map((categoria)=>CategoriaModel.fromMap(categoria)).toList();
  // }
}
