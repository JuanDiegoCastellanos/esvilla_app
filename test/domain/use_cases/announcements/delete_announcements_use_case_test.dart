import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';
import 'package:esvilla_app/domain/use_cases/announcements/delete_announcements_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnnouncementsRepository extends Mock implements AnnouncementsRepository {}

void main() {
  late DeleteAnnouncementsUseCase useCase;
  late MockAnnouncementsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnnouncementsRepository();
    useCase = DeleteAnnouncementsUseCase(mockRepository);
  });

  group('DeleteAnnouncementsUseCase', () {
    test('debería eliminar un anuncio exitosamente', () async {
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

      when(() => mockRepository.delete(announcementId))
          .thenAnswer((_) async => expectedAnnouncement);

      // Act
      final result = await useCase.call(announcementId);

      // Assert
      expect(result, equals(expectedAnnouncement));
      verify(() => mockRepository.delete(announcementId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const announcementId = '999';

      when(() => mockRepository.delete(announcementId))
          .thenThrow(Exception('Anuncio no encontrado'));

      // Act & Assert
      expect(() => useCase.call(announcementId), throwsException);
      verify(() => mockRepository.delete(announcementId)).called(1);
    });
  });
}
