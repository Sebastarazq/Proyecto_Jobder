class PartialUserUpdate {
  String? nombre;
  int? celular;
  int? edad;
  String? categoria;
  String? descripcion;
  double? latitud;
  double? longitud;

  PartialUserUpdate({
    this.nombre,
    this.celular,
    this.edad,
    this.categoria,
    this.descripcion,
    this.latitud,
    this.longitud,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (nombre != null) data['nombre'] = nombre;
    if (celular != null) data['celular'] = celular;
    if (edad != null) data['edad'] = edad;
    if (categoria != null) data['categoria'] = categoria;
    if (descripcion != null) data['descripcion'] = descripcion;
    if (latitud != null) data['latitud'] = latitud;
    if (longitud != null) data['longitud'] = longitud;

    return data;
  }
}