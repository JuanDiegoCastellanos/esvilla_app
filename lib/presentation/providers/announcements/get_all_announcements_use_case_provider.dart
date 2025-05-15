import 'package:esvilla_app/domain/use_cases/announcements/get_all_announcements_use_case.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllAnnouncementsUseCaseProvider = Provider<GetAllAnnouncementsUseCase>((ref) {
  final repository = ref.watch(announcementRepositoryProvider);
  return GetAllAnnouncementsUseCase(repository);
});
