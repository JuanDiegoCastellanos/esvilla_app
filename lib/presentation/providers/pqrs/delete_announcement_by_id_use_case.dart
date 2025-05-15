import 'package:esvilla_app/domain/use_cases/pqrs/delete_pqrs_use_case.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deletePqrsUseCaseProvider = Provider<DeletePqrsUseCase>((ref) {
  final repository = ref.watch(pqrsRepositoryProvider);
  return DeletePqrsUseCase(repository);
});

