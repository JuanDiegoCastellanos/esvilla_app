import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/datasources/users/users_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/users/user_mapper.dart';
import 'package:esvilla_app/data/models/users/create_user_request.dart';
import 'package:esvilla_app/data/models/users/update_password_request.dart';
import 'package:esvilla_app/data/models/users/user_model.dart';
import 'package:esvilla_app/data/models/users/user_update_request.dart';
import 'package:esvilla_app/data/repositories/users/user_repository_impl.dart';
import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRemoteDataSource extends Mock implements UsersRemoteDataSource {}

void main() {
  late UserRemoteRepositoryImpl repository;
  late MockUsersRemoteDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(CreateUserRequest(
      name: '',
      documentNumber: '',
      email: '',
      phone: '',
      password: '',
      mainAddress: '',
      role: '',
    ));
    registerFallbackValue(UpdateUserRequest(
      id: '',
    ));
    registerFallbackValue(UpdatePasswordRequest(
      oldPassword: '',
      newPassword: '',
      confirmNewPassword: '',
    ));
  });

  setUp(() {
    mockDataSource = MockUsersRemoteDataSource();
    repository = UserRemoteRepositoryImpl(mockDataSource);
  });

  group('UserRemoteRepositoryImpl', () {
    group('add', () {
      test('debería crear un usuario exitosamente', () async {
        // Arrange
        final requestEntity = CreateUserRequestEntity(
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        final requestModel = CreateUserRequest(
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        final responseModel = UserModel(
          id: '1',
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.createUser(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.add(requestEntity);

        // Assert
        expect(result.id, equals('1'));
        expect(result.name, equals('Juan Pérez'));
        expect(result.email, equals('juan@example.com'));
        verify(() => mockDataSource.createUser(any())).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        final requestEntity = CreateUserRequestEntity(
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.createUser(any()))
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(() => repository.add(requestEntity), throwsException);
        verify(() => mockDataSource.createUser(any())).called(1);
      });
    });

    group('getAll', () {
      test('debería obtener todos los usuarios exitosamente', () async {
        // Arrange
        final usersModel = [
          UserModel(
            id: '1',
            name: 'Juan Pérez',
            documentNumber: '12345678',
            email: 'juan@example.com',
            phone: '3001234567',
            password: 'password123',
            mainAddress: 'Calle 123 #45-67',
            role: 'user',
          ),
          UserModel(
            id: '2',
            name: 'María García',
            documentNumber: '87654321',
            email: 'maria@example.com',
            phone: '3007654321',
            password: 'password456',
            mainAddress: 'Calle 456 #78-90',
            role: 'admin',
          ),
        ];

        when(() => mockDataSource.getAllUsers())
            .thenAnswer((_) async => usersModel);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result.length, equals(2));
        expect(result[0].id, equals('1'));
        expect(result[1].id, equals('2'));
        verify(() => mockDataSource.getAllUsers()).called(1);
      });

      test('debería retornar lista vacía cuando no hay usuarios', () async {
        // Arrange
        when(() => mockDataSource.getAllUsers())
            .thenAnswer((_) async => <UserModel>[]);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, isEmpty);
        verify(() => mockDataSource.getAllUsers()).called(1);
      });
    });

    group('getById', () {
      test('debería obtener un usuario por ID exitosamente', () async {
        // Arrange
        const userId = '1';
        final userModel = UserModel(
          id: userId,
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.getUserById(userId))
            .thenAnswer((_) async => userModel);

        // Act
        final result = await repository.getById(userId);

        // Assert
        expect(result.id, equals(userId));
        expect(result.name, equals('Juan Pérez'));
        verify(() => mockDataSource.getUserById(userId)).called(1);
      });

      test('debería lanzar excepción cuando el ID está vacío', () async {
        // Arrange
        const emptyId = '';

        // Act & Assert
        expect(() => repository.getById(emptyId), throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.getUserById(any()));
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const userId = '999';

        when(() => mockDataSource.getUserById(userId))
            .thenThrow(Exception('Usuario no encontrado'));

        // Act & Assert
        expect(() => repository.getById(userId), throwsA(isA<AppException>()));
        verify(() => mockDataSource.getUserById(userId)).called(1);
      });
    });

    group('delete', () {
      test('debería eliminar un usuario exitosamente', () async {
        // Arrange
        const userId = '1';
        final userModel = UserModel(
          id: userId,
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.deleteUser(userId))
            .thenAnswer((_) async => userModel);

        // Act
        final result = await repository.delete(userId);

        // Assert
        expect(result.id, equals(userId));
        verify(() => mockDataSource.deleteUser(userId)).called(1);
      });

      test('debería lanzar excepción cuando el ID está vacío', () async {
        // Arrange
        const emptyId = '';

        // Act & Assert
        expect(() => repository.delete(emptyId), throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.deleteUser(any()));
      });
    });

    group('myProfile', () {
      test('debería obtener mi perfil exitosamente', () async {
        // Arrange
        final userModel = UserModel(
          id: '1',
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.myProfile())
            .thenAnswer((_) async => userModel);

        // Act
        final result = await repository.myProfile();

        // Assert
        expect(result.id, equals('1'));
        expect(result.name, equals('Juan Pérez'));
        verify(() => mockDataSource.myProfile()).called(1);
      });
    });

    group('update', () {
      test('debería actualizar un usuario exitosamente', () async {
        // Arrange
        const userId = '1';
        final requestEntity = UpdateUserRequestEntity(
          id: userId,
          name: 'Juan Carlos Pérez',
          email: 'juancarlos@example.com',
        );

        final requestModel = UpdateUserRequest(
          id: userId,
          name: 'Juan Carlos Pérez',
          email: 'juancarlos@example.com',
        );

        final responseModel = UserModel(
          id: userId,
          name: 'Juan Carlos Pérez',
          documentNumber: '12345678',
          email: 'juancarlos@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.updateUser(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.update(userId, requestEntity);

        // Assert
        expect(result.id, equals(userId));
        expect(result.name, equals('Juan Carlos Pérez'));
        verify(() => mockDataSource.updateUser(any())).called(1);
      });

      test('debería lanzar excepción cuando el ID está vacío', () async {
        // Arrange
        const emptyId = '';
        final requestEntity = UpdateUserRequestEntity(
          id: emptyId,
          name: 'Juan Carlos Pérez',
        );

        // Act & Assert
        expect(() => repository.update(emptyId, requestEntity),
            throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.updateUser(any()));
      });

      test('debería lanzar excepción cuando el ID no coincide', () async {
        // Arrange
        const userId = '1';
        const differentId = '2';
        final requestEntity = UpdateUserRequestEntity(
          id: differentId,
          name: 'Juan Carlos Pérez',
        );

        // Act & Assert
        expect(() => repository.update(userId, requestEntity),
            throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.updateUser(any()));
      });
    });

    group('updateMyInfo', () {
      test('debería actualizar mi información exitosamente', () async {
        // Arrange
        final requestEntity = UpdateUserRequestEntity(
          id: '1',
          name: 'Juan Carlos Pérez',
          email: 'juancarlos@example.com',
        );

        final requestModel = UpdateUserRequest(
          id: '1',
          name: 'Juan Carlos Pérez',
          email: 'juancarlos@example.com',
        );

        final responseModel = UserModel(
          id: '1',
          name: 'Juan Carlos Pérez',
          documentNumber: '12345678',
          email: 'juancarlos@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.updateMyInfo(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.updateMyInfo(requestEntity);

        // Assert
        expect(result.id, equals('1'));
        expect(result.name, equals('Juan Carlos Pérez'));
        verify(() => mockDataSource.updateMyInfo(any())).called(1);
      });

      test('debería lanzar excepción cuando el ID está vacío', () async {
        // Arrange
        final requestEntity = UpdateUserRequestEntity(
          id: '',
          name: 'Juan Carlos Pérez',
        );

        // Act & Assert
        expect(() => repository.updateMyInfo(requestEntity),
            throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.updateMyInfo(any()));
      });
    });

    group('updateMyPassword', () {
      test('debería actualizar mi contraseña exitosamente', () async {
        // Arrange
        final requestEntity = UpdatePasswordRequestEntity(
          oldPassword: 'oldPassword123',
          newPassword: 'newPassword456',
          confirmNewPassword: 'newPassword456',
        );

        final requestModel = UpdatePasswordRequest(
          oldPassword: 'oldPassword123',
          newPassword: 'newPassword456',
          confirmNewPassword: 'newPassword456',
        );

        final responseModel = UserModel(
          id: '1',
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'newPassword456',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        );

        when(() => mockDataSource.updateMyPassword(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.updateMyPassword(requestEntity);

        // Assert
        expect(result.id, equals('1'));
        expect(result.password, equals('newPassword456'));
        verify(() => mockDataSource.updateMyPassword(any())).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        final requestEntity = UpdatePasswordRequestEntity(
          oldPassword: 'wrongPassword',
          newPassword: 'newPassword456',
          confirmNewPassword: 'newPassword456',
        );

        when(() => mockDataSource.updateMyPassword(any()))
            .thenThrow(Exception('Contraseña actual incorrecta'));

        // Act & Assert
        expect(() => repository.updateMyPassword(requestEntity),
            throwsA(isA<AppException>()));
        verify(() => mockDataSource.updateMyPassword(any())).called(1);
      });
    });
  });
}
