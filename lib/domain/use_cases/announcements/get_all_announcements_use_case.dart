import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class GetAllAnnouncementsUseCase {
  final AnnouncementsRepository _repository;

  GetAllAnnouncementsUseCase(this._repository);

  Future<List<AnnouncementsEntity>> call() async => await _repository.getAll();
}