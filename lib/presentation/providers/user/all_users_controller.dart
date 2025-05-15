import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/use_cases/user/get_all_users_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/create_user_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/delete_user_by_id_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/update_user_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllUsersController extends StateNotifier<List<UserPresentationModel>> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final Ref _ref;

  AllUsersController(this._getAllUsersUseCase, this._ref) : super([]){
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final listUserEntities = await _getAllUsersUseCase();
      final currentUser = _ref.read(userControllerProvider).value;
      //remove the current user
      final filteredUsers = listUserEntities.where((user) => 
      user.id != currentUser!.id &&
      user.email != currentUser.email
      ).toList();

      state = filteredUsers.map(UserPresentationModel.fromEntity).toList();
    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
  }

  // Método para eliminar un usuario por su ID
  Future<void> removeUser(String userId) async {
    try {

      await _ref.read(deleteUserByIdUseCaseProvider).call(userId);
      await loadUsers();
    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
  }

  // Método para actualizar un usuario existente
  Future<void> updateUser(UserPresentationModel updatedUser) async {
    try {
      await _ref.read(updateUserUseCaseProvider).call(updatedUser.id!, UserPresentationModel.toUpdateUserRequestEntity(updatedUser));
    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
  }

  Future<bool> addUser(UserPresentationModel user) async {
    try {
      final userCreated  = await _ref.read(createUserUseCaseProvider).call(UserPresentationModel.toCreateUserRequestEntity(user));
      if (userCreated.id != '' || userCreated.name != '' || userCreated.email != '') {
        await loadUsers();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
  } 
}

