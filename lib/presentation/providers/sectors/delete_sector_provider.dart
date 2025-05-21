import 'package:esvilla_app/presentation/providers/sectors/delete_sector_by_id_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteSectorProvider =
    FutureProvider.family<bool, SectorModelPresentation>(
        (ref, sectorModel) async {
  final response =
      await ref.watch(deleteSectorByIdUseCaseProvider).call(sectorModel.id!);
  if (response.id == sectorModel.id && response.name == sectorModel.name) {
    return true;
  }
  return false;
});