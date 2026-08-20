import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_exception.dart';
import '../data/repositories/relationship_repository.dart';
import 'my_circle_state.dart';

class MyCircleCubit extends Cubit<MyCircleState> {
  final RelationshipRepository repository;

  MyCircleCubit({RelationshipRepository? repository})
    : repository = repository ?? ApiRelationshipRepository(),
      super(const MyCircleState()) {
    loadRelationships();
  }

  Future<void> loadRelationships() async {
    emit(state.copyWith(status: MyCircleStatus.loading, errorMessage: null));
    try {
      final items = await repository.getRelationships();
      emit(state.copyWith(status: MyCircleStatus.loaded, relationships: items));
    } on ApiException catch (e) {
      emit(
        state.copyWith(status: MyCircleStatus.error, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MyCircleStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleSearch() {
    final newIsSearching = !state.isSearching;
    emit(
      state.copyWith(
        isSearching: newIsSearching,
        searchQuery: newIsSearching ? state.searchQuery : '',
      ),
    );
  }
}
