import 'package:flutter/material.dart';

class Globalvalues {
  static ValueNotifier banMoviemientoActualizar = ValueNotifier(true);
  static ValueNotifier<bool> refrescarWidget = ValueNotifier(true);
  static ValueNotifier<bool> refrescarCarrito_desde_borrar =
      ValueNotifier(true);
  static ValueNotifier<int> id_Municipio = ValueNotifier(0);
  static ValueNotifier<bool> refrescarCalendario = ValueNotifier(true);
  static ValueNotifier<bool> refrescarCarrito = ValueNotifier(true);
  static ValueNotifier<bool> refrecarCarritoContador = ValueNotifier(true);
}
