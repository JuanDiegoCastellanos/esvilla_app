import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/use_cases/user/get_all_users_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/get_user_by_id_provider.dart';
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
      AppLogger.i('listUserEntities------>: $listUserEntities');
      state = listUserEntities.map(UserPresentationModel.fromEntity).toList();
    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
  }

  // Método para eliminar un usuario por su ID
  Future<void> removeUser(String userId) async {
    try {
      // primero encuentro el usuario que va ser eliminado
      final UserPresentationModel loadedUser = await _ref
          .read(getUserByIdProvider(userId))
          .when(
              data: (user) => user,
              error: (error, stackTrace) => UserPresentationModel.empty()
                  .copyWith(error: error.toString()),
              loading: () => UserPresentationModel.empty().copyWith(isLoading: true));

      if (loadedUser.id!.isEmpty) {
        throw AppException(message: 'User not found');
      }
      // valido que no sea el mio
      // TODO: implementar

      // finalmente lo elimino
      //_ref.read(deleteUserByIduseCase)

    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
    state = state.where((user) => user.id != userId).toList();
  }

  // Método para actualizar un usuario existente
  void updateUser(UserPresentationModel updatedUser) {
    // TODO: implementar
  }
}

