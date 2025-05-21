import 'package:esvilla_app/domain/use_cases/sectors/update_sector_use_case.dart';
import 'package:esvilla_app/presentation/providers/sectors/sectors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateSectoruseCaseProvider = Provider<UpdateSectorUseCase>((ref) {
  final repo = ref.watch(sectorRepositoryProvider);
  return UpdateSectorUseCase(repo);
});