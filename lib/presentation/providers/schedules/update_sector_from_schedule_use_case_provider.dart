import 'package:esvilla_app/domain/use_cases/schedules/update_sectors_of_schedule_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedules_reposiroty_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateSectorFromScheduleUseCaseProvider = Provider<UpdateSectorsOfScheduleUseCase>((ref) {
  final repo = ref.watch(schedulesRepositoryProvider);
  return UpdateSectorsOfScheduleUseCase(repo);
});