class CategoriaModel {
  int? id_categoria;
  String? categoria;

  CategoriaModel({this.id_categoria, this.categoria});

  factory CategoriaModel.fromMap(Map<String,dynamic> categoria){
    return CategoriaModel(
      //idGenre: movie['idGenre'],
      id_categoria: categoria['id_categoria'],
      categoria: categoria['categoria']
    );
  }
}
