import 'package:esvilla_app/domain/use_cases/schedules/get_all_schedules_use_case.dart';
import 'package:esvilla_app/domain/use_cases/sectors/get_sector_by_id_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/delete_schedule_by_id_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/get_all_schedules_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/get_sectors_by_id_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/schedules/update_schedule_use_case_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleScreenListNotifier
    extends StateNotifier<AsyncValue<List<ScheduleModelPresentation>>> {
  final GetAllSchedulesUseCase _getAllScheduleUseCase;
  final GetSectorByIdUseCase _getSectorsById;
  ScheduleScreenListNotifier(this._getAllScheduleUseCase, this._getSectorsById)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final schedules = await _getAllScheduleUseCase.call();
      final list = await Future.wait(
        schedules.map(
          (s) async {
            final sectors = await Future.wait(s.associatedSectors
                .map((id) => _getSectorsById.call(id).then((e) => e.name)));

            return ScheduleModelPresentation(
              id: s.id,
              active: s.active,
              createdAt: s.createdAt,
              days: s.days,
              startTime: s.startTime,
              endTime: s.endTime,
              garbageType: s.garbageType,
              observations: s.observations,
              updatedAt: s.updatedAt,
              associatedSectors: sectors,
            );
          },
        ),
      );

      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> filterByDate(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final schedules = await _getAllScheduleUseCase.call();
      final filtered = schedules.where((s) =>
          s.createdAt.year == date.year &&
          s.createdAt.month == date.month &&
          s.createdAt.day == date.day);

      final list = await Future.wait(filtered.map((s) async {
        final sectors = await Future.wait(s.associatedSectors
            .map((id) => _getSectorsById.call(id).then((e) => e.name)));

        return ScheduleModelPresentation(
          id: s.id,
          active: s.active,
          createdAt: s.createdAt,
          days: s.days,
          startTime: s.startTime,
          endTime: s.endTime,
          garbageType: s.garbageType,
          observations: s.observations,
          updatedAt: s.updatedAt,
          associatedSectors: sectors,
        );
      }));

      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final listScheduleNotifierProvider = StateNotifierProvider<
    ScheduleScreenListNotifier, AsyncValue<List<ScheduleModelPresentation>>>(
  (ref) => ScheduleScreenListNotifier(
    ref.read(getAllSchedulesUseCaseProvider),
    ref.read(getSectorByIdUseCaseProvider),
  ),
);

final schedulesSearchTextProvider = StateProvider<String>((_) => '');
final schedulesDateFilterProvider = StateProvider<String>((_) => '');

final deleteScheduleProvider =
    FutureProvider.family<bool, ScheduleModelPresentation>(
        (ref, scheduleModel) async {
  final response = await ref
      .watch(deleteScheduleByIdUseCaseProvider)
      .call(scheduleModel.id!);
  if (response.id == scheduleModel.id &&
      response.active == scheduleModel.active &&
      response.observations == scheduleModel.observations) return true;
  return false;
});

final selectedDaysProvider =
    StateProvider.family<List<String>, List<String>>((_, days) {
  return days;
});

const List<String> weekDays = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];

final trashTypeControllerProvider = Provider.autoDispose
    .family<TextEditingController, ScheduleModelPresentation>((ref, schedule) {
  final ctrl = TextEditingController(text: schedule.garbageType);
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

final observationsTypeControllerProvider = Provider.autoDispose
    .family<TextEditingController, ScheduleModelPresentation>((ref, schedule) {
  final ctrl = TextEditingController(text: schedule.observations);
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

final startTimeControllerProvider = Provider.autoDispose
    .family<TextEditingController, ScheduleModelPresentation>((ref, schedule) {
  final ctrl = TextEditingController(text: schedule.startTime);
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

final endTimeControllerProvider = Provider.autoDispose
    .family<TextEditingController, ScheduleModelPresentation>((ref, schedule) {
  final ctrl = TextEditingController(text: schedule.endTime);
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

final searchSectorControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final ctrl = TextEditingController();
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

final stateScheduleProvider =
    StateProvider.family<bool, ScheduleModelPresentation>(
        (_, schedule) => schedule.active ?? false);

final selectedSectorsListProvider =
    StateProvider.family<List<String>, ScheduleModelPresentation>(
        (ref, schedule) => List.from(schedule.associatedSectors ?? []));

final searchSectorProvider = StateProvider<String>((_) => '');

final updateScheduleProvider =
    FutureProvider.family<bool, ScheduleModelPresentation>((ref, scheduleModel) async {
  final model = ScheduleModelPresentation.toUpdateEntity(scheduleModel);
  final response = await ref.watch(updateScheduleUseCaseProvider).call(model.id, model);
  if (response.id == scheduleModel.id &&
      response.active == scheduleModel.active &&
      response.observations == scheduleModel.observations) return true;
  return false;
});

