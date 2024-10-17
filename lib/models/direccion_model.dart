class DireccionModel {
  int? id_direccion;
  int? id_comunidad, no_exterior, no_interior;
  String? calle;
  String? colonia, num_telefono, nombre_cliente;

  DireccionModel(
      {this.id_direccion,
      this.id_comunidad,
      this.calle,
      this.colonia,
      this.no_exterior,
      this.no_interior,
      this.num_telefono,
      this.nombre_cliente});

  factory DireccionModel.fromMap(Map<String, dynamic> direccion) {
    return DireccionModel(
        id_direccion: direccion['id_direccion'],
        id_comunidad: direccion['id_comunidad'],
        calle: direccion['calle'],
        colonia: direccion['colonia'],
        no_exterior: direccion['no_exterior'],
        no_interior: direccion['no_interior'],
        num_telefono: direccion['num_telefono'],
        nombre_cliente: direccion['nombre_cliente']);
  }
}
