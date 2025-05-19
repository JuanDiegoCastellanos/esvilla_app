import 'package:esvilla_app/domain/use_cases/sectors/get_all_sectors_use_case.dart';
import 'package:esvilla_app/presentation/providers/sectors/get_all_sectors_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectorScreenListNotifier
    extends StateNotifier<AsyncValue<List<SectorModelPresentation>>> {
  final GetAllSectorsUseCase _getAllSectorUseCase;
  SectorScreenListNotifier(this._getAllSectorUseCase)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final sectors = await _getAllSectorUseCase.call();
      state = AsyncValue.data(SectorModelPresentation.fromEntityList(sectors));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> filterByDate(DateTime date) async {
    state = const AsyncValue.loading();
    try {
      final sectors = await _getAllSectorUseCase.call();
      final list = sectors
          .where((sector) =>
              sector.createdAt!.year == date.year &&
              sector.createdAt!.month == date.month &&
              sector.createdAt!.day == date.day)
          .map((sector) => SectorModelPresentation.fromEntity(sector))
          .toList();

      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final listSectorNotifierProvider = StateNotifierProvider<
    SectorScreenListNotifier, AsyncValue<List<SectorModelPresentation>>>(
  (ref) => SectorScreenListNotifier(
    ref.read(getAllSectorsUseCaseProvider),
  ),
);


final sectorSearchTextProvider = StateProvider<String>((ref) {
  return '';
});

final sectorDateFilterProvider = StateProvider<String>((ref) {
  return '';
});