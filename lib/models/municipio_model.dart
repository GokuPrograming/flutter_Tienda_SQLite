class MunicipioModel {
  int? id_municipio;
  String? municipio;

  MunicipioModel({this.id_municipio, this.municipio});
  factory MunicipioModel.fromMap(Map<String, dynamic> municipio) {
    return MunicipioModel(
        id_municipio: municipio['id_municipio'],
        municipio: municipio['municipio']);
  }
}
