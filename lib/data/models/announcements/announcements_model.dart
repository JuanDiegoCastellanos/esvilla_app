import 'dart:convert';

class AnnouncementModel {
    final String id;
    final String title;
    final String description;
    final String mainImage;
    final String body;
    final String secondaryImage;
    final DateTime publicationDate;
    final String createdBy;
    final DateTime createdAt;
    final DateTime updatedAt;

    AnnouncementModel({
        required this.id,
        required this.title,
        required this.description,
        required this.mainImage,
        required this.body,
        required this.secondaryImage,
        required this.publicationDate,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
    });

    factory AnnouncementModel.fromJson(String str) => AnnouncementModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AnnouncementModel.fromMap(Map<String, dynamic> json) => AnnouncementModel(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        mainImage: json["mainImage"],
        body: json["body"],
        secondaryImage: json["secondaryImage"],
        publicationDate: DateTime.parse(json["publicationDate"]),
        createdBy: json["createdBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
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
