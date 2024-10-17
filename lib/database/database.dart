import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MoviesDatabase {
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
          precio NUMERIC,
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
          cantidad INT,
          subtotal NUMERIC,
          CONSTRAINT listaPedido_producto_fk FOREIGN KEY(id_producto) REFERENCES producto(id_producto)
        );''';
        db.execute(query9);
      },
    );
  } // initdatabase

  Future<int> INSERT(String table, Map<String, dynamic> row) async {
    var con = await database;
    return await con.insert(table, row);
  }

  Future<int> UPDATE(String table, Map<String, dynamic> row) async {
    var con = await database;
    return await con
        .update(table, row, where: 'idMovie = ?', whereArgs: [row['idMovie']]);
  }

  Future<int> DELETE(String table, int idMovie) async {
    var con = await database;
    return await con.delete(table, where: 'idMovie = ?', whereArgs: [idMovie]);
  }

  // Future<List<MoviesDAO>?> SELECT() async {
  //   var con = await database;
  //   var result = await con.query('tblmovies');
  //   return result.map((movie) => MoviesDAO.fromMap(movie)).toList();
  // }
}

/* CREATE TABLE tblmovies(
          idMovie INTEGER PRIMARY KEY,
          nameMovie VARCHAR(100),
          overview TEXT,
          idGenre char(1),
          imgMovie VARCHAR(150),
          releaseDate CHAR(10),
          CONSTRAINT fk_gen FOREIGN KEY(idGenre) REFERENCES tblgenre(idGenre)

CONSTRAINT fk_gen FOREIGN KEY(idGenre) REFERENCES tblgenre(idGenre)

            CREATE TABLE tblgenre(
          idGenre char(1) PRIMARY KEY,
          dscgenre VARCHAR(50)  
        );
        
        
        );*/