import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/get_my_pqrs_use_case.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMyPqrsProvider = FutureProvider.autoDispose<PqrsEntity?>((ref) async {
  final repository = ref.watch(pqrsRepositoryProvider);
  try {
    // Intenta obtener la PQRS del usuario actual
    final myPqrs = await GetMyPqrsUseCase(repository).call();
    return myPqrs;
  } catch (e) {
    // Si hay un error, significa que no hay PQRS o hay un problema
    return null;
  }
});

final getMyPqrsStateProvider = StateNotifierProvider<GetMyPqrsController, AsyncValue<PqrsEntity?>>((ref) {
  final repository = ref.watch(pqrsRepositoryProvider);
  final useCase = GetMyPqrsUseCase(repository);
  return GetMyPqrsController(useCase);
});

class GetMyPqrsController extends StateNotifier<AsyncValue<PqrsEntity?>> {
  final GetMyPqrsUseCase useCase;
  GetMyPqrsController(this.useCase) : super(const AsyncValue.loading()) {
    loadPqrsData();
  }
  Future<void> loadPqrsData() async {
    state = const AsyncValue.loading();
    try {
      final pqrs = await useCase.call();
      state = AsyncValue.data(pqrs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> reload() async {
    await loadPqrsData();
  }
}
