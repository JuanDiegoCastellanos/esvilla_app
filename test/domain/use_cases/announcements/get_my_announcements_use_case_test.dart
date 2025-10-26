import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';
import 'package:esvilla_app/domain/use_cases/announcements/get_my_announcements_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnnouncementsRepository extends Mock implements AnnouncementsRepository {}

void main() {
  late GetMyAnnouncementsUseCase useCase;
  late MockAnnouncementsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnnouncementsRepository();
    useCase = GetMyAnnouncementsUseCase(mockRepository);
  });

  group('GetMyAnnouncementsUseCase', () {
    test('debería obtener mis anuncios exitosamente', () async {
      // Arrange
      final now = DateTime.now();
      final expectedAnnouncements = [
        AnnouncementsEntity(
          id: '1',
          title: 'Mi primer anuncio',
          description: 'Descripción de mi primer anuncio',
          mainImage: 'image1.jpg',
          body: 'Contenido completo del anuncio...',
          secondaryImage: 'image2.jpg',
          publicationDate: now,
          createdBy: 'admin1',
          createdAt: now,
          updatedAt: now,
        ),
        AnnouncementsEntity(
          id: '2',
          title: 'Mi segundo anuncio',
          description: 'Descripción de mi segundo anuncio',
          mainImage: 'image3.jpg',
          body: 'Contenido completo del segundo anuncio...',
          secondaryImage: 'image4.jpg',
          publicationDate: now,
          createdBy: 'admin1',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      when(() => mockRepository.getMyAnnouncements())
          .thenAnswer((_) async => expectedAnnouncements);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedAnnouncements));
      expect(result.length, equals(2));
      verify(() => mockRepository.getMyAnnouncements()).called(1);
    });

    test('debería retornar lista vacía cuando no tengo anuncios', () async {
      // Arrange
      when(() => mockRepository.getMyAnnouncements())
          .thenAnswer((_) async => <AnnouncementsEntity>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getMyAnnouncements()).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      when(() => mockRepository.getMyAnnouncements())
          .thenThrow(Exception('Error del servidor'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(() => mockRepository.getMyAnnouncements()).called(1);
    });
  });
}
