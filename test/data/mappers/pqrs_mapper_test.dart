import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/data/mappers/pqrs/pqrs_mapper.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_model.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PqrsMapper toEntity/toModel y campos especiales', () {
    final now = DateTime.now();
    final model = PqrsModel(
      id: 'p1',
      subject: 's',
      description: 'd',
      radicadorId: 'u1',
      radicadorName: 'Juan',
      radicadorPhone: '300',
      radicadorEmail: 'a@b.com',
      radicadorDocument: 'CC',
      status: PqrsStatusEnum.pendiente,
      createdAt: now,
      updatedAt: now,
      closureDate: null,
      resolucion: 'res',
      resolverName: 'admin',
    );
    final e = PqrsMapper.toEntity(model);
    expect(e.id, 'p1');
    expect(e.resolution, 'res');
    expect(e.resolverName, 'admin');

    final back = PqrsMapper.toModel(e);
    expect(back.resolucion, 'res');
    expect(back.resolverName, 'admin');

    final listE = PqrsMapper.toEntityList([model]);
    expect(listE.first.subject, 's');
    final listM = PqrsMapper.toModelList(listE);
    expect(listM.first.description, 'd');
  });
}
