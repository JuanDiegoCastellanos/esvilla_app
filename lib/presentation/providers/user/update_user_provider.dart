import 'package:esvilla_app/presentation/providers/user/update_my_profile_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateUserProvider = FutureProvider.autoDispose.family<UserPresentationModel, UserPresentationModel>((ref, userPresentationModel) async {
  final useCase = ref.watch(updateMyProfileUseCaseProvider);
  final updateRequestDto = UserPresentationModel.toUpdateUserRequestEntity(userPresentationModel);
  final user = await useCase(updateRequestDto);
  return UserPresentationModel.fromEntity(user);
});
