
import 'package:esvilla_app/domain/use_cases/schedules/get_all_schedules_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedules_reposiroty_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllSchedulesUseCaseProvider = Provider<GetAllSchedulesUseCase>((ref) {
  final repo = ref.watch(schedulesRepositoryProvider);
  return GetAllSchedulesUseCase(repo);
});