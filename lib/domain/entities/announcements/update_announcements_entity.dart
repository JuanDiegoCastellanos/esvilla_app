class UpdateAnnouncementsRequestEntity {
  final String id;
  final String? title;
  final String? description;
  final String? mainImage;
  final String? body;
  final String? secondaryImage;
  final DateTime? publicationDate;

  UpdateAnnouncementsRequestEntity({
    required this.id,
    this.title,
    this.description,
    this.mainImage,
    this.body,
    this.secondaryImage,
    this.publicationDate,
  });
}
