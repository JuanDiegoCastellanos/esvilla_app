// lib/presentation/providers/schedules/update_schedule_use_case_provider.dart
import 'package:esvilla_app/domain/use_cases/schedules/update_schedule_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedules_reposiroty_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateScheduleUseCaseProvider = Provider<UpdateScheduleUseCase>((ref) {
  final repository = ref.watch(schedulesRepositoryProvider);
  return UpdateScheduleUseCase(repository);
});

