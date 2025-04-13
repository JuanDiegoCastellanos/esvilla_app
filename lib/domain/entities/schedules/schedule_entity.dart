class ScheduleEntity {
  final String id;
  final List<String> days;
  final String startTime;
  final String endTime;
  final List<String> associatedSectors;
  final bool active;
  final String observations;
  final String garbageType;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleEntity({
    required this.id,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.associatedSectors,
    required this.active,
    required this.observations,
    required this.garbageType,
    required this.createdAt,
    required this.updatedAt,
  });
}

