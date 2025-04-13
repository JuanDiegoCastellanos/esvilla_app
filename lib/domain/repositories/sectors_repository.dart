import 'package:esvilla_app/domain/entities/sectors/create_sector_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';
import 'package:esvilla_app/domain/repositories/generic_repository.dart';

abstract class SectorsRepository implements GenericRepository<SectorEntity, CreateSectorRequestEntity, UpdateSectorRequestEntity>{

}