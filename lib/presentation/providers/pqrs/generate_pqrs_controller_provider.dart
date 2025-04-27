import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/generate_pqrs_use_case.dart';
import 'package:esvilla_app/presentation/providers/pqrs/generate_pqrs_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/pqrs/get_my_pqrs_provider.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneratePqrsControllerProvider extends StateNotifier<AsyncValue<PqrsModelPresentation>>{
  final GeneratePqrsUseCase useCase;
  final Ref _ref;
  
  GeneratePqrsControllerProvider(this.useCase, this._ref) : super(const AsyncValue.loading());

  Future<bool> generatePqrs(PqrsModelPresentation newPrs) async {
    state = const AsyncValue.loading();
    try{
      final createPqrsRequest = CreatePqrsRequestEntity(
        subject: newPrs.subject!,
        description: newPrs.description!,
        status: "PENDIENTE"
      );

      final pqrs = await useCase.call(createPqrsRequest);
      state = AsyncValue.data(PqrsModelPresentation.fromEntity(pqrs));
      _ref.invalidate(getMyPqrsProvider);
      return true;
    }on AppException catch(e){
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

}

// provider 
final generatePqrsControllerProvider = StateNotifierProvider<GeneratePqrsControllerProvider, AsyncValue<PqrsModelPresentation>>((ref) {
  final useCase = ref.watch(generatePqrsProvider);
  return GeneratePqrsControllerProvider(useCase, ref);
});