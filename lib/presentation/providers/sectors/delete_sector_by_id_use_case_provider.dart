import 'package:esvilla_app/domain/use_cases/sectors/delete_sector_use_case.dart';
import 'package:esvilla_app/presentation/providers/sectors/sectors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteSectorByIdUseCaseProvider = Provider<DeleteSectorUseCase>((ref) {
  final repo = ref.watch(sectorRepositoryProvider);
  return DeleteSectorUseCase(repo);
});