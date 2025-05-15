import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/use_cases/announcements/get_all_with_pagination_use_case.dart';
import 'package:esvilla_app/presentation/providers/announcements/get_all_with_pagination_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnouncementsListStateNotifierProvider
    extends StateNotifier<AsyncValue<PaginatedResponse<AnnouncementsEntity>>> {
  final GetAllWithPaginationUseCase getAllWithPaginationUseCase;
  int _currentPage = 1;
  final int _limit = 20;
  String _sortBy = 'createdAt';
  String _sortOrder = 'desc';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  AnnouncementsListStateNotifierProvider(this.getAllWithPaginationUseCase)
      : super(const AsyncValue.loading()) {
    loadInitialNews();
  }

  Future<void> loadInitialNews() async {
    _currentPage = 1;
    await _loadNews();
  }

  Future<void> loadMoreNews() async {
    if (state.value?.meta.hasNextPage == true && !_isLoading) {
      _currentPage++;
      await _loadNews(append: true);
    }
  }

  Future<void> _loadNews({bool append = false}) async {
    _isLoading = true;

    try {
      state = const AsyncValue.loading();

      final queryParams = AnnouncementsQueryParams(
        page: _currentPage,
        limit: _limit,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        startDate: _startDate,
        endDate: _endDate,
      );

      final response = await getAllWithPaginationUseCase.call(queryParams);

      if (append && state.value != null) {
        // Append new data to existing data
        final currentData = List<AnnouncementsEntity>.from(state.value!.data);
        final newData = [...currentData, ...response.data];
        final newResponse = PaginatedResponse<AnnouncementsEntity>(
            data: newData, meta: response.meta);
        state = AsyncValue.data(newResponse);
      } else {
        state = AsyncValue.data(response);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isLoading = false;
    }
  }

  void setSortBy(String sortBy, String sortOrder) {
    _sortBy = sortBy;
    _sortOrder = sortOrder;
    loadInitialNews();
  }

  void setDateFilter(DateTime? startDate, DateTime? endDate) {
    _startDate = startDate;
    _endDate = endDate;
    loadInitialNews();
  }
  
  Future<void> clearFilters() async {
    _sortBy = 'createdAt';
    _sortOrder = 'desc';
    _startDate = null;
    _endDate = null;
    await loadInitialNews();
  }
}

final announcementsListControllerProvider = StateNotifierProvider<
    AnnouncementsListStateNotifierProvider,
    AsyncValue<PaginatedResponse<AnnouncementsEntity>>>((ref) {
  final newsService = ref.watch(getAllWithPaginationUseCaseProvider);
  return AnnouncementsListStateNotifierProvider(newsService);
});

final sortOrderProvider = StateProvider<bool>((ref) => false);

final dateProvider = StateProvider<Map<String,DateTime>>((ref) => {
  'startDate': DateTime.now().subtract(Duration(days: 7)),
  'endDate': DateTime.now(),
}); 


