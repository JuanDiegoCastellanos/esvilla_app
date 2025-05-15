import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_list_state_notifier_provider.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final announcementsPaginatedPresentationProvider = Provider<
    AsyncValue<PaginatedResponse<AnnouncementPresentationModel>>>((ref) {
  final asyncPage = ref.watch(announcementsListControllerProvider);
  // Cuando cambie asyncPage, lo transformamos con whenData
  return asyncPage.whenData(AnnouncementPresentationModel.toMapModelPage);
});