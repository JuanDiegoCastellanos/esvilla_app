import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/sectors/update_sector_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateSectorProvider = FutureProvider.family<bool,SectorModelPresentation>((ref,sectorModel) async {
  final requestModel = SectorModelPresentation.toUpdateSectorRequestEntity(sectorModel);
  final response = await ref.watch(updateSectoruseCaseProvider).call(requestModel.id, requestModel);
  if(response.id == sectorModel.id && response.name == sectorModel.name){
    return true;
  }
  return false;
});