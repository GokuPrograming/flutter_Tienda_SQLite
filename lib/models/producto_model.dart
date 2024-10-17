
class ProductoModel {
  int? id_producto;
  String? producto;
  double? precio;
  String? descripcion;
  int? id_categoria;
  String? img_producto;

  ProductoModel(
      {this.id_producto,
      this.producto,
      this.precio,
      this.descripcion,
      this.id_categoria,
      this.img_producto});
  factory ProductoModel.fromMap(Map<String, dynamic> producto) {
    return ProductoModel(
        id_producto: producto['id_producto'],
        producto: producto['producto'],
        precio: producto['precio'],
        descripcion: producto['descripcion'],
        id_categoria: producto['id_categoria'],
        img_producto: producto['img_producto']);
  }
}
