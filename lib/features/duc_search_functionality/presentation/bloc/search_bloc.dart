import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/services/search_cache_service.dart';
import '../../domain/repositories/search_repository.dart';
import '../../../../shared/models/borrow_card.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../domain/entities/search_query.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;
  final SearchCacheService _cacheService;

  SearchBloc({
    required SearchRepository repository,
    required SearchCacheService cacheService,
  })  : _repository = repository,
        _cacheService = cacheService,
        super(const SearchInitial()) {
    // Search by borrower name với debounce
    on<SearchByBorrowerNameEvent>(
      _onSearchByBorrowerName,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );

    // Search by book name với debounce
    on<SearchByBookNameEvent>(
      _onSearchByBookName,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );

    // Advanced search
    on<ApplyAdvancedSearchEvent>(_onApplyAdvancedSearch);

    // Clear search
    on<ClearSearchEvent>(_onClearSearch);

    // Load suggestions với debounce
    on<LoadSuggestionsEvent>(
      _onLoadSuggestions,
      transformer: _debounce(const Duration(milliseconds: 200)),
    );

    // Search history
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<SaveSearchHistoryEvent>(_onSaveSearchHistory);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
  }

  /// Debounce transformer
  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) {
      return events.debounceTime(duration).switchMap(mapper);
    };
  }

  Future<void> _onSearchByBorrowerName(
    SearchByBorrowerNameEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    // Check cache first
    final cached = _cacheService.getCachedResults(event.query);
    if (cached != null) {
      emit(SearchLoaded(
        results: cached,
        query: event.query,
        totalResults: cached.length,
        fromCache: true,
      ));
      return;
    }

    // Search from repository
    final result = await _repository.searchByBorrowerName(event.query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (results) {
        if (results.isEmpty) {
          emit(SearchEmpty(event.query));
        } else {
          // Cache results
          _cacheService.cacheResults(event.query, results);

          emit(SearchLoaded(
            results: results,
            query: event.query,
            totalResults: results.length,
            fromCache: false,
          ));

          // Save to history
          add(SaveSearchHistoryEvent(event.query));
        }
      },
    );
  }

  Future<void> _onSearchByBookName(
    SearchByBookNameEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    // Check cache
    final cached = _cacheService.getCachedResults(event.query);
    if (cached != null) {
      emit(SearchLoaded(
        results: cached,
        query: event.query,
        totalResults: cached.length,
        fromCache: true,
      ));
      return;
    }

    final result = await _repository.searchByBookName(event.query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (results) {
        if (results.isEmpty) {
          emit(SearchEmpty(event.query));
        } else {
          _cacheService.cacheResults(event.query, results);

          emit(SearchLoaded(
            results: results,
            query: event.query,
            totalResults: results.length,
            fromCache: false,
          ));

          // Save to history
          add(SaveSearchHistoryEvent(event.query));
        }
      },
    );
  }

  Future<void> _onApplyAdvancedSearch(
    ApplyAdvancedSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    final result = await _repository.advancedSearch(event.query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (results) {
        final queryLabel = _formatAdvancedQuery(event.query);

        if (results.isEmpty) {
          emit(SearchEmpty(queryLabel));
        } else {
          emit(SearchLoaded(
            results: results,
            query: queryLabel,
            totalResults: results.length,
            fromCache: false,
          ));
        }
      },
    );
  }

  String _formatAdvancedQuery(SearchQuery q) {
    final parts = <String>[];

    if (q.borrowerName != null && q.borrowerName!.trim().isNotEmpty) {
      parts.add('Tên: "${q.borrowerName!.trim()}"');
    }
    if (q.bookName != null && q.bookName!.trim().isNotEmpty) {
      parts.add('Sách: "${q.bookName!.trim()}"');
    }
    if (q.borrowerClass != null && q.borrowerClass!.trim().isNotEmpty) {
      parts.add('Lớp: "${q.borrowerClass!.trim()}"');
    }
    if (q.status != null) {
      parts.add('Trạng thái: ${_getStatusText(q.status)}');
    }
    if (q.borrowDateFrom != null || q.borrowDateTo != null) {
      final from = q.borrowDateFrom != null ? q.borrowDateFrom!.toIso8601String().split('T').first : '';
      final to = q.borrowDateTo != null ? q.borrowDateTo!.toIso8601String().split('T').first : '';
      parts.add('Ngày mượn: ${from.isNotEmpty ? from : '...'} - ${to.isNotEmpty ? to : '...'}');
    }
    if (q.returnDateFrom != null || q.returnDateTo != null) {
      final from = q.returnDateFrom != null ? q.returnDateFrom!.toIso8601String().split('T').first : '';
      final to = q.returnDateTo != null ? q.returnDateTo!.toIso8601String().split('T').first : '';
      parts.add('Ngày trả: ${from.isNotEmpty ? from : '...'} - ${to.isNotEmpty ? to : '...'}');
    }

    // Prepend type label (Vietnamese) for clarity
    parts.insert(0, 'Loại: ${q.type.toVietnamese()}');

    if (parts.isEmpty) return 'Tìm kiếm nâng cao';
    return parts.join(', ');
  }

  String _getStatusText(BorrowStatus? status) {
    switch (status) {
      case BorrowStatus.borrowed:
        return 'Đang mượn';
      case BorrowStatus.returned:
        return 'Đã trả';
      case BorrowStatus.overdue:
        return 'Quá hạn';
      default:
        return 'Không xác định';
    }
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchInitial());
  }

  Future<void> _onLoadSuggestions(
    LoadSuggestionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.prefix.trim().isEmpty) {
      emit(const SearchSuggestionsLoaded([]));
      return;
    }

    final result = event.type == SuggestionType.borrower
        ? await _repository.getBorrowerSuggestions(event.prefix)
        : await _repository.getBookSuggestions(event.prefix);

    result.fold(
      (failure) => emit(const SearchSuggestionsLoaded([])),
      (suggestions) => emit(SearchSuggestionsLoaded(suggestions)),
    );
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final result = await _repository.getSearchHistory();

    result.fold(
      (failure) => emit(const SearchHistoryLoaded([])),
      (history) => emit(SearchHistoryLoaded(history)),
    );
  }

  Future<void> _onSaveSearchHistory(
    SaveSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    await _repository.saveSearchHistory(event.query);
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    final result = await _repository.clearSearchHistory();

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (_) => emit(const SearchHistoryLoaded([])),
    );
  }
}
