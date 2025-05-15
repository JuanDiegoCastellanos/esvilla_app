import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/create_announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/update_announcements_entity.dart';

class AnnouncementPresentationModel {
  final String? id;
  final String? title;
  final String? description;
  final String? mainImage;
  final String? body;
  final String? secondaryImage;
  final DateTime? publicationDate;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isLoading;
  final String? error;

  AnnouncementPresentationModel({
    this.id,
    this.title,
    this.description,
    this.mainImage,
    this.body,
    this.secondaryImage,
    this.publicationDate,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.isLoading = false,
    this.error,
  });

  
  static List<AnnouncementPresentationModel> fromEntityList(List<AnnouncementsEntity> entities) {
    return entities.map((entity) => fromEntity(entity)).toList();
  }
  static PaginatedResponse<AnnouncementPresentationModel> toMapModelPage(
  PaginatedResponse<AnnouncementsEntity> page,
) {
  return PaginatedResponse<AnnouncementPresentationModel>(
    data: page.data
      .map(AnnouncementPresentationModel.fromEntity)  // o .fromEntityList
      .toList(),
    meta: page.meta,
  );
}

  static AnnouncementPresentationModel fromEntity(AnnouncementsEntity entity) {
    return AnnouncementPresentationModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      mainImage: entity.mainImage,
      body: entity.body,
      secondaryImage: entity.secondaryImage,
      publicationDate: entity.publicationDate,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static AnnouncementsEntity toEntity(AnnouncementPresentationModel entity) {
    return AnnouncementsEntity(
      id: entity.id ?? '',
      title: entity.title ?? '',
      description: entity.description ?? '',
      mainImage: entity.mainImage ?? '',
      body: entity.body ?? '',
      secondaryImage: entity.secondaryImage ?? '',
      publicationDate: entity.publicationDate ?? DateTime.now(),
      createdBy: entity.createdBy ?? '',
      createdAt: entity.createdAt ?? DateTime.now(),
      updatedAt: entity.updatedAt ?? DateTime.now(),
    );
  }

  static AnnouncementPresentationModel fromUpdateAnnouncementsRequestEntity(
      UpdateAnnouncementsRequestEntity entity) {
    return AnnouncementPresentationModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      mainImage: entity.mainImage,
      body: entity.body,
      secondaryImage: entity.secondaryImage,
      publicationDate: entity.publicationDate,
    );
  }

  static UpdateAnnouncementsRequestEntity toUpdateAnnouncementsRequestEntity(
      AnnouncementPresentationModel entity) {
    return UpdateAnnouncementsRequestEntity(
      id: entity.id!,
      title: entity.title,
      description: entity.description,
      mainImage: entity.mainImage,
      body: entity.body,
      secondaryImage: entity.secondaryImage,
      publicationDate: entity.publicationDate,
    );
  }

  static CreateAnnouncementsRequestEntity toCreateAnnouncementsRequestEntity(
      AnnouncementPresentationModel entity) {
    return CreateAnnouncementsRequestEntity(
      title: entity.title ?? '',
      description: entity.description ?? '',
      mainImage: entity.mainImage ?? '',
      body: entity.body ?? '',
      secondaryImage: entity.secondaryImage ?? '',
      publicationDate: entity.publicationDate ?? DateTime.now(),
    );
  }

  AnnouncementPresentationModel.empty()
      : this(
          id: '',
          title: '',
          description: '',
          mainImage: '',
          body: '',
          secondaryImage: '',
          publicationDate: DateTime.now(),
        );

  AnnouncementPresentationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? mainImage,
    String? body,
    String? secondaryImage,
    DateTime? publicationDate,
    bool? isLoading,
    String? error,
  }) {
    return AnnouncementPresentationModel(
      id:id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      mainImage: mainImage ?? this.mainImage,
      body: body ?? this.body,
      secondaryImage: secondaryImage ?? this.secondaryImage,
      publicationDate: publicationDate ?? this.publicationDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  factory AnnouncementPresentationModel.partly({
    String? id,
    String? title,
    String? description,
    String? mainImage,
    String? body,
    String? secondaryImage,
    DateTime? publicationDate,
    bool isLoading = false,
    String? error,
  }) {
    return AnnouncementPresentationModel(
      id: id,
      title: title,
      description: description,
      mainImage: mainImage,
      body: body,
      secondaryImage: secondaryImage,
      publicationDate: publicationDate,
      isLoading: isLoading,
      error: error,
    );
  }
}
