import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/create_announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/update_announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/generic_repository.dart';

abstract class AnnouncementsRepository implements GenericRepository<AnnouncementsEntity, CreateAnnouncementsRequestEntity, UpdateAnnouncementsRequestEntity> {

}