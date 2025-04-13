class LocationEntity {
  final String type;
  final List<List<List<double>>> coordinates;

  LocationEntity({
    required this.type,
    required this.coordinates,
  });
}
