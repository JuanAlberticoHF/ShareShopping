
class Articulos {
  String nombre;
  String? nota;
  String? unidad;
  int? cantidad;
  bool check = false;

  Articulos({
    required this.nombre,
    this.nota,
    this.unidad,
    this.cantidad,
  });

  Articulos.fromMap(Map<String, dynamic> data)
      : nombre = data['nombre'],
        nota = data['nota'],
        unidad = data['unidad'],
        cantidad = data['cantidad'],
        check = data['check'] ?? false;

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'nota': nota,
      'unidad': unidad,
      'cantidad': cantidad,
      'check': check,
    };
  }
}