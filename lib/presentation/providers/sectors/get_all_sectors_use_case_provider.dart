import 'package:esvilla_app/domain/use_cases/sectors/get_all_sectors_use_case.dart';
import 'package:esvilla_app/presentation/providers/sectors/sectors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllSectorsUseCaseProvider = Provider<GetAllSectorsUseCase>((ref) {
  final repository = ref.watch(sectorRepositoryProvider);
  return GetAllSectorsUseCase(repository);
});
