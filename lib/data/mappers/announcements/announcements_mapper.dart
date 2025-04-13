import 'package:esvilla_app/data/models/announcements/announcements_model.dart';
import 'package:esvilla_app/data/models/announcements/create_announcement_request.dart';
import 'package:esvilla_app/data/models/announcements/update_announcements_request.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/create_announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/update_announcements_entity.dart';

class AnnouncementsMapper {
  static AnnouncementsEntity toEntity(AnnouncementModel model) {
    return AnnouncementsEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      mainImage: model.mainImage,
      body: model.body,
      secondaryImage: model.secondaryImage,
      publicationDate: model.publicationDate,
      createdBy: model.createdBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static AnnouncementModel toModel(AnnouncementsEntity entity) {  
    return AnnouncementModel(
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

  static CreateAnnouncementRequest toCreateAnnouncementRequest(CreateAnnouncementsRequestEntity entity) {  
    return CreateAnnouncementRequest(
      title: entity.title,
      description: entity.description,
      mainImage: entity.mainImage,
      body: entity.body,
      secondaryImage: entity.secondaryImage,
      publicationDate: entity.publicationDate,
    );
  }

  static UpdateAnnouncementRequest toUpdateAnnouncementRequest(UpdateAnnouncementsRequestEntity entity) {  
    return UpdateAnnouncementRequest(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      mainImage: entity.mainImage,
      body: entity.body,
      secondaryImage: entity.secondaryImage,
      publicationDate: entity.publicationDate,
    );
  }
  
  static List<AnnouncementsEntity> toEntityList(List<AnnouncementModel> models) {
    return models.map((e) => toEntity(e)).toList();
  }

  static List<AnnouncementModel> toModelList(List<AnnouncementsEntity> entities) {  
    return entities.map((e) => toModel(e)).toList();
  }

}