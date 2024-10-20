class ComunidadModel {
  int? id_comunidad, id_municipio;
  String? comunidad;
  ComunidadModel({this.id_comunidad, this.id_municipio, this.comunidad});

  factory ComunidadModel.fromMap(Map<String, dynamic> comunidad) {
    return ComunidadModel(
        id_comunidad: comunidad['id_comunidad'],
        id_municipio: comunidad['id_municipio'],
        comunidad: comunidad['comunidad']);
  }
}
