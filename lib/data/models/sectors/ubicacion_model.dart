class Ubicacion {
  final String type;
  final List<List<List<double>>> coordinates;

  Ubicacion({
    required this.type,
    required this.coordinates,
  });

  factory Ubicacion.fromMap(Map<String, dynamic> json) => Ubicacion(
        type: json["type"],
        coordinates: List<List<List<double>>>.from(json["coordinates"].map(
            (x) => List<List<double>>.from(
                x.map((x) => List<double>.from(x.map((x) => x?.toDouble())))))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) =>
            List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}
