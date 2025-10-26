import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/create_announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';
import 'package:esvilla_app/domain/use_cases/announcements/create_announcements_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnnouncementsRepository extends Mock implements AnnouncementsRepository {}

void main() {
  late CreateAnnouncementsUseCase useCase;
  late MockAnnouncementsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnnouncementsRepository();
    useCase = CreateAnnouncementsUseCase(mockRepository);
  });

  group('CreateAnnouncementsUseCase', () {
    test('debería crear un anuncio exitosamente', () async {
      // Arrange
      final now = DateTime.now();
      final request = CreateAnnouncementsRequestEntity(
        title: 'Nuevo servicio disponible',
        description: 'Se ha habilitado un nuevo servicio para la comunidad',
        mainImage: 'image1.jpg',
        body: 'Contenido completo del anuncio...',
        secondaryImage: 'image2.jpg',
        publicationDate: now,
      );

      final expectedAnnouncement = AnnouncementsEntity(
        id: '1',
        title: 'Nuevo servicio disponible',
        description: 'Se ha habilitado un nuevo servicio para la comunidad',
        mainImage: 'image1.jpg',
        body: 'Contenido completo del anuncio...',
        secondaryImage: 'image2.jpg',
        publicationDate: now,
        createdBy: 'admin1',
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockRepository.add(request))
          .thenAnswer((_) async => expectedAnnouncement);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedAnnouncement));
      verify(() => mockRepository.add(request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      final now = DateTime.now();
      final request = CreateAnnouncementsRequestEntity(
        title: 'Nuevo servicio disponible',
        description: 'Se ha habilitado un nuevo servicio para la comunidad',
        mainImage: 'image1.jpg',
        body: 'Contenido completo del anuncio...',
        secondaryImage: 'image2.jpg',
        publicationDate: now,
      );

      when(() => mockRepository.add(request))
          .thenThrow(Exception('Error al crear anuncio'));

      // Act & Assert
      expect(() => useCase.call(request), throwsException);
      verify(() => mockRepository.add(request)).called(1);
    });
  });
}
