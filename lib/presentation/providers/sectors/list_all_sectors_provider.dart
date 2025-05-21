import 'package:esvilla_app/domain/use_cases/sectors/get_all_sectors_use_case.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/sectors/sectors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final listAllSectorsProvider = FutureProvider.autoDispose<List<SectorModelPresentation>>((ref) async {
  final repository = ref.watch(sectorRepositoryProvider);
  final useCase = GetAllSectorsUseCase(repository);
  final sectors = await useCase.call();
  return SectorModelPresentation.fromEntityList(sectors);
});