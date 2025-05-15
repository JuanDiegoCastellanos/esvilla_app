import 'package:esvilla_app/domain/use_cases/user/get_all_users_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/all_users_controller.dart';
import 'package:esvilla_app/presentation/providers/user/get_all_users_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allUsersControllerProvider = StateNotifierProvider<AllUsersController, List<UserPresentationModel>>((ref) {
  final GetAllUsersUseCase getAllUsersUseCase = ref.watch(getAllUsersUseCaseProvider);
  return AllUsersController(getAllUsersUseCase, ref);
});

//TODO: Reset password