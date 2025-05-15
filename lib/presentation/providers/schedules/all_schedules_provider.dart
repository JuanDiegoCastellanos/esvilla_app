import 'package:esvilla_app/domain/use_cases/schedules/get_all_schedules_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/delete_schedule_by_id_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/get_all_schedules_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleListNotifier extends StateNotifier<AsyncValue<List<ScheduleModelPresentation>>> {
  final GetAllSchedulesUseCase _getAllScheduleUseCase;
  ScheduleListNotifier(this._getAllScheduleUseCase) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final entities = await _getAllScheduleUseCase.call();
      final list = ScheduleModelPresentation.fromEntityList(entities);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> filterByDate(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final entities = await _getAllScheduleUseCase.call();
      final list = entities
          .where((element) => element.createdAt.year == date.year &&
              element.createdAt.month == date.month &&
              element.createdAt.day == date.day)
          .map((e) => ScheduleModelPresentation.fromEntity(e))
          .toList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final listScheduleNotifierProvider =
    StateNotifierProvider<ScheduleListNotifier, AsyncValue<List<ScheduleModelPresentation>>>(
  (ref) => ScheduleListNotifier(ref.watch(getAllSchedulesUseCaseProvider)),
);

final schedulesSearchTextProvider = StateProvider<String>((_) => '');
final schedulesDateFilterProvider = StateProvider<String>((_) => '');

final deleteScheduleProvider = FutureProvider.family<bool, ScheduleModelPresentation>((ref, scheduleModel) async {
  final response = await ref.watch(deleteScheduleByIdUseCaseProvider).call(scheduleModel.id!);
  if(response.id == scheduleModel.id && response.active == scheduleModel.active && response.observations == scheduleModel.observations) return true;
  return false;
});