
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/use_cases/get_my_profile_use_case.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_state.dart';
import 'package:esvilla_app/presentation/providers/user/user_data_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/user/get_my_user_profile_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController extends StateNotifier<UserState> {
  final GetMyProfileUseCase _getMyProfileUseCase;
  final UserDataStateNotifier _userDataStateNotifier;
  final Ref _ref;

  UserController(
    this._getMyProfileUseCase,
    this._userDataStateNotifier,
    this._ref
    ):super(const UserState.empty());

  Future<void> getMyProfileInfo() async {
      state = const UserState.empty().copyWith(
        isLoading: true
      );
    try {
      final token = await _ref.read(authTokenProvider.notifier).getAccessToken();
      if (token == null || token.isEmpty) {
        throw AppException(code: -1, message: 'Token not found');
      }
      // si hay algo almacenado, usarlo
      
      final response = await _getMyProfileUseCase(token);
      AppLogger.i("GetUserProfileInfo response: ${response.toString()}");
      state = state.copyWith(
        name: response.name,
        email: response.email,
        documentNumber: response.documentNumber,
        phone: response.phone,
        mainAddress: response.mainAddress,
        role: response.role,
        isLoading: false
      );
      _userDataStateNotifier.saveTokens(
        userName: response.name,
        email: response.email,
        documentNumber: response.documentNumber,
        phone: response.phone,
        mainAddress: response.mainAddress,
        role: response.role
      );

      } on AppException catch (e) {
      AppLogger.e("GetUserProfileInfo failed: ${e.message}");
    } finally {
      state = state.copyWith(isLoading: false);
    }

  }

}
final userControllerProvider = StateNotifierProvider<UserController, UserState>(
  (ref) {
    final getMyProfileUseCaseProvider = ref.watch(getMyProfileInfoUseCaseProvider);
    final userDataStateNotifier = ref.watch(userDataProvider.notifier);
    return UserController(getMyProfileUseCaseProvider, userDataStateNotifier, ref);
  },
);