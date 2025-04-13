// user_controller_provider.dart
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/presentation/providers/user/get_my_user_profile_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/update_password_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/update_user_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateUserControllerProvider = StateNotifierProvider<UpdateUserController, AsyncValue<UserPresentationModel>>((ref) {
  return UpdateUserController(ref);
});


class UpdateUserController extends StateNotifier<AsyncValue<UserPresentationModel>> {
  final Ref _ref;
  UpdateUserController(this._ref) : super(const AsyncValue.loading()) {
    getMyProfileInfo(); // Iniciar carga al crear el notifier
  }

  Future<void> getMyProfileInfo() async {
    state = const AsyncValue.loading();
    try {
      final userEntity = await _ref.read(getMyProfileInfoUseCaseProvider).call();
      final userModel = UserPresentationModel.fromEntity(userEntity);
      state = AsyncValue.data(userModel);
    } catch (e, s) {
      AppLogger.e("Error fetching profile");
      state = AsyncValue.error(e, s);
    }
  }

  Future<bool> updateUserProfile(UserPresentationModel updatedData) async {
    // No actualices el estado a loading aquí para no recargar toda la UI,
    // podrías tener un estado secundario para indicar 'updating' si es necesario.
    try {
      // Asegúrate de que el provider 'updateUserProvider' no devuelva un Future directamente,
      // sino que se ejecute y quizás actualice el estado aquí o recargue el perfil.
      // O si devuelve el usuario actualizado:
      final updatedUserPresentation = await _ref.read(updateUserProvider(updatedData).future);
      state = AsyncValue.data(updatedUserPresentation);
      _ref.read(userControllerProvider.notifier).getMyProfileInfo();
      return true; // Indicar éxito
    } catch (e) {
      AppLogger.e("Error updating profile");
      // Podrías querer reflejar el error en 'state' o manejarlo de otra forma
      return false; // Indicar fallo
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword, String confirmNewPassword) async {
    // ... Lógica para llamar al backend para cambiar la contraseña ...
    // Similar al updateUserProfile, maneja éxito/error
    try {
      final UpdatePasswordRequestEntity updatePasswordRequestEntity = UpdatePasswordRequestEntity(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      // Llama a tu caso de uso/repositorio para cambiar la contraseña
      final userWithPasswordUpdated = await _ref.read(updatePasswordUseCaseProvider).call(updatePasswordRequestEntity);
      state = AsyncValue.data(UserPresentationModel.fromEntity(userWithPasswordUpdated));
      AppLogger.i("Password changed successfully (simulated)");
      // Quizás recargar el perfil si es necesario o simplemente indicar éxito
      _ref.read(userControllerProvider.notifier).getMyProfileInfo();
      return true;
    } catch (e) {
      AppLogger.e("Error changing password",);
      return false;
    }
  }
}