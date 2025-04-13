class UpdateAnnouncementRequest {
  final String id;
  final String? title;
  final String? description;
  final String? mainImage;
  final String? body;
  final String? secondaryImage;
  final DateTime? publicationDate;

  UpdateAnnouncementRequest({
    required this.id,
    this.title,
    this.description,
    this.mainImage,
    this.body,
    this.secondaryImage,
    this.publicationDate,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'_id': id};
    
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (mainImage != null) map['mainImage'] = mainImage;
    if (body != null) map['body'] = body;
    if (secondaryImage != null) map['secondaryImage'] = secondaryImage;
    if (publicationDate != null) {
      map['publicationDate'] = publicationDate!.toIso8601String();
    }
    
    return map;
  }
}