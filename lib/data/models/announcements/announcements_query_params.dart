import 'package:esvilla_app/core/config/app_logger.dart';

class AnnouncementsQueryParams {
  final int? page;
  final int? limit;
  final String? sortBy;
  final String? sortOrder;
  final DateTime? startDate;
  final DateTime? endDate;

  AnnouncementsQueryParams(
      {this.page,
      this.limit,
      this.sortBy,
      this.sortOrder,
      this.startDate,
      this.endDate});


  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
    };
    AppLogger.i('Query params: $map');
    return map;
  }
}
