class Coordenada {
  final int? id;
  final double latitudInicial;
  final double longitudInicial;
  final double latitudFinal;
  final double longitudFinal;

  Coordenada({
    this.id,
    required this.latitudInicial,
    required this.longitudInicial,
    required this.latitudFinal,
    required this.longitudFinal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitudInicial': latitudInicial,
      'longitudInicial': longitudInicial,
      'latitudFinal': latitudFinal,
      'longitudFinal': longitudFinal,
    };
  }
}