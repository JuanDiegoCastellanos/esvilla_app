import 'package:esvilla_app/domain/use_cases/pqrs/generate_pqrs_use_case.dart';
import 'package:esvilla_app/presentation/providers/pqrs/pqrs_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final generatePqrsProvider = Provider<GeneratePqrsUseCase>((ref) {
  final repo = ref.watch(pqrsRepositoryProvider);
  return GeneratePqrsUseCase(repo);
});