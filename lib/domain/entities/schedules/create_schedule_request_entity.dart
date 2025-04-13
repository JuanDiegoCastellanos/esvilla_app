class CreateScheduleRequestEntity {
  final List<String> days;
  final String startTime;
  final String endTime;
  final List<String> associatedSectors;
  final bool active;
  final String observations;
  final String garbageType;

  CreateScheduleRequestEntity({
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.associatedSectors,
    required this.active,
    required this.observations,
    required this.garbageType,
  });
}
