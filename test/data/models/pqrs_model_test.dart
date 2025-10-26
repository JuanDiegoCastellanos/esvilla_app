import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PqrsModel.fromMap', () {
    test('parsea correctamente un JSON válido', () {
      final json = {
        "_id": "1",
        "asunto": "Prueba",
        "descripcion": "Desc",
        "idRadicador": "u1",
        "nombreRadicador": "User 1",
        "telefonoRadicador": "123",
        "emailRadicador": "a@b.com",
        "documentoRadicador": "CC",
        "estado": "pendiente",
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      };
      final model = PqrsModel.fromMap(json);
      expect(model.id, '1');
      expect(model.subject, 'Prueba');
      expect(model.status, PqrsStatusEnum.pendiente);
    });

    test('mapea estados conocidos a enum', () {
      expect(
        PqrsModel.fromMap({
          "_id": "1",
          "asunto": "x",
          "descripcion": "x",
          "idRadicador": "x",
          "nombreRadicador": "x",
          "telefonoRadicador": "x",
          "emailRadicador": "x",
          "documentoRadicador": "x",
          "estado": "en proceso",
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        }).status,
        PqrsStatusEnum.EnProceso,
      );
      expect(
        PqrsModel.fromMap({
          "_id": "1",
          "asunto": "x",
          "descripcion": "x",
          "idRadicador": "x",
          "nombreRadicador": "x",
          "telefonoRadicador": "x",
          "emailRadicador": "x",
          "documentoRadicador": "x",
          "estado": "solucionado",
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        }).status,
        PqrsStatusEnum.solucionado,
      );
    });

    test('fechas inválidas no rompen el parseo', () {
      final model = PqrsModel.fromMap({
        "_id": "1",
        "asunto": "x",
        "descripcion": "x",
        "idRadicador": "x",
        "nombreRadicador": "x",
        "telefonoRadicador": "x",
        "emailRadicador": "x",
        "documentoRadicador": "x",
        "estado": "pendiente",
        "createdAt": "invalid",
        "updatedAt": "invalid",
      });
      expect(model.id, '1');
      expect(model.createdAt, isA<DateTime>());
      expect(model.updatedAt, isA<DateTime>());
    });
  });
}
