import 'package:esvilla_app/domain/use_cases/sectors/get_sector_by_id_use_case.dart';
import 'package:esvilla_app/presentation/providers/sectors/sectors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSectorByIdUseCaseProvider = Provider<GetSectorByIdUseCase>((ref) {
  final repo = ref.watch(sectorRepositoryProvider);
  return GetSectorByIdUseCase(repo);
});
