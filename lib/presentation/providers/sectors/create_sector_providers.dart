import 'package:esvilla_app/presentation/providers/sectors/create_sector_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/sectors/sector_model_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final descriptionControllerCreateProvider = Provider.autoDispose<TextEditingController>((ref) {
  final ctrl = TextEditingController();
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

final nameControllerCreateProvider = Provider.autoDispose<TextEditingController>((ref) {
  final ctrl = TextEditingController();
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

final createSectorProvider = FutureProvider.family<bool, SectorModelPresentation>((ref, sector) async {
  final model = SectorModelPresentation.toCreateSectorRequestEntity(sector);
  final response = await ref.watch(createSectorUseCaseProvider).call(model);
  return response.id.isNotEmpty;
}); 