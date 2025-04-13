class UpdateScheduleRequestEntity {
  final String id;
  final List<String>? days;
  final String? startTime;
  final String? endTime;
  final List<String>? associatedSectors;
  final bool? active;
  final String? observations;
  final String? garbageType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UpdateScheduleRequestEntity({
    required this.id,
    this.days,
    this.startTime,
    this.endTime,
    this.associatedSectors,
    this.active,
    this.observations,
    this.garbageType,
    this.createdAt,
    this.updatedAt,
  });
}
