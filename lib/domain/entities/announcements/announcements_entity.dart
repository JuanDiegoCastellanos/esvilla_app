class AnnouncementsEntity {
  final String id;
  final String title;
  final String description;
  final String? mainImage;
  final String body;
  final String? secondaryImage;
  final DateTime publicationDate;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnnouncementsEntity({
    required this.id,
    required this.title,
    required this.description,
    this.mainImage,
    required this.body,
    this.secondaryImage,
    required this.publicationDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
