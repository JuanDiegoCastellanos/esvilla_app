class AnnouncementModel {
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

  AnnouncementModel({
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

  factory AnnouncementModel.fromMap(Map<String, dynamic> json) {
    try {
      return AnnouncementModel(
        id: json["_id"]?.toString() ?? "",
        title: json["title"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        mainImage: json["mainImage"]?.toString(),
        body: json["body"]?.toString() ?? "",
        secondaryImage: json["secondaryImage"]?.toString(),
        publicationDate: json["publicationDate"] != null
            ? DateTime.parse(json["publicationDate"].toString())
            : DateTime.now(),
        createdBy: json["createdBy"]?.toString() ?? "",
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"].toString())
            : DateTime.now(),
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"].toString())
            : DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error parsing AnnouncementModel: $e - JSON: $json');
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "mainImage": mainImage,
        "body": body,
        "secondaryImage": secondaryImage,
        "publicationDate": publicationDate.toIso8601String(),
        "createdBy": createdBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
