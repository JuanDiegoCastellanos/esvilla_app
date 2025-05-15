import 'package:esvilla_app/presentation/providers/announcements/announcements_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/announcements/create_announcements_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/announcements/update_announcements_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTextProvider = StateProvider<String>((_) => '');
final dateFilterProvider = StateProvider<String>((_) => '');

final addAnnouncementProvider = FutureProvider.family<bool, AnnouncementPresentationModel>((ref, announceModel) async {
  final model = AnnouncementPresentationModel.toCreateAnnouncementsRequestEntity(announceModel);
  final response = await ref.watch(createAnnouncementsUseCaseProvider).call(model); 
  if(response.title == model.title && response.description == model.description && response.body == model.body) return true;
  return false;
});

final updateAnnouncementProvider = FutureProvider.family<bool, AnnouncementPresentationModel>((ref,announceModel) async{
  final model = AnnouncementPresentationModel.toUpdateAnnouncementsRequestEntity(announceModel);
  final response = await ref.watch(updateAnnouncementsUseCaseProvider).call(model.id, model);
  if(response.title == model.title && response.description == model.description && response.body == model.body) return true;
  return false;
});