import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/get_all_pqrs_use_case.dart';
import 'package:esvilla_app/presentation/providers/pqrs/delete_announcement_by_id_use_case.dart';
import 'package:esvilla_app/presentation/providers/pqrs/get_all_pqrs_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/pqrs/update_pqrs_use_case_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PqrsListNotifier extends StateNotifier<AsyncValue<List<PqrsModelPresentation>>> {
  final GetAllPqrsUseCase _getAllPqrsUseCase;
  PqrsListNotifier(this._getAllPqrsUseCase) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final entities = await _getAllPqrsUseCase.call();
      final list = PqrsModelPresentation.toPresentationModelList(entities);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> filterByDate(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final entities = await _getAllPqrsUseCase.call();
      final list = entities
          .where((element) => element.createdAt.year == date.year &&
              element.createdAt.month == date.month &&
              element.createdAt.day == date.day)
          .map((e) => PqrsModelPresentation.fromEntity(e))
          .toList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final listPqrsNotifierProvider =
    StateNotifierProvider<PqrsListNotifier, AsyncValue<List<PqrsModelPresentation>>>(
  (ref) => PqrsListNotifier(ref.watch(getAllPqrsUseCaseProvider)),
);

final pqrsSearchTextProvider = StateProvider<String>((_) => '');
final pqrsDateFilterProvider = StateProvider<String>((_) => '');

final updatePqrsProvider = FutureProvider.family<bool, PqrsModelPresentation>((ref, pqrsModel) async {
  final model = PqrsModelPresentation.toUpdateEntity(pqrsModel);
  final response = await ref.watch(updatePqrsUseCaseProvider).call(model.id, model);
  if(response.subject == model.subject && response.description == model.description) return true;
  return false;   
});

final statusProvider = StateProvider.family<PqrsStatusEnum,PqrsModelPresentation>(
  (_,pqrs) => pqrs.status??PqrsStatusEnum.pendiente,
);

final resolutionControllerProvider = Provider
  .autoDispose
  .family<TextEditingController, PqrsModelPresentation>((ref, pqrs) {
    final ctrl = TextEditingController(text: pqrs.resolution);
    ref.onDispose(ctrl.dispose);
    return ctrl;
  });

final deletePqrsProvider = FutureProvider.family<bool, PqrsModelPresentation>((ref, pqrsModel) async {
  final response = await ref.watch(deletePqrsUseCaseProvider).call(pqrsModel.id!);
  if(response.id == pqrsModel.id) return true;
  return false;
});
