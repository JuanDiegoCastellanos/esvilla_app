import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class GetMyAnnouncementsBetweenCreationDateUseCase {
  final AnnouncementsRepository _repository;

  GetMyAnnouncementsBetweenCreationDateUseCase(this._repository);

  Future<List<AnnouncementsEntity>> call(String startDate, String endDate) async => 
  await _repository.getMyAnnouncementsBetweenCreationDates(startDate, endDate);

}