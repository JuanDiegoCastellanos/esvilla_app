import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';
import 'package:esvilla_app/domain/use_cases/announcements/get_announcements_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnnouncementsRepository extends Mock implements AnnouncementsRepository {}

void main() {
  late GetAnnouncementsByIdUseCase useCase;
  late MockAnnouncementsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnnouncementsRepository();
    useCase = GetAnnouncementsByIdUseCase(mockRepository);
  });

  group('GetAnnouncementsByIdUseCase', () {
    test('debería obtener un anuncio por ID exitosamente', () async {
      // Arrange
      const announcementId = '1';
      final now = DateTime.now();
      final expectedAnnouncement = AnnouncementsEntity(
        id: announcementId,
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

      when(() => mockRepository.getById(announcementId))
          .thenAnswer((_) async => expectedAnnouncement);

      // Act
      final result = await useCase.call(announcementId);

      // Assert
      expect(result, equals(expectedAnnouncement));
      verify(() => mockRepository.getById(announcementId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const announcementId = '999';

      when(() => mockRepository.getById(announcementId))
          .thenThrow(Exception('Anuncio no encontrado'));

      // Act & Assert
      expect(() => useCase.call(announcementId), throwsException);
      verify(() => mockRepository.getById(announcementId)).called(1);
    });
  });
}
