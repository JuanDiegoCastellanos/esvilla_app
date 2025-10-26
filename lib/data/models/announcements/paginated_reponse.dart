import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({required this.data, required this.meta});

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    try {
      final listData = json['data'];
      if (listData == null) {
        throw AppException(message: 'Data field is null');
      }

      final List<dynamic> dataList = listData is List ? listData : [];

      final response = PaginatedResponse(
        data:
            dataList.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
        meta: PaginationMeta.fromJson(json['meta']),
      );
      return response;
    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
  }
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    try {
      final response = PaginationMeta(
        page: json['page'] is String ? int.parse(json['page']) : json['page'],
        limit:
            json['limit'] is String ? int.parse(json['limit']) : json['limit'],
        total:
            json['total'] is String ? int.parse(json['total']) : json['total'],
        totalPages: json['totalPages'] is String
            ? int.parse(json['totalPages'])
            : json['totalPages'],
        hasNextPage: json['hasNextPage'],
        hasPrevPage: json['hasPrevPage'],
      );
      return response;
    } catch (e) {
      AppLogger.e(e.toString());
      throw AppException(message: e.toString());
    }
  }
}
