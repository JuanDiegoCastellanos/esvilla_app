import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';
import 'package:esvilla_app/domain/use_cases/announcements/get_all_announcements_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnnouncementsRepository extends Mock implements AnnouncementsRepository {}

void main() {
  late GetAllAnnouncementsUseCase useCase;
  late MockAnnouncementsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnnouncementsRepository();
    useCase = GetAllAnnouncementsUseCase(mockRepository);
  });

  group('GetAllAnnouncementsUseCase', () {
    test('debería obtener todos los anuncios exitosamente', () async {
      // Arrange
      final now = DateTime.now();
      final expectedAnnouncements = [
        AnnouncementsEntity(
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
        ),
        AnnouncementsEntity(
          id: '2',
          title: 'Mantenimiento programado',
          description: 'Se realizará mantenimiento el próximo fin de semana',
          mainImage: 'image3.jpg',
          body: 'Contenido completo del anuncio de mantenimiento...',
          secondaryImage: 'image4.jpg',
          publicationDate: now,
          createdBy: 'admin2',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      when(() => mockRepository.getAll())
          .thenAnswer((_) async => expectedAnnouncements);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedAnnouncements));
      expect(result.length, equals(2));
      verify(() => mockRepository.getAll()).called(1);
    });

    test('debería retornar lista vacía cuando no hay anuncios', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenAnswer((_) async => <AnnouncementsEntity>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getAll()).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenThrow(Exception('Error del servidor'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(() => mockRepository.getAll()).called(1);
    });
  });
}
