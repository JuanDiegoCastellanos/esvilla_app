
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/use_cases/get_my_profile_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_state.dart';
import 'package:esvilla_app/presentation/providers/user/user_data_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/user/get_my_user_profile_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController extends StateNotifier<AsyncValue<UserState>> {
  final GetMyProfileUseCase _getMyProfileUseCase;
  final UserDataStateNotifier _userDataStateNotifier;

  UserController(
    this._getMyProfileUseCase,
    this._userDataStateNotifier,
    ):super(AsyncValue.loading());

  Future<void> getMyProfileInfo() async {
    state = const AsyncValue.loading();
    try {
     // si hay algo almacenado, usarlo
      await _userDataStateNotifier.loadTokens();
      final user = _userDataStateNotifier.state;
      if (user.name != null && user.email != null && user.documentNumber != null && user.phone != null && user.mainAddress != null && user.role != null) {
        state = AsyncValue.data(user);
        return;
      }
      final response = await _getMyProfileUseCase();
      AppLogger.i("GetUserProfileInfo response: ${response.toString()}");
      state = AsyncValue.data(
        UserState(
          name: response.name,
          email: response.email,
          documentNumber: response.documentNumber,
          phone: response.phone,
          mainAddress: response.mainAddress,
          role: response.role
        )
      );
      _userDataStateNotifier.saveTokens(
        userName: response.name,
        email: response.email,
        documentNumber: response.documentNumber,
        phone: response.phone,
        mainAddress: response.mainAddress,
        role: response.role
      );

      } on AppException catch (e, t) {
      AppLogger.e("GetUserProfileInfo failed: ${e.message}  - $t");
      state = AsyncValue.error(e, t);
    } finally {
      if (state is AsyncLoading<UserState>) {
        state = const AsyncValue.data(UserState.empty());
      }
    }
  }

}
final userControllerProvider = StateNotifierProvider<UserController, AsyncValue<UserState>>(
  (ref) {
    final getMyProfileUseCaseProvider = ref.watch(getMyProfileInfoUseCaseProvider);
    final userDataStateNotifier = ref.watch(userDataProvider.notifier);
    return UserController(getMyProfileUseCaseProvider, userDataStateNotifier);
  },
);