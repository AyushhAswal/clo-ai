import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(currentPage: 0));

  void nextPage() {
    if (state.currentPage < state.totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    } else {
      emit(state.copyWith(isCompleted: true));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void setPage(int page) {
    if (page >= 0 && page < state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  void skipToLast() {
    emit(state.copyWith(currentPage: state.totalPages - 1));
  }
}
