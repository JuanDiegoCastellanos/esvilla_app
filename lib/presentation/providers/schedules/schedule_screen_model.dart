class ScheduleScreenModel {
  String? id;
  List<String>? days;
  String? startTime;
  String? endTime;
  List<String>? associatedSectors;
  bool? active;
  String? observations;
  String? garbageType;
  DateTime? createdAt;
  DateTime? updatedAt;

  ScheduleScreenModel({
    this.id,
    this.days,
    this.startTime,
    this.endTime,
    this.associatedSectors,
    this.active,
    this.observations,
    this.garbageType,
    this.createdAt,
    this.updatedAt
  });
}
