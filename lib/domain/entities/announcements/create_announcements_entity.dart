class CreateAnnouncementsRequestEntity {
  final String title;
  final String description;
  final String mainImage;
  final String body;
  final String secondaryImage;
  final DateTime publicationDate;

  CreateAnnouncementsRequestEntity({
    required this.title,
    required this.description,
    required this.mainImage,
    required this.body,
    required this.secondaryImage,
    required this.publicationDate,
  });
}
