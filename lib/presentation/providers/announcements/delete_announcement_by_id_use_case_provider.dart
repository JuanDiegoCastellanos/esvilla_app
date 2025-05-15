import 'package:esvilla_app/domain/use_cases/announcements/delete_announcements_use_case.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteAnnouncementByIdUseCaseProvider = Provider<DeleteAnnouncementsUseCase>((ref) {
  final repository = ref.watch(announcementRepositoryProvider);
  return DeleteAnnouncementsUseCase(repository);
});
