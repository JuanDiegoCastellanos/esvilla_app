import 'package:esvilla_app/presentation/providers/schedules/create_schedule_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final observationsCreateControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
final trashTypeCreateControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
final startTimeCreateControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
final endTimeCreateControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

final searchSectorCreateControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final ctrl = TextEditingController();
  ref.onDispose(ctrl.dispose);
  return ctrl;
});


final stateScheduleCreateProvider = StateProvider.autoDispose<bool>((ref) => true);
final selectedDaysCreateProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final selectedSectorsListCreateProvider = StateProvider.autoDispose<List<String>>((ref) => []);
final schedulesSearchTextCreateProvider = StateProvider.autoDispose<String>((ref) => '');
final schedulesDateFilterCreateProvider = StateProvider.autoDispose<String>((ref) => '');
final searchSectorCreateProvider = StateProvider.autoDispose<String>((ref) => '');


final createScheduleProvider = FutureProvider.family<bool, ScheduleModelPresentation>((ref, scheduleModel) async {
  final model = ScheduleModelPresentation.toCreateEntity(scheduleModel);
  final response = await ref.watch(createScheduleUseCaseProvider).call(model);
  return response.id.isNotEmpty;
});