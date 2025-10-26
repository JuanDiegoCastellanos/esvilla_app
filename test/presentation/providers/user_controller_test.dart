import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/use_cases/get_my_profile_use_case.dart';
import 'package:esvilla_app/presentation/providers/user/user_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_data_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/user/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetMyProfile extends Mock implements GetMyProfileUseCase {}
class _FakeUserDataNotifier extends Fake implements UserDataStateNotifier {
  UserState _state = const UserState();
  
  @override
  UserState get state => _state;
  
  @override
  Future<void> loadTokens() async {
    _state = const UserState(); // Reset to empty state
  }
  
  @override
  Future<void> clearTokens() async {}
  
  @override
  Future<void> saveTokens({
    required String userName,
    required String email,
    required String documentNumber,
    required String phone,
    required String mainAddress,
    required String role,
  }) async {
    _state = UserState(
      name: userName,
      email: email,
      documentNumber: documentNumber,
      phone: phone,
      mainAddress: mainAddress,
      role: role,
    );
  }
}

void main() {
  test('getMyProfileInfo retorna datos y persiste en UserDataStateNotifier', () async {
    final getMy = _MockGetMyProfile();
    when(() => getMy()).thenAnswer((_) async => UserEntity(
      id: 'u1', name: 'Juan', email: 'a@b.com', documentNumber: '123', phone: '300', mainAddress: 'addr', role: 'user', password: ''
    ));

    final container = ProviderContainer(overrides: []);
    final fakeNotifier = _FakeUserDataNotifier();
    final controller = UserController(getMy, fakeNotifier);
    expect(controller.debugState, const AsyncLoading<UserState>());
    await controller.getMyProfileInfo();
    expect(controller.debugState.hasError, false);
    final data = controller.debugState.requireValue;
    expect(data.name, 'Juan');
    expect(data.email, 'a@b.com');
  });
}


