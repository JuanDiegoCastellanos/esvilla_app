class CreateAnnouncementRequest {
  final String title;
  final String description;
  final String mainImage;
  final String body;
  final String secondaryImage;
  final DateTime publicationDate;

  CreateAnnouncementRequest({
    required this.title,
    required this.description,
    required this.mainImage,
    required this.body,
    required this.secondaryImage,
    required this.publicationDate,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'mainImage': mainImage,
        'body': body,
        'secondaryImage': secondaryImage,
        'publicationDate': publicationDate.toIso8601String(),
      };
}
