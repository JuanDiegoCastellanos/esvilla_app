import 'package:esvilla_app/domain/use_cases/schedules/delete_schedule_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedules_reposiroty_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteScheduleByIdUseCaseProvider = Provider<DeleteScheduleUseCase>((ref) {
  final repository = ref.watch(schedulesRepositoryProvider);
  return DeleteScheduleUseCase(repository);
});
