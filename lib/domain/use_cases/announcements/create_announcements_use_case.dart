import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/create_announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class CreateAnnouncementsUseCase {
  final AnnouncementsRepository _repository;

  CreateAnnouncementsUseCase(this._repository);

  Future<AnnouncementsEntity> call(CreateAnnouncementsRequestEntity request) async => 
  await _repository.add(request);
}
