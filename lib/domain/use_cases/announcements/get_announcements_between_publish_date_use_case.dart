import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class GetAnnouncementsBetweenPublishDateUseCase {
  final AnnouncementsRepository _repository;

  GetAnnouncementsBetweenPublishDateUseCase(this._repository);

  Future<List<AnnouncementsEntity>> call(String startDate, String endDate) async => 
  await _repository.getAnnouncementsBetweenPublishDates(startDate, endDate);
  
}